DATA_DISK ?=

.PHONY: debian-gpu
debian-gpu:
	sudo apt-get -y update
	sudo apt-get -y upgrade -V
	sudo apt-get -y install htop zsh rsync wget pciutils unzip tmux jq awscli
	sudo sed -i 's/main$$/\0 contrib non-free/' /etc/apt/sources.list
	sudo apt-get -y update
	sudo apt-get -y install linux-headers-cloud-amd64
	sudo apt-get -y -t buster-backports install nvidia-driver nvidia-smi nvidia-cuda-toolkit nvidia-cuda-dev
ifdef DATA_DISK
	sudo mkdir /data
	echo "UUID=$(DATA_DISK) /data ext4 rw 0 0" | sudo tee -a /etc/fstab
	sudo mount -a
endif
	sudo chsh -s/bin/zsh jaan
	wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc	
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b
	./miniconda3/condabin/conda init zsh
