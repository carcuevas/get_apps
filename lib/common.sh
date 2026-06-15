# common.sh — shared functions for getapp
# Sourced by getapp; not executed directly.

# ── Helpers ───────────────────────────────────────────────────────────────────

die()  { echo "Error: $*" >&2; exit 1; }
log()  { echo "  $*"; }
dlog() { echo "  [dry-run] $*"; }

# ── Platform detection ────────────────────────────────────────────────────────

detect_platform() {
    case "$(uname -s)" in
        Linux)  OS=linux  ;;
        Darwin) OS=macos  ;;
        *)      die "Unsupported OS: $(uname -s)" ;;
    esac

    case "$(uname -m)" in
        x86_64)        ARCH=amd64 ;;
        aarch64|arm64) ARCH=arm64 ;;
        *)             die "Unsupported architecture: $(uname -m)" ;;
    esac
}

set_install_paths() {
    if [ "$OS" = "linux" ]; then
        INSTALL_BASE="/opt"
        BIN_DIR="/usr/local/bin"
        DESKTOP_DIR="/usr/share/applications"
    else
        INSTALL_BASE="/usr/local/opt"
        BIN_DIR="/usr/local/bin"
        DESKTOP_DIR=""
    fi
}

# ── Download ──────────────────────────────────────────────────────────────────

download() {
    local url="$1" dest="$2"
    if [ "$DRY_RUN" = "true" ]; then
        dlog "Download: ${url}"
        dlog "      to: ${dest}"
        return
    fi
    if command -v wget &>/dev/null; then
        wget -q --show-progress -O "$dest" "$url" || die "Download failed: $url"
    elif command -v curl &>/dev/null; then
        curl -L --progress-bar -o "$dest" "$url"   || die "Download failed: $url"
    else
        die "Neither wget nor curl found. Install one of them first."
    fi
}

# ── Extraction ────────────────────────────────────────────────────────────────

extract_archive() {
    local file="$1" dest="$2"
    [ "$DRY_RUN" = "true" ] && { dlog "Extract: $file → $dest"; return; }
    mkdir -p "$dest"
    case "$file" in
        *.tar.gz|*.tgz) tar -xzf "$file" -C "$dest" || die "Failed to extract $file" ;;
        *.zip)           unzip -q  "$file" -d "$dest" || die "Failed to extract $file" ;;
        *)               die "Unknown archive format: $file" ;;
    esac
}

# ── Filesystem ────────────────────────────────────────────────────────────────

make_symlink() {
    local src="$1" dest="$2"
    [ "$DRY_RUN" = "true" ] && { dlog "Symlink: $dest → $src"; return; }
    ln -sf "$src" "$dest"
}

install_desktop_entry() {
    [ "$OS" != "linux" ]                    && return
    [ "${NEEDS_DESKTOP:-false}" = "false" ] && return
    [ -z "${DESKTOP_DIR:-}" ]               && return

    if [ "$DRY_RUN" = "true" ]; then
        dlog "Desktop: ${DESKTOP_DIR}/${PKG}.desktop"
        return
    fi

    if [ -f "${LIB_DIR}/${PKG}.desktop" ]; then
        cp "${LIB_DIR}/${PKG}.desktop" "${DESKTOP_DIR}/"
    else
        sed "s/_APP_/${PKG}/g" < "${LIB_DIR}/_APP_.desktop" > "${DESKTOP_DIR}/${PKG}.desktop"
    fi
    [ -f "${LIB_DIR}/icons/${PKG}.png" ] && cp "${LIB_DIR}/icons/${PKG}.png" "${DEST_DIR}/icon.png"
}

set_chrome_sandbox() {
    [ "${NEEDS_CHROME_SANDBOX:-false}" = "false" ] && return
    if [ "$DRY_RUN" = "true" ]; then
        dlog "Sandbox: chown root + chmod 4755 ${DEST_DIR}/chrome-sandbox"
        return
    fi
    chown root: "${DEST_DIR}/chrome-sandbox"
    chmod 4755  "${DEST_DIR}/chrome-sandbox"
}

# ── Version helpers ───────────────────────────────────────────────────────────

gh_latest() {
    local owner="$1" repo="$2"
    curl -s "https://api.github.com/repos/${owner}/${repo}/releases/latest" \
        | grep '"tag_name"' | head -1 | cut -d'"' -f4 | sed 's/^v//'
}

hashicorp_latest() {
    local pkg="$1"
    curl -s "https://checkpoint-api.hashicorp.com/v1/check/${pkg}" \
        | grep -o '"current_version":"[^"]*"' | cut -d'"' -f4
}

# ── App config reset (prevents leaking between configs in update_all) ─────────

reset_app_config() {
    unset PKG EXEC_FILE ARCHIVE_FORMAT VERSIONED NEEDS_DESKTOP NEEDS_CHROME_SANDBOX
    unset -f get_latest 2>/dev/null || true
    unset -f url_linux_amd64 url_linux_arm64 url_macos_amd64 url_macos_arm64 2>/dev/null || true
    unset -f post_extract post_install 2>/dev/null || true
}

# ── Main install orchestrator ─────────────────────────────────────────────────

