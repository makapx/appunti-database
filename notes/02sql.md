# Structured Query Language

[TOC]

Il **SQL** (Structured Query Language) è una standard nato a metà degli anni 70. Ha subito diverse evoluzioni nel corso del tempo, infatti ad oggi lo distinguiamo nelle sue versioni:

- **SQl-86 / SQL-89 (1986/1989)**
- **SQL-2 (1992)**
- **SQL-3 (1999/2003)**

Ufficialmente il SQL nasce nel 1974 nei laboratori IBM con il nome di SEQUEL (da qui la confusione sulla pronuncia), nome che verrà in seguito cambiato a causa dell'omonimia con una nota compagnia aerea.

Si ponge come riferimento il 1986 perché è stato l'anno in cui l'ANSI lo confermò come standard, seguita l'anno seguente dalla ISO.

Sistemi come MySQL e MariaDB sono invece dei DBMS (Database Management System) che offrono, insieme ad altre funzionalità, promp o shortcut da GUI per scrivere query SQL.

Sebbene SQL-3 sia ad oggi uno standard la sua scrittura è andata di pari passo con l'evolversi dei DBMS quindi ad oggi questi possono differire leggermente per quanto riguarda la sintassi delle query.

I costrutti del SQL possono essere catalogati come segue:

- **Data Definition Language (DDL)**: ne fanno parte tutti quei costrutti che permettono di creare o modificare lo schema (la struttura) del database ( es: `CREATE`, `ALTER` )
- **Data Manipulation Language (DML)**: ne fanno parte i costrutti che permettono di inserire, modificare e gestire i dati inseriti (e quindi le istante). ( es: `INSERT` )
- **Data Query Language (DQL)**: comprende i costrutti utilizzati per le interrogazioni, ovvero per ottenere i dati dal database (es: `SELECT`)
- **Data Control Language (DCL)**: comprende i costrutti per la gestione del controllo di accesso ( es: `GRANT` di privilegi ) 

Questa distinzione non è però sempre nettissima.

## Premessa su come leggere il codice SQL

- Il SQL è case insensitive per quanto riguarda i comandi (non per i nomi degli attributi), nonostante questo per convenzione le direttive si scrivono in maiuscolo. Si possono distribuire su più righe e vanno delimitati dal `;`
- I valori tra parentesi quadre [ ] vanno intesi come opzionali
- I valori tra parentesi angolate < > sono obbligatori
- I valori legati da un or bitwise vanno intesi come legati da un or esclusivo (o l'uno o l'altro)
- Lo * indica "tutto"
- La naming convention per le tabelle è variabile a seconda delle preferenze di chi sviluppa. Tipicamente le tabelle seguono il pascal case `NomeTabella` o il camel case `nomeTabella` mentre gli attributi lo snake case `nome_attributo`. Il camel case può essere a volte utilizzato anche per gli attributi.
- Attributi e tabelle possono essere listati secondo una relazione "almeno uno ma anche più di uno" con la sintassi `nomeAttributo1 {, nomeAttributoN }` per indicare la molteplicità.
- Le liste di attributi indicate nelle clausole sono dette **target list**

## `SELECT`

La `SELECT` è uno dei costrutti basilari del linguaggio. Fa parte dei costrutti DQL e ha una semantica molto simile alla proiezione $\Pi$ dell'algebra relazionale.

```sql
SELECT [DISTINCT] <Attributes|*>
FROM TableName
[WHERE Condition]
```

```sql
SELECT phoneNumber
FROM Students
WHERE id = 'X81000123';
```

| phoneNumber |
| ----------- |
| 123456789   |

```sql
SELECT *
FROM Students
WHERE id = 'X81000123';
```

| id        | name  | surname | phoneNumber | departmentId |
| --------- | ----- | ------- | ----------- | ------------ |
| X81000123 | Mario | Rossi   | 123456789   | 3            |

```sql
SELECT *
FROM Students;
```

| id        | name     | surname | phoneNumber | departmentId |
| --------- | -------- | ------- | ----------- | ------------ |
| X81000123 | Mario    | Rossi   | 123456789   | 3            |
| X81000124 | Luca     | Gialli  | NULL        | 3            |
| X81000125 | Stefano  | Verdi   | 987654321   | 3            |
| X81000126 | Michela  | Bianchi | 987654322   | 3            |
| X81000127 | Patrizia | Neri    | 987654421   | 3            |
| X81000128 | Marta    | Bianchi | 987454321   | 3            |
| MD1000888 | Marta    | Rossi   | 987624321   | 1            |
| MD1000889 | Mario    | Rossi   | 987654329   | 1            |
| MD1000890 | Giovanni | Verdi   | 987654328   | 1            |

```sql
SELECT id, name, surname,
FROM Students;
```

| id        | name     | surname |
| --------- | -------- | ------- |
| X81000123 | Mario    | Rossi   |
| X81000124 | Luca     | Gialli  |
| X81000125 | Stefano  | Verdi   |
| X81000126 | Michela  | Bianchi |
| X81000127 | Patrizia | Neri    |
| X81000128 | Marta    | Bianchi |
| MD1000888 | Marta    | Rossi   |
| MD1000889 | Mario    | Rossi   |
| MD1000890 | Giovanni | Verdi   |

Nella `SELECT` possono figurare anche espressioni aritmetiche e venire utilizzati alias.

```sql
SELECT name, ral, (ral / 12)
FROM Employees;
```

| name | ral  | ral / 12 |
| ---- | ---- | -------- |

```sql
SELECT name, ral, (ral / 12) AS paycheck
FROM Employees;
```

| name | ral  | paycheck |
| ---- | ---- | -------- |

```sql
SELECT name, ral, (ral / 12) paycheck
FROM Employees;
```

| name | ral  | paycheck |
| ---- | ---- | -------- |

```sql
SELECT name, ral, (ral / 12) "Paycheck"
FROM Employees;
```

| name | ral  | Paycheck |
| ---- | ---- | -------- |

Quando si utilizza il `DISTINC` nella clausola i risultati duplicati vengono rimossi. Un risultato è duplicato quando gli attributi mostrati coincidono. Due risultati dell'istanza potrebbero non essere identici ma coincidere sugli attributi oggetto della `SELECT`.

