# https://github.com/blinks zsh theme
# see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#SEC59
# inspired from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
#               http://forrst.com/posts/Oh_my_zsh_iTerm2_Nice_Colors_git_hg_suppo-1Ct
# needs Mercurial extension http://sjl.bitbucket.org/hg-prompt/
# see more for MQ pathces

ZSH_THEME_GIT_PROMPT_PREFIX=" %{%B%F{green}%}[%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%k%b%B%F{green}%}]%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}!%{%f%k%b%}"
#ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{%F{red}%}?%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM="%{%b%F{yellow}%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%} !"
ZSH_THEME_GIT_PROMPT_ACTION="%{%B%F{green}%}|%{%B%F{red}%}"
ZSH_THEME_GIT_PROMPT_BRANCH="%{%B%F{blue}%}"

ZSH_PROMPT_BASE_COLOR="%{%f%k%b%}"
ZSH_THEME_SVN_PROMPT_PREFIX=" %{%B%F{green}%}["
ZSH_THEME_REPO_NAME_COLOR="%{%B%F{blue}%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{%B%F{green}%}]"
ZSH_THEME_SVN_PROMPT_DIRTY=" %{%F{red}%}!"


function bat_charge() {
	echo "$($HOME'/work/tools/battery_level.py')"
}

function _prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    svn info >/dev/null 2>/dev/null && echo 'S' && return
    echo '○'
}

function colored_prompt_char() {
  # if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo "%{%F{blue}%}$(_prompt_char)%{%f%k%b%}"
  # else
  #  echo ' '
  # fi
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< %{%B%F{green}%}[%{%F{magenta}%}<branch>%{%f%k%b%}>\
< at %{%F{yellow}%}<tags|%{%f%k%b%}, %{%F{yellow}%}>%{%f%k%b%}>\
< %{%F{red}%}<status|modified|unknown>%{%f%k%b%}>\
< %{%F{red}%}<update>%{%f%k%b%}>\
%{%B%F{green}%}]%{%f%k%b%}" 2>/dev/null
}


# thx to Olivier Bazoud
# enforce custom git prompt info
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(__git_ps1) $(git_upstream_info)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


various_intersting_chars='⚙ ♨ ♋ ㍖♫𝄢♬♪𝄆𝄇𝄈𝄐〖⦖〘〙》〰︴෴⸚⌁⌀⌖𝌁⿓⎃☢☣☠☤⚕'


local ret_status="%(?::%{$fg_bold[red]%}%S↑%s%? )"

function {
    if [[ -n "$SSH_CLIENT" ]]; then
        prompt_host="%{%f%k%b%}%{%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} "
    else
        prompt_host=''
    fi
}

PROMPT='${ret_status}${prompt_host}%{%b%F{yellow}%}${PWD/#$HOME/~}%E%{%f%k%b%} $(colored_prompt_char) %(!.%F{red}❯❯❯%f.❯%f) %{%f%k%b%}'

RPROMPT='$(git_prompt_info)$(hg_prompt_info)$(svn_prompt_info)$(bat_charge)'
