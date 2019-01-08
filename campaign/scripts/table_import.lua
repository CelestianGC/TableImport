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
        table.insert(aTableText, sLine);
      end
      local nodeTable = createBlankTable();
      DB.setValue(nodeTable,"name","string",aTableText[1]);
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
            local nodeRow = nodeTableRows.createChild();
            DB.setValue(nodeRow, "fromrange", "number", nStart);
            DB.setValue(nodeRow, "torange", "number", nLast);
            local nodeResults = nodeRow.createChild("results");
            local nodeResult = nodeResults.createChild();
            DB.setValue(nodeResult, "result", "string", sText);
          end
        end
      end
    end
end
