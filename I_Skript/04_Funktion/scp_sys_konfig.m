
% PV-Leistung: PPV wird von 4 bis 30 kW variiert mit Schrittweite von 2kW
if BUTTON.PVvar   == 1
    xppv = 4:2:30; 
    P_PV_n=numel(xppv); % Anzahl (engl. number) der Werte
else 
    xppv = 20;
end 

% Die Batterie-Kapazität wird von 0 bis 20 kW vriiert mit Schrittweite von 2kW
if BUTTON.EBATvar  == 1
    xebat = 2:2:20; 
    
else 
    xebat = 10;
end

% Die Kapazität von TCS wird von 400 bis 2800kW variiert 
if BUTTON.TCSvar   == 1
    xTCS = 3200:400:6000;
    
else 
    xTCS = 2000;
end 

% Die Anzahl der Person pro Haushalt 
if BUTTON.n == 1
    xn = 1:1:4;
    
else 
    xn = 4;
end
    
P_PV_n=numel(xppv); % Anzahl (engl. number) der Werte
E_BAT_n=numel(xebat); % Anzahl (engl. number) der Werte
TCS_n=numel(xTCS); % Anzahl (engl. number) der Werte
n_n=numel(xn); % Anzahl (engl. number) der Werte
