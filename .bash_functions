now ()
{
    date +%I:%M:%S;
}

urlencode ()
{
    if [ $# -eq 0 ]; then
        echo "usage: urlencode <string>";
        return 1;
    fi
    python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])" $1;
}

urldecode ()
{
    if [ $# -eq 0 ]; then
        echo "usage: urldecode <string>";
        return 1;
    fi
    python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])" $1;
}

show_hosts ()
{
    awk -F',' '/^[[:alpha:]]/ { print $1 }' ~/.ssh/known_hosts;
}

start_php () 
{
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
}

stop_php ()
{
    launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
}

