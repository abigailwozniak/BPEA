% Set up data and calendars for wc15 project
% 9/2/2015, mww

if load_data == 1;
   % ----------- Features of Data Set ---------
   miss_code = 1.0e+32;

   % ----------- Sample Period, Calendars and so forth
   % Calendar Vector
   nfirst = [1967 2];
   nlast = [2015 4];
   [dnobs,calvec,calds] = calendar_make(nfirst,nlast,4);

   % --------------- Read In quarterly Data ---------------- 
   ns = 9;  % Number of Data Series
   xlsname = 'labor_series.xlsx';
   % Read Data 
   ndesc=0;
   ncodes=0;
   sheet='quarterly';
   [namevec,descmat,tcodemat,datevec,datamat] = readxls(xlsname,sheet,ns,dnobs,ndesc,ncodes);
   %tcodemat = tcodemat(1,:);
   if ndesc>0
      labelvec=descmat(:,1);
      labelvec=strtrim(labelvec);
   end  

   % Eliminate any leading or trailing blanks & Convert Names to upper case 
   namevec = strtrim(namevec);

   % Replace missing values with NaN
   isel = datamat == miss_code;
   datamat(isel) = NaN;

   for ni=1:length(namevec)
      % --- Get Series 
      assignin('base',namevec{ni},datamat(:,ni));
   end
   
   % Save Variable Series 
   slist = namevec;

   str_tmp = [matdir 'slist'];
   save(str_tmp,'slist');
   for iseries = 1:size(slist,1);
      save([matdir slist{iseries}],slist{iseries});
   end; 

   % --------------- Read In Annual Data ---------------- 
   nfirst_a = [1968 1];
   nlast_a = [2014 1];
   [dnobs_a,calvec_a,calds_a] = calendar_make(nfirst_a,nlast_a,1);

   ns_a = 8;  % Number of Data Series
   xlsname = 'labor_series.xlsx';
   % Read Data 
   ndesc_a=0;
   ncodes_a=0;
   sheet_a='yearly';
   [namevec_a,descmat_a,tcodemat_a,datevec_a,datamat_a] = readxls(xlsname,sheet_a,ns_a,dnobs_a,ndesc_a,ncodes_a);
   %tcodemat = tcodemat(1,:);
   if ndesc_a>0
      labelvec_a=descmat_a(:,1);
      labelvec_a=strtrim(labelvec_a);
   end  

   % Eliminate any leading or trailing blanks & append '_a'
   namevec_a = strcat(strtrim(namevec_a),{'_a'});

   % Replace missing values with NaN
   isel_a = datamat_a == miss_code;
   datamat(isel_a) = NaN;

   for ni=1:length(namevec_a)
      % --- Get Series 
      assignin('base',namevec_a{ni},datamat_a(:,ni));
   end
   
   % Save Variable Series 
   slist_a = namevec_a;

   str_tmp = [matdir 'slist_a'];
   save(str_tmp,'slist_a');
   for iseries = 1:size(slist_a,1);
      save([matdir slist_a{iseries}],slist_a{iseries});
   end; 

end;  %Load Data end;
 

% Load Variables and Give Standard Names 
load([matdir 'slist']); 
for iseries = 1:size(slist,1);
     load([matdir char(slist(iseries))]);
end; 

load([matdir 'slist_a']); 
for iseries = 1:size(slist_a,1);
     load([matdir char(slist_a(iseries))]);
end; 
