REM 서브쿼리
--문제 JONES보다 급여가 높은 사원
SELECT *
FROM emp
WHERE ename = UPPER('jones');       --JONES의 급여 : 2975불.

SELECT *
FROM emp
WHERE sal > 2975;
--위의 SELECT문을 합친 서브쿼리.
SELECT *
FROM emp
WHERE sal > (SELECT sal
                    FROM emp
                    WHERE ename = UPPER('jones'));
                    
--밀러보다 먼저 입사한 사원
SELECT *
FROM emp
WHERE hiredate < (SELECT hiredate
                            FROM emp
                            WHERE ename = UPPER('miller'));
            
--단일행 서브쿼리.
--표준 조인
--오라클 : 무조건 SELECT ~ FROM 써줘야함.
SELECT empno, ename, job, sal, deptno, dname, loc
FROM emp NATURAL JOIN dept
WHERE deptno = 20 AND sal > (SELECT AVG(sal)
                                                FROM emp);      --오라클 : 무조건 SELECT ~ FROM 써줘야함.
                                                
--복수행 서브쿼리.
--부서에서 최소 급여 받는 사원
--복수행 서브쿼리의 IN 함수.
SELECT *
FROM emp
WHERE sal = ANY (SELECT MIN(sal)         --IN : 셋 중 하나.  --IN은 = ANY와 일치.
                        FROM emp
                        GROUP BY deptno);

--임의로 삽입된 행을 삭제.                        
DELETE FROM emp
WHERE empno = 7521;

--복수행 서브쿼리의 ANY함수.
SELECT empno, ename, job
FROM emp
WHERE sal < ANY (SELECT sal
                            FROM emp
                            WHERE job = 'CLERK');
                            
--사원번호 7369, 7499과 같은 상사와 부서번호를 갖는 모든 사원의 번호와 상사번호 및 부서번호 출력.
--단 7369, 7499는 제외.
SELECT empno, mgr, deptno
FROM  emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                                        FROM emp
                                        WHERE empno IN (7369, 7499))        --결과값 : 복수행 -> 따라서 복수행 쿼리 사용.
            AND empno NOT IN (7369, 7499);
            
--262page Q1
--전체 사원 중 ALLEN과 같은 직책인 사원들의 사원정보, 부서 정보 출력.
SELECT job, empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE job = (SELECT job
                        FROM emp
                        WHERE ename = 'ALLEN');
                        
--Q2 : 전체 사원의 평균 급여보다 높은 급여를 받는 사원들의 사원정보, 부서정보, 급여등급 정보를 출력.
--급여가 많은 순으로 정렬, 급여 같을 경우 사원번호를 오름차순으로 정렬.

SELECT empno, ename, dname, hiredate, loc, sal, grade
FROM emp INNER JOIN dept ON (emp.deptno = dept.deptno)      --등가조인
                INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)    --grade
WHERE sal > (SELECT AVG(sal) FROM emp)      --단일행 서브쿼리 : > 연산자 사용.
ORDER BY sal DESC, empno ASC;

--Q3 : 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원정보, 부서정보 출력.
           
--강사님 풀이
SELECT empno, ename, job, e.deptno, dname, loc      --JOIN ~ ON ~ : 애매한 칼럼에 식별자 사용.
FROM emp e INNER JOIN dept d ON(e.deptno = d.deptno)
WHERE e.deptno = 10 AND job NOT IN (SELECT job                  --복수행 서브쿼리 NOT IN 사용.
                                                            FROM emp 
                                                            WHERE deptno = 30);     --행이 6개이므로 복수행 서브쿼리 사용.
                                                            
-- Q4 : 직책이 SALEMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원정보, 급여등급 정보를 출력.
--단, 서브쿼리 활용 시, 다중행 함수 사용방법과 단일행 함수 사용방법으로.
--사원번호를 오름차순으로 정렬.

--단일행 함수
SELECT empno, ename, sal, grade
FROM emp INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)
WHERE  sal >   (SELECT MAX(sal)                         --단일행 연산자 : > 사용.
                        FROM emp
                        WHERE job = UPPER('salesman'))     --출력값 : 단일행.
ORDER BY empno ASC;
--다중행함수 사용
SELECT empno, ename, sal, grade
FROM emp INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)
WHERE  sal >  ALL (SELECT MAX(sal)                          --다중행 함수 : ALL.  
                             FROM emp
                             WHERE job = UPPER('salesman'))    
ORDER BY empno ASC;


--연습용 테이블 생성.
CREATE TABLE emp_temp (empno, ename, job, hiredate)
AS
SELECT  empno, ename, job, hiredate
FROM emp
WHERE 1 = 0;        --구조만 복사    --제약조건은 복사 X.

--INSERT문에 사용하는 서브쿼리.
--한번에 3개 입력.
--SELECT문으로 한 번에 여러 행의 데이터 추가 가능.
INSERT INTO emp_temp (empno, ename, job, hiredate)
SELECT empno, ename, job, hiredate
FROM emp
WHERE deptno = 10;


REM TCL
--SQL Plus에서 KING을 삭제해도 COMMIT하지 않으면 원본 DB에 삭제 X
--따라서, SQL Developer에서 KING조회 가능.
SELECT * FROM emp
WHERE ename = 'KING';



REM SAVEPOINT
COMMIT;     --14:16    --롤백하면 여기로 돌아옴.

INSERT INTO emp(empno, ename, hiredate)
VALUES (7777, '한지민', SYSDATE);

--SMITH의 월급 수정.
UPDATE emp
SET sal = 800
WHERE ename = 'SMITH';

UPDATE emp
SET sal = sal * 1.1
WHERE ename = 'SMITH';

--a라는 SAVEPOINT 생성.
SAVEPOINT a;        --14:19.        
SAVEPOINT b;        --14:22.

DELETE FROM emp
WHERE ename = 'SCOTT';

ROLLBACK;       --(가장 최근 COMMIT)14:16분의 COMMIT시점으로 돌아감.
ROLLBACK TO b;      --b의 SAVEPOINT로 넘어감.

COMMIT;


DESC emp_temp;

TRUNCATE TABLE emp_temp;

-- 제약조건 부여
ALTER TABLE emp_temp
ADD CONSTRAINT  emp_temp_empno_pk PRIMARY KEY(empno);    --테이블레벨 제약조건

--디폴트타입, NN제약조건 부여.
ALTER TABLE emp_temp
MODIFY hiredate DATE DEFAULT SYSDATE CONSTRAINT emp_temp_hiredate_nn  NOT NULL;