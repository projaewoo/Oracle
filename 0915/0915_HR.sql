SELECT COUNT(*)
FROM employees;


--부서별 평균 월급
SELECT department_id, TRUNC(AVG(salary))
FROM  employees
GROUP BY department_id;

--189page 실습 7-19
SELECT ename, deptno, AVG(sal)     --행의 개수 다르므로 에러.
FROM emp
GROUP BY deptno;

--오라클 상위버전에서는 오류 X
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