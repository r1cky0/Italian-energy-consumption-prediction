clc 
close all
clear all

%% LETTURA DATI

tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorni_anni = tab.giorno_anno;
giorni_settimana= tab.giorno_settimana;
dati = tab.dati;

%Metodo per risolvere NaN mettendoli = media giorno prima e giorno
%dopo
nulli = isnan(dati);
for i=1:1:size(dati)
    if nulli(i)==1
        dati(i)= (dati(i-1) + dati(i+1))/2;
    end
end

%DATI PER MODELLO(PRIMO ANNO)
giorni_anno_modello = giorni_anni(1:365);
giorni_settimana_modello = giorni_settimana(1:365);
dati_modello = dati(1:365);

%DATI PER VALIDAZIONE(SECONDO ANNO)
giorni_anno_validazione = giorni_anni(366:730);
giorni_settimana_validazione = giorni_settimana(366:730);
dati_validazione = dati(366:730);

%PLOT DATI
figure(1)
plot(giorni_anno_modello, dati_modello);
title('DATI PRIMO ANNO')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
grid on

%% MODELLI 

%MODELLO PERIODICITÁ ANNUALE
uni = ones(365,1);
w_annuale = 2*pi/365;

Phi_annuale = [uni cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello)];

ThetaLS_annuale = Phi_annuale\dati_modello;

y_annuale= Phi_annuale * ThetaLS_annuale;

epsilon_annuale = dati_modello - y_annuale;

figure(2)
title('MODELLO PERIODICITÁ ANNUALE')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
grid on
hold on
plot(giorni_anno_modello, dati_modello)
plot(y_annuale);

%MODELLO PERIODICITÁ SETTIMANALE
w_settimanale = 2*pi/7;

Phi_settimanale = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello) ...
    cos(2*w_settimanale*giorni_settimana_modello) sin(2*w_settimanale*giorni_settimana_modello) ...
    cos(3*w_settimanale*giorni_settimana_modello) sin(3*w_settimanale*giorni_settimana_modello) ...
    cos(4*w_settimanale*giorni_settimana_modello) sin(4*w_settimanale*giorni_settimana_modello)];

ThetaLS_settimanale = Phi_settimanale\dati_modello;

y_settimanale= Phi_settimanale * ThetaLS_settimanale;

epsilon_settimanale = dati_modello - y_settimanale;

y_fin = y_annuale + y_settimanale;

figure(3)
title('MODELLO PERIODICITÁ SETTIMANALE')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
grid on
hold on
plot(giorni_anno_modello, dati_modello)
plot(y_fin);




