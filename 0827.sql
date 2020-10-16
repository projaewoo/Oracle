
SELECT sysdate FROM dual;

--세일즈맨의 이름 앞글자만 대문자로 출력
SELECT INITCAP(ename)
FROM    emp
WHERE job = UPPER('salesman');

--글자의 개수 파악
SELECT      LENGTH('SCOTT'), LENGTH('안녕하세요'),       --글자 길이 파악
                LENGTHB('SCOTT'), LENGTHB('안녕하세요')   --LENGTHB() : 바이트 크기 파악
FROM        dual;

--NLS
SELECT  parameter, value
FROM NLS_SESSION_PARAMETERS;

--이름의 길이가 5글자 초과하는 사람 출력
SELECT ename
FROM    emp
WHERE   LENGTH(ename) > 5;


--SUBSTR(job, 1, 3) : 1부터 3개 -- (_ _ _) job직무의 글자를 3글자까지만 출력
    --SUBSTR(job , 3) : job직무글자의 3번째부터 끝까지 출력
SELECT      job,  SUBSTR(job, 1, 3), SUBSTR(job, 3) 
FROM        emp
WHERE deptno = 10;


ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';

--1987년에 입사한 사람
SELECT      empno, ename, hiredate
FROM       emp 
--WHERE       hiredate >= '1987-01-01' AND hiredate <= '1987-12-31';
--WHERE hiredate BETWEEN '1987-01-01' AND '1987-12-31';
--WHERE hiredate LIKE '1987%';
WHERE SUBSTR(hiredate, 1, 4) = '1987';      --hiredate에서 첫번째부터 4번째까지 가져온 값이 1987이면 출력


--1987년에 입사한 사람
SELECT      empno, ename, hiredate
FROM        emp
--WHERE       hiredate >= '1987-01-01' AND hiredate <= '1987-12-31';
--WHERE       hiredate BETWEEN '1987-01-01' AND '1987-12-31';
--WHERE       hiredate LIKE '1987%';
WHERE   SUBSTR(hiredate, 1, 4) = '1987';

--이름의 첫글자가 B와 J사이의 모든 사원의 정보 출력.
SELECT      *
FROM        emp
WHERE     SUBSTR(ename, 1, 1) BETWEEN 'B'  AND  'J';


--INSTR(ename, 'A') : ename에서 대문자A가 몇번째 있음? --없으면 0
SELECT      ename, LENGTH(ename), LOWER(ename), SUBSTR(ename, 1, 3), INSTR(ename, 'A')  
FROM        emp
WHERE       deptno = 20;

--우편번호 검색
SELECT          *
FROM        zipcode
--WHERE       dong LIKE '%개포%';           --자바는 변수로 받으므로 잘라서 DB -> JAVA에게 보내야함
WHERE dong LIKE CONCAT(CONCAT('%', '개포'), '%');

--TRIM() 함수
SELECT      'aaHelloaa' , LTRIM('yxHelloaa' , 'xy'), RTRIM('aaHelloxXx', 'x'),
                TRIM(BOTH  'a'  FROM 'aaHelloaa')
FROM    dual;

--ASCII()함수 이용
SELECT      'Hello' || ', World' || CHR(10) || CHR(36) || 'Oracle Programming'     --ASCII Code 10 = '%n' (줄바꿈) --ASCII Code 36 = '$'
FROM    dual;

--주어진 문자의 가장 큰, 작은
SELECT      GREATEST('한지민', '김지민', '박지민'), LEAST('한지민', '김지민', '박지민')
FROM        dual;