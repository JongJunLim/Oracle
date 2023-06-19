CREATE TABLE stage_table(
    id INT PRIMARY KEY,
    Stage VARCHAR2(20),
    Stage1_Actual DATE,
    Stage1_Plan DATE,
    Stage2_Actual DATE,
    Stage2_Plan DATE,
    Stage3_Actual DATE,
    Stage3_PLAN DATE    
);

INSERT INTO stage_table(id, stage, Stage1_Actual, Stage1_Plan, Stage2_Actual, Stage2_Plan, Stage3_Actual, Stage3_PLAN)
VALUES(1
       ,'Complete'
       , TO_DATE('2023-05-01', 'yyyy-mm-dd')
       , TO_DATE('2023-05-03', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-15', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-14', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-20', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-25', 'yyyy-mm-dd'));

INSERT INTO stage_table(id, stage, Stage1_Actual, Stage1_Plan, Stage2_Actual, Stage2_Plan, Stage3_Actual, Stage3_PLAN)
VALUES(2
       ,'Stage3'
       , TO_DATE('2023-05-02', 'yyyy-mm-dd')
       , TO_DATE('2023-05-05', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-10', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-20', 'yyyy-mm-dd')
       ,NULL
       ,TO_DATE('2023-05-30', 'yyyy-mm-dd'));
      
SELECT *
 FROM stage_table;


-- 1개 UNPIVOT 
SELECT ID, Stage, End_Actual FROM 
 (SELECT id, Stage1_Actual, Stage2_Actual FROM stage_table)
UNPIVOT( End_Actual -- unpivot_clause
         FOR Stage -- unpivot_for_clause
         IN ( -- unpivot_in_clause
             Stage1_Actual AS 'Stage1',
              Stage2_Actual AS 'Stage2'
    )
);

-- 2개 UNPIVOT
SELECT ID, Stage, End_Actual, End_Plan 
 FROM (SELECT id, Stage1_Actual, Stage2_Actual, Stage3_Actual, Stage1_Plan, Stage2_Plan, Stage3_Plan FROM stage_table)
UNPIVOT( (End_Actual, End_Plan) -- unpivot_clause
         FOR Stage -- unpivot_for_clause
         IN ( -- unpivot_in_clause
             (Stage1_Actual, Stage1_Plan) AS 'Stage1',
             (Stage2_Actual, Stage2_Plan) AS 'Stage2',
             (Stage3_Actual, Stage3_Plan) AS 'Stage3'
    )
);  


-- 테이블 제거 
-- DROP TABLE stage_table;


SELECT job, HIREDATE
 FROM emp;

SELECT * 
  FROM ( 
         SELECT job , TO_CHAR(hiredate, 'FMMM') || '월' hire_month 
           FROM emp 
       ) 
 PIVOT (
         COUNT(*) 
         FOR hire_month IN ('1월', '2월', '3월', '4월', '5월', '6월',
                            '7월', '8월', '9월', '10월', '11월', '12월') 
       );
