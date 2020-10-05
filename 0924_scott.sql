CREATE TABLE dept_copy
AS
SELECT deptno, dname, loc
FROM dept;              --데이터까지 카피.   --제약조건은 카피 X.

--제약조건 확인
SELECT OWNER, constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('dept_copy');      --테이블 카피 : 제약조건은 없음.

--데이터 확인.
SELECT * FROM dept_copy;        --테이블 카피 : 데이터는 있음.

--디폴트값 수정. (지역에 값을 넣지 않으면 SEOUL 데이터가 들어감)
ALTER TABLE dept_copy
MODIFY loc DEFAULT 'SEOUL';         --디폴트 옵션 부여.

--PRIMAERY KEY 부여.  
ALTER TABLE dept_copy
ADD CONSTRAINT dept_copy_deptno_pk PRIMARY KEY(deptno);   --기본키를 부여함.       --ADD CONSTRAINT : 테이블레벨 제약조건만 가능.2

--NN 부여.   --칼럼레벨 제약조건에서만 부여가능.  = MODIFY 사용.
ALTER TABLE dept_copy
MODIFY dname CONSTRAINT dept_copy_dname_nn NOT NULL;

ALTER TABLE dept_copy
MODIFY loc CONSTRAINT dept_copy_loc_nn NOT NULL;

--제약조건 확인. (스키마, 제약조건이름, 제약조건 타입, 테이블 이름)
SELECT  OWNER, constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('dept_copy');


DROP TABLE dept_copy;
DROP TABLE emp_copy10;



REM Foriegn Key

--테이블 카피.
CREATE TABLE emp_copy
AS
SELECT * FROM emp;          --제약조건은 복사 안됨.

CREATE TABLE dept_copy
AS
SELECT * FROM dept;

--1. PRIMARY Key 부여.   --테이블 생성 후 제약조건 부여 : ALTER TABLE ~
ALTER TABLE emp_copy                --참조하는 테이블. (자식 테이블)
ADD CONSTRAINT emp_copy_empno_pk PRIMARY KEY(empno);        --먼저 기본키부터 부여.

ALTER TABLE dept_copy           --참조 당하는 테이블. (부모 테이블)
ADD CONSTRAINT dept_copy_deptno_pk PRIMARY KEY(deptno);

--2.  Foreign Key 부여.   --자식이 부모를 참조. --자식의 외래키가 부모의 유일키or기본키 참조.
ALTER TABLE emp_copy
ADD CONSTRAINT emp_copy_deptno_fk FOREIGN KEY(deptno)       --자식 테이블의 외래키 부여.
REFERENCES  dept_copy (deptno);  --자식의 외래키가 부모의 어떤키(유일키or기본키)를 참조하는지 명시.  --부모 테이블의 유일키or기본키 명시.   --자식의 외래키가 부모의 유일키or기본키 참조하므로.

--제약조건 삭제하는 방법.
ALTER TABLE emp_copy
DROP CONSTRAINT emp_copy_deptno_fk;     --제약조건이름으로 삭제.

--외래키 : 참조하는 부모 테이블의 유일키or기본키에 없는 값은 외래키로 넣을 수 없다.
INSERT INTO emp_copy(empno, ename, deptno)
VALUES (8888, '한지민', 50);               --무결성 제약조건 위배  (emp_copy테이블의 외래키인 deptno, deptno의 부모 테이블의 기본키 : deptno) (그 deptno에 50이 없으므로 자식의 외래키 역시 50을 넣을 수 없음)


--테이블 생성하면서 동시에 제약조건 부여.
CREATE TABLE Member (
    member_id   NUMBER(5),
    member_name VARCHAR2(20)   CONSTRAINT member_member_name_nn NOT NULL,  --NN : 반드시 컬럼레벨제약조건으로 명시
    CONSTRAINT member_member_id_pf  PRIMARY KEY(member_id)      --테이블컬럼레벨로 PRIMARY KEY 부여.
);

CREATE TABLE Product (
    product_id                  NUMBER(5),
    product_name            VARCHAR2(30)    CONSTRAINT product_product_name_nn NOT NULL,    --NN : 반드시 컬럼레벨제약조건으로 명시.
    CONSTRAINT product_product_id_pk    PRIMARY KEY(product_id)
);
--Member와 Product테이블을 참조하는 Cart테이블. (자식 테이블)
CREATE TABLE Cart (
    cart_id             NUMBER(10),
    member_id       NUMBER(5)           CONSTRAINT cart_member_id_fk    REFERENCES member(member_id),     --member테이블의 member_id를 참조  --외래키 : 칼럼레벨제약조건으로 명시. -- 칼럼레벨제약조건으로 명시할 때 -> FOREIGN KEY 키워드 생략.
    product_id             NUMBER(5),
    CONSTRAINT cart_cart_id_pk PRIMARY KEY(cart_id),        --테이블레벨제약조건..
    CONSTRAINT cart_product_id_fk   FOREIGN KEY(product_id) REFERENCES product(product_id)      --product테이블의 product_id를 참조.
);

--데이터 넣기.
--부모 테이블의 데이터를 먼저 만들고, 자식 테이블이 데이터를 넣을때 부모 테이블 데이터를 참조함.
INSERT INTO dept1 (deptno, dname, loc)
VALUES (10, '개발팀', 'SEOUL');

