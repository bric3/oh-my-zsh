function parse_svn() {
    #echo "arrrrrrrg"
    info=$(svn info 2> /dev/null) || return
    in_svn=true
    svn_branch_name="$(svn_get_branch_name $info)"
    svn_dirty="$(svn_dirty_choose)"
    svn_repo_name="$(svn_get_repo_name $info)"
    svn_rev="$(svn_get_revision $info)"
}


function svn_prompt_info {
    eval parse_svn

    if [ ${in_svn} ]; then
        echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR${svn_branch_name}\
$ZSH_PROMPT_BASE_COLOR${svn_dirty}\
$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX\
$ZSH_PROMPT_BASE_COLOR"
    fi
}

function svn_get_branch_name {
    echo $1 | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$' | read SVN_URL
    echo $SVN_URL
}

function svn_get_repo_name {
    echo $1 | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT

    echo $1 | sed -n "s/URL:\ .*$SVN_ROOT\///p"
}

function svn_get_revision {
    echo $1 2> /dev/null | sed -n s/Revision:\ //p
}

function svn_dirty_choose {
    svn status|grep -E '^\s*[ACDIM!?L]' >/dev/null 2>/dev/null && echo $ZSH_THEME_SVN_PROMPT_DIRTY && return
    echo $ZSH_THEME_SVN_PROMPT_CLEAN
}
