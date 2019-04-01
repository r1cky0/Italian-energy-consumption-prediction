clc 
close all
clear all

tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorno_anno = tab.giorno_anno;
giorno_settimana= tab.giorno_settimana;
dati = tab.dati;

figure(1)
plot(dati)
title('Andamento giornaliero')
xlabel("Giorno dell' anno");
ylabel("Dato letto");
grid on
hold on
%Notiamo un duplice andamento sinusoidale. Sia nell' arco giornaliero che
%in quello annuale

%dati_settimana = dati(1);
%for i=8:7:size(dati)
%    dati_settimana = cat(1,dati_settimana,dati(i));
%end
%Campioniamo settimanalmente e plottiamo
%figure(2)
%plot(dati_settimana)
%title('Andamento settimanale')

%dati_mese = dati(1);
%for i=31:30:size(dati)
%    dati_mese = cat(1,dati_mese,dati(i));
%end
%Campioniamo mensilmente e plottiamo
%figure(3)
%plot(dati_mese)

%% Media
%Metodo per risolvere NaN mettendoli = media giorno prima e giorno
%dopo
nulli = isnan(dati);
for i=1:1:size(dati)
    if nulli(i)==1
        dati(i)= (dati(i-1) + dati(i+1))/2;
    end
end

% %media settimanale
% valori = 0;
% for i=1:1:7
%     valori = valori + dati(i);
% end
% media_tot= valori/7;
% 
% for i=8:7:(size(dati)-7)
%     valori = 0;
%     for j=1:1:7
%         valori = valori + dati(i+j);
%     end
%     media = valori/7;
%     media_tot = cat(1,media_tot,media);
% end
% figure(2)
% plot(media_tot)
% title('Media settimanale')

%% MODELLI 

uni = ones(365,1);
f1 = fit(giorno_anno, dati,'fourier6');
% plot(f1,giorno_anno,media_tot)

%Stima annuale
giorni_lineare = giorno_anno(1:365);

w = 2*pi/365;

Phi = [uni cos(w*giorni_lineare) sin(w*giorni_lineare) cos(2*w*giorni_lineare) ...
    sin(2*w*giorni_lineare) cos(3*w*giorni_lineare) sin(3*w*giorni_lineare) ...
    cos(4*w*giorni_lineare) sin(4*w*giorni_lineare)];

ThetaLS = Phi\dati(1:365);

y= Phi * ThetaLS;

epsilon = dati(1:365) - y;

%plot(y)

%Inizia l'altro
giorno_lineare_settimana = giorno_settimana(1:365);
w2 = 2*pi/7;

Phi2 = [cos(w2*giorno_lineare_settimana) sin(w2*giorno_lineare_settimana) ...
    cos(2*w2*giorno_lineare_settimana) sin(2*w2*giorno_lineare_settimana) ...
    cos(3*w2*giorno_lineare_settimana) sin(3*w2*giorno_lineare_settimana) ...
    cos(4*w2*giorno_lineare_settimana) sin(4*w2*giorno_lineare_settimana)];

ThetaLS2 = Phi2\dati(1:365);

y2= Phi2 * ThetaLS2;

epsilon2 = dati(1:365) - y2;

%plot(y2)

yfin = y + y2;
plot(yfin)

