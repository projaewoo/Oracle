REM 비표준 비등가조인, NON - Equi Join --조인조건에 =연산자 사용 X.
SELECT empno, ename, sal, grade
FROM emp, salgrade
--WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
WHERE emp.sal >= salgrade.losal AND emp.sal <= salgrade.hisal;   --식별자 생략 가능.

--비등가조인의 표준조인
SELECT empno, ename, sal, losal, hisal, grade
FROM emp INNER JOIN salgrade ON sal BETWEEN losal AND hisal;

--비표준 등가조인
--emp테이블에서 40번 부서 없음 --등가조인 : 공통칼럼의 같은 데이터만 가져옴. --등가조인은 40번 부서 제외하고 조인.
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp, dept
WHERE  emp.deptno = dept.deptno;



REM OUTER JOIN (외부조인)
--비표준 외부조인 --OUTER JOIN --정보 부족한 쪽에 (+) 연산자.
--emp테이블 쪽에 정보가 더 부족
--RIGHT OUTER JOIN
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp, dept
WHERE  emp.deptno(+) = dept.deptno;   --40번 부서에 소속된 사원은 없음. --RIGHT OUTER JOIN : +연산자가 왼쪽에 있음.  --NULL이 출력됨 : emp테이블이 정보 부족.

--비표준 외부조인 (LEFT OUTER JOIN)
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp, dept
WHERE  emp.deptno = dept.deptno(+); --LIFT OUTER JOIN : +연산자가 오른쪽에 있음.  --혹시 dept테이블 쪽에 부족한 정보 있으면 다 보여줘.  --NULL이 안나옴 = 모든 사원은 부서에 소속되어 있음. = 소속이 없는 사원은 없음.

--FULL OUTER JOIN
--비표준에서는 지원 X
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp, dept
WHERE  emp.deptno(+) = dept.deptno(+);

--FULL OUTER JOIN을 비표준에서 사용하는 방법 : UNION 사용 (왼쪽, 오른쪽을 합침)
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp, dept
WHERE  emp.deptno(+) = dept.deptno
UNION
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp, dept
WHERE  emp.deptno = dept.deptno(+);

--표준 OUTER 조인
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp RIGHT OUTER JOIN dept ON emp.deptno = dept.deptno;      --RIGHT OUTER JOIN : 왼쪽에 (+)연산자 : 왼쪽에 정보 더 부족.

REM 표준 조인으로 FULL OUTER JOIN하기.
SELECT  empno, ename, emp.deptno, dept.deptno, dname, loc
FROM    emp FULL OUTER JOIN dept ON emp.detpno = dept.deptno;


REM SELF JOIN
--자기가 자기 테이블을 참조 (scott스키마에서 emp 테이블이 emp 테이블을 참조.)
-- SELF JOIN, 비표준 조인 --반드시 별칭 사용 (헷갈리므로)
SELECT  부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
FROM   emp 부하, emp 상사
WHERE  부하.mgr = 상사.empno;    --부하의 매니저 번호 = 상사의 사원번호.
--SELF JOIN , 표준 조인
SELECT 부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
FROM  emp 부하 INNER JOIN emp 상사 ON 부하.mgr = 상사.empno;
--SELF JOIN , 비표준 조인, LEFT OUTER JOIN
SELECT  부하.empno, 부하.ename, 부하.mgr, 상사.empno, 상사.ename
FROM   emp 부하, emp 상사
WHERE  부하.mgr = 상사.empno(+);   --부하의 직원 다 나오고, 그에 맞춰서 상사가 없는 사람까지 나옴.

--문제 : "SMITH의 매니저는 FORD이다." 출력.
--SELF JOIN,  표준 조인 (JOIN ~ ON절)
SELECT  부하.ename || '의 매니저는 ' || 상사.ename || '이다.'
FROM   emp 부하 INNER JOIN emp 상사 ON 부하.mgr = 상사.empno;
--문제 : 매니저가 없는 사람도 출력.
--정보 부족한 쪽 : 오른쪽 (왼쪽이 기준) (부하 emp테이블이 기준) -> LEFT JOIN ~ ON 사용.
SELECT  부하.ename || '의 매니저는 ' || NVL(상사.ename, 'N/A') || '이다.'
FROM   emp 부하 LEFT JOIN emp 상사 ON 부하.mgr = 상사.empno;


REM 239page Q1
--급여(SAL)가 2000 초과인 사원들의 부서정보, 사원정보를 출력.
--비표준 조인, 등가조인
SELECT  dept.deptno, dname, empno, ename, sal
FROM   dept, emp
WHERE  dept.deptno = emp.deptno AND sal > 2000;
--표준 조인, JOIN ~ ON 절
SELECT dept.deptno, dname, empno, ename, sal
FROM dept INNER JOIN emp ON dept.deptno = emp.deptno
WHERE sal > 2000;


