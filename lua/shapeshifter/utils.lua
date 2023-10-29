local utils = {
  node_rows = function(node)
    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, erow, ecol = node:range()
    return vim.api.nvim_buf_get_text(buf, srow, scol, erow, ecol, {})
  end,

  node_indentation = function(node)
    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, _, _ = node:range()
    local prefix = vim.api.nvim_buf_get_text(buf, srow, 0, srow, scol, {})[1]
    local _, _, indent = prefix:find("^([ \t]*)")
    return indent
  end,

  node_line_count = function(node)
    local srow, _, erow, _ = node:range()
    return erow - srow + 1
  end,

  node_children_by_name = function(name, node)
    local result = {}

    for child, field in node:iter_children() do
      if field == name then
        result[#result + 1] = child
      end
    end
    return result
  end,

  node_replace_with_lines = function(node, replacement)
    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, erow, ecol = node:range()
    vim.api.nvim_buf_set_text(buf, srow, scol, erow, ecol, replacement)
  end,

  -- used only in testing
  buf_set_content = function(content)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, content)

    local parser = vim.treesitter.get_parser(0)
    parser:parse()
  end
}

return utils
