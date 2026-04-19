#!/usr/bin/cmake -P

include(extern.cmake)

set(GRID_SIZE 8)
set(GAME_OVER NO)

set(SNAKE 4 4)

list(LENGTH SNAKE SNAKE_LEN)

macro(move_snake)
    list(GET SNAKE 0 head_x)
    list(GET SNAKE 1 head_y)
    if(direction STREQUAL "LEFT")
        math(EXPR head_x "${head_x} - 1")
    elseif(direction STREQUAL "RIGHT")
        math(EXPR head_x "${head_x} + 1")
    elseif(direction STREQUAL "DOWN")
        math(EXPR head_y "${head_y} - 1")
    elseif(direction STREQUAL "UP")
        math(EXPR head_y "${head_y} + 1")
    endif()
    list(POP_BACK SNAKE) # remove last y
    list(POP_BACK SNAKE) # remove last x
    list(PREPEND SNAKE ${head_y})
    list(PREPEND SNAKE ${head_x})

endmacro()

macro(update)
    read_keynb(current_key)

    set(direction "NONE")

    if (current_key STREQUAL "q")
        set(GAME_OVER YES)
    elseif(current_key STREQUAL "a")
        set(direction "LEFT")
    elseif(current_key STREQUAL "d")
        set(direction "RIGHT")
    elseif(current_key STREQUAL "s")
        set(direction "DOWN")
    elseif(current_key STREQUAL "w")
        set(direction "UP")
    endif()

    if(NOT direction STREQUAL "NONE")
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

