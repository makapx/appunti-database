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

