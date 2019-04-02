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

%PLOT DI TUTTI I DATI
figure(1)
plot(dati)
title('Dati letti')
grid on

%DATI PER MODELLO(PRIMO ANNO)
giorni_anno_modello = giorni_anni(1:365);
giorni_settimana_modello = giorni_settimana(1:365);
dati_modello = dati(1:365);

%DATI PER VALIDAZIONE(SECONDO ANNO)
giorni_anno_validazione = giorni_anni(366:730);
giorni_settimana_validazione = giorni_settimana(366:730);
dati_validazione = dati(366:730);

%PLOT DATI DEL PRIMO ANNO
figure(2)
plot(giorni_anno_modello, dati_modello);
title('DATI PRIMO ANNO')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
grid on

%% MODELLI 

%MODELLO PERIODICITÁ ANNUALE
uni = ones(365,1);

%Nelle serie di fourier abbiamo sin(n*w*x) e cos(n*w*x) dove w=2pi/Periodo
%e n é il grado
w_annuale = 2*pi/365;

Phi_annuale1 = [uni cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello)];

Phi_annuale2 = [uni cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello)];

Phi_annuale3 = [uni cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello)];

Phi_annuale4 = [uni cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello)];

Phi_annuale5 = [uni cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello)];

%ThetaLS modellizza i coefficienti a0, an, bn con n che va da 1 al grado
%scelto per la serie(ovvero il numero di armoniche)
ThetaLS_annuale1 = Phi_annuale1\dati_modello;
ThetaLS_annuale2 = Phi_annuale2\dati_modello;
ThetaLS_annuale3 = Phi_annuale3\dati_modello;
ThetaLS_annuale4 = Phi_annuale4\dati_modello;
ThetaLS_annuale5 = Phi_annuale5\dati_modello;

y_annuale1= Phi_annuale1 * ThetaLS_annuale1;
y_annuale2= Phi_annuale2 * ThetaLS_annuale2;
y_annuale3= Phi_annuale3 * ThetaLS_annuale3;
y_annuale4= Phi_annuale4 * ThetaLS_annuale4;
y_annuale5= Phi_annuale5 * ThetaLS_annuale5;

epsilon_annuale1 = dati_modello - y_annuale1;
epsilon_annuale2 = dati_modello - y_annuale2;
epsilon_annuale3 = dati_modello - y_annuale3;
epsilon_annuale4 = dati_modello - y_annuale4;
epsilon_annuale5 = dati_modello - y_annuale5;

figure(2)
title('MODELLO PERIODICITÁ ANNUALE')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
grid on
hold on
plot(giorni_anno_modello, dati_modello)
plot(y_annuale5);

%MODELLO PERIODICITÁ SETTIMANALE
%Il periodo é ora di 7 giorni
w_settimanale = 2*pi/7;

Phi_settimanale1 = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello)];

Phi_settimanale2 = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello) ...
    cos(2*w_settimanale*giorni_settimana_modello) sin(2*w_settimanale*giorni_settimana_modello)];

Phi_settimanale3 = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello) ...
    cos(2*w_settimanale*giorni_settimana_modello) sin(2*w_settimanale*giorni_settimana_modello) ...
    cos(3*w_settimanale*giorni_settimana_modello) sin(3*w_settimanale*giorni_settimana_modello)];

Phi_settimanale4 = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello) ...
    cos(2*w_settimanale*giorni_settimana_modello) sin(2*w_settimanale*giorni_settimana_modello) ...
    cos(3*w_settimanale*giorni_settimana_modello) sin(3*w_settimanale*giorni_settimana_modello) ...
    cos(4*w_settimanale*giorni_settimana_modello) sin(4*w_settimanale*giorni_settimana_modello)];

Phi_settimanale5 = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello) ...
    cos(2*w_settimanale*giorni_settimana_modello) sin(2*w_settimanale*giorni_settimana_modello) ...
    cos(3*w_settimanale*giorni_settimana_modello) sin(3*w_settimanale*giorni_settimana_modello) ...
    cos(4*w_settimanale*giorni_settimana_modello) sin(4*w_settimanale*giorni_settimana_modello) ...
    cos(5*w_settimanale*giorni_settimana_modello) sin(5*w_settimanale*giorni_settimana_modello)];

ThetaLS_settimanale1 = Phi_settimanale1\dati_modello;
ThetaLS_settimanale2 = Phi_settimanale2\dati_modello;
ThetaLS_settimanale3 = Phi_settimanale3\dati_modello;
ThetaLS_settimanale4 = Phi_settimanale4\dati_modello;
ThetaLS_settimanale5 = Phi_settimanale5\dati_modello;

y_settimanale1= Phi_settimanale1 * ThetaLS_settimanale1;
y_settimanale2= Phi_settimanale2 * ThetaLS_settimanale2;
y_settimanale3= Phi_settimanale3 * ThetaLS_settimanale3;
y_settimanale4= Phi_settimanale4 * ThetaLS_settimanale4;
y_settimanale5= Phi_settimanale5 * ThetaLS_settimanale5;

epsilon_settimanale1 = dati_modello - y_settimanale1;
epsilon_settimanale2 = dati_modello - y_settimanale2;
epsilon_settimanale3 = dati_modello - y_settimanale3;
epsilon_settimanale4 = dati_modello - y_settimanale4;
epsilon_settimanale5 = dati_modello - y_settimanale5;

y_fin1 = y_annuale1 + y_settimanale1;
y_fin2 = y_annuale2 + y_settimanale2;
y_fin3 = y_annuale3 + y_settimanale3;
y_fin4 = y_annuale4 + y_settimanale4;
y_fin5 = y_annuale5 + y_settimanale5;

figure(3)
title('MODELLO PERIODICITÁ SETTIMANALE')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
grid on
hold on
plot(giorni_anno_modello, dati_modello)
plot(y_fin5);




