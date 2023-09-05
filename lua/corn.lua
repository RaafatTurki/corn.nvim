local M = {}
local config = require 'corn.config'
local utils = require 'corn.utils'
local renderer = require 'corn.renderer'

M.corn_augrp = vim.api.nvim_create_augroup("CORN", {})

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

function M.render()
  renderer.render(utils.get_current_line_diagnostic_items())
end
vim.api.nvim_create_user_command("CornRender", M.render, {})

return M
