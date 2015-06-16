QWI with confidence bands in R
========================================================
author: Lars Vilhuber
date: 2015-06-16

In this short presentation,
- we will show you how to **dynamically** download QWI files within R
- we will show you how to leverage the **new** LEHD Schema files
- we will combine the **new** *rates* with the **new** *variability* measures to create a graph with error bands





You will need
========================================================
- a computer
- R or [Rstudio](http://www.rstudio.com) (free)
- Access to 

Setting up the necessary QWI info
========================================================
This allows us to reuse our code next quarter!

```r
nqwibase <- "http://lehd.ces.census.gov/data/qwi/us"
release <- "R2015Q1"
type <- "DVD-sa_f"
qwi_us_sa <- "qwi_us_sa_f_gn_ns_op_u.csv.gz"
qwir_us_sa <- "qwir_us_sa_f_gn_ns_op_u.csv.gz"
qwirv_us_sa <- "qwirv_us_sa_f_gn_ns_op_u.csv.gz"
```
Be sure you can access http://lehd.ces.census.gov/data/qwi/us/R2015Q1.
Setting up the necessary Schema info
========================================================

```r
schemabase <- "http://lehd.ces.census.gov/data/schema"
schemaver <- "v4.1b-draft"
```
We could also have read the schema from the version metadata!

Reading in the Gzipped data directly from website
========================================================
This might take a few minutes:

```r
conr <- gzcon(url(
  paste(nqwibase,release,type,qwir_us_sa,
        sep="/")))
txt <- readLines(conr)
qwir <- read.csv(textConnection(txt))
```

Repeating it for the variability measures
========================================================
This might take a few minutes:

```r
conrv <- gzcon(url(
  paste(nqwibase,release,qwirv_us_sa,
        sep="/")))
txtv <- readLines(conrv)
qwirv <- read.csv(textConnection(txtv))
```

Some extract from the data
==========================

```r
summary(qwir[1:1000,c("HirAEndR")])[1:5]
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu. 
 0.0612  0.1140  0.1658  0.2152  0.2993 
```

Reading in schema data
========================
We want to get a list of the variables that are record identifiers for the QWI.

```r
ids <- read.csv(url
      (paste(schemabase,schemaver,
             "lehd_identifiers_qwi.csv",
             sep="/")
       ))
```

Result of reading in schema data
========================

```r
ids[1:3,1]
```

```
[1] periodicity seasonadj   geo_level  
16 Levels: agegrp education ethnicity firmage firmsize ... year
```

```r
ids[1:3,3]
```

```
[1] Periodicity of report                 
[2] Seasonal Adjustment Indicator         
[3] Group: Geographic level of aggregation
16 Levels: Group: Age group code (WIA) ... Time: Year
```

Let's prepare the data for plotting
========================================================
Subset the data to manufacturing, certain age groups, keep ids and variables of interest:

```r
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
```
and some other setup (see code).


Create upper and lower 90% confidence bounds 
========================================================


```r
# Create bounds
myvars$HirAEndR_lo <- 
  myvars$HirAEndR - 1.645*myvars$st_HirAEndR
myvars$HirAEndR_hi <- 
  myvars$HirAEndR + 1.645*myvars$st_HirAEndR
```
Strictly speaking, we would want this to be
$$X_t - t(0.95,df\_X_t) st\_X_t$$
and
$$X_t + t(0.95,df\_X_t) st\_X_t $$
but this is close enough.

Plotting it all for women
==============
![plot of chunk unnamed-chunk-11](Pres_qwi_error_bands-figure/unnamed-chunk-11-1.png) 

License
==========
![by-nc 4.0](images/cc4-by-nc-88x31.png)

Programs to read in National QWI files and variability measures by [Lars Vilhuber](http://www.vilhuber.com/lars/)  is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/)
