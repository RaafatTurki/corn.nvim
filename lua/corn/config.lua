require 'corn.types'

local M = {}

-- default config
M.default_opts = {
  ---@type boolean
  auto_cmds = true,

  ---@type string
  sort_method = 'severity',

  ---@type string
  scope = 'line',

  ---@type string
  border_style = 'single',

  ---@type string[]
  blacklisted_modes = {},

  ---@type lsp.DiagnosticSeverity[]
  blacklisted_severities = {},

  ---@type { error: string, warn: string, hint: string, info: string, trunc: string }
  highlights = {
    error = "DiagnosticFloatingError",
    warn = "DiagnosticFloatingWarn",
    info = "DiagnosticFloatingInfo",
    hint = "DiagnosticFloatingHint",
  },

  ---@type { error: string, warn: string, hint: string, info: string, trunc: string }
  icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
    -- trunc = "...",
  },

  ---@param item Corn.Item
  ---@return Corn.Item
  item_preprocess_func = function(item)
    local trunc_tail = "..."
    local max_width = vim.api.nvim_win_get_width(0) / 4

    if #item.message > max_width then
      item.message = string.sub(item.message, 1, max_width - #trunc_tail) .. trunc_tail
      item.source = trunc_tail
    end

    return item
  end,

  ---@type function(boolean) nil
  on_toggle = function(is_hidden)
  end,
}

M.opts = {}

M.validate_opts = function(opts)
  -- TODO: implement config validation with vim.notify() logging
  return true
end

M.apply = function(opts)
  if M.validate_opts(opts) == false then
    return false
  else
    M.opts = vim.tbl_deep_extend("force", M.default_opts, opts or {})
    return true
  end
end

return M
