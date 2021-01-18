addpath('../03_Sim_Umgebung/ERG')
ax=gca;
time = 34560:1:34656;
x = 17280:15:18720;
Pg = max(0,abs(min(diff,0)) - Pbat_out) ;
mat=[...
    diff(time,1),...
    -Pbat_out(time,1),...
    Ppv(time,1),...
    -Pg(time,1),...
    ];
y1=soc(time,1)*100;
% Zuweiseisung der Matrix zur vertikalen Achse
y=mat;
yyaxis left
% Darstellung als Liniengrafik
s=plot(x,y,'LineWidth',1);
% Beschriftung der vertikalen Achse
ax.YLabel.String='Leistung in kW';
s(1).MarkerFaceColor = [0.5020    0.5020    0.5020]; % grau
s(2).MarkerFaceColor = [0.3804    0.9020    0.0078]; % hellgruen
s(3).MarkerFaceColor = [0.0510    0.5216         0]; % dunkelgruen
s(4).MarkerFaceColor = [0         0              0]; % schwarz

yyaxis right 
s=plot(x,y1,'LineWidth',1);
% Beschriftung der vertikalen Achse
ax.YLabel.String='SOC in %';
% Anpassung der Linienfarbe

% Achsen der Darstellung als separate Variable auffuehren
ax=gca;
% Grenzen der horizontalen Achse anpassen
ax.XLim=[17280,18720]; 
% Werte der horizontalen Achse anpassen
%ax.XTick=(ax.XLim(1):3:ax.XLim(2));
% Beschriftung der horizontalen Achse
ax.XLabel.String='Minuten des Tages';
% Grenzen der vertikalen Achse anpassen
%ax.YLim=[-6 6];
title('Leistungsflüsse des Systemes');
% Gitternetz hinzufügen
grid on
% Legende ergaenzen
l=legend(...
    {...
    'Differenzleistung',...
    'Batterie-leistung',...
    'PV-Leistung',...
    'Netzleistung',...
    },...
    'Location','northeast');
% Hintergrundfarbe auf weiss setzen
set(gcf,'color','w');