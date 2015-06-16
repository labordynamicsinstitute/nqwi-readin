schemabase <- "http://lehd.ces.census.gov/data/schema"
schemaver <- "v4.1b-draft"

nqwibase <- "http://lehd.ces.census.gov/data/qwi/us"
release <- "R2015Q1"
release <- "R2015Q1/DVD-sa_f"
qwi_us_sa <- "qwi_us_sa_f_gn_ns_op_u.csv.gz"
qwir_us_sa <- "qwir_us_sa_f_gn_ns_op_u.csv.gz"
qwirv_us_sa <- "qwirv_us_sa_f_gn_ns_op_u.csv.gz"
conr <- gzcon(url(paste(nqwibase,release,qwir_us_sa,sep="/")))
conrv <- gzcon(url(paste(nqwibase,release,qwirv_us_sa,sep="/")))

txt <- readLines(conr)
txtv <- readLines(conrv)
qwir <- read.csv(textConnection(txt))
qwirv <- read.csv(textConnection(txtv))

ids <- read.csv(url(paste(schemabase,schemaver,"lehd_identifiers_qwi.csv",sep="/")))

summary(qwir[,1:3])

library(zoo)
library(ggplot2)

myvars <- merge(qwir[which(qwir$industry=="31-33" & qwir$agegrp %in% c("A04","A05") & qwir$sex != "0"),c(as.vector(ids$Variable),"HirAEndR")],qwirv[,c(as.vector(ids$Variable),"st_HirAEndR")])
# Handle quarterly data
myvars$yyq <- as.Date(as.yearqtr(myvars$year+(myvars$quarter-1)/4,format = "%yQ%q"))
# Create bounds
myvars$HirAEndR_lo <- myvars$HirAEndR - 1.645*myvars$st_HirAEndR
myvars$HirAEndR_hi <- myvars$HirAEndR + 1.645*myvars$st_HirAEndR

ggplot(myvars[which(myvars$sex=="2"),],aes(x=yyq,y=HirAEndR,group=agegrp,color=agegrp),color="black")+geom_line() +geom_ribbon(aes(ymin=HirAEndR_lo,ymax=HirAEndR_hi,group=agegrp),alpha=0.2,fill="black",linetype="blank")+scale_color_brewer(palette="Set1")

