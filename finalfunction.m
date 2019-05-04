function [dati_previsione] = finalfunction(giorni_anno,giorni_settimana,dati)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dati = interp1(giorni_anno(~isnan(dati)), dati(~isnan(dati)), giorni_anno, 'linear');


%% DETRENDIZZAZIONE DATI
%Togliamo il trend per "limare" gli errori e rendere migliore l' andamento
uni = ones(365,1);
n = length(uni);

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

%% PHI VALIDAZIONE
%Creiamo il vettore dei giorni della settimana basandoci sull' anno
%precedente
if giorni_settimana(365) ~= 7
    x = giorni_settimana(365) + 1;
else
    x = 1;
end
    
giorni_settimana_predizione = [];

for j=x:1:7
    giorni_settimana_predizione = cat(1,giorni_settimana_predizione,j);
end

for i=1:1:51
    for j=1:1:7
        giorni_settimana_predizione = cat(1,giorni_settimana_predizione,j);
    end
end

y = 365 - size(giorni_settimana_predizione);

for j=1:1:y
    giorni_settimana_predizione = cat(1,giorni_settimana_predizione,j);
end

Phi_sett_predizione = [cos(w_settimanale*giorni_settimana_predizione) sin(w_settimanale*giorni_settimana_predizione) ...
    cos(2*w_settimanale*giorni_settimana_predizione) sin(2*w_settimanale*giorni_settimana_predizione) ...
    cos(3*w_settimanale*giorni_settimana_predizione) sin(3*w_settimanale*giorni_settimana_predizione)];

Phi_predizione = [Phi_sett_predizione Phi_annuale];

dati_previsione = Phi_predizione * ThetaLS;

y_trend2 = [];

for i=1:1:365
    y_trend2 = cat(1,y_trend2,y_trend(365));
end

dati_previsione = dati_previsione + y_trend2;

end
