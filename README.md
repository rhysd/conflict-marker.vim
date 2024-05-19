conflict-marker.vim
===================
[![CI](https://github.com/rhysd/conflict-marker.vim/workflows/CI/badge.svg?event=push)](https://github.com/rhysd/conflict-marker.vim/actions?query=workflow%3ACI)
[![Coverage](https://codecov.io/gh/rhysd/conflict-marker.vim/branch/master/graph/badge.svg)](https://codecov.io/gh/rhysd/conflict-marker.vim)

Highlight, jump and resolve conflict markers quickly.

[conflict-marker.vim](https://github.com/rhysd/conflict-marker.vim) is Vim plugin for developers fighting against conflicts.
All features are available if and only if an opened buffer contains a conflict marker.

conflict-marker.vim does:
- highlight conflict markers.
- jump among conflict markers.
- jump within conflict block; beginning, separator and end of the block.
- resolve conflict with various strategies; theirs, ours, none and both strategies.
- support both `diff2` (Git default) and [`diff3`](https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging) conflict styles.

This plugin tries to define some mappings if a conflict marker is detected.
If you don't want to use default mappings, set `g:conflict_marker_enable_mappings` to `0`.

## Installation

Please copy below files to corresponding directories in your "~/.vim" directory.

- plugin/conflict_marker.vim
- autoload/conflict_marker.vim
- autoload/conflict_marker/detect.vim
- autoload/unite/sources/conflict.vim (if you use unite.vim)
- doc/conflict-marker.txt

Please do `:helptags ~/.vim/doc` to generate help tags.

If you use a plugin manager, please follow its instruction and documentation to install.
For example, you can install this plugin with [neobundle.vim](https://github.com/Shougo/neobundle.vim).

```vim
NeoBundle 'rhysd/conflict-marker.vim'
```

## Conflict Markers

Conflict markers can be customized using the following options:

```vim
" Default values
let g:conflict_marker_begin = '^<<<<<<< \@='
let g:conflict_marker_common_ancestors = '^||||||| .*$'
let g:conflict_marker_separator = '^=======$'
let g:conflict_marker_end   = '^>>>>>>> \@='
```

## Highlight Conflict Markers

Conflict markers are highlighted by default. Use the following option to disable
highlighting:

```vim
let g:conflict_marker_enable_highlight = 0
```

Each conflict marker and conflict part is associated to a specific syntax group:

| marker / part | syntax group |
|------|--------------|
| begin conflict marker (`<<<<<<<`) | `ConflictMarkerBegin` |
| *ours* part of the conflict | `ConflictMarkerOurs` |
| common ancestors marker (`\|\|\|\|\|\|\|`) | `ConflictMarkerCommonAncestors` |
| common ancestors part of the conflict | `ConflictMarkerCommonAncestorsHunk` |
| separator conflict marker (`=======`) | `ConflictMarkerSeparator` |
| *theirs* part of the conflict | `ConflictMarkerTheirs` |
| end conflict marker (`>>>>>>>`) | `ConflictMarkerEnd` |

By default, `ConflictMarkerBegin`, `ConflictMarkerSeparator`,
`ConflictMarkerCommonAncestors` and `ConflictMarkerEnd` are
linked to the `Error` syntax group.
To link them to another syntax group, use the following option:

```vim
" Default value
let g:conflict_marker_highlight_group = 'Error'
```

`ConflictMarkerOurs`, `ConflictMarkerTheirs`, and
`ConflictMarkerCommonAncestors` are not linked to any syntax group by default,
and can be used to customize the highlight of the *ours* and *theirs*
parts of the conflict.

To use a specific highlight for each marker, disable the default highlight
group, and define your own highlights for each syntax group.

**Example:**

```vim
" disable the default highlight group
let g:conflict_marker_highlight_group = ''

" Include text after begin and end markers
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'

highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
```

![Screenshot_20190911_212653](https://user-images.githubusercontent.com/454315/64728297-f8953d80-d4da-11e9-9033-df5bfdee2f7a.png)

## Jump among Conflict Markers

`[x` and `]x` mappings are defined as default. Use the following option to
disable them:

```vim
let g:conflict_marker_enable_mappings = 0
```

## Jump within a Conflict Marker

This feature uses matchit.vim, which is bundled in Vim (`macros/matchit.vim`).
`%` mapping is extended by matchit.vim. Use the following option to disable this
feature:

```vim
let g:conflict_marker_enable_matchit = 0
```

## Resolve a Conflict with Various Strategies

This plugin defines mappings as default: `ct` for theirs, `co` for ours, `cn` for
none and `cb` for both.  Use the following option to disable mappings:

```vim
let g:conflict_marker_enable_mappings = 0
```

### Theirs

```
<<<<<<< HEAD
ours
=======
theirs
>>>>>>> deadbeef0123
```

↓`ct` or `:ConflictMarkerThemselves`

```
theirs
```

### Ours

```
<<<<<<< HEAD
ours
=======
theirs
>>>>>>> deadbeef0123
```

↓`co` or `:ConflictMarkerOurselves`

```
ours
```

### Apply Both

```
<<<<<<< HEAD
ours
=======
theirs
>>>>>>> deadbeef0123
```

↓`cb` or `:ConflictMarkerBoth`

```
ours
theirs
```

### Apply Both in Reverse Order

```
<<<<<<< HEAD
ours
=======
theirs
>>>>>>> deadbeef0123
```

↓`cB` or `:ConflictMarkerBoth!`

```
theirs
ours
```

### Apply None

```
<<<<<<< HEAD
ours
=======
theirs
>>>>>>> deadbeef0123
```

↓`cn` or `:ConflictMarkerNone`

```
```

## Customize

TODO

## License

This plugin is distributed under MIT license.

```
Copyright (c) 2013 rhysd

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
