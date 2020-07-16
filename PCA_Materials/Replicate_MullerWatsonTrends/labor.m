% wc15_b.m
% bivariate analysis
% September 3, 2015
%
clear all;
small = 1.0e-10;
rng(fix(9797696));

% -- File Directories   
outdir = 'out/';
figdir = 'fig/';
matdir = 'mat/';

load_data = 1;
labor_data;


% Set up variables to study
varstr = {'eu','ue','en','ne','factor'};
varstr_a = {'eu_a','ue_a','en_a','ne_a','empchangeipums_a','smigirs_a','jdr_a','jcr_a'};

nper = 4;
sfirst = [1967 2];  % First obs to use (truncated if later)
slast = [2015 4];   % Last Obs to use (truncated if earlier)

nper_a = 1;
sfirst_a = [1968 1];  % First obs to use (truncated if later)
slast_a = [2014 1];   % Last Obs to use (truncated if earlier)
% q = 1;
q = [2,3,4,5,6,7,8,9,10,11,12];

X_raw = cell(1,length(varstr));
calvec_c = cell(1,length(varstr));
dnobs = cell(1,length(varstr));
X_raw_a = cell(1,length(varstr_a));
calvec_a_c = cell(1,length(varstr_a));
dnobs_a = cell(1,length(varstr_a));

outfig_name = [figdir 'labor_figs.ps'];
subplot(length(varstr),2,1);
set(gcf,'PaperPositionMode','manual',...
        'PaperType','usletter',...
        'PaperOrientation','portrait',...
        'PaperUnits','inches',...
        'PaperPosition',[.25,.25,8,10.5]);

