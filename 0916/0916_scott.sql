REM CROSS JOIN, 교차조인, Cartesian Product, 데카르트 곱
--카티시안 곱 (비표준조인)
SELECT empno, ename, job, dname, loc, dept.deptno
FROM emp, dept;
--Cross join (표준조인) (FROM절에 조인조건 사용)
SELECT empno, ename, job, dname, loc, dept.deptno
FROM emp CROSS JOIN dept;

--카티시안 곱 (비표준 조인)
SELECT empno, ename, job, dname, loc, dept.deptno
FROM emp, dept, salgrade;
--14 * 4 * 5 = 280행의 테이블 나옴.

--Cross join
SELECT empno, ename, job, dname, loc, dept.deptno
FROM emp CROSS JOIN dept CROSS JOIN salgrade CROSS JOIN ...;


REM 등가조인 (Equi Join) , Inner Join, Simple Join, Natural Join, 조인, join ~ on, join ~ using
--1. SMITH는 몇 번 부서 소속인가?  20번 부서
SELECT ename, deptno
FROM emp
WHERE ename = 'SMITH';
--2. 그 부서는 이름과 위치는 어디인가? RESEARCH : 소속, DALLAS : 위치
SELECT dname, loc
FROM dept
WHERE deptno = 20;
--3. SMITH가 속한 부서이름과 위치는 어디인가? 
SELECT ename, emp.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND ename = 'SMITH';

--예를 들어, 사원번호, 이름, 급여, 근무부서를 함께 출력하되
--급여가 3000 이상인 데이터만 출력
--비등가 조인 (비표준 조인) (WHERE절에 조인조건 씀) (비등가 : WHERE절에 = 연산자 사용)
SELECT  e.empno AS "사원번호", e.ename AS "사원명", e.sal AS "봉급", d.dname AS "부서명"
FROM    emp e, dept d
WHERE e.deptno = d.deptno AND sal >= 3000;

--NATURAL JOIN (등가조인의 표준 조인) (FROM절에 조인조건 씀)
SELECT  e.empno AS "사원번호", e.ename AS "사원명", e.sal AS "봉급", d.dname AS "부서명", d.deptno
FROM   emp e NATURAL JOIN dept d
WHERE e.sal >= 3000;


--사원이름이 KING인 부서의 이름과 근무지를 출력
SELECT  ename, dname, loc
FROM   emp, dept
WHERE emp.deptno = dept.deptno AND ename = UPPER('king');   --비표준 조인. --등가조인.

SELECT  ename, dname, loc
FROM   emp NATURAL JOIN dept    --표준 조인 --Natural Join
WHERE ename = UPPER('king');

--Joing ~ Using
SELECT e.empno AS "사원번호", e.ename AS "사원명", e.sal AS "봉급", d.dname AS "부서명", deptno AS "부서번호"
FROM  emp e INNER JOIN dept d USING(deptno)   --JOIN 앞에 INNER 명시해도 됨. (JOIN ~ USING에 해당하는 표준조인 키워드인 INNER 사용)
WHERE e.sal >= 3000;   --표준 JOIN ~ USING (조인 조건에 식별자 사용 금지)

--모든 사원의 이름, 부서번호, 부서이름을 표시하는 질의를 작성.
SELECT  ename, emp.deptno, dname
FROM   emp, dept
WHERE  emp.deptno = dept.deptno;        --비표준 조인 (WHERE절에 조인조건 명시) --등가 조인 (WHERE절에 = 연산자 사용)

SELECT  ename, deptno, dname      --NATURAL JOIN이므로 deptno앞에 식별자 X (dept.deptno X)
FROM  emp NATURAL JOIN dept;   --표준 조인 (FROM절에 조인조건 명시)

SELECT  ename, deptno, dname                --JOIN ~ USING : 공통칼럼인 deptno앞에 식별자 X
FROM  emp JOIN dept USING(deptno);    --표준 조인 (FROM절에 조인조건 명시) (INNER JOIN으로 INNER명시해줘도 됨)

--comm을 받는 모든 사원의 이름, 부서 이름 및 위치를 표시하는 질의 작성.
--비표준 조인 (등가조인)
SELECT  ename, dname, loc
FROM  emp, dept
WHERE emp.deptno = dept.deptno AND comm IS NOT NULL;
--표준 조인 (NATURAL JOIN)
SELECT ename, dname, loc
FROM emp NATURAL JOIN dept
WHERE comm IS NOT NULL;
--표준 조인 (JOIN ~ USING)
SELECT ename, dname, loc
FROM emp INNER JOIN dept USING(deptno)
WHERE comm IS NOT NULL;

