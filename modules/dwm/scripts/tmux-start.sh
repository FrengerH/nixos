#!/usr/bin/env bash

terminals=$(tmux ls | wc -l)
if [ $terminals -lt 1 ];
then
    ses=$(tmux ls | awk '{ print $1 }')
    if [ "$ses" == "base:" ];
    then
        tmux attach -t base
    else
        tmux new -s base
    fi
else
    tmux
fi