for qi = 1:length(q);
   for vv = 1:length(varstr);
      if (isempty(X_raw{vv}));
         eval(['X_raw{vv} = ' varstr{vv} ';']);
       
         % Save series over desired sample period
         tmp = packr([calvec X_raw{vv}]);
         calvec_c{vv} = tmp(:,1);
         X_raw{vv} = tmp(:,2);
         ismpl = smpl(calvec_c{vv},sfirst,slast,nper);
         calvec_c{vv} = calvec_c{vv}(ismpl==1);
         dnobs{vv} = size(calvec_c{vv},1);
         X_raw{vv} = X_raw{vv}(ismpl==1);
      end

      % --- Step 2: Compute Cosine Transforms and some summary statistics
      % Some Summary Statistics 
      [X_mean{qi,vv},X_cos{qi,vv}] = xp_compute(X_raw{vv},q(qi));
      X_var_lr{qi,vv} = dnobs{vv}*mean(X_cos{qi,vv}.^2);
      X_norm{qi,vv} = X_cos{qi,vv}/sqrt(X_cos{qi,vv}'*X_cos{qi,vv}); 
      psi = psi_compute(dnobs{vv},q(qi));
      X_proj{qi,vv} = psi*(inv(psi'*psi))*X_cos{qi,vv};
      X_proj_m{qi,vv} = X_proj{qi,vv} + X_mean{qi,vv};

   end

   for vv = 1:length(varstr_a);
      if (isempty(X_raw_a{vv}));
         eval(['X_raw_a{vv} = ' varstr_a{vv} ';']);
       
         % Save series over desired sample period
         tmp = packr([calvec_a X_raw_a{vv}]);
         calvec_a_c{vv} = tmp(:,1);
         X_raw_a{vv} = tmp(:,2);
         ismpl = smpl(calvec_a_c{vv},sfirst_a,slast_a,nper_a);
         calvec_a_c{vv} = calvec_a_c{vv}(ismpl==1);
         dnobs_a{vv} = size(calvec_a_c{vv},1);
         X_raw_a{vv} = X_raw_a{vv}(ismpl==1);
      end

      % --- Step 2: Compute Cosine Transforms and some summary statistics
      % Some Summary Statistics 
      [X_mean_a{qi,vv},X_cos_a{qi,vv}] = xp_compute(X_raw_a{vv},q(qi));
      X_var_lr_a{qi,vv} = dnobs_a{vv}*mean(X_cos_a{qi,vv}.^2);
      X_norm_a{qi,vv} = X_cos_a{qi,vv}/sqrt(X_cos_a{qi,vv}'*X_cos_a{qi,vv}); 
      psi = psi_compute(dnobs_a{vv},q(qi));
      X_proj_a{qi,vv} = psi*(inv(psi'*psi))*X_cos_a{qi,vv};
      X_proj_m_a{qi,vv} = X_proj_a{qi,vv} + X_mean_a{qi,vv};

   end
end

for qi = 1:length(q);
   for vv = 1:length(varstr);
      subplot(length(varstr),2,2*vv-1)   
         set(gca,'FontSize', 8, 'FontUnits','points');
         %  Figure 1
         plot(calvec_c{vv},X_raw{vv},'-b','LineWidth',1);
         hold on;
         plot(calvec_c{vv},X_proj_m{qi,vv},'-r','LineWidth',2);
         if (~strcmp(varstr{vv},'factor'));
            eval(['plot(calvec_c{vv},' varstr{vv} '_cea_long,''-k'',''LineWidth'',2)']);
            plot(calvec_a_c{vv},X_raw_a{vv},'-m','LineWidth',1);
            plot(calvec_a_c{vv},X_proj_m_a{qi,vv},'-g','LineWidth',2);
         end;
         hold off;
         title([varstr{vv} sprintf(' (q = %d)',q(qi))]);
         xlabel('Date'); 

      subplot(length(varstr),2,2*vv)
         set(gca,'FontSize', 8, 'FontUnits','points');
         % Plot Cosine Transforms
         ct_vec = [1:1:q(qi)]';
         plot(ct_vec,X_cos{qi,vv},':or','MarkerSize',3,'LineWidth',1);
         if (~strcmp(varstr{vv},'factor'));
            hold on
            plot(ct_vec,X_cos_a{qi,vv},':sg','MarkerSize',3,'LineWidth',1);
            hold off;
         end
         xlabel('Cosine Transform');
         xlim([0 12]);
   end

   if (qi==1);
      print('-dpsc2',[figdir 'charts.ps']);
   else;
      print('-dpsc2','-append',[figdir 'charts.ps']);
   end;
end;


for qi = 1:length(q);
   for vv = 5:length(varstr_a);
      subplot(length(varstr_a)-4,2,2*(vv-4)-1)   
         set(gca,'FontSize', 8, 'FontUnits','points');
         %  Figure 1
         plot(calvec_a_c{vv},X_raw_a{vv},'-b','LineWidth',1);
         hold on;
         plot(calvec_a_c{vv},X_proj_m_a{qi,vv},'-r','LineWidth',2);
         hold off;
         %legend(varstr{vv},sprintf([varstr{vv} ' Low Frequency Projection (q = %d)'],q(qi)));
         %h=legend('Location','NorthEast');
         title([varstr_a{vv} sprintf(' (q = %d)',q(qi))]);
         xlabel('Date'); 

      subplot(length(varstr_a)-4,2,2*(vv-4))
         set(gca,'FontSize', 8, 'FontUnits','points');
         % Plot Cosine Transforms
         ct_vec = [1:1:q(qi)]';
         plot(ct_vec,X_cos_a{qi,vv},':or','MarkerSize',3,'LineWidth',1);
         % legend(varstr{vv});
         % legend('Location','NorthEast');
         xlabel('Cosine Transform');
         xlim([0 12]);
   end

   if (qi==1);
      print('-dpsc2',[figdir 'charts_a.ps']);
   else;
      print('-dpsc2','-append',[figdir 'charts_a.ps']);
   end;
end;

for qi = 1:length(q);
   outfile_name = [outdir sprintf('labor_q%d.out',q(qi))];
   fid_out = fopen(outfile_name,'w');

   fprintf(fid_out,[' Date and Time: ' datestr(now) '\n']); 
   fprintf(fid_out,'   Number of Cosine Transformations %4d\n',q(qi));

   for vv=1:length(varstr)
      fprintf(fid_out,['   Series name: ' varstr{vv} '\n']);
      fprintf(fid_out, '      First obs = %6.2f\n',calvec_c{vv}(1));
      fprintf(fid_out, '      Last obs = %6.2f\n',calvec_c{vv}(end));
      fprintf(fid_out, '      Number of Obs %4.0f\n',dnobs{vv});
      fprintf(fid_out, '      Number of Years %4.1f\n',dnobs{vv}/nper);
      fprintf(fid_out,'       Cutoff periodicity (in years) = %4.1f\n\n',(2*dnobs{vv}/q(qi))/nper);
      fprintf(fid_out, '      Sample Mean = %6.2f\n',X_mean{qi,vv});
      fprintf(fid_out, '      Sample Std. Dev. = %6.2f\n',std(X_raw{vv}));
      fprintf(fid_out, '      LR SD (Low-Freq I(0)) = %6.2f\n\n',sqrt(X_var_lr{qi,vv}));
   end
   fprintf(fid_out,    '   Sample Correlations:\n');
   for v1=1:(length(varstr)-1)
      for v2=(v1+1):length(varstr)
          % Sample Correlation
          cor_I0{qi,v1,v2} = (X_cos{qi,v2}'*X_cos{qi,v1})/sqrt((X_cos{qi,v1}'*X_cos{qi,v1})*(X_cos{qi,v2}'*X_cos{qi,v2}));
          fprintf(fid_out,['      I(0) weighted (' varstr{v1} ' & ' varstr{v2} '): %6.2f\n'],cor_I0{qi,v1,v2});
      end
   end
   fprintf(fid_out,'\n');

   for v1=1:(length(varstr_a)-1)
      for v2=(v1+1):length(varstr_a)
          % Sample Correlation
          cor_I0_a{qi,v1,v2} = (X_cos_a{qi,v2}'*X_cos_a{qi,v1})/sqrt((X_cos_a{qi,v1}'*X_cos_a{qi,v1})*(X_cos_a{qi,v2}'*X_cos_a{qi,v2}));
      end
   end

   %     
   %   % Compute Regression Coefficient, etc.
   tcv = tinv(0.95,q(qi)-1);
   for v1=1:(length(varstr)-1)
      for v2=(v1+1):length(varstr)
         bhat{qi,v1,v2} = X_cos{qi,v1}\X_cos{qi,v2};
         xxi{qi,v1} = 1/(X_cos{qi,v1}'*X_cos{qi,v1});
         Xhat_cos{qi,v1,v2} = X_cos{qi,v1}*bhat{qi,v1,v2};
         U_cos{qi,v1,v2} = X_cos{qi,v2}-Xhat_cos{qi,v1,v2};
         ssr{qi,v1,v2} = U_cos{qi,v1,v2}'*U_cos{qi,v1,v2};
         tss{qi,v1,v2} = X_cos{qi,v2}'*X_cos{qi,v2};
         rss{qi,v1,v2} = Xhat_cos{qi,v1,v2}'*Xhat_cos{qi,v1,v2};
         s2_u{qi,v1,v2} = ssr{qi,v1,v2}/(q(qi)-1);
         se_bhat{qi,v1,v2} = sqrt(s2_u{qi,v1,v2}*xxi{qi,v1});
         r2{qi,v1,v2} = 1-ssr{qi,v1,v2}/tss{qi,v1,v2};

         fprintf(fid_out,['   Regression of ' varstr{v2} ' onto ' varstr{v1} ':\n']);
         fprintf(fid_out, '      |BetaHat                : %6.2f (%5.2f)\n',bhat{qi,v1,v2},se_bhat{qi,v1,v2});
         fprintf(fid_out, '      |tstat for BetaHat      : %6.2f\n',bhat{qi,v1,v2}/se_bhat{qi,v1,v2});
         fprintf(fid_out, '      |90 Percent CI for Beta : %6.2f to %6.2f\n',bhat{qi,v1,v2}-(se_bhat{qi,v1,v2}*tcv),bhat{qi,v1,v2}+(se_bhat{qi,v1,v2}*tcv)); 
         fprintf(fid_out, '      |SER                    : %6.2f \n',sqrt(s2_u{qi,v1,v2}));
         fprintf(fid_out, '      |R^2                    : %6.2f \n\n',r2{qi,v1,v2});
      end
   end


 
   % Construct confidence set for correlation
   cor_size = .100;
   pctl = cor_size/2;
   pctu = 1-pctl;
   nrep = 50000;


   e1 = randn(q(qi),nrep);
   e2 = randn(q(qi),nrep);
   a11 = sum(e1.^2)';
   a22 = sum(e2.^2)';
   a12 = sum(e1.*e2)';
   ngrid = 501;
   rho_grid = linspace(-1,1,ngrid)';
   pctl_vec = NaN(ngrid,1);
   pctu_vec = NaN(ngrid,1);
   syy = a11;
   for i = 1:ngrid;
      rho = rho_grid(i);
      tmp = sqrt(1-rho*rho);
      syx = rho*a11+tmp*a12;
      sxx = rho*rho*a11 + tmp*tmp*a22 + 2*rho*tmp*a12;
      rhat = syx./sqrt(sxx.*syy);
      pct = pctile(rhat,[pctl;pctu]);
      pctl_vec(i) = pct(1);
      pctu_vec(i) = pct(2);
   end;


   for v1=1:(length(varstr)-1)
     for v2=(v1+1):length(varstr)
        tmp = (pctl_vec < cor_I0{qi,v1,v2}).*(pctu_vec > cor_I0{qi,v1,v2});
        cor_cset = rho_grid(tmp==1);
        cor_ci_lower{qi,v1,v2} = min(cor_cset);
        cor_ci_upper{qi,v1,v2} = max(cor_cset);
        fprintf(fid_out,['       90 Percent CI for (' varstr{v1} ',' varstr{v2} ') correlation: %6.2f to %6.2f\n'],cor_ci_lower{qi,v1,v2},cor_ci_upper{qi,v1,v2});
        fprintf(fid_out,['       90 Percent CI for (' varstr{v1} ',' varstr{v2} ') R^2        : %6.2f to %6.2f\n'],...
           ((cor_ci_lower{qi,v1,v2}*cor_ci_upper{qi,v1,v2}>0)*min(abs(cor_ci_upper{qi,v1,v2}),abs(cor_ci_lower{qi,v1,v2})))^2, ...
           max(abs(cor_ci_upper{qi,v1,v2}),abs(cor_ci_lower{qi,v1,v2}))^2);
      end
   end

   for v1=1:(length(varstr_a)-1)
     for v2=(v1+1):length(varstr_a)
        tmp = (pctl_vec < cor_I0_a{qi,v1,v2}).*(pctu_vec > cor_I0_a{qi,v1,v2});
        cor_cset = rho_grid(tmp==1);
        cor_ci_lower_a{qi,v1,v2} = min(cor_cset);
        cor_ci_upper_a{qi,v1,v2} = max(cor_cset);
      end
   end
end

outfile_name = [outdir 'summary.out'];
fid_out = fopen(outfile_name,'w');

for v1=1:(length(varstr)-1)
   for v2=(v1+1):length(varstr)
      fprintf(fid_out,[strjoin(repmat({'%15d'},[1 length(q)]),',') '\n'],q);
      fprintf(fid_out,[strjoin(repmat({'         %6.2f'},[1 length(q)]),',') '\n'],cell2mat({cor_I0{:,v1,v2}}));
      fprintf(fid_out,[strjoin(repmat({'(%6.2f,%6.2f)'},[1 length(q)]),',') '\n'],[cell2mat({cor_ci_lower{:,v1,v2}}); cell2mat({cor_ci_upper{:,v1,v2}})]);
   end
end

outfile_name = [outdir 'summary_a.out'];
fid_out = fopen(outfile_name,'w');

for v1=1:(length(varstr_a)-1)
   for v2=(v1+1):length(varstr_a)
      fprintf(fid_out,[strjoin(repmat({'%15d'},[1 length(q)]),',') '\n'],q);
      fprintf(fid_out,[strjoin(repmat({'         %6.2f'},[1 length(q)]),',') '\n'],cell2mat({cor_I0_a{:,v1,v2}}));
      fprintf(fid_out,[strjoin(repmat({'(%6.2f,%6.2f)'},[1 length(q)]),',') '\n'],[cell2mat({cor_ci_lower_a{:,v1,v2}}); cell2mat({cor_ci_upper_a{:,v1,v2}})]);
   end
end

outfile_name = [outdir 'quarterly.csv'];
fid_out = fopen(outfile_name,'w');

% make the projections of uniform length by padding with NaN
for v1=1:length(varstr)
   for qi = 1:length(q);
      uX_proj_m{qi,v1} = [NaN*ones(1,find(calvec==calvec_c{v1}(1))-1) X_proj_m{qi,v1}' NaN*ones(1,length(calvec)-find(calvec==calvec_c{v1}(end)))];
   end
end

fprintf(fid_out,['date,' strjoin(strcat(cellstr(reshape(repmat(varstr,length(q),1),1,[])),{'_q'},arrayfun(@num2str,repmat(q,1,length(varstr)),'UniformOutput',0)),',') '\n']); 
for cc=1:length(calvec)
   fprintf(fid_out,'%7d',1000*calvec(cc));
   for v1=1:length(varstr)
      fprintf(fid_out,[',' strjoin(repmat({'%15.12f'},[1 length(q)]),',')],cellfun(@(x) x(cc),{uX_proj_m{:,v1}}));
   end
   fprintf(fid_out,'\n');
end

outfile_name = [outdir 'annual.csv'];
fid_out = fopen(outfile_name,'w');

% make the projections of uniform length by padding with NaN
for v1=1:length(varstr_a)
   for qi = 1:length(q);
      uX_proj_m_a{qi,v1} = [NaN*ones(1,find(calvec_a==calvec_a_c{v1}(1))-1) X_proj_m_a{qi,v1}' NaN*ones(1,length(calvec_a)-find(calvec_a==calvec_a_c{v1}(end)))];
   end
end

fprintf(fid_out,['date,' strjoin(strcat(cellstr(reshape(repmat(varstr_a,length(q),1),1,[])),{'_q'},arrayfun(@num2str,repmat(q,1,length(varstr_a)),'UniformOutput',0)),',') '\n']); 
for cc=1:length(calvec_a)
   fprintf(fid_out,'%4d',calvec_a(cc));
   for v1=1:length(varstr_a)
      fprintf(fid_out,[',' strjoin(repmat({'%15.12f'},[1 length(q)]),',')],cellfun(@(x) x(cc),{uX_proj_m_a{:,v1}}));
   end
   fprintf(fid_out,'\n');
end


return  
  
