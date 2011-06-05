local rvm_path="$HOME/.rvm"

# Colors
local col_sha='yellow'
local col_branch='blue'
local col_remote='magenta'

local return_char='↵' # ↳
local return_code="%(?.%{$fg[green]%}$return_char.%{$fg[red]%}%? $return_char)%{$reset_color%}"

local prompt_char="%(#.%{$fg[red]%}.%{$fg[green]%})%#%{$reset_color%}"
local prompt_user="%(#.%{$fg[red]%}.%{$fg[green]%})%n%{$reset_color%}"
local prompt_host="%{$fg[magenta]%}%m%{$reset_color%}"
local prompt_path="%{$fg[blue]%}%~%{$reset_color%}"

function rvm_prompt {
	ruby_version=$($rvm_path/bin/rvm-prompt s i v p g 2> /dev/null) || return
	echo -n "rvm: %{$fg[red]%}"
	echo -n "$ruby_version" | sed \
		-e "s/ruby-1.8.7-p334/1.8.7/" \
		-e "s/ruby-1.9.2-p180/1.9.2/" \
		-e "s/jruby-1.6.2/jruby/" \
		-e "s/rbx-head/rbx/" \
		-e "s/ree-1.8.7-2011.03/ree/" \
		-e "s/maglev-25876/maglev/" \
		-e "s/macruby-0.10/macruby/" \
		-e "s/@/%{$reset_color%} %{$fg_bold[yellow]%}/"
	echo -n "%{$reset_color%}"
}

# function git_prompt {
# 	local git_dir="$(git rev-parse --git-dir 2>/dev/null)"
# 	if [ ! -n "$git_dir" ]; then return; fi
# 	local sha=$(git rev-parse --short HEAD 2>/dev/null)
# 	local ref=$(git symbolic-ref HEAD 2>/dev/null)
# 	local tag=$(git describe --exact-match HEAD 2>/dev/null)
# 	echo -n "git: "
# 	
# 	
# 	local b
# 	local r
# 	if [ -d "$git_dir/rebase-apply" ]; then
# 		if test -f "$git_dir/rebase-apply/rebasing"; then
# 			r=" rebasing"
# 		elif test -f "$git_dir/rebase-apply/applying"; then
# 			r=" applying"
# 		else
# 			r=" applying/rebasing"
# 		fi
# 		b="$ref"
# 	elif [ -f "$git_dir/rebase-merge/interactive" ]; then
# 		if [ -f "$git_dir/rebase-merge/interactive" ]; then
# 			r=" rebasing interactively"
# 		else
# 			r=" rebasing merging"
# 		fi
# 		b="$(cat "$git_dir/rebase-merge/head-name")"
# 	elif [ -f "$g/MERGE_HEAD" ]; then
# 		r=" merging"
# 		b="$(git symbolic-ref HEAD 2>/dev/null)"
# 	else
# 		if [ -f "$git_dir/BISECT_LOG" ]; then
# 			r=" bisecting"
# 		fi
# 		if ! b="$(git symbolic-ref HEAD 2>/dev/null)"; then
# 		   if ! b="$(git describe --exact-match HEAD 2>/dev/null)"; then
# 			  b="$(cut -c1-7 "$git_dir/HEAD")..."
# 		   fi
# 		fi
# 	fi
# 	local branch=${ref#refs/heads/}
# 	local remote=$(git config --get "branch.$branch.remote")
# 	echo -n "git: %{$fg[blue]%}${b##refs/heads/}%{$reset_color%}$r"
# 	
# 	sha=$(git rev-parse --short HEAD 2>/dev/null) || return
# 	echo -n "git: "
# 	ref=$(git symbolic-ref HEAD 2> /dev/null)
# 	if [ -z "$ref" ]; then
# 		echo -n "%{$fg[$col_sha]%}$sha%{$reset_color%}"
# 		return
# 	fi
# 	branch=
# 	echo -n "%{$fg[$col_branch]%}$branch%{$reset_color%} (%{$fg[$col_sha]%}$sha%{$reset_color%})"
# 	remote=$(git config --get "branch.$branch.remote") || return
# 	echo -n " -> %{$fg[$col_remote]%}$remote%{$reset_color%}"
# 	
# 	if [ -n "$1" ]; then
# 		 printf "$1" "${b##refs/heads/}$r"
# 	else
# 		 printf "git: %{$fg[blue]%}%s%{$reset_color%} (%s)" "${b##refs/heads/}$r"
# 	fi
# }

