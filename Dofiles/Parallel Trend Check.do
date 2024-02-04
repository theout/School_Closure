clear

use ".\Scratch\CPS_1"

keep if year == 2018 | year == 2019 | year == 2020 | year == 2021

drop if county == 0 
gen hoursworking = ahrsworkt if ahrsworkt != 999

gen date_m = ym(year, month)
format date_m %tm
xtset cpsidp date_m

gen i_schoolage = (age >=5 & age < 18)
bysort cpsid year month: egen hasSchoolAgeChild = max(i_schoolage)
gen i_youngage = (age < 5)
bysort cpsid year month: egen hasYoungChild = max(i_youngage)
// Remove the children
keep if age >= 21 


drop if occ2010 == 9999

// Merge the teleworkability data
merge m:1 occ2010 using ".\Raw Data\teleworkability_crosswalk.dta"
keep if _merge==3

// Remove the occupations where teleworkability is not available
drop if teleworkability == -1


// Generate the parallel trend graphs
bysort date_m hasSchoolAgeChild: egen avg_hours = mean(hoursworking)
bysort date_m hasSchoolAgeChild: egen avg_teleworkability = mean(teleworkability)

twoway (line avg_hours date_m if hasSchoolAgeChild == 1, lcolor(blue)) ///
       (line avg_hours date_m if hasSchoolAgeChild == 0, lcolor(red)), ///
       legend(label(1 "Has School-age Child") label(2 "No School-age Child")) ///
       title("Trends in Weekly Working Hours") ///
       xtitle("Time") ytitle("Average Working Hours/Week")

graph save ".\Output\workinghours_trend", replace

twoway (line avg_teleworkability date_m if hasSchoolAgeChild == 1, lcolor(blue)) ///
       (line avg_teleworkability date_m if hasSchoolAgeChild == 0, lcolor(red)), ///
       legend(label(1 "With School-age Child") label(2 "No School-age Child")) ///
       title("Trends in Teleworkability") ///
       xtitle("Time") ytitle("Average Working Hours/Week")

graph save ".\Output\teleworkability_trend", replace