#!/usr/bin/env bash

set -eu

init_term() {
    printf '\e[?1049h\e[2J\e[?25l'

    # Bash < 4 lacks dynamic $LINES/$COLUMNS updates, so we fallback to `stty`
    (( BASH_VERSINFO[0] < 4 ))&& read -r LINES COLUMNS < <(stty size)&& return
    # Bash 4+ supports dynamic sizing via `shopt -s checkwinsize`,
    # but it forces a size check after every command — inefficient for tight loops.
    # Instead, we directly query the terminal size from the bottom-right:
    IFS='[;' read -p $'\e[999;999H\e[6n' -rd R -s _ LINES COLUMNS
}

deinit_term(){ printf '\e[?1049l\e[?25h'; stty echo; }

print_to() { printf '\e[%d;%dH\e[%d;38;2;%sm%s\e[m' "$2" "$3" "${5:-2}" "$4" "$1"; }

rain() {
    ((dropStart=RANDOM%LINES/9))
    ((dropCol=RANDOM%COLUMNS+1))
    ((dropLen=RANDOM%(LINES/2)+2))
    ((dropSpeed=RANDOM%9+1))
    ((dropColDim=RANDOM%4))
    color=${colors[RANDOM%${#colors[@]}]}

    for ((i=dropStart; i <= LINES+dropLen; i++)); do
        symbol=${1:RANDOM%${#1}:1}
        (( dropColDim ))|| print_to "$symbol" $i $dropCol "$color" 1
        (( i > dropStart ))&& print_to "$symbol" $((i-1)) $dropCol "$color"
        (( i > dropLen ))&& printf '\e[%d;%dH\e[m ' $((i-dropLen)) $dropCol

        sleep 0.$dropSpeed
    done
}

trap init_term WINCH
trap 'kill 0; exit' INT
trap deinit_term EXIT

export LC_ALL=C

# Using non-ASCII characters (like katakana, emojis, or custom symbols) requires 
# everyone running the script to have a compatible font installed. To keep things 
# portable and simple, this script uses a set of ASCII characters (defined below) 
# so it doesn't require any special font installation on the user's system.
symbols='0123456789!@#$%^&*()-_=+[]{}|;:,.<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
colors=('102;255;102' '255;176;0' '169;169;169')

init_term; stty -echo
for((;;)) { rain "$symbols" & sleep 0.1; }