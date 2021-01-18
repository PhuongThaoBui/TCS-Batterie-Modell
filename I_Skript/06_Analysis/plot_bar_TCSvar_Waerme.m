figure
im='Energie_Anteil_Abhaengig_von_TCS_BatVar_klein';
ax=gca;
addpath('../03_Sim_Umgebung/ERG')
load('ERG_end_richtig.mat')

x = 1796:4:1820;
y = 400:400:2800;
E_rhx =  E_rh*ERG(x,10);
Etcs2h = E_rh*ERG(x,11);
Epv2h = E_rh*ERG(x,12);
Eg2h = E_rh*ERG(x,13);
%a = 0:2:20;
mat=[Etcs2h,Epv2h,Eg2h];

%p(1).Color = [0.5020    0.5020    0.5020];
%p(2).Color = [0.3804    0.9020    0.0078];
%p(3).Color = [0.0510    0.5216         0];

p=bar(y,mat,'stacked','BarWidth',0.5);

title('Wärmeversorungsanteil des Haushalts im Abhängigkeit der Batterie bei PV-Leistung 20kWp ')
ax.XLabel.String='TCS-kapazität in kWh';
ax.YLabel.String='Energie in kWh';
l=legend([p(3) p(2) p(1) ],...
    {...
    'Gridversorgung',...
    'PV-Überschus-Versorgung',...
    'TCS-Versorgung',...
    },...
    'Location','northeast');
% Legendenrahmen entfernen
%legend('boxoff')
% Hintergrundfarbe auf weiss setzen
set(gcf,'color','w');
% Schriftgroesse vereinheitlichen
fig=gcf; fonsize=12; set(findall(fig,'-property','FontSize'),'FontSize',fonsize); set(findall(fig,'-property','FontName'),'FontName','Verdana');
% print(im,'-dpng')