--비표준 조인
SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id;
--표준 조인 (NATURAL JOIN) --자동으로 공통칼럼 찾아서 사용.
SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees NATURAL JOIN departments;
--표준 조인 (JOIN ~ USING절)
SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees INNER JOIN departments USING(department_id);


REM 3개 이상의 테이블 조인 : employess, departments, locations, countries 테이블 연결.
--비표준 조인 (등가조인)
SELECT employee_id, first_name, hire_date, department_name, city, state_province, country_name
FROM employees e, departments d, locations lo, countries c
WHERE e.department_id = d.department_id --employee와 departments의 관계 (공통칼럼)
            AND d.location_id = lo.location_id  --departments와 locations의 관계 (공통칼럼)
            AND lo.country_id = c.country_id   --locations와 countires의 관계 (공통칼럼)
            AND e.department_id IN (10, 20, 30, 40);
            
--표준 조인( JOIN ~ ON 절)  --비표준 등가조인과 동일.
SELECT employee_id, first_name, hire_date, e.department_id, department_name, city, state_province, country_name
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id
            INNER JOIN locations lo ON d.location_id = lo.location_id
            INNER JOIN countries c ON lo.country_id = c.country_id
WHERE e.department_id IN (10, 20, 30, 40);    --NATURAL JOIN : 공통칼럼에 식별자 X

--표준 조인 (NATURAL JOIN)  --비표준 등가조인과 결과 다름.
--등가조인, JOIN ~ ON절보다 공통칼럼 더 많으므로 범위 제한. --더 작은 데이터 나옴.
SELECT employee_id, first_name, hire_date, department_name, city, state_province, country_name
FROM employees e NATURAL JOIN departments d NATURAL JOIN locations lo NATURAL JOIN countries c
WHERE department_id IN (10, 20, 30, 40);    --NATURAL JOIN : 공통칼럼에 식별자 X

--표준 조인 (JOIN ~ USING절) --비표준 등가조인과 결과 다름.
--등가조인, JOIN ~ ON절보다 공통칼럼 더 많으므로 범위 제한. --더 작은 데이터 나옴.
SELECT employee_id, first_name, hire_date, department_id, department_name, city, state_province, country_name
FROM employees e INNER JOIN departments d USING(department_id, manager_id) INNER JOIN locations lo USING(location_id)     --유의!!  Employess와 Departments의 공통칼럼 : department_id, Manager_id --( departments d USING(department_id) AND departments d INNER JOIN locaions lo ~ )에서 AND departments d 생략됨. --
            INNER JOIN countries c USING(country_id)
WHERE department_id IN (10, 20, 30, 40);    --NATURAL JOIN : 공통칼럼에 식별자 X


REM 포괄조인, 외부조인, OUTER JOIN
--혹시 특정 부서에 사원이 한명도 없는가? (사원이 없는 부서가 존재?)
--비표준 조인 (RIGHT OUTER JOIN) (+연산자가 왼쪽에 있어서)
SELECT  employee_id, first_name, e.department_id, d.department_id, department_name
FROM  employees e, departments d
WHERE e.department_id(+) = d.department_id;   --정보 부족한 쪽에 (+) --오른쪽 테이블에 맞게 왼쪽 테이블 출력 (왼쪽 테이블에 NULL발생할 수 있음).
--표준 조인 (RIGHT OUTER JOIN ~ ON) (정보 부족한 테이블이 왼쪽에)
SELECT  employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id = d.department_id;  --공통칼럼 명시.

--사원 중 소속 부서가 없는 사원이 있는가?
--비표준 조인 (LEFT OUTER JOIN) (+가 오른쪽에_
SELECT  employee_id, first_name, e.department_id, d.department_id, department_name
FROM  employees e, departments d
WHERE e.department_id = d.department_id(+);    --부서쪽이 정보 부족하게 출력. --왼쪽 테이블에 맞게 오른쪽 테이블 데이터 출력.
--표준 조인 (LEFT OUTER JOIN) (정보 부족한 테이블이 오른쪽에 위치)
SELECT  employee_id, first_name, e.department_id, d.department_id, department_name
FROM  employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id;

REM FULL 포괄 조인 (FULL 조인 : 표준 조인만 있음)
--억지로 FULL 조인을 비표준으로 하려면 UNION 사용.
--소속이 없는 사원, 사원이 한 명도 없는 부서 모두 출력하기.
SELECT  employee_id, first_name, e.department_id, d.department_id, department_name
FROM  employees e, departments d
WHERE e.department_id(+) = d.department_id
UNION
SELECT  employee_id, first_name, e.department_id, d.department_id, department_name
FROM  employees e, departments d
WHERE e.department_id = d.department_id(+);

--표준 조인 (FULL 조인) (RIGHT JOIN + LEFT JOIN) --소속이 없는 사원, 사원이 한 명도 없는 부서 출력.
SELECT  employee_id, first_name, e.department_id, d.department_id, department_name
FROM  employees e FULL OUTER JOIN departments d ON e.department_id = d.department_id;

