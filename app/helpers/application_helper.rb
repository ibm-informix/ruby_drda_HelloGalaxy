module ApplicationHelper

	# Topics
# 1 Create table 
# 2 Inserts
# 2.1 Insert a single document into a table
# 2.2 Insert multiple documents into a table
# 3 Queries
# 3.1 Find one document in a table that matches a query condition
# 3.2 Find documents in a table that match a query condition
# 3.3 Find all documents in a table
# 3.4 Count documents with query
# 3.5 Order documents in a table
# 3.6 Join tables
# 3.7 Find distinct fields in a table
# 3.8 Find with projection clause
# 4 Update documents in a table
# 5 Delete documents in a table
# 6 Transactions
# 7 Commands
# 7.1 Count
# 7.2 Distinct
# 8 Drop a table

	class City
		attr_accessor :name, :population, :longitude, :latitude, :countryCode

		def initialize(cityName, cityPopulation, cityLatitude, cityLongitude, cityCountryCode)
			@name = cityName
			@population = cityPopulation
			@longitude = cityLongitude
			@latitude = cityLatitude
			@countryCode = cityCountryCode
		end
	    
	    def toSql
	    	return "('#{name}', #{population}, #{longitude}, #{latitude}, #{countryCode})"
	    end
	    def toHash
	    	return {:name => @name, :population => @population, :latitude => @latitude, :longitude => @longitude, :countryCode => @countryCode}
	    end
	end

	def runHelloGalaxy()
=begin  
	use the following if deploying onto bluemix
	if ENV['VCAP_SERVICES'] == nil
		outPut.push("vcap services is nil")
		return outPut
	end
	vcap_hash = JSON.parse(ENV['VCAP_SERVICES'])["altadb-dev"]
	credHash = vcap_hash.first["credentials"]
	host = credHash["host"]
	port = credHash["drda_port"]
	dbname= credHash['db']
	user = credHash["username"]
	password = credHash["password"]
