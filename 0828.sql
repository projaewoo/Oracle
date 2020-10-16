REM 주석


--NLS파라미터의 값 확인
SELECT parameter, value
FROM NLS_SESSION_PARAMETERS;

--NLS파라미터의 NLS_DATE_FORMAT 변환  --ALTER ~ SET : SESSION 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

REM 숫자함수
--1. ROUND( )
SELECT ROUND(45.925, 2), ROUND(45.925, 0), ROUND(45.925, -1)        --소수점2, 0까지 보여줘 -- -1: 1자리에서 반올림
FROM DUAL;

--23. 부서번호가 20인 부서의 시간당 임금을 계산하여 출력하라. 단, 1달의 근무일수는 12일이고, 1
--일 근무시간은 5시간이다. 출력양식은 이름, 급여, 시간당 임금(소수이하 첫 번째 자리에서 반올림)
--을 출력하라

SELECT      sal, ROUND(sal / 12 / 5, 0)     -- = ROUND( sal / 12 / 5)
FROM       emp 
WHERE       deptno = 20;


--2. TRUNC( )
SELECT TRUNC(45.925, 2), TRUNC(45.925, 0), TRUNC(45.925, -1)       -- 2, 0 : 소수점 2, 0까지만 보여줘  -- -1 : 정수 1자리에서 잘라
FROM DUAL;

--3. CEIL, FLOOR( ) --CEIL : 천장 : 상한 --FLOOR : 바닥 : 하한
SELECT      ROUND(45.925, 2), TRUNC(42.924, 2), CEIL(45.925), FLOOR(45.925)
FROM        dual;

SELECT      ROUND(-45.925, 2), TRUNC(-42.924, 2), CEIL(-45.925), FLOOR(-45.925)
FROM        dual;

--4. MOD( )
SELECT 15 / 6, MOD(15, 6)
FROM dual;

--5. NVL2( )
REM NVL1(column, express1) : NULL이면 express1으로 바꿔
REM NVL2(column, express1, express2) : null아니면 express1, null이면 express2
REM NULLIF : comm이 NULL과 같니? 같으면 NULL,  다르면 그대로 comm 출력
SELECT   deptno, comm, NVL(comm, 0), NVL2(comm, comm * 1.1, 0), NULLIF(comm, NULL)
FROM    emp
WHERE   deptno IN (10, 30)
ORDER BY deptno;

--6. NULLIF()
REM 스미스 월급 = 800 -> NULL ,  스미스 월급 != 800 --> 스미스 월급 그대로 출력
SELECT NULLIF(sal, 800)
FROM        emp
WHERE       ename = UPPER('smith');

--7. COALLESCE() : 널이 아닌 값 뽑아냄
SELECT comm, sal, NVL(comm, 0), NVL2(comm, comm * 1.1, 0), COALESCE(comm, sal) --comm이 null이면 sal찍고, comm : NULL이 아니면 자기 comm찍기.
FROM emp
WHERE deptno IN(10, 30);

SELECT deptno, comm, COALESCE(comm, 100)  --comm이 null이면 100찍고, comm이 null이 아니면 comm찍기
FROM emp
WHERE deptno IN (10, 30)
ORDER BY deptno ASC;

--9. DECODE
--부서번호에 따른 보너스
SELECT      deptno, sal, DECODE(deptno, 10, sal * 1.1, 20, sal * 1.5, 30, sal) AS "보너스"  --deptno : 10이면 10%, 20이면 50%, 30번이면 기본월급
FROM        emp
ORDER BY deptno ASC;

--직무 별 보너스
SELECT    job, sal,
                DECODE(job, 'ANALYST', sal * 0.1, 
                                    'CLERK', sal * 0.2,
                                        'MANAGER', sal * 0.3,
                                            0) AS "보너스" --  'ANALYST'면 보너스 : 10%, 클락(일반 회사원)이면 20%, 매니저면 30%, 기타 나머지는 기본급
