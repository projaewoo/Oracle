REM 테이블 생성

CREATE TABLE member(
    id             VARCHAR(14),
    passwd      VARCHAR(20)
);

--테이블 생성됐는지 확인
DESC USER_TABLES;       --구조 확인.
--내가 만든 테이블 보여줘 
SELECT table_name
FROM user_tables;           --SELET * FROM tab;과 동일

SELECT * FROM tab;      --BIN$~ : 휴지통에 들어간 테이블들.

--학생 테이블 생성
CREATE TABLE Student1 (
    hakbun           CHAR(7),          --2020-01
    name             VARCHAR2(20),     --Oracle만 VARCHAR2, 나머지 DB는 VARCHAR
    addrress        VARCHAR2(200),      --한글 : 66자. (UNICODE : 한글 3Byte)
    age               NUMBER(3),    --연령은 최대 999이므로.
    birthday         DATE,   
    email             VARCHAR2(100),  --영어 : 100자리.
    height             NUMBER(4, 1),            --178.3
    weight            NUMBER(4, 1)              --110.3   --전체자리 4자리, 소숫점 이하 1자리.
);
--테이블 만들어졌는지 확인
SELECT table_name
FROM user_tables;

--테이블 안의 데이터만 삭제.
TRUNCATE TABLE Student;