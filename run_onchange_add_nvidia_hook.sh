#!/usr/bin/env sh

# Taken from https://wiki.archlinux.org/title/NVIDIA#pacman_hook
# This script will automatically add this hook to pacman

echo "Installing nvidia hook for pacman"
sudo tee /etc/pacman.d/hooks/nvidia.hook <<EOF 
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux

[Action]
Description=Updating NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case \$trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF
