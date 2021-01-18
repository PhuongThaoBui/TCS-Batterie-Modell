figure
im='Energie_Anteil_Abhaengig_von_n_gross';
ax=gca;
addpath('../03_Sim_Umgebung/ERG')
load('ERG_end_richtig.mat')
% 1 Person
El1 = sum(Verbrauch5Jahre.P1.P_el(1:70080,1))*f*f_s/Jahr;
x = 2013;
Elx1 = El1*ERG(x,6);
ELpv1 = El1*ERG(x,7);
Elbat1 = El1*ERG(x,8);
Elg1 = El1*ERG(x,9);

% 2 Personen 
x2 = 2014;
El2 = sum(Verbrauch5Jahre.P2.P_el(1:70080,1))*f*f_s/Jahr;
Elx2 = El2*ERG(x2,6);
ELpv2 = El2*ERG(x2,7);
Elbat2 = El2*ERG(x2,8);
Elg2 = El2*ERG(x2,9);

% 3 Personen 
x3 = 2015;
El3 = sum(Verbrauch5Jahre.P3.P_el(1:70080,1))*f*f_s/Jahr;
Elx3 = El3*ERG(x3,6);
ELpv3 = El3*ERG(x3,7);
Elbat3 = El3*ERG(x3,8);
Elg3 = El3*ERG(x3,9);

% 4 Personen 
x4 = 2016;
El4 = sum(Verbrauch5Jahre.P4.P_el(1:70080,1))*f*f_s/Jahr;
Elx4 = El4*ERG(x4,6);
ELpv4 = El4*ERG(x4,7);
Elbat4 = El4*ERG(x4,8);
Elg4 = El4*ERG(x4,9);

a = 1:1:4;

Elbat=[Elbat1;Elbat2;Elbat3;Elbat4];
Elpv=[ELpv1;ELpv2;ELpv3;ELpv4];
Elg=[Elg1;Elg2;Elg3;Elg4];
mat=[Elpv,Elbat,Elg];


b=bar(a,mat,'stacked','BarWidth',0.5);
b(1).FaceColor = [1.0000    0.8000         0]; % gelb
b(2).FaceColor = [0.0510    0.5216         0]; % dunkelgruen
b(3).FaceColor = [0.2471    0.2471    0.2471]; % dunkelgrau

title('Energieversorungsanteil beim Ansteig der Personen')
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
