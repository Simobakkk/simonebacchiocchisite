-- Artista(id_artista, nome, nazionalità, anno_nascita)
-- Album(id_album, titolo, anno_pubblicazione, genere, id_artista (FK))
-- Brano(id_brano, titolo, durata, popolarità, id_album (FK))
-- Concerto(id_concerto, città, paese, data, incasso, id_artista(FK))
-- Biglietto(id_biglietto, prezzo, tipo, id_concerto(FK))

--1 
SELECT a.nome, COUNT(*) AS num_album
FROM Artista a 
JOIN Album ab ON a.id_artista = ab.id_artista 
GROUP BY a.id_artista, a.nome
HAVING COUNT(*) > (
    SELECT AVG(num_tutti_album)
    FROM (
        SELECT COUNT(*) AS num_tutti_album
        FROM Album 
        GROUP BY id_artista
    ) as album_per_artista
);

--2 
SELECT a.titolo, COUNT(*) AS num_brani
FROM Album a 
JOIN Brano b ON a.id_album = b.id_album
GROUP BY a.id_album, a.titolo, a.genere
HAVING COUNT(*) > (
    SELECT AVG(num_brani)
    FROM (
        SELECT ab.id_album, COUNT(*) AS num_brani
        FROM Album ab
        JOIN Brano br ON ab.id_album = br.id_album
        WHERE ab.genere = a.genere
        GROUP BY ab.id_album
    ) t
);

SELECT * 
FROM Artista 
WHERE id_artista IN (
    SELECT id_artista 
    FROM Concerto 
    GROUP BY id_artista 
    HAVING COUNT(DISTINCT città) >= 3 
);

--departments (dept_id PK, dept_name, location)
--employees (emp_id PK, name, dept_id (FK), salary)
--projects (proj_id PK, proj_name, dept_id (FK))

--1 
SELECT * FROM Employees 
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);

--2 
SELECT * FROM Employees 
WHERE dept_id IN (
    SELECT dept_id 
    FROM Departments 
    WHERE dept_id NOT IN (
        SELECT dept_id 
        FROM Projects 
    )
);

--3 
SELECT * FROM Departments 
WHERE dept_id IN (
    SELECT dept_id 
    FROM employees 
    WHERE salary > (
        SELECT AVG(salary)
        FROM employees 
    )
);

--4 
SELECT * FROM Employees 
WHERE salary > ANY(
    SELECT salary 
    FROM Employees 
    WHERE dept_id IN (
        SELECT dept_id 
        FROM departments 
        WHERE dept_name = "Marketing"
    )
);

--5
SELECT * FROM employees 
WHERE salary > ALL(
    SELECT salary 
    FROM employees 
    WHERE dept_id IN (
        SELECT dept_id 
        FROM departments 
        WHERE dept_name = "HR"
    )
);

--6 
SELECT * 
FROM departments 
WHERE dept_id IN (
    SELECT dept_id 
    FROM projects 
    GROUP BY dept_id 
    HAVING COUNT(*) > 1 -- "having" in questo caso conta le occorrenze di ogni gruppo
)

--7
SELECT *
FROM projects 
WHERE dept_id IN (
    SELECT dept_id 
    FROM departments 
    WHERE dept_id IN (
        SELECT dept_id 
        FROM employees 
        GROUP BY dept_id 
        HAVING COUNT(*) > 5
    )
);

--8
SELECT * 
FROM employees 
WHERE dept_id NOT IN (
    SELECT dept_id 
    FROM Departments 
    WHERE location = "Roma"
);

--9 
SELECT * 
FROM Employees 
WHERE dept_id IN (
    SELECT dept_id
    FROM Employees 
    GROUP BY dept_id
    HAVING AVG(salary) = (
        SELECT MAX(media_salari)
        FROM (
            SELECT AVG(salary) AS media_salari
            FROM Employees 
            GROUP BY dept_id 
        ) AS media
    )
)

--altro esercizio 
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    enrollment_year INT
);

CREATE TABLE professors (
    professor_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    professor_id INT,
    credits INT,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
);

