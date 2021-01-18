% Achsen der Darstellung als separate Variable auffuehren
ax=gca;
time = 1:1:35040;
y = soc_TCS(1:35040,1)*100;
plot(time,y, 'LineWidth',1)


% Grenzen der horizontalen Achse anpassen
ax.XLim=[1 35040]; 
% Werte der horizontalen Achse anpassen
%ax.XTick=(ax.XLim(1):3:ax.XLim(2));
% Beschriftung der horizontalen Achse
ax.XLabel.String='Minuten des Tages';
ax.YLabel.String='SOC von TCS in %';
% Grenzen der vertikalen Achse anpassen
%ax.YLim=[-6 6];
title('State of Change von TCS');
% Gitternetz hinzufügen
grid on
% Legende ergaenzen
l=legend(...
    {...
    'soc_{TCS}',...
    },...
    'Location','northeast');
% Hintergrundfarbe auf weiss setzen
set(gcf,'color','w');