Working in R
============================================
Reference sheet version 1 (20210226)

Johan Zvrskovec 2021

# User packages

    old.packages() #lists old packages
    update.packages(ask='graphics') #updates installed packages and lets you select which packages through a graphical interface (if this is available)
    update.packages(ask=FALSE) #updates installed packages without prompting
    
# File handling using read.table() and write table()

    pgc.mdd.full<-read.table('data/PGC_UKB_depression_genome-wide.txt', header=T)
    
    write.table(pgc.mdd.full,file = 'data/PGC_UKB_depression_genome-wide_OR.txt', sep = '\t', quote = FALSE, row.names = FALSE)

# Data frames
Create new empty data frame, using matrix

    newempty<-data.frame(matrix("somevalue",ncol = 3,nrow = 3))
    
Order

    irisOrder<-iris[order(iris$Sepal.Length),]
    
Subset
    
    irisSub<-iris[,c(1,3,4)]
    irisSub<-iris[which(iris$Species=='setosa' | iris$Species=='versicolor'),]
    
Make factor with updated levels

    irisSub$Species <- factor(irisSub$Species)

Standardisation on dataframes

    iris$Petal.Length.std<-scale(iris$Petal.Length)

Aggregate
    
    aggregate(Petal.Length ~ Species, FUN = mean, data = iris)
    
Regex subset of text column

    indexesLengths<-regexec(pattern = "^\\d+:(\\w+)_\\w+_\\w+", text=text)
    matches<-regmatches(text,indexesLengths)
    rsCore<-lapply(X = matches, FUN = function(x)x[2])

# R and relational databases (using PostgreSQL here)

## Connect to the database

    library(DBI)
    #install.packages('RPostgres')
    
    con <- dbConnect(RPostgres::Postgres(),
                     dbname = 'phenodb',
                     host = '10.200.105.5', # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'
                     port = 5432, # or any other port specified by your DBA
                     user = 'johan',
                     password = 'xxxxx')


## Fetching all data in a table/selection

    res <- dbSendQuery(con, "SELECT * FROM met.population")
    resDf<-dbFetch(res)
    dbClearResult(res)

## Fetching the data in parts

    res <- dbSendQuery(con, "SELECT * FROM met.population")
    while(!dbHasCompleted(res)){
      chunk <- dbFetch(res, n = 5)
      print(nrow(chunk))
    }
    dbClearResult(res)

## Inserting data to the database

    rs <- RPostgres::dbSendQuery(
      con, 
      "INSERT INTO johan.test(code,n,documentation) VALUES ($1,$2,$3);",
      params=list("first",3,"some value here")
    )
    
    dbFetch(rs) #don't need to do this for statements (such as above)
    dbClearResult(rs)


    # Does not work
    # rs <- dbSendQuery(
    #   con,
    #   "INSERT INTO johan.test(code,n,documentation) VALUES (?,?,?);",
    #   params = list("first",3,"some value here")
    # )
    # dbFetch(rs)
    # dbClearResult(rs)


## Insert a whole table

    dbWriteTable(con, "mtcars", mtcars)
    
## Inspect the database
These did not work for me.

    dbListTables(con)
    dbListFields(con, "mtcars")

## Disconnect from the database

    dbDisconnect(con)
