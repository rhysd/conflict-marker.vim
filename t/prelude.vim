if &compatible
    set nocompatible
endif
if !exists('s:root_dir')
    let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
    execute 'set' 'rtp +=./'.s:root_dir
endif

call vspec#matchers#load()
runtime plugin/conflict_marker.vim

