libname mydata '/folders/myfolders/StatsProgramming/Homework 3';
	data promotion;
	set mydata.promotion;

proc means data = promotion;
	class adtype;

proc means data = promotion mean p50;
	var Tvad;

proc univariate data = promotion plots;
	var Sales;

libname mydata '/folders/myfolders/StatsProgramming/Homework 3';
	data promotion;
	set mydata.promotion;

data promotion;
	set promotion;
	LogAd = log(TVad);
	
	newproduct = (Adtype = 'product');
	newbrand = (Adtype = 'brand');
	newmixed = (Adtype = 'mixed');
	
	if Adtype = 'NA' then do;
		newproduct = .;
		newbrand = .;
		newmixed = .;
	end;


proc means data = promotion;
	var display Tvad sales LogAd;

proc reg data = promotion;
	model Sales = Display LogAd newproduct newmixed;
run;
quit;

proc reg data = promotion;
	model Sales = Display LogAd newbrand newmixed;
run;
quit;

data promotion;
	set promotion; 
IntDL = Display*LogAd;

proc reg data = promotion;
	model Sales = Display LogAd IntDL newproduct newmixed / vif;
run;
quit;

proc means data = promotion;
	var Display LogAd;

data promotion;
	set promotion;
	Display_c = Display - 10.7380392;
	LogAd_c = LogAd - 8.6605083;
	IntDL_c = Display_c*LogAd_c;

proc reg data = promotion;
	model Sales = Display_c LogAd_c IntDL_c newproduct newmixed / vif;
run;
quit;


	























	
		