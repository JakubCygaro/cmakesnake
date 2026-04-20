function(bash script output)
    execute_process(
        COMMAND bash -c "${script}"
        OUTPUT_VARIABLE _output
    )
    set(${output} ${_output} PARENT_SCOPE)

endfunction()

function(bash_no script)
    execute_process(
        COMMAND bash -c "${script}"
    )
endfunction()

function(echo input)
    bash_no(
        "echo '${input}' "
    )
endfunction()

function(clear)
    bash_no(
        "clear"
    )
endfunction()

function(sleep t)
    bash_no(
        "sleep ${t}"
    )
endfunction()

function(read_line line)
    bash(
        "                   \
            read line;      \
            echo -n $line   \
        "
        output
    )
    set(${line} ${output} PARENT_SCOPE)
endfunction()

function(read_key key)
    bash(
        "                   \
            read -sn1 k;      \
            echo -n $k   \
        "
        output
    )
    set(${key} ${output} PARENT_SCOPE)
endfunction()

function(read_keynb key)
    bash(
        "                   \
            read -sn1 -t 0.02 k;      \
            echo -n $k   \
        "
        output
    )
    set(${key} ${output} PARENT_SCOPE)
endfunction()
