// This do-file sorts the closure databases and generate the closed and reopened dummies.

clear // Clearas the existing data
cd "C:\Users\theou\Documents\School Work\UW Madison\Spring 2022\Econ 580\Data\Scratch"


/*
	This section cleans and sorts the School Closure data by county, year, month
*/

sysuse schools_county
recast int year
recast byte month

rename countyfips3 county // countyfips3 is the code consistent with county in CPS


duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county year month

/*
	This section converts the dataset to panel data and generates the closed dummy with a cutoff of 50% and the reopened dummy with a cutoff of 10%.
*/
gen date_m = ym(year, month)
format date_m %tm
xtset county date_m // Converts to a panel data by countyfips3

gen i_closed = (share_all_closed_50 > .50) // Locates the months the county closed
replace i_closed = 1 if i_closed == 0 & l.i_closed == 1 

gen i_reopen = ( share_all_closed_50 < 0.1 & l.i_closed == 1) // Locates the months when the county reopened
replace i_reopen = 1 if i_reopen == 0 & l.i_reopen == 1

replace i_closed = 0 if i_reopen == 1


save schools_county_sorted, replace
