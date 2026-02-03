--1
SELECT titolo
FROM Film
WHERE annoProduzione > 2010;
--2
SELECT nome
FROM Sale
WHERE posti < 80 AND citta = 'Milano';
--3
SELECT COUNT(*)
FROM Proiezioni
WHERE YEAR(data_Proiezione) = 2022;
--4
SELECT citta, COUNT(*) AS numSale
FROM Sale
GROUP BY citta;
--5
SELECT citta, COUNT(*) AS numSale
FROM Sale
GROUP BY citta
HAVING numSale > 5;
--6
SELECT f.titolo, s.nome
FROM Film f JOIN Sale S JOIN Proiezioni p
ON f.codFilm = p.codFilm AND p.codSala = s.codSala;
--7
SELECT f.regista, SUM(p.incasso) AS incassoTotale
FROM Film f JOIN Proiezioni p
ON f.codFilm = p.codFilm;
--8
SELECT f.titolo, s.nome, p.dataProiezione 
FROM Film f JOIN Sale s JOIN Proiezioni p 
ON f.codFilm = p.codFilm AND p.codSala = s.codSala
WHERE f.annoProduzione = 2023 AND s.citta = "Roma"
GROUP BY f.titolo;
--9
SELECT *
FROM Film
ORDER BY annoProduzione DESC;
--10
SELECT s.nome, SUM(p.incasso) AS incassoTotale 
FROM Sale s JOIN Proiezioni p 
ON s.codSala = p.codSala 
GROUP BY s.nome
HAVING incassoTotale > 20000;
--11
SELECT f.regista, YEAR(f.annoProduzione) COUNT(p.codFilm) AS numFilm
FROM Film f
