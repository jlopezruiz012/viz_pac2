# Càrrega de les llibreries necessàries
library(dplyr)

# Lectura del fitxer
viatgersDF <- read.csv("raw_data/barcelona_viajeros_por_franja_csv.csv", 
                       na.strings = "NA", sep=";", encoding = "UTF-8")


# Creació d'una columna amb el total de viatgers per franja
viatgersDF$VIAJEROS_TOTAL <- viatgersDF$VIAJEROS_SUBIDOS + viatgersDF$VIAJEROS_BAJADOS

# Obtenció dels fluxes totals diaris per estació
totalFlowDF <- viatgersDF %>% group_by(NOMBRE_ESTACION) %>% summarise(TOTAL = sum(VIAJEROS_TOTAL))
totalFlowDF <- totalFlowDF %>% arrange(desc(TOTAL))

# Obtenció de les estacions entre les posicions 11 i 18 (representatives)
estacions <- totalFlowDF[c(11:18),1]$NOMBRE_ESTACION

# Filtrat del dataframe per a les estacions seleccionades
viatgers_subDF <- viatgersDF[viatgersDF$NOMBRE_ESTACION %in% estacions,]

# Eliminació de les columnes no necessàries
keepcols <- c("NOMBRE_ESTACION","TRAMO_HORARIO","VIAJEROS_TOTAL")
viatgers_subDF <- viatgers_subDF[,keepcols]

# Transformació de la variable "TRAMO_HORARIO" per a obtenir trams d'una hora
viatgers_subDF$TRAMO_HORARIO <- as.integer(substring(viatgers_subDF$TRAMO_HORARIO,1,2))

# Obtenció del fluxe de viatgers per franja horària
viatgers_subDF <- viatgers_subDF %>% group_by(NOMBRE_ESTACION,TRAMO_HORARIO) %>%
  summarise(TOTAL = sum(VIAJEROS_TOTAL))

# Creació d'un csv amb les dades netejades
write.csv(viatgers_subDF,"data/rodalies.csv", row.names = FALSE, fileEncoding = "UTF-8")
