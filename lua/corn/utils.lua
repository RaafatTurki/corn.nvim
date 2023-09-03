local M = {}

local config = require 'corn.config'

M.get_current_line_diagnostic_items = function()
  local lnum = vim.fn.line('.') - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
  local items = {}

  for i, diag in ipairs(diagnostics) do
    table.insert(items, {
      message = diag.message,
      severity = diag.severity or vim.diagnostic.severity.ERROR,
      col = diag.col,
      source = diag.source or '',
      code = diag.code or '',
    })
  end

  return items
end

M.diag_severity_to_hl_group = function(severity)
  local look_up = {
    [vim.diagnostic.severity.ERROR] = config.opts.highlights.error,
    [vim.diagnostic.severity.WARN] = config.opts.highlights.warn,
    [vim.diagnostic.severity.INFO] = config.opts.highlights.info,
    [vim.diagnostic.severity.HINT] = config.opts.highlights.hint,
  }

  return look_up[severity] or ''
end

M.diag_severity_to_icon = function(severity)
  local look_up = {
    [vim.diagnostic.severity.ERROR] = config.opts.icons.error,
    [vim.diagnostic.severity.WARN] = config.opts.icons.warn,
    [vim.diagnostic.severity.INFO] = config.opts.icons.info,
    [vim.diagnostic.severity.HINT] = config.opts.icons.hint,
  }

  return look_up[severity] or '-'
end

return M
