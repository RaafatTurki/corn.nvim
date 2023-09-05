# Corn.nvim
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

LSP diagnostics at your corner.

Get your LSP feedback the helix way, denoised, uncluttered and cornered.

![demo](https://user-images.githubusercontent.com/16624558/265285866-8257051e-b944-4759-96b7-e5a97587ea21.gif)

## Install
```lua
{ 'RaafatTurki/corn.nvim' }
```

## Setup
```lua
require 'corn'.setup()
```

## Use
```lua
require 'corn'.toggle()    -- toggle visiblity
require 'corn'.render()    -- manually invoke the renderer
```
or their vim cmds
```
:CornToggle
:CornRender
```

## Config
```lua
-- defaults
require 'corn'.setup {
  -- enable plugin auto commands
  auto_cmds = true,

  -- sorts diagnostics according to one of `severity`, `severity_reverse`, `column` or `column_reverse`
  sort_method = 'severity',

  -- highlights to use for each diagnostic severity level
  highlights = {
    error = "DiagnosticFloatingError",
    warn = "DiagnosticFloatingWarn",
    info = "DiagnosticFloatingInfo",
    hint = "DiagnosticFloatingHint",
  },

  -- icons to use for each diagnostic severity level
  icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },
}
```

## Plans
- [ ] Add a custom renderering config opt for both the window and line contents
- [ ] Add `:CornScope current_line` & `:CornScope all`
- [ ] Add a truncated/squashed rendering mode when there isn't enough space
