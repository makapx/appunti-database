## Esercizi normalizzazione

Dal libro di testo di Atzeni-Ceri, capitolo 9.

| Docente | Dipartimento | Facoltà    | Preside | Corso     |
| ------- | ------------ | ---------- | ------- | --------- |
| Verdi   | Matematica   | Ingegneria | Neri    | Analisi   |
| Verdi   | Matematica   | Ingegneria | Neri    | Geometria |
| Rossi   | Fisica       | Ingegneria | Neri    | Analisi   |
| Rossi   | Fisica       | Scienze    | Bruni   | Analisi   |
| Bruni   | Fisica       | Scienze    | Bruni   | Fisica    |

**Figura 9.20**

**Esercizio 9.1**: Considerare la relazione in Figura 9.20 e individuare le proprietà della corrispondente applicazione. Individuare inoltre eventuali ridondanze e anomalie nella relazione

**Risposta**: L'applicazione memorizza valori relativi ad un ambiente universitario.

Un docente può insegnare uno o più corsi. Un docente può insegnare in più dipartimenti. Il dipartimento è relativo alla facoltà. In una facoltà c'è un solo dipartimento del dato tipo, ma omonimi dipartimenti possono essere presenti in altre facoltà. Ogni facoltà ha un suo presidente, il presidente può essere un docente ma non è detto lo sia.

Ridondanze: Facoltà e presidente.

Anomalie:

-  Di inserimento: si potrebbe voler registrare un docente ma non gli è stato ancora assegnato il corso
- Di aggiornamento: se cambia il presidente vanno aggiornati tutti i valori che lo riportano
- Di eliminazione: se devo eliminare Bruni scompare anche il corso di Fisica

**Esercizio 9.2**: Individuare la chiave e le dipendenze funzionali della relazione nell'esercizio 9.1 e individuare poi una decomposizione in forma normale di Boyce e Codd

**Risposta**:
$$
Facoltà \rightarrow Presidente \\
Presidente \rightarrow Facoltà \\
Corso,Facoltà,Dipartimento \rightarrow Docente \ (chiave)
$$

| Facoltà    | Presidente |
| ---------- | ---------- |
| Ingegneria | Neri       |
| Scienze    | Bruni      |

| Docente | Dipartimento | Facoltà    | Corso     |
| ------- | ------------ | ---------- | --------- |
| Verdi   | Matematica   | Ingegneria | Analisi   |
| Verdi   | Matematica   | Ingegneria | Geometria |
| Rossi   | Fisica       | Ingegneria | Analisi   |
| Rossi   | Fisica       | Scienze    | Analisi   |
| Bruni   | Fisica       | Scienze    | Fisica    |

**Esercizio 9.3**: Si consideri la relazione riportata in Figura 9.21 che rappresenta alcune informazioni sui prodotti di una falegnameria e i relativi componenti. Vengono indicati:

- il tipo di componente di un prodotto (attributo Tipo)
- la quantità del componente necessaria per un certo prodotto (attributo Q)
- il prezzo unitario del componente di un certo prodotto (attributo PC)
- il fornitore del componente (attributo Fornitore)
- il prezzo totale del singolo prodotto (attributo PT)

Individuare le dipendenze funzionali e la chiave di questa relazione

| Prodotto  | Componente | Tipo    | Q    | PC     | Fornitore | PT      |
| --------- | ---------- | ------- | ---- | ------ | --------- | ------- |
| Libreria  | Legno      | Noce    | 50   | 10 000 | Forrest   | 400 000 |
| Libreria  | Bulloni    | B212    | 200  | 100    | Bolt      | 400 000 |
| Libreria  | Vetro      | Cristal | 3    | 5000   | Clean     | 400 000 |
| Scaffale  | Legno      | Mogano  | 5    | 15 000 | Forrest   | 300 000 |
| Scaffale  | Bulloni    | B212    | 250  | 100    | Bolt      | 300 000 |
| Scaffale  | Bulloni    | B412    | 150  | 300    | Bolt      | 300 000 |
| Scrivania | Legno      | Noce    | 10   | 8000   | Wood      | 250 000 |
| Scrivania | Maniglie   | H621    | 10   | 20 000 | Bolt      | 250 000 |
| Tavolo    | Legno      | Noce    | 4    | 10 000 | Forrest   | 200 000 |

**Figura 9.21**


$$
Prodotto \rightarrow PT \\
Componente, Tipo \rightarrow PC \\
Prodotto, Componente, Tipo \ (chiave) \rightarrow Q, PC, Fornitore, PT
$$

**Esercizio 9.4**: con riferimento alla relazione in Figura 9.21 si considerino le seguenti operazioni di aggiornamento:

