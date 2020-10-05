--ALTER SESSION SET "_ORACLE_SCRIPT"=ture;        --오라클 12c 이상만.

CREATE USER jimin
IDENTIFIED BY jimin;

--User를 만드는 절차
--1. 계정 생성
--2. tablespace부여
--3. QUOTA  부여
--4. 권한부여 : connect, resource

--계정 생성, tablespace부여.  --1, 2단계 동시에.      
CREATE USER jimin
IDENTIFIED BY jimin
DEFAULT tablespace USERS
TEMPORARY tablespace temp;

--3단계 QUOTA부여
--USERS테이블 안에서 jimin의 QUOTA는 UNLIMITIED.
ALTER USER jimin
DEFAULT tablespace USERS
QUOTA UNLIMITED ON USERS;

--4단계 : 권한부여 (connect, resource권한 존재)
GRANT CONNECT, RESOURCE TO jimin;
--따라서 테이블 생성 가능


CREATE VIEW test_view
AS
SELECT * FROM member;


REM DBA_SYS_PRIVS 사전을 통해 권한 확인
DESC DBA_SYS_PRIVS;

SELECT grantee, privilege, admin_option
FROM DBA_SYS_PRIVS
WHERE grantee = UPPER('jimin');

show user;

--jimin이 자기가 만든 테이블 들어올 수 있도록 허락
--객체권한 (한 객체에게만 권한 부여) : 지민에게 scott스키마의 emp테이블의 SELECT권한만 부여.       --DROP같은 다른 쿼리문은 불가.
GRANT SELECT ON scott.emp TO jimin;
--객체권한 부여 (삭제, 수정, 선택, 삽입)
GRANT DELETE, UPDATE, SELECT, INSERT ON dept_clone TO jimin;
--권한 취소 (지민에게 줬던 emp SELECT권한을 회수)      --REVOKE : DCL --따라서 실제 DB에 바로 반영 (ROLLBACK 불가)
REVOKE SELECT ON emp FROM jimin;

--권한 확인.  
SELECT *
FROM USER_TAB_PRIVS_MADE;       --MADE : (권한을 부여한 사람 기준)

SELECT *
FROM USER_TAB_PRIVS_RECD;       --REDC : 권한을 받은사람 기준.



--1. level 1이라는 role을 생성.  (롤 생성)   (롤 : 권한의 그룹)
CREATE ROLE level1;
--2. level 1에 CREATE SESSION, CAREATE TABLE, CREATE VIEW라는 권한 할당.   (롤에게 권한 부여 가능)
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO level1;
--3. test1/tiger, tset2/tiger라는 계정을 생성하시오.
CREATE USER test1
IDENTIFIED BY tiger
default tablespace users
temporary tablespace temp;

CREATE USER test1
IDENTIFIED BY tiger
default tablespace users
temporary tablespace temp;
--4. 사용자 test1, test2에게 level1이라는 role을 부여.
GRANT level1 TO test1;
GRANT level1 TO test2;      --test1과 test2가 role에게 부여받은 권한을 상속받음. 
--5. 사용자로 커넥트하여 롤을 확인.
--role 확인.
SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'LEVEL1';

SELECT * FROM user_role_privs;

--6. 사용자에게 부여된 role를 회수.
REVOKE level1 FROM test1;
REVOKE level1 FROM test2;

--7. role삭제.
DROP ROLE level1;



REM 416page
--Q1 : SYSTEM계정으로 접속하여 PREV_HW계정 생성
--비밀번호 ORCL. 접속권한을 부여하고 PREV_HW계정으로 접속 잘 되는지 확인.
CREATE USER PREV_HW
IDENTIFIED BY orcl
default tablespace users
temporary tablespace temp;

GRANT CONNECT TO prev_hw;       --CONNECT외의 다른 권한도 얻음.

--Q2 : scott계정으로 접속하여 위의 생성한 PREV_HW계정에 scott소유의 emp, dept, salgrade테이블에 SELECT권한 부여.
GRANT SELECT ON emp TO prev_hw;         
GRANT SELECT ON dept TO prev_hw;
GRANT SELECT ON salgrade TO prev_hw;

--JOIN ~ ON~ 통해서 테이블 잘 조회되는지 확인   --조인이 잘 되서 출력 = 각 테이블이 잘 조회된다는 뜻.
SELECT empno, ename, dname, loc, grade
FROM scott.emp INNER JOIN scott.dept ON(scott.emp.deptno = scott.dept.deptno)
                        INNER JOIN scott.salgrade ON (sal BETWEEN losal AND hisal);

--Q3 : scott계정으로 접속하여 PREV_HW계정에 salgrade테이블의 SELECT권한을 취소. 
show user;
--prev_hw로부터 salgrade테이블의 권한 뺏어.
REVOKE SELECT ON salgrade FROM prev_hw;



REM SYNONYM
show user;

--동의어 생성
--일반유저 : VIEW, SYNOYNM 등을 만들 권한 없음.
CREATE SYNONYM mysynonym
FOR scott.emp;

SELECT * FROM emp;
SELECT * FROM mysynonym;

--원본 테이블의 이름 공개하지 않으려고 할 때, SYNONYM 사용.
GRANT SELECT ON mysynonym TO jimin;     --jimin에게 mysynonym이라는 동의어의 SELECT권한 부여.    --mysynonym : scott의 emp테이블.

--public : scott가 공개적으로.    --scott의 테이블을 SELECT할때, scott.dept가 아니라 그냥 dept라 해도 됨 (공개적이라서)
GRANT CREATE PUBLIC SYNONYM TO scott;


--dept테이블을 d_temp라 하자.
CREATE PUBLIC SYNONYM d_temp
FOR dept;
--CREATE권한까지 줘야 jimin이 d_temp를 SELECT할 수 있음.
GRANT SELECT ON d_temp TO jimin;