CREATE TABLE exams (
    exam_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    exam_date DATE,
    grade INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

/*
STUDENTS(student_id PK, name, city, enrollment_year)
PROFESSORS(professor_id PK, name, department)
COURSES(course_id PK, course_name, credits, professor_id FK)
EXAMS(exam_id PK, student_id FK, course_id FK, exam_date, grade)
*/

--1
/*
1) Mostrare per ogni corso:
   - nome del corso
   - media dei voti
   - numero totale di esami sostenuti
   Considerare solo i corsi con almeno 5 esami.

2) Trovare gli studenti che hanno ottenuto almeno un voto
   superiore alla media del corso corrispondente.

3) Individuare il professore i cui corsi hanno
   la media voti più alta.

4) Elencare gli studenti che non hanno mai preso
   un voto inferiore a 18.

5) Trovare il corso con il maggior numero
   di studenti distinti che hanno sostenuto l’esame.

6) Elencare gli studenti che hanno sostenuto esami
   con almeno 2 professori diversi.

7) Trovare gli studenti la cui media voti
   è superiore alla media globale di tutti gli esami.

8) Elencare i professori per cui non risulta
   alcun esame registrato nei loro corsi.

9) Calcolare i crediti totali acquisiti da ogni studente
   (considerando solo esami con voto ≥ 18)
   e trovare quello con il totale più alto.

10) Determinare l’anno (basato su exam_date)
    con la media voti più alta.
*/

--1
SELECT c.course_name, AVG(e.grade), COUNT(e.exam_id)
FROM Exams e JOIN Courses c ON e.course_id = c.course_id 
GROUP BY c.course_name
HAVING COUNT(e.exam_id) >= 5;

--2 
SELECT *
FROM students s JOIN exams e ON s.student_id = e.student_id 
WHERE e.grade > (
    SELECT AVG(e2.grade)
    FROM exams e2 
    WHERE e2.course_id = e.course_id
);

--3 
SELECT * 
FROM professor p JOIN courses c on p.professor_id = c.professor_id 
WHERE c.course_id IN (
    SELECT course_id 
    FROM exams 
    GROUP BY course_id 
    HAVING AVG(grade) = (
        SELECT MAX(media_voti_corso)
        FROM (
            SELECT AVG(grade) AS media_voti_corso
            FROM exams
            group by course_id
        ) as media_voti
    )
);

--4
SELECT * 
FROM students s JOIN exams e ON s.student_id = e.student_id 
WHERE e.grade >=18;

--5 
SELECT * 
FROM course c JOIN exams e on c.course_id = e.course_id 
WHERE c.course_id IN (
    SELECT course_id
    FROM exams 
    GROUP BY course_id
    HAVING COUNT(DISTINCT student_id) = (
        SELECT MAX(numero_studenti_esame)
        FROM (
            SELECT COUNT(DISTINCT student_id) AS numero_studenti_esame
            FROM exams 
            GROUP BY course_id
        )AS studenti_esame
    )
);

--6
SELECT * 
FROM students s JOIN exams e ON s.student_id = e.student_id 
WHERE e.course_id IN (
    SELECT course_id 
    FROM exams 
    GROUP BY course_id
    HAVING COUNT(*) > 2
);

--7 
SELECT * 
FROM students s JOIN exams e ON s.student_id = e.student_id 
WHERE e.grade > (
    SELECT AVG(grade)
    FROM exams
);

--8 
SELECT * 
FROM professors 
WHERE professor_id IN (
    SELECT c.professor_id 
    FROM course c 
    where c.course_id NOT IN (
        SELECT course_id 
        FROM exams 
    )
);

--9
SELECT s.student_id, s.name, SUM(c.credits) AS totale_crediti 
FROM exams e 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id 
WHERE e.grade >= 18
GROUP BY s.student_id, s.name 
ORDER BY totale_crediti DESC 
LIMIT 1;

--10
SELECT YEAR(exam_date)
FROM exams 
GROUP BY YEAR(exam_date)
HAVING YEAR(exam_date) IN (
    SELECT MAX(medie_per_anno)
    FROM(
        SELECT AVG(grade) AS medie_per_anno
        FROM exams
        GROUP BY YEAR(exam_date)
    ) AS medie_anno
);