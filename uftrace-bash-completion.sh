_uftrace()
{
    local cmd=$1 cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    [[ ${COMP_LINE:COMP_POINT-1:1} = " " ]] && cur=""
    [[ $prev == "=" ]] && prev=${COMP_WORDS[COMP_CWORD-2]}
    local IFS=$' \t\n' words opts=() opt1=() opt2=() tmp i

    IFS=$'\n'
    for tmp in $( $cmd --help | sed -En '/^\s+-/{ s/^\s{,15}((-\w),?\s)?(--[[:alnum:]-]+=?)?.*/ \2 \3/p }')
    do
        if [[ $tmp == *"="* ]]; then
            tmp=${tmp/=/} opt1+=( ${tmp// /$'\n'} )
        else
            opt2+=( ${tmp// /$'\n'} )
        fi
    done
    unset -v IFS

    opts=( "${opt1[@]}" "${opt2[@]}" )
    if [[ $cur == --* ]]; then
        words=${opts[@]/#-[^-]*/}
    elif [[ $CUR == -* ]]; then
        words=${opts[@]/#--*/}" -?"
    elif [[ $prev == @(-!(-*)L|--libmcount-path) ]]; then
        compopt -o dirnames
    elif [[ $prev == --color ]]; then
        words="yes no auto"
    elif [[ $prev == --demangle ]]; then
        words="full simple no"
    elif [[ $prev == --match ]]; then
        words="regex glob"
    elif [[ $prev == @(-!(-*)s|--sort) ]]; then
        words="total self call avg min max"
    elif [[ $prev == --logfile ]]; then
        :
    else
        words="record replay live report info dump recv graph script tui"
        if printf '%s\n' "${opt1[@]}" | grep -xq -- "$prev" ||
            [[ $prev == [,@] ]]; then words=""
        else
            for (( i = 1; i < ${#COMP_WORDS[@]}; i++ )); do
                for tmp in $words; do
                    [[ ${COMP_WORDS[i]} == $tmp ]] && words=""
                done
            done
        fi
    fi
    [[ $cur == "=" ]] && cur=""
    COMPREPLY=( $(compgen -W "$words" -- "$cur") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -o bashdefault -F _uftrace uftrace

