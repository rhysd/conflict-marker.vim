let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir
call vspec#matchers#load()
runtime plugin/conflict_marker.vim

let s:lines = [
            \ "<<<<<<< HEAD",
            \ "ourselves1",
            \ "=======",
            \ "themselves1",
            \ ">>>>>>> 8374eabc232",
            \ ]

lockvar s:lines

let s:lines_diff3 = [
            \ "<<<<<<< HEAD",
            \ "ourselves1",
            \ "||||||| merged common ancestors",
            \ "common ancestors1",
            \ "=======",
            \ "themselves1",
            \ ">>>>>>> 8374eabc232",
            \ ]

lockvar s:lines_diff3

describe 'matchit'
    before
        new
        for l in range(1, len(s:lines))
            call setline(l, s:lines[l-1])
        endfor
        doautocmd BufEnter
    end

    after
        close!
    end

    it 'defines b:match_words'
        Expect 'b:match_words' to_exist
        Expect b:match_words =~# ',^<<<<<<<:^||||||| .*$:^=======$:^>>>>>>>'
    end

    it 'can jump within a conflict marker'
        normal! gg
        normal %
        Expect line('.') == 3
        normal %
        Expect line('.') == 5
        normal %
        Expect line('.') == 1
        normal %
        Expect line('.') == 3
    end
end

describe 'matchit with diff3'
    before
        new
        for l in range(1, len(s:lines_diff3))
            call setline(l, s:lines_diff3[l-1])
		endfor
        doautocmd BufEnter
    end

    after
        close!
    end

    it 'defines b:match_words'
        Expect 'b:match_words' to_exist
        Expect b:match_words =~# ',^<<<<<<<:^||||||| .*$:^=======$:^>>>>>>>'
    end

    it 'can jump within a conflict marker'
        normal! gg
        normal %
        Expect line('.') == 3
        normal %
        Expect line('.') == 5
        normal %
        Expect line('.') == 7
        normal %
        Expect line('.') == 1
    end
end
