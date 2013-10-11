if exists('g:loaded_conflict_marker')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:get(name, default)
    return get(g:, 'g:conflict_marker_'.a:name, a:default)
endfunction

let g:conflict_marker_highlight_group = s:get('highlight_group', 'Error')
let g:conflict_marker_begin = s:get('begin', '^<<<<<<< ')
let g:conflict_marker_separator = s:get('separator', '^=======$')
let g:conflict_marker_end = s:get('end', '^>>>>>>> ')

if s:get('enable_highlight', 1)
    " highlight before colorscheme is loaded
    execute 'highlight link ConflictMarker '.g:conflict_marker_highlight_group

    augroup ConflictMarkerHighlight
        autocmd!
        autocmd ColorScheme * execute 'highlight link ConflictMarker '.g:conflict_marker_highlight_group
        autocmd VimEnter,WinEnter * execute
                    \ printf('syntax match ConflictMarker containedin=ALL /\%(%s\|%s\|%s\)/',
                    \        g:conflict_marker_begin,
                    \        g:conflict_marker_separator,
                    \        g:conflict_marker_end)
    augroup END
endif

if s:get('enable_matchit', 1)
    function! s:set_conflict_marker_to_match_words()
        if exists('b:conflict_marker_match_words_loaded')
            return
        endif
        let b:match_words = get(b:, 'match_words', '')
                    \       . printf('%s:%s:%s',
                    \                g:conflict_marker_begin,
                    \                g:conflict_marker_separator,
                    \                g:conflict_marker_end)
        let b:conflict_marker_match_words_loaded = 1
    endfunction

    augroup ConflictMarkerMatchIt
        autocmd!
        autocmd BufRead,BufNew,BufNewFile * call <SID>set_conflict_marker_to_match_words()
    augroup END
endif

command! -nargs=0 ConflictMarkerThemselves call conflict_marker#themselves()
command! -nargs=0 ConflictMarkerOurselves  call conflict_marker#ourselves()
command! -nargs=0 ConflictMarkerBoth       call conflict_marker#down_together()
command! -nargs=0 ConflictMarkerNone       call conflict_marker#compromise()

if s:get('enable_mappings', 0)
    " TODO
endif

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_conflict_marker = 1
