#!/usr/bin/cmake -P

include(extern.cmake)

set(GRID_SIZE 8)
set(GAME_OVER NO)

set(SNAKE 4 4)
set(DIRECTION "RIGHT")

list(LENGTH SNAKE SNAKE_LEN)

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
    list(POP_BACK SNAKE) # remove last y
    list(POP_BACK SNAKE) # remove last x
    list(PREPEND SNAKE ${head_y})
    list(PREPEND SNAKE ${head_x})

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

