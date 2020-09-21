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

let s:lines_diff3 = [
            \ "",
            \ "<<<<<<< HEAD",
            \ "ourselves1",
            \ "|||||||",
            \ "base1",
            \ "=======",
            \ "themselves1",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ "",
            \ "<<<<<<< HEAD",
            \ "ourselves2",
            \ "|||||||",
            \ "base2",
            \ "=======",
            \ "themselves2",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ "",
            \ "<<<<<<< HEAD",
            \ "ourselves3",
            \ "|||||||",
            \ "base3",
            \ "=======",
            \ "themselves3",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ ]

lockvar s:lines_diff3

function! s:setup(lines) abort
    new
    for l in range(1, len(a:lines))
        call setline(l, a:lines[l-1])
    endfor
endfunction

describe ':ConflictMarkerNextHunk'
    context 'applying to diff2'
        before
            call s:setup(s:lines)
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

    context 'applying to diff3'
        before
            call s:setup(s:lines_diff3)
        end

        after
            close!
        end

        it 'move cursor to next hunk'
            normal! gg
            for l in [2, 11, 20]
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
            Expect line('.') == 11
        end

        it 'with bang accepts at cursor'
            normal! ggj
            ConflictMarkerNextHunk!
            Expect line('.') == 2
        end
    end
end

describe ':ConflictMarkerPrevHunk'
    context 'applying to diff2'
        before
            call s:setup(s:lines)
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

    context 'applying to diff3'
        before
            call s:setup(s:lines_diff3)
        end

        after
            close!
        end

        it 'move cursor to previous hunk'
            normal! G
            for l in [20, 11, 2]
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
            Expect line('.') == 11
        end

        it 'with bang accepts at cursor'
            normal! Gk
            ConflictMarkerPrevHunk!
            Expect line('.') == 20
        end
    end
end
