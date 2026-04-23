#!/usr/bin/cmake -P

cmake_minimum_required(VERSION 3.80)
include(extern.cmake)
include(rng.cmake)

set(GRID_SIZE 8)
set(GAME_OVER NO)
set(RNG_SEED 69420)
string(TIMESTAMP RNG_SEED "%H%M%S")

set(SNAKE 4 4)
set(FOOD 1 1)
set(DIRECTION "RIGHT")
set(SCORE 0)

list(LENGTH SNAKE SNAKE_LEN)

function(wrap_pos val min max out)
    if(${val} LESS ${min})
        set(${out} ${max} PARENT_SCOPE)
    elseif(${val} GREATER ${max})
        set(${out} ${min} PARENT_SCOPE)
    endif()

endfunction()

macro(check_head_body_collision)
    set(collision FALSE)

    set(elem 2)
    list(LENGTH SNAKE elems)

    while(${elem} LESS elems)
        math(EXPR elem_1 "${elem} + 1")
        list(GET SNAKE ${elem} elem_x)
        list(GET SNAKE ${elem_1} elem_y)

        # message("head(${x} ${y}) elem(${elem_x} ${elem_y})")
        if(${y} EQUAL ${elem_y} AND ${x} EQUAL ${elem_x})
            # message("CHUJ")
            set(collision TRUE)
        endif()

        math(EXPR elem "${elem} + 2")
    endwhile()
endmacro()

macro(check_eat)
    set(eated FALSE)

    list(GET FOOD 0 food_x)
    list(GET FOOD 1 food_y)

    if(${y} EQUAL ${food_y} AND ${x} EQUAL ${food_x})
        set(eated TRUE)
    endif()
endmacro()

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

    check_eat()
    if(NOT ${eated})
        list(POP_BACK SNAKE) # remove last y
        list(POP_BACK SNAKE) # remove last x
    else()
        scatter_food()
        math(EXPR SCORE "${SCORE} + 1")
    endif()


    list(PREPEND SNAKE ${y})
    list(PREPEND SNAKE ${x})

    check_head_body_collision()
    if(${collision})
        set(GAME_OVER YES)
    endif()

endmacro()

macro(update)
    read_keynb(current_key)

    if (current_key STREQUAL "q")
        set(GAME_OVER YES)
    elseif(current_key STREQUAL "a" AND NOT ${DIRECTION} STREQUAL "RIGHT")
        set(DIRECTION "LEFT")
    elseif(current_key STREQUAL "d" AND NOT ${DIRECTION} STREQUAL "LEFT")
        set(DIRECTION "RIGHT")
    elseif(current_key STREQUAL "s" AND NOT ${DIRECTION} STREQUAL "UP")
        set(DIRECTION "DOWN")
    elseif(current_key STREQUAL "w" AND NOT ${DIRECTION} STREQUAL "DOWN")
        set(DIRECTION "UP")
    endif()

    if(NOT DIRECTION STREQUAL "NONE")
        move_snake()
    endif()

endmacro()

macro(scatter_food)
    lcg(${RNG_SEED} RNG_SEED)
    math(EXPR _rx "${RNG_SEED} % 8")
    list(INSERT FOOD 0 ${_rx})
    lcg(${RNG_SEED} RNG_SEED)
    math(EXPR _ry "${RNG_SEED} % 8")
    list(INSERT FOOD 1 ${_ry})
endmacro()

macro(check_parts)
    set(elem 0)
    set(check FALSE)

    list(LENGTH snake elems)

    while(${elem} LESS elems)
        math(EXPR elem_1 "${elem} + 1")
        list(GET snake ${elem} x)
        list(GET snake ${elem_1} y)

        if(${line_c} EQUAL ${y} AND ${col_c} EQUAL ${x})
            set(check TRUE)
        endif()

        math(EXPR elem "${elem} + 2")
    endwhile()
endmacro()


macro(check_food_draw)
    set(food_check FALSE)

    list(GET food 0 food_x)
    list(GET food 1 food_y)

    if(${line_c} EQUAL ${food_y} AND ${col_c} EQUAL ${food_x})
        set(food_check TRUE)
    endif()
endmacro()

function(draw)
    clear()
    set(snake ${SNAKE} PARENT_SCOPE)
    set(food ${FOOD} PARENT_SCOPE)
    list(GET snake 0 x)
    list(GET snake 1 y)
    set(line_c 7)
    while(${line_c} GREATER_EQUAL 0)
        set(line "")
        set(col_c 0)
        while(${col_c} LESS 8)

            check_food_draw()
            check_parts()
            if(${check})
                string(APPEND line "X")
            elseif(${food_check})
                string(APPEND line "F")
            else()
                string(APPEND line " ")
            endif()

            math(EXPR col_c "${col_c} + 1")
        endwhile()
        math(EXPR line_c "${line_c} - 1")
        message("${line}")
    endwhile()
endfunction()


while(NOT ${GAME_OVER})
    update()
    draw()
    message("SCORE: ${SCORE}")
    sleep("0.1s")
endwhile()
message("GAME OVER")

