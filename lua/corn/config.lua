local M = {}

-- default config
M.default_opts = {
  auto_cmds = true,
  sort_method = 'severity',
  scope = 'line',
  highlights = {
    error = "DiagnosticFloatingError",
    warn = "DiagnosticFloatingWarn",
    info = "DiagnosticFloatingInfo",
    hint = "DiagnosticFloatingHint",
  },
  truncate_message = true,
  icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },
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
