.PHONY: minimal default graphical
minimal:
	stow -v --adopt git shell vim
	git checkout .

default: minimal
	stow -v --adopt mail systemd
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

CONDA_FILE = Miniconda3-py38_4.8.2-Linux-x86_64.sh
CONDA_SHA256 = 5bbb193fd201ebe25f4aeb3c58ba83feced6a25982ef4afa86d5506c3656c142
conda:
	wget https://repo.anaconda.com/miniconda/$(CONDA_FILE)
	echo "$(CONDA_SHA256)  $(CONDA_FILE)" | sha256sum -c
	bash $(CONDA_FILE) -b
