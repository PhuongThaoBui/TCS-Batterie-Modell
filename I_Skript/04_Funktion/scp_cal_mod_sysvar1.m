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


Pp_ein(1,1) = 0;
T_soll = 60;
Ppv2h= zeros(length(Ppv),1);
T_aus(1,1) = 60;
P_bat_max(1,1) = 2500;
diff = Ppv - Pel;
soc(2,1)=1;                     % Ladezustand
Ebat(1,1)=1;                    % Energieinhalt des Batteriespeichers in kWh
Pbat(1,1)=2500;                 % Batteriespeicherleistung in W
eta_ac2hl1 = 0.95;              % Beladung des TCS
eta_ac2hl2 = 0.95;              % Wirkungsgrad bei der Erwärmung von WWS aus PV
eta_wt2wws1= 0.95;              % Wirkungsgrad von Wärmetauscher von TCS zu WWS
eta_wt2wws2= 0.95;              % Wirkungsgrad von Wärmetauscher von WWS zu Haus


% Definiton der Lade und Entladezeiträume des TCS in Spaltenvektor (L) Beladung
% (1) & Entladung(0)
% Beladung von 31.März bis 1.Oktober       
% Entladung von 1.Oktober bis 31.März
load('L5Jahre.mat'); 

for i = 2:length(diff)
    
    if L5Jahre(i,1)==1 && diff(i,1) >=0  % TCS Beladung von März bis Oktober (implementiert)              
                                                                 
        % TCS-Ladung im aktuellen Zeitschritt ermitteln
        % Fall 1: 
        % PV-Überschussstrom ist vorhanden 
        % Batterie wird als 1.Priorität voll geladen bzw. max.Ladeleistung erreicht 
        % Wenn es noch restliche PV-Überschussstrom gibt, dann TCS beladen
        
        if diff(i,1)- min(P_AC2BAT_in*1000*eta_ac2bat,E_BAT*1000*(1-soc(i-1,1))/dt/eta_bat) > 0
            TCS_out(i,1)=0;
            TCS_in(i,1)= min(min(min((diff(i,1)- min(P_AC2BAT_in*1000*eta_ac2bat,E_BAT*1000*(1-soc(i-1,1))/dt/eta_bat)),Q_TCS_in),E_TCS*1000*(1-soc_TCS(i-1,1))/dt))*eta_ac2hl1;           
            Pbat_in(i,1) = min(min(P_AC2BAT_in*1000)*eta_ac2bat,E_BAT*1000*(1-soc(i-1))/dt/eta_bat);
            Pbat_out(i,1) = 0;
            
             
            % Wenn es nach dem Beladen des TCSs restliche PV-Überschussstrom gibt, 
            % dann PV erwärmt mithilfe des Heizelement die Warmwasserspeicher 
            % Wenn keine Bedarf vorhanden ist, dann ins Nezt einspeisen 
            
            if (diff(i,1)- min(P_AC2BAT_in*1000*eta_ac2bat,E_BAT*1000*(1-soc(i-1,1))/dt/eta_bat)) <= min(Q_TCS_in,E_TCS*1000*(1-soc_TCS(i-1,1))/dt)
                Ppv2h(i,1) = 0;
                P_TCS_aus(i,1) = min(Ppv2h(i,1)*eta_wt2wws2,P_rh(i,1));
                b(i,1) = -1;
            elseif (diff(i,1)- min(P_AC2BAT_in*1000*eta_ac2bat,(E_BAT*1000*(1-soc(i-1,1))/dt/eta_bat))) > min(Q_TCS_in,E_TCS*1000*(1-soc_TCS(i-1,1))/dt) 
                
                Ppv2h(i,1) =  min(min((diff(i,1)- min(P_AC2BAT_in*1000*eta_ac2bat,E_BAT*1000*(1-soc(i-1,1))/dt/eta_bat)))-min(Q_TCS_in,E_TCS*1000*(1-soc_TCS(i-1,1))/dt),P_rh(i,1))*eta_ac2hl2;
                P_TCS_aus(i,1) = P_rh(i,1)*eta_wt2wws2;
                b(i,1) = -1.5;
            end
            % PV-Überschussstrom ist nach dem Batteriebeladung nicht vorhanden 
            % TCS wird nicht beladen 
        else 
            TCS_in(i,1) =0;
            TCS_out(i,1)=0;
            Pbat_in(i,1) = min(min(diff(i,1),P_AC2BAT_in*1000)*eta_ac2bat,E_BAT*1000*(1-soc(i-1))/dt/eta_bat);
            Pbat_out(i,1) = 0;
            P_TCS_aus(i,1) = 0;
            b(i,1) = 1.5;
        end
        
    % Fall 2
    % TCS Entladung im Winter von Oktober bis März
    % Kein Überschussstrom von PV
    % Batterie wird entladen um Strombedarf zu decken 
    
    elseif L5Jahre(i,1)==0 && diff(i,1) <0
        
        % TCS Entladung im aktuellen Zeitschritt ermitteln
        TCS_in(i,1) =0;
        TCS_out(i,1)= -min(min(P_rh(i,1),Q_TCS_out),ETCS(i-1,1)*1000/dt)*eta_wt2wws1;
        Pbat_in(i,1) = 0;
        Pbat_out(i,1) = min(min(abs(diff(i,1)),P_BAT2AC_out*1000)/eta_bat2ac,P_bat_max(i-1,1));
        P_TCS_aus(i,1) = min(min(min((abs(TCS_in(i,1) + TCS_out(i,1))*eta_wt2wws2),P_rh(i,1)),Q_TCS_in),E_TCS*1000*(1-soc_TCS(i-1,1)));
        b(i,1) = 2;
        
    % Fall 3
    % TCS Beladung von März bis Oktober aber es gibt kein Überschussstrom --> Entladen 
    % Kein Überschussstrom von PV
    % Batterie wird entladen um Strombedarf zu decken 

    elseif L5Jahre(i,1)==1 && diff(i,1) <0
        TCS_in(i,1) =0;
        TCS_out(i,1)= -min(min(P_rh(i,1),Q_TCS_out),ETCS(i-1,1)*1000/dt)*eta_wt2wws1;
        Pbat_in(i,1) = 0;
        Pbat_out(i,1) = min(min(abs(diff(i,1)),P_BAT2AC_out*1000)/eta_bat2ac,P_bat_max(i-1,1));
        P_TCS_aus(i,1) = min(min(min(abs(TCS_in(i,1) + TCS_out(i,1))*eta_wt2wws2,P_rh(i,1)),Q_TCS_in),E_TCS*1000*(1-soc_TCS(i-1,1)));
        b(i,1) = 3;
        
    % Fall 4
    % TCS Entladung im Winter von Oktober bis März obwohl Überschuss da ist. 
    % Überschussstrom von PV vorhanden
    % Batterie wird beladen 
    
    elseif L5Jahre(i,1)==0 && diff(i,1) >=0
        TCS_in(i,1) =0;
        TCS_out(i,1)= -min(min(P_rh(i,1),Q_TCS_out),ETCS(i-1,1)*1000/dt)*eta_wt2wws1;
        Pbat_in(i,1) = min(min(diff(i,1),P_AC2BAT_in*1000)*eta_ac2bat,E_BAT*1000*(1-soc(i-1))/dt/eta_bat);
        Pbat_out(i,1) = 0;
        
        % Nachdem Batterie voll beladen wird, ist noch PV-Überschuss übrig 
        % Warmwasserspeicher erwärmen mit PV über den Heizelement
        
        if diff(i,1)*eta_ac2bat >= min((P_AC2BAT_in*1000)*eta_ac2bat,E_BAT*1000*(1-soc(i-1))/dt/eta_bat)
            Ppv2h(i,1) = min(diff(i,1) - min((P_AC2BAT_in*1000)*eta_ac2bat,E_BAT*1000*(1-soc(i-1))/dt/eta_bat),P_rh(i,1));
            P_TCS_aus(i,1) = min(min(min(abs(TCS_in(i,1) + TCS_out(i,1)+Ppv2h(i,1))*eta_wt2wws2,P_rh(i,1)),Q_TCS_out),E_TCS*1000*(1-soc_TCS(i-1,1)));
        else 
            Ppv2h(i,1) = 0;
            P_TCS_aus(i,1) = min(min(min(abs(TCS_in(i,1) + TCS_out(i,1)+Ppv2h(i,1))*eta_wt2wws2,P_rh(i,1)),Q_TCS_out),E_TCS*1000*(1-soc_TCS(i-1,1)));
        end
        b(i,1) = 4;

    end
    
        % Batterie 

        Pbat(i,1)=Pbat_in(i,1)-Pbat_out(i,1);

        % Batteriesystemleistung bestimmen
        Pbs(i,1)=Pbat_in(i,1)/eta_ac2bat-Pbat_out(i,1)*eta_bat2ac;

        % Anpassung des Energieinhalts des Batteriespeichers
        Ebat(i,1)= max(Ebat(i-1,1)+(Pbat_in(i,1)*eta_bat-Pbat_out(i,1))/1000*dt,0);
        
        % TCS
        Q_TCS(i,1)=TCS_in(i,1)+TCS_out(i,1);

        % Anpassung des Energieinhalts des TCS-speichers
        ETCS(i,1)=ETCS(i-1,1)+(Q_TCS(i,1)/4000);

        % Ladezustand berechnen
        soc_TCS(i,1)=ETCS(i,1)/E_TCS;
        % Wenn Fall 1.5a dann SOC von Batterie auf 1 gesetzt
        if b==-1
            soc(i,1) = 1;
        else
            % Ladezustand berechnen
            soc(i,1)=Ebat(i,1)/E_BAT;
        end
        % Wenn Fall 1.5b dann SOC von TCS auf 1 gesetzt
        if b==-1.5
            soc_TCS(i,1) = 1;
        else
            % Ladezustand berechnen
            soc_TCS(i,1)=ETCS(i,1)/E_TCS;
        end

        
        P_bat_max(i,1)= E_BAT*1000*soc(i,1)/dt;
    % Batteriesystemleistung bestimmen
    %Pbs(t)=Pbatin(t)/eta_ac2bat+Pbatout(t)*eta_bat2ac;
    

        


    
    % Temperatursenkung im Speicher 
   
    %T_aus(i+1,1)= T_aus(i,1) - ((P_rh(i+1,1)-P_rh(i,1))/(cp*10^-3))/ms/3600;
    T_aus(i+1,1) = 60;  
end
