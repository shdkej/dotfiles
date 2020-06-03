

alias kb="kubectl"
alias jl="joplin"
alias jln="joplin mknote"


set Theme Terlar
set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
set -x FZF_DEFAULT_OPS "--extended \
    --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 \
    --color info:150,prompt:110,spinner:150,pointer:167,marker:174"
set -x GOPATH "$HOME/workspace/golang"
set -x GOROOT "/usr/lib/go-1.13"
set -x GOBIN "$GOPATH/bin"
set PATH $GOROOT/bin $PATH
set PATH $GOPATH/bin $PATH
set PATH $GOBIN $PATH
setxkbmap -option keypad:pointerkeys
setxkbmap -option 'caps:ctrl_modifier' \
    && xcape -e 'Caps_Lock=Escape'
xset r rate 250 60

function da 
    docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}' | read -l cid
    [ $cid ]; and docker start "$cid"
    [ $cid ]; and docker exec -it "$cid" fish; or docker exec -it "$cid" bash
end

function dr
    docker run -it --name $1 ubuntu
end

function dl
    docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}' | read -l cid
    [ $cid ]; and docker restart "$cid"; and docker logs -f "$cid"
end

function ww
    set sug (hello)
    vi $sug
#hello | fzf --multi -q "$1" | string split '\n' | read -l file
#[ "$file" ]; and echo $file
end

# Copy purify and edit
# name: purify
# base on: theme-clearance (https://github.com/oh-my-fish/theme-clearance)

# Set fish global colors
set -l normal     fafafa
set -l selection  7f8593
set -l comment    5f5f87

set -l red    ff6059
set -l green  5fff87
set -l blue   5fafff
set -l yellow ffff87
set -l pink   ff79c6
set -l salmon ff875f

set -g fish_color_autosuggestion $selection
set -g fish_color_command        $green
set -g fish_color_comment        $comment
set -g fish_color_end            $salmon
set -g fish_color_error          $red
set -g fish_color_escape         $pink
set -g fish_color_normal         $normal
set -g fish_color_operator       $green
set -g fish_color_param          $normal
set -g fish_color_quote          $yellow
set -g fish_color_redirection    $foreground
set -g fish_color_search_match   --background=$selection
set -g fish_color_selection      --background=$selection

# Function to support git
function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
  set -l last_status $status

  # Define required colors
  set -l cyan   (set_color 88fcfc)
  set -l pink   (set_color ff79c6)
  set -l red    (set_color ff6059)
  set -l blue   (set_color 5fafff)
  set -l green  (set_color 5fff87)
  set -l normal (set_color fafafa)

  set -l cwd $blue(pwd | sed "s:^$HOME:~:")

  # Add a newline before new prompts
  echo -e ''

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b blue black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Print pwd or full path
  echo -n -s $cwd $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info $cyan $git_branch $red " !"
    else
      set git_info $cyan $git_branch $green " √"
    end

    echo -n -s $cyan ' ⇢  ' $git_info
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s $pink '❯ '
end
