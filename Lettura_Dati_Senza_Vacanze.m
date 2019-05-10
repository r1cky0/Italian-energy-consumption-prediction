clc 
close all
clear all

%% LETTURA DATI
tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorni_settimana= tab.giorno_settimana;
dati = tab.dati;
giorni_anno = tab.giorno_anno;

g = [1:730]';

%Metodo per risolvere NaN 
dati = interp1(g(~isnan(dati)), dati(~isnan(dati)), g, 'linear');

%DATI PER MODELLO(PRIMO ANNO)
anno_modello = giorni_anno(1:365);

settimana_modello = giorni_settimana(1:365);

dati_modello = dati(1:365);
                 
%DATI PER VALIDAZIONE(SECONDO ANNO)
anno_validazione = giorni_anno(366:730);

settimana_validazione = giorni_settimana(366:730);

dati_validazione = dati(366:730);

%% DETRENDIZZAZIONE DATI
%Togliamo il trend per "limare" gli errori e rendere migliore l' andamento
uni = ones(365,1);
n = length(uni);

Phi_trend = [uni anno_modello];

ThetaLS_trend = Phi_trend\dati_modello;

y_trend = Phi_trend * ThetaLS_trend;

dati_modello = dati_modello - y_trend;

%% SELEZIONE DATI
%Selezione periodi di vacanza a natale e ferragosto
anno_modello = cat(1, anno_modello(7:213),anno_modello(226:356));

settimana_modello = cat(1, settimana_modello(7:213),settimana_modello(226:356));

dati_natale = cat(1, dati_modello(1:6), dati_modello(357:365));
dati_ferragosto = dati_modello(214:225);

media_natale = mean(dati_natale);
media_ferragosto = mean(dati_ferragosto);      

dati_modello = cat(1, dati_modello(7:213),dati_modello(226:356));

%% MODELLO
w_settimanale = 2*pi/7;
w_annuale = 2*pi/365;

Phi_sett_modello = [cos(w_settimanale*settimana_modello) sin(w_settimanale*settimana_modello) ...
    cos(2*w_settimanale*settimana_modello) sin(2*w_settimanale*settimana_modello) ...
    cos(3*w_settimanale*settimana_modello) sin(3*w_settimanale*settimana_modello)];

Phi_ann_modello = [cos(w_annuale*anno_modello) sin(w_annuale*anno_modello) ... 
    cos(2*w_annuale*anno_modello) sin(2*w_annuale*anno_modello) ... 
    cos(3*w_annuale*anno_modello) sin(3*w_annuale*anno_modello) ...
    cos(4*w_annuale*anno_modello) sin(4*w_annuale*anno_modello) ...
    cos(5*w_annuale*anno_modello) sin(5*w_annuale*anno_modello) ...
    cos(6*w_annuale*anno_modello) sin(6*w_annuale*anno_modello) ...
    cos(7*w_annuale*anno_modello) sin(7*w_annuale*anno_modello) ...
    cos(8*w_annuale*anno_modello) sin(8*w_annuale*anno_modello) ... 
    cos(9*w_annuale*anno_modello) sin(9*w_annuale*anno_modello) ...
    cos(10*w_annuale*anno_modello) sin(10*w_annuale*anno_modello)];

Phi = [Phi_sett_modello Phi_ann_modello];

ThetaLS = Phi\dati_modello;

%% PLOT 3D
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

dati_previsione_mat = reshape(dati_previsione, size(GA));

%% CORREZIONE GIORNI VACANZA
%Sommiamo al modello finale la media dei valori assunti nei giorni di
%vacanza di natale e ferragosto per correggere la predizione
for i=1:1:6
    for j=1:1:7
        dati_previsione_mat(j,i) = dati_previsione_mat(j,i) + media_natale;
    end
end

for i=357:1:365
    for j=1:1:7
        dati_previsione_mat(j,i) = dati_previsione_mat(j,i) + media_natale;
    end
end

for i=214:1:225
    for j=1:1:7
        dati_previsione_mat(j,i) = dati_previsione_mat(j,i) + media_ferragosto;
    end
end

y_trend2 = y_trend(365);

dati_previsione_mat = dati_previsione_mat + y_trend2;

previsione = dati_previsione_mat(settimana_validazione(1),giorni_anno(1));

for i=2:1:365
   previsione = cat(1,previsione,dati_previsione_mat(settimana_validazione(i),giorni_anno(i)));
end

%% VALIDAZIONE SU SECONDO ANNO
epsilon_val = dati_validazione - previsione;
SSR_val = (epsilon_val') * epsilon_val;

