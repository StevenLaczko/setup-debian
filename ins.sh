#! /bin/bash
script_dir="$(pwd)"
echo "Installing for user $HOME"
echo "Make sure you're connected to the internet before running this, ethernet's fine"
read line;

. ./config.sh

cp "$script_dir/bashrc" "$HOME/.bashrc"
. "$HOME/.bashrc"
cp "$script_dir/rundwm" /usr/local/bin

has_param () {
	local term="$1"
	shift
	for arg; do
		if [[ $arg == "$term" ]]; then
			return 0
		fi
	done
	return 1
}


# Apt update stuff
if ! has_param '--no-apt' "$@"; then
	echo "$@"
	apt upgrade
	apt update -y
fi

if ! has_param '--no-tmux' "$@"; then
	# tmux conf
	echo "TMUX INSTALL"
	apt install tmux -y
	cp "$script_dir/tmux.conf" "$HOME/.tmux.conf"
	echo "Tmux installed"
fi

if ! has_param '--no-net' "$@"; then
	# Network stuff
	echo "NETWORKING INSTALL"
	read line;
	apt install network-manager -y
	echo -e "\n\nrename $wifi=wifi\nauto wifi\niface wifi inet dhcp\n\nrename $ethernet=eth\niface eth inet dhcp" >> /etc/network/interfaces
	sed -i 's/managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf

	echo -e "Network set up.\nSet up wifi with nmtui"
fi

if ! has_param '--no-dwm' "$@"; then
	# Install dwm
	echo "DWM INSTALL"
	read line;
	mkdir /src
	apt install xorg xinit x11-common libx11-dev libxinerama-dev libxft-dev -y
	cd /src/dwm
	git clone https://git.suckless.org/dwm /src/dwm
    chown -hR soda /src
	make
	git apply --directory=/src/dwm "./dwm-diff-file"
	make
	cd "$script_dir"

	# Enable dwm in x11
	touch "$HOME/.xinitrc"
	echo -e "\n\nexec /usr/local/bin/rundwm" >> "$HOME/.xinitrc"
	echo "dwm installed"
fi

if ! has_param '--no-vim' "$@"; then
	# Install vim
	echo "VIM INSTALL"
	apt install vim -y
	GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa" git clone git@github.com:StevenLaczko/vim-install.git
	chmod +x "$script_dir/vim-install/install.sh"
    nomdcat=""
    if has_param '--no-mdcat' "$@"; then
        nomdcat="--no-mdcat"
    fi
	HOME="$HOME" "$script_dir/vim-install/install.sh" "$nomdcat"
    rm -rf "$script_dir/vim-install"
fi

# Apt update stuff
apt-get install -f

if ! has_param '--no-apt' "$@"; then
	apt upgrade
	apt update -y
fi
