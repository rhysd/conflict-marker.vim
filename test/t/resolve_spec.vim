runtime t/prelude.vim

let g:lines_diff2 = [
            \ "<<<<<<< HEAD",
            \ "ourselves",
            \ "=======",
            \ "themselves",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ ]

lockvar g:lines_diff2

let g:lines_diff3 = [
            \ "<<<<<<< HEAD",
            \ "ourselves",
            \ "||||||| base",
            \ "ancestors",
            \ "=======",
            \ "themselves",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ ]

lockvar g:lines_diff3

function! s:load(lines)
    new
    for l in range(1, len(a:lines))
        call setline(l, a:lines[l-1])
    endfor
    doautocmd BufEnter
endfunction

describe ':ConflictMarkerThemselves'
    context 'applying to diff2'
        before
            call s:load(g:lines_diff2)
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
            Expect getline(1, '$') == g:lines_diff2
        end
    end

    context 'applying to diff3'
        before
            call s:load(g:lines_diff3)
        end

        after
            close!
        end

        it 'resolves a conflict with themselves strategy'
            ConflictMarkerThemselves
            Expect getline(1, '$') == ['themselves', '']
        end
    end
end

describe ':ConflictMarkerOurselves'
    context 'applying to diff2'
        before
            call s:load(g:lines_diff2)
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
            Expect getline(1, '$') == g:lines_diff2
        end
    end

    context 'applying to diff3'
        before
            call s:load(g:lines_diff3)
        end

        after
            close!
        end

        it 'resolves a conflict with ourselves strategy'
            ConflictMarkerOurselves
            Expect getline(1, '$') == ['ourselves', '']
        end
    end
end

describe ':ConflictMarkerNone'
    context 'applying to diff2'
        before
            call s:load(g:lines_diff2)
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
            Expect getline(1, '$') == g:lines_diff2
        end
    end

    context 'applying to diff3'
        before
            call s:load(g:lines_diff3)
        end

        after
            close!
        end

        it 'resolves a conflict by removing both modifications'
            ConflictMarkerNone
            Expect getline(1, '$') == ['']
        end
    end
end

describe ':ConflictMarkerBoth'
    context 'applying to diff2'
        before
            call s:load(g:lines_diff2)
        end

        after
            close!
        end

        it 'resolves a conflict by keeping theirs and ours'
            ConflictMarkerBoth
            Expect getline(1, '$') == ['ourselves', 'themselves', '']
        end

        it 'makes no change out of marker'
            normal! G
            ConflictMarkerBoth
            Expect getline(1, '$') == g:lines_diff2
        end

        context 'with bang'
            it 'resolves a conflict by keeping theirs and ours in reverse order'
                ConflictMarkerBoth!
                Expect getline(1, '$') == ['themselves', 'ourselves', '']
            end

            it 'makes no change out of marker'
                normal! G
                ConflictMarkerBoth!
                Expect getline(1, '$') == g:lines_diff2
            end
        end
    end

    context 'applying to diff3'
        before
            call s:load(g:lines_diff3)
        end

        after
            close!
        end

        it 'resolves a conflict by keeping theirs and ours'
            ConflictMarkerBoth
            Expect getline(1, '$') == ['ourselves', 'themselves', '']
        end

        context 'with bang'
            it 'resolves a conflict by keeping theirs and ours in reverse order'
                ConflictMarkerBoth!
                Expect getline(1, '$') == ['themselves', 'ourselves', '']
            end
        end
    end
end
