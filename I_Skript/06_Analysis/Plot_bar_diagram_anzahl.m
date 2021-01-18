figure
im='Energie_Anteil_Abhaengig_von_n_gross';
ax=gca;
addpath('../03_Sim_Umgebung/ERG')
load('ERG_end_richtig.mat')

x = 2013:1:2016;
Elx = El*ERG(x,6);
ELpv = El*ERG(x,7);
Elbat = El*ERG(x,8);
Elg = El*ERG(x,9);
a = 1:1:4;
mat=[ELpv,Elbat,Elg];

b=bar(a,mat,'stacked','BarWidth',0.5);
b(1).FaceColor = [1.0000    0.8000         0]; % gelb
b(2).FaceColor = [0.0510    0.5216         0]; % dunkelgruen
b(3).FaceColor = [0.2471    0.2471    0.2471]; % dunkelgrau


ax.XLabel.String='Anzahl der Person im Haushalt';
ax.YLabel.String='Energie in kWh';
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
print(im,'-dpng')