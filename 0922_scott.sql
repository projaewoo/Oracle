REM 1. 각 칼럼을 정의하면서 새로운 테이블 생성.
-- 환자의 번호, 진료코드, 입원일수, 나이, 진찰부서, 진찰비, 입원비, 진료비.
--환자 테이블  생성
CREATE TABLE Patient (
    bunho    NUMBER(1),                     --한글 : 논리적 모델   --영어 : 물리적 모델링.
    code      CHAR(2),
    days        NUMBER(3),      --108일도 있어서 3자리.
    age         NUMBER(3),      --100세 이상도 존재해서 3자리.
    departmet   VARCHAR(20),        --한글 최대 6자
    jinchalfee      NUMBER(4),          --천원 단위이므로 4자리.
    ipwonfee        NUMBER(7),          --백만 단위이므로 7자리.
    total               NUMBER(7)
);

-- 급여관리프로그램
--SalaryManagement 급여관리프로그램
--테이블 생성.
CREATE TABLE Employee (
    empno           NUMBER(4),             --한글 : 논리적 모델링, 영어 : 물리적 모델링
    grade               NUMBER(2),
    ho                  NUMBER(2),
    sudang              NUMBER(4),
    money               NUMBER(7),        --지급액
    tex                     NUMBER(4, 2),       --0.13, 1.05  등등 전체자리 4자리, 소숫점 이하 2자리.
    sal                     NUMBER(7)           --백만 단위이므로 7자리.
);

--테이블 삭제
DROP TABLE CHAP10HW_DEPT;
DROP TABLE CHAP10HW_EMP;
DROP TABLE CHAP10HW_SALGRADE;
DROP TABLE EMP_COPY;
DROP TABLE MEMBER;
DROP TABLE STUDENT1;



REM 2. 기존 테이블 열 구조와 데이터를 복사하여 새 테이블 생성
CREATE TABLE emp_copy
AS
SELECT * FROM emp;    --값 복사. (emp테이블 변경해도 emp_copy는 변경X)  --emp테이블의 구조, 데이터를 그대로 복사.  --단, 제약조건은 복사되지 않음.

SELECT * FROM emp_copy;
--값복사는 테이블의 스키마는 복사 안됨. (NULL여부 안나옴.)
DESC emp;                       --제약조건 있음 (NULL여부 있음)
DESC emp_copy;              --제약조건 없음.  (NULL여부 없음)

--10번 부서의 사람들만 들어있는 테이블 생성하기.
CREATE TABLE emp10
AS
SELECT * FROM emp
WHERE deptno = 10;
--테이블 확인.
SELECT * FROM emp10;

--직무가 SALESMAN인 사람들만 들어있는 테이블 생성하되,
--단, 사번, 이름, 직무, 봉급, 입사날짜만 생성하기
CREATE TABLE emp_salesman
AS
SELECT empno, ename, job, sal, hiredate
FROM emp
WHERE job = 'SALESMAN';
--테이블 확인
SELECT * FROM emp_salesman;

--사번, 이름, 부서이름, 위치, 부서번호를 포함하는 테이블을 생성하되,
--단, 부서번호가 10번과 20번만

--작성 순서 : 71행~74행을 먼저 돌리고, 그 위에 (69행~70행)을 붙임.
--단, 테이블 생성 시, 제약조건은 같이 안 만들어짐.
CREATE TABLE emp_dept
AS 
SELECT     empno, ename, dname, loc, deptno         --JOIN ~ USING, NATURAL JOIN : 식별자 사용 X
FROM emp INNER JOIN dept USING(deptno)
WHERE deptno IN (10, 20)
ORDER BY deptno ASC;



REM 3. 기존 테이블의 데이터 말고 열 구조만 복사하여 새 테이블 생성.
--WHERE절의 조건을 언제나 false나오도록 만듬.
CREATE TABLE emp_empty
AS
SELECT * FROM emp
WHERE 1 = 0;            --WHERE조건을 false로 나오도록 -> 구조만 복사.
--테이블 확인
SELECT * FROM emp_empty;            --data는 복사 안되고, 열 구조만 복사됨
--테이블 제약조건 확인
DESC emp_empty;                     --제약조건도 복사 X.

--문제 : 테이블을 복사해서 생성하되, 데이터 복사하지 말고, 구조만 복사
--사번, 이름, 직무, 부서이름, 부서위치, 부서번호를 생성.
CREATE TABLE emp_dept_1
AS
SELECT  empno, ename, job, dname, loc, detpno                 --NATURAL JOIN : 식별자 사용 불가.             
FROM  emp NATURAL JOIN dept             --알아서 두 테이블의 공통칼럼 찾음.
WHERE 1 < 0;



REM RENAME old_name TO new_name
-- RENAME old_name To new_name으로 테이블 이름 변경.
--emp_copy --> emp_boksa 이름 변경.
SELECT * FROM emp_copy;     --테이블 확인
--테이블 이름 변경.
RENAME emp_copy TO emp_boksa;
--테이블 확인
SELECT * FROM emp_copy;         --이름 변경했으므로 emp_copy테이블은 없음.
SELECT * FROM emp_boksa;


REM TRUNCATE : 테이블의 모든 데이터 삭제.  --열 구조는 남아있음.
TRUNCATE TABLE emp_boksa;



REM DROP
--자식 테이블이 참조하고 있으면 삭제 불가능.
DROP TABLE dept;                --자식 테이블의 외래키가 부모의 primary key를 가리킴



