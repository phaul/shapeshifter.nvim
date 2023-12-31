local utils = require("shapeshifter.utils")

--[[
                                              if condition
  do_something if condition         -->         do_something
                                              end
--]]
local postfix_condition = {
  match = function(current_node)
    if current_node:type() == "if_modifier" or current_node:type() == "unless_modifier" then
      local condition = utils.node_children_by_name("condition", current_node)
      local body = utils.node_children_by_name("body", current_node)

      return { target = current_node, condition = condition[1], body = body[1] }
    end
  end,

  shift = function(data)
    local node, condition, body =
        data.target, data.condition, data.body
    local indent = utils.node_indentation(node)

    local header = (node:type() == "if_modifier") and "if" or "unless"

    local replacement = {
      header .. " " .. utils.node_rows(condition)[1],
      indent .. "  " .. utils.node_rows(body)[1],
      indent .. "end"
    }

    utils.node_replace_with_lines(node, replacement)
  end
}

return postfix_condition
