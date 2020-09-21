if exists('s:test_did_setup')
    finish
endif

let s:root_dir = expand('<sfile>:p:h:h:h')
execute 'set' 'rtp +=' . s:root_dir

call vspec#matchers#load()

if $PROFILE_LOG !=# ''
    execute 'profile' 'start' $PROFILE_LOG
    execute 'profile!' 'file' s:root_dir . '/autoload/conflict_marker/detect.vim'
    execute 'profile!' 'file' s:root_dir . '/autoload/conflict_marker.vim'
    execute 'profile!' 'file' s:root_dir . '/plugin/conflict_marker.vim'
    " This is necessary to load autoload/conflict_marker.vim again. Without it
    " the file is not profiled.
    runtime! autoload/conflict_marker.vim
endif

runtime plugin/conflict_marker.vim

let s:test_did_setup = 1
