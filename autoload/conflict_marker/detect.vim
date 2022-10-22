let s:save_cpo = &cpo
set cpo&vim

function! conflict_marker#detect#markers() abort
    if !g:conflict_marker_enable_detect
        return
    endif
    let view = winsaveview()
    try
        keepjumps call cursor(1, 1)
        for marker in [g:conflict_marker_begin, g:conflict_marker_separator, g:conflict_marker_end]
            if search(marker, 'cW') == 0
                return 0
            endif
        endfor

        return 1
    finally
        call winrestview(view)
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
