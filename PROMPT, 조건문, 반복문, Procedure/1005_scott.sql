REM PROMPT변수.

ACCEPT p_username PROMPT '당신의 이름은 ? : ';
ACCEPT p_job            PROMPT '당신의 직업은 ? : ';

DECLARE
    ename VARCHAR2(20) := '&p_username';
    job         VARCHAR2(20) := '&p_job';
BEGIN
    dbms_output.put_line(ename || '의 직업은 ' || job || '입니다.');
END;

SET SERVEROUTPUT ON     --실행결과를 화면에 출력.
DECLARE
    t_deptno  NUMBER;
    t_dname  VARCHAR2(14);
    t_loc       VARCHAR2(13);
BEGIN
    SELECT deptno, dname, loc
    INTO  t_deptno, t_dname, t_loc
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE('부서번호     '||'부서명      '||'부서위치');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(t_deptno  || '   '  || t_dname||'   '||t_loc);
END;


--참조 변수
--ACCEPT ~ DECLARE : BEGIN ~ AND부분의 보조역할  --조건을 명시.
ACCEPT p_deptno     PROMPT 'Department Number : ';      --팝업창으로 물어보는 내용
ACCEPT p_dname      PROMPT 'Department Name : ';
ACCEPT p_loc        PROMPT 'Department Location : ';
DECLARE 
    t_deptno    dept.deptno%TYPE := &p_deptno;       --dept테이블의 deptno칼럼과 같은 데이터 타입으로 t_deptno을 정의  --p_deptno을 넣어라.
    t_dname      dept.dname%TYPE  := UPPER('&p_dname');     --문자열이므로 '  ' 붙임
    t_loc           dept.loc%TYPE := UPPER('&p_loc');
BEGIN       --BEGIN ~ END : 실제 실행하는 부분
    INSERT INTO dept
    VALUES (t_deptno, t_dname, t_loc);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Insert Success');   --COMMIT성공하면 이 내용 출력.  --System.out.print()와 동일.
END;


ACCEPT p_empno PROMPT 'Employee Number : ';
DECLARE
    v_empno     emp.empno%TYPE DEFAULT 7788;     --하나씩 데이터 타입 가져올때 : %TYPE.   --디폴트값 : 7788, empno%TYPE : empno타입과 동일하게 선언.
    v_record       emp%ROWTYPE;    --여러 개의 데이터 타입 한꺼번에 참조 : %ROWTYPE.    --8개의 타입을 가지고 있음.
BEGIN
    SYS.dbms_output.put_line('사원번호' || '사원이름' || '직무' || '입사날짜');
    SYS.dbms_output.put_line('-------------------------------------------');
    SELECT empno, ename, job, hiredate
    INTO v_empno, v_record.ename, v_record.job, v_record.hiredate   --v_record의 8개 타입 중 각각의 타입을 사용.
    FROM emp
    WHERE empno = v_empno;
    SYS.dbms_output.put_line(v_empno || '  '  || v_record.ename || '  '  || v_record.job || '  '  || v_record.hiredate);
END;



REM 조건문
REM IF문
ACCEPT p_num PROMPT 'Insert a Number : ';       --p_num에 입력값 받기.
DECLARE
    v_num  NUMBER NOT NULL := &p_num;               --내부변수 생성.  --p_num이 들어오면 변환해서 v_num에 넣음.   --v_num : NN (Null이면 연산 안되서)
BEGIN
    IF  v_num >= 0 THEN    --조건
        DBMS_output.put_line(v_num || ' : ' || '양수입니다.');
    ELSE
        DBMS_output.put_line(v_num || ' : ' || '음수입니다.');
    END IF;
END;

--윤년인지 확인
DECLARE     --변수 선언.
   v_year NUMBER  := TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy'));    --변수 선언.   --SYSDATE를 yyyy만 뽑아서 문자형, 숫자형으로 변형.
BEGIN
    IF   ( MOD(v_year, 400) = 0 ) OR
          (MOD(v_year, 4) = 0   AND   MOD(v_year, 100) <> 0) THEN   -- <> 0  : 0이 아닐 때.
        dbms_output.put_line('윤년입니다.');
    ELSE
        dbms_output.put_line('윤년이 아닙니다.');
    END IF;
END;

--ELSIF문
ACCEPT p_season PROMPT '당신이 좋아하시는 계절 : ';   --p_season변수에 받기.
DECLARE
    v_season VARCHAR2(6);
BEGIN
    v_season := '&p_season';        --문자열로 들어오므로 ' ' 처리.
    IF   v_season = '봄' OR v_season = 'spring' THEN
        DBMS_OUTPUT.PUT_LINE('개나리, 진달래');
    ELSIF   v_season = '여름' OR v_season = 'summer' THEN
        dbms_output.put_line('장미, 아카시아');
    ELSIF   v_season = '가을' OR v_season = 'fall' THEN
        dbms_output.put_line('코스모스, 백합');
    ELSE
        dbms_output.put_line('동백, 매화');
    END IF;
