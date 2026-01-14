# get_apps

## Intro
This started when I was using Arch linux, and not trusting some AUR repos, so I got the files myself from the official repos (many times from the official github)  and so. Now even using other repos, I think
it is quite comfortable for me to use....

## How it works
It automatically fetches the pacakges with the specified version (1pasword/bitwarden are taking the latest version so no need to specify it), so for example if I want to get 
the last version of bitwarden, I just need to execute:

```
sudo get_bitwarden.sh 

```
And it will create the `/opt/bitwarden` and download there the packages, then after it will create the menu for desktop, and shortcut with the icon. 

For example if you want to get the Tidal Hi-Fi version 6.0.1, just run:

```
sudo get_tidal.sh 6.0.1

```

and that's it :) 

**NOTE:** The destination path I have is `/opt` it will create links in `/usr/local/bin` ... So don't forget to add the `export PATH=$PATH:/usr/local/bin` in your .profile/.bashrc/.zshrc :) 


## What software I have at the moment 
* 1password
* bitwarden  
* brave
* Darktable
* Drawio-Desktop
* Ferdium
* Logcli (From Grafana)
* Microsoft Visual Code
* Packer
* Postman
* Terraform
* Tidal hi-Fi for Linux
* WinBox (beta for linux)
