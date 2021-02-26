# Connect to the database

    library(DBI)
    #install.packages('RPostgres')
    
    con <- dbConnect(RPostgres::Postgres(),
                     dbname = 'phenodb',
                     host = '10.200.105.5', # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'
                     port = 5432, # or any other port specified by your DBA
                     user = 'johan',
                     password = 'hej123')



# Fetching all data in a table/selection

    res <- dbSendQuery(con, "SELECT * FROM met.population")
    resDf<-dbFetch(res)
    dbClearResult(res)

# Fetching the data in parts

    res <- dbSendQuery(con, "SELECT * FROM met.population")
    while(!dbHasCompleted(res)){
      chunk <- dbFetch(res, n = 5)
      print(nrow(chunk))
    }
    dbClearResult(res)

#Inserting data to the database

    rs <- RPostgres::dbSendQuery(
      con, 
      "INSERT INTO johan.test(code,n,documentation) VALUES ($1,$2,$3);",
      params=list("first",3,"some value here")
    )
    
    dbFetch(rs) #don't need to do this for statements
    dbClearResult(rs)


    # Does not work
    # rs <- dbSendQuery(
    #   con,
    #   "INSERT INTO johan.test(code,n,documentation) VALUES (?,?,?);",
    #   params = list("first",3,"some value here")
    # )
    # dbFetch(rs)
    # dbClearResult(rs)


    

#Insert a whole table

    dbWriteTable(con, "mtcars", mtcars)
#Inspect the database
These did noit work for me.

    dbListTables(con)
    dbListFields(con, "mtcars")

# Disconnect from the database

    dbDisconnect(con)
