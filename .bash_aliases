alias ij="java org.apache.derby.tools.ij"

# Misc
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias lsl='ls -lrt'
alias lsa='ls -lrta'
alias l='ls -CF'                              #

# useful tools
alias json="python -m json.tool"; # usage echo '{"foo": "lorem", "bar": "ipsum"}' | json

# Git
alias ga='git add '
alias gb='git branch '
alias gc='git commit '
alias gcm='git commit -m '
alias gcam='git commit -am '
alias gd='git diff '
alias gdc='git diff --cached'
alias gf='git fetch '
alias gl='git ls '
alias gp='git push '
alias gpu='git pull '
alias gra='git remote add '
alias grr='git remote rm '
alias gs='git status '
alias gcl='git clone '

# use 'go' to jump to different branches
function go {
    if [ -z "$1" ]; then
        git checkout master;
    else
        git checkout $*;
    fi
}

# svn
alias sa='svn add '
alias sc='svn ci '
alias scm='svn ci -m '
alias sd='svn diff '
alias sl='svn log '
alias sup='svn up '
alias ss='svn st '
alias si='svn info '

# mvn
alias mc='mvn clean '
alias mi='mvn install '
alias mt='mvn test '
alias mci='mvn clean install '
alias mwd='mvn weblogic:deploy '
alias mwu='mvn weblogic:undeploy '
alias mciV="mvn clean install -Drtm-ignoreValidationErrors=true "
alias mj="mvn -P devint-test jetty:run "
alias mdj="mvnDebug -P devint-test jetty:run "
alias mag="mvn archetype:generate "
alias mapi="mvn archetype:generate -Dfilter=com.capitalone.api: "

