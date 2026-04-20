# nixos-desktop
nixos configuration for my personal desktop

to reproduce in nixOS:
```bash
sudo git clone https://github.com/rezadoz/nixos-desktop.git /tmp/nixos-desktop
sudo cp -r /tmp/nixos-desktop/. /etc/nixos/
rm -rf /tmp/nixos-desktp[/
sudo nixos-rebuild switch --flake /etc/nixos#enterprise
```
