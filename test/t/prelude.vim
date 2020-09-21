if !exists('s:root_dir')
    let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
    execute 'set' 'rtp +=./'.s:root_dir
endif

call vspec#matchers#load()

if $PROFILE_LOG !=# '' && !exists('s:profile_did_setup')
    execute 'profile' 'start' $PROFILE_LOG
    execute 'profile!' 'file' './' . s:root_dir . '/autoload/conflict_marker.vim'
    execute 'profile!' 'file' './' . s:root_dir . '/autoload/conflict_marker/detect.vim'
    execute 'profile!' 'file' './' . s:root_dir . '/plugin/conflict_marker.vim'
    let s:profile_did_setup = 1
endif

runtime plugin/conflict_marker.vim