END;


--ㅌㅔ이블 카피.
CREATE TABLE emp_clone (empno, ename, sal, hiredate, deptno)
AS
SELECT empno, ename, sal, hiredate, deptno
FROM emp;

SELECT empno, ename, sal, deptno,
            DECODE(deptno, 10, sal * 0.1,
                                    20, sal * 0.2,
                                    30, sal * 0.3, sal) AS "Bonus"    --부서번호가 10번이라면 sal * 1.1, 20번이라면 ... 나머지 경우라면 그냥 sal만.
FROM emp;


DECLARE
        v_empno     emp_clone.empno%TYPE;
        v_deptno    emp_clone.deptno%TYPE;        --v_deptno의 타입 결정.
        v_sal           emp_clone.sal%TYPE;
        v_bonus     emp_clone.sal%TYPE;
BEGIN
        SELECT empno, deptno, sal INTO v_empno, v_deptno, v_sal     --empno을 v_empno에 대입.
        FROM emp_clone
        WHERE empno = 7788;         --SELECT ~ INTO : 결과값이 무조건 1행만 나와야함.  --커서를 사용한다면 2개 이상의 행 출력 가능.
        
        IF v_deptno = 10 THEN  v_bonus := v_sal * 0.1;
        ELSIF v_deptno = 20 THEN v_bonus := v_sal * 0.2;
        ELSIF v_deptno = 30 THEN v_bonus := v_sal * 0.3;
        ELSE v_bonus := v_sal;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(v_empno || '  ' || v_deptno || '  ' || v_sal || '  ' || v_bonus);
END;


--CASE

ACCEPT  p_name PROMPT 'Name : ';
ACCEPT  p_kor     PROMPT    'Korean : ';
ACCEPT  p_eng   PROMPT  'English : ';
ACCEPT  p_mat       PROMPT  'Math : ';
DECLARE
    v_tot       NUMBER(3);          --사용할 변수 선언.
    v_avg       NUMBER(4, 1);
    v_grade     CHAR(1); 
BEGIN                                   --사용할 변수 정의.
    v_tot := &p_kor + &p_eng + &p_mat;
    v_avg := v_tot / 3;
    CASE
        WHEN v_avg BETWEEN 90 AND 100 THEN v_grade := 'A';
        WHEN v_avg >= 80 THEN v_grade := 'B';
        WHEN v_avg >= 70 THEN v_grade := 'C';
        WHEN v_avg >= 60 THEN v_grade := 'D';
        ELSE v_grade := 'F';
    END CASE;
    --p_ 변수는 변환해서 &로 찍어야 함.
    --p_name : 문자열이므로 ' ' 로 묵음.
    dbms_output.put_line('&p_name' || '  ' || &p_kor || '  ' || &p_eng || '  ' || 
                                  &p_mat || '  ' || v_tot || '  ' || v_avg || '  ' || v_grade);
END;
/



REM 반복문.
--기본 LOOP.
DECLARE
        i           NUMBER := 1;        --상수이므로 초기값 설정.
BEGIN
        LOOP
                dbms_output.put_line(i  || '    ');           --출력문.
                i := i + 1;
                EXIT WHEN i > 5;
        END LOOP;
END;

--WHILE LOOP
DECLARE
        i           NUMBER := 1;        --상수이므로 초기값 설정.
BEGIN
        WHILE i < 6 LOOP
            dbms_output.put_line(i  || '    ');
             i := i + 1;
        END LOOP;
END;

--WHILE LOOP이용해서 부서테이블 전체 다 가져오기.
DECLARE         --사용할 변수 선언.
        v_deptno NUMBER := 10;      --초기값 : 10.
        v_dname  dept.dname%TYPE;           
        v_loc       dept.loc%TYPE;
BEGIN              
        WHILE  v_deptno <= 60 LOOP
            SELECT      dname, loc
            INTO          v_dname, v_loc
            FROM        dept
            WHERE       deptno = v_deptno;         
            dbms_output.put_line(v_deptno || CHR(9) || v_dname || CHR(9) || v_loc);
            v_deptno := v_deptno + 10;          
        END LOOP;
END;

--FOR ~ IN ~ LOOP
--구구단 출력.
DECLARE
    i   NUMBER;
    j   NUMBER;
BEGIN
    FOR i IN 1..9 LOOP
        FOR j IN 2..9 LOOP
            dbms_output.put(j || ' * ' || i || ' = ' || (j * i) || CHR(9));     -- put : (옆으로 찍는 출력문), CHR(9) : \t 가능.
        END LOOP;
            dbms_output.new_line();
    END LOOP;
END;

--구구단을 while문으로 출력.
DECLARE
    i   NUMBER;
    j   NUMBER;
