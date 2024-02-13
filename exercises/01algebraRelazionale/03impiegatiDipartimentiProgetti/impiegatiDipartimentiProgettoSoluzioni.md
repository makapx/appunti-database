## Esercizio 1 

Si consideri lo schema relazionale composto dalle seguenti relazioni:

IMPIEGATO(**Matricola**, Cognome, Stipendio, Dipartimento)
DIPARTIMENTO(**Codice**, Nome, Sede, Direttore)
PROGETTO(**Sigla**, Nome, Bilancio, Responsabile)
PARTECIPAZIONE(**Impiegato, Progetto**)

Con i seguenti vincoli di riferimento:
• tra l’attributo Dipartimento della relazione Impiegato e la relazione Dipartimento
• tra l’attributo Direttore della relazione Dipartimento e la relazione Impiegato
• tra l’attributo Responsabile della relazione Progetto e la relazione Impiegato
• tra l’attributo Impiegato della relazione Partecipazione e la relazione Impiegato
• tra l’attributo Progetto della relazione Partecipazione e la relazione Progetto

Formulare le seguenti interrogazioni in algebra relazionale

1. Trovare matricola e cognome degli impiegati che guadagnano più di 50 milioni

$$
\pi_{Matricola,Cognome}(\sigma_{Stipendio > 50.000.000}(Impiegato))
$$
2. Trovare cognome e stipendio degli impiegati che lavorano a Roma

$$
\pi_{Cognome,Stipendio} ( Impiegato \Join_{Impiegato.Dipartimento = Dipartimento.Codice} \sigma_{Sede = 'Roma'}(Dipartimento))
$$
3.  Trovare cognome degli impiegati e nome del dipartimento in cui lavorano

$$
\pi_{Cognome,Nome}(Impiegato \Join_{Impiegato.Dipartimento = Dipartimento.Codice} Dipartimento)
$$
4. Trovare cognome degli impiegati che sono direttori di dipartimento

$$
\pi_{Cognome}(Dipartimento \Join_{Dipartimento.Direttore = Impiegato.Matricola} Impiegato)
$$
5. Trovare i nomi dei progetti e i cognomi dei responsabili

$$
\pi_{Nome, Cognome} (Progetto \Join_{Progetto.Responsabile = Impiegato.Matricola} Impiegato)
$$
6. Trovare i nomi dei progetti con bilancio maggiore di 100K e i cognomi degli impiegati che lavorano su di essi

$$
\pi_{Nome,Cognome} (Impiegato \Join_{Impiegato.Matricola = Partecipazione.Impiegato}( \\ Partecipazione \Join _{Partecipazione.Progetto = Progetto.Sigla} (\sigma_{Bilancio > 100.000} (Progetto))))
$$
7. Trovare il cognome degli impiegati che guadagnano più del loro direttore di dipartimento

$$
DirettoriDipartimenti = \rho_{(Matricola,Cognome,Stipendio,Dipartimento \rightarrow MatricolaDirettore, CognomeDirettore, StipendioDirettore, DipartimentoDirettore)} \\
(Dipartimento \Join_{Dipartimento.Direttore = Impiegato.Matricola} Impiegato) \\ \\

\pi_{Cognome} ( \sigma_{Stipendio > StipendioDirettore \ AND \ Matricola \ != \ MatricolaDirettore }(Impiegati \Join_{Impiegato.Dipartimento = Dipartimento.Codice} DirettoriDipartimenti))
$$
8. Trovare cognome dei direttori di dipartimento e dei responsabili di progetto

$$
ResponsabiliProgetti = Progetto \Join_{Progetto.Responsabile = Impiegato.Matricola} Impiegato \\
CognomiResponsabili = \pi_{Cognome} ResponsabiliProgetto \\\\

CognomiDirettori = \rho_{(CognomeDirettore \rightarrow Cognome)}(\pi_{CognomeDirettore}(DirettoriDipartimenti)) \\ \\

CognomiResponsabili \ \cup \ CognomiDirettori 
$$
9. Trovare nomi dei dipartimenti in cui lavorano impiegati che guadagnano più di 60K

$$
ImpiegatiRicchi = \sigma_{Stipendipo > 60.000}(Impiegato) \\ \\
\pi_{Nome}(Dipartimento \Join_{Dipartimento.Codice = ImpiegatiRicchi.Dipartimento} ImpiegatiRicchi) \\
$$
10. Trovare nomi dei dipartimenti in cui tutti gli impiegati guadagnano più di 60K

$$
CodiciDipartimentiImpiegatiRicchi = \pi_{Matricola,Dipartimento}(Impiegato) \ \div \  \pi_{Matricola}(ImpiegatiRicchi) \\\\

\pi_{Nome}(Dipartimento \Join_{Codice = Dipartimento} CodiciDipartimentiImpiegatiRicchi)
$$
11. Trovare cognome degli impiegati di stipendio massimo

$$
Impiegato2 = \rho_{(Matricola,Cognome,Stipendio,Dipartimento \rightarrow Matricola2,Cognome2,Stipendio2,Dipartimento2)}Impiegato \\\\

ImpiegatiConStipendiNonMax = \sigma_{Stipendio2 < Stipendio}(Impiegato2 \times Impiegato) \\\\

\pi_{Cognome2}((Impiegato \times Impiegato) \ - \ ImpiegatiCOnStipendiNonMax)
$$
12. Trovare matricola e cognome degli impiegati che non lavorano a nessun progetto

$$
MatricoleImpiegati = \pi_{Matricola}(Impiegato) - (\rho_{(Impiegato \rightarrow Matricola)}(\pi_{Impiegato}(Partecipazione))) \\ \\

\pi_{Matricola,Cognome}(MatricoleImpiegati \Join Impiegato)
$$
13. Trovare matricola e cognome degli impiegati che lavorano a più di un progetto

$$
Partecipazioni2 = \rho_{(Impiegato,Progetto \rightarrow Impiegato2,Progetto2)}(Partecipazione) \\

AlmenoDuePartecipazioni = \sigma_{Impiegato = Impiegato2 \ AND \ Progetto \ < > \ Progetto2 }(Partecipazioni \times Partecipazioni2) \\ \\

ImpiegatiConAlmenoDueProgetti = Impiegato \Join_{Matricola = Impiegato} AlmenoDuePartecipazioni \\ \\

\pi_{Matricola,Cognome}(ImpiegatiConAlmenoDueProgetti)
$$
14. Trovare matricola e cognome degli impiegati che lavorano a un solo progetto

$$
ImpiegatiZeroOUnProgetto = \\ \pi_{Matricola,Cognome}(Impiegato) - \pi_{Matricola,Cognome}(ImpiegatiConAlmenoDueProgetti) \\\\

ImpiegatiConUnProgetto = ImpiegatiZeroOUnProgetto \Join_{Matricola = Impiegato} Partecipazione
$$

## Esercizio 2

Con riferimento allo schema dell’esercizio precedente, descrivere in linguaggio naturale il significato delle seguenti interrogazioni espresse in algebra relazionale.

1. Proietta il cognome di tutti gli impiegati che sono responsabili di almeno un progetto
2. Proietta il cognome dei direttori di dipartimento che sono anche impiegati del dipartimento che amministrano.
