% Phuong Thao Bui: Datum - 13.12.2020
% Skript: Das Modell vom Warmwasserspeicher 


%% Formel
% Übertragungsleistung 
Pw = ms*cp*(T_ein - T_aus);      % Wärmeleistung in W

% Wärmebedarf 
% P_rh = Verbrauch5Jahre.P1.Q_ges  ;            % Wärmebedarf für die Raumheizung [Array] 
% Pel = Verbrauch5Jahre.P1.P_el;                % Elektrischer Last in W 
P_TCS = 0;                                    % Leistung vom TCS 
Ppv = ppvs5(1:70080,1)*1000*PPV;                         % PV-Leistung 
diff = Ppv - Pel;

% Sensorstelle 
T_sens = 60; 

 %% Simulationsmodell fuer Batteriesysteme

%% 1 Entnahme der erforderlichen Systemparameter

% Entnahme der Parameter aus dem Struct zur Verringerung der Rechenzeit

% Nutzbare Speicherkapazitaet in kWh
E_BAT=s.E_BAT; 
% Nominale AC-Leistungsaufnahme des Batteriewechselrichters in kW
P_AC2BAT_in=s.P_AC2BAT_in; 
% Nominale AC-Leistungsabgabe des Batteriewechselrichters in kW
P_BAT2AC_out=s.P_BAT2AC_out; 
% Mittlerer Umwandlungswirkungsgrad des Batteriewechselrichters im Ladebetrieb 
eta_ac2bat=s.eta_ac2bat;
% Mittlerer Umwandlungswirkungsgrad des Batteriewechselrichters im Entladebetrieb 
eta_bat2ac=s.eta_bat2ac;
% Mittlerer Umwandlungswirkungsgrad des Batteriespeichers 
eta_bat=s.eta_bat;
% Simulationszeitschrittweite in h
dt=s.dt;

%% 2 Definition der Systemparameter TCS

% Nominale PV-Generatorleistung in kWp
P_PV=1000;
% Nutzbare Speicherkapazität in kWh
E_TCS=TCS; 
% Maximale Ladeleistung des TCS begrenzt durch Heizleistung des
% Heizregisters in W max 25000W
Q_TCS_in=25000; 
% Maximale Entladeleistung des TCS begrenzt durch Heizleistung des
% Heizregisters in W max 25000W
Q_TCS_out=25000;
% Mittlerer Wirkungsgrad des TCS 
eta_TCS=0.7;
% Simulationszeitschrittweite in h
dt=1/4;

%% 2 Vorinitialisierung der Variablen

soc_TCS=zeros(size(diff)); % Ladezustand
ETCS=zeros(size(diff)); % Energieinhalt des Batteriespeichers in kWh
TCS_in=zeros(size(diff)); % Batterieladeleistung in W
TCS_out=zeros(size(diff)); % Batterieentladeleistung in W
Q_TCS=zeros(size(diff)); % Batteriespeicherleistung in W
Pbs=zeros(size(diff)); % Batteriesystemleistung in W
%% Algorithmen 
% Energie wird in den Speicher hinzugefügt wenn die Temperatur im Speicher kleiner als 60 Grad
% Initialisierung 

% run fcn_Pbat.m
%[Pbs,Pbat,soc]=bssim(s,diff);

Pp_ein(1,1) = 0;
%Pp_aus= zeros(length(Ppv),1);
%Pp_ges = zeros(length(Ppv),1);
%Pp_ein_soll = zeros(length(Ppv),1);
T_soll = 60;
%P_TCS_aus = zeros(length(Ppv),1);
%P_h = zeros(length(Ppv),1);
% Pl_h = zeros(length(Ppv),1);
% Pbat_in = zeros(length(Ppv),1);
% Pbat_out = zeros(length(Ppv),1);
% P_grid = zeros(length(Ppv),1);
% Pl_h_bat = zeros(length(Ppv),1);
% Pl_h_grid = zeros(length(Ppv),1);
% P_TCS_ges = zeros(length(Ppv),1);
% P_ein_soll= zeros(length(Ppv),1);
T_aus(1,1) = 60;
% a = zeros(length(Ppv),1);
% P_bat_max = zeros(length(Ppv),1);
P_bat_max(1,1) = 2500;
diff = Ppv - Pel;
soc(2,1)=1; % Ladezustand
Ebat(1,1)=1; % Energieinhalt des Batteriespeichers in kWh
% Pbat = zeros(length(Ppv),1);
Pbat(1,1)=2500; % Batteriespeicherleistung in W

