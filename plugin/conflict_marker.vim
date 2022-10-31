if exists('g:loaded_conflict_marker')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:var(name, default)
    let g:conflict_marker_{a:name} = get(g:, 'conflict_marker_'.a:name, a:default)
endfunction

call s:var('highlight_group', 'Error')
call s:var('begin', '^<<<<<<<')
call s:var('common_ancestors', '^|||||||')
call s:var('separator', '^=======$')
call s:var('end', '^>>>>>>>')
call s:var('enable_mappings', 1)
call s:var('enable_hooks', 1)
call s:var('enable_highlight', 1)
call s:var('enable_matchit', 1)
call s:var('enable_detect', 1)

command! -nargs=0 ConflictMarkerThemselves     call conflict_marker#themselves()
command! -nargs=0 ConflictMarkerOurselves      call conflict_marker#ourselves()
command! -nargs=0 -bang ConflictMarkerBoth     call conflict_marker#compromise(<bang>0)
command! -nargs=0 ConflictMarkerNone           call conflict_marker#down_together()
command! -nargs=0 -bang ConflictMarkerNextHunk call conflict_marker#next_conflict(<bang>0)
command! -nargs=0 -bang ConflictMarkerPrevHunk call conflict_marker#previous_conflict(<bang>0)

nnoremap <silent><Plug>(conflict-marker-themselves) :<C-u>ConflictMarkerThemselves<CR>
nnoremap <silent><Plug>(conflict-marker-ourselves)  :<C-u>ConflictMarkerOurselves<CR>
nnoremap <silent><Plug>(conflict-marker-both)       :<C-u>ConflictMarkerBoth<CR>
nnoremap <silent><Plug>(conflict-marker-both-rev)   :<C-u>ConflictMarkerBoth!<CR>
nnoremap <silent><Plug>(conflict-marker-none)       :<C-u>ConflictMarkerNone<CR>
nnoremap <silent><Plug>(conflict-marker-next-hunk)  :<C-u>ConflictMarkerNextHunk<CR>
nnoremap <silent><Plug>(conflict-marker-prev-hunk)  :<C-u>ConflictMarkerPrevHunk<CR>

function! s:execute_hooks()
    if g:conflict_marker_enable_mappings
        nmap <buffer>]x <Plug>(conflict-marker-next-hunk)
        nmap <buffer>[x <Plug>(conflict-marker-prev-hunk)
        nmap <buffer>ct <Plug>(conflict-marker-themselves)
        nmap <buffer>co <Plug>(conflict-marker-ourselves)
        nmap <buffer>cn <Plug>(conflict-marker-none)
        nmap <buffer>cb <Plug>(conflict-marker-both)
        nmap <buffer>cB <Plug>(conflict-marker-both-rev)
    endif

    if exists('g:conflict_marker_hooks') && has_key(g:conflict_marker_hooks, 'on_detected')
        if type(g:conflict_marker_hooks.on_detected) == type('')
            call call(function(g:conflict_marker_hooks.on_detected), [])
        else
            call call(g:conflict_marker_hooks.on_detected, [], {})
        endif
    endif
endfunction

function! s:set_conflict_marker_to_match_words()
    if ! exists('g:loaded_matchit')
        runtime macros/matchit.vim
        if ! exists('g:loaded_matchit')
            " matchit.vim doesn't exists. remove autocmd
            let g:conflict_marker_enable_matchit = 0
        endif
    endif

    if exists('b:conflict_marker_match_words_loaded')
        return
    endif

    let b:match_words = get(b:, 'match_words', '')
                \       . printf(',%s:%s:%s:%s',
                \                g:conflict_marker_begin,
                \                g:conflict_marker_common_ancestors,
                \                g:conflict_marker_separator,
                \                g:conflict_marker_end)
    let b:conflict_marker_match_words_loaded = 1
endfunction

function! s:create_highlight_links()
    if exists('g:conflict_marker_highlight_group') && strlen(g:conflict_marker_highlight_group)
        execute 'highlight default link ConflictMarkerBegin '.g:conflict_marker_highlight_group
        execute 'highlight default link ConflictMarkerCommonAncestors '.g:conflict_marker_highlight_group
        execute 'highlight default link ConflictMarkerSeparator '.g:conflict_marker_highlight_group
        execute 'highlight default link ConflictMarkerEnd '.g:conflict_marker_highlight_group
    endif
endfunction

function! s:on_detected()
    if g:conflict_marker_enable_hooks
        call s:execute_hooks()
    endif

    if g:conflict_marker_enable_highlight
        execute printf('syntax match ConflictMarkerBegin containedin=ALL /%s/',
                \      g:conflict_marker_begin)
        execute printf('syntax region ConflictMarkerOurs containedin=ALL start=/%s/hs=e+1 end=/%s\&/',
                \      g:conflict_marker_begin,
                \      g:conflict_marker_separator)
        execute printf('syntax match ConflictMarkerCommonAncestors containedin=ALL /%s/',
                \      g:conflict_marker_common_ancestors)
        execute printf('syntax region ConflictMarkerCommonAncestorsHunk containedin=ALL start=/%s/hs=e+1 end=/%s\&/',
                \      g:conflict_marker_common_ancestors,
                \      g:conflict_marker_separator)
        execute printf('syntax match ConflictMarkerSeparator containedin=ALL /%s/',
                \      g:conflict_marker_separator)
        execute printf('syntax region ConflictMarkerTheirs containedin=ALL start=/%s/hs=e+1 end=/%s\&/',
                \      g:conflict_marker_separator,
                \      g:conflict_marker_end)
        execute printf('syntax match ConflictMarkerEnd containedin=ALL /%s/',
                \      g:conflict_marker_end)

        call s:create_highlight_links()
    endif

    if g:conflict_marker_enable_matchit
        call s:set_conflict_marker_to_match_words()
    endif
endfunction

augroup ConflictMarkerDetect
    autocmd!
    autocmd BufReadPost,FileChangedShellPost,ShellFilterPost,StdinReadPost * if conflict_marker#detect#markers()
                \ | call s:on_detected()
                \ | endif
augroup END

if g:conflict_marker_enable_highlight
    call s:create_highlight_links()
endif

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_conflict_marker = 1
