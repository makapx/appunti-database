# ALGEBRA RELAZIONALE

[TOC]

L'algebra relazionale è uno strumento teorico, basato sulla teoria matematica, che permette di definire strutture dati e relazioni a partire da esse. Teorizzata da Edgar F. Codd a cavallo tra i '70 e gli '80, ancora oggi è un potente strumento per astrarre i concetti legati ai database.

## Nomenclatura

Vengono convenzionalmente utilizzati i seguenti simboli con scopo a seguire:

- $R$, $S$, $P$ ed altre lettere finali dell'alfabeto denotano le **relazioni**
- $A$, $B$ e altre lettere iniziali dell'alfabeto denotano i **singoli attributi**, contenuti all'interno delle relazioni
- $X$, $Y$ denotano **insiemi di attributi** all'interno delle relazioni, ad esempio data una relazione:
  $Esami = \{id,data,professore,insegnamento,voto,matricola\}$ si può estrarre un insieme di attributi $VotiEsami = \{voto, matricola\}$ 

## Operatori fondamentali

Anche detti operatori **primitivi**. Rappresentano le operazioni principali che è possibile compiere su una relazione.

- **Ridenominazione** $\rho$ (*rho* o anche *ro*): permette di rinominare gli attributi di una relazione, molto utile per generare alias.

- **Unione** $\cup$: operazione di unione classica della teoria degli insiemi

- **Differenza** $-$: operazione di differenza classica della teoria degli insiemi

- **Proiezione** $\Pi$ o $\pi$ (*Pi* o pi-greco maiuscuolo): consente di ottenere un sottoinsieme della relazione proiettata. Per ricondurci al linguaggio SQL, può essere intesa come una `SELECT` priva di condizioni.

  ```sql
  SELECT id, matricola, voto FROM esami;
  ```

  Si dice anche che l'operazione di proiezione **riduce il grado (numero di attributi) della relazione su cui è applicata**. L'operazione di proiezione inoltre elimina le tuple duplicate, nel caso in cui esse siano presenti.

  - **Selezione** $\sigma$ (sigma): anche nota come *restrizione*, permette di ottenere tutte e sole le tuple che rispettano la condizione sottoposta. Paragonandola nuovamente ai costrutti del SQL, possiamo dire che la selezione è l'equivalente di una clausola `WHERE`.


  ```sql
  SELECT * FROM esami WHERE matricola = '12345678';
  ```

  La selezione può fare uso degli operatori $=, \neq, \ge, \le,>,<$ e le condizioni possono essere combinate tra loro attraverso piùoperatori logici $\and, \or,\neg $.

- **Prodotto cartesiano** $\times$: operazione di prodotto cartesiano classica della teoria degli insiemi. Il prodotto cartesiano è definito nel caso in cui le relazioni sottoposte non abbiano attributi comuni. 

### Esempi di utilizzo per gli operatori relazionali primitivi

#### Ridenominazione

Prendiamo una relazione $Studente$ così composta e rinominiamo l'attributo $ID$ in $Matricola$

|    ID     |  Nome  | Cognome |
| :-------: | :----: | :-----: |
| 123456789 |  Eric  | Barone  |
| 987654321 | Robert |   Fox   |

$$
\rho_{ (ID \rightarrow Matricola) }(Studente)
$$

Otteniamo dopo la ridenominazione una **nuova** relazione le cui tuple rimangono invariate ma l'attributo $ID$ è stato rinominato.

| Matricola |  Nome  | Cognome |
| :-------: | :----: | :-----: |
| 123456789 |  Eric  | Barone  |
| 987654321 | Robert |   Fox   |

#### Proiezione

Utilizziamo la proiezione sulla relazione già vista per estrapolare i numeri di matricola e i cognomi degli studenti.
$$
\Pi_{Matricola, Cognome}(Studente)
$$

| Matricola | Cognome |
| :-------: | :-----: |
| 123456789 | Barone  |
| 987654321 |   Fox   |

Se supponiamo che nella relazione siano presenti omonimi e ci limitiamo a proiettare nome e cognome noteremo, come già anticipato, che il numero di tuple della nuova relazione è minore rispetto all'originale.

| Matricola |  Nome  | Cognome |
| :-------: | :----: | :-----: |
| 123456789 |  Eric  | Barone  |
| 987654321 | Robert |   Fox   |
| 123123123 | Robert |   Fox   |

