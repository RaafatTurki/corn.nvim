local M = {}

require 'corn.types'
local config = require 'corn.config'

M.get_diagnostic_items = function()
  local lnum = vim.fn.line('.') - 1

  local diagnostics = {}
  if config.opts.scope == 'line' then
    diagnostics = vim.diagnostic.get(0, { lnum = lnum })
  elseif config.opts.scope == 'file' then
    diagnostics = vim.diagnostic.get(0, {})
  end

  local items = {}

  for i, diag in ipairs(diagnostics) do
    -- skip blacklisted severities
    if vim.tbl_contains(config.opts.blacklisted_severities, diag.severity) then
      goto continue
    end

    ---@type Corn.Item
    local item = {
      -- non-optional keys
      message = diag.message,
      col = diag.col,
      lnum = diag.lnum,

      -- optional keys
      severity = diag.severity or vim.diagnostic.severity.ERROR,
      source = diag.source or '',
      code = diag.code or '',
    }

    table.insert(items, item)

    ::continue::
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

M.get_cursor_relative_pos = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor_pos[1]
  local cursor_col = cursor_pos[2]

  local cursor_relative_line = cursor_line - vim.fn.line('w0')
  local cursor_relative_col = cursor_col - vim.fn.col('w0')

  return cursor_relative_line, cursor_relative_col
end

M.tbl_add_reverse_lookup = function(tbl)
  local reverse_lookup = {}

  for k, v in pairs(tbl) do
    reverse_lookup[v] = k
  end

  return reverse_lookup
end

return M
