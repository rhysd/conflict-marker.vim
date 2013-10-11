if exists('g:loaded_conflict_marker')
    finish
endif

function! s:get(name, default)
    return get(g:, 'g:conflict_marker_'.a:name, a:default)
endfunction

let g:conflict_marker_highlight_group = s:get('highlight_group', 'Error')

augroup ConflictMarkerHighlight
    autocmd!
    autocmd ColorScheme * highlight link ConflictMarker Error
    autocmd VimEnter,WinEnter * syntax match ConflictMarker containedin=ALL /^\%(<<<<<<< \|=======$\|>>>>>>> \)/
augroup END


let g:loaded_conflict_marker = 1
