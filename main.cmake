#!/usr/bin/cmake -P

cmake_minimum_required(VERSION 3.80)
include(extern.cmake)

set(GRID_SIZE 8)
set(GAME_OVER NO)

set(SNAKE 4 4)
set(DIRECTION "RIGHT")

list(LENGTH SNAKE SNAKE_LEN)

function(wrap_pos val min max out)
    if(${val} LESS ${min})
        set(${out} ${max} PARENT_SCOPE)
    elseif(${val} GREATER ${max})
        set(${out} ${min} PARENT_SCOPE)
    endif()

endfunction()

macro(move_snake)
    list(GET SNAKE 0 head_x)
    list(GET SNAKE 1 head_y)
    if(DIRECTION STREQUAL "LEFT")
        math(EXPR head_x "${head_x} - 1")
    elseif(DIRECTION STREQUAL "RIGHT")
        math(EXPR head_x "${head_x} + 1")
    elseif(DIRECTION STREQUAL "DOWN")
        math(EXPR head_y "${head_y} - 1")
    elseif(DIRECTION STREQUAL "UP")
        math(EXPR head_y "${head_y} + 1")
    endif()

    set(x ${head_x})
    set(y ${head_y})
    wrap_pos(head_x 0 7 x)
    wrap_pos(head_y 0 7 y)

    list(POP_BACK SNAKE) # remove last y
    list(POP_BACK SNAKE) # remove last x
    list(PREPEND SNAKE ${y})
    list(PREPEND SNAKE ${x})

endmacro()

macro(update)
    read_keynb(current_key)

    if (current_key STREQUAL "q")
        set(GAME_OVER YES)
    elseif(current_key STREQUAL "a")
        set(DIRECTION "LEFT")
    elseif(current_key STREQUAL "d")
        set(DIRECTION "RIGHT")
    elseif(current_key STREQUAL "s")
        set(DIRECTION "DOWN")
    elseif(current_key STREQUAL "w")
        set(DIRECTION "UP")
    endif()

    if(NOT DIRECTION STREQUAL "NONE")
        move_snake()
    endif()

endmacro()

function(draw)
    set(snake ${SNAKE} PARENT_SCOPE)
    list(GET snake 0 x)
    list(GET snake 1 y)
    message("HEAD: ${x} ${y}")
endfunction()


while(NOT GAME_OVER)
    update()
    draw()
endwhile()