BEGIN
    i := 1;                                         --초기값.
    WHILE i < 10 LOOP                       --조건.
        FOR j IN 2..9 LOOP
            dbms_output.put(j || ' * ' || i || ' = ' || (j * i) || CHR(9));     -- put  : (옆으로 찍는 출력문), CHR(9) : \t 가능.
        END LOOP;
            dbms_output.new_line();
        i := i + 1;                                     --증감식.
    END LOOP;
END;


--444page Q1
--숫자 1부터 10까지의 숫자 중 오른쪽과 같이 홀수만 출력하는 PL/SQL프로그램 작성.
DECLARE
    i   NUMBER;
BEGIN
    FOR i IN 1..10  LOOP
        IF MOD(i, 2) = 1 THEN   --홀수라면.
            dbms_output.put_line('현재 i의 값 : ' || i);
        END IF;
    END LOOP;
END;

--대문자 찍기.
DECLARE 
    i   NUMBER;
    CNT     NUMBER := 0;
BEGIN
    FOR i IN 65..90 LOOP
        dbms_output.put(CHR(i) || CHR(9));
        CNT := CNT + 1;
        IF MOD(CNT, 5) = 0 THEN
            dbms_output.new_line();
        END IF;
    END LOOP;
END;



REM Procedure
CREATE OR REPLACE PROCEDURE sp_test     --sp : StoredProcedure의 접두사.
IS
    v_str  VARCHAR2(20);            --지역변수 선언
BEGIN
    v_str   := 'Hello, World';
    dbms_output.put_line(v_str);
END;

--구구단
CREATE OR REPLACE PROCEDURE sp_gugudan
IS
    i   NUMBER;
    j   NUMBER;
BEGIN
    i := 1;                                         --초기값.
    WHILE i < 10 LOOP                       --조건.
        FOR j IN 2..9 LOOP
            dbms_output.put(j || ' * ' || i || ' = ' || (j * i) || CHR(9));     -- put : (옆으로 찍는 출력문), CHR(9) : \t 가능.
        END LOOP;
            dbms_output.new_line();
        i := i + 1;                                     --증감식.
    END LOOP;
END;

--프로시저 생성 확인
DESC USER_PROCEDURES;
--생성된 프로시저 이름을 확인.
SELECT object_name FROM USER_PROCEDURES;
--프로시저의 소스(내용)을 전부 확인.
SELECT * FROM USER_SOURCE;


-- 파라미터 모드 : IN
CREATE OR REPLACE PROCEDURE sp_test  --Call By Name  --sp_test 이미 존재하면 덮어씌움.
(                                                               -- ( ) : 파라미터를 받는다는 뜻.
    p_name         IN      VARCHAR2             --이름이 p_name에 들어온다는 뜻.
)         
IS
    v_str VARCHAR2(30);
BEGIN
    v_str := p_name;
    dbms_output.put_line('Your name ' || v_str || '!!');
END;



CREATE OR REPLACE PROCEDURE  sp_emp_dept_select
(
    t_empno     IN  emp.empno%TYPE          --파라미터 변수 선언.
)
IS
    v_empno         emp.empno%TYPE;         --지역변수 선언.
    v_ename         emp.ename%TYPE;
    v_dname         dept.dname%TYPE;
    v_loc              dept.loc%TYPE;
BEGIN
    SELECT empno, ename, dname, loc
    INTO v_empno, v_ename, v_dname, v_loc
    FROM  emp NATURAL JOIN dept
    WHERE empno = t_empno;
    dbms_output.put_line(v_empno || '  ' || v_ename || '  ' || v_dname || '  ' || v_loc);
END;

--Java에서 사용할 StoredProcedure
CREATE OR REPLACE PROCEDURE sp_emp_clone_delete
(
    t_empno IN  emp.empno%TYPE
)
IS          --선언할게 없어서 생략.
BEGIN           --END까지 블록 지정       --삭제하고 COMMIT까지 수행하게 함.
    DELETE FROM emp_clone
    WHERE empno = t_empno;      --파라미터로 들어온 번호만 삭제.     --이 번호를 자바에서 넣을 예정.
    COMMIT;
END;

--파라미터 없는 프로시저.
CREATE OR REPLACE PROCEDURE sp_dept_select      --파라미터 없으므로 () 생략.
IS
    v_deptno        dept.deptno%TYPE;
    v_dname         dept.dname%TYPE;
    v_loc               dept.loc%TYPE;
BEGIN
    dbms_output.put_line('부서번호'  || CHR(9)  ||  '부서명'   ||  CHR(9)  ||  '부서위치');
    dbms_output.put_line('----------------------------------------------------------------------');
    FOR i   IN  1..6    LOOP
        SELECT  deptno, dname, loc
        INTO    v_deptno, v_dname, v_loc
        FROM    dept
        WHERE   deptno = i * 10;     --부서번호 10, 20, 30, ... ,60
        dbms_output.put_line(v_deptno || CHR(9) || v_dname || CHR(9) || v_loc);
    END LOOP;
END;