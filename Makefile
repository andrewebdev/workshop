help:
	@echo "prepare - Set up our core system"
	@echo "add-udev-rules - Adds udev rules so that we can read/write to some unique usb devices"
	@echo "i3wm-install"
	@echo "polybar"
	@echo "ansible-install"
	@echo "neovim-install"
	@echo "nodejs-install"
	@echo "npm-update"
	@echo "docker-install"
	@echo "shell - Set up the shell"
	@echo "powerline-shell-new - Create a new config for powerline shell"
	@echo "devbox - My development toolbox for setting up custom project environments "
	@echo "sigrok - Install Sigrok Pulseview for signal analysis as well as required udev rules"
	@echo "dart - Install dart PPA and packages"
	@echo "flutter - Install flutter"
	@echo "postgres - Install postgres"
	@echo "mysql - Install mysql"


prepare:
	sudo apt-get update && sudo apt-get install -y \
		apt-transport-https \
		ca-certificates
	# Now install the rest as separate process
	sudo apt-get install -y \
		software-properties-common \
		curl \
		lsb-core \
		ruby \
		gem \
		git \
		gitg \
		build-essential \
		python-virtualenv \
		python-dev \
		python-pip \
		python-flake8 \
		python-jedi \
		python3-dev \
		python3-flake8 \
		python3-pip \
		flake8 \
		xclip \
		silversearcher-ag \
		ubuntu-restricted-extras \
		tmux
	# Install python requirements
	# todo
	# Install standard confined snaps
	sudo snap install \
		ufw \
		brave \
		discord \
		inkscape \
		lxd \
		mosquitto \
		whalebird
	# Install classic confined snaps
	sudo snap install --classic slack
	sudo snap install --classic snapcraft
	# Make sure we enable the firewall
	sudo ufw enable

add-udev-rules:
	sudo wget -O /etc/udev/rules.d/20-hw1.rules https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/20-hw1.rules
	sudo udevadm trigger
	sudo udevadm control --reload-rules

ansible-install:
	sudo apt-add-repository ppa:stable/ansible
	sudo apt-get update & apt-get upgrade
	sudo apt-get install -y ansible

neovim-install:
	sudo add-apt-repository ppa:neovim-ppa/stable
	sudo apt-get update & sudo apt-get install -y neovim
	sudo pip2 install neovim
	sudo pip3 install neovim
	# Ensure that some config folders exist
	mkdir -p ~/.config/nvim/autoload/
	# Use neovim as our default editor for various things
	sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	sudo update-alternatives --config vi
	sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	sudo update-alternatives --config vim
	sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
	sudo update-alternatives --config editor

nodejs-add-repo:
	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

nodejs-install: nodejs-add-repo
	sudo apt-get update & sudo apt-get install -y nodejs
	echo "If this is the first time installing nodejs, you should run, make npm-update, next."

npm-update:
	npm install npm@latest -g

i3wm-install:
	sudo apt-get install -y i3 i3blocks feh dunst rofi pavucontrol

polybar:
	sudo snap install polybar

docker-install:
	sudo addgroup --system docker
	sudo adduser ${USER} docker
	newgrp docker
	sudo snap install docker

devbox: docker-install
	# Install various tools used for my general dev environment
	sudo apt-get install -y virtualbox virtualbox-ext-pack
	sudo snap install go --classic
	sudo snap install kubectl --classic
	sudo snap install microk8s --classic
	# Install skaffold, a tool that makes developing with containers easier
	curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
	chmod +x skaffold
	sudo mv skaffold /usr/local/bin
	# Install bazel, a tool that builds anything
	sudo apt-get install -y openjdk-8-jdk
	echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
	curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
	sudo apt-get update && sudo apt-get install bazel
	# Install Kustomize
	go get sigs.k8s.io/kustomize

shell:
	sudo apt-get install neofetch
	pip install --user powerline-shell

powerline-shell-new:
	# powerline shell was newly installed, create config
	powerline-shell --generate-config > ~/.powerline-shell.json

sigrok:
	sudo apt-get install sigrok sigrok-cli sigrok-firmware-fx2lafw
	# Note Remember to run as root so that pulseview have access to USB
	# We won't install udev rules for now

dart:
	sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
	sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
	sudo apt-get update
	sudo apt-get install dart

flutter:
	echo "todo..."

postgres:
	sudo apt-get install -y \
		postgresql \
		postgresql-contrib \
		python-psycopg2 \
		pgadmin3 \
		libpcre3 \
		libpcre3-dev \
		zlib1g-dev \
		libpq-dev
	sudo service postgresql restart
	echo "\password postgres" | sudo -u postgres psql postgres

mysql:
	sudo apt-get install -y mysql-server mysql-client
	sudo mysql_secure_installation

