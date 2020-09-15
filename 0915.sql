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