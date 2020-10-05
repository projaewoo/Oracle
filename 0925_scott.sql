REM 394page Q1
--E-R다이어그램으로 테이블 부음.

--제약조건 확인
SELECT OWNER, constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('DEPT_CONST');
--C : CHECK or NN --따라서 제약조건 지운다음, 다시 제약조건을 제대로 부여.
ALTER TABLE DEPT_CONST
DROP CONSTRAINT SYS_C007148;

ALTER TABLE DEPT_CONST
DROP CONSTRAINT SYS_C007149;

ALTER TABLE dept_const
ADD CONSTRAINT deptconst_dname_unq  UNIQUE(dname);

--NN : 테이블레벨 제약조건으로 명시!!  --따라서, MODIFY!!
ALTER TABLE dept_const
MODIFY loc  CONSTRAINT deptconst_loc_nn   NOT NULL;

--emp_const테이블.
SELECT OWNER, constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = UPPER('emp_const');
--제약조건이 c로 명시 (Check ? NN?)    --따라서 확실히 제약조건 명시해줘야함.
--제약조건 삭제한 뒤, 제대로 제약조건 부여.
ALTER TABLE emp_const
DROP CONSTRAINT fk_dept_const_to_emp_const;

ALTER TABLE emp_const
DROP CONSTRAINT SYS_C007151;

ALTER TABLE emp_const
DROP CONSTRAINT SYS_C007152;

--제대로 제약조건 부여.
--NN 제약조건 부여 시 ,칼럼레벨제약조건!! MODIFY!!   
ALTER TABLE emp_const
MODIFY ename CONSTRAINT empconst_ename_nn NOT NULL;
--테이블레벨 제약조건.
ALTER TABLE emp_const
ADD CONSTRAINT empconst_tel_unq  UNIQUE(tel);
--테이블레벨 제약조건.
ALTER TABLE emp_const
ADD CONSTRAINT empconst_sal_chk  CHECK (sal BETWEEN 1000 AND 9999);
--외래키 부여.  (테이블레벨 제약조건)
ALTER TABLE emp_const
ADD CONSTRAINT empconst_dept_fk  FOREIGN KEY(deptno)
REFERENCES dept_const(deptno);       --dept_const테이블의 deptno칼럼을 참조.


--394page Q1정답.
SELECT  table_name, constraint_name, constraint_type
FROM USER_CONSTRAINTS
WHERE table_name IN (UPPER('emp_const'), UPPER('dept_const'));

--제약조건 이름 변경
ALTER TABLE 테이블명
RENAME CONSTRAINT 현재 제약조건 이름 TO 바꿀 새로운 이름;



REM 시퀀스
--시퀀스 삭제
DROP SEQUENCE dept_detpno_seq;
DROP SEQUENCE tset_seq;

--시퀀스 생성
CREATE SEQUENCE test_seq
    START WITH 1
    INCREMENT BY 1
    NOCYCLE
    MAXVALUE 100
    CACHE 20;

--시퀀스 사용
SELECT test_seq.CURRVAL, test_seq.NEXTVAL
FROM dual;
--시퀀스 변경 (증가값 변경)
ALTER SEQUENCE test_seq
    INCREMENT BY 10;                --최대값 : 100이므로 100 넘어가면 시퀀스가 ERROR.
--시퀀스 변경 (최대값 변경)
ALTER SEQUENCE test_seq
    MAXVALUE 300;

--SEQ삭제 후    
DROP SEQUENCE test_seq;
--다시 생성
CREATE SEQUENCE test_seq
    START WITH 1
    INCREMENT BY 1
    NOCYCLE
    MAXVALUE 100
    CACHE 20;
