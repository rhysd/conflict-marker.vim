let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir
call vspec#matchers#load()
runtime plugin/conflict_marker.vim

let s:lines = [
            \ "",
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
            \ "",
            \ ]

lockvar s:lines

describe ':ConflictMarkerNextHunk'
    before
        new
        for l in range(1, len(s:lines))
            call setline(l, s:lines[l-1])
        endfor
    end

    after
        close!
    end

    it 'move cursor to next hunk'
        normal! gg
        for l in [2, 9, 16]
            ConflictMarkerNextHunk
            Expect line('.') == l
        endfor
    end

    it 'doesn''t move cursor at the end of buffer'
        normal! G
        ConflictMarkerNextHunk
        Expect line('.') == line('$')
    end

    it 'doesn''t accept at cursor'
        normal! ggj
        ConflictMarkerNextHunk
        Expect line('.') == 9
    end

    it 'with bang accepts at cursor'
        normal! ggj
        ConflictMarkerNextHunk!
        Expect line('.') == 2
    end
end

describe ':ConflictMarkerPrevHunk'
    before
        new
        for l in range(1, len(s:lines))
            call setline(l, s:lines[l-1])
        endfor
    end

    after
        close!
    end

    it 'move cursor to previous hunk'
        normal! G
        for l in [16, 9, 2]
            ConflictMarkerPrevHunk
            Expect line('.') == l
        endfor
    end

    it 'doesn''t move cursor at the top of buffer'
        normal! gg
        ConflictMarkerPrevHunk
        Expect line('.') == 1
    end

    it 'doesn''t accept at cursor'
        normal! Gk
        ConflictMarkerPrevHunk
        Expect line('.') == 9
    end

    it 'with bang accepts at cursor'
        normal! Gk
        ConflictMarkerPrevHunk!
        Expect line('.') == 16
    end
end
