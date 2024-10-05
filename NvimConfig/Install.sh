#install dependencies:
sudo apt update
sudo apt upgrade -y
sudo apt install -y bear tmux gdb build-essential git gcc vim clang lldb clangd gcc-multilib ddd sasm nasm
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
sudo rm -rf ~/.config/nvim
sudo cp -R nvim ~/.config
sudo echo 'alias vim="nvim"' >> ~/.bashrc
