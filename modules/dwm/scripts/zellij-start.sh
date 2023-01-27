#!/usr/bin/env bash

terminals=$(ps -e | grep 'zellij' | wc -l)
if [ $terminals -lt 1 ];
then
    ses=$(zellij list-sessions | awk '{ print $1 }')
    if [ "$ses" == "base" ];
    then
        zellij attach base
    else
        zellij -s base
    fi
else
    nr=$(terminals/2)
    zellij -s "$nr"
fi