% Definiton der Lade und Entladezeiträume des TCS in Spaltenvektor (L) Beladung
% (1) & Entladung(0)
% Beladung von 31.März bis 1.Oktober       
% Entladung von 1.Oktober bis 31.März
load('L5Jahre.mat'); 

 stat_TCS = 1-L5Jahre ;
%% Fall 1
%P_TCS_ges = abs(TCS_out);        % gesammte Leistung von TCS 
for i = 2:length(diff)
    
    if L5Jahre(i,1)==1 && diff(i,1) >=0 %               
                                        % TCS Beladung von März bis Oktober (implementiert)                              %  
                                        % Batterie voll geladen bzw. max.Ladeleistung erreicht (nicht implementiert)
                                        % elektrischer Bedarf ist gedeckt (nicht implementiert)
                                        % WWS ist auf Solltemperatur (nicht implementiert)

        % TCS-Ladung im aktuellen Zeitschritt ermitteln
        TCS_in(i,1)=max(min(min((diff(i,1)- min(P_AC2BAT_in*1000*eta_ac2bat,max(E_BAT*1000*(1-soc(i-1,1))/dt/eta_bat,0))),Q_TCS_in),max(E_TCS*1000*(1-soc_TCS(i-1,1))/dt,0)),0);
        b(i,1) = 1;

    elseif L5Jahre(i,1)==0 && diff(i,1) <0% TCS Entladung im Winter von Oktober bis März

        % TCS Entladung im aktuellen Zeitschritt ermitteln
        TCS_out(i,1)= -min(min(P_rh(i,1),Q_TCS_out),max(ETCS(i-1,1)*1000/dt,0));
        b(i,1) = 2;

    elseif L5Jahre(i,1)==1 && diff(i,1) <0
        TCS_in(i,1)=0;
        b(i,1) = 3;
    elseif L5Jahre(i,1)==0 && diff(i,1) >=0
        TCS_out(i,1)=0;
        b(i,1) = 4;

    end
    
    if TCS_out(i,1) < 0
        stat_TCS(i,1) = 1;
    else 
        stat_TCS(i,1) = 0;
    end

    P_TCS_ges(i,1) = abs(TCS_in(i,1) + TCS_out(i,1));        % gesammte Leistung von TCS 
    P_ein_soll(i,1) = diff(i,1)-TCS_in(i,1);
    if stat_TCS(i,1) == 1 && P_ein_soll(i,1) >= 0
        if P_TCS_ges(i,1) >= P_rh(i,1)
            P_TCS_aus(i,1) = P_rh(i,1);
            Pl_h(i,1) = 0;
            if b(i,1) == 1
                Pbat_in(i,1) = min(min(P_AC2BAT_in*1000)*eta_ac2bat,max(E_BAT*1000*(1-soc(i-1))/dt/eta_bat,0));
            else
                Pbat_in(i,1) = min(min(P_ein_soll(i,1),P_AC2BAT_in*1000)*eta_ac2bat,max(E_BAT*1000*(1-soc(i-1))/dt/eta_bat,0));
            end
            Pbat_out(i,1) = 0;
            P_grid(i,1) = 0;
            a(i,1) = 1;
        elseif P_TCS_ges(i,1) < P_rh(i,1)
            P_TCS_aus(i,1) = P_TCS_ges(i,1);
            Pl_h(i,1) = (P_rh(i,1)-P_TCS_ges(i,1))/eta_h;
            % Fall 2 
            if P_ein_soll(i,1) > Pl_h(i,1)
                Pbat_in(i,1) = min(min((P_ein_soll(i,1)-Pl_h(i,1)),P_AC2BAT_in*1000)*eta_ac2bat,max(E_BAT*1000*(1-soc(i-1,1))/dt/eta_bat,0));
                Pbat_out(i,1) = 0;
                P_grid(i,1) = 0;
                a(i,1) = 2;
            % Fall 3
            elseif P_ein_soll(i,1) < Pl_h(i,1) && P_bat_max(i,1) >= (Pl_h(i,1)-P_ein_soll(i,1))
                Pbat_in(i,1) = 0;
                Pbat_out(i,1)=min(min((Pl_h(i,1)- P_ein_soll(i,1)),P_BAT2AC_out*1000)/eta_bat2ac,E_BAT*1000*soc(i-1,1)/dt);
              
                P_grid(i,1) = 0;
                a(i,1) = 3;
            % Fall 4
            elseif P_ein_soll(i,1) < Pl_h(i,1) && P_bat_max(i-1,1) < (Pl_h(i,1)-P_ein_soll(i,1))
                Pbat_in(i,1) = 0;
                Pbat_out(i,1)= min(min((Pl_h(i,1)- P_ein_soll(i,1)),P_BAT2AC_out*1000)/eta_bat2ac,E_BAT*1000*soc(i-1,1)/dt);
             
                P_grid(i,1) = Pl_h(i,1) - P_ein_soll(i,1) - Pbat_out(i,1);
                a(i,1) = 4;
            end 
        end
    % Fall 5    
    elseif P_ein_soll(i,1) < 0 && stat_TCS(i,1) == 1
        if P_TCS_ges(i,1) >= P_rh(i,1) 
            P_TCS_aus(i,1) = P_rh(i,1);
            Pl_h(i,1) = 0;
            Pbat_in(i,1) = 0;
            Pbat_out(i,1) = min(min(-P_ein_soll(i,1),P_BAT2AC_out*1000)/eta_bat2ac,E_BAT*1000*soc(i-1)/dt);
            a(i,1) = 5;
            % Fall 6
            if -P_ein_soll(i,1) <= Pbat_out(i,1) 
                P_grid(i,1) = 0;
                a(i,1) = 5;
            % Fall 7    
            elseif -P_ein_soll(i,1) > Pbat_out(i,1)
                P_grid(i,1) = -P_ein_soll(i,1) - Pbat_out(i,1);
                a(i,1) = 7;
            end 
        % Fall 8
        elseif P_TCS_ges(i,1) < P_rh(i,1) 
            P_TCS_aus(i,1) = P_TCS_ges(i,1);
            Pl_h(i,1)= (P_rh(i,1)-P_TCS_ges(i,1))/eta_h;
            if Pl_h(i,1) - P_ein_soll(i,1) < P_bat_max(i-1,1)
                Pbat_in(i,1) = 0;
                Pbat_out(i,1) = min(min(P_bat_max(i-1,1) - Pl_h(i,1) +P_ein_soll(i,1),P_BAT2AC_out*1000)/eta_bat2ac,E_BAT*1000*soc(i-1)/dt);
                P_grid(i,1) = 0;
                a(i,1) = 8;
            % Fall 9
            elseif Pl_h(i,1) - P_ein_soll(i,1) >= P_bat_max(i-1,1)
                Pbat_in(i,1) = 0;
                Pbat_out(i,1) = min(min(P_BAT2AC_out*1000)/eta_bat2ac,E_BAT*1000*soc(i-1)/dt);
                P_grid(i,1) = (Pl_h(i,1) - P_ein_soll(i,1)) - Pbat_out(i,1);
                a(i,1) = 9;
            end
        end 
    % Fall 10
    elseif P_ein_soll(i,1) >= 0 && stat_TCS(i,1) == 0
        P_TCS_aus(i,1) = 0; 
        Pl_h(i,1) = P_rh(i,1) /eta_h;
        if Pl_h(i,1) <= P_ein_soll(i,1) 
            Pbat_in(i,1) = min(min(P_ein_soll(i,1)-Pl_h(i,1),P_AC2BAT_in*1000)*eta_ac2bat,E_BAT*1000*(1-soc(i-1))/dt/eta_bat);
            Pbat_out(i,1) = 0;
            P_grid(i,1) = 0;
            a(i,1) = 10;
        % Fall 11
        % !! alt: P_rh(i,1) > P_ein_soll(i,1) && P_bat_max(i-1,1) > (Pl_h(i,1) - P_ein_soll(i,1))
        elseif Pl_h(i,1) > P_ein_soll(i,1) && P_bat_max(i-1,1) >= (Pl_h(i,1) - P_ein_soll(i,1))
            Pbat_in(i,1) = 0;
            Pbat_out(i,1) = min(min(Pl_h(i,1) - P_ein_soll(i,1),P_BAT2AC_out*1000)/eta_bat2ac,E_BAT*1000*soc(i-1)/dt);
            P_grid(i,1) = 0;
            a(i,1) = 11;
        % Fall 12
        elseif Pl_h(i,1) > P_ein_soll(i,1) && P_bat_max(i-1,1) < (Pl_h(i,1)-P_ein_soll(i,1))
            Pbat_in(i,1) = 0;
            Pbat_out(i,1) = min(min((Pl_h(i,1) - P_ein_soll(i,1)),P_BAT2AC_out*1000)/eta_bat2ac,P_bat_max(i-1,1));
            P_grid(i,1) = Pl_h(i,1)- P_ein_soll(i,1) -Pbat_out(i,1);
            a(i,1) = 12;
        end
    % Fall 13 
    elseif P_ein_soll(i,1) < 0 && stat_TCS(i,1) == 0
        P_TCS_aus(i,1) = 0; 
        Pl_h(i,1) = P_rh(i,1) /eta_h; 
        if P_bat_max(i-1,1) > (-P_ein_soll(i,1) + Pl_h(i,1))
            Pbat_in(i,1) = 0;
            Pbat_out(i,1) = min(min(P_bat_max(i-1,1)+P_ein_soll(i,1) - Pl_h(i,1),P_BAT2AC_out*1000)/eta_bat2ac,E_BAT*1000*soc(i-1)/dt);
            P_grid(i,1) = 0; 
            a(i,1) = 13;
        % Fall 14 
        elseif P_bat_max(i-1,1) <= (-P_ein_soll(i,1) +Pl_h(i,1))
            Pbat_in(i,1) = 0; 
            Pbat_out(i,1) = min(min(P_BAT2AC_out*1000)/eta_bat2ac,P_bat_max(i-1,1));
            P_grid(i,1) = -P_ein_soll(i,1) + Pl_h(i,1) - Pbat_out(i,1);
            a(i,1) = 14;
        end
    end
    % Batterie 

        Pbat(i,1)=Pbat_in(i,1)-Pbat_out(i,1);

        % Batteriesystemleistung bestimmen
        Pbs(i,1)=Pbat_in(i,1)/eta_ac2bat-Pbat_out(i,1)*eta_bat2ac;

        % Anpassung des Energieinhalts des Batteriespeichers
        Ebat(i,1)=max(Ebat(i-1,1)+(Pbat_in(i,1)*eta_bat-Pbat_out(i,1))/1000*dt,0);
        
        if b==1
            soc(i,1) = 1;
        else
            % Ladezustand berechnen
            soc(i,1)=Ebat(i,1)/E_BAT;
        end
        
        P_bat_max(i,1)= E_BAT*1000*soc(i,1)/dt;
    % Batteriesystemleistung bestimmen
    %Pbs(t)=Pbatin(t)/eta_ac2bat+Pbatout(t)*eta_bat2ac;
    
    % TCS
        Q_TCS(i,1)=TCS_in(i,1)+TCS_out(i,1);

        % Anpassung des Energieinhalts des Batteriespeichers
        ETCS(i,1)=ETCS(i-1,1)+(Q_TCS(i,1)/4000);

        % Ladezustand berechnen
        soc_TCS(i,1)=ETCS(i,1)/E_TCS;

    
    % Temperatursenkung im Speicher 
   
    %T_aus(i+1,1)= T_aus(i,1) - ((P_rh(i+1,1)-P_rh(i,1))/(cp*10^-3))/ms/3600;
    T_aus(i+1,1) = 60;

end











