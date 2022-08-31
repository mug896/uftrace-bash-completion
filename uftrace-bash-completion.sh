_uftrace()
{
    local CMD=$1 CUR=${COMP_WORDS[COMP_CWORD]} PREV=${COMP_WORDS[COMP_CWORD-1]}
    [[ ${COMP_LINE:COMP_POINT-1:1} = " " ]] && CUR=""
    [[ $PREV == "=" ]] && PREV=${COMP_WORDS[COMP_CWORD-2]}
    local IFS=$' \t\n' WORDS OPTS=() OPT1=() OPT2=() TMP i

    IFS=$'\n'
    for TMP in $( $CMD --help | sed -En '/^\s+-/{ s/^\s{,15}((-\w),?\s)?(--[[:alnum:]-]+=?)?.*/ \2 \3/p }')
    do
        if [[ $TMP == *=* ]]; then
            TMP=${TMP/=/} OPT1+=( ${TMP// /$'\n'} )
        else
            OPT2+=( ${TMP// /$'\n'} )
        fi
    done
    unset -v IFS

    OPTS=( "${OPT1[@]}" "${OPT2[@]}" )
    if [[ $CUR == --* ]]; then
        WORDS=${OPTS[@]/#-[^-]*/}
    elif [[ $CUR == -* ]]; then
        WORDS=${OPTS[@]/#--*/}" -?"
    elif [[ $PREV == @(-!(-*)L|--libmcount-path) ]]; then
        compopt -o dirnames
    elif [[ $PREV == --color ]]; then
        WORDS="yes no auto"
    elif [[ $PREV == --demangle ]]; then
        WORDS="full simple no"
    elif [[ $PREV == --match ]]; then
        WORDS="regex glob"
    elif [[ $PREV == @(-!(-*)s|--sort) ]]; then
        WORDS="total self call avg min max"
    elif [[ $PREV == --logfile ]]; then
        :
    else
        WORDS="record replay live report info dump recv graph script tui"
        if printf '%s\n' "${OPT1[@]}" | grep -xq -- "$PREV" ||
            [[ $PREV == @(,|@) ]]; then WORDS=""
        else
            for (( i = 1; i < ${#COMP_WORDS[@]}; i++ )); do
                for TMP in $WORDS; do
                    [[ ${COMP_WORDS[i]} == $TMP ]] && WORDS=""
                done
            done
        fi
    fi
    COMPREPLY=( $(compgen -W "$WORDS" -- "$CUR") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -o bashdefault -F _uftrace uftrace