REM COMMENT ON TABLE, COMMENT ON COLUMN
--테이블, 칼럼(열)에 주석 달기.
COMMENT ON TABLE emp_boksa IS '이 테이블은 emp 테이블을 복사한 테이블입니다.';
--테이블의 주석 들어갔는지 확인.
DESC USER_tab_comments;     --tab : 테이블에 주석 달았으므로  
--테이블 주석 확인.
--반드시 주석을 달았다면 dictionary에서 확인하자.
DESC USER_tab_comments          --tab : 테이블에서 주석 달았으므로.
SELECT table_name, table_type, comments
FROM user_tab_comments
WHERE table_name = upper('emp_boksa');

--칼럼에 주석 달기
COMMENT ON COLUMN emp_boksa.hiredate IS '입사날짜를 저장하는 칼럼';
--칼럼의 주석 확인.
SELECT table_name, column_name, comments
FROM user_col_comments
WHERE table_name = upper('emp_boksa');

SELECT *
FROM user_col_comments;         --여기서 나오는 테이블 이름 : BIN~ : 이전에 삭제된 테이블 명.

--ALTER 사용하기 위한 이전 작업.
--테이블 삭제
DROP table emp_boksa;
DROP TABLE emp_dept;
DROP TABLE demp_dept_1;
DROP TABLE emp_empty;
DROP TABLE emp_salesman;
DROP TABLE emp10;
--테이블 추가
CREATE TABLE emp_copy10
AS
SELECT empno, ename
FROM emp
WHERE deptno = 10;
--테이블 생성 확인 및 구조 확인
DESC emp_copy10;
SELECT * FROM emp_copy10;


REM ALTER TABLE
--ALTER TABLE ~ ADD, DROP, MODIFY, RENAME 사용가능.
--테이블을 리모델링  (열 추가, 삭제, 열의 자료형, 길이 변경)

--ALTER TABLE ~ ADD ~
ALTER TABLE emp_copy10
ADD (job VARCHAR2(9));              --emp_copy10테이블에 job이라는 칼럼 (9Byte) 넣어줘.       --칼럼 추가 : 제일 마지막에 칼럼 들어감.   --데이터 : NULL로 들어감.

ALTER TABLE emp_copy10
ADD (hiredate DATE);            --칼럼 추가 : 제일 마지막에 추가됨.   --데이터 : NULL로 들어감.

ALTER TABLE emp_copy10
ADD (sal NUMBER(7, 2));
--구조 확인
DESC emp_copy10;

--ATLER TABLE ~ RENAME COLUMN ~ TO ~  
ALTER TABLE emp_copy10
RENAME COLUMN sal TO salary;
--칼럼이름 변경됐는지 구조 확인
DESC emp_copy10;

--ALTER TABLE ~ MODIFY 
--데이터 타입도 변경 가능.

--데이터 길이를 넘어서는 값은 ERROR.
INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES (5555, '김빛나라', 'KBS저녁뉴스기자', SYSDATE); 
--이름의 데이터 길이 늘리는 것은 쉽게 가능
ALTER TABLE emp_copy10
MODIFY ename VARCHAR2(20);
--직업의 데이터 길이 늘리는 것도 쉽게 가능
ALTER TABLE emp_copy10
MODIFY  job VARCHAR2(30);
--데이터 길이 늘렸으므로 이제는 오류 안남.

--다른 문제
--숫자 데이터 길이 늘려야 에러 안남.
INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES (55555, '한지민', '배우', SYSDATE); 
--데이터 길이 변경
ALTER TABLE emp_copy10
MODIFY empno NUMBER(5, 0);
--테이블 구조 확인
DESC emp_copy10;
--테이블 데이터 확인.
SELECT * FROM emp_copy10;

--데이터 길이 줄이기 : 한계가 있음.
ALTER TABLE emp_copy10
MODIFY job VARCHAR2(9);

--데이터 타입 변경  (VARCHAR2 -> CHAR)
ALTER TABLE emp_copy10
MODIFY job CHAR(30);

--ALTER TABLE ~ DROP COLUMN ~
ALTER TABLE emp_copy10
DROP COLUMN job;
ALTER TABLE emp_copy10
DROP COLUMN hiredate;



REM 324page
--Q1
CREATE TABLE EMP_HW (
    empno   NUMBER(4),
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7, 2),
    comm NUMBER(7, 2),
    deptno NUMBER(2)
);
--테이블 생성 후에는 반드시 DICTIONARY에서 확인
SELECT TABLE_NAME FROM USER_TABLES
WHERE TABLE_NAME = UPPER('emp_hw');
--테이블 구조까지 확인
DESC EMP_HW;

--Q2 : 열 추가.
ALTER TABLE EMP_HW
ADD (BIGO VARCHAR2(20));
--구조 변경 후에도 반드시 확인.
DESC EMP_HW;

--Q3 : 열 크기 변경.
ALTER TABLE EMP_HW
MODIFY bigo VARCHAR2(30);
--변경 후에 반드시 구조 확인.
DESC EMP_HW;

--Q4 : 열 이름 변경.
ALTER TABLE EMP_HW
RENAME COLUMN BIGO TO REMARK;
--변경 후에 반드시 구조 확인.
DESC EMP_HW;

--Q5 : 테이블의 데이터 저장.
SELECT * FROM EMP_HW;       --테이블의 데이터 확인.
--명시적 NULL 대입.
INSERT INTO EMP_HW (empno, ename, job, mgr, hiredate, sal, comm, deptno, remark)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno, NULL   --명시적 NULL 대입. --서브쿼리 : INSERT INTO ~ VALUES 대신 INSERT INTO ~ SELECT 사용.
FROM emp;

--Q6 : 테이블 삭제.
DROP TABLE EMP_HW;