```sql
SELECT DISTINCT departmentId
FROM Students;
```

| departmentId |
| ------------ |
| 3            |
| 1            |

## `WHERE`

La clausola `WHERE` può venire utilizzata per apporre delle condizioni alla `SELECT`. La clausola `WHERE` accetta sia semplici uguaglianze, sia comparazioni di tipo maggiore e minore (o maggiore e uguale, minore e uguale), sia comparazioni per mezzo di altri operatori ausiliari, come ad esempio il `LIKE`. Più condizioni possono infine essere legate dagli operatori logici.

| Operatore               | Significa                                 |
| ----------------------- | ----------------------------------------- |
| =                       | Uguale a                                  |
| >                       | Maggiore di                               |
| >=                      | Maggiore o uguale di                      |
| <                       | Minore di                                 |
| <=                      | Minore o uguale di                        |
| <> oppure !=            | Diverso da                                |
| `BETWEEN` ... `AND` ... | Compreso tra due valori                   |
| `[NOT] IN ( *lista* )`  | Compreso tra i valori della lista passata |
| `[NOT] LIKE`            | Operatore di pattern matching di stringhe |
| `IS [NOT] NULL`         | Se è NULL                                 |

```sql
-- Trova lo studente con la matricola X81000123 -- 
SELECT *
FROM Students
WHERE id = 'X81000123';
```

```sql
-- Trova gli studenti la cui matricola inizia per X81 -- 
SELECT *
FROM Students
WHERE id LIKE 'X81%';
```

```sql
-- Trova gli studenti che NON afferiscono al dipartimento di ID 1 --
SELECT *
FROM Students
WHERE departmentId != 1;
```

```sql
-- Trova gli studenti che afferiscono ai dipartimenti compresi da ID 1 ed ID 5 --
SELECT *
FROM Students
WHERE departmentId BETWEEN 1 AND 5;
```

```sql
-- Trova gli studenti che afferiscono ai dipartimenti compresi da ID 1 ed ID 5 --
SELECT *
FROM Students
WHERE departmentId IN (1,2,3,4,5);
```

```sql
-- Trova gli studenti che non hanno ancora fornito un numero di telefono --
SELECT *
FROM Students
WHERE phoneNumber IS NULL;
```

### Note sul pattern matching con `LIKE`

- `_` indicato un singolo carattere
- `%` indica zero o più caratteri

```sql
-- Tutti gli studenti con matricola che ha dopo la prima lettera (qualunque) un 81.
SELECT *
FROM Students
WHERE id LIKE '_81%'
```

```sql
-- Tutti gli studenti con matricola che finisce con il numero 9
SELECT *
FROM Students
WHERE id LIKE '%9'
```

### Operatori logici e precedenza

**A meno di parentesi**, vige il seguente ordine per la priorità

1. Operatori di confronto ($=$, $<>$, etc...)
2. `NOT`
3. `AND`
4. `OR`

## `ORDER BY`

È possibile ordinare le righe risultanti da una query di interrogazione (in maniera crescente `ASC` o decrescente `DESC`) tramite la clausola `ORDER BY`. La clausola necessita di un attributo, che sarà quello che utilizzerà come riferimento per l'ordinamento.

```sql
SELECT *
FROM Students
ORDER BY name;
```

Quando non è specificato, l'ordinamento di default è crescente.

```sql
SELECT *
FROM Students
ORDER BY name DESC;
```

È possibile dare più parametri alla clausola `ORDER BY`. In questo l'ordinamento avviene raggruppando coerentemente gli attributi a partire da quelli più a sinistra.

```sql
-- Ordinamento per numero di dipartimento (crescente) e salario (decrescente) ---
SELECT ename, deptno, sal
FROM Employees
ORDER BY deptno, sal DESC;
```

| ename  | deptno | sal  |
| ------ | ------ | ---- |
| King   | 10     | 5000 |
| Clark  | 10     | 2450 |
| Miller | 10     | 1300 |
| Ford   | 20     | 3000 |

In questo caso ottengo gli impiegati ordinati per dipartimento ma, per ogni dipartimento, mi vengono restituiti prima quelli con il salario maggiore.

Una clausola `WHERE` può essere o meno accompagnata da una `ORDER BY` e viceversa. Nel caso siano presenti entrambi, la sintassi è la seguente:

```sql
SELECT <Attributes|*>
FROM Tables
WHERE Condition 		-- Prima questa --
ORDER BY attributeName; -- Dopo questa --
```

Gli attributi della `ORDER BY` devono necessariamente essere presenti nella `SELECT`, tipicamente viene inseriti per ultimi.

## `GROUP BY`

È possibile effettuare ulteriori raggruppamenti utilizzando la clausola `GROUP BY`. La sintassi è la seguente:

```sql
SELECT column, group_function(column)
FROM table
[WHERE condition]
[GROUP BY group_by_expression] -- Prima di ORDER BY --
[ORDER BY column];
```

Se nella `SELECT` c'è un riferimento diretto agli attributi, questi devono essere presenti nella `GROUP BY`, tuttavia se non figurano relazioni dirette, come accade ad esempio quando si usano gli operatori aggregati, in questo caso gli attributi utilizzati nella `GROUP BY` possono anche non essere presenti nella `SELECT`

```sql
-- Salario medio per ogni dipartimento --
SELECT deptno, AVG(sal)
FROM Employees
GROUP BY deptno;
```

```sql
-- Salario medio per ogni dipartimento, ma in questo caso non si ha evidenda del dipartimento --
SELECT AVG(sal)
FROM Employees
GROUP BY deptno;
```

Sebbene non sia necessario a volte introdurre l'attributo sulla base del quale si sta raggruppando può arricchire la semantica del risultato.

Come per la `ORDER BY`, anche questa clausola supporta l'ordinamento multiplo secondo logica posizionale.

## `HAVING`

