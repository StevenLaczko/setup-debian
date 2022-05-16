echo "Make sure you're connected to the internet before running this, ethernet's fine"
read line;

. ./config.sh

$curdir=$(pwd)

cp ./.bashrc $HOME
source $HOME/.bashrc
sudo cp ./rundwm /usr/local/bin

# Install stuff
sudo apt upgrade
sudo apt update -y
sudo apt install git vim x11-common tmux network-manager
sudo apt-get install -f

echo "https://github.com/gokcehan/lf"

# tmux conf
cp ./.tmux.conf $HOME
echo "Tmux installed"

# Network stuff
echo -e "\n\nrename $wifi=wifi\nauto wifi\niface wifi inet dhcp\n\nrename $ethernet=eth\niface eth inet dhcp" >> /etc/network/interfaces
sed -i 's/managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf

echo -e "Network set up.\nSet up wifi with nmtui"

# Install dwm
sudo mkdir /src
sudo git clone https://git.suckless.org/dwm /src/dwm
git apply --directory=/src/dwm ./dwm-diff-file
cd /src/dwm
make
cd $curdir

# Enable dwm in x11
touch ~/.xinitrc
echo -e "\n\nexec /usr/local/bin/rundwm" >> ~/.xinitrc
echo "dwm installed"

# Install vim
git clone git@github.com:StevenLaczko/vim-install.git
sudo chmod +x ./vim-install/install.sh
exec ./vim-install/install.sh