$$
\Pi_{Nome, Cognome}(Studente)
$$

|  Nome  | Cognome |
| :----: | :-----: |
|  Eric  | Barone  |
| Robert |   Fox   |

#### Selezione

Applichiamo la selezione alla relazione con gli omonimi per trovare tutti gli studenti che vanno di cognome Fox.
$$
\sigma_{Cognome=Fox}(Studente)
$$

| Matricola |  Nome  | Cognome |
| :-------: | :----: | :-----: |
| 987654321 | Robert |   Fox   |
| 123123123 | Robert |   Fox   |

#### Combinazioni

##### Combinazione di selezione e proiezione

Combiniamo insieme l'operatore selezione con quello di proiezione per ottenere le matricole di tutti gli studenti che vanno di cognome Fox.
$$
\Pi_{Matricola}(\sigma_{Cognome=Fox}(Studente))
$$

| Matricola |
| :-------: |
| 987654321 |
| 123123123 |

Combinare più operatori è possibile in quando ogni operatore da in output una relazione. Esistono banalmente dei limiti alle combinazioni tra operatori, ad esempio non ha senso tentare di proiettare un attributo che non appartiene alla relazione che si sta esaminando, ad esempio non avrebbe senso invertire le due operazioni, ovvero:
$$
\sigma_{Cognome=Fox}(\Pi_{Matricola}(Studente))
$$

##### Combinazione di ridenominazione ed unione

Supponiamo l'esistenza di due relazioni, $Paternità$ e $Maternità$ così fatte:

| Padre     | Figlio  |
| --------- | ------- |
| Wizard    | Abigal  |
| Demetrius | Maru    |
| Kent      | Sam     |
| Kent      | Vincent |

| Madre    | Figlio  |
| -------- | ------- |
| Caroline | Abigail |
| Robin    | Maru    |
| Jodi     | Sam     |
| Jodi     | Vincent |

Allo stato attuale non è possibile applicare l'unione perché i domini della relazione, cioè gli attributi, sono differenti. Mentre il primo è $(Padre, Figlio)$ l'altro è $(Madre, Figlio)$. Rinominiamo gli attributi $Padre$ e $Madre$ allo stesso modo in modo tale da poter fare l'unione su di essi:
$$
\rho_{Padre \rightarrow Genitore}(Paternità) \ \cup \ \rho_{Madre \rightarrow Genitore}(Maternità)
$$
Otteniamo la relazione:

| Genitore  | Figlio  |
| --------- | ------- |
| Wizard    | Abigail |
| Caroline  | Abigail |
| Demetrius | Maru    |
| Robin     | Maru    |
| Kent      | Sam     |
| Jodi      | Sam     |
| Kent      | Vincent |
| Jodi      | Vincent |

Questo, che vuole essere un esempio didattico, può forse essere contro-intuitivo se già si hanno delle basi per quanto riguarda il linguaggio SQL. Infatti un'operazione come la join, illustrata a seguire, risulterebbe sicuramente più intuitiva.

#### Prodotto cartesiano

Consideriamo le relazioni a seguire, $MediaStudente$ e $FruttaStagionale$ e applichiamo il prodotto cartesiano.

| Matricola | Media |
| :-------: | :---: |
| 12345678  |  27   |
| 87654321  |  24   |

| NomeComune | Stagione |
| :--------: | :------: |
|  Lamponi   | Autunno  |
|   Melone   |  Estate  |
|  Pomodori  |  Estate  |

$$
MediaStudente \times FruttaStagionale = (Matricola,Media,NomeComune,Stagione) = \\\\
\{ matricola_1,media_1,nomecomune_1,stagione_1\}, \\
\{ matricola_2, media_2, nomecomune_1, stagione_1\}, \\
\{ matricola_1,media_1,nomecomune_2,stagione_2\}, \\
\ \ \ \ \ \{ matricola_2,media_2,nomecomune_2,stagione_2\}, ...\\
$$

| Matricola | Media | NomeComune | Stagione |
| :-------: | :---: | :--------: | :------: |
| 12345678  |  27   |  Lamponi   | Autunno  |
| 87654321  |  24   |  Lamponi   | Autunno  |
| 12345678  |  27   |   Melone   |  Estate  |
| 87654321  |  24   |   Melone   |  Estate  |
| 12345678  |  27   |  Pomodori  |  Estate  |
| 87654321  |  24   |  Pomodori  |  Estate  |

