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
end
