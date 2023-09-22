#!/usr/bin/env bash

acpi=`ps -e | command -v acpi | wc -l`
if [ $acpi -gt 0 ]; then
    response=`acpi -b | grep 'Battery 0'`
    proc=`echo $response | awk -F ': ' '{print $2}' | awk -F ', ' '{print $2}'`
    charge_state=`echo $response | awk -F ': ' '{print $2}' | awk -F ', ' '{print $1}'`
    # echo $charge_state
    nr=${proc::-1}
    if (($nr<=5)); then
        ico="000"
    elif (($nr<=15)); then
        ico="010"
    elif (($nr<=25)); then
        ico="020"
    elif (($nr<=35)); then
        ico="030"
    elif (($nr<=45)); then
        ico="040"
    elif (($nr<=55)); then
        ico="050"
    elif (($nr<=65)); then
        ico="060"
    elif (($nr<=75)); then
        ico="070"
    elif (($nr<=85)); then
        ico="080"
    elif (($nr<=95)); then
        ico="090"
    else
        ico="100"
    fi

    ICONC000="󰂎"
    ICONC010="󰁺"
    ICONC020="󰁻"
    ICONC030="󰁼"
    ICONC040="󰁽"
    ICONC050="󰁾"
    ICONC060="󰁿"
    ICONC070="󰂀"
    ICONC080="󰂁"
    ICONC090="󰂂"
    ICONC100="󰁹"

    ICON000="󰂎"
    ICON010="󰢜"
    ICON020="󰂆"
    ICON030="󰂇"
    ICON040="󰂈"
    ICON050="󰢝"
    ICON060="󰂉"
    ICON070="󰢞"
    ICON080="󰂊"
    ICON090="󰂋"
    ICON100="󰂅"

    icon='ICON'$ico
    if [ $charge_state = 'Charging' ]; then
        icon='ICONC'$ico
    fi
    printf "${!icon} %s" "$proc"
fi