### :notebook_with_decorative_cover: Osservazioni

Sebbene i concetti introdotti siano intuitivi e necessari per l'uso che se ne dovrà fare a seguire, sono qui in aggiunta riportate alcune considerazioni sugli operatori provenienti dal mondo insiemistico.

- **Unione**: operatore binario. Prese due relazioni, restituisce una relazione. In questo caso la cardinalità della relazione generata è sempre maggiore o uguale della relazione "più grande" tra le due sottoposte.
  L'unione di due relazioni identiche con cardinalità $n$ genera una relazione di cardinalità $n$, identica a quelle sottoposte. L'unione di due relazioni con cardinalità $n$ ed $m$ dove $n \ge m$ genera una relazione con cardinalità $t$ sicuramente maggiore o uguale di $n$, ovvero $t \ge n$. La cardinalità della relazione risultate non è dunque necessariamente $n + m$ visto che i due insiemi possono presentare elementi comuni. Ovviamente $n + m$ è un upper bound (limite superiore) per la cardinalità della nuova relazione.
  Possiamo quindi scrivere:
  $$
  \forall m,n,t \in \mathbb{N}, n \ge m \\
  0 \le n \le t \le n + m
  $$
  Dove la cardinalità 0 per $t$ si ha quando entrambe le cardinalità delle relazioni sottoposte sono zero (e dunque le relazioni sono degli insiemi vuoti) e la cardinalità massima si ha nel caso della totale disgiunzione. La ridenominazione con unione sopra riportata è un caso di cardinalità massima.

- **Differenza**: operatore binario. Prese due relazioni, restituisce una relazione. Mentre l'unione è un operazione commutativa, la differenza risente dell'ordine dei suoi fattori, ovvero $R - S \ne S - R$.
  La cardinalità di una relazione ottenuta dalla differenza è pari alla cardinalità del primo insieme nel caso in cui questi siano totalmente disgiunti, oppure è pari a 0 nel caso il secondo insieme sia totalmente contenuto nel primo. Ovvero:
  $$
  |\ T\ | =
  \begin{cases}
    0 \ se \ R = S \Leftrightarrow R - S = \emptyset \\
    |\ S\ | \ se \ S \ \cap R = \emptyset \Leftrightarrow R - S = R  
  \end{cases}
  $$
  La cardinalità $t$ dell'insieme risultante $T$ è quindi compresa come segue: $0 \le t \le |\ R \ |$.

- **Prodotto cartesiano**: operatore binario. Prese due relazioni, restituisce una relazione. In questo caso la cardinalità della relazione risultante è il prodotto delle cardinalità delle relazioni iniziali, ovvero:
  $$
  |\ R \times S \ | = |\ R \ | \ \cdot \ |\ S \ |
  $$
  Quindi se la relazione $R$ presenta $5$ tuple e la relazione $S$ presenta $4$ tuple, presupponendo che gli insiemi siano disgiunti e che il prodotto cartesiano sia quindi definito, la relazione risultante presenterà esattamente $20$ tuple.
  
  Nella teoria matematica il prodotto cartesiano è definito come:
  $$
  R \times S = \{ tu : t \in R \and u \in S \}
  $$
  Si ricorda inoltre che l'operazione del prodotto cartesiano non gode della proprietà commutativa e quindi l'ordine delle coppie è rilevante, non ha caso si pone l'attenzione sul fatto che le coppie siano **ordinate**.

Quanto descritto fino ad ora può rivelarsi un utile strumento per verificare velocemente la correttezza di un'operazione. Se una certa operazione producesse più o meno tuple di quante effettivamente dovrebbe è facile intuire la presenza di errori (non è detto ovviamente che il giusto numero di tuple siano una garanzia di correttezza).

## Operatori derivati

A partire dagli operatori primitivi è possibile derivare:

- **Intersezione** $\cap$: operatore binario. Prese due relazioni restituisce una relazione i cui elementi, analogamente al suo corrispettivo insiemistico, sono comuni alle due relazioni di partenza. L'intersezione è definita come:
  $$
  R \cap S = \{ t: t \in R \and t \in S \}
  $$
  Con $R$ ed $S$ relazioni dello stesso tipo (definite sugli stessi domini). Può essere derivata dalla differenza come:
  $$
  R \cap S = R - (R-S)
  $$

