local M = {}

-- default config
M.default_opts = {
  ---@type boolean
  auto_cmds = true,

  ---@type string
  sort_method = 'severity',

  ---@type string
  scope = 'line',

  ---@type { error: string, warn: string, hint: string, info: string }
  highlights = {
    error = "DiagnosticFloatingError",
    warn = "DiagnosticFloatingWarn",
    info = "DiagnosticFloatingInfo",
    hint = "DiagnosticFloatingHint",
  },

  ---@type boolean | number
  truncate_message = true,

  ---@type { error: string, warn: string, hint: string, info: string }
  icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },

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
