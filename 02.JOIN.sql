-- Join
  -- 조인 문법을 사용하면 여러 테이블에 저장되어 있는 데이터를 함께 조회할 수 있다.
    -- 관계형 데이터 베이스에서는 정규화에 의해 여러 테이블에 데이터가 나뉘어 저장되어 있으므로, 이들을 함께 조회하기 위해서는 반드시 조인이 필요하다.
  -- 조인은 두 테이블 간에 특정 컬럼(들)의 값을 비교하여, 비교 결과가 TRUE인 행들을 연결시킨다.
    -- FROM 절에는 조인할 테이블들을 콤마(,)로 구분하여 기술한다.
    -- WHERE 절에는 조인 조건(양쪽 테이블 컬럼들간의 비교 조건) 및 일반 조건을 함께 기술한다.

SELECT A.컬럼, B.컬럼, ...
  FROM Table A, Table B, ...
 WHERE 조인 조건
   AND 일반 조건;

  -- 조인은 선행 집합의 조인 컬럼 값을 가지고, 후행 집합을 반복적으로 Lookup하면서 조인 조건이 TRUE가 되는 행을 서로 연결하여 결과 집합에 포함시킨다.
    -- 집합을 읽는 순서는 DBMS(옵티마이저)에 의해 정해진다.

SELECT B.EMPNO, B.ENAME, B.JOB, A.DEPTNO, A.DNAME
  FROM DEPT A, EMP B
 WHERE B.DEPTNO = A.DEPTNO          -- 조인 조건
   AND A.DNAME = 'RESEARCH'         -- 일반 조건
   AND B.JOB IN ('CLECK','ANALYST') -- 일반 조건
 ORDER BY B.SAL;

SELECT B.EMPNO, B.ENAME, B.JOB, A.DEPTNO, A.DNAME
  FROM DEPT A, EMP B
 WHERE B.DEPTNO = A.DEPTNO                      -- 조인 조건
 GROUP BY A.DEPTNO, TO_CHAR(B.HIREDATE, 'YYYY') -- 그룹화 조건
 ORDER BY A.DEPTNO, TO_CHAR(B.HIREDATE, 'YYYY');

  -- 1:M 관계에 있는 두 테이블을 조인하면, 1쪽 테이블의 행이 M쪽 테이블에 맞춰 늘어난다.
SELECT COUNT(B.EMPNO)           AS CNT_EMP
      ,COUNT(A.DEPTNO)          AS WRONG_CNT_DEPT
      ,COUNT(DISTINCT A.DEPTNO) AS CNT_DEPT
  FROM DEPT A, EMP B
 WHERE B.DEPTNO = A.DEPTNO; 

  -- 비등가 조인 (<>, <, BETWEEN, LIKE)
SELECT *
  FROM EMP A, SALGRADE B
 WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL;

  -- 순환 관계 데이터 모델 (계층형 모델)
    -- 각 관리자는 여러 명의 사원을 관리 할 수 있다.
    -- 각 사원은 한 명의 관리자를 가질 수 있다.
SELECT B.EMPNO, B.ENAME, A.EMPNO, A.ENAME 
	FROM EMP A -- 사원
      ,EMP B -- 관리자
    WHERE B.EMPNO = A.MGR; 

  -- Inner Join
    -- 조인에 성공한 행들만 리턴하는 조인
  -- Outer Join
    -- Inner Join의 결과와 조인에 실패한 기준 집합의 행들을 함께 리턴하는 조인
    -- 오라클에서는 조인 조건에 (+) 기호를 사용하여 기준 집합을 지정한다.
    -- (+) 기호가 사용된 쪽의 반대쪽 집합이 기준 집합이 된다.
SELECT B.EMPNO, B.ENAME, B.JOB, B.DEPTNO, A.DEPTNO, A.DNAME, A.LOC
  FROM DEPT A, EMP B
 WHERE B.DEPTNO(+) = A.DEPTNO
   AND A.LOC IN ('NEW YORK','BOSTON');