- **Join** $\Join$ (anche conosciuta come giunzione): operatore binario. Prese due relazioni restituisce una relazione combinazione delle iniziali. La combinazione è basata sul valore degli attributi delle relazioni sottoposte. Si presenta in diverse varianti, ciascuna derivata da differenti combinazioni di operatori primari:

  - **Natural join**
  - **Equi join**
  - **Theta join**
  - **Outer** (in tre varianti)
    - **Left**
    - **Right**
    - **Full**

  Il join (o la join se si preferisce), è un operatore che gode della proprietà sia commutativa che associativa. Una catena di join produce quindi sempre lo stesso risultato indipendentemente posizionamento delle sue relazioni. Essendo la join una tra le operazioni più costose applicabili, è una best practice cercare di anticipare selezioni e proiezioni, in modo tale da ridurre la cardinalità dei risultati intermedi e quindi snellire l'operazione di prodotto cartesiano.

- **Divisione** (o quoziente) $\div$: operatore binario dalla funzione analoga al suo corrispettivo insiemistico. L'operazione di divisione si applica ogni qual volta abbiamo come requisito il "trovare le tuple di R che sono associate con tutte le tuple di S", ad esempio trovare le informazioni di tutti gli studenti che hanno sempre e solo preso 24 agli esami. In termini logici infatti questo tipo di affermazioni si traduce in "se c'è almeno un valore in S per cui la condizione non è soddisfatta, allora la tupla non farà parte del risultato"

### Theta join

La theta join, anche conosciuta come *giunzione condizionale*, è un operando genera una nuova relazione mettendo facendo corrispondere le tuple che rispettano la condizione data. Nella sua forma generale è così rappresentata:
$$
R \Join_{F} S
$$
Le condizioni imponibili nella theta join sono analoghe a quelle viste in altri operatori quindi possono presentare relazioni come maggioranza, minoranza, uguaglianza ed essere concatenate tra loro da operatori logici.

Siano $R$ ed $S$ relazioni così definite:
$$
R (A_1: T_1, ..., A_n: T_n) \\
S(A_{n+1}:T_{n+1}, ... , A_{n+m}:T_{n+m}) \\
$$
La cui intersezione risulta l'insieme vuoto:
$$
\{ A_1 ,..., A_n \} \cap \{ A_{n+1} , ... , A_{n+m} \} = \empty
$$
E poniamo:
$$
1 \le i \le n \and n+1 \le k \le n+m
$$
Con $*$ generica operazione binaria che appartiene all'insieme di quelle già osservate per gli operatori primitivi $ \le, <, \ge, >, =, \ne$ e che abbia senso sui domini su cui si sta definendo.

La theta join è così definita:
$$
R \Join_{A_i * A_k} S = \{ tu : t \in R, u \in S, t.A_i * u.A_k \}
$$
Può quindi essere derivata dagli operatori primitivi come:
$$
R \Join_{A_i * A_k} S = \sigma_{A_i * A_k}( R \times S)
$$
**Quando la theta join è formata esclusivamente da una catena di uguaglianze è detta equi join**

### Equi join

Sebbene sia già qui menzionata, l'equi join è considerata spesso un'estensione della natural join, operatore considerato concettualmente più semplice. Nonostante questo per spiegare il funzionamento della natural join ci si appoggia spesso alla equi join, questo per non riscrivere per intero tutte le operazioni con gli operatori primitivi, che sono appunto esprimibili in funzione della equi join. Visto che ritengo confusionario spiegare un concetto in funzione di un altro non ancora presentato iniziamo introducendo la equi join. Inoltre, essendo un caso particolare della theta join, la definizione rimane pressoché identica ma viene specificata l'operazione di uguaglianza.

