# Prerequisites
1. Enable these copr repos:
sudo dnf copr enable
- alternateved/eza
- solopasha/hyprland
- erikreider/swayosd 
- elxreno/jetbrains-mono-fonts
- maveonair/jetbrains-mono-nerd-fonts
- sudo dnf install fedora-workstation-repositories
- sudo dnf config-manager setopt google-chrome.enabled=1
2. Please make sure these packages are installed:
- fastfetch
- hyprland
- hyprpaper
- kitty
- nvim
- oh-my-posh
- rofi
- SDDM
- swayosd
- waybar
- eza
- python3-pip
- NetworkManager-tui

3. Install these pip packages
- pywal
4. Install jetbrains mono nerd font from here: https://www.nerdfonts.com/font-downloads

# Instructions
1. Clone this repository *with git submodules* into your user home directory.
    - `git clone --recurse-submodules`
2. Add execute permissions to `install.sh`
3. Run `install.sh`
All these configs will be symlinked into your `XDG_CONFIG_HOME` directory.
