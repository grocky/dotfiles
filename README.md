# Personal Dotfiles

Storing personal settings and configurations stored in dotfiles to make it easy to distribute to other hosts.

## Setup

To load dotfiles on the host run

```shell
git clone https://github.com/grocky/dotfiles.git
# enter username and (password or personal access token)
cd dotfiles && make init
```

The script will idempotently link the dotfiles in `./dotfiles` to your `$HOME` directory. If any conflicting dotfiles exist on the host already they will be backed up first.

In order to clean up the host just run

```shell
cd dotfiles && ./install_dotfiles.sh -u
cd ../ && rm -rf dotfiles/
```

## AI agent instructions

Shared conventions for coding agents live in [`agents/`](agents/) and are installed by `make agents`
(also part of `make init`):

| Source | Installed to | Read by |
|---|---|---|
| `agents/AGENTS.md` | `~/AGENTS.md`, `~/.codex/AGENTS.md` | all agents, Codex |
| `agents/CLAUDE.md` (imports `@~/AGENTS.md`) | `CLAUDE.md` in `~/.claude` and each `~/.claude-*` config dir | Claude Code |
| `agents/rules/*.md` | `~/.agents/rules/`, and `rules/` in each Claude config dir | all agents; Claude loads them by path |

Cursor has no global rules file: add "Follow `~/AGENTS.md`" under Cursor Settings → Rules → User Rules.
Add a new language by dropping `agents/rules/<lang>.md` in place, listing it in `AGENTS.md`, and re-running
`make agents`. Uninstall with `./install_agents.sh -u`.

> **NOTE**: On older versions of tmux we need to `brew install reattach-to-user-namespace` [See](https://github.com/thoughtbot/dotfiles/issues/75)

```shell
gem install tmuxinator
```

## Powerline install

```shell
go install github.com/justjanne/powerline-go@latest

git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
```

## GPG

To load the gpg key passphrase into the macos keychain without installing the entire GPG Suite add the following to
`~/.gnupg/gpg-agent.conf`:

```shell
pinentry-program /usr/local/bin/pinentry-mac
```

Then sign a test message to have pinentry-mac store your password in the keychain.

```shell
echo "test" | gpg --clearsign
```
