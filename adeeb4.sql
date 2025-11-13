CREATE DATABASE EMPLOYEE;
USE EMPLOYEE;

CREATE TABLE DEPT (
    DEPTNO INT PRIMARY KEY,
    DNAME VARCHAR(100),
    DLOC VARCHAR(100)
);

CREATE TABLE PROJECT (
    PNO INT PRIMARY KEY,
    PLOC VARCHAR(100),
    PNAME VARCHAR(100)
);

CREATE TABLE EMPLOYEE (
    EMPNO INT PRIMARY KEY,
    ENAME VARCHAR(100),
    MGR_NO INT,
    HIREDATE DATE,
    SAL DECIMAL(10, 2),
    DEPTNO INT,
    FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO) ON DELETE SET NULL,
    FOREIGN KEY (MGR_NO) REFERENCES EMPLOYEE(EMPNO) ON DELETE SET NULL
);

CREATE TABLE INCENTIVES (
    EMPNO INT,
    INCENTIVE_DATE DATE,
    INCENTIVE_AMOUNT DECIMAL(10, 2),
    PRIMARY KEY (EMPNO, INCENTIVE_DATE),
    FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO) ON DELETE CASCADE
);

CREATE TABLE ASSIGNED_TO (
    EMPNO INT,
    PNO INT,
    JOB_ROLE VARCHAR(100),
    PRIMARY KEY (EMPNO, PNO),
    FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO) ON DELETE CASCADE,
    FOREIGN KEY (PNO) REFERENCES PROJECT(PNO) ON DELETE CASCADE
);

INSERT INTO DEPT (DEPTNO, DNAME, DLOC) VALUES
(10, 'Engineering', 'Bengaluru'),
(20, 'Testing', 'Hyderabad'),
(30, 'HR', 'Mysuru'),
(40, 'Finance', 'Bengaluru'),
(50, 'Marketing', 'Chennai'),
(60, 'Support', 'Pune');

INSERT INTO PROJECT (PNO, PLOC, PNAME) VALUES
(101, 'Bengaluru', 'PAlpha'),
(201, 'Hyderabad', 'PBeta'),
(301, 'Mysuru', 'PGamma'),
(401, 'Bengaluru', 'PDelta'),
(501, 'Chennai', 'POmega'),
(601, 'Pune', 'PZeta');

-- Insert 7 employees (Mgr: 1 -> 2, 3; 3 -> 4, 5; 5 -> 6, 7)
INSERT INTO EMPLOYEE (EMPNO, ENAME, MGR_NO, HIREDATE, SAL, DEPTNO) VALUES
(1, 'Ajay', NULL, '2020-01-15', 90000, 10),
(2, 'Bhuvan', 1, '2021-03-10', 75000, 10),
(3, 'Chetan', 1, '2020-05-20', 80000, 20),
(4, 'Dev', 3, '2022-07-01', 60000, 20),
(5, 'Esha', 3, '2021-11-30', 95000, 30),
(6, 'Falak', 5, '2023-02-12', 55000, 40),
(7, 'Guru', 5, '2023-01-10', 100000, 10);

INSERT INTO ASSIGNED_TO (EMPNO, PNO, JOB_ROLE) VALUES
(1, 101, 'Manager'),
(2, 101, 'Developer'),
(3, 201, 'Lead Analyst'),
(4, 301, 'Tester'),
(5, 401, 'HR Lead'),
(1, 201, 'Sr. Manager');


INSERT INTO INCENTIVES (EMPNO, INCENTIVE_DATE, INCENTIVE_AMOUNT) VALUES
(1, '2023-06-01', 5000),
(2, '2023-06-01', 3000),
(3, '2023-07-15', 4000),
(4, '2023-07-15', 2000),
(5, '2023-08-01', 6000),
(1, '2023-12-01', 5500);

select * from dept;
select * from project;
select * from assigned_to;
select * from employee;
select * from incentives;

select distinct a.empno from assigned_to a join project p on a.pno = p.pno where p.ploc in ("Bengaluru", "Mysuru", "Hyderabad");

select e.empno from employee e left join incentives i on e.empno = i.empno where i.empno is null;

select
 e.ename,
    e.empno,
    e.deptno,
    a.job_role,
    d.dloc, p.ploc
from 
 employee e
join
 dept d on e.deptno = d.deptno
join
 assigned_to a on e.empno = a.empno
join 
 project p on a.pno = p.pno
where d.dloc = p.ploc;

SELECT
    M.ENAME,
    COUNT(E.EMPNO) AS NumberOfReportees
FROM
    EMPLOYEE E
JOIN
    EMPLOYEE M ON E.MGR_NO = M.EMPNO
GROUP BY
    M.EMPNO, M.ENAME
HAVING
    COUNT(E.EMPNO) = (
        -- Subquery to find the maximum count of subordinates
        SELECT
            MAX(T.CountOfReportees)
        FROM
            (
                SELECT
                    COUNT(EMPNO) AS CountOfReportees
                FROM
                    EMPLOYEE
                WHERE
                    MGR_NO IS NOT NULL
                GROUP BY
                    MGR_NO
            ) AS T
    );
    
SELECT
    M.ENAME,
    M.SAL AS ManagerSalary,
    AVG(E.SAL) AS AvgSubordinateSalary
FROM
    EMPLOYEE E -- Employees (Subordinates)
JOIN
    EMPLOYEE M ON E.MGR_NO = M.EMPNO -- Managers
GROUP BY
    M.EMPNO, M.ENAME, M.SAL
HAVING
    M.SAL > AVG(E.SAL);