Per concludere, è possibile filtrare i risultati ottenuti dal raggruppamento fatto con `GROUP BY`  attraverso la clausola `HAVING`. Solitamente `HAVING` è utilizzato con gli operatori aggregati, che sono specificati sia nella `SELECT` che in suddetta clausola.

```sql
SELECT deptno, max(sal)
FROM Employees
GROUP BY deptno
HAVING max(sal)>2900;
```

L'ordine è quindi:

```sql
SELECT column, group_function(column)
FROM table
[WHERE condition]
[GROUP BY group_by_expression]
[HAVING group_condition]
[ORDER BY column];
```

## Operatori aggregati

Gli operatori aggregati sono dei costrutti che operano su insiemi di righe per generare un risultato inerente ad ai valori della relazione. Fanno ancora parte dei costrutti DQL in quanto non modificano in via persistente i dati ma effettuano e riportano un calcolo.

- `AVG` media
- `COUNT` counter
- `MAX` massimo
- `MIN` minimo
- `SUM` somma

Come già visto, possono essere utilizzati sia nella clausola `SELECT` che nella `HAVING`.

```sql
SELECT AVG(sal), MAX(sal),
MIN(sal), SUM(sal)
FROM Employees
WHERE job LIKE 'SALES%';
```

Gli operatori di aggregazione come `MIN`, `MAX` e `AVG` possono essere utilizzati su più tipi e non solo sui numerici, funzionano ad esempio con le date.

Altri operatori come il `COUNT` invece lavorano sul numero di risultati e non sull'informazione trasportata. 

```sql
-- Il numero degli studenti la cui matricola inizia per X81 --
SELECT COUNT(*)
FROM Students
WHERE id LIKE 'X81%';
```

L'operatore `COUNT` può essere applicato sia a generico numero di righe (tuple) che al singolo attributo.

```sql
-- Conteggio delle matricole --
SELECT COUNT(ID) FROM Students;
```

```sql
-- Conteggio con DISTINCT (omonimi esclusi) --
SELECT COUNT(DISTINCT name) FROM Students;
```

Il `COUNT` esclude i valori di tipo `NULL` da proprio conteggio  (se il conteggio è basato sul singolo valore o se tutta la riga è posta a `NULL`).

Se agli operatori aggregati `MAX`, `MIN`, `AVG` e `SUM` vengono sottoposti solo valori nulli, torneranno a loro volta `NULL`, tuttavia se sono presenti solo alcuni valori nulli (non tutti) li ignoreranno durante il calcolo. Questo comportamento potrebbe non sempre essere desiderato e va eventualmente gestito di conseguenza.

Di default gli operatori aggregati funzionano con un'implicita clausola `ALL`, atta a conteggiare tutti i valori differenti da `NULL` (anche se duplicati).

Visto che gli operatori aggregati lavorano su gruppi di tuble e producono un singolo valore numerico, **non è possibile concatenarli tra loro**.

## `JOIN`

È possibile mettere in relazione più tabelle attraverso i loro attributi (o meglio i valori di suddetti attributi) utilizzando il costrutto `JOIN`.
Similmente all'algebra relazionale, una `JOIN` è un sottoinsieme del prodotto cartesiano dove a venire selezionati sono gli attributi comuni alle due entità (tabelle) oggetto dell'operazione.

Ovviamente la `JOIN` non è l'unico modo per mettere in relazione due o più tabelle, un esempio implicito di `JOIN` infatti lo si ha già quando si fanno query del tipo:

```sql
SELECT paternity.child, father, mother
FROM maternity, paternity
WHERE paternity.child = maternity.child;
```

Ciò nonostante la `JOIN` resta il costrutto più potente e più adatto a questo tipo di operazioni.

La stessa query formulata con il costrutto JOIN si presenta così:

```sql
SELECT paternity.child, father, mother
FROM maternity JOIN paternity ON paternity.child = maternity.child;
```

Come avviene in algebra relazionale, una `JOIN` di una tabella con sè stessa ha bisogno di essera accompagnata da ridenominazione.

```sql
-- Le info dei padri accompagnate a quelle dei figli --
SELECT ...
FROM persons p1 JOIN paternity ON
p1.name = paternity.father JOIN persons p2 ON
paternity.child = p2.name = p2.child;
```

Questo tipo di `JOIN` viene spesso definita *self join*.

### `LEFT`, `RIGHT` e `FULL JOIN`

Quando si effettua un'operazione di JOIN i valori NULL vengono esclusi dal risultato, quindi non comparirà mai una tupla del tipo:

| father | mother | child     |
| ------ | ------ | --------- |
| NULL   | Robin  | Sebastian |

L'esclusione di queste tuple dal risultato non sempre è desiderabile. Per ovviare a questo problema utilizziamo i costrutti:

- `LEFT JOIN`
- `RIGHT JOIN`
- `FULL JOIN`

Che includono nel risultato i valori NULL rispettivamente per le relazioni a sinistra (primo operando), a destra (secondo operando) e per entrambe.

```sql
-- Se noto, verrà mostrato il padre, altrimenti NULL --
SELECT father, mother, child
FROM paternity LEFT JOIN maternity
ON paternity.child = maternity.child
```

```sql
-- Anche se nessuno dei due genitori è noto --
SELECT father, mother, child
FROM paternity FULL JOIN maternity
ON paternity.child = maternity.child
```

Questo tipo di JOIN viene comunemente detto *outer join* o *join esterno*.

### Atri esempi di `JOIN`

Altri esempi di JOIN sono ad esempio:

- `NATURAL JOIN` (simile all'algebra relazionale)
- `JOIN` ... `USING` (su un subset di attributi comuni)

```sql
-- Utilizziamo gli attributi con lo stesso nome --
SELECT students.name, exams.course, exams.grade
FROM exams NATURAL JOIN students;
```

È possibile utilizzare la `NATURAL JOIN` in combinazione con i costrutti `LEFT`, `RIGHT` e `FULL` per generare una *natural outer join*, ovvero una join sugli attributi che hanno lo stesso nome (senza condizione esplicita) dove vengono mantenuti i valori `NULL` (da una sola o da entrambe le parti a seconda del costrutto di accompagnamento).

La `JOIN` ... `USING` può essere vista come una **sintassi particolare della natural join**, dove al posto della clausola `ON` viene utilizzata la clausola `USING` indicando tra parentesi gli attributi comuni alle entità.

```sql
-- Esempio di JOIN con USING --
SELECT e.EMPLOYEE_ID, e.LAST_NAME, d.LOCATION_ID
FROM Employees e JOIN Departments d
USING(DEPARTMENT_ID);
```

## `UNION`, `INTERSECT`, `EXCEPT`

È possibile unire i risultati di più query attraverso il costrutto `UNION`. Due relazioni legate da una `UNION` **necessitano di domini compatibili** affinchè l'operazione vada a buon fine. Inoltre la UNION non ha modo di verificare la coerenza semantica del risultato, quindi deve essere accortezza dello sviluppatore sottoporre attributi ordinati e ridenominare le colonne del risultato in maniera coerente.

```sql
SELECT father as parent, child
FROM paternity
UNION
SELECT mother as parent, child
FROM maternity
```

In questo caso se gli attributi `parent` e `child` di una delle due query fossero invertiti di posto si avrebbe un'icoerenza nel risultato, visto che la `UNION` accoda semplicemente i valori.

Si comportano analogamente anche i costrutti `INTERSECT` ed `EXCEPT` che effettuano rispettivamente l'intersezione e la divisione.

```sql
SELECT NAME, AGE, HOBBY FROM STUDENTS_HOBBY
INTERSECT 
SELECT NAME, AGE, HOBBY FROM STUDENTS;
```

```sql
SELECT NAME, AGE, HOBBY FROM STUDENTS_HOBBY
WHERE AGE BETWEEN 25 AND 30
INTERSECT
SELECT NAME, AGE, HOBBY FROM STUDENTS
WHERE AGE BETWEEN 20 AND 30;
```

```sql
SELECT NAME, AGE, HOBBY FROM STUDENTS_HOBBY
WHERE HOBBY IN('Cricket')
INTERSECT
SELECT NAME, AGE, HOBBY FROM STUDENTS
WHERE HOBBY IN('Cricket');
```

```sql
SELECT NAME, HOBBY, AGE FROM STUDENTS
EXCEPT 	
SELECT NAME, HOBBY, AGE FROM STUDENTS_HOBBY;
```

```sql
SELECT NAME, HOBBY, AGE
FROM STUDENTS
WHERE AGE BETWEEN 20 AND 30
EXCEPT 
SELECT NAME, HOBBY, AGE 
FROM STUDENTS_HOBBY
WHERE AGE BETWEEN 20 AND 30
```

## Query nidificate

È possibile sottoporre alla clausola WHERE, oltre ai predicati e alle espressioni semplici, anche altre query. Solitamente in questi casi vengono utilizzati costrutti come:

- `[NOT] EXISTS`
- `[NOT] IN`

```sql
-- Le informazioni di tutti gli impiegati londinesi --
SELECT firstName, surname
FROM Emplotee
WHERE Dept IN (
	SELECT deptName
	FROM Department
	WHERE city = 'London'
);
```

È inoltre possibile utilizzare operatori di confronto ( $=$, $<$, $\le$ etc... )  accompagnandoli alle keyword `ANY` e `ALL`.

Le regole di valutazione dei predicati sono le seguenti:

- `ANY`: vero se **almeno uno** dei valori restituiti dalla sottoquery soddisfra l'operatore che vi si è anteposto
- `ALL`: vero se **tutti** i valori restituiti dalla sottoquery soddisfano la relazione dell'operatore anteposto

```sql
-- I dipartimenti situati nella zona centrale di Londra, se ne esistono --
SELECT deptName
FROM Department
WHERE city = ANY (
	SELECT cityName
	FROM City
	WHERE postalCode LIKE 'E';
);
```

```sql
-- I dipartimenti che non hanno affiliati che si chiamano "Brown" -- 
SELECT deptName
FROM Department
WHERE deptName <> ALL (
	SELECT dept
	FROM Employee
	WHERE surname = 'Brown'
);
```

Gli operatori visti fino ad ora sono intercambiali come segue:

- `IN` corrisponde ad = `ANY`
- `NOT IN` corrisponde a `<>ALL`

Solitamente le forme `IN` e `NOT IN` sono più utilizzate dei loro corrispettivi.

Altri operatori utilizzabili sono quelli già visti, come ad esempio,  `[NOT] EXIST`.

### Operatori aggregati e query nidificate

È possibile utilizzare gli operatori aggregati nelle query nidificate. Ovviamente gli operatori devono fornire risultati confrontabili tra di loro e lo scope delle variabili segue le linee guida di quello dei classici linguaggi di programmazione.

```sql
-- L'impiegato che ha lo stipendio più alto --
SELECT name, surname
FROM Employee
WHERE salary IN (
	SELECT MAX(salary)
	FROM Employee
);
```

```sql
--  Dipartimenti che hanno la somma dei salari più alti, rispetto alla media -- 
SELECT name, surname, dept
FROM Employee
GROUP BY dept
HAVING SUM(salary) > (
    SELECT AVG(totalByDept.salaryTot)
    FROM (
        -- Totale dei salari, per dipartimento --
        SELECT SUM(salary) AS 'salaryTot'
    	FROM Employee
    	GROUP BY dept
    ) AS totalByDept
)
```

## Comandi DDL: creare ed eliminare database e tabelle

Mentre i comandi descritti fino ad ora rappresentano una buona parte dei comandi catalogati come **DQL (Data Query Language)** quelli a seguire sono comandi cosiddetti **DDL (Data Definition Language)**, ovvero istruzioni che consentono di **modificare lo schema** della base di dati (e non, come i precedenti, le istanze).

### CREATE

La keyword `CREATE`, accompagnata da altre come `SCHEMA` (o `DATABASE`) o `TABLE` consente di creare nuovi database, tabelle, viste ed altre entità.

Al momento della creazione è buona pratica specificare quali utenti e con che permessi possono accedere al database o alla singola tabella.

```sql
CREATE <(SCHEMA|DATABASE)> <dbName> AUTHORIZATION <username>;
```

```sql
CREATE TABLE <tableName> (
	<attributeName> <attributeType> [{constrains, }]
	{,<attributeName> <attributeType> [{constrains, }] }
	[, {tableCostrains, } ]
)
```

```sql
CREATE TABLE Employee(
    id CHAR(6) PRIMARY KEY,
    name CHAR(20) NOT NULL,
    surname CHAR(20) NOT NULL,
    dept CHAR(15),
    salary NUMERIC(9) DEFAULT 0,
    FOREIGN KEY(dept) REFERENCES Department(depName)
);
```

### DROP

Schemi e tabelle possono essere a loro volta eliminati utilizzando la keyword `DROP`.

```sql
DROP SCHEMA dbName [RESTRICT | CASCADE]
```

```sql
DROP TABLE tableName [RESTRICT | CASCADE]
```

Dove `RESTRICT` e `CASCADE` sono i comportamenti da seguire nel caso in cui l'entità eliminata sia in relazione con altre entità (ad esempio se gli attributi della tabella eliminata sono `FOREIGN KEY` per un'altra). 

