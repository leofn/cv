--[[
  count-refs.lua
  Lua filter para contar publicações por categoria
  
  Uso no .qmd:
    ### Peer-Reviewed Articles {{count:articles}}
    
  O placeholder será substituído por (N) onde N é o número de entradas
--]]

local counts = {}

-- Primeira passagem: conta referências em cada div
function count_refs(doc)
  for i, block in ipairs(doc.blocks) do
    if block.t == "Div" and block.identifier then
      local category = block.identifier:match("^refs%-(.+)$")
      if category then
        local count = 0
        pandoc.walk_block(block, {
          Div = function(el)
            if el.classes:includes("csl-entry") then
              count = count + 1
            end
          end
        })
        counts[category] = count
      end
    end
  end
  return doc
end

-- Segunda passagem: substitui placeholders
function replace_placeholders(doc)
  local function replace_in_inlines(inlines)
    local result = pandoc.Inlines({})
    for _, el in ipairs(inlines) do
      if el.t == "Str" then
        local new_text = el.text:gsub("{{count:(%w+)}}", function(cat)
          local count = counts[cat] or "?"
          return "(" .. tostring(count) .. ")"
        end)
        table.insert(result, pandoc.Str(new_text))
      else
        table.insert(result, el)
      end
    end
    return result
  end
  
  for i, block in ipairs(doc.blocks) do
    if block.t == "Header" then
      block.content = replace_in_inlines(block.content)
    elseif block.t == "Para" then
      block.content = replace_in_inlines(block.content)
    end
  end
  
  return doc
end

function Pandoc(doc)
  doc = count_refs(doc)
  doc = replace_placeholders(doc)
  return doc
end
