figure
addpath('../03_Sim_Umgebung/ERG')
im='Energie_Anteil_Abhaengig_von_Batterie';
ax=gca;
ERG1= load('ERG_BAT_4_und_6kWh.mat');
load('ERG_end_richtig.mat')
ERG2=load('ERG_Bat_0.mat');
x = 4:28:224;
y = 4:28:32;
Elx = [[El*ERG1.ERG(1,6);El*ERG1.ERG(y,6)]; El*ERG(x,6)];
ELpv = [[El*ERG1.ERG(4,7);El*ERG1.ERG(y,7)];El*ERG(x,7)];
Elbat = [[0;El*ERG1.ERG(y,8)];El*ERG(x,8)];
Elg = [[El-El*ERG1.ERG(4,7);El*ERG1.ERG(y,9)];El*ERG(x,9)];
a = 0:2:20;
mat=[ELpv,Elbat,Elg];

b=bar(a,mat,'stacked','BarWidth',0.5);
b(1).FaceColor = [1.0000    0.8000         0]; % gelb
b(2).FaceColor = [0.0510    0.5216         0]; % dunkelgruen
b(3).FaceColor = [0.2471    0.2471    0.2471]; % dunkelgrau


ax.XLabel.String='Batteriekapazität in kWh';
ax.YLabel.String='Energie in kWh';
title('Anteile der Energieversorung in Abhängigkeit der Batteriekapazität beim 4kWp PV-Leistung')
l=legend([b(3) b(2) b(1) ],...
    {...
    'Netzversorgung',...
    'Batterieversorgung',...
    'PV-Direktversorgung',...
    },...
    'Location','northeast');
% Legendenrahmen entfernen
%legend('boxoff')
% Hintergrundfarbe auf weiss setzen
set(gcf,'color','w');
% Schriftgroesse vereinheitlichen
fig=gcf; fonsize=12; set(findall(fig,'-property','FontSize'),'FontSize',fonsize); set(findall(fig,'-property','FontName'),'FontName','Verdana');
