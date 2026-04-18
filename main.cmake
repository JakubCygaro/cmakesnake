function(inline_bash script output)
    execute_process(
            COMMAND bash -c "${script}"
            OUTPUT_VARIABLE _output
        )
    set(${output} ${_output} PARENT_SCOPE)
endfunction()

function(read_line var)
    if(NOT DEFINED var)
        execute_process(COMMAND ./read_line.sh)
    else()
        execute_process(COMMAND ./read_line.sh
            OUTPUT_VARIABLE _var
        )
        set(${var} ${_var} PARENT_SCOPE)
    endif()
endfunction()

message("Macieju, jak ci na imie?: ")

# read_line(line)

set(src
    "echo dupa"
    "echo -n chuj"
)

inline_bash(${src} chuj)
message("inline_bash: '${chuj}'")

# message("Twoje imie to '${line}'")

