# Moonsphere-theme loosely based on the 'cloud' theme
# Author: Tim Kurvers <tim@moonsphere.net>

function collapse_pwd {
  echo $(pwd | perl -pe "s|^$HOME|~|; s|/([^/])[^/]*(?=(?:/.+/))|/\$1|g")
}

function git_info {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return

  local git_ref
  git_ref=$(git symbolic-ref HEAD --short 2> /dev/null || git rev-parse --short HEAD)

  local git_status
  git_status=$(git status 2> /dev/null)

  local symbol_dirty="⚡︎"
  local symbol_clean="★ "
  local symbol_ahead="⤴ "
  local symbol_behind=" ⤶"

  local suffix=''
  if [[ $git_status == *"Your branch is ahead"* ]]; then
    suffix=$symbol_ahead
  fi
  if [[ $git_status == *"Your branch is behind"* ]]; then
    suffix=$symbol_behind
  fi
  if [[ $git_status == *"have diverged"* ]]; then
    suffix="%{$fg_bold[red]%} diverged%{$reset_color%}"
  fi
  if [[ $git_status == *"HEAD detached"* ]]; then
    suffix="%{$fg_bold[red]%} detached%{$reset_color%}"
  fi

  local symbol=$symbol_clean
  local color="cyan"

  if [[ -n $(git status -s 2> /dev/null) ]]; then
    symbol=$symbol_dirty
    color="yellow"
  fi

  echo "%{$fg_bold[$color]%}$symbol$git_ref$suffix %{$reset_color%}"
}

function node_info {
  local version=$(cat .node-version 2> /dev/null) || return
  if [ $version ]; then
    echo "  node $version"
  fi
}

function python_info {
  local version=$(cat .python-version 2> /dev/null) || return
  if [ $version ]; then
    echo -n "  python $version"
    if [ $VIRTUAL_ENV ]; then
      echo " + virtualenv"
    fi
  fi
}

function ruby_info {
  local version=$(cat .ruby-version 2> /dev/null) || return
  if [ $version ]; then
    echo "  ruby $version"
  fi
}

PROMPT='%{$reset_color%}$(git_info)%{$fg_bold[green]%}$(collapse_pwd) %{$fg_bold[black]%}∴ %{$reset_color%}'
RPROMPT='%{$fg_bold[black]%}$(node_info)$(python_info)$(ruby_info)%{$reset_color%}'

VIRTUAL_ENV_DISABLE_PROMPT=1
