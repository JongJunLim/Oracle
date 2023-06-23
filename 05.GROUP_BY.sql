SELECT 컬럼1, 컬럼2, ...
  FROM 테이블, ...
 WHERE 조건
 GROUP BY RULLUP / CUBE / GROUPING SETS (컬럼 [,컬럼, ...]);

-- 확장 기능 사용하지 않는 레벨 별 집계
SELECT a.deptno
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY a.deptno -- 부서별 집계
UNION ALL
SELECT NULL, SUM(a>sal)
  FROM emp a
  GROUP BY (); -- 전체 집계

--GROUPING SETS
  -- 괄호 안에 명시된 집계 칼럼들 별로 여러 개의 개별적인 집계 그룹을 생성
SELECT a.deptno
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY GROUPING SETS((a.deptno, a.job), a.job)
  ORDER BY a.deptno, a.job;

SELECT a.deptno
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY GROUPING SETS(a.deptno, ()) -- () : 전체를 의미
  ORDER BY a.deptno;

SELECT a.deptno
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY GROUPING SETS(a.deptno, a.job ()) -- () : 전체를 의미
  ORDER BY a.deptno, a.job;

SELECT a.deptno
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY a.deptno, GROUPING SETS(a.job ()) -- () : 전체를 의미
  ORDER BY a.deptno, a.job;

-- ROLLUP
  -- 집계 단위가 많아질수록 GROUPING SETS()로 하는 거보다 조회 속도 더 빠름
SELECT a.deptno
      ,a.job
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY ROLLUP (a.deptno, a.job) -- N + 1 집계 그룹 결과 나옴
  ORDER BY a.deptno, a.job;

SELECT a.deptno
      ,a.job
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY GROUPING SETS ( (a.deptno, a.job),
                            a.deptno,
                            () )  -- 위 쿼리와 같은 결과
  ORDER BY a.deptno, a.job;

SELECT a.deptno
      ,a.job
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY ROLLUP ((a.deptno, a.job))
  ORDER BY a.deptno, a.job;

SELECT a.deptno
      ,a.job
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY a.deptno ROLLUP (a.job)
  ORDER BY a.deptno, a.job;

-- GROUPING SETS + ROLLUP 응용
SELECT a.deptno
      ,a.job
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY GROUPING SETS (a.deptno, ROLLUP(a.job))
  ORDER BY a.deptno, a.job;

-- CUBE
  -- 괄호 안의 집계 컬럼들로 만들어지는 모든 경우의 수를 집계 기준으로 하여 집계 그룹 생성 (다차원 집계)
SELECT a.deptno
      ,a.job
      ,SUM(a.sal) AS SUM_SAL
  FROM emp a
  GROUP BY CUBE (a.deptno, a.job) -- 2^n 개수로 집계됨
  ORDER BY a.deptno, a.job;

-- GROUP BY 절의 확장 기능과 NULL
  -- GROUP BY 컬럼이 NOT NULL 인경우
SELECT NVL(a.job, 'Total') AS JOB 
      ,COUNT(*) AS CNT_EMP
  FROM emp a
  GROUP BY ROLLUP (a.job) 
  ORDER BY a.deptno, a.job;
  
  -- GROUP BY 컬럼이 NULLABLE
    -- GROUPING(expr) : 집계 컬럼 값이염 0, 아니면(그룹화된 값이면) 1을 리턴
SELECT a.comm
       ,GROUPING(a.comm) AS GRP
      ,COUNT(*) AS CNT_EMP
  FROM emp a
  GROUP BY ROLLUP (a.comm) 
  ORDER BY a.comm;

SELECT CASE WHEN GROUPING(a.comm) =1 
            THEN 'Total'
            ELSE TO_CHAR(a.comm)
       END AS COMM
      ,COUNT(*) AS CNT_EMP
  FROM emp a
  GROUP BY ROLLUP (a.comm) 
  ORDER BY a.comm;

    -- GROUPING_ID(expr [,edxpr, ...]) : 인자 1개 - GROUPING 함수와 동일한 결과 리턴 / 인자 N개 - 각 인자의 GROUPING 함수 리턴값을 2진수화 한 후, 그에 대한 10진수 값을 리턴
SELECT b.dname
      ,GROUOPING_ID(b.name)           AS GRP1
      ,a.comm
      ,GROUPING_ID(a.coomm)           AS GRP2
      ,GROUPING_ID(b.dname. a.coomm)  AS GRP_ID
      ,COUNT(*)                       AS CNT
  FROM emp a,
       dept b
 WHERE b.deptno = a.deptno
 GROUP BY CUBE (b.dname, a.comm) 
 ORDER BY b.dname, a.comm;

SELECT CASE WHEN GROUOPING_ID(b.name, a.comm) == 2
            THEN 'ALL DEPTS'
            WHEN GROUOPING_ID(b.name, a.comm) == 3
            THEN 'TOTAL'
            ELSE b.deptno
        END AS DNAME
       ,CASE WHEN GROUOPING_ID(b.name, a.comm) == 1
            THEN 'ALL DEPTS'
            WHEN GROUOPING_ID(b.name, a.comm) == 3
            THEN 'TOTAL'
            ELSE TO_CHAR(a.comm)
        END AS COMM
      ,GROUPING_ID(b.dname. a.coomm)  AS GRP_ID
      ,COUNT(*)                       AS CNT
  FROM emp a,
       dept b
 WHERE b.deptno = a.deptno
 GROUP BY CUBE (b.dname, a.comm) 
 ORDER BY b.dname, a.comm;

    -- HAVING 절 조건에 GROUPING_ID 함수 사용 예시 (성능 좋음)
SELECT b.dname
      ,a.comm
      ,GROUPING_ID(b.dname. a.coomm)  AS GRP_ID
      ,COUNT(*)                       AS CNT
  FROM emp a,
       dept b
 WHERE b.deptno = a.deptno
 GROUP BY CUBE (b.dname, a.comm) 
    HAVING GROUPING_ID(b.name, a.comm) IN (1,2)
 ORDER BY b.dname, a.comm;

    -- GROUP_ID() : 동일한 기준을 가진 집계 그룹에 대한 순번을 0부터 린턴 (1 이상이면 중복 집계 그룹이 존재)
SELECT b.dname
      ,a.job
      ,GROUP_ID()  AS GRP_ID
  FROM emp a,
       dept b
 WHERE b.deptno = a.deptno
 GROUP BY b.dname, ROLLUP (b.dname, a.comm);

SELECT b.dname
      ,a.job
      ,GROUP_ID()  AS GRP_ID
  FROM emp a,
       dept b
 WHERE b.deptno = a.deptno
 GROUP BY b.dname, ROLLUP (b.dname, a.comm)
  HAVING GROUP_ID() = 0; 

SELECT b.dname
      ,a.job
      ,GROUP_ID()  AS GRP_ID
  FROM emp a,
       dept b
 WHERE b.deptno = a.deptno
 GROUP BY b.dname, ROLLUP (a.comm); -- 위 쿼리와 같은 결과, BUT 성능은 더 좋음 (이유 : 다 만들어 놓고 HAVING 절로 거르는 거 보다 생성 자체를 적게 하는 것이 더 좋음)