--시퀀스 새롭게 생성 후, NEXTVAL안해서 밑에 행은 ERROR.
SELECT test_seq.CURRVAL;
--NEXTVAL 생성 후, CURRVAL하면 에러 안남.
SELECT test_seq.NEXTVAL
FROM dual;
SELECT test_seq.CURRVAL
FROM dual;
--시퀀스 사용
CREATE TABLE dept_clone
AS
SELECT deptno, dname, loc
FROM dept
WHERE 1 = 0;            --구조만 복사 (데이터 복사 X)

ALTER TABLE dept_clone
ADD CONSTRAINT dept_clone_deptno_pk PRIMARY KEY(deptno);

DROP SEQUENCE dept_deptno_seq;
--시퀀스 생성.
CREATE SEQUENCE dept_deptno_seq
    START WITH 10
    INCREMENT BY 10
    MAXVALUE 99     --부서테이블의 부서번호는 NUMBER(2)이므로.
    CACHE 20;

--시퀀스 사용
INSERT INTO dept_clone(deptno, dname, loc)      
VALUES (dept_deptno_seq.NEXTVAL, '개발팀', 'SEOUL');      --시퀀스가 자동으로 넣어줌. --NEXTVAL : 다음 번호표를 넣어주세요.
INSERT INTO dept_clone(deptno, dname, loc)      
VALUES (dept_deptno_seq.NEXTVAL, '총무팀', 'SEOUL');      --시퀀스가 자동으로 넣어줌. --NEXTVAL : 다음 번호표를 넣어주세요
INSERT INTO dept_clone(deptno, dname, loc)      
VALUES (dept_deptno_seq.NEXTVAL, '운영팀', 'BUSAN');      --시퀀스가 자동으로 넣어줌. --NEXTVAL : 다음 번호표를 넣어주세요

--확인
SELECT * FROM dept_clone;




REM VIEW
--VIEW 생성       --일반계정 : VIEW 생성권한 없음.
CREATE VIEW test_view
AS 
SELECT * FROM emp;
--VIEW 삭제.
DROP VIEW test_view;        --뷰를 삭제해도 기반 테이블은 전혀 영향 없음.

--VIEW 생성
CREATE VIEW test1_view
AS
SELECT * FROM aaa;        --기반 테이블.  --없는 테이블로 VIEW를 만들 수 없음.

--emp 테이블에서 10번 부서만 바라보는 VIEW 생성.
--쿼리를 뷰에게 날림.  (테이블 이름 몰라도 됨)
CREATE OR REPLACE View emp_dept10_view
AS
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 10;

SELECT * FROM emp_dept10_view
ORDER BY sal DESC;

DROP VIEW emp_dept10_view;      --삭제해도, 기반 테이블(emp)는 전혀 영향 없음.

--조인 사용해서 뷰 생성
CREATE OR REPLACE View emp_dept10_view
AS
SELECT empno, ename, dname, sal, deptno
FROM emp NATURAL JOIN dept
WHERE deptno = 20;

SELECT * FROM emp_dept10_view;

SELECT * FROM emp_dept10_view
WHERE sal >= 2500;

--특정 뷰 생성.
--JOIN ~ USING절.        --식별자 사용 x.
--뷰에서 사용할 칼럼이름 지정.
CREATE OR REPLACE NOFORCE VIEW emp1982_view(Employee_id, Employee_name, hire_date, department_name, location, department_id)       --칼럼이름 명시.
AS
SELECT empno, ename, hiredate, dname, loc, deptno
FROM emp INNER JOIN dept USING(deptno)
WHERE  TO_CHAR(hiredate, 'YYYY') = '1981'
WITH READ ONLY;     --DML불가.
--만든 뷰 확인.
SELECT * FROM emp1982_view;

--뷰 확인.
DESC USER_VIEWS;

SELECT view_name, text
FROM USER_VIEWS;        --VIEW 확인.

--단순 뷰 (simple view) : DML 가능.
--복합 뷰  : DML 불가.

--뷰 : DML 가능.
INSERT INTO emp1982_view(Employee_id, Employee_name)
VALUES (8888, '한지민');

ROLLBACK;