Siano $R$ ed $S$ relazioni così definite:
$$
R (A_1: T_1, ..., A_n: T_n) \\
S(A_{n+1}:T_{n+1}, ... , A_{n+m}:T_{n+m}) \\
$$
La cui intersezione risulta l'insieme vuoto:
$$
\{ A_1 ,..., A_n \} \cap \{ A_{n+1} , ... , A_{n+m} \} = \empty
$$
E poniamo:
$$
1 \le i \le n \and n+1 \le k \le n+m
$$
Definiamo la equi join come:
$$
R \Join_{A_i = A_k} S = \{ tu : t \in R, u \in S, t.A_i = u.A_k \}
$$
Il caso d'uso più basilare e diffuso dell'utilizzo della equi join è il confronto tra due soli attributi, appartenenti il primo ad $R$ e il secondo ad $S$, ciò nonostante è utile conoscere la definizione formale e sapere che la catena può estendersi a più operandi equi join.

Visto che la equi join è da intendersi come un caso particolare della theta join, spesso gli esempi di join con uguaglianze simili sono anche chiamati semplicemente theta join. Non appartengono ovviamente alle equi join le theta join a cui a pedice figurano operazioni diverse dall'uguaglianza.

![Equi Join come subset di theta join](./img/theta-equi.drawio.png)

Essendo un caso particolare della theta join, anche la equi join è un operatore derivato dagli operatori primitivi:
$$
R \Join_{A_i = A_k} S = \sigma_{A_i = A_k}( R \times S)
$$

#### Esempio di equi join

Supponiamo di avere le seguenti relazioni $Scuderia$ e $Pilota$

| ID   | Denominazione     | Colore  |
| ---- | ----------------- | ------- |
| 1    | Mercedes          | #00D2BE |
| 2    | Ferrari           | #DC0000 |
| 3    | Red Bull Racing   | #0600EF |
| 4    | Alpine            | #0090FF |
| 5    | Haas              | #FFFFFF |
| 6    | Aston Martin      | #006F62 |
| 7    | AlphaTauri        | #2B4562 |
| 8    | McLaren           | #FF8700 |
| 9    | Alfa Romeo Racing | #900000 |
| 10   | Williams          | #005AFF |

| ID   | Nome             | Numero | IDScuderia |
| ---- | ---------------- | ------ | ---------- |
| 1    | Max Verstappen   | 1      | 3          |
| 2    | Sergio Perez     | 11     | 3          |
| 3    | Lewis Hamilton   | 44     | 1          |
| 4    | Fernando Alonso  | 14     | 6          |
| 5    | Carlos Sainz     | 55     | 2          |
| 6    | Charles Leclerc  | 16     | 2          |
| 7    | Lando Norris     | 4      | 8          |
| 8    | George Russell   | 63     | 1          |
| 9    | Oscar Piastri    | 81     | 8          |
| 10   | Lance Stroll     | 18     | 6          |
| 11   | Pierre Gasly     | 10     | 4          |
| 12   | Esteban Ocon     | 31     | 4          |
| 13   | Alexander Albon  | 23     | 10         |
| 14   | Valtteri Bottas  | 77     | 9          |
| 15   | Nico Hulkenberg  | 27     | 5          |
| 16   | Zhou Guanyu      | 24     | 9          |
| 17   | Yuki Tsunoda     | 22     | 7          |
| 18   | Kevin Magnussen  | 20     | 5          |
| 19   | Liam Lawson      | 40     | 7          |
| 20   | Logan Sargeant   | 2      | 10         |
| 21   | Nyck De Vries    | 21     | 7          |
| 22   | Daniel Ricciardo | 3      | 7          |

Vogliamo ottenere una relazione che contenga tutte le informazioni dei piloti e, in aggiunta, anche quelle delle scuderie a cui appartengo, in questo caso il nome e il codice colore esadecimale. Nella relazione $Pilota$ abbiamo un valore $IDScuderia$, detto **chiave esterna** che fa riferimento alla relazione $Scuderia$. Occorre specificare che se l'$IDScuderia$ della relazione $Pilota$ è uguale al $ID$ della relazione $Scuderia$ le due tuple possono essere messe in relazione e generarne una nuova, appartenente alla relazione che si viene a creare, contenente i valori di queste due.
$$
Pilota \Join_{Pilota.IDScuderia=Scuderia.ID} Scuderia
$$
La relazione risultante è così composta:

