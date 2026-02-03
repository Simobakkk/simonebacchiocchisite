--1
SELECT * FROM Sale
WHERE citta = "Pisa";
--2
SELECT codFilm, titolo
FROM codFilm
WHERE annoProduzione > 1960 AND regista = 'F. Fellini';
--3
SELECT titolo, durata
FROM Film 
WHERE (nazionalita = 'Giapponese' OR nazionalita = 'Francese') AND annoProduzione > 1990 AND genere = 'Fantascienza';
--4
SELECT titolo
FROM Film 
WHERE (nazionalita = 'Giapponese' OR nazionalita = 'Francese') AND annoProduzione > 1990 AND genere = 'Fantascienza';
--5
SELECT f.titolo, f.genere, p.giorno
FROM Film f JOIN Proiezione P
WHERE p.dataProiezione = '2004-12-25'
ON f.codFilm = p.codFilm;
--6
SELECT f.titolo, f.genere, p.giorno, s.citta
FROM Film f JOIN Proiezione P JOIN Sale s
WHERE p.dataProiezione = '2004-12-25' AND s.citta = 'Napoli'
ON f.codFilm = p.codFilm;
--7
SELECT s.nome, p.dataProiezione, a.regista
FROM Sale s JOIN Proiezione p JOIN Attore n 
WHERE p.dataProiezione = '2004-12-25' AND s.citta = 'Napoli' AND a.nome = 'R. Williams'
ON p.codSala = s.codSala;
--8
SELECT f.titolo, a.nome
FROM Film f JOIN Attore a 
WHERE a.nome = ('M. Mastroianni' OR 'S. Loren');
ON f.codFilm = a.codFilm;
--9
SELECT a.nazionalita, a.nome, f.titolo
FROM Attore a JOIN Film f 
WHERE a.nazionalita = 'Francese'
GROUP BY a.nazionalita
--12
SELECT f.titolo, s.nome, d.dataProiezione
FROM Film f JOIN Sale s, JOIN Proiezioni d
WHERE p.dataProiezione = '2005-01-__' AND s.citta = 'Pisa'
ON f.codFilm = p.codFilm AND p.codSala = s.codSala;
--13
SELECT nome, COUNT(*)
FROM Sale
WHERE posti > 60 AND citta = 'Pisa';
--14
SELECT SUM(Posti) AS numPosti
FROM Sale
--15
SELECT citta, COUNT(*),
FROM Sale
GROUP BY citta;
--16
SELECT citta, COUNT(*)
FROM Sale
WHERE posti > 60
GROUP BY citta
--17
SELECT regista, COUNT(*) AS numFilm
FROM Film
WHERE AnnoProduzione > 1990
--18
SELECT f.regista, SUM(p.incasso) AS incassoTotale
FROM Film f JOIN Proiezioni P
ON f.codFilm = p.codFilm 
GROUP BY regista
--19
SELECT f.titolo, p.COUNT(*) AS numProiezioni, incasso
FROM Film f JOIN Proiezioni p JOIN Sale S
WHERE s.citta = 'Pisa' AND f.regista = 'S.Spielberg'
ON f.codFilm = p.codFilm AND p.codSala = s.codSala
--20
SELECT f.regista, a.nome, f.COUNT(*)
FROM Film f JOIN Attori a
ON f.codFilm = a.codFilm
--21
SELECT f.titolo, f.regista, COUNT(a.codAttore) as numAttori
FROM Film f
JOIN Recita r ON r.codFilm = f.codFilm
JOIN Attori a ON r.codAttore = a.codAttore 
GROUP BY f.titolo, f.regista 
HAVING COUNT(a.codAttore) < 6 
--22
SELECT f.codFilm, f.titolo, SUM(p.incasso)
FROM Film f JOIN Proiezioni p 
ON f.codFilm = p.codFilm 
WHERE f.AnnoProduzione > 2000
GROUP BY f.codFilm, f.titolo;
--23
SELECT COUNT(*)
FROM Attori
WHERE annoNascita < 1970;
--24
SELECT f.titolo, SUM(p.incasso) AS incassoTotale 
FROM Film f JOIN Proiezioni p 
ON f.codFilm = p.codFilm 
WHERE f.genere = 'Fantascienza'
GROUP BY f.titolo;
--25
SELECT f.titolo, SUM(p.incasso) AS incassoTotale 
FROM Film f JOIN Proiezioni p 
ON f.codFilm = p.codFilm 
WHERE f.genere = 'Fantascienza' AND f.annoProduzione > 2001
GROUP BY f.titolo;
--26
SELECT f.titolo, SUM(p.incasso) AS incassoTotale 
FROM Film f JOIN Proiezioni p 
ON f.codFilm = p.codFilm 
WHERE f.genere = 'Fantascienza' AND f.annoProduzione > 2001
GROUP BY f.titolo;
--27
SELECT s.nome, SUM(p.incasso) AS incassoTotale 
FROM Sale s JOIN Proiezioni p 
ON s.codSala = p.codSala 
WHERE (YEAR(p.dataProiezione) = 2005 AND MONTH(p.dataProiezione) = 1) AND p.incasso > 20000 AND s.citta = 'Pisa'
GROUP BY s.nome;
