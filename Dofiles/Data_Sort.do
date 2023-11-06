// This do-file sorts schools closure, childcare closure, and covid cases and deaths samples by county, year, month after recasting them into corresponding formats in the CPS sample.

clear // Clearas the existing data
cd "C:\Users\theou\Documents\School Work\UW Madison\Spring 2022\Econ 580\Data\Scratch"

/*
	This section sorts and saves the School Closure data by county, year, month
*/

sysuse schools_county
recast int year
recast byte month
rename countyfips3 county // countyfips3 is the code consistent with county in CPS

duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county year month
save schools_county_sorted, replace

clear

/*
	This section sorts and saves the Childcare Closure data by county, year, month
*/

sysuse care_county
recast int year
recast byte month
rename countyfips3 county // countyfips3 is the code consistent with county in CPS

duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county year month
save care_county_sorted, replace

clear

/*
	This section cleans the Covid-19 Cases Data and sorts it by county, year, month.
*/

sysuse time_series_covid19_confirmed_US_county
rename fips county // fips is the county fips code

duplicates tag county, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county
save time_series_covid19_confirmed_US_county_sorted, replace

clear

/*
	This section cleans the Covid-19 Deaths Data and sorts it by county, year, month.
*/

sysuse time_series_covid19_deaths_US_county
rename fips county // fips is the county fips code

duplicates tag county, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county
save time_series_covid19_deaths_US_county_sorted, replace

clear