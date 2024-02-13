SELECT idevento, COUNT(idpersona) AS num_partecipanti
FROM EVENTO e JOIN PARTECIPANTE p ON e.id = p.idevento
WHERE data > '2013-01-01' AND data < '2013-12-31'
HAVING num_partecipanti = (
	SELECT COUNT(idpersona) as numero_partecipanti
	FROM PARTECIPANTE p JOIN EVENTO e ON p.idevento = e.id
	WHERE data > '2013-01-01' AND data < '2013-12-31'
	GROUP BY idevento, titolo, data ORDER BY numero_partecipanti LIMIT 1
);