SELECT B.EMPNO, B.ENAME, B.JOB, B.DEPTNO, A.DEPTNO, A.DNAME, A.LOC
  FROM DEPT A, EMP B
 WHERE B.DEPTNO(+) = A.DEPTNO -- 2) A.DEPTNO를 기준으로 조인이 되고 없는 값들도 보여짐
   AND B.DEPTNO(+) <> 20; -- 1) 20이 아닌 것들 먼저 거름

SELECT B.EMPNO, B.ENAME, B.JOB, B.DEPTNO, A.DEPTNO, A.DNAME, A.LOC
  FROM DEPT A, EMP B
 WHERE B.DEPTNO(+) = A.DEPTNO
   AND B.DEPTNO <> 20; -- (+) 기호 누락

  -- Cross Join
    -- 양쪽 집합의 카타시안 곱(M*N건)을 리턴하는 조인
    -- 양쪽 집합 간에 조인 조건이 없을 때 Cross Join이 수행된다.
SELECT B.EMPNO, B.ENAME, B.JOB, B.DEPTNO, A.DEPTNO, A.DNAME, A.LOC
  FROM DEPT A, EMP B
 WHERE A.LOC IN ('NEW YORK','BOSTON')                 -- 일반 조건
   AND B.JOC IN ('ANALYST' , 'MANAGER', 'PRESIDENT'); -- 일반 조건

  -- ANSI 표준 조인
    -- 오라클을 포함한 대부분의 상용 DBMS는 ANSI(American National Standards Institue) 표준 문법을 지원한다.
    -- ANSI 조인 문법은 조인 조건과 일반 조건을 구분하여 기술한다.
      -- FROM 절에는 조인할 테이블과 조인 유형을 기술한다.
      -- ON 절에는 조인 조건을, WHERE 절에는 일반 조건을 기술한다. (ON 절에 기술한 조건은 모두 조인 조건으로 동작한다.)

SELECT A.컬럼, B.컬럼, ...
  FROM Table A
  JOIN 
  TYPE Table B ... -- JOIN (INNER JOIN), LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN
    ON (조인 조건)
 WHERE 일반 조건;

    -- WHERE 절에 비기준 집합에 대한 일반 조건을 기술하면 INNER JOIN이 수행된다. (ON 절 안에 일반 조건 넣어주면 FULL OUTER 수행 됨)

  -- JOIN 실습







  -- Self Join 실습
    --1.
SELECT A.EMPNO, A.ENAME, A.MGR
	FROM emp A
	WHERE A.MGR IS NULL;

    --2.
SELECT B.EMPNO, B.ENAME, A.EMPNO, A.ENAME 
	FROM EMP A, EMP B
    WHERE A.MGR IS NULL
	  AND A.EMPNO = B.MGR; 

    --3.
SELECT C.EMPNO, C.ENAME,  B.EMPNO, B.ENAME, A.EMPNO, A.ENAME
 FROM EMP A --1번 사원 
     ,EMP B --2번 사원 / 1번 사원의 하위 사원
     ,EMP C --3번 사원 / 2번 사원의 하위 사원
     WHERE A.MGR IS NULL
	  AND A.EMPNO = B.MGR
	  AND B.EMPNO = C.MGR;
	 
	 
SELECT D.EMPNO, D.ENAME, C.EMPNO, C.ENAME,  B.EMPNO, B.ENAME, A.EMPNO, A.ENAME
 FROM EMP A --1번 사원 
     ,EMP B --2번 사원 / 1번 사원의 하위 사원
     ,EMP C --3번 사원 / 2번 사원의 하위 사원
     ,EMP D --4번 사원 / 3번 사원의 하위 사원
     WHERE A.MGR IS NULL
	  AND A.EMPNO = B.MGR(+)
	  AND B.EMPNO = C.MGR(+)
	  AND C.EMPNO = D.MGR(+); 
