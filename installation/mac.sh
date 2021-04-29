#!/bin/bash
if ! command -v brew &> /dev/null
then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
if [ ! -d "$HOME/.dotfiles" ]; then
	git clone https://github.com/davidsu/dotfiles.git "${HOME}/.dotfiles"
fi
if [ ! -d "$HOME/.zgen" ]; then
	git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

if [ ! -d "$HOME/zsh-defer" ]; then
    git clone https://github.com/romkatv/zsh-defer.git ~/zsh-defer
fi
if ! command -v fzf &> /dev/null; then
	brew install fzf
	$(brew --prefix)/opt/fzf/install
fi

#fast node manager -- substitues nvm
brew install fnm
brew install the_silver_searcher
brew install ripgrep
sudo gem install rouge
brew install neovim
brew install zsh
brew install coreutils
brew install wget
brew install entr # watch file changes in terminal
cd ~/.dotfiles
git submodule update --init --recursive
brew install yarn 
yarn global add yarn-completions
yarn global add tldr
#manages process in the background, use for mru
yarn global add pm2
# chrome standalone debugger
yarn global add ndb
yarn global add neovim
yarn global add typescript

brew install fasd
chsh -s /bin/zsh
ln -fs ~/.dotfiles/config/ ~/.config
ln -sf ~/.dotfiles/zsh/zshrc.symlink ~/.zshrc
brew install python3
pip3 install neovim
sudo gem install neovim
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cd ~/Library/Fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

cd $HOME/.dotfiles/js && yarn && yarn build
