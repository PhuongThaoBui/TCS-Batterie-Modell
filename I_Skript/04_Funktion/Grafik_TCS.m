% Neues Fenster für die Grafik erstellen
figure
% Bildname (wird spaeter fuer den Export verwendet)
im='Bild_1';
% Matrix mit den einzelnen Variablen
mat=[TCS_in, TCS_out, ETCS]; % Evtl. transponieren, falls Probleme auftauchen
% Vektor fuer die horizontale Achse
x=[1:1:70080]; % Evtl. transponieren, falls Probleme auftauchen
% Darstellung als Liniendiagramm
p=plot(x,mat,'LineWidth',2);
% Anpassung der Linienfarben
p(1).Color = [0.4627    0.7255         0];% gruen
p(2).Color = [1.0000    0.8000         0];% gelb
p(3).Color = [0.8000    0.2000         0];% rot
% Achsen der Darstellung als separate Variable auffuehren
ax=gca;
% Grenzen der horizontalen Achse anpassen
%ax.XLim=[0 70]; 
% Werte der horizontalen Achse anpassen
%ax.XTick=(ax.XLim(1):2:ax.XLim(2));
% Beschriftung der horizontalen Achse
ax.XLabel.String='Monate von 5 Jahren';
% Grenzen der vertikalen Achse anpassen
%ax.YLim=[0 100];
% Werte der horizontalen Achse anpassen
%ax.YTick=(ax.YLim(1):20:ax.YLim(2));
% Beschriftung der vertikalen Achse
ax.YLabel.String='Leistung kW';
% Vertikale Achse um Prozent mit Leerzeichen erweitern
%ytickformat(ax, '%g %%');
% Gitternetz hinzufügen
grid on
% Legende 
legend('TCS_in', 'TCS_out','ETCS');
% Hintergrundfarbe auf weiss setzen
set(gcf,'color','w');
% Schriftgroesse vereinheitlichen
fig=gcf; fonsize=12; set(findall(fig,'-property','FontSize'),'FontSize',fonsize); set(findall(fig,'-property','FontName'),'FontName','Verdana');
% Grafik als PNG-Datei exportieren
print(im,'-dpng')