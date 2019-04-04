clc 
close all
clear all

tab = readtable('caricoITAday.xlsx', 'Range', 'A2:C732');
giorno_anno = tab.giorno_anno;
giorno_settimana= tab.giorno_settimana;
dati = tab.dati;

figure(1)
plot3(giorno_anno, giorno_settimana, dati, 'x')

title('Andamento giornaliero')
xlabel("Giorno anno");
ylabel("Giorno settimana");
zlabel("Consumo energetico [kw]");
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
% f1 = fit(giorno_anno, dati,'fourier6');
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
% plot(yfin)

% %Modello 3d
% Phi3 = [uni cos(w*giorni_lineare) sin(w*giorni_lineare) cos(w2*giorno_lineare_settimana) ...
%     sin(w2*giorno_lineare_settimana) cos(2*w*giorni_lineare) sin(2*w*giorni_lineare) ...
%     cos(2*w2*giorno_lineare_settimana) sin(2*w2*giorno_lineare_settimana)];
% 
% ThetaLS3 = Phi3\dati(1:365);
% 
% y3= Phi3 * ThetaLS3;
%  
% epsilon3 = dati(1:365) - y3;
%  
% plot3(giorni_lineare, giorno_lineare_settimana, y3)

%**************************************************************************
%BISOGNA FARE LA GRIGLIA PER DISEGNARE LA SUPERFICIE CORRETTAMENTE NEL PLOT
%**************************************************************************

%Test F al 95%
%f è un indice della riduzione % di SSR che ottengo passando dal modello 
%Mk-1 (meno complesso) al modello Mk (più complesso)
%f? = finv(1-?, gradi libertá numeratore, gradi libertá denominatore)
%f= (Numero Copie dati - k)*(SSRk-1 - SSRk)/SSRk
% f < f? ? scelgo il modello Mk-1
% f > f? ? scelgo il modello Mk

%Fra 1 e 2 
% fAlpha_anno1= finv(1-0.05, 1, 2);
% f_anno12= (365-2)*(SSR_annuale1 - SSR_annuale2)/(SSR_annuale2);
% %fra 2 e 3:
% fAlpha_anno2= finv(1-0.05, 1, 3);
% f_anno23= (365-3)*(SSR_annuale2 - SSR_annuale3)/(SSR_annuale3);
% %fra 3 e 4:
% fAlpha_anno3= finv(1-0.05, 1, 4);
% f_anno34= (365-4)*(SSR_annuale3 - SSR_annuale4)/(SSR_annuale4);
% %fra 4 e 5:
% fAlpha_anno4= finv(1-0.05, 1, 5);
% f_anno45= (365-5)*(SSR_annuale4 - SSR_annuale5)/(SSR_annuale5);