FROM    emp
ORDER BY   job;

-- 입사년도에 따른 직급 부여
--80년 입사 : 이사, 81년 입사 : 부장, 82년 입사 : 과장, 87년 입사 : 사원
SELECT   ename, CONCAT(' --> ', TO_CHAR(hiredate, 'YYYY')) AS "입사년도",
                DECODE(TO_CHAR(hiredate, 'YYYY'), '1980', '이사',
                                                                '1981', '부장',
                                                                    '1982', '과장',
                                                                        '사원') AS "직급"
FROM    emp
ORDER BY "입사년도";


--10. CASE()
SELECT      deptno, sal, DECODE(deptno, 10, sal * 1.1, 20, sal * 1.5, 30, sal) AS "보너스"  --deptno : 10이면 10%, 20이면 50%, 30번이면 기본월급
FROM        emp
ORDER BY deptno ASC;

--92~94행을 CASE()로 변환
SELECT      deptno, sal,
                CASE
                    WHEN deptno = 10  THEN sal * 1.1
                    WHEN deptno = 20   THEN sal * 1.5
                    ELSE  sal
                END AS "보너스"
FROM   emp
ORDER BY deptno ASC;

--직급별 보너스를 DECODE로 구현
SELECT    job, sal,
                DECODE(job, 'ANALYST', sal * 0.1, 
                                    'CLERK', sal * 0.2,
                                        'MANAGER', sal * 0.3,
                                            0) AS "보너스" --  'ANALYST'면 보너스 : 10%, 클락(일반 회사원)이면 20%, 매니저면 30%, 기타 나머지는 기본급
FROM    emp
ORDER BY   job;

--직급별 보너스를 CASE로 구현
SELECT    job, sal,
            CASE
                WHEN  job = 'ANALYST' THEN  sal * 0.1
                WHEN  job = 'CLERK'     THEN  sal * 0.2
                WHEN  job = 'MANAGER' THEN sal * 0.3
                ELSE   0
            END AS "보너스"
FROM    emp
ORDER BY   job;

--hiredate에서 "입사년도", "직급" 출력.
SELECT      ename, TO_CHAR(hiredate, 'YYYY') AS "입사년도",
                CASE
                    WHEN TO_CHAR(hiredate, 'YYYY') = '1980' THEN '이사'
                    WHEN TO_CHAR(hiredate, 'YYYY') = '1981' THEN '부장'
                    WHEN TO_CHAR(hiredate, 'YYYY') = '1982' THEN '과장'
                    ELSE '사원'
                END AS "직급"
FROM        emp
ORDER BY       "입사년도";


--오늘 날짜 출력
SELECT sysdate
FROM dual;

--오늘부터 5일 뒤의 날짜 출력
SELECT sysdate + 5
FROM dual;

--날짜함수
SELECT      ename, hiredate, TRUNC(TRUNC(sysdate - hiredate) / 365) || '년째 근무',  --입사한지 몇년째 되는지 소숫점 이하 절삭
                TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) || '개월 째 근무'
FROM        emp
WHERE       deptno = 10;

--지금으로부터 5개월 뒤
SELECT ADD_MONTHS(SYSDATE, 5)
FROM dual;

--다음 금요일의 날짜형식 출력
SELECT NEXT_DAY(SYSDATE, '금요일')
FROM dual;

--다다음주 월요일 출력
SELECT NEXT_DAY(NEXT_DAY(SYSDATE, '월요일'), '월요일')
FROM dual;

--다음달의 마지막 날
SELECT LAST_DAY(ADD_MONTHS(SYSDATE, 1))
FROM dual;

--오늘의 3개월 전의 연도 반올림 --2020년 5월 28일 기준으로 연도 반올림
SELECT     ROUND(ADD_MONTHS(SYSDATE, -3), 'YEAR')
FROM    dual;


SELECT  ROUND(SYSDATE, 'YEAR'), TRUNC(SYSDATE, 'YEAR')
FROM dual;