.PHONY: minimal default graphical
minimal:
	stow -v --adopt git shell vim
	git checkout .

default: minimal
	stow -v --adopt neomutt systemd
	git checkout .

graphical: default
	stow -v --adopt desktop xorg
	git checkout .

dotfiles:
	git clone --recursive https://github.com/jaantoots/dotfiles.git

.PHONY: debian debian-gpu
debian:
	sudo apt-get -y update
	sudo apt-get -y upgrade -V
	sudo apt-get -y install htop zsh zsh-syntax-highlighting zsh-autosuggestions rsync wget pciutils unzip tmux jq awscli git stow
	sudo chsh -s/bin/zsh $(USER)
	sudo wget --backups=1 -O /etc/zsh/zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

debian-gpu: debian
	sudo sed -i 's/main$$/\0 contrib non-free/' /etc/apt/sources.list
	sudo apt-get -y update
	sudo apt-get -y install linux-headers-cloud-amd64
	sudo apt-get -y -t buster-backports install nvidia-driver nvidia-smi nvidia-cuda-toolkit nvidia-cuda-dev

.PHONY: ml
ml: debian-gpu dotfiles
	make -C dotfiles minimal
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b
	./miniconda3/condabin/conda init zsh