| ID   | Nome             | Numero | IDScuderia | Denominazione     | Colore  |
| ---- | ---------------- | ------ | ---------- | ----------------- | ------- |
| 1    | Max Verstappen   | 1      | 3          | Redbull Racing    | #0600EF |
| 2    | Sergio Perez     | 11     | 3          | Redbull Racing    | #0600EF |
| 3    | Lewis Hamilton   | 44     | 1          | Mercedes          | #00D2BE |
| 4    | Fernando Alonso  | 14     | 6          | Aston Martin      | #006F62 |
| 5    | Carlos Sainz     | 55     | 2          | Ferrari           | #DC0000 |
| 6    | Charles Leclerc  | 16     | 2          | Ferrari           | #DC0000 |
| 7    | Lando Norris     | 4      | 8          | McLaren           | #FF8700 |
| 8    | George Russell   | 63     | 1          | Mercedes          | #00D2BE |
| 9    | Oscar Piastri    | 81     | 8          | McLaren           | #FF8700 |
| 10   | Lance Stroll     | 18     | 6          | Aston Martin      | #006F62 |
| 11   | Pierre Gasly     | 10     | 4          | Alpine            | #0090FF |
| 12   | Esteban Ocon     | 31     | 4          | Alpine            | #0090FF |
| 13   | Alexander Albon  | 23     | 10         | Williams          | #005AFF |
| 14   | Valtteri Bottas  | 77     | 9          | Alfa Romeo Racing | #900000 |
| 15   | Nico Hulkenberg  | 27     | 5          | Haas              | #FFFFFF |
| 16   | Zhou Guanyu      | 24     | 9          | Alfa Romeo Racing | #900000 |
| 17   | Yuki Tsunoda     | 22     | 7          | AlphaTauri        | #2B4562 |
| 18   | Kevin Magnussen  | 20     | 5          | Haas              | #FFFFFF |
| 19   | Liam Lawson      | 40     | 7          | AlphaTauri        | #2B4562 |
| 20   | Logan Sargeant   | 2      | 10         | Williams          | #005AFF |
| 21   | Nyck De Vries    | 21     | 7          | AlphaTauri        | #2B4562 |
| 22   | Daniel Ricciardo | 3      | 7          | AlphaTauri        | #2B4562 |

Uno schema simile potrebbe trovare la sua applicazione ad esempio sul sito ufficiale della Formula1, dove alla sezione Drivers sono listati tutti i piloti che le relative scuderie. Ovviamente, essendo l'operazione di join particolarmente costosa, ad ogni visita non corrisponderebbe una query sul database ma piuttosto una richiesta al sistema di cache, che è spesso a sé stante.

Nel caso in cui volessimo conoscere solo una porzione dei risultati, diciamo ad esempio solo le informazioni dei piloti che gareggiano per l'AlphaTauri, che al momento risultano ufficialmente quattro (due in più rispetto alla norma perché sono state effettuate alcune sostituzioni temporanee a causa di alcuni infortuni che impediscono ai piloti principali di gareggiare), potremmo applicare una selezione. In questi casi è opportuno, per questioni di performance, anticipare la selezione alla join.
$$
Pilota \Join_{Pilota.IDScuderia = Scuderia.ID} ( \sigma_{Denominazione='AlphaTauri'}(Scuderia))
$$

| ID   | Nome             | Numero | IDScuderia | Denominazione | Colore  |
| ---- | ---------------- | ------ | ---------- | ------------- | ------- |
| 17   | Yuki Tsunoda     | 22     | 7          | AlphaTauri    | #2B4562 |
| 19   | Liam Lawson      | 40     | 7          | AlphaTauri    | #2B4562 |
| 21   | Nyck De Vries    | 21     | 7          | AlphaTauri    | #2B4562 |
| 22   | Daniel Ricciardo | 3      | 7          | AlphaTauri    | #2B4562 |

Analogamente, se nella tabella pilota avessimo riportata per ogni scuderia la denominazione anziché l'ID, potremmo effettuare la selezione a partire da lì. Tipicamente nei database reali poche relazioni (tabelle) sono indicizzate attraverso attributi come la denominazione, e si preferisce per questioni di robustezza affidarsi agli ID incrementali autogenerati. Nel caso specifico delle scuderie è impossibile che si presentino due scuderie con lo stesso nome, ma se le relazioni fossero ad esempio una lista di pazienti affidati ad un medico curante sarebbe opportuno identificare il medico tramite ID, visto che possono facilmente presentarsi omonimie.

