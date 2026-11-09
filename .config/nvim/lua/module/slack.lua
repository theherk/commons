local M = {}

local function stash_new()
  local items = {}
  local function put(s)
    items[#items + 1] = s
    return "\1" .. #items .. "\2"
  end
  local function restore(s)
    local out = s
    repeat
      local prev = out
      out = out:gsub("\1(%d+)\2", function(n) return items[tonumber(n)] end)
    until out == prev
    return out
  end
  return put, restore
end

local function inline(text)
  local put, restore = stash_new()
  text = text:gsub("(`+)(.-)%1", function(ticks, body) return put(ticks .. body .. ticks) end)
  text = text:gsub("(%]%b())", put)
  text = text:gsub("%*%*(.-)%*%*", function(s) return put("*" .. s .. "*") end)
  text = text:gsub("__(.-)__", function(s) return put("*" .. s .. "*") end)
  text = text:gsub("%*([^%s*][^*]-)%*", "_%1_")
  text = text:gsub("~~(.-)~~", "~%1~")
  return restore(text)
end

local function split_row(line)
  local cells = {}
  line = line:gsub("^%s*|", ""):gsub("|%s*$", "")
  for cell in (line .. "|"):gmatch("(.-)|") do
    cells[#cells + 1] = vim.trim(cell)
  end
  return cells
end

local function is_table_sep(line) return line:match("^%s*|?[%s:%-|]+|[%s:%-|]*$") and line:find("%-") ~= nil end
local function is_rule(line) return line:match("^%s*([-*_])%s*%1%s*%1[%s%-*_]*$") ~= nil end

function M.convert(lines)
  local out = {}
  local in_fence = false
  local skip_blank = false
  local i = 1
  while i <= #lines do
    local line = lines[i]
    local fence = line:match("^%s*(```+)") or line:match("^%s*(~~~+)")
    if fence then
      if in_fence then
        out[#out + 1] = line:match("^%s*") .. fence
      else
        out[#out + 1] = line:match("^%s*") .. fence
      end
      in_fence = not in_fence
    elseif in_fence then
      out[#out + 1] = line
    elseif line:match("^%s*$") then
      if not skip_blank then
        local prev = out[#out]
        local nxt = lines[i + 1]
        if prev and prev:match("^>") and nxt and nxt:match("^%s*>") then
          out[#out + 1] = "> "
        else
          out[#out + 1] = ""
        end
      end
    elseif is_rule(line) then
      -- dropped
    elseif line:match("^%s*|") and lines[i + 1] and is_table_sep(lines[i + 1]) then
      local headers = split_row(line)
      i = i + 2
      while i <= #lines and lines[i]:match("^%s*|") do
        local cells = split_row(lines[i])
        local parts = {}
        for c, cell in ipairs(cells) do
          local label = headers[c]
          parts[#parts + 1] = (label and label ~= "") and (label .. ": " .. cell) or cell
        end
        out[#out + 1] = inline("- " .. table.concat(parts, "; "))
        i = i + 1
      end
      i = i - 1
    elseif line:match("^%s*>") then
      local body = line:gsub("^%s*>%s?", "")
      out[#out + 1] = "> " .. inline(body)
    elseif line:match("^%s*#+%s") then
      local text = line:gsub("^%s*#+%s+", ""):gsub("%s+#+%s*$", ""):gsub("%*%*", ""):gsub("__", "")
      out[#out + 1] = "*" .. inline(text) .. "*"
      out[#out + 1] = ""
      skip_blank = true
      i = i + 1
      goto continue
    else
      local indent, rest = line:match("^(%s*)[+*]%s+(.*)$")
      if indent then line = indent .. "- " .. rest end
      out[#out + 1] = inline(line)
    end
    skip_blank = false
    i = i + 1
    ::continue::
  end
  while #out > 0 and out[#out] == "" do
    out[#out] = nil
  end
  return out
end

local function yank(lines)
  local text = table.concat(M.convert(lines), "\n")
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify("slack yank: " .. #vim.split(text, "\n") .. " lines")
end

function M.yank_buffer() yank(vim.api.nvim_buf_get_lines(0, 0, -1, false)) end

function M.yank_selection()
  local mode = vim.fn.mode()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
  vim.api.nvim_feedkeys(vim.keycode("<esc>"), "nx", false)
  yank(lines)
end

return M
