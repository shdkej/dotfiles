alias jl="joplin"
alias jln="joplin mknote"
set Theme Terlar
set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
set -x FZF_DEFAULT_OPS "--extended"
set -x GOPATH "$HOME/workspace/golang"

function da 
    docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}' | read -l cid
    docker start "$cid"
    docker exec -it "$cid" fish
end

function dr
    docker run -it --name $1 ubuntu
end
