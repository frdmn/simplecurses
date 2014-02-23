(Caution: I (@frdmn) forked this repo from [Google Code](https://code.google.com/p/bashsimplecurses/) and turned it into a git repo using `svn2git` to provide Mac OS X compatibility. None of this is text, including the wiki content and the README.md below, is written by myself.)

## The simple way

"Bash simple curses" give you some basic functions to quickly create some windows on you terminal as Xterm, aterm, urxvt...

An example is given: bashbar. Bashbar is a monitoring bar that you can integrate in tiling desktop (Xmonad, WMii...)

The goal of Bash Simple Curses is not done (not yet) to create very complete windows. It is only done to create some colored windows and display informations into.

## Why ?

Because bash is very usefull, there are command to do whatever you want. With curses you can create a little bar to display informations every second, you can change an output command to display a report...

So, we need an easy and usefull library to quickly create this kind of views. This is why you can try Bash Simple Curses

## Examples

### the bashbar

Bash bar is the given example that show system informations. You only have to resize your terminal window and place it on left or right. This screenshot is made on Xmonad:

![](http://cl.ly/image/2F0X230t1V0w/content)

this is the code used:

    #!/bin/bash

    . `dirname $0`/simple_curses.sh

    main (){
        window "`hostname`" "red"
        append "`date`"
        addsep
        append_tabbed "Up since|`uptime | cut -f1 -d"," | sed 's/^ *//' | cut -f3- -d" "`" 2 "|"
        append_tabbed "Users:`uptime | cut -f2 -d"," | sed 's/^ *//'| cut -f1 -d" "`" 2
        append_tabbed "`awk '{print "Load average:" $1 " " $2 " " $3}' < /proc/loadavg`" 2
        endwin 
        
        window "Memory usage" "red"
        append_tabbed `cat /proc/meminfo | awk '/MemTotal/ {print "Total:" $2/1024}'` 2
        append_tabbed `cat /proc/meminfo | awk '/MemFree/ {print "Used:" $2/1024}'` 2
        endwin

        window "Processus taking memory and CPU" "green"
        for i in `seq 2 6`; do
            append_tabbed "`ps ax -o pid,rss,pcpu,ucmd --sort=-cpu,-rss | sed -n "$i,$i p" | awk '{printf "%s: %smo:  %s%%" , $4, $2/1024, $3 }'`" 3
        done
        endwin

        window "Last kernel messages" "blue"
        dmesg | tail -n 10 > /tmp/deskbar.dmesg
        while read line; do
            append_tabbed "$line" 1 "~"
        done < /tmp/deskbar.dmesg
        rm -f /tmp/deskbar.dmesg
        endwin

        window "Inet interfaces" "grey"
        _ifaces=$(for inet in `ifconfig | cut -f1 -d " " | sed -n "/./ p"`; do ifconfig $inet | awk 'BEGIN{printf "%s", "'"$inet"'"} /adr:/ {printf ":%s\n", $2}'|sed 's/adr://'; done)
        for ifac in $_ifaces; do
            append_tabbed  "$ifac" 2
        done
        endwin
    }
    main_loop 1

### Another Example

this capture shows you that you can do whatever you want:

![](http://cl.ly/image/3t0x2A152Q16/content)

Code is:

    #!/bin/bash

    source $(dirname $0)/simple_curses.sh

    main(){
        window "Test 1" "red" "33%"
        append "First simple window"
        endwin

        col_right 
        move_up

        window "Test 2" "red" "33%"
        append "Multiline is allowed !!!\nLike this :)"
        append "This is a new col here."
        endwin

        window "Test 3" "red" "33%"
        append "We can had some text, log..."
        endwin
        window "Test 4" "grey" "33%"
        append "Example using command"
        append "`date`"
        append "I only ask for date"
        endwin
        
        col_right 
        move_up
        window "Test 5" "red" "34%"
        append "We can add some little windows... rememeber that very long lines are wrapped to fit window !"
        endwin

        window "Little" "green" "12%"
        append "this is a simple\nlittle window"
        endwin
        col_right
        window "Other window" "blue" "22%"
        append "And this is\nanother little window"
        endwin

    }
    main_loop

**How nice !**

And just with libcaca "img2txt" command, you can have fun:

![](http://cl.ly/image/1Z3P2C1E1a1I/content)

Cool, isn't it ?