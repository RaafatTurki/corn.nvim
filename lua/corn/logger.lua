local M = {}

M.title = "Corn"

function M.info(message)
  vim.schedule(function()
    vim.notify(message, vim.log.levels.INFO, { title = M.title })
  end)
end

function M.warn(message)
  vim.schedule(function()
    vim.notify(message, vim.log.levels.WARN, { title = M.title })
  end)
end

function M.error(message)
  vim.schedule(function()
    vim.notify(message, vim.log.levels.ERROR, { title = M.title })
  end)
end

return M
