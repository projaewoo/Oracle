REM 테이블 생성 4가지 방법
--필요한 칼럼 선언해서
--기존의 테이블 복사
--기존 테이블 복사하되 스키마만 (구조만) 복사 (내용복사x)

CREATE TABLE emp_copy
AS 
SELECT * FROM emp;   --emp테이블 전체를 카피.  --14rows(열), 8cloumn(행) 카피.

SELECT * FROM emp_copy;



REM (INSERT INTO ~ VAULES ~)
--순서 주의
--데이터 타입 주의
--데이터 크기 주의
--literal 타입 (문자형, 날짜형, 숫자형) 주의
INSERT INTO emp_copy(empno, ename, mgr, hiredate)   --권장사항 : 칼럼 명시
VALUES (8001, 'CHULSU', 7369, SYSDATE);         --문자 데이터 : ' ' 사용.  --숫자 데이터 : ' ' 사용 X.

INSERT INTO emp_copy(empno, ename, job, sal)
VALUES (8002, 'YOUNGHEE', 'DESIGNER', 1500);

REM 테이블 삭제
DROP TABLE emp_copy;

REM 스키마 구조만 복사해서 테이블 생성
CREATE TABLE emp_copy
AS
SELECT * FROM emp
WHERE 0 > 1;            --dat는 복사하지 않고, schema만 복사하는 방법.(테이블 구조만 복사)  (조건에 논리적 오류 발생시킴)

SELECT * FROM emp_copy;   --data는 없고, 구조만 들어옴.

--만든 테이블에 데이터 입력
INSERT INTO emp_copy(empno, ename, sal, comm, deptno)
VALUES (1111, 'CHULSU', 800, 100, 40);

INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (2222, 'HANJIMIN', 'DEVELOPER', SYSDATE);
--데이터 개수가 맞지 않을 경우, ERROR.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (3333, 'YOUNGHEE', SYSDATE);         --갯수에 주의하자.
--데이터 타입 맞지 않을 경우  --숫자형 글자인 경우 -> 숫자로 자동 형변환.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES ('3333', 'YOUNGHEE', 'MARKETTER' ,SYSDATE);  
--데이터 타입 맞지 않을 경우  --글자 -> 숫자로 변환X.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES ('Hello', 'HOJUNE', 'MARKETTER' ,SYSDATE); 

--바이트 확인        --한글 : 한 글자당 3Byte.
SELECT LENGTH(ename), LENGTHB('안녕')
FROM emp_copy;

--데이터 사이즈보다 큰 데이터 입력할 경우 ERROR
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (4444, '소녀시대', 'MARKETTER' ,SYSDATE);        --data size 주의.



REM NULL 처리.
--암시적 입력   --값을 넣지 않은 열 : 자동으로 NULL로 채움.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (4444, 'HOJUNE', 'MARKETTER' ,SYSDATE);    --나머지 4개의 열은 자동으로 null 처리.

--명시적으로 NULL처리 (권장)   --값을 넣지 않은 열 : 자동으로 NULL로 채움. & NULL로 써준 곳도 NULL.
INSERT INTO emp_copy(empno, ename, job, hiredate)
VALUES (5555, UPPER('girlsday'), NULL, NULL);



REM 날짜 데이터 입력.
INSERT INTO emp_copy(empno, ename, hiredate)
VALUES (6666, UPPER('bts'), TO_DATE('01-02-2019', 'MM-DD-YYYY'));



REM Foreign Key 주의
SELECT deptno FROM dept;
--외래키 주의.
INSERT INTO emp(empno, ename, deptno)           --테이블 복사하면 제약조건은 복사X (emp_copy테이블에는 제약조건 복사 X (프라이머리키, 외래키 복사 X)).   --따라서 emp_copy에는 77번 부서 들어가짐.
VALUES(8888, 'JIMIN', 77);          --77번이라는 부서번호 없어서 77번 부서에 들어갈 수 없음.  --Foriegn Key에 주의.
--부모가 먼저 77번 부서 만들어야 자식이 77번 부서 들어갈 수 있음


--테이블 삭제.
DROP TABLE emp_copy;
--테이블 다시 생성.  (JDBC에서 INSERT하기 위해 미리 만들어놓음)
CREATE TABLE emp_copy
AS
SELECT * FROM emp
WHERE 0 > 1;  --가져올 조건. (불가능한 조건) (data 복사 X, schema만 복사)  --논리적 오류 발생 -> data 날라감. (data 안들어옴)



REM (UPDATE ~ SET ~ WHERE ~)

--테이블 확인
SELECT * FROM emp_copy;
--테이블 전체 수정  --(드물지만 WHERE절 사용 X)
UPDATE  emp_copy        --어떤 테이블을 수정할 것인가
SET deptno = 10;                --어떤 컬럼(열)을 수정할 것인가
--일부 행 수정. 
UPDATE  emp_copy                 
SET        sal = 1000               --어떤 칼럼(열)을 수정?
WHERE   empno < 3000;
--일부 수정 예제
UPDATE emp_copy
SET  sal = 2000
WHERE ename = UPPER('jimin');

