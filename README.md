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

![](http://imgur.com/TDV81DQ.png)

[Click here for the source](../blob/master/bashbar.sh)

### Another Example

this capture shows you that you can do whatever you want:

![](http://imgur.com/pM1nzTn.png)

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

![](http://i.imgur.com/0gNHg3l.png)

(Note by frdmn: Couldn't get the `img2txt` working so I just ignored that...)

[Click here for the source](../blob/master/wintest.sh)

## Howto

[Check out the wiki](https://github.com/frdmn/simplecurses/wiki) for some basic tutorials and informations, written by [Metal3d](https://code.google.com/u/Metal3d/).