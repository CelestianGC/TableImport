-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
function onInit()
LibraryData.aRecords["table"] = { 
		bExport = true,
		aDataMap = { "tables", "reference.tables" }, 
		aDisplayIcon = { "button_tables", "button_tables_down" },
		-- sRecordDisplayClass = "table", 
		aGMEditButtons = { "button_add_table_guided","button_import_table" };
};
end

