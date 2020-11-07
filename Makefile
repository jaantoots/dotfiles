.PHONY: minimal default graphical
minimal:
	stow -v --adopt git shell vim
	git checkout .

default: minimal
	stow -v --adopt mail gpg systemd
	git checkout .

graphical: default
	stow -v --adopt desktop xorg
	git checkout .

dotfiles:
	git clone --recursive https://github.com/jaantoots/dotfiles.git

.PHONY: debian debian-gpu conda
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

CONDA_FILE = Miniconda3-py38_4.8.3-Linux-x86_64.sh
CONDA_SHA256 = 879457af6a0bf5b34b48c12de31d4df0ee2f06a8e68768e5758c3293b2daf688
conda:
	wget https://repo.anaconda.com/miniconda/$(CONDA_FILE)
	echo "$(CONDA_SHA256)  $(CONDA_FILE)" | sha256sum -c
	bash $(CONDA_FILE) -b