--234page Q2
--부서 별 -> GROUP BY절 사용.  -- dept.deptno, dname : 14개 행 나옴 // 나머지는 그룹 함수 : 1개 행만 나옴. //따라서 dept.deptno, dname을 GROUP BY 절로 묶어줌.
--비표준 조인, Equi JOIN
SELECT  dept.deptno, dname, TRUNC(AVG(sal)), MAX(sal), MIN(sal), COUNT(sal) AS "CNT"
FROM   dept, emp
WHERE  dept.deptno = emp.deptno
GROUP BY dept.deptno, dname;
--표준 조인,
SELECT  dept.deptno, dname, TRUNC(AVG(sal)), MAX(sal), MIN(sal), COUNT(sal) AS "CNT"
FROM   dept INNER JOIN emp ON dept.deptno = emp.deptno
GROUP BY dept.deptno, dname;

--234page Q3
--비표준 조인, RIGHT OUTER JOIN (오른쪽 : 정보 부족한 쪽의 테이블 (OPERATIONS의 empno, ename 등의 정보 없게 출력해야하므로.)
SELECT  dept.deptno, dname, empno, ename, job, sal
FROM   dept, emp
WHERE dept.deptno = emp.deptno(+)
ORDER BY dept.deptno, ename;
--표준 조인, LEFT OUTER JOIN ~ ON (오른쪽 : 정보 부족한 쪽의 테이블) (deptno = 40번인 데이터의 empno, ename 등의 정보 없게 출력해야 하므로)
SELECT  dept.deptno, dname, empno, ename, job, sal
FROM   dept LEFT OUTER JOIN emp ON dept.deptno = emp.deptno
ORDER BY dept.deptno, ename;

--234page Q4
--SELF JOIN (직속상관 부서 찍어야함)
--OUTER JOIN (모든 부서 출력)
--비표준 조인
SELECT dept.deptno AS DEPTNO, dname, 부하.empno AS EMPNO, 부하.ename AS ENAME, 부하.mgr AS MGR, 부하.sal AS SAL,
            부하.deptno DEPTNO_1 , losal, hisal, grade,
            상사.empno  MGR_EMPNO, 상사.ename  MGR_ENAME     --충돌날 수 있는 칼럼만 식별자 사용.
FROM   dept, emp 부하, salgrade, emp 상사
WHERE (dept.deptno = 부하.deptno(+) )            --포괄 조인
            AND (부하.sal BETWEEN losal(+) AND hisal(+) )    --비등가조인 (emp와 salgrade는 BETWEEN A AND B)  --losal(+), hisal(+) : OPERATIONS행에서 losal, hisal도 null나와야하므로
            AND 부하.mgr = 상사.empno(+)           --Self Join (부족한 쪽에 + 연산자 사용) --MGR_EMPNO, MGR_ENAME에
ORDER BY dept.deptno, 부하.empno;

--표준 조인
SELECT dept.deptno AS DEPTNO, dname, 부하.empno AS EMPNO, 부하.ename AS ENAME, 부하.mgr AS MGR, 부하.sal AS SAL,
            부하.deptno DEPTNO_1 , losal, hisal, grade,
            상사.empno  MGR_EMPNO, 상사.ename  MGR_ENAME     --충돌날 수 있는 칼럼만 식별자 사용.
FROM  dept LEFT OUTER JOIN emp 부하 ON (dept.deptno = 부하.deptno)      --123행을 표준조인으로 변환.
            LEFT OUTER JOIN salgrade ON (부하.sal BETWEEN losal AND hisal)  --124행을 표준조인으로 변환.
            LEFT OUTER JOIN emp 상사 ON (부하.mgr = 상사.empno)    --125행을 표준조인으로 변환.
ORDER BY dept.deptno, 부하.empno;



REM INSERT : 테이블에 새로운 데이터 추가
--INSERT INTO 테이블명 VALUES(값들...)
--1. ' ' 사용할지 고민 --날짜형과 문자형 : 반드시 ' ' 를 사용.  --숫자형 : ' ' 사용 X.
--2. 순서 고민
--3. literal의 사이즈 고민.
--4. literal type을 고민.
--5. NULL을 고민.

INSERT INTO dept
VALUES (50, 'DEVELOPMENT', 'SEOUL');            --dept테이블의 칸이 몇개? 채울게 몇개?  (50, 'DEVELOPER', 'SEOUL') =  (deptno, dname, loc)

INSERT INTO dept (loc, deptno, dname)   --테이블의 기본순서를 다르게 하려면.
VALUES ('BUSAN', 60, 'DESIGN');

--고민 4
--literal의 타입이 일치하지 않음.
--INSERT INTO dept (dname, loc, deptno)    --테이블의 기본순서를 다르게 하려면 반드시 명시해야함.
--VALUES (30, 40, 70);

--고민 5
--값의 수가 충분하지 않음.
--INSERT INTO dept (deptno, dname, loc)       --아직 부서 위치가 안정해졌다면
--VALUES (80, 'JAVA');

--고민 5
--NULL을 암시적으로 처리하자.
INSERT INTO dept (deptno, dname)            --아직 부서 위치가 안정해졌다면
VALUES (80, 'JAVA');                                -- loc은 NULL로 삽입됨.
--고민 5
--NULL을 명시적으로 처리하자.
INSERT INTO dept (deptno, dname, loc)
VALUES (90, 'ORACLE', NULL);                --loc은 NULL로 삽입.
