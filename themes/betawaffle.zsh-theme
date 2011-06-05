local rvm_path="$HOME/.rvm"

# Colors
local col_sha='yellow'
local col_branch='blue'
local col_remote='magenta'

# ↳ ↵
local return_char="↳"
local return_code="%(?.%{$fg[green]%}.%{$fg[red]%})$return_char%(?.. %?)%{$reset_color%}"

function rvm_prompt {
	# $rvm_path/bin/rvm-prompt
	ver=$(rvm-prompt s i v p g 2> /dev/null) || return
	echo -n "%{$fg[red]%}$ver%{$reset_color%} " | sed \
		-e "s/ruby-1.8.7-p334/1.8.7/" \
		-e "s/ruby-1.9.2-p180/1.9.2/" \
		-e "s/jruby-1.6.2/jruby/" \
		-e "s/rbx-head/rbx/" \
		-e "s/ree-1.8.7-2011.03/ree/" \
		-e "s/maglev-25876/maglev/" \
		-e "s/macruby-0.10/macruby/" \
		-e "s/@/%{$reset_color%} %{$fg_bold[yellow]%}/"
}

function git_prompt {
	sha=$(git rev-parse --short HEAD 2>/dev/null) || return
	echo -n "\n%{$fg[green]%}± "
	if ref=$(git symbolic-ref HEAD 2> /dev/null); then
		if branch=${ref#refs/heads/}; then
			echo -n "%{$fg[$col_branch]%}$branch%{$reset_color%} (%{$fg[$col_sha]%}$sha%{$reset_color%})"
			if remote=$(git config --get "branch.$branch.remote"); then
				echo -n " -> %{$fg[$col_remote]%}$remote%{$reset_color%}"
			fi
		fi
	else
		echo -n "%{$fg[$col_sha]%}$sha%{$reset_color%}"
	fi
}

preexec() {
	clear
}

precmd() {
	
}

local ps_char="%(#.%{$fg[red]%}.%{$fg[green]%})%#%{$reset_color%}"
local ps_user="%(#.%{$fg[red]%}.%{$fg[green]%})%n%{$reset_color%}"
local ps_host="%{$fg[magenta]%}%m%{$reset_color%}"
local ps_path="%{$fg[blue]%}%~%{$reset_color%}"

local ps_rvm='$(rvm_prompt)'
local ps_git='$(git_prompt)'

PROMPT="${return_code}${ps_git}
${ps_char} " # %{$footer%}
RPROMPT=" ${ps_rvm}[${ps_user} @ ${ps_host} : ${ps_path}]"

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
