QWI with confidence bands in Excel
========================================================
author: Lars Vilhuber
date: 2015-06-16

In this short presentation,
- we will combine the **new** *rates* with the **new** *variability* measures to create a graph with error bands in Excel

You will need access to
===================
- Excel
- National QWI http://lehd.census.gov/lehd/data/qwi_national_beta.html or http://go.usa.gov/3EDUG

LEHD Data Page
===============
![Screenshot](images/test-2015-06-15-21-39-35.png)
 
National QWI Beta page
===============
![Screenshot](images/test-2015-06-15-21-39-57.png)
 
To download data, scroll to the bottom
===============
![Screenshot](images/test-2015-06-15-21-42-20.png)
 
Direct download
================

http://lehd.ces.census.gov/data/qwi/us/R2015Q1/

or

http://go.usa.gov/3EDUz

Downloaded data is gzipped
===============
![Screenshot](images/test-2015-06-15-21-44-31.png)
 
Unzipping data
===============
Use any number of ZIP-compatible products to unzip (here: [7zip](http://www.7zip.com)). Right-click, extract.
![Screenshot](images/test-2015-06-15-21-49-31.png)
 
Loading into Excel
===============
Simply double-click on both files
![Screenshot](images/test-2015-06-15-21-53-50.png)
 
Combining sheets
===============
For simplicity, we move the sheets into the same workbook.
![Screenshot](images/test-2015-06-15-21-55-14.png)
 
A single statistics
===============
We focus on HirAEndR (and deleted most other columns after it)
![Screenshot](images/test-2015-06-15-22-09-53.png)
 
Identify standard error on other tab
===============
![Screenshot](images/test-2015-06-15-22-10-39.png)
 
Creating bounds
===============
On first tab, create columns *H_low* and *H_high*
![Screenshot](images/test-2015-06-15-22-15-53.png)
 
Formulae
==========
left: 65%

**Strict** 

$$X_{low} = X_t - t(0.95,df\_X_t) st\_X_t$$

i.e.

*h_low = HirAEndR –*

 *t(df_HirAEndR,0.95)*st_HirAEndR*


**Approximate**

$$X_{low} = X_t - 1.645 st\_X_t$$

i.e.

h_low = HirAEndR – 
1.645*st_HirAEndR
 
 
Fill in entire column
===============
![Screenshot](images/test-2015-06-15-22-16-39.png)
 
Filter to the desired characteristics
===============
![Screenshot](images/test-2015-06-15-22-16-58.png)
 
Filtered series
===============
![Screenshot](images/test-2015-06-15-22-17-39.png)
 
 
Create date column
===============
as *=Date(year,(quarter-1)*3+1,1)*
===============
![Screenshot](images/test-2015-06-15-22-28-23.png)
 
Select columns for graphing
==================
You want the *yyq*, *HirAEndR* and the high/low columns
![Screenshot](images/test-2015-06-15-22-28-30.png)
 
 
Choose area or line graph
===============
We'll be changing it shortly anyway...
![Screenshot](images/test-2015-06-15-22-32-27.png)
 
Modify the Chart types
===============
![Screenshot](images/test-2015-06-15-22-33-53.png)
 
Creating bounds
===============
Select "Line" for main series, "Area" for bounds 
![Screenshot](images/test-2015-06-15-22-37-51.png)
 (not "Stacked Area"!)

Format graph
============
- Delete legend
- H_high should come before H_low in order
  - color light blue
- H_low last in order
  - Color white (not transparent!)
- Adjust size

Voilà!
===============
![Screenshot](images/test-2015-06-15-22-44-11.png)

License
==========
![by-nc 4.0](images/cc4-by-nc-88x31.png)

Programs to read in National QWI files and variability measures by [Lars Vilhuber](http://www.vilhuber.com/lars/)  is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/)
