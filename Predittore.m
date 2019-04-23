clc 
close all
clear all

%% LETTURA DATI

tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorni_anno = tab.giorno_anno;
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

figure(2)
plot(dati)
title("TREND")
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
hold on

%% DETRENDIZZAZIONE DATI
%Togliamo il trend per "limare" gli errori e rendere migliore l' andamento
uni = ones(730,1);
n = length(uni);

giorni = (1:730)';

Phi_trend = [uni giorni];

ThetaLS_trend = Phi_trend\dati;

y_trend = Phi_trend * ThetaLS_trend;

dati = dati - y_trend;

plot(y_trend)
grid on

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

y = Phi * ThetaLS;

figure(4);
title('MODELLO')
xlabel("Giorno anno");
ylabel("Consumo energetico [kw]");
hold on
grid on
plot(dati)
plot(y);

epsilon = dati - y;
SSR = (epsilon') * epsilon;

%% PLOT 3D
g = [1:7]';
[GA,GS] = meshgrid(giorni, g);

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

y_ext = Phi_ext * ThetaLS;

y_ext_matrice = reshape(y_ext, size(GA));

figure(5)
plot3(giorni, giorni_settimana,dati,'o')
title("MODELLO 3D")
xlabel('Giorno dell''anno')
ylabel('Giorno della settimana')
zlabel('Consumo energetico [kw]')
grid on
hold on
mesh (GA, GS, y_ext_matrice);