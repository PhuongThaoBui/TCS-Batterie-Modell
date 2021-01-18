% function [diff]=TCS(stat_TCS, TCS_out)


%% Simulationsmodell fuer Batteriesysteme


%% 2 Definition der Systemparameter TCS

% Nominale PV-Generatorleistung in kWp
P_PV=1000;
% Nutzbare Speicherkapazität in kWh
E_TCS=TCS; 
% Maximale Ladeleistung des TCS begrenzt durch Heizleistung des
% Heizregisters in W max 25000W
Q_TCS_in=10000; 
% Maximale Entladeleistung des TCS begrenzt durch Heizleistung des
% Heizregisters in W max 25000W
Q_TCS_out=10000;
% Mittlerer Wirkungsgrad des TCS 
eta_TCS=0.7;
% Simulationszeitschrittweite in h
dt=1/4;

%% Simulation des TCS

PV_prod = ppvs5*P_PV*PPV;
Pl = Pel;
Ql = P_rh;


Pd = PV_prod - Pl;


%% 2 Vorinitialisierung der Variablen

soc=zeros(size(Pd)); % Ladezustand
ETCS=zeros(size(Pd)); % Energieinhalt des Batteriespeichers in kWh
TCS_in=zeros(size(Pd)); % Batterieladeleistung in W
TCS_out=zeros(size(Pd)); % Batterieentladeleistung in W
Q_TCS=zeros(size(Pd)); % Batteriespeicherleistung in W
Pbs=zeros(size(Pd)); % Batteriesystemleistung in W

% Definiton der Lade und Entladezeiträume des TCS in Spaltenvektor (L) Beladung
% (1) & Entladung(0)
% Beladung von 31.März bis 1.Oktober       
% Entladung von 1.Oktober bis 31.März
load('..\02_Simdata\L5Jahre.mat');
%% 3 Zeitschrittsimulation des Batteriesystems

% Erster und letzter Zeitschritt der Zeitschrittsimulation
tstart=2;
tend=length(Pl);

% Durchfuehrung der Batteriesystemsimulation, wenn die Batteriekapazitaet
% groesser null ist.
if E_TCS>0
    
% Beginn der Zeitschrittsimulation
for t=tstart:tend
    
    if L5Jahre(t)==1 %               
                                        % TCS Beladung von März bis Oktober (implementiert)                              %  
                                        % Batterie voll geladen bzw. max.Ladeleistung erreicht (nicht implementiert)
                                        % elektrischer Bedarf ist gedeckt (nicht implementiert)
                                        % WWS ist auf Solltemperatur (nicht implementiert)

        % TCS-Ladung im aktuellen Zeitschritt ermitteln
        TCS_in(t)=max(min(min(Pd(t),Q_TCS_in),E_TCS*1000*(1-soc(t-1))/dt),0);

    elseif L5Jahre(t)==0 % TCS Entladung im Winter von Oktober bis März

        % TCS Entladung im aktuellen Zeitschritt ermitteln
        TCS_out(t)= -min(min(Ql(t),Q_TCS_out),ETCS(t-1)*1000/dt);

    end

    % Ladeleistung bestimmen
    Q_TCS(t)=TCS_in(t)+TCS_out(t);

    % Batteriesystemleistung bestimmen
    %Pbs(t)=Pbatin(t)/eta_ac2bat+Pbatout(t)*eta_bat2ac;

    % Anpassung des Energieinhalts des Batteriespeichers
    ETCS(t)=ETCS(t-1)+(Q_TCS(t)/4000);

    % Ladezustand berechnen
    soc(t)=ETCS(t)/E_TCS;

    if TCS_out(t) < 0 
        stat_TCS(t,1) = 1;
    else 
        stat_TCS(t,1) = 0 ;
    end 

end

end




