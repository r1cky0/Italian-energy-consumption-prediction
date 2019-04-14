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
title("DATI")
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
grid on

%DATI PER MODELLO(PRIMO ANNO)
giorni_anno_modello = giorni_anni(1:365);
giorni_settimana_modello = giorni_settimana(1:365);
dati_modello = dati(1:365);

%DATI PER VALIDAZIONE(SECONDO ANNO)
giorni_anno_validazione = giorni_anni(366:730);
giorni_settimana_validazione = giorni_settimana(366:730);
dati_validazione = dati(366:730);

figure(2)
plot(dati_modello)
title("TREND")
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
hold on

%% DETRENDIZZAZIONE DATI
uni = ones(365,1);
n = length(uni);

Phi_trend = [uni giorni_anno_modello];

ThetaLS_trend = Phi_trend\dati_modello;

y_trend = Phi_trend * ThetaLS_trend;

dati_modello = dati_modello - y_trend;
dati_validazione = dati_validazione - y_trend;

plot(y_trend)
grid on

%% MODELLI 
%MODELLO PERIODICITÁ SETTIMANALE

%Il periodo é di 7 giorni
w_settimanale = 2*pi/7;

Phi_settimanale = [cos(w_settimanale*giorni_settimana_modello) sin(w_settimanale*giorni_settimana_modello) ...
    cos(2*w_settimanale*giorni_settimana_modello) sin(2*w_settimanale*giorni_settimana_modello) ...
    cos(3*w_settimanale*giorni_settimana_modello) sin(3*w_settimanale*giorni_settimana_modello)];

ThetaLS_settimanale = Phi_settimanale\dati_modello;

y_settimanale= Phi_settimanale * ThetaLS_settimanale;

epsilon_settimanale = dati_modello - y_settimanale;

%MODELLO PERIODICITÁ ANNUALE
% %Nelle serie di fourier abbiamo sin(n*w*x) e cos(n*w*x) dove w=2pi/Periodo
% %e n é il grado
w_annuale = 2*pi/365;

Phi_annuale1 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello)];

Phi_annuale2 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello)];

Phi_annuale3 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello)];

Phi_annuale4 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello)];

Phi_annuale5 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello)];

Phi_annuale6 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello)];

Phi_annuale7 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello) ...
    cos(7*w_annuale*giorni_anno_modello) sin(7*w_annuale*giorni_anno_modello)];

Phi_annuale8 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello) ...
    cos(7*w_annuale*giorni_anno_modello) sin(7*w_annuale*giorni_anno_modello) ...
    cos(8*w_annuale*giorni_anno_modello) sin(8*w_annuale*giorni_anno_modello)];

Phi_annuale9 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello) ...
    cos(7*w_annuale*giorni_anno_modello) sin(7*w_annuale*giorni_anno_modello) ...
    cos(8*w_annuale*giorni_anno_modello) sin(8*w_annuale*giorni_anno_modello) ... 
    cos(9*w_annuale*giorni_anno_modello) sin(9*w_annuale*giorni_anno_modello)];

Phi_annuale10 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello) ...
    cos(7*w_annuale*giorni_anno_modello) sin(7*w_annuale*giorni_anno_modello) ...
    cos(8*w_annuale*giorni_anno_modello) sin(8*w_annuale*giorni_anno_modello) ... 
    cos(9*w_annuale*giorni_anno_modello) sin(9*w_annuale*giorni_anno_modello) ...
    cos(10*w_annuale*giorni_anno_modello) sin(10*w_annuale*giorni_anno_modello)];

Phi_annuale11 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello) ...
    cos(7*w_annuale*giorni_anno_modello) sin(7*w_annuale*giorni_anno_modello) ...
    cos(8*w_annuale*giorni_anno_modello) sin(8*w_annuale*giorni_anno_modello) ... 
    cos(9*w_annuale*giorni_anno_modello) sin(9*w_annuale*giorni_anno_modello) ...
    cos(10*w_annuale*giorni_anno_modello) sin(10*w_annuale*giorni_anno_modello) ...
    cos(11*w_annuale*giorni_anno_modello) sin(11*w_annuale*giorni_anno_modello)];

Phi_annuale12 = [cos(w_annuale*giorni_anno_modello) sin(w_annuale*giorni_anno_modello) ... 
    cos(2*w_annuale*giorni_anno_modello) sin(2*w_annuale*giorni_anno_modello) ... 
    cos(3*w_annuale*giorni_anno_modello) sin(3*w_annuale*giorni_anno_modello) ...
    cos(4*w_annuale*giorni_anno_modello) sin(4*w_annuale*giorni_anno_modello) ...
    cos(5*w_annuale*giorni_anno_modello) sin(5*w_annuale*giorni_anno_modello) ...
    cos(6*w_annuale*giorni_anno_modello) sin(6*w_annuale*giorni_anno_modello) ...
    cos(7*w_annuale*giorni_anno_modello) sin(7*w_annuale*giorni_anno_modello) ...
    cos(8*w_annuale*giorni_anno_modello) sin(8*w_annuale*giorni_anno_modello) ... 
    cos(9*w_annuale*giorni_anno_modello) sin(9*w_annuale*giorni_anno_modello) ...
    cos(10*w_annuale*giorni_anno_modello) sin(10*w_annuale*giorni_anno_modello) ...
    cos(11*w_annuale*giorni_anno_modello) sin(11*w_annuale*giorni_anno_modello) ...
    cos(12*w_annuale*giorni_anno_modello) sin(12*w_annuale*giorni_anno_modello)];

