# Definició d'una funció que calculi diferències entre elements d'un vector
pop_deltas <- function(pop) {
  
  v <- c(0)
  
  for(i in 1:length(pop)){
    if(i>1){
      #v <- append(v,pop[i]-pop[i-1])
      if (pop[i-1] == 0) {
        v <- append(v,0)
      } else {
        v <- append(v,round((pop[i]-pop[i-1])*100/pop[i-1],2))
      }
    }
  }
  
  return (v)
}

# Lectura del fitxer
popdtDF <- read.csv("raw_data/pmh446at.csv", na.strings = "NA", sep=";", encoding = "UTF-8")

# Eliminació de les files i columnes no necessàries
colnames(popdtDF)[2] <- "ambit"
popdtDF <- popdtDF[popdtDF$sexe == "total",]
popdtDF <- popdtDF[popdtDF$ambit != "Catalunya",]

keepcols <- c("any","ambit","valor")
popdtDF <- popdtDF[,keepcols]

# Conversió a integer de les dades de la columna 'valor'. El valor "null" passa a ser 0
popdtDF$valor[popdtDF$valor == "null"] <- 0
popdtDF$valor <- as.integer(popdtDF$valor)

# Creació d'una columna amb la variació de població per àmbit territorial
popdtDF$diferencia <- 0

ambits <- unique(popdtDF$ambit)

# Aplicació de la funció per a calcular la diferència de població a cada àmbit territorial
for (dt in ambits){
  popdtDF$diferencia[popdtDF$ambit == dt] <- pop_deltas(popdtDF[popdtDF$ambit==dt,]$valor)
}

# Eliminació de les dades de l'any 1998 que no aporten informació rellevant de diferències
popdtDF<- popdtDF[popdtDF$any != "1998",]

# Creació d'un csv amb les dades netejades
write.csv(popdtDF,"data/diffpopcat.csv", row.names= FALSE, fileEncoding = "UTF-8")
