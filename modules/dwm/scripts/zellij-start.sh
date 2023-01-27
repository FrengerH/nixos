#!/usr/bin/env bash

sessions=$(zellij list-sessions | wc -l)
terminals=$(wmctrl -l | grep 'Zellij (base)' | wc -l)
if [ $terminals -lt 1 ];
then
    ses=$(zellij list-sessions | grep 'base' | awk '{ print $1 }')
    if [ "$ses" == "base" ];
    then
        zellij attach base
    else
        zellij -s base
    fi
else
    nr=$(($sessions+1))
    zellij -s "$nr"
fi

