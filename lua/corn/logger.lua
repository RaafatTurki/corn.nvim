local M = {}

M.prefix = "[corn]"

function M.info(message)
  vim.schedule(function()
    vim.notify(M.prefix .. ' ' .. message, vim.log.levels.INFO)
  end)
end

function M.warn(message)
  vim.schedule(function()
    vim.notify(M.prefix .. ' ' .. message, vim.log.levels.WARN)
  end)
end

function M.error(message)
  vim.schedule(function()
    vim.notify(M.prefix .. ' ' .. message, vim.log.levels.ERROR)
  end)
end

return M
