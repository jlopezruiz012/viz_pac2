# Càrrega de les llibreries necessàries
library(dplyr)

# Lectura del fitxer
pop_bcnDF <- read.csv("raw_data/2022_padro_sexe.csv", na.strings = "NA", encoding = "UTF-8")

# Eliminació de les columnes no necessàries
keepcols <- c("Nom_Districte","Sexe","Nombre")
pop_bcnDF <- pop_bcnDF[,keepcols]

# Agregació del total de població per districte
pop_bcn_cleanDF <- pop_bcnDF %>% group_by(Nom_Districte) %>% summarise(Habitants = sum(Nombre))

# Creació d'un csv amb les dades netejades
write.csv(pop_bcn_cleanDF,"data/popbcn.csv", row.names = FALSE, fileEncoding = "UTF-8")
