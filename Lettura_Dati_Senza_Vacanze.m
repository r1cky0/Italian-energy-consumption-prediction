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

%DATI PER MODELLO(PRIMO ANNO)
anno_modello = giorni_anni(1:365);

settimana_modello = giorni_settimana(1:365);

dati_modello = dati(1:365);
                 
%DATI PER VALIDAZIONE(SECONDO ANNO)
anno_validazione = giorni_anni(366:730);

settimana_validazione = giorni_settimana(366:730);

dati_validazione = dati(366:730);

%% DETRENDIZZAZIONE DATI
%Togliamo il trend per "limare" gli errori e rendere migliore l' andamento
uni = ones(365,1);
n = length(uni);

giorni = [1:365]';

Phi_trend = [uni giorni];

ThetaLS_trend = Phi_trend\dati_modello;

y_trend = Phi_trend * ThetaLS_trend;

dati_modello = dati_modello - y_trend;

%% SELEZIONE DATI
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

Phi_modello = [Phi_sett_modello Phi_ann_modello];

ThetaLS = Phi_modello\dati_modello;

y_modello = Phi_modello * ThetaLS;

Phi_val = [Phi_sett_validazione Phi_ann_validazione];

y_val = Phi_val * ThetaLS;

for i=1:1:6
    y_val(i) = y_val(i) + media_natale;
end

for i=357:1:365
    y_val(i) = y_val(i) + media_natale;
end

for i=214:1:225
    y_val(i) = y_val(i) + media_ferragosto;
end

ytrend2 = y_trend(365);
y_val = y_val + ytrend2;

figure(4);
title('VALIDAZIONE MODELLO (SU DATI SECONDO ANNO)')
xlabel("Giorno anno");
ylabel("Consumo energetico [GW]");
hold on
grid on
plot(dati_validazione)
plot(y_val);

epsilon_val = dati_validazione - y_val;
SSR_val = (epsilon_val') * epsilon_val;

figure(5)
plot(epsilon_val)
grid on

figure(6)
histogram(epsilon_val)
grid on