=end
		outPut = Array.new
		# local connection info
		host = "lxvm-ciiqa3.lenexa.ibm.com"
		port = "8412"
		user = "informix"
		password = "Ibm4pass"
		dbname = "rubydb"

		tableName = "rubyDRDAGalaxy"
		kansasCity = City.new("Kansas City", "467007", "39.0997", "94.5783", "1")
		seattle = City.new("Seattle", "652405", "47.6097", "122.3331", "1");
		newYork = City.new("New York", "8406000", "40.7127", "74.0059", "1");
		london = City.new("London", "8308000", "51.5072", "0.1275", "44");
		tokyo = City.new("Tokyo", "13350000", "35.6833", "-139.6833", "81");
		madrid = City.new("Madrid", "3165000", "40.4000", "3.7167", "34");
		melbourne = City.new("Melbourne", "4087000", "-37.8136", "-144.9631", "61");
		sydney = City.new("Sydney", "4293000", "-33.8650", "-151.2094", "61")

		
		
		connStr = "DRIVER={IBM DB2 ODBC DRIVER};DATABASE=#{dbname};HOSTNAME=#{host};PORT=#{port};PROTOCOL=TCPIP;UID=#{user};PWD=#{password}"
		dbconn = IBM_DB.connect connStr, user, password
		if dbconn
			outPut.push("Connected Successfully to database")
		else
			outPut.push("Failed to Connect to Database")
			return outPut
		end

		# drop table if exists
		sql = "drop table if exists #{tableName}"
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Failed to drop table")
		end

		outPut.push("Create table")
		
	 	sql = "create table #{tableName}(name VARCHAR(255), population INTEGER, longitude DECIMAL(8,4), latitude DECIMAL(8,4),countryCode INTEGER)"
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Create table failed")
			return outPut
		end
		outPut.push(" ")

		outPut.push("Insert a single document into a table")

		sql = "insert into #{tableName} values(?,?,?,?,?)"
		stmtHdl = IBM_DB::prepare dbconn, sql
		#  	ibm_db.bind_param documentation states this for value parameter
		# 	'A string specifying the name of the Ruby variable to bind to the parameter specified by parameter-number.''

		IBM_DB::bind_param stmtHdl, 1, 'kansasCity.name', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 2, 'kansasCity.population', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 3, 'kansasCity.longitude', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 4, 'kansasCity.latitude', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 5, 'kansasCity.countryCode', IBM_DB::SQL_PARAM_INPUT
		stmt = IBM_DB::execute stmtHdl
		unless stmt
			outPut.push("Failed to execute insert")
		end

		outPut.push(" ")
		outPut.push("Insert multiple documents into a table. Currently there is no support batch inserts")
		# use same sql and stmtHdl from above
		stmtHdl = IBM_DB::prepare dbconn, sql
		IBM_DB::bind_param stmtHdl, 1, 'seattle.name', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 2, 'seattle.population', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 3, 'seattle.longitude', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 4, 'seattle.latitude', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 5, 'seattle.countryCode', IBM_DB::SQL_PARAM_INPUT
		stmt = IBM_DB::execute stmtHdl
		unless stmt
			outPut.push("Failed to execute 1st document insert")
		end
		stmtHdl = IBM_DB::prepare dbconn, sql
		IBM_DB::bind_param stmtHdl, 1, 'newYork.name', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 2, 'newYork.population', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 3, 'newYork.longitude', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 4, 'newYork.latitude', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 5, 'newYork.countryCode', IBM_DB::SQL_PARAM_INPUT
		stmt = IBM_DB::execute stmtHdl
		unless stmt
			outPut.push("Failed to execute 2nd document insert")
		end

		outPut.push("#{tokyo.toSql}")

		outPut.push(" ")
		outPut.push("Alternate way to insert without bindings")
		sql = "insert into #{tableName} values #{tokyo.toSql}"
		outPut.push("1st insert: #{sql}")
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Failed to execute 1st alternate insert")
		end
		sql = "insert into #{tableName} values #{madrid.toSql}"
		outPut.push("2nd insert: #{sql}")
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Failed to execute 2nd alternate insert")
		end
		sql = "insert into #{tableName} values #{melbourne.toSql}"
		outPut.push("3rd insert: #{sql}")
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Failed to execute 3rd alternate insert")
		end

		outPut.push("")
		outPut.push("Find one document in a table that matches a query condition")
		sql = "select * from #{tableName} where population > 8000000 and countryCode = 1"
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Failed to select one document")
		end
		resultHash = IBM_DB.fetch_assoc(stmt)
		# ruby uses BigDecimal when returning the floating point values in table
		# To convert to string representation use  .to_s('F')
		outPut.push(resultHash.to_a)

		outPut.push("")
		outPut.push("Find documents in a table that match a query condition")
		sql = "select * from #{tableName} where population > 8000000 and longitude > 40.0"
		outPut.push("Query: #{sql}")
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt 
			outPut.push("Failed to select mult documents")
		end
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Find all documents with name: #{kansasCity.name}")
		sql = "select * from #{tableName} where name = '#{kansasCity.name}'"
		stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Find all documents in a table")
		sql = "select * from #{tableName}"
		stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Count documents in a table")
		sql = "select count(*) from #{tableName} where longitude < 40.0"
		stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		outPut.push(resultHash["1"]) # the key for result hash is "1"

		outPut.push("")
		outPut.push("Order documents in a table")
		sql = "select * from #{tableName} order by population"
		outPut.push(sql)
		stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Joins")
		tableJoin = "country"
		# drop table if exists
		sql = "drop table if exists #{tableJoin}"
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Failed to drop join table")
		end
		sql = "create table if not exists #{tableJoin} (countryCode INTEGER, countryName VARCHAR(255))"
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("Create join table failed")
			return outPut
		end

		# insert values into country
		sql = "insert into #{tableJoin} values (1,\"United States of America\")";
    	stmt = IBM_DB.exec(dbconn, sql)
	    sql = "insert into #{tableJoin} values (44,\"United Kingdom\")";
	    stmt = IBM_DB.exec(dbconn, sql)
	    sql = "insert into #{tableJoin} values (81,\"Japan\")";
	    stmt = IBM_DB.exec(dbconn, sql)	    
	    sql = "insert into #{tableJoin} values (34,\"Spain\")";
	    stmt = IBM_DB.exec(dbconn, sql)	    
	    sql = "insert into #{tableJoin} values (61,\"Australia\")";
	    stmt = IBM_DB.exec(dbconn, sql)

	    sql = ("select table1.name, table1.population, table1.longitude, table1.latitude," \
	    	" table1.countryCode, table2.countryName from #{tableName} table1 inner join #{tableJoin}" \
	    	" table2 on table1.countryCode=table2.countryCode")
	    outPut.push("Query: #{sql}")
	    stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Distinct documents in a table")
		sql = "select distinct countryCode from #{tableName} where longitude > 40.0"
		outPut.push("Query: #{sql}")
		stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Projection Clause")
		sql = "select distinct name, countryCode from #{tableName} where population > 8000000"
		outPut.push("Query: #{sql}")
		stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Update documents in a table")
		sql = "update #{tableName} set countryCode = ? where name = ?"
		stmtHdl = IBM_DB::prepare dbconn, sql
		tempCountryCode = '999'
		IBM_DB::bind_param stmtHdl, 1, 'tempCountryCode', IBM_DB::SQL_PARAM_INPUT
		IBM_DB::bind_param stmtHdl, 2, 'seattle.name', IBM_DB::SQL_PARAM_INPUT
		outPut.push("Query: update #{tableName} set countryCode = #{tempCountryCode} where name = #{seattle.name}")
		stmt = IBM_DB::execute stmtHdl
		unless stmt
			outPut.push("Failed to execute update")
		end

		outPut.push("")
		outPut.push("Delete documents in a table")
		sql = "delete from #{tableName} where name like '#{newYork.name}'"
		outPut.push(sql)
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("failed to delete")
		end

		outPut.push("")
		outPut.push("Transactions")
		IBM_DB.autocommit(dbconn, IBM_DB::SQL_AUTOCOMMIT_OFF)
		# verify that in correct state
		ac = IBM_DB.autocommit(dbconn)
		if ac == 0
			outPut.push("Autocommit set to off as intended")
		else
			outPut.push("Cannot set autocommit to off.  FAIL")
		end
		sql = "insert into #{tableName} values #{sydney.toSql}"
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("failed to insert Sydney")
		end
		if IBM_DB.commit(dbconn)
			outPut.push("Commit successful")
		else
			outPut.push("Commit unsuccessful")
		end
		sql = "update #{tableName} set countryCode = 998 where name = 'Seattle'"
		stmt = IBM_DB.exec(dbconn, sql)
		unless stmt
			outPut.push("failed to update Seattle")
		end
		if IBM_DB.rollback(dbconn)
			outPut.push("Rollback successful")
		else
			outPut.push("Rollback unsuccessful")
		end

		outPut.push("")
		outPut.push("Find all documents in table")
		sql = "select * from #{tableName}"
		outPut.push(sql)
		stmt = IBM_DB.exec(dbconn, sql)
		resultHash = IBM_DB.fetch_assoc(stmt)
		while resultHash
			outPut.push(resultHash.to_a)
			resultHash = IBM_DB.fetch_assoc(stmt)
		end

		outPut.push("")
		outPut.push("Drop a table")
		stmt = IBM_DB.exec(dbconn, "drop table #{tableName}")
		unless stmt
			outPut.push("Failed to drop #{tableName}")
		end
		stmt = IBM_DB.exec(dbconn, "drop table #{tableJoin}")
		unless stmt
			outPut.push("Failed to drop #{tableJoin}")
		end

		if IBM_DB.close(dbconn)
			outPut.push("successfully closed connection")
		else
			outPut.push("Failed to close connection")
		end
		return outPut
	end

end