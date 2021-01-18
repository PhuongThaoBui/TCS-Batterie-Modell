%% A04 Aufgabe Grundlagen der Parametervariation

% Individuellen Ordnerpfad angeben
% cd 'C:\DATEN\Lehre\S3_Solarspeichersysteme\Aufgaben' 

%% 1 Import der Eingangsdaten

%load('A04_Daten.mat')

%% 2 Definition der Systemparameter

% Nominale PV-Generatorleistung in kWp
s.P_PV=5;
% Nutzbare Speicherkapazität in kWh
s.E_BAT=E_BAT; 
% Nominale AC-Leistungsaufnahme des Batteriewechselrichters in kW
s.P_AC2BAT_in=5.0; 
% Nominale AC-Leistungsabgabe des Batteriewechselrichters in kW
s.P_BAT2AC_out=4.9; 
% Mittlerer Umwandlungswirkungsgrad des Batteriewechselrichters im Ladebetrieb 
s.eta_ac2bat=0.919;
% Mittlerer Umwandlungswirkungsgrad des Batteriewechselrichters im Entladebetrieb 
s.eta_bat2ac=0.918;
% Mittlerer Umwandlungswirkungsgrad des Batteriespeichers 
s.eta_bat=0.96;
% Simulationszeitschrittweite in h
s.dt=1/4;

%% 3 Durchfuehrung der Speichersimulation ueber ein Jahr

% Ausgangsleistung des PV-Systems in W aus der spezifischen
% AC-Leistungsabgabe des PV-Systems und der nominalen PV-Generatorleistung
%Ppvs=ppvs*1000*s.P_PV;

% Differenzleistung in W
%diff=Ppvs-Pel;

% Aufruf des Simulationsmodells


% Netzleistung bestimmen
%Pg=diff-Pbs;

