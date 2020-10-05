REM DEFAULT option
--INSERT할때 암시적으로 NULL이 들어가면 자동적으로 대체될 값을 지정할 때 사용.
--DEFAULT의 값은 해당 칼럼의 데이터타입과 일치해야함.
DROP TABLE emp_copy10;
--DEFAULT 옵션 이용해서 테이블 생성.
CREATE TABLE emp_copy10(
    empno           NUMBER(4),
    ename           VARCHAR2(20),
    hiredate         DATE                   DEFAULT SYSDATE,        --SYSDATE : 앞의 데이터 타입(DATE)와 일치해야함.
    job                VARCHAR2(50)    DEFAULT 'DEVELOPER',
    sal                 NUMBER(7)         DEFAULT 800000     --백만 단위여서 7자리.
);
--암시적으로 NULL 넣기
INSERT INTO emp_copy10(empno, ename)
VALUES (1111, '한지민');
--INSERT 확인.
SELECT * FROM emp_copy10;

INSERT INTO emp_copy10(empno, ename, job)
VALUES (2222, '김지민', 'SALESMAN');
--명시적으로 NULL넣기.
INSERT INTO emp_copy10(empno, ename, job, hiredate)
VALUES (3333, '박지민', NULL, NULL);
--새로운 테이블 생성.
CREATE TABLE member     --테이블 복사 (단, 구조만 복사)    --테이블을 복사해서 생성하면 모든 제약조건 : 삭제.  --따라서 member테이블의 제약조건 : 없음.
AS
SELECT      empno, ename
FROM         emp
WHERE   1 = 0;      --구조만 복사할 예정.

DESC member;            --NULL유형 없음 = 제약조건 복사 안되서.

--칼럼 추가해야할 경우    
--성별 칼럼 추가하는 경우, 그리고 기본값을 여성으로 놓자.
ALTER TABLE member
ADD (gender NUMBER(1));         --성별의 기본값을 여성이라는 문자가 들어가야하기 때문에 다시 변경해야함.

ALTER TABLE member
MODIFY (gender   VARCHAR2(7) DEFAULT '여성');       --데이터 하나도 없어서 형 변환 가능

INSERT INTO Member(empno, ename)
VALUES (1111, '한지민');                           --성별의 기본값 : 여성이므로 굳이 지정하지 않아도 자동으로 여성으로 들어감.
--명시적으로 DEFAULT라 써줘서 자동으로 기본값으로 대체 (성별 : 여성으로 입력가능.)
INSERT INTO Member(empno, ename, gender)
VALUES (3333, '김지민', DEFAULT);

SELECT * FROM member;

INSERT INTO Member(empno, ename, gender)
VALUES (2222, '박지민', '남성');

--테이블 삭제
DROP TABLE emp_copy10;
DROP TABLE Member;



REM PRIMARY KEY (기본키)
--1. Column - level  제약조건으로 기본키 생성.
CREATE TABLE Member (
    userid         CHAR(14)    CONSTRAINT member_userid_PK     PRIMARY KEY,      --테이블 생성 시, 칼럼 옆에 바로 제약조건 명시.  --제약조건이름 명시.    --고정길이 14Byte
    passwd        VARCHAR2(20) ,        --가변길이 20Byte
    name           VARCHAR2(20) ,
    age             NUMBER(2),          --2자리 (10~ 99살만 가능)
    city            VARCHAR2(20)        DEFAULT 'Seoul'
);

--2. Table-level 제약조건으로 생성하기.
--제약조건을 별도로 명시.
--PRIMAEY KEY : 2개 이상 지정 가능. (괄호로 묶기 때문)
CREATE TABLE Member (
    userid      CHAR(14),
    passwd      VARCHAR2(20),
    name        VARCHAR2(20),
    age         NUMBER(2),
    city            VARCHAR2(20)   DEFAULT  'Seoul',
    CONSTRAINT member_userid_pk PRIMARY KEY(userid)
);
--테이블(=객체) 확인.
SELECT table_name FROM USER_TABLES;
--테이블 제약조건 확인.
DESC USER_CONSTRAINTS;
--Member테이블의 제약조건만 확인.
SELECT OWNER, Constraint_name, constraint_type, table_name      --constraint_type : C or P : 
FROM user_constraints
WHERE table_name = UPPER('member');

DROP TABLE Member;


REM 제약조건 이름 부여하기
--테이블이름_칼럼이름_ PK | UK | NN | FK | CK
INSERT INTO Member (userid, passwd)
VALUES (1111, '12345');

INSERT INTO Member(userid, passwd)
VALUES (1111, '44444');         --PK : UNIQUE (중복불가.)

INSERT INTO Member(userid, passwd)
VALUES (NULL, '5555');      --PK : NOT NULL.


--제품테이블 생성.
CREATE TABLE Product(
    productid       CHAR(7),
    name            VARCHAR2(30),
    price               NUMBER(8),
    pdate               DATE                DEFAULT SYSDATE,
    maker               VARCHAR2(20),
    CONSTRAINT product_productid_pk PRIMARY KEY(productid)         --테이블 레벨 제약조건.
);

--테이블 복사해서 테이블을 생성한 후, 새로 생성한 테이블에는 제약조건 삭제됐으므로, 새로 제약조건을 추가하는 방법
CREATE TABLE emp_copy10
AS
SELECT empno, ename, job, hiredate          --제약조건은 복사 안됨.
FROM emp
WHERE deptno = 10;
    
    
    
REM ADD CONSTRAINT 제약조건이름  제약조건       --제약조건 추가.
ALTER TABLE emp_copy10
ADD CONSTRAINT emp_copy10_empno_pk   PRIMARY KEY(empno);
--제약조건 확인
SELECT owner, constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('emp_copy10');

