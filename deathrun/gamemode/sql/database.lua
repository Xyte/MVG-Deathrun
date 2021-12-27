// sql code
// By AC²

-- Create our object
database = {}

// Error
function database.Error(str)
	print("[SQL] "..str)
end

// Send a query and optional add a callback
function database.Query(strquery, callback, value)
	if not (strquery) then return end
	
	value = value or false
	local query
	
	if (value) then
		query = sql.QueryValue(strquery)
	else
		query = sql.Query(strquery)
	end
	
	if (query) then
		if (callback) and (type(callback) == "function") then
			callback(query)
		end
	end
	
	if (sql.LastError()) then
		database.Error("Query "..strquery.." failed with "..sql.LastError())
	end

	
	return query
end

// Send a queryvalue
function database.QueryValue(strquery, callback)
	return database.Query(strquery, callback, true)
end

// Create a new table
function database.CreateTable(tblname, ...)
	local args = {...}
	if (sql.TableExists(tblname)) then return end
	
	database.Query([[CREATE TABLE IF NOT EXISTS ]]..tblname..[[ (]]..unpack(args)..[[) ]])
end

// Remove an existing table
function database.RemoveTable(tblname)
	if not (sql.TableExists(tblname)) then return end
	
	database.Query([[DROP TABLE ]]..tblname..[[]], function(data)
		database.Error("Table "..tblname.." has been deleted.")
	end)
end
	
-- Create tables
database.CreateTable("player_achievements", "steamid varchar(20), achievement text")
database.CreateTable("player_store", "steamid varchar(20), items text")
database.CreateTable("player_data", "steamid varchar(20), xp int, perk text, firstjoin int")
database.CreateTable("player_stats", "steamid varchar(20), stats text")