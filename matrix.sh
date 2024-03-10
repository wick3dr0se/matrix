#!/bin/bash

SYMBOLS='0123456789!@#$%^&*()-_=+[]{}|;:,.<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

init_term() {
    shopt -s checkwinsize; (:;:)
    printf '\e[?1049h\e[2J\e[?25l'
}

deinit_term(){
    printf '\e[?1049l\e[?25h'
}

animate() {
    ((startPos=SRANDOM%LINES/4))
    ((drawPos=SRANDOM%COLUMNS+1))
    ((trailLen=SRANDOM%20))
    ((color=SRANDOM&2))

    for (( i = startPos; i <= LINES+trailLen; i++ )); do
        symbol="${SYMBOLS:SRANDOM%${#SYMBOLS}:1}"
        printf '\e[%d;%dH\e[3%dm%s\e[m' "$i" "$drawPos" "$color" "$symbol"
        (( i > trailLen ))&& printf '\e[%d;%dH\e[m ' "$((i-trailLen))" "$drawPos"

        sleep 0.8
    done
}

trap deinit_term EXIT
trap 'wait; exit 1' INT
trap init_term WINCH

main() {
    init_term

    for((;;)) { animate & sleep 0.1; }
}

main