INSERT INTO emp1 (empno, ename, deptno)
VALUES(1111, '한지민', 10);     


DELETE FROM dept1
WHERE deptno = 10;      --자식이 부모의 10번부서를 참조하므로, 부모가 함부로 10번부서 삭제 불가.

--제약조건 이름 찾기
SELECT constraint_type, constraint_name, table_name
FROM USER_CONSTRAINTS
WHERE table_name = 'EMP1';
--제약조건 삭제.
ALTER TABLE emp1
DROP CONSTRAINT FK_DEPT1_TO_EMP1;


REM ON DELETE CASCADE
ALTER TABLE emp1
ADD CONSTRAINT emp1_deptno_fk FOREIGN KEY(deptno) REFERENCES dept1(deptno) ON DELETE CASCADE;       --부모가 삭제될 때, 자식도 삭제.

DELETE FROM dept1
WHERE deptno = 10;      --113행으로 인해, 부모 삭제 시, 자식테이블의 한지민도 같이 삭제.

SELECT * FROM emp1;


REM ON DELETE SET NULL : 부모 데이터가 삭제되면 이를 참조하는 자식 테이블의 데이터를 삭제하지 않고 대신 NULL로 바꾼다.
INSERT INTO dept1 (deptno, dname, loc)
VALUES (20, '총무팀', 'SEOUL');

DELETE FROM dept1
WHERE deptno = 20;      --부모의 20번부서를 참조하는 자식 없음, 따라서 부모 20번부서는 쉽게 삭제 가능.

ALTER TABLE emp1
DROP CONSTRAINT emp1_deptno_fk;

ALTER TABLE emp1
ADD CONSTRAINT emp1_deptno_fk FOREIGN KEY(deptno)
REFERENCES dept1(deptno) ON DELETE SET NULL;



REM UNIQUE KEY (유일키)
REM 부서테이블의 부서명에 유일키를 지정!
ALTER TABLE dept1
ADD CONSTRAINT dept1_dname_uk UNIQUE(dname);

INSERT INTO dept1
VALUES (20, '총무팀', 'SEOUL');

INSERT INTO dept1
VALUES (30, '개발팀', 'BUSAN');        --부서이름 : 유일키 , 따라서 동일한 부서이름 넣을 수 없음.



REM CHECK 제약조건.
REM 부서의 위치는 서울, 부산, 대전, 대구, 인천, 광주, 울산만 가능하도록 CHECK 설정.
ALTER TABLE dept1
ADD CONSTRAINT dept1_loc_ck     CHECK (loc IN ('SEOUL', 'BUSAN', '대구', '인천', '광주', '울산', '대전'));

INSERT INTO dept1
VALUES (30, '디자인팀', '대구');          --CHECK제약조건 성립.

INSERT INTO dept1
VALUES (40, '운영팀', '용인');       --CHECK제약조건에 위배.



REM 제약조건 및 DEFAULT 옵션 복습

CREATE TABLE Student (
    hakbun          CHAR(7),
    name             VARCHAR2(20)       CONSTRAINT student_name_nn  NOT NULL,
    math               NUMBER(3)      DEFAULT 0  CONSTRAINT student_math_nn  NOT NULL,    
    age                  NUMBER(3)      DEFAULT 20 CONSTRAINT student_age_nn  NOT NULL,
    seq                 NUMBER(5) ,         --우편번호 테이블 참조.
    city                VARCHAR2(30) ,
    gender          CHAR(1)  DEFAULT '0',
    CONSTRAINT student_hakbun_pk  PRIMARY KEY(hakbun),      --기본키
    CONSTRAINT sutdent_math_ck      CHECK(math BETWEEN 0 AND 100),
    CONSTRAINT student_age_ck        CHECK(age > 19),
    CONSTRAINT student_city_ck          CHECK(city IN ('서울', '부산', '용인')),
    CONSTRAINT student_city_uk       UNIQUE(city),              --유일키
    CONSTRAINT student_gender_ck     CHECK(gender IN ('1', '0')),
    CONSTRAINT student_seq_fk       FOREIGN KEY(seq) REFERENCES zipcode(seq)        --외래키. 이 테이블(Student테이블) seq칼럼은 zipcode테이블의 seq를 참조.
);
--테이블 확인.
INSERT INTO Student(hakbun, name)
VALUES ('2020-01', NULL);                   --name : NN 제약조건 위배    --이름 : NN --따라서, NULL 입력 불가.

INSERT INTO Student(hakbun, name, math, age)
VALUES ('2020-01', '한지민', 110, 18);             --math, age : CHECK 제약조건 위배.

INSERT INTO student(hakbun, name, math, age, seq)
VALUES ('2020-01', '한지민', 100, 20, 50000);              --seq : 부모키가 없어서 ERROR.

INSERT INTO student(hakbun, name, math, age, seq, gender)
VALUES ('2020-01', '한지민', 100, 20, 1234, 3);            --gender : CHECK 제약조건 위배.

DROP TABLE Patient;
DROP TABLE checkup;
DROP TABLE department;
DROP TABLE discount;