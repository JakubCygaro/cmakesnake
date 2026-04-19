#!/usr/bin/cmake -P

function(bash script output)
    execute_process(
        COMMAND bash -c "${script}"
        OUTPUT_VARIABLE _output
    )
    set(${output} ${_output} PARENT_SCOPE)

endfunction()

function(read_line line)
    bash("\
            read line;\
            echo -n $line\
        "
        output
    )
    set(${line} ${output} PARENT_SCOPE)
endfunction()

message("What is your name?:")

read_line(line)

message("Your name is '${line}'")
