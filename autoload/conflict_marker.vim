" Note:
" In this plugin, position of marker is treated with [line, col], not line.
" This is because some markers may be not linewise but characterwise.
" I consider the extensibility of this plugin and markers are customizable,
" I don't throw the possibility of characterwise conflict hunks away.

function! s:current_conflict_begin()
    let begin = searchpos(g:conflict_marker_begin, 'bcnW')
    let before_end = searchpos(g:conflict_marker_end, 'bnW')

    if begin == [0, 0] || (before_end != [0, 0] && before_end[0] > begin[0])
        return [0, 0]
    endif

    return begin
endfunction

function! s:current_conflict_end()
    let after_begin = searchpos(g:conflict_marker_begin, 'nW')
    let end = searchpos(g:conflict_marker_end, 'cnW')

    if end == [0, 0] || (after_begin != [0, 0] && end[0] > after_begin[0])
        return [0, 0]
    endif

    return end
endfunction

function! s:current_conflict_separator()
    " when separator is before cursor
    let before_begin = s:current_conflict_begin()
    let before_sep = searchpos(g:conflict_marker_separator, 'bcnW')
    if before_sep != [0, 0] && before_begin != [0, 0] && before_begin[0] < before_sep[0]
        return before_sep
    endif

    " when separator is after cursor
    let after_end = s:current_conflict_end()
    let after_sep = searchpos(g:conflict_marker_separator, 'cnW')
    if after_sep != [0, 0] && after_end != [0, 0] && after_sep[0] < after_end[0]
        return after_sep
    endif

    return [0, 0]
endfunction

function! s:valid_hunk(hunk)
    return filter(copy(a:hunk), 'v:val == [0, 0]') == []
endfunction

function! conflict_marker#markers()
    return [s:current_conflict_begin(), s:current_conflict_separator(), s:current_conflict_end()]
endfunction

" Note: temporary implementation, linewise
function! conflict_marker#themselves()
    let markers = conflict_marker#markers()
    if ! s:valid_hunk(markers) | return | endif
    execute markers[2][0].'delete'
    execute markers[0][0].','.markers[1][0].'delete'
endfunction

" Note: temporary implementation, linewise
function! conflict_marker#ourselves()
    let markers = conflict_marker#markers()
    if ! s:valid_hunk(markers) | return | endif
    execute markers[1][0].','.markers[2][0].'delete'
    execute markers[0][0].'delete'
endfunction

" Note: temporary implementation, linewise
function! conflict_marker#down_together()
    let markers = conflict_marker#markers()
    if ! s:valid_hunk(markers) | return | endif
    execute markers[0][0].','.markers[2][0].'delete'
endfunction

" Note: temporary implementation, linewise
function! conflict_marker#compromise()
    let markers = conflict_marker#markers()
    if ! s:valid_hunk(markers) | return | endif
    execute markers[2][0].'delete'
    execute markers[1][0].'delete'
    execute markers[0][0].'delete'
endfunction

function! conflict_marker#next_conflict()
    throw "Not implemented"
endfunction

function! conflict_marker#previous_conflict()
    throw "Not implemented"
endfunction
