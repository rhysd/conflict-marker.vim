if exists('g:loaded_conflict_marker')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:get(name, default)
    return get(g:, 'conflict_marker_'.a:name, a:default)
endfunction

let g:conflict_marker_highlight_group = s:get('highlight_group', 'Error')
let g:conflict_marker_begin = s:get('begin', '^<<<<<<< \@=')
let g:conflict_marker_separator = s:get('separator', '^=======$')
let g:conflict_marker_end = s:get('end', '^>>>>>>> \@=')

command! -nargs=0 ConflictMarkerThemselves call conflict_marker#themselves()
command! -nargs=0 ConflictMarkerOurselves  call conflict_marker#ourselves()
command! -nargs=0 ConflictMarkerBoth       call conflict_marker#down_together()
command! -nargs=0 ConflictMarkerNone       call conflict_marker#compromise()
command! -nargs=0 ConflictMarkerNextHunk   call conflict_marker#next_conflict()
command! -nargs=0 ConflictMarkerPrevHunk   call conflict_marker#previous_conflict()

nnoremap <silent><Plug>(conflict-marker-themselves) :<C-u>call conflict_marker#themselves()<CR>
nnoremap <silent><Plug>(conflict-marker-ourselves)  :<C-u>call conflict_marker#ourselves()<CR>
nnoremap <silent><Plug>(conflict-marker-both)       :<C-u>call conflict_marker#down_together()<CR>
nnoremap <silent><Plug>(conflict-marker-none)       :<C-u>call conflict_marker#compromise()<CR>
nnoremap <silent><Plug>(conflict-marker-next-hunk)  :<C-u>call conflict_marker#next_conflict()<CR>
nnoremap <silent><Plug>(conflict-marker-prev-hunk)  :<C-u>call conflict_marker#previous_conflict()<CR>

function! s:detect_marker()
    if exists('b:conflict_marker_exists')
        return b:conflict_marker_exists
    endif

    let pos_save = getpos('.')
    try
        keepjumps normal! gg
        for marker in [g:conflict_marker_begin, g:conflict_marker_separator, g:conflict_marker_end]
            if search(marker, 'cW') == 0
                let b:conflict_marker_exists = 0
                return 0
            endif
        endfor
        let b:conflict_marker_exists = 1
        return 1
    finally
        call setpos('.', pos_save)
    endtry
endfunction

augroup ConflictMarkerDetect
    autocmd!
    autocmd BufReadPost * if s:detect_marker() | call s:hook_on_detected() | endif
augroup END

if s:get('enable_highlight', 1)
    " highlight before colorscheme is loaded
    execute 'highlight link ConflictMarker '.g:conflict_marker_highlight_group

    augroup ConflictMarkerHighlight
        autocmd!
        autocmd ColorScheme * if s:detect_marker() |
                    \ execute 'highlight link ConflictMarker '.g:conflict_marker_highlight_group
                    \ | endif
        autocmd BufReadPost * if s:detect_marker() | execute
                    \ printf('syntax match ConflictMarker containedin=ALL /\%(%s\|%s\|%s\)/',
                    \        g:conflict_marker_begin,
                    \        g:conflict_marker_separator,
                    \        g:conflict_marker_end)
                    \ | endif
    augroup END
endif

if s:get('enable_matchit', 1)
    function! s:set_conflict_marker_to_match_words()
        if ! exists('g:loaded_matchit')
            runtime macros/matchit.vim
            if ! exists('g:loaded_matchit')
                " matchit.vim doesn't exists. remove autocmd
                autocmd! ConflictMarkerMatchIt
            endif
        endif

        if exists('b:conflict_marker_match_words_loaded')
            return
        endif

        let b:match_words = get(b:, 'match_words', '')
                    \       . printf(',%s:%s:%s',
                    \                g:conflict_marker_begin,
                    \                g:conflict_marker_separator,
                    \                g:conflict_marker_end)
        let b:conflict_marker_match_words_loaded = 1
    endfunction

    augroup ConflictMarkerMatchIt
        autocmd!
        autocmd BufReadPost * if s:detect_marker() | call s:set_conflict_marker_to_match_words() | endif
    augroup END
endif

if s:get('enable_hooks', 1)
    function! s:hook_on_detected()
        if s:get('enable_mappings', 1)
            nmap <buffer>]x <Plug>(conflict-marker-next-hunk)
            nmap <buffer>[x <Plug>(conflict-marker-prev-hunk)
            nmap <buffer>ct <Plug>(conflict-marker-themselves)
            nmap <buffer>co <Plug>(conflict-marker-ourselves)
            nmap <buffer>cn <Plug>(conflict-marker-none)
            nmap <buffer>cb <Plug>(conflict-marker-both)
        endif

        if exists('g:conflict_marker_hooks') && has_key(g:conflict_marker_hooks, 'on_detected')
            if type(g:conflict_marker_hooks.on_detected) == type('')
                call call(function(g:conflict_marker_hooks.on_detected), [])
            else
                call call(g:conflict_marker_hooks.on_detected, [], {})
            endif
        endif
    endfunction

    augroup ConflictMarkerDetect
        autocmd!
        autocmd BufReadPost * if s:detect_marker() | call s:hook_on_detected() | endif
    augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_conflict_marker = 1
