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

# ported __git_ps1 to read brabch and current action
function __git_ps1 () {
  local g="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -n "$g" ]; then
    local r
    local b
	if [ -f "$g/rebase-merge/interactive" ]
	then
		r="REBASE-i"
		b="$(cat "$g/rebase-merge/head-name")"
	elif [ -d "$g/rebase-merge" ]
	then
		r="REBASE-m"
		b="$(cat "$g/rebase-merge/head-name")"
	else
		if [ -d "$g/rebase-apply" ]
		then
			if [ -f "$g/rebase-apply/rebasing" ]
			then
				r="REBASE"
				b="$(cat "$g/rebase-apply/head-name")"
			elif [ -f "$g/rebase-apply/applying" ]
			then
				r="|AM"
			else
				r="AM/REBASE"
			fi
		elif [ -f "$g/MERGE_HEAD" ]
		then
			r="MERGING"
		elif [ -f "$g/CHERRY_PICK_HEAD" ]
		then
			r="CHERRY-PICKING"
		elif [ -f "$g/BISECT_LOG" ]
		then
			r="BISECTING"
		fi
	
		if [ -z "$b" ]
		then
			b="$(git symbolic-ref HEAD 2>/dev/null)" || {
				b="$(cut -c1-7 "$g/HEAD" 2>/dev/null)..." ||
				b="unknown"
				b="($b)"
			}
		fi
	fi
	
	if [ -n "$r" ]
	then
		r="$ZSH_THEME_GIT_PROMPT_ACTION$r"
	fi

    if [ -n "${1-}" ]; then
      printf "$1" "$ZSH_THEME_GIT_PROMPT_BRANCH${b##refs/heads/}$r"
    else
      printf "%s" "$ZSH_THEME_GIT_PROMPT_BRANCH${b##refs/heads/}$r"
    fi
  fi
}

# thx to Olivier Bazoud
# custom git prompt info
function git_prompt_info() {
#  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(__git_ps1) $(git_upstream_info)$(git_prompt_status)$(git_prompt_ahead)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


# find how many commits we are ahead/behind our upstream
git_upstream_info() {
  count=$(git rev-list --count --left-right @{upstream}...HEAD 2> /dev/null)
  case "$count" in
    "") # no upstream
      up="" ;;
    "0	0") # equal to upstream
      up="=" ;;
    "0	"*) # ahead of upstream
      up="↑${count#0	}" ;;
    *"	0") # behind upstream
      up="↓${count%	0}" ;;
    *)	    # diverged from upstream
      up="↑${count#*	} ↓${count%	*}" ;;
  esac
  echo "$ZSH_THEME_GIT_PROMPT_UPSTREAM$up$ZSH_THEME_GIT_PROMPT_CLEAN"
}



chars='⚙ ♨ ♋ ㍖♫𝄢♬♪𝄆𝄇𝄈𝄐〖⦖〘〙》〰︴෴⸚⌁⌀⌖𝌁⿓⎃☢☣☠☤⚕'


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