- inserimento di un nuovo prodotto
- cancellazione di un prodotto
- aggiunta di un componente al prodotto
- modifica del prezzo di un prodotto

Discutere i tipi di anomalia che possono essere causati da tali operazioni

**Risposta**:

- Si può voler inserire un nuovo prodotto ma non sapere ancora quali componenti lo costituiranno, il tipo, il numero di pezzi, il fornitore e il costo effettivo.
- Cancellare un prodotto fa perdere traccia dei materiali che lo compongono e dei fornitori che forniscono i materiali
- Per aggiungere un componente al prodotto devo conoscere già il fornitore che lo fornisce, il prezzo e la quantità. Il prezzo totale dell'intero prodotto, per tutte le righe in cui si ripete, andrà aggiornato per rispecchiare l'aggiunta di una nuova parte.
- Il prezzo di un prodotto va modificato per tutte le righe in cui esso si ripete. Se il prezzo è legato esclusivamente al costo dei materiali per le unità presenti allora va aggiornato anche il valore di prezzo (o la quantità) del materiale/componente che lo fa decrescere.

**Esercizio 9.5**: Si consideri sempre la relazione in figura 9.21. Descrivere le ridondanze presenti e individuare una decomposizione della relazione che non presenti tali ridondanze. Fornire infine l'istanza dello schema così ottenuto, corrispondente all'istanza originale. Verificare poi che sia possibile ricostruire l'istanza originale a partire da tale istanza.

**Risposta**: Il prezzo totale è dipendente dal prodotto, quindi ridondante. Il prezzo per componente dipende dall'insieme tipo, componente e fornitore, è quindi ridondante. La quantità dipende dal prodotto e dal  componente e dal tipo.
$$
Prodotto \rightarrow PT \\
Componente, Tipo, Fornitore \rightarrow PC \\
Prodotto, Componente, Tipo \rightarrow Q
$$

| Prodotto  | Componente | Tipo    | Q    | PC     | Fornitore | PT      |
| --------- | ---------- | ------- | ---- | ------ | --------- | ------- |
| Libreria  | Legno      | Noce    | 50   | 10 000 | Forrest   | 400 000 |
| Libreria  | Bulloni    | B212    | 200  | 100    | Bolt      | 400 000 |
| Libreria  | Vetro      | Cristal | 3    | 5000   | Clean     | 400 000 |
| Scaffale  | Legno      | Mogano  | 5    | 15 000 | Forrest   | 300 000 |
| Scaffale  | Bulloni    | B212    | 250  | 100    | Bolt      | 300 000 |
| Scaffale  | Bulloni    | B412    | 150  | 300    | Bolt      | 300 000 |
| Scrivania | Legno      | Noce    | 10   | 8000   | Wood      | 250 000 |
| Scrivania | Maniglie   | H621    | 10   | 20 000 | Bolt      | 250 000 |
| Tavolo    | Legno      | Noce    | 4    | 10 000 | Forrest   | 200 000 |

| Componente | Tipo    | Fornitore | PC     |
| ---------- | ------- | --------- | ------ |
| Legno      | Noce    | Forrest   | 10 000 |
| Vetro      | Cristal | Clean     | 5000   |
| Legno      | Mogano  | Forrest   | 15 000 |
| Bulloni    | B212    | Bolt      | 100    |
| Bulloni    | B412    | Bolt      | 300    |
| Legno      | Noce    | Wood      | 8000   |
| Maniglie   | H621    | Bolt      | 20 000 |

| Prodotto  | PT      |
| --------- | ------- |
| Libreria  | 400 000 |
| Scaffale  | 300 000 |
| Scrivania | 250 000 |
| Tavolo    | 200 000 |

| Prodotto  | Componente | Tipo    | Q    |
| --------- | ---------- | ------- | ---- |
| Libreria  | Legno      | Noce    | 50   |
| Libreria  | Bulloni    | B212    | 200  |
| Libreria  | Vetro      | Cristal | 3    |
| Scaffale  | Legno      | Mogano  | 5    |
| Scaffale  | Bulloni    | B212    | 250  |
| Scaffale  | Bulloni    | B412    | 150  |
| Scrivania | Legno      | Noce    | 10   |
| Scrivania | Maniglie   | H621    | 10   |
| Tavolo    | Legno      | Noce    | 4    |

L'istanza iniziale si ricostruisce:
$$
( T3 \Join T2 ) \Join _{Componente = T1.Componente \ AND \ Tipo = T1.Tipo } T1
$$
**Esercizio 9.6** Individuare le dipendenze funzionali definite sulla relazione in figura 9.21 e decomporre la relazione con l'algoritmo di sintesi di schemi in terza forma normale illustrato nel Paragrafo 9.6.3