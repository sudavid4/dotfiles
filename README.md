# DOTFILES

- how to setup computer for using this dotfiles

1. install homebrew
2. install a better version of zsh: `brew install zsh`
3. make better zsh version your custom shell: 

    ```
    Go to the Users & Groups pane of the System Preferences 

    -> Select the User -> Click the lock to make changes (bottom left corner) 

    -> right click the current user select Advanced options... 

    -> Select the Login Shell: /usr/local/Cellar/zsh/5.3.1_1/bin/zsh and OK
    ```

    or wherever is your better version of zsh installed
4. install [zgen](https://github.com/tarjoilija/zgen): `git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"`
5. install [fzf version 0.17.0](https://github.com/junegunn/fzf): `brew install fzf && /usr/local/opt/fzf/install`, find a way to use version 0.17.0 `brew switch fzf 0.17.0`
6. install fnm using homebrew: `brew install fnm`
7. install [the-silver-searcher aka ag](https://github.com/ggreer/the_silver_searcher): `brew install the_silver_searcher`
8. symlink all `.symlink` files to your home folder `ln -s PATH_TO_SOURCE_FILE.symlink ~/.FILE_NAME`
9. apply macos defaults: `sh ~/.dotfiles/macos/defaults`
10. install rouge (I'll go ahead and suggest sudoing this, there must be a better way though): `sudo gem install rouge` 
11. install [karabiner-elements](https://github.com/tekezo/Karabiner-Elements/blob/master/usage/README.md)
12. download and install [spectacle](https://www.spectacleapp.com/)
13. do yourself a favor: [glances](https://github.com/nicolargo/glances) `pip3 install glances` OR `brew install htop` and stop using activity monitor
14. `brew install coreutils` -- you need it for `realpath`
15. update submodules: `git submodule update --init --recursive`
16. install yarn: `brew install yarn --without-node`
17. install yarn completions:`yarn global add yarn-completions`
19. install tldr `yarn global add tldr` for [simplified man pages](https://github.com/tldr-pages/tldr)
20. install iterm and set colors as follows:
    - black: 727272
    - red: bf6054
    - green: 5b965e
    - yellow: b7b334
    - blue: 88a2f3
    - magenta: cb31ca
    - cyan: 7db6bb
    - white: c7c7c7
    - foreground: b2b2ac
21. set itemr's "minimal contrast" slider to 0

22. install [ITerm2 shell integration](https://www.iterm2.com/documentation-shell-integration.html): `curl -L https://iterm2.com/misc/install_shell_integration.sh | bash`
23. enable mouse scroll for less in iterm: ITerm -> Preferences -> Advanced and search for "scroll"
24. unmark checkbox of iterm->Preferences->terminal->Shell Integration[Show mark indicators]
25. make cmd+click filename in iterm open in terminal vim (or cd into dir) [Preferences -> Profiles -> Advanced, Under "Semantic History", choose "Run coprocess..". In the text field, put:`echo 'if [[ -d \1 ]]; then cd \1; else vim \1 \2; fi'`
26. install fasd: `git clone https://github.com/akatrevorjay/fasd.git && cd fasd && make install`
    - don't use the brew version cuz it messes up the global alias V
27. make changes in `_faasd_preexec` [like this](https://github.com/clvv/fasd/issues/120)
28. install hub: `brew install hub`
29. setup universal <Command-alt-ctrl-t> to open chrome dedicated node devtools: <br>
    https://www.howtogeek.com/286332/how-to-run-any-mac-terminal-command-with-a-keyboard-shortcut/#:~:text=Click%20the%20first%20field%2C%20then,the%20current%20time%20out%20loud. <br>
    In short: set bin/nodedebugchrome.sh code through automator, open <br>
    systemPreferences -> keyboard -> shortcut -> general -> <br>
    add keyboard shortcut to what you've set up in the automator <br>
30. set icon fonts in iterm: Iterm -> preferences -> profiles -> text -> [checkbox]"Use a different font for non-ASCII text": select DroidSansMono Nerd Font

- to push to github (https with two factor authentication) you will need to use a token instead of your password. [Instructions here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
