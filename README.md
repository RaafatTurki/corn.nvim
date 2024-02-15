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
require 'corn'.toggle(state?)       -- toggle visiblity (true, false)
require 'corn'.scope(scope_type)    -- change scope type ("line", "file")
require 'corn'.scope_cycle()        -- cycle scope type
require 'corn'.render()             -- manually invoke the renderer
```
or their vim cmds
```
:Corn toggle [on|off]
:Corn scope <file|line>
:Corn scope_cycle
:Corn render
```

## Config
```lua
-- defaults
require 'corn'.setup {
  -- enables plugin auto commands
  auto_cmds = true,

  -- sorts diagnostics according to a criteria. must be one of `severity`, `severity_reverse`, `column`, `column_reverse`, `line_number` or `line_number_reverse`
  sort_method = 'severity',

  -- sets the scope to be searched for diagnostics, must be one of `line` or `file`
  scope = 'line',

  -- sets the style of the border, must be one of `single`, `double`, `rounded`, `solid`, `shadow` or `none`
  border_style = 'single',

  -- sets which vim modes corn isn't allowed to render in, should contain strings like 'n', 'i', 'v', 'V' .. etc
  blacklisted_modes = {},

  -- sets which severity corn isn't allowed to render in, should contain diagnostic severities like:
  -- vim.diagnostic.severity.HINT
  -- vim.diagnostic.severity.INFO
  -- vim.diagnostic.severity.WARN
  -- vim.diagnostic.severity.ERROR
  blacklisted_severities = {},

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

  -- a preprocessor function that takes a raw Corn.Item and returns it after modification, could be used for truncation or other purposes
  item_preprocess_func = function(item)
    -- the default truncation logic is here ...
    return item
  end,

  -- a hook that executes each time corn is toggled. the current state is provided via `is_hidden`
  on_toggle = function(is_hidden)
    -- custom logic goes here
  end,
}
```

## Tips
<details>
<summary> virtual text diagnostics visiblity </summary>

enable virtual text diagnostics when corn is off and disable it when it's on
```lua
-- ensure virtual_text diags are disabled
vim.diagnostic.config { virtual_text = false }

-- toggle virtual_text diags when corn is toggled
require 'corn'.setup {
  on_toggle = function(is_hidden)
    vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
  end
}
```
</details>

<details>
<summary> disable truncation </summary>

disable the default truncation which is implemented inside item_preprocess_func
```lua
-- set item_preprocess_func to return the item unmodified
require 'corn'.setup {
  item_preprocess_func = function(item)
    return item
  end
}
```
</details>

## Plans
- [ ] Add a component based custom render function for both window opts and text rendering
