#!/bin/zsh

print() { 
    echo -n "$@" 
}

cons() {
    echo $@
    command \cat
}

drop() {
    command \tail -n +$(( ${1} + 1 ))
}

take() {
    command \head -n -${1}
}

tail() { 
    drop 1 
}

head() { 
    take 1 
}

last() {
    \tail -n 1
}

list() {
    for i in "$@"; do
        echo "$i"
    done
}

unlist() {
    echo "$@"
}

map() {
    while read x; do
        echo $x | $@
    done
}

foldl() {
    f="$@"
    read acc
    while read elem; do
        acc="$(echo "$acc\n$elem" | $f)"
    done
    echo "$acc"
}

scanl() {
    f="$@"
    read acc
    while read elem; do
        acc="$(echo "$acc\n$elem" | $f)"
        echo "$acc"
    done
}

lambda() { 
    lam() { 
        unset last 
        unset ars
        for last; do 
            shift
            if [[ $last = "." || $last = ":" || $last = "->" || $last = "→" ]]; then 
                echo "$@"
                return
            else 
                echo "read $last;"
            fi
        done 
    }
    y="stdin"
    for i in "$@"; do 
        if [[ $i = "." || $i = ":" || $i = "->" || $i = "→" ]]; then 
            y="args"
        fi 
    done 
    if [[ "$y" = "stdin" ]]; then
        read fun
        eval $(lam "$@ : $fun")
    else 
        eval $(lam "$@")
    fi
    unset y
    unset i
    unset fun 
}

alias -g 'λ'="lambda "

append() {
    lines $@
    while read xs; do
        echo $xs
    done
}

sum() { 
    foldl λ a b . 'echo $(($a + $b))' 
}

product() { 
    foldl λ a b . 'echo $(($a * $b))' 
}

factorial() { 
    seq 1 $1 | product 
}

