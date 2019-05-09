function [s_hat] = prediz(d,w)

tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorni_settimana= tab.giorno_settimana;
dati = tab.dati;
giorni_anno = [1:730]';

dati = interp1(giorni_anno(~isnan(dati)), dati(~isnan(dati)), giorni_anno, 'linear');

%% DETRENDIZZAZIONE
uni = ones(730,1);

Phi_trend = [uni giorni_anno];

ThetaLS_trend = Phi_trend\dati;

y_trend = Phi_trend * ThetaLS_trend;

dati = dati - y_trend;

%% MODELLO
w_settimanale = 2*pi/7;
w_annuale = 2*pi/365;

Phi_settimanale = [cos(w_settimanale*giorni_settimana) sin(w_settimanale*giorni_settimana) ...
    cos(2*w_settimanale*giorni_settimana) sin(2*w_settimanale*giorni_settimana) ...
    cos(3*w_settimanale*giorni_settimana) sin(3*w_settimanale*giorni_settimana)];

Phi_annuale = [cos(w_annuale*giorni_anno) sin(w_annuale*giorni_anno) ... 
    cos(2*w_annuale*giorni_anno) sin(2*w_annuale*giorni_anno) ... 
    cos(3*w_annuale*giorni_anno) sin(3*w_annuale*giorni_anno) ...
    cos(4*w_annuale*giorni_anno) sin(4*w_annuale*giorni_anno) ...
    cos(5*w_annuale*giorni_anno) sin(5*w_annuale*giorni_anno) ...
    cos(6*w_annuale*giorni_anno) sin(6*w_annuale*giorni_anno) ...
    cos(7*w_annuale*giorni_anno) sin(7*w_annuale*giorni_anno) ...
    cos(8*w_annuale*giorni_anno) sin(8*w_annuale*giorni_anno) ... 
    cos(9*w_annuale*giorni_anno) sin(9*w_annuale*giorni_anno) ...
    cos(10*w_annuale*giorni_anno) sin(10*w_annuale*giorni_anno)];

Phi = [Phi_settimanale Phi_annuale];

ThetaLS = Phi\dati;

%% MESHGRID
s = [1:7]';
g = [1:365]';

[GA,GS] = meshgrid(g, s);

Phi_ext = [cos(w_settimanale*GS(:)) sin(w_settimanale*GS(:)) ...
    cos(2*w_settimanale*GS(:)) sin(2*w_settimanale*GS(:)) ...
    cos(3*w_settimanale*GS(:)) sin(3*w_settimanale*GS(:)) ...
    cos(w_annuale*GA(:)) sin(w_annuale*GA(:)) ... 
    cos(2*w_annuale*GA(:)) sin(2*w_annuale*GA(:)) ... 
    cos(3*w_annuale*GA(:)) sin(3*w_annuale*GA(:)) ...
    cos(4*w_annuale*GA(:)) sin(4*w_annuale*GA(:)) ...
    cos(5*w_annuale*GA(:)) sin(5*w_annuale*GA(:)) ...
    cos(6*w_annuale*GA(:)) sin(6*w_annuale*GA(:)) ...
    cos(7*w_annuale*GA(:)) sin(7*w_annuale*GA(:)) ...
    cos(8*w_annuale*GA(:)) sin(8*w_annuale*GA(:)) ... 
    cos(9*w_annuale*GA(:)) sin(9*w_annuale*GA(:)) ...
    cos(10*w_annuale*GA(:)) sin(10*w_annuale*GA(:))];

dati_previsione = Phi_ext * ThetaLS;

y_trend2 = y_trend(730);

dati_previsione = dati_previsione + y_trend2;

dati_previsione_mat = reshape(dati_previsione, size(GA));

figure(5)
title("MODELLO 3D")
xlabel('Giorno dell''anno')
ylabel('Giorno della settimana')
zlabel('Consumo energetico [kw]')
grid on
hold on
mesh (GA, GS, dati_previsione_mat);

s_hat = dati_previsione_mat(w,d);

end

