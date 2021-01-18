% Umrechnungsfaktor von J in kWh 
f = 1/(1000*3600);

% Umrechnungsfaktor von 15min in Sekunde 
f_s = 15*60;

% Die absolute Anzahl der Jahre 
Jahr = 5;
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
Ebs2ac=sum(abs((min(max(0,Pbat_out),abs(min(0,P_ein_soll))))))*f_s*f/Jahr;
% Ebs2ac=sum(abs((max(Pbat_out-max(0,diff)))))*f_s*f/Jahr;
% --> Anteil der Batterie-Direktstromversorgung in pozent 
    eta_bs2el=Ebs2ac/El*1;
% Stromversorgung ausm Netz in kWh 
Eg2ac= El-Epvs2l-Ebs2ac;
% --> Anteil der Stromversorgung ausm Netz in pozent 
    eta_g2el=Eg2ac/El*1;
% Strom in Netz einspeisen in kWh 
Epv2g= sum(max(0,P_ein_soll)-(max(0,Pbat_in)))*f_s*f/Jahr;
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

% gesamte Nachheizung Ebat2q + Epv2q + Eg2q in kWh 
E_ges2H=(E_rh-Etcs2q);

% Nachheizung mit Batterie in kWh   
Ebat2q=Epv2bat-Ebs2ac;
% --> Anteil in pozent 
    eta_bat2q=Ebat2q/E_rh*1;

% Nachheizung mit direkt PV in kWh     
Epv2q=max(0,Epvs-Epvs2l-Epv2tcs-Epv2bat-Epv2g);   
% --> Anteil in pozent 
    eta_PV2Q=Epv2q/E_rh*1;    
    
% Nachheizung ausm Netz in kWh      
Eg2q=max(0,E_ges2H-Epv2q-Ebat2q);  
% --> Anteil in pozent 
    eta_g2q=Eg2q/E_rh*1;    

% Autarkiegrad Stromversorgung 
eta_ges_q = (E_rh-Eg2q)/E_rh*1;

%% Strom und Wärme 
% gesamte Netzbezug für Strom und Wärme in kWh
Egrid=sum(P_grid)*f_s*f/Jahr;
% --> Anteil in pozent
eta_ges  = 1- Egrid/(E_rh+El)*1;

 
    
    
    
    
    
    

    

