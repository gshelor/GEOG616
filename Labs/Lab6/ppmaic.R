ppmaic <- function(modnames){
options("scipen"=100, "digits"=4)
ppm.aictab <- data.frame(model=modnames, AIC = 0)
for(i in 1:length(modnames)){
ppm.aictab$AIC[i] <- AIC(get(modnames[i]))
}
ppm.aictab <- ppm.aictab[order(ppm.aictab$AIC),]
ppm.aictab$Delta[2:length(modnames)] <- ppm.aictab$AIC[2:length(modnames)] - ppm.aictab$AIC[1]
ppm.aictab$Delta[1] <- 0
ppm.aictab$wi <- exp(-0.5*ppm.aictab$Delta)
ppm.aictab$W <- ppm.aictab$wi/sum(ppm.aictab$wi)
return(ppm.aictab)
}
