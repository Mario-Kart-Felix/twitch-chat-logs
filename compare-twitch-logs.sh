#!/usr/bin/env bash

compare_files () {
    wdiff -si123 <(sed 's/^.\{10\}//' "${1}") <(sed 's/^.\{10\}//' "${2}") | grep -Eo '[[:digit:]]+% common'
}

tcd1=(./tcd1/WoolieVersus/*)
tcd2=(./tcd2/WoolieVersus/*)
start=0

while :; do
    case $1 in
    -n)
        if [[ -z "${2}" ]]; then
            printf "ERROR: No number specified.\n"
        else
            start="${2}"
            shift 2
        fi
        ;;
    -a)
        if [[ -z "${2}" ]]; then
            printf "ERROR: No a specified.\n"
        else
            tcd1=("${2}/*")
            shift 2
        fi
        ;;
    -b)
        if [[ -z "${2}" ]]; then
            printf "ERROR: No b specified.\n"
        else
            tcd2=("${2}/*")
            shift 2
        fi
        ;;
    "")
        break
        ;;
    -?*)
        printf "ERROR: Unknown argument: %s\n" "${1}"
        usage
        ;;
    *)
        printf "ERROR: Unknown argument: %s\n" "${1}"
        usage
        ;;
    esac
done

for ((i = start; i < ${#tcd1[@]}; ++i)); do
    diff_stats=$(compare_files "${tcd1[i]}" "${tcd2[i]}")
    printf "%03d: %s *** %s\n%s\n" "${i}" "$(basename "${tcd1[i]}")" "$(basename "${tcd2[i]}")" "${diff_stats}"
done
