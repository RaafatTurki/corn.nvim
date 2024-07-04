local M = {}
local config = require 'corn.config'
local utils = require 'corn.utils'
local renderer = require 'corn.renderer'
local logger = require 'corn.logger'

M.augroup = vim.api.nvim_create_augroup("corn", {})
M.is_setup = false
local scope_types = { 'line', 'file' }
local scope_types_lookup = utils.tbl_add_reverse_lookup(scope_types)

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
      "ModeChanged",
    }, {
        group = M.augroup,
        callback = function()
          M.render()
        end
      })
  end

  vim.api.nvim_create_user_command("Corn", function(opts)
    local sub_cmd = opts.fargs[1]

    if sub_cmd == "toggle" then
      M.toggle(opts.fargs[2])

    elseif sub_cmd == "scope" then
      M.scope(opts.fargs[2])

    elseif sub_cmd == "scope_cycle" then
      M.scope_cycle()

    elseif sub_cmd == "render" then
      M.render()

    else
      logger.error("invalid corn subcommand")
    end

  end, {
      nargs = '+',
      complete = function(ArgLead, CmdLine, CursorPos)
        local args = vim.split(CmdLine, ' ', { trimempty = true })
        last_arg = args[#args]

        -- log(last_arg)
        if last_arg == "Corn" then
          return { 'toggle', 'scope', 'scope_cycle', 'render' }
        elseif last_arg == "toggle" then
          return { "on", "off" }
        elseif last_arg == "scope" then
          return { "line", "file" }
        end

      end,
    })

  M.is_setup = true
end

function M.toggle(state)
  if M.is_setup == false then
    logger.error("can't use corn yet, call setup first")
    return
  end

  -- on|off to true|false
  if state ~= nil then state = state == "on" end
  renderer.toggle(state)
  M.render()
end

function M.scope(scope_type)
  if M.is_setup == false then
    logger.error("can't use corn yet, call setup first")
    return
  end

  if config.opts.scope == scope_type then
    -- do nothing
  elseif vim.tbl_contains(scope_types, scope_type) then
    config.opts.scope = scope_type
    M.render()
  else
    logger.error("invalid scope type")
  end
end

function M.scope_cycle()
  if M.is_setup == false then
    logger.error("can't use corn yet, call setup first")
    return
  end

  local curr_scope_type_index = scope_types_lookup[config.opts.scope]
  local new_scope_type_index = curr_scope_type_index + 1
  if new_scope_type_index > #scope_types then new_scope_type_index = 1 end
  config.opts.scope = scope_types_lookup[new_scope_type_index]
  M.render()
end

function M.render()
  if M.is_setup == false then
    logger.error("can't use corn yet, call setup first")
    return
  end

  renderer.render(utils.get_diagnostic_items())
end

return M
