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
giorni_anno_modello = giorni_anni(1:365);
giorni_anno_vacanza = cat(1, giorni_anno_modello(1:6),giorni_anno_modello(223:230), ...
                        giorni_anno_modello(357:365));

giorni_anno_modello = cat(1, giorni_anno_modello(7:210),giorni_anno_modello(231:356));

giorni_settimana_modello = giorni_settimana(1:365);
giorni_settimana_vacanza = cat(1, giorni_settimana_modello(1:6),giorni_settimana_modello(223:230), ...
                            giorni_settimana_modello(357:365));

giorni_settimana_modello = cat(1, giorni_settimana_modello(7:210),giorni_settimana_modello(231:356));

dati_modello = dati(1:365);
dati_modello = cat(1, dati_modello(7:210),dati_modello(231:356));

%DATI PER VALIDAZIONE(SECONDO ANNO)
giorni_anno_validazione = giorni_anni(366:730);
giorni_anno_val = cat(1, giorni_anno_validazione(7:210),giorni_anno_validazione(231:356));

giorni_settimana_validazione = giorni_settimana(366:730);
giorni_settimana_val = cat(1, giorni_settimana_validazione(7:210),giorni_settimana_validazione(231:356));

dati_validazione = dati(366:730);
dati_validazione_xSSR = cat(1, dati_validazione(7:210),dati_validazione(231:356));

%% MODELLO
w_settimanale = 2*pi/7;
w_annuale = 2*pi/365;

Phi_settimanale = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello) ...
    cos(2*w_settimanale*giorni_settimana_modello) sin(2*w_settimanale*giorni_settimana_modello) ...
    cos(3*w_settimanale*giorni_settimana_modello) sin(3*w_settimanale*giorni_settimana_modello)];

Phi_annuale = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello) ...
    cos(7*w_annuale*giorni_anno_modello) sin(7*w_annuale*giorni_anno_modello) ...
    cos(8*w_annuale*giorni_anno_modello) sin(8*w_annuale*giorni_anno_modello) ... 
    cos(9*w_annuale*giorni_anno_modello) sin(9*w_annuale*giorni_anno_modello) ...
    cos(10*w_annuale*giorni_anno_modello) sin(10*w_annuale*giorni_anno_modello)];

Phi_sett_validazione_xSSR = [cos(w_settimanale*giorni_settimana_val) ...
    sin(w_settimanale*giorni_settimana_val) ...
    cos(2*w_settimanale*giorni_settimana_val) ...
    sin(2*w_settimanale*giorni_settimana_val) ...
    cos(3*w_settimanale*giorni_settimana_val) ...
    sin(3*w_settimanale*giorni_settimana_val)];

Phi_ann_validazione_xSSR = [cos(w_annuale*giorni_anno_val) ...
    sin(w_annuale*giorni_anno_val) ... 
    cos(2*w_annuale*giorni_anno_val) sin(2*w_annuale*giorni_anno_val) ... 
    cos(3*w_annuale*giorni_anno_val) sin(3*w_annuale*giorni_anno_val) ...
    cos(4*w_annuale*giorni_anno_val) sin(4*w_annuale*giorni_anno_val) ...
    cos(5*w_annuale*giorni_anno_val) sin(5*w_annuale*giorni_anno_val) ...
    cos(6*w_annuale*giorni_anno_val) sin(6*w_annuale*giorni_anno_val) ...
    cos(7*w_annuale*giorni_anno_val) sin(7*w_annuale*giorni_anno_val) ...
    cos(8*w_annuale*giorni_anno_val) sin(8*w_annuale*giorni_anno_val) ... 
    cos(9*w_annuale*giorni_anno_val) sin(9*w_annuale*giorni_anno_val) ...
    cos(10*w_annuale*giorni_anno_val) sin(10*w_annuale*giorni_anno_val)];

Phi_totale = [Phi_settimanale Phi_annuale];

ThetaLS_totale = Phi_totale\dati_modello;

y_modello = Phi_totale * ThetaLS_totale;

Phi_tot_val = [Phi_sett_validazione_xSSR Phi_ann_validazione_xSSR];

y_tot_fin = Phi_tot_val * ThetaLS_totale;

figure(4);
title('VALIDAZIONE MODELLO (SU DATI SECONDO ANNO)')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
hold on
grid on
plot(dati_validazione_xSSR)
plot(y_tot_fin);

epsilon_tot_val = dati_validazione_xSSR - y_tot_fin;
SSR_tot_val = (epsilon_tot_val') * epsilon_tot_val;
