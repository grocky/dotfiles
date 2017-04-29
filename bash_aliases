alias reload="source ${HOME}/.bash_profile"

alias mux="tmuxinator"

# shell shortcuts
export LS_OPTIONS='--color=auto'
alias lsl='ls ${LS_OPTIONS} -lrth'
alias lsa='ls ${LS_OPTIONS} -lrtha'

# directory shortcuts
alias ws='cd ~/Workspace'
alias dl='cd ~/Downloads'
alias gws="cd ~/GoogleDrive/Projects"
alias gdrive="cd /Users/grocky/GoogleDrive"

# php shortcuts
alias xon="export XDEBUG_CONFIG=\"profiler_enable=1\""
alias xoff="export XDEBUG_CONFIG=\"profiler_enable=0\""

# tool shortcuts
alias json="python -m json.tool"; 
### usage echo '{"foo": "lorem", "bar": "ipsum"}' | json
alias mux='tmuxinator'

### IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="sudo ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

### Kill all the tabs in Chrome to free up memory
### [explained](http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description)

alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

### get week number
alias week='date +%V'

function timer () {
  sleep ${1:=25m}
  say "time is up! $1"
}

### vhosts
alias hosts='sudo vim /etc/hosts'

### copy working directory
alias cwd='pwd | tr -d "\r\n" | pbcopy'

function find_password() {
  password_name=$1
  grep -i ${password_name} ~/.env|cut -d= -f2
}

alias speedtest='speedtest-cli'
alias st='speedtest-cli'

alias openssl-b='/usr/local/Cellar/openssl/1.0.2h_1/bin/openssl'
alias ssl='openssl-b'


# Git
### top level shortcuts
alias ga='git add '
alias gcm='git commit -m '
alias gcam='git commit -a -m '
alias gl='git logtree'
alias glg='git lg'
alias gs='git status'
alias gd='git diff'

### github cli wrapper
alias git='hub '

### Git-flow
alias gff='git flow feature'
alias gffs='gff start'
alias gfff='gff finish --no-ff --keepremote'
alias gffp='gff publish'
alias gffr='gff rebase'
alias gfb='git flow bugfix'
alias gfbs='gfb start'
alias gfbf='gfb finish'
alias gfh='git flow hotfix'
alias gfhs='gfh start'
alias gfhp='gfh publish'
alias gfhf='gfh finish -np'
alias gfr='git flow release'
alias gfrf='gfr finish'
alias grfs='gfr start $(date +"%Y%m%d-%H%M") "$@"'

# Docker
alias dm='docker-machine'
alias dml='docker-machine ls'
alias dms='docker-machine start'
alias dmusb='docker-machine start stockblocks'
alias dmssb="docker-machine stop stockblocks"

alias dc='docker-compose'
alias dcps='docker-compose ps'
alias dce='docker_compose_exec'

alias d='docker'
alias dps='docker ps'
alias de='docker_exec'

# https://github.com/justone/dockviz
alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"

if [ -f ~/.vb_aliases ]; then
    source ~/.vb_aliases
fi
