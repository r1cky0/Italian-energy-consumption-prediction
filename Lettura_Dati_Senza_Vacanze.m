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
giorni_anno_modello = cat(1, giorni_anno_modello(7:217),giorni_anno_modello(231:356));
giorni_settimana_modello = giorni_settimana(1:365);
giorni_settimana_modello = cat(1, giorni_settimana_modello(7:217),giorni_settimana_modello(231:356));
dati_modello = dati(1:365);
dati_modello = cat(1, dati_modello(7:217),dati_modello(231:356));

%DATI PER VALIDAZIONE(SECONDO ANNO)
giorni_anno_validazione_tot = giorni_anni(366:730);
giorni_anno_val_corti = cat(1, giorni_anno_validazione_tot(7:217),giorni_anno_validazione_tot(231:356));
giorni_settimana_validazione_tot = giorni_settimana(366:730);
giorni_set_val_corti = cat(1, giorni_settimana_validazione_tot(7:217),giorni_settimana_validazione_tot(231:356));
dati_validazione = dati(366:730);
dati_validaione_corti = cat(1, dati_validazione(7:217),dati_validazione(231:356));

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

Phi_validazione = [cos(w_settimanale*giorni_set_val_corti) sin(w_settimanale*giorni_set_val_corti) ...
    cos(2*w_settimanale*giorni_set_val_corti) sin(2*w_settimanale*giorni_set_val_corti) ...
    cos(3*w_settimanale*giorni_set_val_corti) sin(3*w_settimanale*giorni_set_val_corti)];

Phi_totale = [Phi_settimanale Phi_annuale];

ThetaLS_totale = Phi_totale\dati_modello;

y_totale = Phi_totale * ThetaLS_totale;

Phi_tot_val = [Phi_validazione Phi_annuale];

y_tot_fin = Phi_tot_val * ThetaLS_totale;

figure(4);
title('VALIDAZIONE MODELLO (SU DATI SECONDO ANNO)')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
hold on
grid on
plot(dati_modello)
plot(y_totale);

epsilon_tot_val = dati_validaione_corti - y_tot_fin;
SSR_tot_val = (epsilon_tot_val') * epsilon_tot_val;
