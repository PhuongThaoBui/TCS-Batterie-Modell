% Umrechnungsfaktor von J in kWh 
f = 1/(1000*3600);

% Umrechnungsfaktor von 15min in Sekunde 
f_s = 15*60;

% Die absolute Anzahl der Jahre 
Jahr = 2;
%% Last 
% Elektrischer Energieverbrauch in kWh
El=sum(Pel)*f_s*f/Jahr;
% gesamte Wärmebedarf in kWh pro Jahr 
E_rh = sum(P_rh)*f_s*f/Jahr;

%% Strom
% AC-Energieabgabe des PV-Systems in kWh
Epvs=sum(Ppv)*f_s*f/Jahr;
% PV-Direktversorgung in kWh
Epvs2l=sum(min(Ppv,Pel))*f_s*f/Jahr;
% Batterie-Beladung mit PV in kWh 
% Epv2bat=sum(Pbat_in)*f_s*f/Jahr;
% --> Anteil der PV-Direktstromversorgung in pozent 
    eta_pv2el=Epvs2l/El*1;
% AC-Energieabgabe des Batteriesystems in kWh
Ebs2ac=sum(Pbat_out)*f_s*f/Jahr;
% Ebs2ac=sum(abs((max(Pbat_out-max(0,diff)))))*f_s*f/Jahr;
% --> Anteil der Batterie-Direktstromversorgung in pozent 
    eta_bs2el=Ebs2ac/El*1;
% Stromversorgung ausm Netz in kWh 
Eg2ac= max(0,El-Epvs2l-Ebs2ac);
% --> Anteil der Stromversorgung ausm Netz in pozent 
    eta_g2el=max(Eg2ac/El,0)*1;
% Strom in Netz einspeisen in kWh 
Epv2g= sum(max(0,diff)-(max(0,Pbat_in))-TCS_in-Ppv2h)*f_s*f/Jahr;
% --> Anteil der PV-Einspeisung
    eta_pv2g=Epv2g/Epvs;
% Autarkiegrad Stromversorgung 
eta_ges_el = (El-Eg2ac)/El*1;

%% Wärme
% gesamte Wärmebedarf in kWh pro Jahr 
E_rh = sum(P_rh)*f_s*f/Jahr;

% TCS-Beladung mit PV in kWh 
Epv2tcs=sum(TCS_in)*f_s*f/Jahr;

% Batterie-Beladung mit PV in kWh 
Epv2bat=sum(Pbat_in)*f_s*f/Jahr;

% TCS-Versorgung für Wärmebedarf in kWh 
Etcs2q=sum(P_TCS_aus)*f_s*f/Jahr;
% --> Anteil in pozent 
    eta_TCS2Q=Etcs2q/E_rh*1; 


% Nachheizung mit Batterie in kWh   
% Ebat2q=Epv2bat-Ebs2ac;
% % --> Anteil in pozent 
%     eta_bat2q=Ebat2q/E_rh*1;

% Nachheizung mit direkt PV in kWh     
Epv2q=sum(Ppv2h)*f_s*f/Jahr;  
% --> Anteil in pozent 
    eta_PV2Q=min(Epv2q/E_rh,1)*1;    
% Nachheizung ausm Netz in kWh 
Eg2q = E_rh - Etcs2q - Epv2q;
% --> Anteil in pozent 
    eta_g2q=Eg2q/E_rh*1; 

    eta_ges_q= 1-max(eta_g2q,0);


%% Strom und Wärme 
% gesamte Netzbezug für Strom und Wärme in kWh
Egrid=Eg2q +Eg2ac;
% --> Anteil in pozent
eta_ges  = 1- Egrid/(E_rh+El)*1;

 
    
    
    
    
    
    

    