%Y=Phi * Theta ---> Essendo matrici: Theta = Phi inversa * Y
ThetaLS_annuale1 = Phi_annuale1\epsilon_settimanale;
ThetaLS_annuale2 = Phi_annuale2\epsilon_settimanale;
ThetaLS_annuale3 = Phi_annuale3\epsilon_settimanale;
ThetaLS_annuale4 = Phi_annuale4\epsilon_settimanale;
ThetaLS_annuale5 = Phi_annuale5\epsilon_settimanale;
ThetaLS_annuale6 = Phi_annuale6\epsilon_settimanale;
ThetaLS_annuale7 = Phi_annuale7\epsilon_settimanale;
ThetaLS_annuale8 = Phi_annuale8\epsilon_settimanale;
ThetaLS_annuale9 = Phi_annuale9\epsilon_settimanale;
ThetaLS_annuale10 = Phi_annuale10\epsilon_settimanale;
ThetaLS_annuale11 = Phi_annuale11\epsilon_settimanale;
ThetaLS_annuale12 = Phi_annuale12\epsilon_settimanale;
%ThetaLS modellizza i coefficienti a0, an, bn con n che va da 1 al grado
%scelto per la serie(ovvero il numero di armoniche)

y_annuale1= Phi_annuale1 * ThetaLS_annuale1;
y_annuale2= Phi_annuale2 * ThetaLS_annuale2;
y_annuale3= Phi_annuale3 * ThetaLS_annuale3;
y_annuale4= Phi_annuale4 * ThetaLS_annuale4;
y_annuale5= Phi_annuale5 * ThetaLS_annuale5;
y_annuale6= Phi_annuale6 * ThetaLS_annuale6;
y_annuale7= Phi_annuale7 * ThetaLS_annuale7;
y_annuale8= Phi_annuale8 * ThetaLS_annuale8;
y_annuale9= Phi_annuale9* ThetaLS_annuale9;
y_annuale10= Phi_annuale10* ThetaLS_annuale10;
y_annuale11= Phi_annuale11* ThetaLS_annuale11;
y_annuale12= Phi_annuale12* ThetaLS_annuale12;

epsilon_annuale1 = dati_modello - y_annuale1;
epsilon_annuale2 = dati_modello - y_annuale2;
epsilon_annuale3 = dati_modello - y_annuale3;
epsilon_annuale4 = dati_modello - y_annuale4;
epsilon_annuale5 = dati_modello - y_annuale5;
epsilon_annuale6 = dati_modello - y_annuale6;
epsilon_annuale7 = dati_modello - y_annuale7;
epsilon_annuale8 = dati_modello - y_annuale8;
epsilon_annuale9 = dati_modello - y_annuale9;
epsilon_annuale10 = dati_modello - y_annuale10;
epsilon_annuale11 = dati_modello - y_annuale11;
epsilon_annuale12 = dati_modello - y_annuale12;

SSR_annuale1 = epsilon_annuale1'*epsilon_annuale1;
SSR_annuale2 = epsilon_annuale2'*epsilon_annuale2;
SSR_annuale3 = epsilon_annuale3'*epsilon_annuale3;
SSR_annuale4 = epsilon_annuale4'*epsilon_annuale4;
SSR_annuale5 = epsilon_annuale5'*epsilon_annuale5;
SSR_annuale6 = epsilon_annuale6'*epsilon_annuale6;
SSR_annuale7 = epsilon_annuale7'*epsilon_annuale7;
SSR_annuale8 = epsilon_annuale8'*epsilon_annuale8;
SSR_annuale9 = epsilon_annuale9'*epsilon_annuale9;
SSR_annuale10 = epsilon_annuale10'*epsilon_annuale10;
SSR_annuale11 = epsilon_annuale11'*epsilon_annuale11;
SSR_annuale12 = epsilon_annuale12'*epsilon_annuale12;

%% VALIDAZIONE
%PHI VALIDAZIONE
Phi_validazione = [cos(w_settimanale*giorni_settimana_validazione) sin(w_settimanale*giorni_settimana_validazione) ...
    cos(2*w_settimanale*giorni_settimana_validazione) sin(2*w_settimanale*giorni_settimana_validazione) ...
    cos(3*w_settimanale*giorni_settimana_validazione) sin(3*w_settimanale*giorni_settimana_validazione)];

y_validazione = Phi_validazione * ThetaLS_settimanale;

