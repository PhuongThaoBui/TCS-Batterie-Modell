%% Übertragungsmedium: Wasser 
roh = 1000;     % Dichte kg/l
cp = 4200;      % Wärmekapazität in J/(kgK)
ms = 15;        % Massenstrom in kg/h 
T_ein = 80;     % Vorlauftemperatur in Grad
T_aus = 60;     % Austrittstemperatur aus dem Speicher in Grad

%% Speichereigenschaften 
ns = 10;            % Anzahl der Schichten im Speicher
Vs = 1000;          % Volumen des Speichers
pos_TCS_ein = 6;    % relative Einspeisungsposition des TCSs 
pos_TCS_aus = 2;    % relative Abzapfspotion des TCSs

%% Heizelement 
eta_h = 0.95;       % Umwandlungswirkungsgrad vom Heizelement 
P_h_max =  3000;    % maximale Ladeleistung vom Heizelement in W

% Lage der Anschlüsse 
pos_h_ein = 4;      % Einspeisungsanschluss vom Heizelement 

%% TCS 
eta_TCS = 0.77;     % Wirkungsgrad vom TCS 
eta_WT_TCS = 0.95;  % WIrkungsgrad vom Wärmetauscher 
pos_TCS = 5;        % relative Position vom TCS 