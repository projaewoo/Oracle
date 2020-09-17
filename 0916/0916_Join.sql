REM NAME : 정재우
REM OBJECTIVE : 2020-09-16 과제
REM DATE : 2020-09-16
REM ENVIRONMENT : Mac Os Catalina, Oracle SQL Developer 20.2.0.175, Oracle-xe-11g

--잘 모르겠음.
--3번. DEPT Table에 있는 모든 부서를 출력하고, EMP Table에 있는 DATA와 JOIN하여
--모든 사원의 이름, 부서번호, 부서명, 급여를 출력하라.  (DEPT Table의 모든 부서 출력 = OUTER JOIN 사용해야함)
--비표준 조인
SELECT e.ename, e.deptno, d.dname, e.sal
FROM   emp e, dept d
WHERE e.deptno = d.deptno;
--표준 조인 (NATURAL JOIN)
SELECT  e.ename, deptno, d.dname, e.sal  --조인의 기준이 되는 열 (deptno)은 식별자 사용 X.
FROM emp e NATURAL JOIN dept d;
--표준 조인 (JOIN ~ USING절)
SELECT e.ename, deptno, d.dname, e.sal          --조인의 기준이 되는 열 (deptno)은 식별자 사용 X.
FROM emp e INNER JOIN dept d USING(deptno);
--표준 조인 (JOIN ~ ON 절)
SELECT e.ename, e.deptno, d.dname, e.sal            --이때, 공통칼럼 (deptno)에 식별자 사용 가능.
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno;


--5번. 'ALLEN'의 직무와 같은 사람의 이름, 부서명, 급여, 회사위치, 직무를 출력.
--먼저 SELECT 한번 사용해서 ALLEN의 직무 알아냄.
SELECT job
FROM emp
WHERE ename = 'ALLEN';  --SALESMAN
--두번째 SELECT (비표준 조인) (Equi join)
SELECT ename, dname, sal, loc, job
FROM emp, dept
WHERE emp.deptno = dept.deptno AND job = 'SALESMAN';
--두번째 SELECT (표준 조인) (NATURAL JOIN)
SELECT ename, dname, sal, loc, job
FROM emp NATURAL JOIN dept
WHERE job = 'SALESMAN';

--서브쿼리
SELECT ename, dname, sal, loc, job
FROM   emp NATURAL JOIN dept
WHERE job = ( SELECT job
                            FROM emp
                            WHERE ename = 'ALLEN');
                            
--6번. 'JAMES'가 속해있는 부서의 모든 사람의 사원번호, 이름, 입사일, 급여 출력.
--서브쿼리
SELECT deptno, ename, hiredate, sal 
FROM   emp INNER JOIN dept USING(deptno)
WHERE deptno = ( SELECT deptno
                            FROM emp
                            WHERE ename = UPPER('james'));
                            
--7번. 전체 사원의 평균 임금보다 많은 사원의 사원번호, 이름, 부서명, 입사일, 지역, 급여 출력.
SELECT empno, ename, dname, hiredate, loc, sal
FROM emp NATURAL JOIN dept 
WHERE sal > ( SELECT AVG(sal)
                        FROM emp);

--8번. 10번 부서 사람들 중에서 20번 부서의 사원과 같은 업무를 하는 사원의
--사원번호, 이름, 부서명, 입사일, 지역을 출력.
SELECT empno, ename, dname, hiredate, loc
FROM emp NATURAL JOIN dept
WHERE deptno IN 10 AND job IN ( SELECT job
                                                    FROM emp
                                                    WHERE deptno = 20);
                                                    
--9번. 10번 부서 중에서 30번 부서에는 없는 업무를 하는 사원의
--사원번호, 이름, 부서명, 입사일, 지역을 출력.
--첫번째 SELECT (30번 부서의 업무 확인)
SELECT job
FROM emp
WHERE deptno = 30;  --SALESMAN, MANAGER, CLERK
--두번째 SELECT --비표준 조인(Equi join)
SELECT empno, ename, dname, hiredate, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
            AND  emp.deptno = 10
            AND  job NOT IN ('SALESMAN', 'MANAGER', 'CLERK');
--두번째 SELECT --표준 조인 (JOIN ~ USING 절)
SELECT empno, ename, dname, hiredate, loc
FROM emp INNER JOIN dept USING(deptno)
WHERE deptno = 10
            AND job NOT IN ('SALESMAN', 'MANAGER', 'CLERK');
            
--서브쿼리
SELECT empno, ename, dname, hiredate, loc
FROM    emp INNER JOIN dept USING(deptno)
WHERE  deptno IN 10 AND job NOT IN ( SELECT job
                                                            FROM emp
                                                            WHERE deptno IN 30);
--비표준 조인
SELECT e.empno, e.ename, d.dname, e.hiredate, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno = 10 AND job NOT IN ( SELECT job
                                                                                                FROM emp
                                                                                                WHERE deptno IN 30);
                                                                                                
--10번. 10번 부서와 같은 일을 하는 사원의 사원번호, 이름, 부서명, 지역, 급여를
--급여가 많은 순으로 출력.
SELECT e.empno, e.ename, d.dname, d.loc, e.sal
FROM   emp e, dept d
WHERE   e.deptno = d.deptno AND job IN ( SELECT job
                                                                FROM emp
                                                                WHERE deptno = 10)
ORDER BY sal DESC;


--11번. 'MARTIN'이나 'SCOTT'의 급여와 같은 사원의
--사원번호, 이름, 급여 출력.
--단, MARTIN과 SCOTT는 출력 X
