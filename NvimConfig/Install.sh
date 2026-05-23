#install dependencies:
sudo apt update
sudo apt upgrade -y
sudo apt install -y bear tmux gdb build-essential git gcc vim clang lldb clangd gcc-multilib ddd sasm nasm
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
sudo tar -C /usr/local -xzf nvim-linux64.tar.gz --strip-components=1
rm nvim-linux64.tar.gz
sed -i '/nvim-linux-x86/d' ~/.bashrc
sed -i '/nvim-linux-x86/d' ~/.zshrc
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.zshrc
# I now use this for nvim config: https://github.com/ThePrimeagen/neovimrc.git
rm -rf ~/.config/nvim
cp -R nvim ~/.config/nvim
