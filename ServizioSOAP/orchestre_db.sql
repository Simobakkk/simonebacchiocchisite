DROP DATABASE IF EXISTS orchestra_db;

CREATE DATABASE orchestra_db;

USE orchestra_db;

CREATE TABLE Orchestra (
    id_orchestra SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valutazione DECIMAL(3,1),
    citta_origine VARCHAR(50),
    paese_origine VARCHAR(50),
    anno_fondazione INT
);

CREATE TABLE Concerto (
    id_concerto SERIAL PRIMARY KEY,
    citta VARCHAR(50),
    paese VARCHAR(50),
    anno INT,
    valutazione DECIMAL(3,1),
    id_orchestra INT REFERENCES Orchestre(id_orchestra)
);

CREATE TABLE Membrp (
    id_membro SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    strumento VARCHAR(50),
    stipendio DECIMAL(8,2),
    anni_esperienza INT,
    id_orchestra INT REFERENCES Orchestre(id_orchestra)
);

--tabella orchestre
INSERT INTO Orchestre (nome, valutazione, citta_origine, paese_origine,
anno_fondazione) VALUES
('Chamber Orchestra', 7.2, 'Vienna', 'Austria', 1980),
('Symphonic Stars', 8.5, 'Berlino', 'Germania', 1990),
('Modern Ensemble', 7.8, 'Parigi', 'Francia', 2000),
('Classic Harmony', 9.1, 'Londra', 'Regno Unito', 1975),
('Young Philharmonic', 8.0, 'Roma', 'Italia', 2010),
('Orchestra Sinfonica Mediterranea', 8.6, 'Napoli', 'Italia', 1998),
('Orchestra Giovanile Europea', 7.9, 'Vienna', 'Austria', 2005);
--Tabella Concerti
INSERT INTO Concerti (citta, paese, anno, valutazione, id_orchestra) VALUES
('Vienna', 'Austria', 2013, 7.5, 1),
('Berlino', 'Germania', 2013, 8.2, 2),
('Parigi', 'Francia', 2014, 7.9, 3),
('Londra', 'Regno Unito', 2013, 9.0, 4),
('Roma', 'Italia', 2015, 8.1, 5);
--Tabella Membri
INSERT INTO Membri (nome, strumento, stipendio, anni_esperienza, id_orchestra)
VALUES
('Alice Brown', 'violino', 3000, 12, 2),
('Marco Rossi', 'violoncello', 2800, 15, 4),
('John Smith', 'violino', 2500, 8, 1),
('Laura White', 'flauto', 2700, 11, 3),
('Anna Verdi', 'pianoforte', 3200, 20, 4),
('Paolo Bianchi', 'violino', 2600, 10, 5),
('Luca Bianchi', 'violino', 2200, 12, 6),
('Maria Rossi', 'violoncello', 2400, 15, 6),
('Giovanni Verdi', 'flauto', 1800, 8, 7),
('Anna Müller', 'violino', 2000, 6, 7),
('Paul Schneider', 'tromba', 2100, 9, 7);


/*
Orchestra(id_orchestra, nome, valutazione, citta_origine, paese_origine, anno_fondazione)
Concerto(id_concerto, città, paese, anno, valutazione, id_orchestra)
Membro(id_membro, nome, strumento, stipendio, anni_esperienza, id_orchestra)
*/

/*query*/

/*1*/
SELECT id_orchestra, COUNT(*) AS num_membri
FROM Membro m JOIN Orchestra o ON m.id_orchestra = o.id_orchestra 
GROUP BY m.id_orchestra 
ORDER BY o.anno_fondazione;

/*2*/
SELECT * FROM Orchestra 
WHERE citta_origine IN (
    SELECT o.citta_origine 
    FROM Orchestra o JOIN Concerto c ON o.id_orchestra = c.id_orchestra
    WHERE c.anno = 2013
);

/*3*/
SELECT * FROM Membro
WHERE anni_esperienza > 10 AND id_orchestra NOT IN (
    SELECT id_orchestra 
    FROM Orchestra 
    WHERE valutazione > 8
);

/*4*/
SELECT nome, strumento 
FROM Membro 
WHERE stipendio > (
    SELECT AVG(stipendio) as salario_medio 
    FROM Membro 
    WHERE strumento = "Violino"
); 

/*5*/
SELECT nome 
FROM Orchestra 
WHERE anno_fondazione > (
    SELECT anno_fondazione 
    FROM Orchestra 
    WHERE nome = "Chamber Orchestra"
)
AND valutazione > 7.5;

/*6*/
SELECT nome 
FROM Orchestra 
WHERE id_orchestra NOT IN (
    SELECT id_orchestra 
    FROM Concerto 
)

/*7*/
SELECT nome, strumento, stipendio
FROM Membro m
WHERE stipendio > (
    SELECT AVG(stipendio)
    FROM Membro
    WHERE id_orchestra = m.id_orchestra
);

/*8*/
SELECT o.nome, COUNT(*) AS num_membri 
FROM Orchestra o JOIN Membro m ON o.id_orchestra = m.id_orchestra 
GROUP BY o.id_orchestra 
HAVING num_membri > (
    SELECT AVG(num_membri)
    FROM (
        SELECT COUNT(*) AS num_membri 
        FROM Membro 
        GROUP BY id_orchestra
    )
);

/*9*/
SELECT o.nome, COUNT(*) AS num_concerti
FROM Orchestra o JOIN Concerto c ON id_orchestra = c.id_orchestra 
GROUP BY o.id_orchestra 
HAVING num_concerti > ALL(
    SELECT COUNT(*) AS num_concerti 
    FROM Concerto
    GROUP BY id_orchestra 
)

/*10*/
CREATE VIEW MiglioriOrchestre AS 
SELECT nome, citta_origine, valutazione
FROM Orchestra 
WHERE valutazione >= 8.5;

SELECT * FROM MiglioriOrchestre m JOIN Orchestra o 
ON m.nome = o.nome
WHERE o.anno_fondazione > 2000;
