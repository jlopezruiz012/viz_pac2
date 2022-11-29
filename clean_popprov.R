# Lectura del fitxer
populationDF <- read.csv("raw_data/9687bsc.csv", na.strings = "NA", sep=";", encoding = "UTF-8")

# Eliminació de les columnes no necessàries
keepcols <- c("Provincias","Total")
populationDF <- populationDF[,keepcols]

# Neteja de les dades de la columna 'Provincias'. Eliminació del codi
populationDF$Provincias <- substring(populationDF$Provincias,4)

# Obtenció de les files corresponents a les províncies catalanes
cat_provs <- c("Barcelona","Girona","Lleida","Tarragona")
populationDF <- populationDF[populationDF$Provincias %in% cat_provs,]

# Formatació del total de població a variable numèrica sencera
populationDF$Total <- substring(populationDF$Total,1,nchar(populationDF$Total)-7)
populationDF$Total <- as.integer(gsub("\\.","",populationDF$Total))

# Creació d'un csv amb les dades netejades
write.csv(populationDF,"data/popcat.csv", row.names= FALSE, fileEncoding = "UTF-8")
