function git_state {
	ref=$(git rev-parse HEAD 2>/dev/null | git name-rev --stdin --name-only 2>/dev/null) || return
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)$ref$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

local rvm_info='%{$fg_bold[red]%}$(rvm_prompt_info s i v p g)%{$reset_color%}'
local git_info='$(git_state)$(git_prompt_ahead)'

local return_code="%(?..%{$fg[red]%}↳ %?%{$reset_color%}
)"

local prompt_user='%{$fg[cyan]%}%n%{$reset_color%}'
local prompt_host='%{$fg[magenta]%}%m%{$reset_color%}'
local prompt_path='%{$fg[blue]%}%~%{$reset_color%}'
local prompt_char='%#'

#[ ${prompt_user} @ ${prompt_host} : ${prompt_path} ]${git_info} ${rvm_info}
PROMPT="${return_code}${prompt_path}${git_info}
${prompt_char} "
RPROMPT="${rvm_info} [ ${prompt_user} @ ${prompt_host} ]"

PROMPT2="%{$fg[yellow]%}>%{$reset_color%} "
RPROMPT2="%i:%_"

ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" [%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

ZSH_THEME_GIT_PROMPT_PREFIX=" on "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_AHEAD=" with unpushed changes"
ZSH_THEME_GIT_PROMPT_BEHIND=" with unpulled changes"

ZSH_THEME_GIT_PROMPT_UNTRACKED=" ?"
ZSH_THEME_GIT_PROMPT_ADDED=" A"
ZSH_THEME_GIT_PROMPT_MODIFIED=" M"
ZSH_THEME_GIT_PROMPT_RENAMED=" R"
ZSH_THEME_GIT_PROMPT_DELETED=" D"
ZSH_THEME_GIT_PROMPT_UNMERGED=" U"

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
