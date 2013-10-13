let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir
call vspec#matchers#load()
runtime plugin/conflict_marker.vim
set nocompatible
syntax on

let s:lines = [
            \ "<<<<<<< HEAD",
            \ "ourselves1",
            \ "=======",
            \ "themselves1",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ "",
            \ "<<<<<<< HEAD",
            \ "ourselves2",
            \ "=======",
            \ "themselves2",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ "",
            \ "<<<<<<< HEAD",
            \ "ourselves3",
            \ "=======",
            \ "themselves3",
            \ ">>>>>>> 8374eabc232",
            \ ]
lockvar s:lines

function! GetHighlight(line, col)
    return synIDattr(synID(a:line,a:col,1),'name')
endfunction

describe 'Conflict marker'
    before
        new
        for l in range(1, len(s:lines))
            call setline(l, s:lines[l-1])
        endfor
    end

    after
        close!
    end

    it 'is highlighted'
        doautocmd BufReadPost
        for l in [1, 3, 5, 8, 10, 12, 15, 17, 19]
            Expect GetHighlight(l, 1) ==# 'ConflictMarker'
        endfor
    end

    it 'is not highlighted if no marker is detected at BufReadPost'
        for l in [1, 3, 5, 8, 10, 12, 15, 17, 19]
            Expect GetHighlight(l, 1) !=# 'ConflictMarker'
        endfor
    end
end
