#!/bin/bash

. `dirname $0`/simple_curses.sh

main (){
    #basic informations, hostname, date,...
    window "`hostname`" "red"
    append "`date`"
    addsep
    append_tabbed "Up since|`uptime | cut -f1 -d"," | sed 's/^ *//' | cut -f3- -d" "`" 2 "|"
    append_tabbed "Users:`uptime | cut -f2 -d"," | sed 's/^ *//'| cut -f1 -d" "`" 2
    
    if [[ "$OSTYPE" == "darwin"* ]]
    then
        append_tabbed "`sysctl -n vm.loadavg | awk '{print "Load average: " $2 " " $3 " " $4}'`" 2
    else
        append_tabbed "`awk '{print "Load average:" $1 " " $2 " " $3}' < /proc/loadavg`" 2  
    fi

    endwin 
    
    #memory usage
    window "Memory usage" "red"

    if [[ "$OSTYPE" == "darwin"* ]]
    then
        # http://apple.stackexchange.com/questions/4286/is-there-a-mac-os-x-terminal-version-of-the-free-command-in-linux-systems/19107#19107
        FREE_BLOCKS=$(vm_stat | grep free | awk '{ print $3 }' | sed 's/\.//')
        INACTIVE_BLOCKS=$(vm_stat | grep inactive | awk '{ print $3 }' | sed 's/\.//')
        SPECULATIVE_BLOCKS=$(vm_stat | grep speculative | awk '{ print $3 }' | sed 's/\.//')

        FREE=$((($FREE_BLOCKS+SPECULATIVE_BLOCKS)*4096/1048576))
        INACTIVE=$(($INACTIVE_BLOCKS*4096/1048576))
        TOTAL=$((($FREE+$INACTIVE)))

        append_tabbed "Total: $TOTAL" 2
        append_tabbed "Free: $FREE" 2
        append_tabbed "Inactive: $INACTIVE" 2
    else
        append_tabbed `cat /proc/meminfo | awk '/MemTotal/ {print "Total:" $2/1024}'` 2
        append_tabbed `cat /proc/meminfo | awk '/MemFree/ {print "Used:" $2/1024}'` 2
    fi

    endwin

    #5 more used process ordered by cpu and memory usage
    window "Processus taking memory and CPU" "green"
    for i in `seq 2 6`; do
        if [[ "$OSTYPE" == "darwin"* ]]
        then
            append_tabbed "`ps ax -o pid,rss,pcpu,comm -r| sed -n "$i,$i p" | awk '{printf "%s: %smo:  %s%%" , $4, $2/1024, $3 }'`" 3
        else
            append_tabbed "`ps ax -o pid,rss,pcpu,ucmd --sort=-cpu,-rss | sed -n "$i,$i p" | awk '{printf "%s: %smo:  %s%%" , $4, $2/1024, $3 }'`" 3
        fi
    done
    endwin

    #get dmesg, log it then send to deskbar
    window "Last kernel messages" "blue"

    if [[ "$OSTYPE" == "darwin"* ]]
    then
        OUT="$(mktemp -t bashbar)"
        cat /var/log/system.log | tail -n 10 > $OUT
        append_file $OUT
        rm -f $OUT
    else
        dmesg | tail -n 10 > /dev/shm/deskbar.dmesg
        append_file /dev/shm/deskbar.dmesg
        rm -f /dev/shm/deskbar.dmesg
    fi

    endwin

    #a special manipulation to get net interfaces  and IP
    window "Inet interfaces" "grey"

    if [[ "$OSTYPE" == "darwin"* ]]
    then
        _ifaces=$(ifconfig | egrep "^[A-Za-z0-9]" | cut -d":" -f 1 | grep "en\|wlan")
        for ifac in $_ifaces; do
            append_tabbed  "$ifac: $(ipconfig getifaddr $ifac)" 2
        done
    else
        _ifaces=$(for inet in `ifconfig | cut -f1 -d " " | sed -n "/./ p"`; do ifconfig $inet | awk 'BEGIN{printf "%s", "'"$inet"'"} /adr:/ {printf ":%s\n", $2}'|sed 's/adr://'; done)
        for ifac in $_ifaces; do
            append_tabbed  "$ifac" 2
        done
    fi

    endwin
}
main_loop 0.5
