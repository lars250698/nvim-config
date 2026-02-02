local M = {}

local function cabbrev(lhs, rhs)
  vim.cmd(string.format(
    [[cnoreabbrev <expr> %s getcmdtype() == ':' && getcmdline() ==# '%s' ? '%s' : '%s']],
    lhs, lhs, rhs, lhs
  ))
end

--- Create a user command with an optional abbreviation.
--- Pass opts.buffer to make it buffer-local, opts.abbrev for the cabbrev.
---@param name string Command name (must start with uppercase)
---@param func function|string Command implementation
---@param opts? { abbrev?: string, buffer?: integer, desc?: string, range?: boolean, [string]: any }
function M.create(name, func, opts)
  opts = opts or {}
  local abbrev = opts.abbrev
  local bufnr = opts.buffer

  -- Build a clean opts table for the API (strip our custom keys)
  local cmd_opts = {}
  for k, v in pairs(opts) do
    if k ~= 'abbrev' and k ~= 'buffer' then
      cmd_opts[k] = v
    end
  end

  if bufnr then
    vim.api.nvim_buf_create_user_command(bufnr, name, func, cmd_opts)
  else
    vim.api.nvim_create_user_command(name, func, cmd_opts)
  end

  if abbrev then
    cabbrev(abbrev, name)
  end
end

return M
