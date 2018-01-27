## Personal Dotfiles

Storing personal settings and configurations stored in dotfiles to make it easy to distribute to other hosts.

To load dotfiles on the host run

```shell
git clone https://github.com/grocky/dotfiles.git
# enter username and (password or personal access token)
cd dotfiles && ./install_dotfiles.sh
```

The script will idempotently link the dotfiles in `./dotfiles` to your `$HOME` directory. If any conflicting dotfiles exist on the host already they will be backed up first.

In order to clean up the host just run

```shell
cd dotfiles && ./install_dotfiles.sh -u
cd ../ && rm -rf dotfiles/
```

For tmux we need to `brew install reattach-to-user-namespace` [See](https://github.com/thoughtbot/dotfiles/issues/75)

```shell
gem install tmuxinator
```

### Change screenshot location
defaults write com.capple.screencapture location ${HOME}/Desktop/screenshots && killall SystemUIServer && "update successful" || "update failed"

### Git status

```shell
ln -s ~/dotfiles/config/powerline ~/.config/powerline
```

```shell
pip install powerline-gitstatus
pip install powerline-mem-segment

git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
```

TODO: extract gitshots into a separate repo

