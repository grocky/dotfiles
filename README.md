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
