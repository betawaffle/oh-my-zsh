# get the name of the branch we are on
function rvm_prompt_info() {
  ruby_version=$(~/.rvm/bin/rvm-prompt $@ 2> /dev/null) || return
  echo "$ruby_version" | sed \
	-Ee "s/@(.+)/%{$reset_color%}@%{$fg[yellow]%}\1%{$reset_color%}/g"
}
