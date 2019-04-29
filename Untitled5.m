tab = readtable('arr.xlsx', 'Range', 'A2:C732');
giorni_anni = tab.giorno_anno;
giorni_settimana= tab.giorno_settimana;
dati = tab.dati;

giorni_anno_modello = giorni_anni(1:365);
giorni_settimana_modello = giorni_settimana(1:365);
dati_modello = dati(1:365);

giorni_anno_validazione = giorni_anni(366:730);
giorni_settimana_validazione = giorni_settimana(366:730);
dati_validazione = dati(366:730);

previsione = finalfunction(giorni_anno_modello,giorni_settimana_modello,dati_modello);

plot(previsione)