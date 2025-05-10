# My Dotfiles
Installing HyDE after minimal archinstall installs conflicting network managers which can cause disconnects. Run this to fix that
```bash
sudo systemctl disable --now iwd.service
sudo pacman -R iwd
sudo systemctl restart NetworkManager.service
```
Reboot after that

## Screenshots

![hyprdots](pr/1.png)
![hyprdots](pr/2.png)
![hyprdots](pr/3.png)
![hyprdots](pr/4.png)