`RESTRICT` evita il propagarsi della `DROP`, mentre `CASCADE` propaga l'eliminazione. 

Un database eliminato con clausola `RESTRICT` verrà effettivamente cancellato solo se vuoto, idem per una tabella.  Quando una tabella viene eliminata con `CASCADE` vengono eliminate anche le varie reference.

Ovviamente l'eliminazione con `RESTRICT` risulta più cauta, anche se non sempre è applicabile o desiderata.

### Creazione di domini

SQL offre dei domini, anche detti tipi, predefiniti. I domini vengono indicati in fase di creazione e modifica degli attributi. Ovviamente un dominio va scelto con accortezza e i dati sottoposti dovranno essere compatibili con il dominio scelto (di solito pena il fallimento della query).

Tra i domini predefiniti troviamo:

-  `CHAR(n)` stringhe di lunghezza fissa n
- `VARCHAR(n)` stringhe di lunghezza variabile che possono avere al più n caratteri (tipicamente non più di 256)
- `INTEGER` interi
- `REAL` reali
- `NUMERIC (p,s)` p cifre di cui s decimali
- `FLOAT(p)`, dove p rappresenta la precisione
- `DATE` 
- `TIME`

Partendo dai domini predefiniti è possibile crearne uno custom.

```sql
CREATE DOMAIN GRADE
AS SMALLINT DEFAULT NULL
CHECK ( value >= 18 AND value <= 30 )
```

## Vincoli di integrità

È possibile formulare dei requisiti per singole tabelle o per gruppi di tabelle e definire il comportamento da mettere in atto nel caso le operazioni fatte rappresentino una violazione di questi ultimi.

Distinguiamo i vincoli in:

- **intrarelazionali** (definiti sulla stessa tabella/relazione)
- **referenziali** o interrelazionali (definiti su più relazioni/tabelle)

I vincoli di integrità vengono verificati ogni qual volta si fa un'operazione di tipo DML, come ad esempio `INSERT`, `DELETE` ed `UPDATE`. Quando una di queste operazioni immette (o rimuove) dati che portano alla violazione dei vincoli, le conseguenze possibili sono due:

- la transazione fallisce
- la transazione viene permessa ma accompagnata con delle azioni correttive

### Vincoli intrarelazioni

I vincoli intrarelazionali sono:

- `NOT NULL`
- `UNIQUE`
- `PRIMARY KEY`
- `CHECK` condizione

### Vincoli interrelazionali

Permettono di definire vincoli di **integrità referenziale**, ovvero di coerenza tra i riferimenti su più tabelle.

- `FOREIGN KEY`
- `REFERENCES`
- `CHECK` condizione

Le prime due vengono utilizzate insieme per indicare quale attributo della tabella corrente faccia riferimento ad una chiave primaria di un'altra relazione.

```sql
CREATE TABLE Employee (
	id CHAR(20) NOT NULL PRIMARY KEY,
	name CHAR(30) NOT NULL,
	surname CHAR (30) NOT NULL,
	dept CHAR(20),
	FOREIGN KEY (dept) REFERENCES Department(id)
);
```

### Propagare i cambiamenti

Quando si definiscono le chiavi esterne ed i relativi vincoli interrelazionali è inoltre possibile (e buona pratica) definire il tipo di azione da effettuare in caso di eliminazione dei record. Le azioni possibili sono:

