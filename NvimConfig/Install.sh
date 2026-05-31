#install dependencies:
sudo apt update
sudo apt upgrade -y
sudo apt install -y bear tmux gdb build-essential git gcc vim clang lldb clangd gcc-multilib ddd sasm nasm nodejs npm golang-go python3 python3-pip clang gcc g++ make curl unzip tar dmd-compiler ldc dub
go install golang.org/x/tools/gopls@latest
curl https://sh.rustup.rs -sSf | sh
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz 
sudo tar -C /opt/ -xzf nvim-linux-x86_64.tar.gz --strip-components=1
rm nvim-linux-x86_64.tar.gz
sed -i '/nvim-linux-x86/d' ~/.bashrc
sed -i '/nvim-linux-x86/d' ~/.zshrc
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.zshrc
rm -rf ~/.config/nvim
cp -R nvim ~/.config/nvim
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && cd ~/.local/share/fonts && unzip JetBrainsMono.zip && rm JetBrainsMono.zip && fc-cache -fv
