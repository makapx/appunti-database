SELECT idevento, titolo, data, SUM(costo_partecipazione) as incasso_totale
FROM PARTECIPANTE p JOIN EVENTO e ON p.idevento = e.id
GROUP BY idevento, titolo, data ORDER BY incasso_totale DESC;