- `ON DELETE NO ACTION` (conseguente abort dell'operazione)
- `ON DELETE CASCADE` (propagazione dei cambiamenti ai valori correlati)
- `ON DELETE SET NULL` (assegna il valore `NULL`)

Se decidessimo ad esempio di cancellare la tabella dei dipartimenti, a seconda della modalità scelta avremmo risultati differenti.

La cancellazione di un dipartimento che ha ancora impiegati ad esso collegati con una `NO ACTION` porterebbe al fallimento dell'operazione, utilizzando `CASCADE` anche gli impiegati verrebbero eliminati e con `SET NULL` il loro dipartimento verrebbe messo a `NULL` (ammesso che sia un valore permetto dalla definizione stessa della tabella)

## Comandi DML: INSERT, DELETE, UPDATE

I comandi `INSERT`, `DELETE` e `UPDATE` vengono utilizzati per inserire, eliminare o modificare i record delle tabelle. Ovviamente per `INSERT` E `UPDATE` il DBMS verifica che gli eventuali vincoli associati alle tabelle siano rispettati, altrimenti le operazioni non vanno a buon fine.

```sql
-- Registro un nuovo esame --
INSERT INTO Exams VALUES ('database', 'X81000123', 24);
```

```sql
-- Elimino gli esami dello studente --
DELETE FROM Exams WHERE id = 'X81000123';
```

```sql
-- Aggiorno l'aulario --
UPDATE Classrooms SET classroomNumber = 126 WHERE classroomNumber = 3;
```

## Viste

Le viste sono delle tabelle ausiliarie, anche dette "virtuali", che vengono create a partire da un'istanza di database. Una vista può essere una semplice copia di una tabella esistente oppure un'aggregazione di attributi provenienti da JOIN o altre operazioni.

Spesso le viste vengono esposte agli applicativi per proteggere lo schema sottostante, offrire query complesse ma ricorrenti in modo semplice, riorganizzare i dati esposti agli applicativi senza stravolgere lo schema sottostante ed altro ancora.

```sql
CREATE VIEW gradeAvg (id, average) AS
	SELETE studentId, AVG (grade)
	FROM Exams
	GROUP BY studentId;
```

Una volta creata, la vista può essere utilizzata come una qualsiasi tabella.

```sql
SELECT * FROM gradeAvg;
```

Come tali, le viste possono essere soggette a `DROP` ed `ALTER`, inoltre **a partire da una view è possibile crearne un'altra**.

Operazioni quali `INSERT`, `DELETE` o `UPDATE` sono invece soggette a limitazioni nelle nuove basi di dati e le più vecchie nemmeno le permettevano.

Essendo la vista una tabella derivata inserire o eliminare la discosta dalla tabella originale e i dati contenuti nella vista non è detto che abbiano senso per la tabella originale (o le tabelle, se derivata da più tabelle).

È possibile restringere il tipo di dati inseribili nella view attraverso comando `WITH CHECK OPTION` in fase di creazione della stessa.

Non esiste un modo standard per gestire l'aggiornamento delle viste e la sincronizzazione con le tabelle da cui si originano, di solito però:

- è possibile effettuare inserimenti su viste derivate da singole tabelle
- non è possibile farlo su viste derivate da più tabelle (eccetto rari casi e la cui gestione è lasciata allo specifico DBMS e alle regole personalizzate definite dall'amministratore)
- non è possibile farlo su viste che usano funzioni di aggregazione (in quanto esse sono calcolate sui record della tabella originale)

## Asserzioni

È possibile creare dei vincoli ed applicarli alle tabelle utilizzando la keyword `ASSERTION`. Un asserzione è a tutti gli effetti un vincolo di integrità ma definito sull'intera tabella e non sui singoli record.

```sql
-- Verifica che il numero massimo di crediti per esame sia 12 --
CREATE ASSERTION maxCreditForExam
CHECK ( NOT EXISTS ( SELECT * FROM Exams WHERE credit > 12));
```

## Viste ricorsive

Per ottenere la chiusura transitiva di una relazione, ed in generale per qualsiasi operazione che "risalga" i riferimenti di una o più relazioni, c'è bisogno di utilizzare la ricorsione. Le viste ricorsive vengono introdotte nel 99.

```sql
WITH RECURSIVE factorial (n, fact) AS
(
    SELECT 0, 1
    UNION ALL
    SELECT n+1, (n+1)*fact
    FROM factorial
    WHERE n < 9
)
SELECT * FROM factorial;
```

```sql
WITH RECURSIVE tens(n) AS 
(
    SELECT 1 as n
 	UNION ALL
   	SELECT n+1 FROM tens
)
SELECT * FROM tens LIMIT 10;
```

## Controllo di accesso

Nei database è possibile gestire capillarmente quali utenti hanno accesso a quali risorse e con che **privilegi**.

I privilegi vengono concessi o revocati attraverso i comandi `GRANT` e `REVOKE`

In fase di concessione vanno specificati i privilegi, le risorse a cui si applicano, l'utente che deve ottenerli e se questo può o meno avere capacità di trasmettere e/o revocare privilegi ad altri.

```sql
-- Sintassi del comando di GRANT --
GRANT <Privileges | ALL PRIVILEGES>
ON Resource
TO Users [WITH GRANT OPTION];
```

```sql
-- Sintassi del comando di REVOKE --
REVOKE Privileges
ON Resource
FROM Users [RESTRICT | CASCADE];
```

Il comportamento di `RESTRICT` e `CASCADE` è analogo all'utilizzo che se ne fa nel `DELETE`.

Con l'opzione `CASCADE` gli utenti che hanno ricevuto privilegi di `GRANT` dall'utente soggetto a revoca verranno privati a loro volta dei privilegi  l'opzione, il contrario invece avviene con `RESTRICT`.

I privilegi specificabili sono:

- `INSERT` 
- `UPDATE`
- `DELETE`
- `SELECT`
- `REFERENCES`: creazioni di chiavi esterne/vincoli di integrità referenziale
- `USAGE`: permesso di utilizzo di una definizione

Per questioni di sicurezza viene introdotto un certo livello di *obfuscation*. La risorsa a cui l'utente non ha accesso viene presentata dalla base di dati come inesistente, quindi azioni non permesse produrranno messaggi di errore uguali ad tentativi su risorse che non esistono.

### Note sull'utente amministratore

Le slide del corso citano un utente `_system` che detiene tutti i privilegi. Non sempre l'utente è così denominato e non sempre questo tipo di utente è utilizzabile. La più recenti versioni di MariaDB ad esempio prevedono un utente `root` privo di password a cui però è possibile accedere solo tramite socket UNIX e lanciando la CLI come *sudoers*, è quindi buona pratica creare un secondo utente amministratore e utilizzare la CLI e gli applicativi loggandosi con quest'ultimo. Per questioni di sicurezza, nel caso si amministrino più database, è inoltre consigliato creare utenti amministratori differenti con permessi specifici sulle singole basi di dati.

## Transazioni

Le transazioni sono insiemi di operazioni che godono delle cosiddette proprietà **ACID**.

- **Atomicità**: rappresentano insiemi di operazioni tra loro inscindibili, che non possono essere eseguite in maniera parziale e la cui interruzione porta immediatamente all'abort di tutta la transazione ed al conseguente rollback. 
- **Consistenza**: sebbene le transazioni possano, nel corso delle loro operazioni intermedie, violare qualche vincolo di integrità della base di dati, a conclusione (**commit**) della transazione la base di dati viene lasciata in uno stato consistente, ovvero con tutti i propri vincoli di integrità soddisfatti.
- **Isolamento**: le transazioni possono essere concorrenti e devono produrre lo stesso risultato, indipendentemente dall'ordine. Il comportamento di transazioni concorrenti deve essere identico a quello che si avrebbe nel caso fossero eseguite sequenzialmente.
- **Durabilità**: una volta terminata (**commit**) le modifiche apportate dalla transazione rimangono memorizzate all'interno della base di dati.

Le transazioni sono delimitate da un comando `START TRANSACTION`, o simili, e si concludono con un comando di `COMMIT` o di `ROLLBACK`. Non sempre il comando di inizio è presente e a volte la sintassi differisce da quella riportata.

Attualmente la documentazione SQL Server 2022 riporta la seguente sintassi per le transazioni:

```sql
BEGIN { TRAN | TRANSACTION }   
    [ { transaction_name | @tran_name_variable }  
      [ WITH MARK [ 'description' ] ]  
    ]  
[ ; ]
```

```sql
COMMIT [ { TRAN | TRANSACTION }  [ transaction_name | @tran_name_variable ] ] [ WITH ( DELAYED_DURABILITY = { OFF | ON } ) ]  
[ ; ]  
```

```sql
COMMIT [ WORK ]  
[ ; ]  
```

`COMMIT WORK` e `COMMIT TRANSACTION` funzionano in maniera analoga, ad eccezione del fatto che `COMMIT TRANSACTION` accetta un nome di transazione definito dall'utente. La sintassi di `COMMIT`, con o senza la parola chiave facoltativa `WORK`, è compatibile con SQL-92.

Vale lo stesso per l'istruzione `ROLLBACK`.

```sql
ROLLBACK { TRAN | TRANSACTION }   
     [ transaction_name | @tran_name_variable  
     | savepoint_name | @savepoint_variable ]   
[ ; ]  
```

```sql
ROLLBACK [ WORK ]  
[ ; ]  
```

Ovviamente una transazione che fallisce, seppur non abbia `ROLLBACK` definiti al suo interno, va in **auto-rollback**, ovvero la base di dati viene riportata allo stato precedente all'avvio della transazione.

Alcuni esempi di transazioni:

```sql
DELETE FROM CUSTOMERS WHERE AGE = 25;
COMMIT;
```

```sql
DELETE FROM CUSTOMERS WHERE AGE = 25;
ROLLBACK;
```

Per ulteriori info vedere la [documentazione](https://learn.microsoft.com/it-it/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver16).

## Trigger

I trigger rappresentano un concetto derivato dal paradigma di programmazione ad eventi e consentono di eseguire porzioni di codice al verificarsi di determinati eventi.

Il supporto ai trigger da parte delle basi di dati le rende "attive", ovvero capaci di reagire dinamicamente al verificarsi degli eventi.

Sintassi dei trigger:

```sql
CREATE TRIGGER TriggerName
{ BEFORE | AFTER }
{ INSERT | DELETE | UPDATE [OF Column] } ON
Table
[REFERENCING
{[old_table [AS] OldTableAlias]
[new_table [AS] NewTableAlias] } |
{[old [ROW] [AS] OldTupleName]
[new [ROW] [AS] NewTupleName] }]
[FOR EACH { ROW | statement }]
[WHEN Condition]
SQLStatements
```

Il **ciclo di vita di un trigger** si compone di **tre fasi** principali:

- **Attivazione**: accade l'evento a cui il trigger è legato (insert, delete, update etc...) e che lo "risveglia". Si dice che l'evento attiva il trigger.
- **Considerazione** (o valutazione): si valutano eventuali condizioni legate all'esecuzione del trigger. Si dice che il trigger viene considerato.
- **Esecuzione**: l'azione che lo ha attivato viene eseguita e così anche il trigger stesso.

Alla parte di valutazione ed esecuzione sono legato anche il timing del trigger, rappresentato dalle clausole `BEFORE` e `AFTER`. 

### Statement-level e row-level

I trigger possono funzionare secondo due **granularità** differenti:

- **statement-level**: indicato dalla clausola `FOR EACH STATEMENT`, le operazioni esplicitate nel trigger vengono eseguire una singola volta per tutto il gruppo di tuple risultanti quando questo viene attivato. Un trigger statement level legato ad una `INSERT` ad esempio verra triggerato una volta sola per ogni comando `INSERT`,  sia che si stia inserendo un solo record, sia che se ne stiano inserendo decine nello stesso comando. Per molte basi di dati questa è la granularità di default dei trigger.

- **row-level**: indicato dalla clausola `FOR EACH ROW`. È il tipo di trigger più semplice da scrivere e viene valutato e (ove ne siano soddisfatte le condizioni) eseguito per ogni tupla interessata (e quindi non più per l'intero statement come avviene nell'altro caso)

A seconda della granularità utilizzata si hanno differenti **valori di transizione**. Un valore di transizione è una sorta di keyword per riferirsi allo stato precedente (o successivo) rispetto all'esecuzione del trigger (in questo caso precedente e successivo sono legati al se il trigger è `BEFORE` o `AFTER`).

- `old` e `new`: sono **variabili di transizione**. Utilizzati nei trigger row-level, rappresentano lo stato precedente e successivo della singola tupla che si sta prendendo in esame

- `old_table` e `new_table`: utilizzati nei trigger di tipo statement-level. In questo caso ci riferiamo a vere e proprie copie di tabella, anche dette **tabelle di transizione**

Sia `old` che `old_table` non esistono nel caso delle operazioni di `INSERT`, `new` e `new_table` invece non esistono nel caso della `DELETE`.

Alcuni trigger di esempio:

```sql
-- Ogni volta che viene fatto un update sulla tabella, registra gli aumenti di tutti - row-level --
CREATE TRIGGER AccountMonitor
AFTER UPDATE ON Account
FOR EACH ROW
WHEN new.total > old.total
	INSERT INTO Payments
	VALUES (new.accNumber, new.total-old.total);
```

```sql
-- Dopo una delete, copia il contenuto della tabella messaggi nella tabella dei messaggi eliminati - statement-level --
CREATE TRIGGER FileDeletedInvoices
AFTER DELETE ON Invoice
REFERENCING old_table as OldInvoiceSet
	INSERT INTO DeletedInvoices
	(SELECT * FROM OldInvoiceSET);
```

### Trigger execution context

In maniera del tutto analoga a come avviene per i processi, i trigger possiedono un proprio **contesto di esecuzione** (trigger execution context o **TEC** ) e possono a loro volta innescare altri trigger. Il TEC contiene lo stato del trigger e sempre come avviene per i processi questo può venire salvato nel momento in cui viene innescato un altro trigger e venire ripristinato quando questo termina.

Quando un trigger termina in maniera corretta si dice che il suo stato è **quiescente**. Un trigger può anche non terminare, per un errore di progettazione del singolo codice o perché ha innescato una ricorsione di altri trigger troppo in profondità (una sorta di segmentation fault). Quando un trigger generare un simile errore, viene eseguito un **rollback parziale** dello stesso.

### Trigger in DB2

Un esempio di trigger per DB2:

```sql
CREATE TRIGGER CheckDecrement
AFTER UPDATE OF Salary ON Employee
FOR EACH ROW
WHEN (NEW.Salary < OLD.Salary * 0.97)
BEGIN 
	UPDATE Employee
	SET Salary = OLD.Salary*0.97
	WHERE RegNum = NEW.RegNum;
END;
```

Differenze sostanziali con la sintassi precedente:

- è specificato il campo su cui eseguire il controllo con`UPDATE OF [...] ON`
- sintassi dei comandi di `old` e `new` in maiuscolo
- gestito tramite transazione

#### Sistema di priorità in DB2

Quando più trigger sono associati ad uno stesso evento vengono eseguiti secondo il seguente ordine:

1. `BEFORE` statement-level 
2. `BEFORE` row-level 
3. Azione di modifica e controllo dei vincoli di integrità
4. `AFTER` row-level 
5. `AFTER` statement-level

Se sono definiti più trigger dello stesso tipo viene eseguito prima il trigger con il timestamp di creazione più vecchio.

### Trigger in Oracle

```sql
CREATE TRIGGER TriggerName
{ BEFORE | AFTER } event [, event [,event] ]
[
    [ REFERENCING
    	[ old [ROW] [AS] OldTupleName ]
  		[ new [ROW] [AS] NewTupleName ]
	]
    FOR EACH { ROW | STATEMENT } [WHEN Condition]
]
PL/SQLStatement

-- Dove event può essere --
-- event ::= { INSERT | DELETE | UPDATE [OF Column]} ON Table --
```

Differenze principali:

- supporto agli eventi multipli
- non sono presenti tabelle di transizione
- i trigger `BEFORE` supportano gli `UPDATE`
- la condizione è presente solo per i trigger row-level
- l'azione è costituita da codice [PL/SQL](https://en.wikipedia.org/wiki/PL/SQL)

#### Sistema di priorità in Oracle

I sistema di priorità per i trigger Oracle associati allo stesso evento è il seguente:

1. `BEFORE` statement-level
2. `BEFORE` row-level
3. Azione di modifica e verifica dei vincoli di integrità
4. `AFTER` row-level
5. `AFTER` statement-level

Anche qui se ci sono trigger dello stesso tipo vengono eseguiti prima quelli creati in precedenza

Oracle gestisce inoltre gli errori di dipendenze circolari, dette **mutating table exception**. Se il trigger $T$ di tipo **BEFORE** innesca una serie di altri trigger che vogliano andare a scrivere sulla tabella target dello stesso, un errore viene sollevato.

### Proprietà formali dei trigger

È possibile descrivere i trigger in maniera simile alle macchine a stati finiti.

Le proprietà fondamentali sono:

- **terminazione**: indipendentemente dallo stato iniziale o dalla transazione che si deve compiere, il trigger produrrà uno stato quiescente, ovvero terminerà correttamente. La terminazione è la proprietà più importante.
- **confluenza**: esiste un unico stato finale. Il trigger terminerà la sua esecuzione con quello stato, indipendentemente dall'ordine di esecuzione di altri trigger (in altre parole, lo stato finale non dipende dall'operato di altri trigger)
- **univoca osservabilità**: i trigger devono funzionare come una scatola nera. Indipendentemente dall'ordine di esecuzione, devono emettere all'esterno sempre lo stesso risultato (per stati e valori di partenza identici)

#### Analisi della terminazione

La terminazione di una catena di trigger può essere analizzata studiandone il grafo che rappresenta i suoi percorsi, detto anche **grafo di triggering**.

Come ogni grafo: 

- definiamo nodi (trigger) e archi (eventi che scatenano il cambio di contesto)
- se il grafo è aciclico la proprietà di terminazione è banalmente garantita
- se il grafo non è aciclico può (ma non è detto) presentarsi un problema di terminazione e bisogna analizzare le condizioni del ciclo nel dettaglio (le condizioni degli archi all'indietro).

Supponiamo di avere due trigger:

```sql
-- Pone le tasse allo 0.8 del salario, ogni qual volta l'impiegato riceve un aumento --
T1:
	CREATE TRIGGER AdjustContributions
	AFTER UPDATE OF Salary ON Employee
	REFERENCING new_table AS NewEmp
 	UPDATE Employee
    SET Contribution = Salary * 0.8
    WHERE RegNum IN
    ( SELECT RegNum FROM NewEmp);
```

```sql
-- Decrementa il salario se tutti hanno un salario (lordo) superiore a 50.000 --
T2:
	CREATE TRIGGER CheckBudgetThreshold
    AFTER UPDATE ON Employee
    REFERENCING new_table AS NewEmp1
    WHEN 50000 < ALL (
    	SELECT (Salary+Contribution)
 		FROM NewEmp1
 	)
    	UPDATE Employee
 		SET Salary = 0.9 * Salary;
```

<img src="./img/trigger-cycle.drawio.svg" alt="Trigger cycle" style="zoom: 200%;" />

Ad ogni `UPDATE` sulla tabella `Employee` entrambi i trigger vengono attivati. Entrambi generano a loro volta un `UPDATE` sulla tabella. In questo caso specifico la terminazione avviene perchè il trigger $T2$ fa un `UPDATE` condizionale che tiene conto del lordo degli impiegati.
