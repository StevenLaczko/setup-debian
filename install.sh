. ./config.sh

curdir="$(pwd)"

cp "$curdir/.bashrc" "$HOME"
source "$HOME/.bashrc"
sudo cp "$curdir/rundwm" /usr/local/bin

# Apt update stuff
sudo apt upgrade
sudo apt update -y


if [[ $* != --no-tmux ]]; then
    # tmux conf
    sudo apt install tmux -y
    sudo apt-get install -f
    cp "$curdir/.tmux.conf" "$HOME"
    echo "Tmux installed"
fi

if [[ $* != --no-net ]]; then
    # Network stuff
    sudo apt install network-manager -y
    sudo apt-get install -f
    echo -e "\n\nrename $wifi=wifi\nauto wifi\niface wifi inet dhcp\n\nrename $ethernet=eth\niface eth inet dhcp" >> /etc/network/interfaces
    sed -i 's/managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf

    echo -e "Network set up.\nSet up wifi with nmtui"
fi

if [[ $* != --no-dwm ]]; then
    # Install dwm
    sudo mkdir /src
    sudo apt install x11-common -y
    sudo apt-get install -f
    sudo git clone https://git.suckless.org/dwm /src/dwm
    git apply --directory=/src/dwm "$curdir/dwm-diff-file"
    cd /src/dwm
    make
    cd "$curdir"

    # Enable dwm in x11
    touch "$HOME/.xinitrc"
    echo -e "\n\nexec /usr/local/bin/rundwm" >> "$HOME/.xinitrc"
    echo "dwm installed"
fi

if [[ $* != --no-vim ]]; then
    # Install vim
    sudo apt install vim -y
    sudo apt-get install -f
    git clone git@github.com:StevenLaczko/vim-install.git
    sudo chmod +x "$curdir/vim-install/install.sh"
    exec "$curdir/vim-install/install.sh"
fi