% %% 4 Auswertung
% 
% %% 4.1 Energiesummen
% 
% % Elektrischer Energieverbrauch in kWh
% El=sum(Pl)/60/1000;
% % AC-Energieabgabe des PV-Systems in kWh
% Epvs=sum(Ppvs)/60/1000;
% % PV-Direktversorgung in kWh
% Epvs2l=sum(min(Ppvs,Pl))/60/1000;
% % AC-Energieaufnahme des Batteriesystems in kWh
% Eac2bs=sum(max(0,Pbs))/60/1000;
% % DC-Energieaufnahme des Batteriespeichers in kWh
% Ebatin=sum(max(Pbat,0))/60/1000;
% % DC-Energieabgabe des Batteriespeichers in kWh
% Ebatout=sum(abs(min(Pbat,0)))/60/1000;
% % AC-Energieabgabe des Batteriesystems in kWh
% Ebs2ac=sum(abs((min(0,Pbs))))/60/1000;
% % Netzeinspeisung in kWh
% Eac2g=sum(max(0,Pg))/60/1000;
% % Netzbezug in kWh
% Eg2ac=sum(abs((min(0,Pg))))/60/1000;
% 
% %% 4.2 Balkendiagramm der Energiesummen
% 
% % Neues Fenster für die Grafik erstellen
% figure
% % Bildnahme (wird spaeter fuer den Export verwendet)
% im='A04_Bild_1';
% % Matrix mit den einzelnen Variablen
% mat=[...
%     Epvs2l,...
%     Eac2bs,...
%     Eac2g,...
%     0,...
%     0;...
%     Epvs2l,...
%     0,...
%     0,...
%     Ebs2ac,...
%     Eg2ac,...
%     ];
% % Vektor fuer die horizontale Achse
% x=[1,2];
% % Darstellung als Balkendiagramm
% b=bar(x,mat,'stacked','BarWidth',0.5);
% % Anpassung der Balkenfarben
% b(1).FaceColor = [1.0000    0.8000         0]; % gelb
% b(2).FaceColor = [0.4627    0.7255         0]; % gruen
% b(3).FaceColor = [0.6000    0.6000    0.6000]; % hellgrau
% b(4).FaceColor = [0.0510    0.5216         0]; % dunkelgruen
% b(5).FaceColor = [0.2471    0.2471    0.2471]; % dunkelgrau
% % Achsen der Darstellung als separate Variable auffuehren
% ax=gca;
% % Grenzen der horizontalen Achse anpassen
% ax.XLim=[0.5 2.5]; 
% % Werte der horizontalen Achse anpassen
% ax.XTick=(1:2);
% % Neue Bezeichnung der Kategorien einfügen
% ax.XTickLabel=(['Erzeugung';'Verbrauch']); 
% % Beschriftung der vertikalen Achse
% ax.YLabel.String='Energie in kWh';
% % Legende ergaenzen
% l=legend([b(5) b(3) b(4) b(2) b(1)],...
%     {...
%     'Netzversorgung',...
%     'PV-Einspeisung',...
%     'Batterieversorgung',...
%     'PV-Batterieladung',...
%     'PV-Direktversorgung',...
%     },...
%     'Location','eastoutside');
% % Hintergrundfarbe auf weiss setzen
% set(gcf,'color','w');
% % Grafik als PNG-Bild exportieren
% print(im,'-dpng')
% % Neue Bilder angedockt öffnen
% set(0,'DefaultFigureWindowStyle','docked') 
% % set(0,'DefaultFigureWindowStyle','normal') % Neue Bilder nicht angedockt öffnen
% 
% %% 4.3 Visualisierung der Leistungsfluesse
% 
% % Neues Fenster für die Grafik erstellen
% figure
% % Bildnahme (wird spaeter fuer den Export verwendet)
% im='A04_Bild_2';
% % Matrix mit den einzelnen Variablen
% mat=[...
%     Pd,...
%     Pbs,...
%     ]/1000;
% % Vektor fuer die horizontale Achse
% x=[1:length(mat)]/60;
% % Zuweisung der Matrix zur vertikalen Achse
% y=mat;
% % Darstellung als Liniengrafik
% st=stairs(x,y,'LineWidth',1);
% % Anpassung der Linienfarbe
% st(1).Color = [0.5020    0.5020    0.5020]; % grau
% st(2).Color = [0.0510    0.5216         0]; % dunkelgruen
% % Achsen der Darstellung als separate Variable auffuehren
% ax=gca;
% % Grenzen der horizontalen Achse anpassen
% ax.XLim=[0 8760]; 
% % Werte der horizontalen Achse anpassen
% % ax.XTick=(ax.XLim(1):3:ax.XLim(2));
% % Beschriftung der horizontalen Achse
% ax.XLabel.String='Stunde des Jahres';
% % Grenzen der vertikalen Achse anpassen
% ax.YLim=[-6 6];
% % Beschriftung der vertikalen Achse
% ax.YLabel.String='Leistung in kW';
% % Gitternetz hinzufügen
% grid on
% % Legende ergaenzen
% l=legend(...
%     {...
%     'Differenzleistung',...
%     'Batteriesystemleistung',...
%     },...
%     'Location','northeast');
% % Hintergrundfarbe auf weiss setzen
% set(gcf,'color','w');
% 
% %% 5 Durchfuehrung der Parametervariation und Speichersimulation
% 
% % Ausgangsleistung des PV-Systems in W aus der spezifischen
% % AC-Leistungsabgabe des PV-Systems und der nominalen PV-Generatorleistung
% Ppvs=ppvs*1000*s.P_PV;
% 
% % Differenzleistung in W
% Pd=Ppvs-Pl;
% 
% % Index der zur Ergebnisspeicherung erforderlich ist.
% i=0;
% 
% % Ergebnismatrix vorinitialisieren
% ERG=zeros(10,11);
% 
% for E_BAT=0:1:10
% % Laufvariable i um eins erhoehen    
% i=i+1;
% 
% % E_BAT im struct neu definieren    
% s.E_BAT=E_BAT;
% 
% % Aufruf des Simulationsmodells
% [Pbs,Pbat,soc]=bssim(s,Pd);
% 
% % Netzleistung bestimmen
% Pg=Ppvs-Pl-Pbs;
% 
% % Energiesummen
% 
% % Elektrischer Energieverbrauch in kWh
% El=sum(Pl)/60/1000;
% % AC-Energieabgabe des PV-Systems in kWh
% Epvs=sum(Ppvs)/60/1000;
% % PV-Direktversorgung in kWh
% Epvs2l=sum(min(Ppvs,Pl))/60/1000;
% % AC-Energieaufnahme des Batteriesystems in kWh
% Eac2bs=sum(max(0,Pbs))/60/1000;
% % DC-Energieaufnahme des Batteriespeichers in kWh
% Ebatin=sum(max(0,Pbat))/60/1000;
% % DC-Energieabgabe des Batteriespeichers in kWh
% Ebatout=sum(abs(min(0,Pbat)))/60/1000;
% % AC-Energieabgabe des Batteriesystems in kWh
% Ebs2ac=sum(abs((min(0,Pbs))))/60/1000;
% % Netzeinspeisung in kWh
% Eac2g=sum(max(0,Pg))/60/1000;
% % Netzbezug in kWh
% Eg2ac=sum(abs((min(0,Pg))))/60/1000;
% 
% % Ergebnisse in Matrix speichern
% ERG(:,i)=[E_BAT;El;Epvs; Epvs2l; Eac2bs; Ebatin; Ebatout; Ebs2ac; Eac2g; Eg2ac];
% 
% end
% 
% %% 6 Auswertung
% 
% %% 6.1 Balkendiagramm der Energiesummen
% 
% % Neues Fenster für die Grafik erstellen
% figure
% % Bildname (wird spaeter fuer den Export verwendet)
% im='A04_Bild_3';
% % Matrix mit den einzelnen Variablen
% mat=[...
%     ERG(4,:);... % Epvs2l
%     ERG(8,:);... % Ebs2ac
%     ERG(10,:);... % Eg2ac
%     ];
% % Vektor fuer die horizontale Achse
% x=ERG(1,:);
% % Darstellung als Balkendiagramm
% b=bar(x,mat,'stacked','BarWidth',0.5);
% % Anpassung der Balkenfarben
% b(1).FaceColor = [1.0000    0.8000         0]; % gelb
% b(2).FaceColor = [0.0510    0.5216         0]; % dunkelgruen
% b(3).FaceColor = [0.2471    0.2471    0.2471]; % dunkelgrau
% % Achsen der Darstellung als separate Variable auffuehren
% ax=gca;
% % Grenzen der horizontalen Achse anpassen
% ax.XLim=[-0.5 10.5]; 
% % Beschriftung der horizontalen Achse
% ax.XLabel.String='Batteriekapazität in kWh';
% % Grenzen der vertikalen Achse anpassen
% ax.YLim=[0 7000];
% % Beschriftung der vertikalen Achse
% ax.YLabel.String='Energie in kWh/a';
% % Legende ergaenzen
% l=legend([b(3) b(2) b(1) ],...
%     {...
%     'Netzversorgung',...
%     'Batterieversorgung',...
%     'PV-Direktversorgung',...
%     },...
%     'Location','northeast');
% % Legendenrahmen entfernen
% legend('boxoff')
% % Hintergrundfarbe auf weiss setzen
% set(gcf,'color','w');
% % Schriftgroesse vereinheitlichen
% fig=gcf; fonsize=12; set(findall(fig,'-property','FontSize'),'FontSize',fonsize); set(findall(fig,'-property','FontName'),'FontName','Verdana');
% % Grafik als PNG-Datei exportieren
% print(im,'-dpng')
% % Grafik als EMF-Datei exportieren
% print(im,'-dmeta')
% 