install_app() {
    # Resolve version
    if [ -z "$VERSION" ] && declare -f get_latest &>/dev/null; then
        log "Fetching latest version..."
        VERSION=$(get_latest)
        [ -z "$VERSION" ] && die "Could not determine latest version for ${APP}."
        log "Latest: ${VERSION}"
    fi

    # If still no version and this app requires one, abort
    if [ -z "$VERSION" ] && [ "${VERSIONED:-true}" = "true" ]; then
        die "${APP} requires a version. Use: getapp ${APP} -v VERSION"
    fi

    # Build platform URL
    local url_func="url_${OS}_${ARCH}"
    declare -f "$url_func" &>/dev/null || die "${APP} is not available for ${OS}/${ARCH}."
    local SRC_URL
    SRC_URL=$($url_func)

    # Destination directory
    if [ "${VERSIONED:-true}" = "true" ] && [ -n "$VERSION" ]; then
        DEST_DIR="${INSTALL_BASE}/${PKG}_${VERSION}"
    else
        DEST_DIR="${INSTALL_BASE}/${PKG}"
    fi

    local fmt="${ARCHIVE_FORMAT:-tar.gz}"
    local TMP_ARCHIVE="/tmp/${PKG}_${VERSION:-latest}.${fmt}"
    local TMP_EXTRACT="/tmp/${PKG}_extract_$$"

    # Dry-run: print plan and return
    if [ "$DRY_RUN" = "true" ]; then
        echo ""
        printf "  %-14s %s\n" "App:"      "${APP}"
        printf "  %-14s %s\n" "Platform:" "${OS}/${ARCH}"
        printf "  %-14s %s\n" "Version:"  "${VERSION:-latest}"
        printf "  %-14s %s\n" "URL:"      "${SRC_URL}"
        printf "  %-14s %s\n" "Install:"  "${DEST_DIR}"
        printf "  %-14s %s\n" "Binary:"   "${BIN_DIR}/${PKG}"
        [ "${NEEDS_DESKTOP:-false}"        = "true" ] && printf "  %-14s %s\n" "Desktop:"  "${DESKTOP_DIR:-N/A}/${PKG}.desktop"
        [ "${NEEDS_CHROME_SANDBOX:-false}" = "true" ] && printf "  %-14s %s\n" "Sandbox:"  "chrome-sandbox (setuid root)"
        echo ""
        return
    fi

    log "Installing ${APP} ${VERSION:-latest} (${OS}/${ARCH})..."

    # AppImage — place directly, no extraction
    if [ "$fmt" = "appimage" ]; then
        mkdir -p "$DEST_DIR"
        download "$SRC_URL" "${DEST_DIR}/${EXEC_FILE}"
        chmod +x "${DEST_DIR}/${EXEC_FILE}"
    else
        mkdir -p "$TMP_EXTRACT"
        download "$SRC_URL" "$TMP_ARCHIVE"
        extract_archive "$TMP_ARCHIVE" "$TMP_EXTRACT"
        rm -f "$TMP_ARCHIVE"

        if declare -f post_extract &>/dev/null; then
            mkdir -p "$DEST_DIR"
            post_extract "$TMP_EXTRACT" "$DEST_DIR"
        else
            # Single extracted subdirectory → rename it to DEST_DIR
            local ndirs
            ndirs=$(find "$TMP_EXTRACT" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')
            if [ "$ndirs" -eq 1 ]; then
                local subdir
                subdir=$(find "$TMP_EXTRACT" -maxdepth 1 -mindepth 1 -type d)
                rm -rf "$DEST_DIR"
                mv "$subdir" "$DEST_DIR"
            else
                # Multiple files (e.g. single binary in zip) — move all into DEST_DIR
                rm -rf "$DEST_DIR"
                mkdir -p "$DEST_DIR"
                mv "$TMP_EXTRACT"/* "$DEST_DIR/"
            fi
        fi
        rm -rf "$TMP_EXTRACT"
    fi

    # Versioned symlink: /opt/terraform → /opt/terraform_1.8.0
    if [ "${VERSIONED:-true}" = "true" ] && [ -n "$VERSION" ]; then
        rm -f "${INSTALL_BASE}/${PKG}"
        make_symlink "$DEST_DIR" "${INSTALL_BASE}/${PKG}"
    fi

    make_symlink "${INSTALL_BASE}/${PKG}/${EXEC_FILE}" "${BIN_DIR}/${PKG}"

    install_desktop_entry
    set_chrome_sandbox

    # Per-app post-install hook (e.g. extra desktop files)
    declare -f post_install &>/dev/null && post_install

    echo "Done. ${APP} ${VERSION:-latest} installed successfully."
}

# ── List / update ─────────────────────────────────────────────────────────────

list_apps() {
    echo "Available apps:"
    for f in "${APPS_DIR}"/*.sh; do
        echo "  - $(basename "$f" .sh)"
    done
}

update_all() {
    for f in "${APPS_DIR}"/*.sh; do
        APP=$(basename "$f" .sh)
        VERSION=""
        reset_app_config
        # shellcheck source=/dev/null
        source "$f"
        log "Updating ${APP}..."
        detect_platform
        set_install_paths
        install_app
    done
}
