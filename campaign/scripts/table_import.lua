-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
--Debug.console("table_import.lua","onInit","getDatabaseNode",getDatabaseNode());
end


function createBlankTable()
--	local node = window.getDatabaseNode().createChild();
--	local node = getDatabaseNode().createChild();
    local node = DB.createChild("tables"); 
--Debug.console("table_import.lua","createTable","node",node);    

	if node then
		local w = Interface.openWindow("table", node.getNodeName());
		--TableManager.createRows(node, nRows, nStep, bSpecial);
		if w and w.header and w.header.subwindow and w.header.subwindow.name then
			w.header.subwindow.name.setFocus();
		end
	end
    return node;
end

function importTextAsTable()
    local sText = tableimporttext.getValue() or "";
--Debug.console("table_import.lua","importTextAsTable","sText",sText);    
    if (sText ~= "") then
      local aTableText = {};
      for sLine in string.gmatch(sText, '([^\r\n]+)') do
        sLine = StringManager.trim(sLine);  -- remove spaces in front and on end.
        table.insert(aTableText, sLine);
      end
      local nodeTable = createBlankTable();
      DB.setValue(nodeTable,"name","string",aTableText[1]);
      DB.setValue(nodeTable,"resultscols","number",1);
      local nResultsCols = 1;
      local nNewRow = 0;
      if (nodeTable) then
        local nodeTableRows = nodeTable.createChild("tablerows");
        for _,sTableLines in ipairs(aTableText) do
          local nStart, nLast = 0;
          local sStart, sLast, sText = sTableLines:match("^(%d+)-(%d+) (.*)"); -- grab 1-10 numbers
          if (sStart == nil or sLast == nil) then -- check for just a single starting number then
            sStart, sText = sTableLines:match("^(%d+)%.? (.*)");
          end
          if (sStart ~= nil) then -- we got at least 1 number
            if sLast == nil then  -- just a single number
              sLast = sStart;
            end
            nStart = tonumber(sStart) or 1;
            nLast = tonumber(sLast) or 1;
            nNewRow = nNewRow + 1;
          else
            sText = sTableLines;
            nNewRow = nNewRow + 1;
            nStart = nNewRow-1;
            nLast = nNewRow-1;
          end
          if (nNewRow ~= 1) then -- use line 1 as title/name of table
            --local aText = StringManager.split(sText," %s+",true);
            --local aText = string.gmatch(sText," %s+");
            local aText = split(sText,"%s%s+");
--Debug.console("table_import.lua","importTextAsTable","aText",aText);
--Debug.console("table_import.lua","importTextAsTable","#aText",#aText);
            if #aText > nResultsCols then
              DB.setValue(nodeTable,"resultscols","number",#aText);
              nResultsCols = #aText;
            end
            local nodeRow = nodeTableRows.createChild();
            DB.setValue(nodeRow, "fromrange", "number", nStart);
            DB.setValue(nodeRow, "torange", "number", nLast);
            local nodeResults = nodeRow.createChild("results");
            for i=1, #aText do
              local nodeResult = nodeResults.createChild();
              DB.setValue(nodeResult, "result", "string", StringManager.trim(aText[i]));
            end
          end
        end
      end
    end
end

-- this allows me to split on 2+spaces
function split(str, pat)
  local t = {};
  local fpat = "(.-)" .. pat;
  local last_end = 1;
  local s, e, cap = str:find(fpat, 1);
  while s do
  if s ~= 1 or cap ~= "" then
   table.insert(t,cap);
  end
    last_end = e+1;
    s, e, cap = str:find(fpat, last_end);
  end
  if last_end <= #str then
    cap = str:sub(last_end);
    table.insert(t, cap);
  end
  return t
end