--일부 열 수정.  (동시에 3개 변경) (, 사용) (순서는 섞여도 됨)
UPDATE   emp_copy
SET         job = 'DESIGNER', mgr = 1111, sal = 3000, deptno = 20
WHERE   empno = 4444;

--ERROR 상황
UPDATE  emp
SET     deptno = 70
WHERE   ename = 'SMITH';

UPDATE emp_copy 
SET mgr = 2222, sal = 1500, comm = 100 
WHERE empno = 5555;
--메모리 상에서 작업했던 내용들이 DB에 반영.
COMMIT;



REM (DELETE FROM ~ WHERE ~ )

--emp_copy의 모든 데이터 삭제.   (WHERE 사용 X)   (매우 위험) (되도록 사용 금지)
DELETE FROM emp_copy;               --테이블의 모든 데이터 삭제
--롤백 : 원위치
ROLLBACK;

--특정 레코드(행) 삭제
DELETE FROM emp_copy
--WHERE empno < 3000;           --2개의 행 삭제 
WHERE ename = 'JIMIN';         --1개의 행 삭제.



REM 287Page 연습문제
--문제 풀기 위한 연습 테이블 생성.
CREATE TABLE CHAP10HW_EMP
AS SELECT * FROM emp;
CREATE TABLE CHAP10HW_DEPT
AS SELECT * FROM dept;
CREATE TABLE CHAP10HW_SALGRADE
AS SELECT * FROM salgrade;

--Q1 : CHAP10HW_DEPT테이블에 50, 60, 70, 80부서를 등록
INSERT INTO CHAP10HW_DEPT (deptno, dname, loc)
VALUES(50, 'ORACLE', 'BUSAN');
INSERT INTO CHAP10HW_DEPT (deptno, dname, loc)
VALUES(60, 'SQL', 'ILSAN');
INSERT INTO CHAP10HW_DEPT (deptno, dname, loc)
VALUES(70, 'SELECT', 'INCHEON');
INSERT INTO CHAP10HW_DEPT (deptno, dname, loc)
VALUES(80, 'DML', 'BUNDANG');
--제대로 INSERT 되었는지 확인
SELECT * FROM CHAP10HW_DEPT;

--Q2
INSERT INTO CHAP10HW_EMP
VALUES  (7201, 'TEST_USER1', 'MANAGER', 7788, TO_DATE('2016-01-02', 'YYYY-MM-DD'), 4500, NULL, 50);
INSERT INTO CHAP10HW_EMP
VALUES  (7202, 'TEST_USER2', 'CLERK', 7201, TO_DATE('2016-02-21', 'YYYY-MM-DD'), 1800, NULL, 50);
--제대로 INSERT 되었는지 확인
SELECT * FROM chap10hw_emp;
--Q2 : 강사님 해설
--암시적 NULL처리
INSERT INTO CHAP10HW_EMP (empno, ename, job, mgr, hiredate, sal, deptno)
VALUES (7201, 'TEST_USER1', 'MANAGER', 7788, TO_DATE('2016-01-02', 'YYYY-MM-DD'), 4500, 50);
--명시적 NULL처리
INSERT INTO CHAP10HW_EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (7202, 'TEST_USER2', 'CLERK', 7201, TO_DATE('2016-02-21', 'YYYY-MM-DD'), 1800, NULL, 50);

--Q3
--50번 부서의 평균급여.
SELECT AVG(sal) FROM CHAP10HW_EMP
WHERE deptno = 50;
--UPDATE
UPDATE   CHAP10HW_EMP
SET  deptno = 70
WHERE sal > 3150;
--테이블 확인
SELECT * FROM CHAP10HW_EMP;

--20번 부서의 사원 중 입사일이 가장 늦은 사원보다 더 늦게 입사한
--사원의 급여를 10% 인상, 80번 부서로 이동.

--1step : 20번 부서 사원 중 입사일이 느린 사람의 입사일.
SELECT  MAX(hiredate)               --날짜형 데이터 : 숫자처럼 MAX, 크기비교 가능.
FROM   CHAP10HW_emp
WHERE deptno = 20;          --87년 7월 13일
--2step : 사원의 급여 10% 인상, 80번 부서로 이동
UPDATE   CHAP10HW_emp
SET       deptno = 80, sal = sal * 1.1
WHERE hiredate > TO_DATE('1987-07-14', 'YYYY/MM/DD');
--테이블 확인
SELECT * FROM CHAP10HW_emp;


--289Page Q5 : CHAP10HW_EMP에 속한 사원 중, 급여 등급이 5인 사원을 삭제
--1step : 급여등급이 5인 사원.
--비등가 조인, 표준 조인
SELECT *
FROM CHAP10HW_EMP INNER JOIN salgrade ON (sal BETWEEN losal AND hisal)
WHERE grade = 4;     --7839, 7201
--2step : 삭제.
DELETE FROM  chap10hw_emp
WHERE empno IN (7839, 7201);
--테이블 확인.
SELECT * FROM CHAP10HW_EMP;


--SQL Devloper상에서는 INSERT될 수 있으나 COMMIT까지 해야 실제 DB에 반영.
INSERT INTO Student
VALUES ('2020-01', '한지민', 100, 100, 100, 300, 100.00, 'A');

COMMIT;