alias g='git'

compdef g=git

alias ga='git add'
alias gb='git branch'
alias gc='git commit -v'
alias gd='git difftool'
alias gf='git fetch --all'
alias gl='git lg'
alias gm='git merge --no-ff'
alias gp='git difftool --cached'
alias gs='git status -s'
alias gx='gitx'

compdef _git ga=git-add
compdef _git gb=git-branch
compdef _git gc=git-commit
compdef _git gd=git-difftool
compdef _git gf=git-fetch
compdef _git gl=git-log
compdef _git gm=git-merge
compdef _git gp=git-difftool
compdef _git gs=git-status

alias g..='git checkout HEAD~'

alias gps='git diff --cached --stat'

compdef _git gps=git-diff

alias branches='git branch -vva'
alias stashes='git stash list'

function stashes-deleted {
	git fsck --unreachable | grep commit | cut -d\  -f3 | xargs git lg --merges --no-walk --grep=WIP
}

function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}