SELECT * FROM emp_copy10;

INSERT INTO emp_copy10 (empno, ename)
VALUES (7782, '한지민');           --PK : 중복 불가이므로 ERROR.


REM DROP CONSTRAINT 제약조건명 : 제약조건 제거.
--따라서 이름 명명해주는게 중요.
ALTER TABLE emp_copy10
DROP CONSTRAINT emp_copy10_empno_pk;            --PRIMARY KEY : 제거 -> empno가 같은 사원 입사 가능.


REM NOT NULL
ALTER TABLE emp_copy10
--ADD CONSTRAIN : 테이블레벨 제약조건이므로 X.
--MODIFY ename NOT NULL;    -- 제약조건이름 명시 안함.
MODIFY ename CONSTRAINT emp_copy10_ename_nn NOT NULL;   --제약조건이름 명시.

--테이블 만들면서 제약조건 부여.
CREATE TABLE Patient (
    bunho         NUMBER(4) ,
    name           VARCHAR2(20)     CONSTRAINT patient_name_nn  NOT NULL,       --이름 필수 : NOT NULL로 지정.  --칼럼레벨 제약조건으로 NN 제약조건 부여.
    code           CHAR(2)                 CONSTRAINT patient_code_nn   NOT NULL,
    age             NUMBER(3)           CONSTRAINT patient_age_nn   NOT NULL,
    days            NUMBER(3)           CONSTRAINT patient_days_nn  NOT NULL,
    CONSTRAINT patient_bunho_pk     PRIMARY KEY(bunho)                  --테이블레벨 제약조건으로 기본키 제약조건 부여.
);



REM 병원관리 프로그램.
--진찰부서 테이블 생성.
CREATE TABLE department (
    code            CHAR(2),
    dname           VARCHAR2(15)   CONSTRAINT department_dname_nn  NOT NULL,   --NOT NULL : 반드시 컬럼레벨제약조건으로 부여.
    CONSTRAINT department_code_pk   PRIMARY KEY(code)
);

INSERT INTO department VALUES('MI', '외과');
INSERT INTO department VALUES('NI', '내과');
INSERT INTO department VALUES('SI', '피부과');
INSERT INTO department VALUES('TI', '소아과');
INSERT INTO department VALUES('VI', '산부인과');
INSERT INTO department VALUES('WI', '비뇨기과');

--진찰비 테이블 생성.
CREATE TABLE checkup (
    seq     NUMBER(1),             --모든 테이블은 PRIMARY KEY 있어야하므로 임의의 일련번호 칼럼 만들어서 그 칼럼을 PRIMARY KEY로 지정.
    loage    NUMBER(2)      CONSTRAINT checkup_loage_nn   NOT NULL,             --최저 나이 : 50.
    hiage      NUMBER(3)       CONSTRAINT checkup_hiage_nn   NOT NULL,               --최대 나이 : 100세일 수도 있음
    fee         NUMBER(4)       CONSTRAINT checkup_fee_nn   NOT NULL,
    CONSTRAINT checkup_seq_pk   PRIMARY KEY(seq)
);

INSERT INTO checkup VALUES(1, 0, 9, 7000);
INSERT INTO checkup VALUES(2, 10, 19, 5000);
INSERT INTO checkup VALUES(3, 20, 29, 8000);
INSERT INTO checkup VALUES(4, 30, 39, 7000);
INSERT INTO checkup VALUES(5, 40, 49, 4500);
INSERT INTO checkup VALUES(6, 50, 120, 2300);

--입원일수 할인표 테이블 생성.
CREATE TABLE Discount(
    seq             NUMBER(1),        --모든 테이블에 PK 항상 존재해야하므로 임의의 일련번호 생성해서 그 번호를 PK로 지정.
    lodays          NUMBER(3)           CONSTRAINT discount_lodays_nn NOT NULL,
    hidays          NUMBER(4)           CONSTRAINT discount_hidays_nn NOT NULL,
    rate            NUMBER(3, 2)        CONSTRAINT discount_rate_nn NOT NULL,
    CONSTRAINT discount_seq_pk  PRIMARY KEY(seq)
);

INSERT INTO discount VALUES (1, 1, 9, 1.00);
INSERT INTO discount VALUES (2, 10, 14, 0.85);
INSERT INTO discount VALUES (3, 15, 19, 0.80);
INSERT INTO discount VALUES (4, 20, 29, 0.77);
INSERT INTO discount VALUES (5, 30, 99, 0.72);
INSERT INTO discount VALUES (6, 100, 9999, 0.68);

COMMIT;         --실제 DB에 반영하려면 COMMIT 필수.

DROP TABLE patient;
--입력받을 때 사용하는 환자 테이블 생성.   --사용자가 데이터 직접 입력하는 테이블 생성.
CREATE TABLE Patient (
    bunho               NUMBER(1),      --환자번호  
    code                    CHAR(2)             CONSTRAINT patient_code_nn  NOT NULL,        --환자진찰코드    
    days                    NUMBER(4)           CONSTRAINT patient_days_nn  NOT NULL,      --환자입원일수
    age                     NUMBER(3)               CONSTRAINT patient_age_nn  NOT NULL,      --환자 나이
    dname                  VARCHAR2(15),        --환자 진찰부서명
    checkup_fee           NUMBER(4),        --진찰비.
    hospital_fee               NUMBER(7),        --입원비.
    sum                     NUMBER(8),           --진료비.
    CONSTRAINT patient_bunho_pk  PRIMARY KEY(bunho)
);