### Natural join

A differenza delle altre due varianti e degli operatori già visti la natural join si presenta senza condizioni a pedice ed è così definita:

Siano $R$ ed $S$ due relazioni e siano $XY$ ed $YZ$ insiemi di attributi, dove $XY \subset R$ e $YZ \subset S$, con $Y$ contenuto dunque in entrambe le relazioni.
$$
R \Join S = \{ t : t[XY] \in R \and t[YZ] \in S \}
$$
La relazione risultante è quindi insieme di tutte le n-uple che, per lo stesso attributo o serie di attributi $Y$, presentano un valore comune.

La natural join è così derivabile combinando la equi join, la ridenominazione e la proiezione.
$$
R \Join S = \Pi_{XYZ}(R \Join_{Y=Y'} (\sigma_{Y'' \rightarrow Y'}(S) )
$$
Dove $S'$ è la relazione $S$ dopo la ridenomiazione e $Y''$ è un attributo compatibile con $Y$ ma per cui i nomi divergono. $Y'$ è invece oltre che perfettamente compatibile anche omonimo.

In alcuni testi la ridenominazione viene omessa per semplicità o perché gli attributi di interesse presentano già la stessa denominazione e quindi si potrebbe trovare la dicitura
$$
R \Join S = \Pi_{XYZ}(R \Join_{Y=Y'} S' )
$$

#### Esempi di natural join

Riprendiamo le relazioni di $Maternità$ e $Paternità$ gia viste.

| Padre     | Figlio  |
| --------- | ------- |
| Wizard    | Abigal  |
| Demetrius | Maru    |
| Kent      | Sam     |
| Kent      | Vincent |

| Madre    | Figlio  |
| -------- | ------- |
| Caroline | Abigail |
| Robin    | Maru    |
| Jodi     | Sam     |
| Jodi     | Vincent |

Una natural join sulle due relazioni genera una relazione così composta:

| Padre     | Figlio  | Madre    |
| --------- | ------- | -------- |
| Wizard    | Abigail | Coraline |
| Demetrius | Maru    | Robin    |
| Kent      | Sam     | Jodi     |
| Kent      | Vincent | Jodi     |

Che come anticipato parlando dell'unione è forse più semplice da comprendere una volta che si è preso familiarità con questo tipo di concetti.

### Outer join

Per tutte le operazioni di join descritte fino ad ora si può configurare l'eventualità che alcune tuple delle relazioni iniziali non contribuiscano al risultato, venendo quindi omesse dalla nuova relazione. Questo avviene quando i valori presenti nell'attributo o serie di attributi comuni non sono tutti presenti in entrambe le relazioni. Prendiamo ad esempio le relazioni $Paternità$ e $Maternià$ e supponiamo la presenza di una nuova tupla nella relazione $Maternità$

| Madre    | Figlio    |
| -------- | --------- |
| Caroline | Abigail   |
| Robin    | Maru      |
| Jodi     | Sam       |
| Jodi     | Vincent   |
| Robin    | Sebastian |

Sebastian è un personaggio del videogioco Stardew Valley di Eric Barone, meglio noto come ConcernedApe. È figlio di Robin e del suo primo marito, di cui non abbiamo però informazioni. Allo stato attuale, se dovessimo fare una join tra le due tabelle la tupla contenente questo valore verrebbe esclusa perché non abbiamo un corrispettivo padre-figlio nella relazione $Paternità$. La relazione risultante sarebbe quindi identica a quella già vista.

Quella di Sebastian è nota come tupla ***dandling***. Le tuple dandling sono escluse dalla risultato delle join viste fino ad ora proprio per la loro mancanza di valori comuni. Se si vogliono includere anche le tuple dandling nel risultato è necessario ricorrere alle outer join.

Un'outer join (o giunzione esterna), si può presentare in tre varianti, a seconda di quali tuple dandling deve riportare (se provenienti dalla prima relazione, dalla seconda o da entrambe).

- **Left outer join**: preserva le tuple dandling della prima relazione. Chiama per brevità anche solo left join.
- **Right outer join**: preserva le tuple dandling della seconda relazione. Chiama per brevità anche solo right join.
- **Full outer join**: preserva le tuple dandling di entrambe le relazioni. Chiamata per brevità solo outer join.