%Usiamo y_annuale perché non avrebbe senso fare una y_validazione_annuale
%dato che sarebbe identica dato che sarebbe da una phi in cui utlizzeremmo
%giorni_anno_validazione dentro a sin e cos che sono uguali a giorni_anno_modello
y_fin1 = y_annuale1 + y_validazione;
y_fin2 = y_annuale2 + y_validazione;
y_fin3 = y_annuale3 + y_validazione;
y_fin4 = y_annuale4 + y_validazione;
y_fin5 = y_annuale5 + y_validazione;
y_fin6 = y_annuale6 + y_validazione;
y_fin7 = y_annuale7 + y_validazione;
y_fin8 = y_annuale8 + y_validazione;
y_fin9 = y_annuale9 + y_validazione;
y_fin10 = y_annuale10 + y_validazione;
y_fin11 = y_annuale11 + y_validazione;
y_fin12 = y_annuale12 + y_validazione;

%TEST AIC
q1 = length(ThetaLS_annuale1);
aic1 = 2*q1/n + log(SSR_annuale1);

q2 = length(ThetaLS_annuale2);
aic2 = 2*q2/n + log(SSR_annuale2);

q3 = length(ThetaLS_annuale3);
aic3 = 2*q3/n + log(SSR_annuale3);

q4 = length(ThetaLS_annuale4);
aic4 = 2*q4/n + log(SSR_annuale4);

q5 = length(ThetaLS_annuale5);
aic5 = 2*q5/n + log(SSR_annuale5);

q6 = length(ThetaLS_annuale6);
aic6 = 2*q6/n + log(SSR_annuale6);

q7 = length(ThetaLS_annuale7);
aic7 = 2*q7/n + log(SSR_annuale7);

q8 = length(ThetaLS_annuale8);
aic8 = 2*q8/n + log(SSR_annuale8);

q9 = length(ThetaLS_annuale9);
aic9 = 2*q9/n + log(SSR_annuale9);

q10 = length(ThetaLS_annuale10);
aic10 = 2*q10/n + log(SSR_annuale10);

q11 = length(ThetaLS_annuale11);
aic11 = 2*q11/n + log(SSR_annuale11);

q12 = length(ThetaLS_annuale12);
aic12 = 2*q12/n + log(SSR_annuale12);


%CROSSVALIDAZIONE
epsilon_validazione1 = dati_validazione - y_fin1;
SSR_validazione1 = epsilon_validazione1'*epsilon_validazione1;

epsilon_validazione2 = dati_validazione - y_fin2;
SSR_validazione2 = epsilon_validazione2'*epsilon_validazione2;

epsilon_validazione3 = dati_validazione - y_fin3;
SSR_validazione3 = epsilon_validazione3'*epsilon_validazione3;

epsilon_validazione4 = dati_validazione - y_fin4;
SSR_validazione4 = epsilon_validazione4'*epsilon_validazione4;

epsilon_validazione5 = dati_validazione - y_fin5;
SSR_validazione5 = epsilon_validazione5'*epsilon_validazione5;

epsilon_validazione6 = dati_validazione - y_fin6;
SSR_validazione6 = epsilon_validazione6'*epsilon_validazione6;

epsilon_validazione7 = dati_validazione - y_fin7;
SSR_validazione7 = epsilon_validazione7'*epsilon_validazione7;

epsilon_validazione8 = dati_validazione - y_fin8;
SSR_validazione8 = epsilon_validazione8'*epsilon_validazione8;

epsilon_validazione9 = dati_validazione - y_fin9;
SSR_validazione9 = epsilon_validazione9'*epsilon_validazione9;

epsilon_validazione10 = dati_validazione - y_fin10;
SSR_validazione10 = epsilon_validazione10'*epsilon_validazione10;

epsilon_validazione11 = dati_validazione - y_fin11;
SSR_validazione11 = epsilon_validazione11'*epsilon_validazione11;

epsilon_validazione12 = dati_validazione - y_fin12;
SSR_validazione12 = epsilon_validazione12'*epsilon_validazione12;

figure(3);
title('VALIDAZIONE MODELLO (SU DATI SECONDO ANNO)')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
hold on
grid on
plot(giorni_anno_validazione, dati_validazione)
plot(y_fin10);

%MODELLO 10 SEMBRA IL MIGLIORE PER LA CROSSVALIDAZIONE

% figure(4)
% plot3(giorni_anno_modello, giorni_settimana_modello,dati_modello,'o')
% title("MODELLO 3D")
% xlabel('Giorno dell''anno')
% ylabel('Giorno della settimana')
% zlabel('Consumo energetico [kw]')
% grid on
% hold on
% plot3(giorni_anno_modello, giorni_settimana_modello,y_fin10,'x')
% 
% %% Plot con mesh
% giorni_anno_ext = linspace(min(giorni_anno_validazione),max(giorni_anno_validazione), 100);
% giorni_settimana_ext = linspace(min(giorni_settimana_validazione), max(giorni_settimana_validazione), 100);
% [GA,GS] = meshgrid(giorni_anno_ext, giorni_settimana_ext);

