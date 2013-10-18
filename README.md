Highlight, Jump and Resolve Conflict Markers Quickly in Vim
===============================================
[![Build Status](https://travis-ci.org/rhysd/conflict-marker.vim.png)](https://travis-ci.org/rhysd/conflict-marker.vim)

conflict-marker.vim is Vim plugin for developers fighting against conflicts.
All features is available if and only if an opened buffer contains a conflict marker.

conflict-marker.vim does:
- highlight conflict markers.
- jump among conflict markers.
- jump within conflict block; beginning, separator and end of the block.
- resolve conflict with various strategies; themselves, ourselves, none and both strategies.

This plugin tries to define some mappings if a conflict marker is detected. If you don't want to use default mappings, set `g:conflict_marker_enable_mappings` to `0`.

## Highlight Conflict Markers

## Jump among Conflict Markers

`[x` and `]x` mappings are defined as default.

## Jump within a Conflict Marker

This feature uses matchit.vim, which is bundled in Vim (`macros/matchit.vim`).
`%` mapping is extened by matchit.vim.

## Resolve a Conflict with Various Strategies

This plugin defines mappings as default, `ct` for themselves, `co` for ourselves, `cn` for none and `cb` for both.

### Themselves

```
<<<<<<< HEAD
ourselves
=======
themselves
>>>>>>> deadbeef0123
```

↓`ct`

```
themselves
```

### Ourselves

```
<<<<<<< HEAD
ourselves
=======
themselves
>>>>>>> deadbeef0123
```

↓`ot`

```
ourselves
```

### Adopt Both

```
<<<<<<< HEAD
ourselves
=======
themselves
>>>>>>> deadbeef0123
```

↓cb`

```
ourselves
themselves
```

### Adopt None

```
<<<<<<< HEAD
ourselves
=======
themselves
>>>>>>> deadbeef0123
```

↓`nb`

```
```

## Customize

## License

This plugin is distributed under MIT license.

> Copyright (c) 2013 rhysd
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
> CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
> TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
> SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
