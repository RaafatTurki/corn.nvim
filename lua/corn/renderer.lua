local utils = require 'corn.utils'

local M = {}

M.bufnr = nil
M.ns = nil
M.win = nil
M.is_visible = false
M.is_hidden = false

M.make_win_cfg = function(width, height)
  return {
    relative = "win",
    win = vim.api.nvim_get_current_win(),
    anchor = "NE",

    col = vim.api.nvim_win_get_width(0) - 1, -- because of the scrollbar
    row = 0,

    width = width <= 0 and 1 or width,
    height = height <= 0 and 1 or height,
    focusable = false,
    style = 'minimal',

    border = 'single',
    -- border = 'none',
  }
end

M.setup = function()
  M.bufnr = vim.api.nvim_create_buf(false, true)
  M.ns = vim.api.nvim_create_namespace('corn')
end

M.toggle_hide = function()
  M.is_hidden = not M.is_hidden
end

M.render = function(items)
  -- clear buffer
  -- vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, {})
  -- vim.api.nvim_buf_clear_namespace(M.bufnr, M.ns, 0, -1)

  local item_lines = {}
  local longest_line_len = 1
  local hl_segments = {}

  function insert_hl_segment(hl, lnum, col, end_col)
    table.insert(hl_segments, {
      hl_group = hl,
      lnum = lnum,
      col = col,
      end_col = end_col,
    })
  end

  -- assemble item lines
  for i, item in ipairs(items) do
    -- splitting messages by \n and adding each as a separate line
    local message_lines = vim.fn.split(item.message, '\n')
    for j, message_line in ipairs(message_lines) do
      local line = ""

      function append_to_line(text, hl)
        insert_hl_segment(hl, #item_lines + j-1, #line, #line + #text)
        line = line .. text
      end

      -- icon on first message_line, put and ' ' on the rest
      if j == 1 then
        append_to_line(utils.diag_severity_to_icon(item.severity), utils.diag_severity_to_hl_group(item.severity))
      else
        append_to_line(' ', utils.diag_severity_to_hl_group(item.severity))
      end
      -- message_line content
      append_to_line(' ' .. message_line, utils.diag_severity_to_hl_group(item.severity))
      -- extra info on the last line only
      if j == #message_lines then
        append_to_line(' ' .. item.code .. '', 'Folded')
        append_to_line(' ' .. item.source, 'Comment')
        append_to_line(' col:' .. item.col, 'Comment')
      end

      -- record the longest line length for later use
      if #line > longest_line_len then longest_line_len = #line end
      -- insert the entire line
      table.insert(item_lines, line)
    end
  end

  -- calculate visibility
  if 
    -- items not zero
    not M.is_hidden
    -- user didnt hide it
    and #items ~= 0
    -- can fit in the width and height of the parent window
    and vim.api.nvim_win_get_width(0) >= longest_line_len + 2 -- because of the borders
    and vim.api.nvim_win_get_height(0) >= #items
  then
    M.is_visible = true
  else
    M.is_visible = false
  end

  -- either close_win, open_win or win_set_config
  if not M.is_visible then
    if M.win then
      vim.api.nvim_win_hide(M.win)
      M.win = nil
    end
  elseif not M.win then
    M.win = vim.api.nvim_open_win(M.bufnr, false, M.make_win_cfg(longest_line_len, #item_lines))
    -- vim.api.nvim_win_set_option(M.win, 'winblend', 50)
    vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, false, item_lines)
    vim.api.nvim_win_set_hl_ns(M.win, M.ns)
  elseif M.win then
    vim.api.nvim_win_set_config(M.win, M.make_win_cfg(longest_line_len, #item_lines))
    vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, false, item_lines)
    vim.api.nvim_win_set_hl_ns(M.win, M.ns)
  end
  
  -- apply highlights
  for i, hl_segment in ipairs(hl_segments) do
    vim.api.nvim_buf_add_highlight(M.bufnr, M.ns, hl_segment.hl_group, hl_segment.lnum, hl_segment.col, hl_segment.end_col)
  end
end

return M
