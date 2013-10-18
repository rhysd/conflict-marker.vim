let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir
call vspec#matchers#load()
runtime plugin/conflict_marker.vim

let g:lines = [
            \ "<<<<<<< HEAD",
            \ "ourselves",
            \ "=======",
            \ "themselves",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ ]

lockvar g:lines

function! s:load()
    for l in range(1, len(g:lines))
        call setline(l, g:lines[l-1])
    endfor
endfunction

describe ':ConflictMarkerThemselves'
    before
        new
        call s:load()
        doautocmd BufRead
    end

    after
        close!
    end

    it 'resolves a conflict with themselves strategy'
        ConflictMarkerThemselves
        Expect getline(1, '$') == ['themselves', '']
    end

    it 'makes no change out of marker'
        normal! G
        ConflictMarkerThemselves
        Expect getline(1, '$') == g:lines
    end
end

describe ':ConflictMarkerOurselves'
    before
        new
        call s:load()
        doautocmd BufRead
    end

    after
        close!
    end

    it 'resolves a conflict with ourselves strategy'
        ConflictMarkerOurselves
        Expect getline(1, '$') == ['ourselves', '']
    end

    it 'makes no change out of marker'
        normal! G
        ConflictMarkerOurselves
        Expect getline(1, '$') == g:lines
    end
end

describe ':ConflictMarkerNone'
    before
        new
        call s:load()
        doautocmd BufRead
    end

    after
        close!
    end

    it 'resolves a conflict by removing both modifications'
        ConflictMarkerNone
        Expect getline(1, '$') == ['']
    end

    it 'makes no change out of marker'
        normal! G
        ConflictMarkerNone
        Expect getline(1, '$') == g:lines
    end
end

describe ':ConflictMarkerBoth'
    before
        new
        call s:load()
        doautocmd BufRead
    end

    after
        close!
    end

    it 'resolves a conflict by removing nothing'
        ConflictMarkerBoth
        Expect getline(1, '$') == ['ourselves', 'themselves', '']
    end

    it 'makes no change out of marker'
        normal! G
        ConflictMarkerBoth
        Expect getline(1, '$') == g:lines
    end
end