--4. DALLAS에 근무하는 모든 사원의 이름, 직무, 부서번호 및 부서이름을 표시하는 질의 작성.
--비표준 조인
SELECT  ename, job, dept.deptno, dname, loc     --dept.deptno 명시 (deptno : 공통칼럼이므로)
FROM    emp, dept
WHERE emp.deptno = dept.deptno AND loc = UPPER('Dallas');
--표준 조인(NATURAL JOIN)
SELECT ename, job, deptno, dname, loc       --NATURAL JOIN이므로 공통칼럼인 deptno앞에 식별자 X (emp.deptno X)
FROM emp NATURAL JOIN dept
WHERE loc = UPPER('Dallas');
--표준 조인(JOIN ~ USING)
SELECT ename, job, deptno, dname, loc
FROM emp INNER JOIN dept USING(deptno)      --JOIN ~ USING 또는 INNER JOIN ~ USING 사용.
WHERE loc = UPPER('Dallas');


REM JOIN ~ ON 사용하기
--비표준 조인. (Equi join)
SELECT  empno, ename, job, sal, dname, loc, dept.deptno
FROM  emp, dept
WHERE  emp.deptno = dept.deptno AND sal <= 2000 AND job IN ('SALESMAN', 'CLERK', 'MANAGER');

--NATURAL JOIN (표준 조인)
SELECT  empno, ename, job, sal, dname, loc, deptno      --NATURAL JOIN : 식별자 사용 불가
FROM emp NATURAL JOIN dept
WHERE sal <= 2000 AND job IN ('SALESMAN', 'CLERK', 'MANAGER');

--표준 조인(JOIN ~ USING절)
SELECT  empno, ename, job, sal, dname, loc, deptno      --JOIN ~ USING 절 : 식별자 사용 불가.
FROM emp INNER JOIN dept USING(deptno)      --INNER 명시해도 되고 안해도 됨.
WHERE sal <= 2000 AND job IN ('SALESMAN', 'CLERK', 'MANAGER');

--JOIN ~ ON 절 (표준조인)
SELECT  empno, ename, job, sal, dname, loc, dept.deptno      --JOIN ~ ON 절 : 식별자 사용 가능.
FROM emp JOIN dept ON emp.deptno = dept.deptno        --표준 조인 (FROM절에 조인조건 명시) (JOIN ~ ON 절 : FROM절의 조건에 =연산자 사용)   --INNER JOIN ~ ON해도 됨.
WHERE sal <= 2000 AND job IN ('SALESMAN', 'CLERK', 'MANAGER');  


--이름이 'ALLEN'인 사원의 부서명을 출력.
--비표준 조인 (Equi Join)
SELECT  ename, dname
FROM  emp, dept
WHERE  emp.deptno = dept.deptno AND ename = 'ALLEN';
--NATURAL JOIN (표준 조인)
SELECT ename, dname
FROM emp NATURAL JOIN dept
WHERE ename = 'ALLEN';
--JOIN ~ USING절 (표준 조인)
SELECT ename, dname
FROM emp INNER JOIN dept USING(deptno)      --USING(공통칼럼)
WHERE ename = 'ALLEN';
--JOIN ~ ON절 (표준 조인)
SELECT ename, dname
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno
WHERE ename = 'ALLEN';

--EMP와 DEPT table을 JOIN하여 부서번호, 부서명, 이름, 급여 출력.
--비표준 조인 (Equi Join) (등가조인)
SELECT d.deptno, dname, ename, sal
FROM emp e, dept d
WHERE e.deptno = d.deptno;
--NATURAL JOIN (표준 조인)
SELECT deptno, dname, ename, sal        --NATURAL JOIN : 식별자 사용 불가.
FROM emp NATURAL JOIN dept;         --공통된 칼럼 알아서 찾음.
--JOIN ~ USING절 (표준 조인)
SELECT deptno, dname, ename, sal
FROM  emp INNER JOIN dept USING(deptno);
--JOIN ~ ON절 (표준 조인)
SELECT d.deptno, dname, ename, sal
FROM emp  e INNER JOIN dept d ON e.deptno = d.deptno;