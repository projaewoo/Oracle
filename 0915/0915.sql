--175page Q3
SELECT  empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD'),
             TO_CHAR(NEXT_DAY(ADD_MONTHS(hiredate, 3), '월요일'), 'YYYY/MM/DD')  AS R_JOB,
             NVL(TO_CHAR(COMM), 'N/A') AS "COMM"
             --NVL(COMM, 0) -> COMM : 숫자형, 따라서 대체할 파라미터 0도 숫자형이어야함.
             --NVL(COMM, 'N/A') -> COMM : 숫자형, 'N/A' : 문자형이기 때문에 오류.
             --NVL(TO_CHAR(COMM), 'N/A')  -> COMM를 문자형으로 변경, 'N/A' : 문자형 -> 따라서 오류 X
FROM   emp;

--175page Q4
SELECT  EMPNO, ENAME, MGR,
             CASE 
                WHEN MGR IS NULL THEN '0000'     --숫자 0000 = 0만 찍힘 --따라서 글자 0000 = 0000으로 찍힘.
                WHEN MGR LIKE '75%' THEN '5555'
                WHEN MGR LIKE '76%' THEN '6666'
                WHEN MGR LIKE '77%' THEN '7777'
                WHEN MGR LIKE '78%' THEN '8888'
                ELSE TO_CHAR(MGR)
            END AS "CHG_MGR"
FROM   emp;

--강사님 해설.
SELECT empno, ename, mgr,
                CASE
                    WHEN mgr IS NULL THEN '0000'
                    WHEN SUBSTR(mgr, 1, 2) = '75' THEN '5555'
                    WHEN SUBSTR(mgr, 1, 2) = '76' THEN '6666'
                    WHEN SUBSTR(mgr, 1, 2) = '77' THEN '7777'
                    WHEN SUBSTR(mgr, 1, 2) = '78' THEN '8888'
                    ELSE TO_CHAR(mgr)           --숫자형 mgr를 글자형으로 변환.
                END AS "CHG_MGR"
FROM emp;

--다중행 함수
REM COUNT 함수
SELECT COUNT(DISTINCT job)
FROM emp;

--ALL이 숨겨져있음.
SELECT COUNT(deptno) , COUNT(ALL deptno), COUNT(DISTINCT deptno)
FROM emp;

--월급 많이 받는 사람, 적게 받는 사람
SELECT MAX(sal), MIN(sal)
FROM emp;

--183page 실습 7-12
SELECT TO_CHAR(MAX(hiredate), 'YYYY-MM-DD')
FROM emp;

--comm이 null이면 0으로 변경한 값과 다름.
--앞에꺼 4명으로 나눔, 뒤에꺼 14명으로 나눔.
SELECT  AVG(comm), AVG(nvl (comm,0) )
FROM   emp
WHERE deptno = 30;

--각 부서별 통계
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND( AVG(sal), 1)
FROM emp
WHERE deptno = 10
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND( AVG(sal), 1)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND( AVG(sal), 1)
FROM emp
WHERE deptno = 30;

--GROUP BY절 ( ~별로 정렬할때 사용)
--위의 행과 결과 동일
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND( AVG(sal), 1)
FROM emp
GROUP BY deptno;

--정렬도 가능
--SELECT절에 GROUP BY의 기준을 넣음 -> 가독성
SELECT deptno, SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND( AVG(sal), 1)
FROM emp
GROUP BY deptno
ORDER BY deptno;

--부서별 월급의 평균
--SELECT절에 GROUP BY의 기준 넣어서 가독성 향상.
SELECT deptno, job, TRUNC(AVG(sal)), MAX(sal), MIN(sal), COUNT(*)
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;

--부서별 평균 월급
SELECT department_id, TRUNC(AVG(salary))
FROM  employees
GROUP BY department_id;

--189page 실습 7-19
SELECT ename, deptno, AVG(sal)     --행의 개수 다르므로 에러.
FROM emp
GROUP BY deptno;


--SELECT절의 두 개가 행의 개수가 다르지만 GROUP BY로 deptno이 있으므로.
SELECT deptno, TRUNC(AVG(sal))
FROM emp
GROUP BY deptno;


SELECT deptno, TRUNC(AVG(sal))
FROM emp
GROUP BY deptno
HAVING TRUNC(AVG(sal)) >= 2000
WHERE deptno IN (10, 20);

--HAVING절
SELECT deptno, COUNT(*), SUM(sal)
FROM emp
WHERE COUNT(*) >= 4     --WHERE절에서 GROUP 함수 사용불가. --따라서 HAVING절에서 사용.
GROUP BY deptno;
--수정
SELECT deptno, COUNT(*), SUM(sal)
FROM emp
--WHERE COUNT(*) >= 4
GROUP BY deptno
HAVING COUNT(*) >= 4;

--사원테이블에서 전체 월급이 5000불을 초과하는 각 업무에 대해 업무이름과 월 급여의
--합계를 출력하라. 단, 판매원은 제외하고 월급여 합계의 내림차순으로 출력하라.
SELECT job, SUM(sal)
FROM emp
WHERE job NOT LIKE 'SA%'
GROUP BY job
HAVING SUM(sal) > 5000
ORDER BY SUM(sal) DESC;

--그룹화와 관련된 여러 함수
--ROLLUP함수
--합계, 평균 등을 볼때, 산출근거를 보여줌.
--deptno, job과 SELECT의 다른 함수가 행이 다르지만 GROUP BY에 의해 오류 안남.
SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY ROLLUP(deptno, job)
ORDER BY deptno, job;

