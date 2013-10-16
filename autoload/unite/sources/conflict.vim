let s:save_cpo = &cpo
set cpo&vim

let s:source = {
            \ 'name' : 'conflict',
            \ 'description' : 'conflicts in current buffer',
            \ 'default_kind' : 'jump_list',
            \ 'hooks' : {},
            \ }

function! unite#sources#conflict#define()
    return s:source
endfunction

function! s:source.hooks.on_init(args, context)
    echomsg expand('%:p')
    if ! conflict_marker#detect#markers()
        return
    endif

    let a:context.source__path = expand('%:p')
    let a:context.source__bufnr = bufnr('%')

    let pos_save = getpos('.')
    let a:context.source__markers = []
    normal! gg

    while 1
        let pos = getpos('.')
        call conflict_marker#next_conflict()
        if pos == getpos('.')
            break
        endif
        let end_line = search(g:conflict_marker_end, 'cWn')
        call add(a:context.source__markers, [getline('.'), line('.')])
        call add(a:context.source__markers, [getline(end_line), end_line])
    endwhile

    call setpos('.', pos_save)
endfunction

function! s:source.gather_candidates(args, context)
    if ! has_key(a:context, 'source__markers')
        return []
    endif

    return map(a:context.source__markers, "{
                \ 'word' : v:val[0].' (line:'.v:val[1].')',
                \ 'action__path' : a:context.source__path,
                \ 'action__buffer_nr' : a:context.source__bufnr,
                \ 'action__line' : v:val[1],
                \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
