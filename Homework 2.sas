data BasicInfo;
infile '/folders/myfolders/StatsProgramming/Basic Info.xls' 
 delimiter=',' dsd firstobs=2;
 input ID Female $ Region :$9. ; 
run;

proc import
 
 datafile = '/folders/myfolders/StatsProgramming/HistData1.xlsx'
 dbms = xlsx replace
 out = HistData1;
 getnames = yes;
 
run;
proc import
 
 datafile = '/folders/myfolders/StatsProgramming/HistData2.xlsx'
 dbms = xlsx replace
 out = HistData2;
 getnames = yes;
 
run;
data HistData;
 set HistData1 HistData2;
 
run;

proc sort data = BasicInfo;
by ID;
run;

proc sort data = HistData;
by ID;
run;

data Combined;
merge BasicInfo (in = inBasicInfo) HistData (in = inHistData);
by ID;
if inBasicInfo = 1 and inHistData = 1;
run;

data Combined;

	set Combined;
	
	if Region = "Northeast" then RegionGroup = 1;
	else if Region = "Midwest" then RegionGroup = 1;
	else if Region = "South" then RegionGroup = 2;
	else if Region = "West" then RegionGroup = 2;

run;

proc freq data = Combined;
 	
 	table RegionGroup;
 
run;

data Combined;

	set Combined;
	
	if Referral = 999 then Referral = .;
	else if DirectMarketing = 999 then DirectMarketing = .;
	else if Brochure = 999 then Brochure = .;
	else if Other = 999 then Other = .;

run;

data Combined;

	set Combined;
	
	if Referral = 1 then Acquisition = 1 ;
	else if DirectMarketing = 1 then Acquisition = 2 ;
	else if Brochure = 1 then Acquisition = 3 ;
	else if Other = 1 then Acquisition = 4 ;
	
run;

proc freq data = Combined;

	table Acquisition * Female;

run;

*There does not seem to be a huge difference in 
males vs. females with regards to 
type of acquisition channel. Only in 
acquisition channel 4, Other, is there a difference in 
percentage of males at about 56% and females at 43%;


proc sgplot data = Combined;
	
	vbar Acquisition / group = female groupdisplay = cluster;
	
run;

data Combined;

	set Combined;
	if YearSince < 1000 then YearSince = YearSince + 1900;

run;

data Combined;

	set Combined;
	AcquireTime = mdy(MonthSince, 15, YearSince);
	format AcquireTime MMDDYY10.;
	
run;

data Combined;

	set Combined;
	TenureYears = ('10sep2016'd - AcquireTime)/365;
	TenureYears = round(TenureYears, .1);
	
run;

proc univariate data = Combined;
	
	var TenureYears;

run;

data Combined;

	set combined;
	if PastPurchase = -99 then PastPurchase = .;

run;

proc univariate data = Combined plots;
	
	var PastPurchase;
	
run;


data Combined;

	set Combined;
	LogPurchase = log(PastPurchase);

run;	

proc univariate data = Combined plots; 
	
	var LogPurchase;
	
run;

proc corr data = Combined;

	var PastPurchase -- TenureYears;
	
run;

proc corr data = Combined;

	var TenureYears -- LogPurchase;
	
run;

proc sgplot data = Combined;
	scatter x = TenureYears y = PastPurchase;
run;

proc sgplot data = Combined;
	scatter x = TenureYears y = LogPurchase;
run;

proc means data = Combined p25 p50 p75;
	var PastPurchase;
run;

data combined;
set combined;

if PastPurchase < 89.125 then PurchaseLevel = 1 ;
	else if 89.125 <= PastPurchase < 271.130 then PurchaseLevel = 2 ;
	else if 271.130 <= PastPurchase < 1635.980 then PurchaseLevel = 3 ;
	else if PastPurchase >= 1635.980 then PurchaseLevel = 4 ;
	
	if PastPurchase = . then PurchaseLevel = .;
	
run;

data combined;
	set combined;
	NewFemale = input(Female,BEST1.);
run;

data Combined;

	set Combined;
	if RegionGroup = 1 then Region1 = 1;
	else if RegionGroup = 2 then Region1 = 0 ;

run;

proc means data = combined;

class PurchaseLevel;
var NewFemale TenureYears Renewal RegionGroup;
output out = SumData
	mean(NewFemale) = PctFemale
	mean(TenureYears) = MeanYear
	std(TenureYears) = SDYear
	P80(TenureYears) = P80Year
	mean(Renewal) = PctRenewal
	mean(Region1) = PctRegion1;

run;

data SumData;
	set SumData;
 	if PurchaseLevel = . then delete;
 	drop _Type_;
 	rename _Freq_ = Nobs;
run;

proc sort data = SumData;
	by PurchaseLevel;
run;
	
proc sort data = Combined;
	by PurchaseLevel;
run;

data Combined;
	merge SumData Combined;
	by PurchaseLevel;
run;


	
	
	