--CUBE함수
--직무별로 통계 보여줌.
SELECT deptno, job, COUNT(*), SUM(sal), TRUNC(AVG(sal))
FROM emp
GROUP BY CUBE(deptno, job)
ORDER BY deptno, job;

--212page Q1
SELECT deptno, TRUNC(AVG(sal)) AS "AVG_SAL",
            MAX(sal) AS "MAX_SAL", MIN(sal) AS "MIN_SAL",
            COUNT(*) AS "CNT"
FROM emp
GROUP BY deptno;

--212page Q2
SELECT job, COUNT(*)
FROM Emp
GROUP BY job
HAVING COUNT(*) >= 3;

--212page Q3
--입사연도를 기준으로 부서별로 몇명이 입사했는지 출력.
SELECT   TO_CHAR(hiredate, 'YYYY') AS "HIRE_YEAR", deptno,
                COUNT(*) AS "CNT"
FROM        emp
GROUP BY TO_CHAR(hiredate, 'YYYY'), deptno;
--4자리 연도 기준으로 부서번호 기준으로 정렬.


--212page Q4
--추가수당을 받는 사원의 수와 받지 않는 수 출력.
SELECT NVL2(comm, 'O', 'X') AS "EXIST_COMM", COUNT(*) AS "CNT"
FROM  emp
GROUP BY NVL2(comm, 'O', 'X');
--NVL의 파라미터 : 데이터 타입 일치  ex) NVL(comm, 0) -> 숫자, 숫자 형
--NVL2의 파라미터 : 데이터 타입 일치 안해도 됨.

--212page Q5
--각 부서의 입사 연도 별 사원 수, 최고 급여, 급여 합, 평균 급여 출력
--각 부서별 소계와 총계 출력.
SELECT deptno, TO_CHAR(hiredate, 'YYYY') AS "HIRE_YEAR",
                COUNT(*) AS "CNT", MAX(sal), SUM(sal), AVG(sal)
FROM emp
GROUP BY ROLLUP(deptno, hiredate)
ORDER BY deptno, hiredate;

--강사님 5-1 PDF 5번
--emp table에서 등록되어 있는 인원수, 보너스가 NULL이 아닌 인원수,
-- 보너스의 전체평균, 등록되어 있는 부서의 수를 구하여 출력.
SELECT  COUNT(*) AS "인원수", COUNT(comm),
            AVG(comm), SUM(comm) / 4, AVG(NVL(comm, 0)), SUM(comm) / 14,
            COUNT(DISTINCT deptno)
FROM   emp;
--193행 : 평균의 다른 표현.


--강사님 5-1 PDF 8번
--각 부서별 같은 업무를 하는 사람의 인원수를 구하여
--부서번호, 업무명, 인원수를 출력.
SELECT deptno, job, COUNT(*)
FROM  emp
GROUP BY deptno, job;


--강사님 5-1 PDF 10번
--각 부서별 평균 월급, 전체 월급, 최고 월급, 최저 월급을 구하여
--평균 월급이 많은 순으로 출력.
SELECT TRUNC(AVG(sal)), SUM(sal), MAX(sal), MIN(sal)
FROM emp
GROUP BY deptno
ORDER BY AVG(sal) DESC;


---------------------조인-------------------------------------
--1. 교차조인, Cartesian Product, 데카르트 곱, Cross Join
--두 개의 테이블을 그냥 붙여버린 것
--실무에서 잘 안씀

--scott.emp.deptno : 스키마 scott소속의 emp테이블 소속의 deptno
SELECT  scott.emp.empno, scott.emp.ename, scott.emp.sal, 
            scott.dept.dname, scott.dept.loc, scott.dept.deptno
FROM emp, dept;
--교차조인 : 모든 경우의 수로 조합되어 출력.
--총 56개 = 부서 번호 당 emp의 14명 사원 = 14 * 4.

--테이블 별칭 사용
SELECT dname, loc, d.deptno, empno, ename, sal
FROM dept   d, emp    e;
--4 * 14 (하나 당 14번)

--표준 CROSS JOIN
SELECT dname, loc, d.deptno, e.empno, e.ename, e.sal
FROM dept   d CROSS JOIN emp  e;


--2. Equi Join (등가조인)(내부조인)(단순조인)(조인) = (조인의 90%)
--비표준 등가 조인
--서로 다른 테이블에서 데이터 가져와야함

--SMITH는 어느 부서에 있는가? (emp테이블에서 부서 가져와야함)
SELECT ename, deptno
FROM emp
WHERE ename = 'SMITH';
--그 부서는 어디에 있는가?  (dept테이블에 근무위치 있음)  (emp테이블의 부서 번호에 맞는 dept테이블에서의 위치 가져옴)
SELECT deptno, loc
FROM dept
WHERE deptno = 20;
--비표준 등가 조인 (조건 WHERE에서 = 써서 등가 조인이라 함) (WHERE에서 = 안쓰면 비등가 조인)
SELECT empno, ename, sal, dname, loc, d.deptno
FROM  emp e, dept d
WHERE e.deptno = d.deptno AND e.ename = 'SMITH';

--표준 등가 조인 (FROM에 조인조건 사용)
SELECT empno, ename, sal, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE ename = 'SMITH';

--표준 등가 조인(FROM절에 조인조건 사용)
SELECT empno, ename, sal, dname, loc, deptno
FROM emp NATURAL JOIN dept;