runtime t/prelude.vim

let s:lines = [
            \ "<<<<<<< HEAD",
            \ "ourselves1",
            \ "=======",
            \ "themselves1",
            \ ">>>>>>> 8374eabc232",
            \ ]

lockvar s:lines

describe 'g:conflict_marker_hooks'
    before
        new
        for l in range(1, len(s:lines))
            call setline(l, s:lines[l-1])
        endfor
    end

    after
        unlet! g:conflict_marker_hooks
        close!
    end

    it 'does nothing if does not have on_detected hook'
        let g:conflict_marker_hooks = {}
        Expect 'doautocmd BufEnter' not to_throw_exception
    end

    it 'execute on_detected hook specified by string'
        let g:test_hooked = 0
        function! TestHook()
            let g:test_hooked = 1
        endfunction
        let g:conflict_marker_hooks = {'on_detected' : 'TestHook'}

        doautocmd BufEnter
        Expect g:test_hooked to_be_true
        unlet g:test_hooked
    end

    it 'execute on_detected hook specified by funcref'
        let g:test_hooked = 0
        let g:conflict_marker_hooks = {}
        function! g:conflict_marker_hooks.on_detected()
            let g:test_hooked = 1
        endfunction

        doautocmd BufEnter
        Expect g:test_hooked to_be_true
        unlet g:test_hooked
    end
end
