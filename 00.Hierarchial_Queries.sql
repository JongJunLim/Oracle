--계층형 쿼리(Hierarchial Queries)
	-- 테이블에 계층형 데이터가 존재하는 경우, 계층형 쿼리를 사용하면 계층 정보와 함께 데이터를 조회할 수 있다.
		-- 계층형 데이터란, 데이터 간에 상하위 관계(부모-자식)를 가진 데이터를 말한다.
		-- 계층형 데이터를 가지도록 설계된 모델을 순환 관계 데이터 모델이라고 한다.
		-- 순환 관계 데이터 모델의 예로는 조직도, 제품군, 메뉴 트리 등이 있다.
		-- 루트(Root) 노드, 브랜치(Branch) 노드, 리프(Leaf) 노드
	-- START WITH 절과 CONNECT BY 절은 WHERE 절과 GROUP BY절 사이에 기술한다.
		-- START WITH절에는 루트 노드를 생성하기 위한 조건을 기술한다.
			-- START WITH 절은 1번만 수행되며 생략이 가능하다.
		-- CONEECT BY 절에는 루트 노드의 하위 노드를 생성하기 위한 조건을 기술한다.
			-- 브랜치 노드와 리프 노드를 생성하며, 조회 결과가 없을 때까지 반복 수행된다.
SELECT col1, col2 ,...
	FROM TABLE
   WHERE 조건
 [START WITH 조건] 
 CONNECT BY 조건
   GROUP BY col,...
   	 HAVING 조건
   ORDER [SIBLINGS] BY col, ...
 ;


SELECT LEVEL AS lv
	  ,a.empno
	  ,a.ename
	  ,a.mgr
	FROM emp a
START WITH a.mgr IS NULL
CONNECT BY a.mgr = PRIOR a.empno;
	
	-- 동작 원리
		-- START WITH 절을 수행하여 루트 노드를 생성한 후,
		-- CONNECT BY 절의 결과가 없을 때까지 부모 노드의 결과로 CONNECT BY절(JOIN)을 반복 수행(SELF JOIN을 위한 조건) 

SELECT a.empno
	  ,a.ename
	  ,a.mgr
	  ,PRIOR a.empno           AS PR_ENO -- 자신의 이전 노드의 값을 리턴  
	  ,PRIOR a.ename           AS PR_ENM -- 루트 노드의 값을 리턴
	  ,CONNECT_BY_ROOT a.ename AS RT_ENM
	FROM emp a
START WITH a.mgr IS NULL
CONNECT BY a.mgr = PRIOR a.empno;
	
SELECT a.empno
	  ,a.ename
	  ,a.mgr
	  ,LEVEL                   AS LV       -- 현재 노드의 레벨을 리턴 
	  ,CONNECT_BY_ISLEAF       AS IS_LEAF  -- 리프 노드이면 1, 아니면 0   
	  ,CONNECT_BY_ISCYCLE      AS IS_CYCLE -- CYCLE이 발생하면 1, 아니면 0 (하위에서 상위를 추적하게 될때 표시) 
	FROM emp a
START WITH a.mgr IS NULL
CONNECT BY NOCYCLE a.mgr = PRIOR a.empno;  -- NOCYCLE 를 넣으면 무한반복또는 에러 발생하지 않고 값 리턴 	
	
SELECT LEVEL                   AS LV       
      ,a.empno
      ,a.ename
      ,a.mgr  
	  ,SYS_CONNECT_BY_PATH(a.ename, ' / ')      AS PATH_ENAME -- 루트 노드에서 현재 노드까지의 column 값을 delimiter 문자로 구분하여 연결한 값을 리턴  
	FROM emp a
START WITH a.mgr IS NULL
CONNECT BY NOCYCLE a.mgr = PRIOR a.empno;	
	
	-- 계층 정렬
		-- ORDER BY 절에 SIBLINGS 키워드를 사용하면 형제 노드 내에서만 행이 정렬되기 때문에 계층 구조를 유지한 채로 행을 정렬할 수 있다.
SELECT LEVEL                   AS LV       
      ,a.empno
      ,a.ename
      ,a.mgr    
	FROM emp a
START WITH a.mgr IS NULL
CONNECT BY NOCYCLE a.mgr = PRIOR a.empno
ORDER  SIBLINGS BY a.sal, a.ename;
	
	-- 순방향 전개
		-- 부모 노드에서 자식 노드로 계층을 전개
			-- START WITH 절에 부모 노드 생성 조건을 기술하고, CONNECT BY절의 조건 중 PRIOR 연산자 뒤에 자식 노드의 컬럼 기술
	-- 역방향 전개
		-- 자식 노드에서 부모 노드로 계층을 전개
			-- START WITH 절에 자식 노드 생성 조건을 기술하고, CONNECT BY절의 조건 중 PRIOR 연산자 뒤에 부모 노드의 컬럼 기술
SELECT LEVEL                   AS LV       
      ,a.empno
      ,a.ename
      ,a.mgr    
	FROM emp a
START WITH a.ename = 'ADAMS'
CONNECT BY a.empno = PRIOR a.mgr;
	
		-- 전개 방향이 반대일뿐, 동작 원리는 동일하다
	
	-- 분기(branch) 제거
		-- CONNECT BY절 반속 수행 시 필터 조건에 의해 중간 노드에 해당하는 행이 제외되면, 그 하위 노드들도 모두 결과에서 제외된다.
SELECT LEVEL                   AS LV       
      ,a.empno
      ,a.ename
      ,a.mgr    
	FROM emp a
START WITH a.mgr IS NULL
CONNECT BY a.mgr = PRIOR a.empno
	   AND a.ename <> 'BLAKE';

	-- 노드(node) 제거
		-- WHERE 절 조건은 전체 노드를 모두 전개한 후에 적용된다.
			-- 즉, 조건을 만족하지 않는 특정 노드(행)만 결과에서 제외될 뿐 그 하위 노드와는 무관하다.
SELECT LEVEL                   AS LV       
      ,a.empno
      ,a.ename
      ,a.mgr    
	FROM emp a
   WHERE a.ename <> 'BLAKE'
START WITH a.mgr IS NULL
CONNECT BY a.mgr = PRIOR a.empno;
	
	-- 재귀 서브쿼리 팩토링(Recursive Subquery Factoring)
		-- ANSI 표준 SQL 문법으로, WITH 절을 사용하여 계층형 쿼리를 작성할 수 있다.
WITH emp_w (lv, empno, ename, mgr) AS 
(
 SELECT 1 AS lv
 	   ,a.empno
 	   ,a.ename
 	   ,a.mgr
   FROM emp a
  WHERE a.mgr IS NULL -- START WITH 절
 UNION ALL 
 SELECT a.lv + 1 AS lv
       ,b.empno
       ,b.ename
       ,b.mgr
   FROM emp_w a, emp b
  WHERE b.mgr = a.empno) -- CONNECT BY 절
 
SELECT a.*
	FROM emp_w a;