--OR REPLACE : 기존에 뷰 있으면 그 위에 덮어씌움. --따라서, 기존에 뷰 있는지 확인해야함.
--다른 객체들(테이블 등)은 기존에 테이블 있으면 에러 나서 확인가능.
CREATE OR REPLACE VIEW test_view20
AS
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 20;

COMMIT;     --12:25분.   실제 DB에 반영.

--뷰에 데이터 삽입.  --> 기반 테이블에도 데이터 삽입됨. --이걸 CHECK통해서 막아야함.
INSERT INTO test_view20 (empno, ename, sal, deptno)
VALUES (9999, '김지민', 2000, 30);     --뷰를 만들때, (CHECK옵션 사용했다면) 사용했던 WHERE절의 조건과 일치하지 않으면 실행거부.

ROLLBACK;       --마지막 COMMIT 시점으로 돌아감.  --12:25 분 시점으로 돌아감.

--210행. CHECK통해 막기.
CREATE OR REPLACE VIEW test_view20
AS
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 20
WITH CHECK OPTION;      --뷰를 만들때, 사용했던 WHERE절의 조건과 일치하는 경우에만 DML 사용 허가.

--WITH CHECK OPTION은 조건절에 있는 조건을 만족할 때만,  (WHERE조건절 대상으로만 CHECK OPTION 함)
--WITH READ ONLY는 전체 조건을 만족할 때만 (전체를 대상으로 READ ONLY함)

--FORCE 옵션 : 기반 테이블 없어도 강제로 생성.
CREATE OR REPLACE FORCE VIEW aaa_view
AS
SELECT * FROM aaa;



REM TOP - N Query

SELECT ROWNUM, ename, sal        --ROWNUM : (가짜 열) 숨겨져있던 열의 번호.
FROM emp
WHERE ROWNUM < 4;

--인라인 뷰 생성.  (일회성으로 만들어 사용하는 뷰)
CREATE OR REPLACE VIEW emp_sal_dec_view
AS
SELECT ename, sal
FROM emp
ORDER BY sal DESC;

--월급 가장 많이 받는 사람 3명 출력.
SELECT ROWNUM, ename, sal
FROM emp_sal_dec_view
WHERE ROWNUM < 4;

--부서별로 부서명, 최소 급여, 최대 급여, 부서의 평균 급여를 포함하는 DEPT_SUM View를 생성하라.
--서브쿼리를 통해 뷰 생성.
CREATE OR REPLACE VIEW DEPT_SUM (deptno, dname, min_sal, max_sal, avg_sal)
AS
SELECT  emp.deptno, dept.dname, MIN(sal), MAX(sal), TRUNC(AVG(sal))
FROM    emp INNER JOIN dept ON (emp.deptno = dept.deptno)       --JOIN ~ ON절 : 식별자 사용.
GROUP BY  emp.deptno, dept.dname;          --부서별.

DESC DEPT_SUM;
SELECT * FROM dept_sum;

--2. emp table에서 사원번호, 이름, 업무를 포함하는 emp_view VIEW를 생성.
CREATE OR REPLACE VIEW emp_view
AS
SELECT empno, ename, job, deptno
FROM emp;

SELECT * FROM emp_view;

--3. 위 2번에서 생성한 VIEW를 이용하여 10번 부서의 자료만 조회.
SELECT *
FROM emp_view
WHERE deptno = 10;

--4. 위 2번에서 생성한 VIEW를 Data Dictionary에서 조회.
SELECT view_name, text
FROM USER_VIEWS
WHERE view_name = UPPER('emp_view');

--5. 이름, 업무, 급여, 부서명, 위치를 포함하는 emp_dept_name이라는 view를 생성.
CREATE OR REPLACE VIEW emp_dept_name ("이름", "업무", "급여", "부서명", "위치")        --별칭이 한글 : " " 사용.
AS
SELECT ename, job, sal, dname, loc
FROM emp e  INNER JOIN dept d ON(e.deptno = d.deptno);       --JOIN ~ ON : 애매한 공통칼럼에 식별자 사용.