function git_prompt {
	sha=$(git rev-parse --short HEAD 2>/dev/null) || return
	echo -n "git: "
	ref=$(git symbolic-ref HEAD 2> /dev/null)
	if [ -z "$ref" ]; then
		echo -n "%{$fg[$col_sha]%}$sha%{$reset_color%}"
		return
	fi
	branch=${ref#refs/heads/}
	echo -n "%{$fg[$col_branch]%}$branch%{$reset_color%} (%{$fg[$col_sha]%}$sha%{$reset_color%})"
	remote=$(git config --get "branch.$branch.remote") || return
	echo -n " -> %{$fg[$col_remote]%}$remote%{$reset_color%}"
}

function prompt_footer {
	FOOTER="\e[$LINES;0f# ${prompt_user} @ ${prompt_host} : ${prompt_path}"
	FEET=1
	for FOOT ($@); do
		if [ -z "$FOOT" ]; then
			continue;
		fi
		FOOTER="\e[$[$LINES-$FEET];0f# $FOOT$FOOTER"
		FEET=$[$FEET+1]
	done
	echo -ne "\e[s" # Save Cursor
	echo -ne "\e[0;$[$LINES-$FEET]r"
	echo -ne "$FOOTER"
	echo -ne "\e[u" # Restore Cursor
}

local footer_rvm='$(rvm_prompt yellow)'
local footer_git='$(git_prompt)'
local footer="$(prompt_footer $footer_rvm $footer_git)"

#precmd() { prompt_footer $footer_rvm $footer_git }

PROMPT="%{$footer%}${prompt_char} " # %{$footer%}
RPROMPT="${return_code}"

local sprompt_no="%{$fg[red]%}n%{$reset_color%}o"
local sprompt_yes="%{$fg[green]%}y%{$reset_color%}es"
local sprompt_edit="%{$fg[yellow]%}e%{$reset_color%}dit"
local sprompt_abort="%{$fg[yellow]%}a%{$reset_color%}bort"
local sprompt_options="[$sprompt_no $sprompt_yes $sprompt_edit $sprompt_abort]"
local sprompt_char="%{$fg[yellow]%}?%{$reset_color%}"
local sprompt_from="%{$fg[red]%}%R%{$reset_color%}"
local sprompt_to="%{$fg[green]%}%r%{$reset_color%}"
SPROMPT="$sprompt_char $sprompt_from -> $sprompt_to $sprompt_options "

PROMPT2="%{$footer%}%{$fg[yellow]%}>%{$reset_color%} "
RPROMPT2="%_"

#  1: Directory
#  2: Symbolic Link
#  3: Socket
#  4: Pipe
#  5: Executable
#  6: Block Special
#  7: Character Special
#  8: Executable w/ setuid
#  9: Executable w/ setgid
# 10: Directory Writable to Others, w/  Sticky Bit
# 11: Directory Writable to Others, w/o Sticky Bit

#  a: Black     A: Bold Black
#  b: Red       B: Bold Red
#  c: Green     C: Bold Green
#  d: Yellow    D: Bold Yellow
#  e: Blue      E: Bold Blue
#  f: Magenta   F: Bold Magenta
#  g: Cyan      G: Bold Cyan
#  h: White     H: Bold White
#  x: Default

# Color Config
# Type            1   3   5   7   9  11
# Fore/Back      fbfbfbfbfbfbfbfbfbfbfb
export LSCOLORS='excxfxfxbxdxDxbBbBEeEx'
