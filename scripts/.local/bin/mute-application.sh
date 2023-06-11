#!/bin/bash

main() {
    local action=mute
    while getopts :hu option; do 
        case "$option" in 
            h) usage 0 ;;
            u) action=unmute ;;
            ?) usage 1 "invalid option: -$OPTARG" ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ "$1" ]]; then
        $action "$1"
    else
        usage 1 "specify an application name" 
    fi
}

usage() {
    [[ "$2" ]] && echo "error: $2"
    echo "usage: $0 [-h] [-u] appname"
    echo "where: -u = ummute application (default action is to mute)"
    exit $1
}

mute()   { adjust_muteness "$1" 1; }
unmute() { adjust_muteness "$1" 0; }

adjust_muteness() { 
    local index=$(get_index "$1")
    [[ "$index" ]] && pacmd set-sink-input-mute "$index" $2 >/dev/null 
}

get_index() {
    local pid=$(pidof "$1")
    pacmd list-sink-inputs | 
    awk -v pid=$pid '
    $1 == "index:" {idx = $2} 
    $1 == "application.process.id" && $3 == "\"" pid "\"" {print idx; exit}
    '
}

main $*
