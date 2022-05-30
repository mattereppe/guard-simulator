# guard-simulator

Simulator for the Medial Records application. It emulates a doctor that access the data of two patients.

There are two optional parameters, to repeat the request and to set the "speed" to make calls within the request.



I parametri sono opzionali, se lo lanci direttamente simula la navigazione fatta tramite client per consultare i dati di due pazienti

i due parametri previsti permettono di ripetere n volte la richiesta completa e di scegliere la "velocità" con cui vengono fatte le chiamate dentro alla richiesta

in particolare con -u scegli il numero di iterazioni

con -d il ritardo massimo tra una chiamata http e l'altra, il valore effettivo viene preso in modo random tra 0 secondi e questo valore (default 4) quindi diminuendolo la sessione sarà più veloce, aumentandolo più lento

es: ./simulator.sh -d 3 -u 2

in questo caso simula 2 volte la consultazione dei dati di due pazienti prevedendo un tempo massimo di 3 secondi tra una chiamata http e l'altra
