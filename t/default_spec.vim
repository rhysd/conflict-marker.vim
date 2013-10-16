let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir

call vspec#matchers#load()

runtime plugin/conflict_marker.vim

describe 'Default settings'

    it 'provide variables to customize'
        Expect 'g:loaded_conflict_marker' to_exist
        Expect 'g:conflict_marker_highlight_group' to_exist_and_default_to 'Error'
        Expect 'g:conflict_marker_begin' to_exist_and_default_to '^<<<<<<< \@='
        Expect 'g:conflict_marker_separator' to_exist_and_default_to '^=======$'
        Expect 'g:conflict_marker_end' to_exist_and_default_to '^>>>>>>> \@='
        Expect 'g:conflict_marker_enable_mappings' to_exist_and_default_to 1
        Expect 'g:conflict_marker_enable_hooks' to_exist_and_default_to 1
        Expect 'g:conflict_marker_enable_highlight' to_exist_and_default_to 1
        Expect 'g:conflict_marker_enable_matchit' to_exist_and_default_to 1
    end

    it 'provides commands'
        Expect ':ConflictMarkerThemselves' to_exist
        Expect ':ConflictMarkerOurselves' to_exist
        Expect ':ConflictMarkerBoth' to_exist
        Expect ':ConflictMarkerNone' to_exist
        Expect ':ConflictMarkerNextHunk' to_exist
        Expect ':ConflictMarkerPrevHunk' to_exist
    end

    it 'provides <Plug> mappings'
        Expect '<Plug>(conflict-marker-themselves)' to_map_in 'n'
        Expect '<Plug>(conflict-marker-ourselves)' to_map_in 'n'
        Expect '<Plug>(conflict-marker-both)' to_map_in 'n'
        Expect '<Plug>(conflict-marker-none)' to_map_in 'n'
        Expect '<Plug>(conflict-marker-next-hunk)' to_map_in 'n'
        Expect '<Plug>(conflict-marker-prev-hunk)' to_map_in 'n'
    end

    it 'provides user mappings unless g:conflict_marker_enable_mappings is 0'
        new
        let lines = [
                \ "<<<<<<< HEAD",
                \ "ourselves1",
                \ "=======",
                \ "themselves1",
                \ ">>>>>>> 8374eabc232",
                \ ]

        for l in range(1, len(lines))
            call setline(l, lines[l-1])
        endfor
        doautocmd BufReadPost

        Expect ']x' to_map_in 'n'
        Expect '[x' to_map_in 'n'
        Expect 'ct' to_map_in 'n'
        Expect 'co' to_map_in 'n'
        Expect 'cn' to_map_in 'n'
        Expect 'cb' to_map_in 'n'

        close!
    end
end
