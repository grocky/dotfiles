# vim:set filetype=sh:

alias bash_functions='vi ~/.bash_functions && source ~/.bash_functions'

docker_exec () {
  local container_name=${1}
  local command=${@:2}

  docker exec -it ${container_name} ${command}
}

# This is no longer necessary
# docker_compose_exec () {
#   local service_name=${1}
#   local command=${@:2}
# 
#   docker_exec $(docker-compose ps | grep ${service_name} | awk '{print $1}') ${command}
# }

now () {
  date +%I:%M:%S;
}

urlencode () {
    if [ $# -eq 0 ]; then
        echo "usage: urlencode <string>";
        return 1;
    fi
    python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])" "$1";
}

urldecode () {
    if [ $# -eq 0 ]; then
        echo "usage: urldecode <string>";
        return 1;
    fi
    python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])" "$1";
}

show_hosts () {
    awk -F',' '/^[[:alpha:]]/ { print $1 }' ~/.ssh/known_hosts;
}

dash() {
    open dash://${1}
}

list_merged_remotes() {
    for branch in $(git branch -r --merged | grep -Ev 'HEAD|develop'); do
        echo -e $(git show --format="%ci %cr %an" $branch | head -n 1) \\t$branch; 
    done | sort -r
}

list_unmerged_remotes() {
    for branch in $(git branch -r --no-merged | grep -Ev 'HEAD|master|develop'); do 
        echo -e `git show --format="%ci %cr %an" $branch | head -n 1` \\t$branch; 
    done | sort -r
}

function notify_when_cloudfront_is_deployed() {
    distribution_id=${1};
    profile=${2:-'videoblocks'};
    is_equal=true;

    if [ -z ${distribution_id} ]; then
		echo "you must provide a distribution id";
		return 1;
	fi
   
	echo "Checking on ${distribution_id} using profile: ${profile}"
 
    status=$(aws cloudfront get-distribution --id ${distribution_id} --profile ${profile} | jq '.Distribution.Status');
    while [ ${status} = '"InProgress"' ]; do
        echo "$(date) - ${status}";
        sleep 30;
    	status=$(aws cloudfront get-distribution --id ${distribution_id} --profile ${profile} | jq '.Distribution.Status');
    done
    echo '';
    echo "$(date) - ${status}";
    echo 'DONE: cloudfront distribution is propogated';
    say 'Cloudfront Distribution is propogated';
}

function close_all_notifications() {
    osascript -e 'my closeNotif()
    on closeNotif()

        tell application "System Events"
            tell process "Notification Center"
                set theWindows to every window
                repeat with i from 1 to number of items in theWindows
                    set this_item to item i of theWindows
                    try
                        click button 1 of this_item
                    on error

                        my closeNotif()
                    end try
                end repeat
            end tell
        end tell

    end closeNotif'
}

if [ -f ~/.vb_functions ]; then
    source ~/.vb_functions
fi

