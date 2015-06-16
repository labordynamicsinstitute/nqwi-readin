## @knitr defs
nqwibase <- "http://lehd.ces.census.gov/data/qwi/us"
release <- "R2015Q1"
type <- "DVD-sa_f"
qwi_us_sa <- "qwi_us_sa_f_gn_ns_op_u.csv.gz"
qwir_us_sa <- "qwir_us_sa_f_gn_ns_op_u.csv.gz"
qwirv_us_sa <- "qwirv_us_sa_f_gn_ns_op_u.csv.gz"

## @knitr schemadefs
schemabase <- "http://lehd.ces.census.gov/data/schema"
schemaver <- "v4.1b-draft"

## @knitr readqwir
conr <- gzcon(url(
  paste(nqwibase,release,type,qwir_us_sa,
        sep="/")))
txt <- readLines(conr)
qwir <- read.csv(textConnection(txt))

## @knitr readqwirv
conrv <- gzcon(url(
  paste(nqwibase,release,type,qwirv_us_sa,
        sep="/")))
txtv <- readLines(conrv)
qwirv <- read.csv(textConnection(txtv))

## @knitr summary
summary(qwir[1:1000,c("HirAEndR")])[1:5]

## @knitr def_ids
ids <- read.csv(url
      (paste(schemabase,schemaver,
             "lehd_identifiers_qwi.csv",
             sep="/")
       ))

## @knitr print_ids
ids[1:3,1]
ids[1:3,3]

## @knitr subset
myvars <- merge(
  qwir[which(qwir$industry=="31-33"
             & qwir$agegrp %in% c("A04","A05")
             & qwir$sex   !="0"  ),
      c(as.vector(ids$Variable),
           "HirAEndR")],
  qwirv[,
      c(as.vector(ids$Variable),
           "st_HirAEndR","df_HirAEndR")]
  )

## @knitr prepareplot
library(zoo)
library(ggplot2)
library(RColorBrewer)
#Handle quarterly data
myvars$yyq <- as.Date(
  as.yearqtr(
    myvars$year+(myvars$quarter-1)/4,
    format = "%yQ%q")
  )

## @knitr createbounds
# Create bounds
myvars$HirAEndR_lo <-
  myvars$HirAEndR - 1.645*myvars$st_HirAEndR
myvars$HirAEndR_hi <-
  myvars$HirAEndR + 1.645*myvars$st_HirAEndR

## @knitr plot
gg <- ggplot(myvars[which(myvars$sex=="2"),],
       aes(x=yyq,y=HirAEndR,group=agegrp,color=agegrp),color="black") +geom_line()
gg <- gg  +geom_ribbon(aes(ymin=HirAEndR_lo,ymax=HirAEndR_hi,group=agegrp),
               alpha=0.2,fill="black",linetype="blank")
gg <- gg  +scale_color_brewer(palette="Set1")
gg
