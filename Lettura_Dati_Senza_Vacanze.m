clc 
close all
clear all

%% LETTURA DATI
tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorni_anni = tab.giorno_anno;
giorni_settimana= tab.giorno_settimana;
dati = tab.dati;

%Metodo per risolvere NaN mettendoli uguali alla media tra il valore del 
%giorno prima e quello del giorno dopo
nulli = isnan(dati);
for i=1:1:size(dati)
    if nulli(i)==1
        dati(i)= (dati(i-1) + dati(i+1))/2;
    end
end

%% DETRENDIZZAZIONE DATI
%Togliamo il trend per "limare" gli errori e rendere migliore l' andamento
uni = ones(730,1);
n = length(uni);

giorni = [1:730]';

Phi_trend = [uni giorni];

ThetaLS_trend = Phi_trend\dati;

y_trend = Phi_trend * ThetaLS_trend;

dati = dati - y_trend;

%DATI PER MODELLO(PRIMO ANNO)
anno_modello = giorni_anni(1:365);
anno_vacanza = cat(1, anno_modello(1:6),anno_modello(223:230), ...
                        anno_modello(357:365));

anno_modello = cat(1, anno_modello(7:210),anno_modello(231:356));

settimana_modello = giorni_settimana(1:365);
settimana_vacanza = cat(1, settimana_modello(1:6),settimana_modello(223:230), ...
                            settimana_modello(357:365));

settimana_modello = cat(1, settimana_modello(7:210),settimana_modello(231:356));

dati_modello = dati(1:365);
dati_modello = cat(1, dati_modello(7:210),dati_modello(231:356));

%DATI PER VALIDAZIONE(SECONDO ANNO)
anno_validazione = giorni_anni(366:730);
anno_val_xSSR = cat(1, anno_validazione(7:210),anno_validazione(231:356));

settimana_validazione = giorni_settimana(366:730);
settimana_val_xSSR = cat(1, settimana_validazione(7:210),settimana_validazione(231:356));

dati_validazione = dati(366:730);
dati_validazione_xSSR = cat(1, dati_validazione(7:210),dati_validazione(231:356));

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

Phi_sett_validazione = [cos(w_settimanale*settimana_validazione) ...
    sin(w_settimanale*settimana_validazione) ...
    cos(2*w_settimanale*settimana_validazione) ...
    sin(2*w_settimanale*settimana_validazione) ...
    cos(3*w_settimanale*settimana_validazione) ...
    sin(3*w_settimanale*settimana_validazione)];

Phi_ann_validazione = [cos(w_annuale*anno_validazione) ...
    sin(w_annuale*anno_validazione) ... 
    cos(2*w_annuale*anno_validazione) sin(2*w_annuale*anno_validazione) ... 
    cos(3*w_annuale*anno_validazione) sin(3*w_annuale*anno_validazione) ...
    cos(4*w_annuale*anno_validazione) sin(4*w_annuale*anno_validazione) ...
    cos(5*w_annuale*anno_validazione) sin(5*w_annuale*anno_validazione) ...
    cos(6*w_annuale*anno_validazione) sin(6*w_annuale*anno_validazione) ...
    cos(7*w_annuale*anno_validazione) sin(7*w_annuale*anno_validazione) ...
    cos(8*w_annuale*anno_validazione) sin(8*w_annuale*anno_validazione) ... 
    cos(9*w_annuale*anno_validazione) sin(9*w_annuale*anno_validazione) ...
    cos(10*w_annuale*anno_validazione) sin(10*w_annuale*anno_validazione)];

Phi_sett_validazione_xSSR = [cos(w_settimanale*settimana_val_xSSR) ...
    sin(w_settimanale*settimana_val_xSSR) ...
    cos(2*w_settimanale*settimana_val_xSSR) ...
    sin(2*w_settimanale*settimana_val_xSSR) ...
    cos(3*w_settimanale*settimana_val_xSSR) ...
    sin(3*w_settimanale*settimana_val_xSSR)];

Phi_ann_validazione_xSSR = [cos(w_annuale*anno_val_xSSR) ...
    sin(w_annuale*anno_val_xSSR) ... 
    cos(2*w_annuale*anno_val_xSSR) sin(2*w_annuale*anno_val_xSSR) ... 
    cos(3*w_annuale*anno_val_xSSR) sin(3*w_annuale*anno_val_xSSR) ...
    cos(4*w_annuale*anno_val_xSSR) sin(4*w_annuale*anno_val_xSSR) ...
    cos(5*w_annuale*anno_val_xSSR) sin(5*w_annuale*anno_val_xSSR) ...
    cos(6*w_annuale*anno_val_xSSR) sin(6*w_annuale*anno_val_xSSR) ...
    cos(7*w_annuale*anno_val_xSSR) sin(7*w_annuale*anno_val_xSSR) ...
    cos(8*w_annuale*anno_val_xSSR) sin(8*w_annuale*anno_val_xSSR) ... 
    cos(9*w_annuale*anno_val_xSSR) sin(9*w_annuale*anno_val_xSSR) ...
    cos(10*w_annuale*anno_val_xSSR) sin(10*w_annuale*anno_val_xSSR)];

Phi_modello = [Phi_sett_modello Phi_ann_modello];

ThetaLS = Phi_modello\dati_modello;

y_modello = Phi_modello * ThetaLS;

Phi_val_xSSR = [Phi_sett_validazione_xSSR Phi_ann_validazione_xSSR];

y_val_xSSR = Phi_val_xSSR * ThetaLS;

Phi_val = [Phi_sett_validazione Phi_ann_validazione];

y_val = Phi_val * ThetaLS;

figure(4);
title('VALIDAZIONE MODELLO (SU DATI SECONDO ANNO)')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
hold on
grid on
plot(dati_validazione)
plot(y_val);

epsilon_val_noVac = dati_validazione_xSSR - y_val_xSSR;
SSR_val_noVac = (epsilon_val_noVac') * epsilon_val_noVac;

epsilon_val = dati_validazione - y_val;
SSR_val = (epsilon_val') * epsilon_val;