SELECT * FROM emp_dept_name;


--6. 1987년에 입사한 사람을 볼 수 있는 뷰.
CREATE OR REPLACE VIEW emp1987_view
AS
SELECT empno, ename, hiredate
FROM emp
--WHERE hiredate >= '87/01/01' AND hiredate <= '87/12/31';
--WHERE hiredate BETWEEN '87/01/01' AND '87/12/31';
--WHERE SUBSTR(hiredate, 1, 2) = '87';        --hiredate의 첫번째부터 2개의 글자 뽑아서 87과 일치?
--WHERE hiredate LIKE '87%';
WHERE TO_CHAR(hiredate, 'YYYY') = '1987';

SELECT * FROM emp1987_view;


--1. DEPT 테이블에서 기본 키 열로 사용할 시퀀스를 다음 조건에 맞게 생성
-- 1) 시퀀스 값은 60에서 시작하여 10씩 증가, 최대 200까지 가능.
-- 2) 시퀀스 이름은 dept_deptno_seq로 지정.

CREATE SEQUENCE dept_deptno_seq
    START WITH 60
    INCREMENT BY 10
    MAXVALUE 200;
    
--2. 위의 1에서 만든 시퀀스의 이름, 최대값, 증가분, 마지막 번호의 정보를
--아래와 같이 출력되도록 Data Dictionnary에서 조회.
SELECT SEQUENCE_NAME, MAX_VALUE, INCREMENT_BY, LAST_NUMBER
FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = UPPER('dept_deptno_seq');

--3. 위의 1에서 만든 시퀀스를 이용하여 부서이름은 education, 부서 위치는 seoul로 새 행을 dept 테이블에 추가하고, 아래와 같이 조회.
COMMIT;     --14:35
ROLLBACK;   

INSERT INTO dept
VALUES (dept_deptno_seq.NEXTVAL, 'education', 'seoul');

SELECT * FROM dept;



REM INDEX
--Data Dictionary 통해서 인덱스 확인
DESC USER_INDEXES;

SELECT INDEX_NAME, INDEX_TYPE, TABLE_NAME
FROM USER_INDEXES;              --PK, UK로 지정하면 저절로 인덱스 지정되므로, 따로 인덱스 지정 잘 안함.


--357page Q1. 1번 조건
CREATE TABLE EMPIDX
AS
SELECT *
FROM emp;

SELECT * FROM EMPIDX;

--Q1. 2번 조건
--EMPIDX테이블의 empno열에 IDX_EMPIDX_EMPNO인덱스 생성.
CREATE INDEX idx_empidx_empno
ON empidx (empno);

--Q1. 3번 조건.
SELECT index_name, table_name
FROM USER_INDEXES
WHERE index_name = UPPER('idx_empidx_empno');

--Q2.
CREATE OR REPLACE VIEW empidx_over15k ("사원 번호", "사원 이름", "직책", "부서 번호", "급여", "추가 수당")
AS
SELECT empno, ename, job, deptno, sal, NVL2(comm, 'O', 'X')
FROM empidx
WHERE sal > 1500;

-- Q3. 1번 조건
CREATE TABLE deptseq
AS
SELECT *
FROM dept;

--Q3. 2번 조건
CREATE SEQUENCE deptseq_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 99
    MINVALUE 1
     NOCYCLE       --부서번호 최댓값에서 생성 중단
     NOCACHE;       --캐쉬 없음.

--Q3. 3번 조건
INSERT INTO deptseq
VALUES (deptseq_seq.NEXTVAL, 'DATABASE', 'SEOUL');
INSERT INTO deptseq
VALUES (deptseq_seq.NEXTVAL, 'WEB', 'BUSAN');
INSERT INTO deptseq
VALUES (deptseq_seq.NEXTVAL, 'MOBILE', 'ILSAN');

SELECT * FROM deptseq;