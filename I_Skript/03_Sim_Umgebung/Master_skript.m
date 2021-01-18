%% Modul Numerische Simulation 
%% Hauptskript zur Berechnung und Analysieren der Funktion
%  Gruppe I
%  Erstellsdatum: 
%  Update: 11.12, Johannes Gramann, Rohdaten bearbeiten und Einlesen der Datei in Matlab
%  Update: 18.12, Johannes Gramann , Phuong Thao Bui, die Modelle implementieren 
%  Update: 21.12, Phuong Thao Bui, analysieren und berechnen  
%  Update: 04.01, Phuong Thao Bui: Schleife für Parametervariation hinzufügen
%  Update: 05.01, Johannes Gramann, die GUI für App-Designer erstellen
%  Update: 06.01, Phuong Thao Bui: Daten speichern, 
%  Update: 12.01, Johannes Gramann: Daten im App implementieren 
%  Update: 15.01, Johannes Gramann,Phuong Thao Bui: Ergebnisse plausibilisieren 
%  Update: 17.01, Phuong Thao Bui: Kommentar hinzufügen

%%  Benötigte Matlab-Datein

%   Master_skript.m                 --> Hauptdatei zum Initialisieren und Vornehmen von Einstellungen
%   scp_cal_mod_sysvar1.m           --> Initialisierung des Modells vom Warmwasserspeicher
%   scp_cal_TCS_mod.m               --> Initialisierung des Modells vom Thermochemische Speicher

clc
clear all
close all
commandwindow

addpath('../01_Verbrauch_Data')        %Ordner mit Rohdaten
addpath('../02_Simdata')               %Ornder von bearbeiteten Eingangsdaten
addpath('../04_Funktion')              %Ordner mit Matlab Skripten und Funktionen zum Matlabpfad hinzufügen
addpath('../06_Analysis')

%% Einstellungen

BUTTON.Datasave = 1;                % |1| speichern der Kalkulationsdaten
BUTTON.Plot     = 1;                % |1| die Ergebnisse plotten 
                                    % |0| die Ergebnisse nicht darstellen
%% Wichtige Systemeinstellung 
BUTTON.Sysvar = 1;                  % |1| Systemvariante 1, |2| Systemvariante 1 mit der zusätzlichen Energiefluss von Batterie zum Heizelement 
BUTTON.PVvar    = 0;                % |1| PV-Leistung variieren / |0| nicht variieren  
BUTTON.TCSvar   = 0;                % |1| TCS-Kapazität variieren / |0| nicht variieren  
BUTTON.EBATvar  = 0;                % |1| Batterie-Kapazität variieren / |0| nicht variieren   
BUTTON.n        = 0;                % |1| Anzahl der Personen im Haushalt variieren / |0| nicht variieren  
BUTTON.saveData_app = 1;            % |1| Save Data für die App-Designer

% Plot
BUTTON.plot_ERG = 0;                % |1| plot ERG   



%% Eingangsdaten einlesen 
load('Verbraucher5Jahre.mat')             % Die Lastprofil
load('ppvs5Jahre.mat')                    % PV-Leistung       



%% Initialisierungsdaten
% Beschreibung des Simulationssystems und die entsprechende Parameter einladen 
run scp_init_sim_compo.m            

run scp_sys_konfig
% Startwert der Laufvariable fuer die Zeilennummer in der Ergebnismatrix

znr=0;   
% Ergebnisse in Matrix speichern
% Gesamtanzahl der zu simulierenden Varianten durch Multiplikation der Anzahl der
% Werte pro Variable ermitteln
 n_var=P_PV_n*E_BAT_n*TCS_n*n_n;

% Anzahl der zu speichernden Ergebnisvariablen 
if BUTTON.Sysvar == 1
    n_erg=15;
elseif BUTTON.Sysvar == 2
    n_erg=16;
end

% Ergebnismatrix vorinitialisieren
ERG=zeros(n_var,n_erg);
for PPV = xppv
    for E_BAT = xebat
        for TCS = xTCS
            for n = xn
                % Zeilennummer bei jedem weiteren Simulationsdurchlauf um den Wert 1 erhoehen
                znr=znr+1;
                
                eval(['P_rh = Verbrauch5Jahre.P', num2str(n) ,'.Q_ges(1:70080,1)/4  ; ']);
                eval(['Pel = Verbrauch5Jahre.P', num2str(n) ,'.P_el(1:70080,1)  ; ']);
                
                % Die Konfiguration des TCS-Modells 
                % run scp_cal_TCS_mod.m 

                % Die TCS-Leistung plotten 


                % Berechnung der Batterie 
                run fcn_Pbat.m

                % Die Konfiguration des WW-Speichers
                if BUTTON.Sysvar == 1
                    run scp_cal_mod_sysvar1.m
                elseif BUTTON.Sysvar == 2
                    run scp_cal_WWS_mod_v5.m
                end 
                
                % Simulationsergebnisse für App-Designer speichern
                if BUTTON.saveData_app == 1 && BUTTON.Sysvar == 1

                    run scp_cal_energy_sysvar1.m
%                     run scp_save_sim_results.m
                    % Veränderbare Systemparameter sowie Ergebnisvariablen in
                    % der Ergebnismatrix speichern
                    ERG(znr,1:n_erg)=[znr,PPV,E_BAT,TCS,n,eta_ges_el,eta_pv2el,eta_bs2el,eta_g2el,...
                        eta_ges_q,eta_TCS2Q,eta_PV2Q,eta_g2q,eta_ges,eta_pv2g]; 
                    
                elseif BUTTON.saveData_app == 1 && BUTTON.Sysvar == 2
                    % Anzahl der zu speichernden Ergebnisvariablen 
                    n_erg=16;
                    run scp_cal_energie_sysvar2.m
                    ERG(znr,1:n_erg)=[znr,PPV,E_BAT,TCS,n,eta_ges_el,eta_pv2el,eta_bs2el,eta_g2el,...
                        eta_ges_q,eta_TCS2Q,eta_PV2Q,eta_bat2q,eta_g2q,eta_ges,eta_pv2g]; 

                end 
            end
        end
    end
end


%% Run Simulink 
disp('Initialisierung abgeschlossen...')
disp(['Simuliere den Fall : ',' TCS-Technologiekombination'] )
                    
     %open(modelName);               %Simulink Modell öffenen verbraucht Resourcen
     %sim(modelName);                 %Simulation starten

%% Analysieren 
% Plot 
if BUTTON.plot_ERG == 1
 run plot_elLeistung.m

 run Plot_bat_diagram_PVvar_TCS_analyst.m
end

%%
%% SPEICHERN
     if BUTTON.Datasave == 1
         
%%%%%%%%%%%%%%%%%%%%%%%  Script zu Bestimmung des Speichernamens  %%%%%%%%%%%%%%
         FileName = 'ERG_sysvar1';    
    
         save_name = strcat('./_Results/',FileName);
    
         save(save_name , 'ERG');
         display(['Data saved at: ', save_name]);
    
    end





                                    
                             