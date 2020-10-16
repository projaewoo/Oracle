--1. 모든 row와 모든 column 조회하기
SELECT ALL *  --ALL : 모든 low, * : 모든 column
FROM salgrade;

--2. 모든 row와 특정 column 조회하기
SELECT empno, ename
FROM emp;

--부서테이블에서 부서번호와 부서명 조회하기
SELECT  deptno, dname
FROM    dept;

--사원테이블에서 사원번호와 부서번호 조회하기
SELECT  empno, deptno
FROM    emp;

--사원테이블에서 직무를 조회하기
SELECT  DISTINCT job            --DISTINCT : 중복 제거
FROM    emp;

--사원테이블에서 사원들은 몇 개의 부서에 소속되어 있습니까? (자연어)
SELECT  DISTINCT deptno
FROM    emp;

--3. 별칭 사용하기
SELECT  empno AS "사원번호"  , ename  AS  "사원이름"
FROM    emp;

SELECT  sal * 12 + NVL(COMM, 0) AS "연봉"
FROM    emp;

--사원테이블에서 사번, 사원의 이름, 직무, 월급, 보너스, 연봉을 조회하시오.
--단, 연봉은 내림차순으로 출력하시오.
SELECT  empno AS "사번", ename AS "사원의 이름", job AS "직무",
        sal AS "월급", comm AS "보너스",
        sal * 12 + NVL(COMM, 0) AS "연봉"
FROM    emp
ORDER BY "연봉" DESC;

--4. 정렬하기
--사원테이블에서 부서번호로 오름차순 정렬하고, 월급을 내림차순으로 정렬하시오.
SELECT  deptno, sal
FROM    emp
ORDER BY deptno ASC, sal DESC;

--92page Q3
--조건1
SELECT  *
FROM    emp;

--조건2
SELECT  empno AS "EMPLOYEE_NO", ename AS "EMPLOYEE_NAME",
        MGR AS "MANAGER", SAL AS "SALARY", 
        COMM AS "COMMISION", DEPTNO AS "DEPARTMENT_NO"
FROM    emp;

--조건3
SELECT  empno, ename
FROM    emp
ORDER BY empno DESC, ename ASC;

--5. NULL 처리
--NVL()함수
--SELECT  NVL(commm, 'NULL')
--comm : 숫자형태이므로 숫자형으로 변환
SELECT NVL(mgr, 0)
FROM    emp;

--6. 문자열 연결하기
SELECT  'HELLO' || ', WOLRD'
FROM    dual;

SELECT  '사원번호 ' || empno || '는 ' || ename || '입니다.'
FROM    emp;

--7. 조건절
--ALL 숨겨져있어서 모든 사원의 ename, job, sal 가져옴.
SELECT  ename, job, sal
FROM    emp
WHERE   deptno = 10;

SELECT  sal
FROM    emp
WHERE   empno = 7782;

--사원테이블에서 부서번호가 20번 부서에 속해있는
--사원 중에 월급이 1000불 이하인 사원의 정보를 조회하시오.
SELECT  *
FROM    emp
WHERE   deptno = 20 AND sal <= 1000;

SELECT  sal
FROM    emp
WHERE   empno = 7369;

--사원테이블에서 부서번호가 10번이거나 월급이 3000불에서 5000불 사이인 사원의 
--사번, 이름, 월급, 부서번호를 조회하시오.
SELECT  empno, ename, sal, deptno
FROM    emp
WHERE   deptno = 10 OR (sal >= 3000 AND sal <= 5000);


SELECT          deptno, dname, loc
FROM              dept
WHERE           deptno NOT IN(10, 20);
--WHERE NOT (deptno = 10 OR deptno = 20);

--사원테이블에서 직무가 SALESMAN이거나 MANAGER이거나 PRESIDENT인 사원의
--사원이름, 직무를 조회하시오.
SELECT      ename, job
FROM        emp
WHERE       job IN('SALESMAN', 'MANAGER', 'PRESIDENT');
--WHERE   job = 'SALESMAN'   OR   job = 'MANAGER'   OR   job = 'PRESIDENT';