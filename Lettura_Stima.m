clc 
close all
clear all

%% Lettura dati e plot
tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorno_anno = tab.giorno_anno;
giorno_settimana= tab.giorno_settimana;
dati = tab.dati;

%Metodo per risolvere NaN mettendoli uguali alla media tra giorno prima e giorno
%dopo
nulli = isnan(dati); %vettore lungo come dati composto da tutti zeri tranne
%dove si ha Nan. Lí abbiamo uni
for i=1:1:size(dati)
    if nulli(i)==1
        dati(i)= (dati(i-1) + dati(i+1))/2;
    end
end

% figure(1)
% plot(giorno_anno, dati,'o')
% title('Andamento giornaliero')
% xlabel("Giorno dell' anno");
% ylabel("Dato letto");
% grid on
% hold on

%% Stima 
% 
% n = length(dati);
% uni = ones(n,1);
% 
% % Modello del primo ordine 
% phi1 = uni;
% [thetaLS1, std_theta1] = lscov(phi1, dati);
% %errore = rendimento - stima
% epsilon1 = dati - phi1*thetaLS1;
% q1=length(thetaLS1);
% SSR1 = (epsilon1' * epsilon1);
% 
% figure(2)
% scatter (giorno_anno, dati, 'xblue');
% hold on
% %plottiamo anche con la stima
% scatter(giorno_anno, phi1*thetaLS1,'ored')
% grid on
% 
% %Modello del secondo ordine
% phi2 = [uni, giorno_anno];
% [thetaLS2, std_theta2] = lscov(phi2, dati);
% epsilon2 = dati - phi2*thetaLS2;
% q2 = length(thetaLS2);
% SSR2 = (epsilon2' * epsilon2);
% 
% %Modello del terzo ordine
% phi3 = [uni, giorno_anno, (giorno_anno).^2];
% [thetaLS3, std_theta3] = lscov(phi3, dati);
% epsilon3 = dati - phi3*thetaLS3;
% q3 = length(thetaLS3);
% SSR3 = (epsilon3' * epsilon3);
% %Modello del quarto ordine
% 
% %Modello del quinto ordine

%% Fourier

f1 = fit(giorno_anno, dati, 'fourier4');
plot(f1, giorno_anno, dati)

f2 = fit(giorno_settimana, dati, 'fourier2');
plot(f2, giorno_settimana, dati)

