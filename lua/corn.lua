local M = {}
local config = require 'corn.config'
local utils = require 'corn.utils'
local renderer = require 'corn.renderer'
local logger = require 'corn.logger'

M.corn_augrp = vim.api.nvim_create_augroup("CORN", {})
local scope_types = { 'line', 'file' }
local scope_types_lookup = vim.tbl_add_reverse_lookup(scope_types)

M.setup = function(opts)
  -- apply config opts and exit if validation fails
  if not config.apply(opts or {}) then return end

  -- setup renderer
  renderer.setup()

  -- setup auto_cmds
  if config.opts.auto_cmds then
    vim.api.nvim_create_autocmd({
      "DiagnosticChanged",
      "CursorMoved",
      "CursorMovedI",
      "TextChanged",
      "TextChangedI",
      "WinResized",
    }, {
      group = vim.api.nvim_create_augroup("corn", {}),
      callback = function()
        M.render()
      end
    })
  end
end

-- TODO: make a single Corn commands with autocompleted sub commands
function M.toggle()
  renderer.toggle_hide()
end
vim.api.nvim_create_user_command("CornToggle", M.toggle, {})

function M.scope(scope_type)
  if config.opts.scope == scope_type then
    -- do nothing
  elseif vim.tbl_contains(scope_types, scope_type) then
    config.opts.scope = scope_type
    M.render()
  else
    logger.error("invalid scope type")
  end
end
vim.api.nvim_create_user_command("CornScope", function(opts) M.scope(opts.fargs[1]) end, { nargs = 1 })

function M.scope_cycle()
  local curr_scope_type_index = scope_types_lookup[config.opts.scope]
  local new_scope_type_index = curr_scope_type_index + 1
  if new_scope_type_index > #scope_types then new_scope_type_index = 1 end
  config.opts.scope = scope_types_lookup[new_scope_type_index]
  M.render()
end
vim.api.nvim_create_user_command("CornScopeCycle", M.scope_cycle, {})

function M.render()
  renderer.render(utils.get_diagnostic_items())
end
vim.api.nvim_create_user_command("CornRender", M.render, {})

return M
