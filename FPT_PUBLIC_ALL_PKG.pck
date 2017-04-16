CREATE OR REPLACE PACKAGE FPT_PUBLIC_ALL_PKG IS

  -- Author  : bkhero     
  -- Created : 2016/10/28
  -- Purpose : 

  PROCEDURE GET_CONCAT_SEGMENT(P_CCID NUMBER);

END FPT_PUBLIC_ALL_PKG;
/
CREATE OR REPLACE PACKAGE BODY FPT_PUBLIC_ALL_PKG IS

  PROCEDURE GET_CONCAT_SEGMENT(P_CCID NUMBER) IS
    V_CONCAT_SEG VARCHAR2(100);
    V_SEG        VARCHAR2(25);
    V_RESULT     VARCHAR2(100);
    CURSOR C_SEG IS
      SELECT *
        FROM (SELECT C.SEGMENT1,
                     C.SEGMENT2,
                     C.SEGMENT3,
                     C.SEGMENT4,
                     C.SEGMENT5,
                     C.SEGMENT6,
                     C.SEGMENT7,
                     C.SEGMENT8,
                     C.SEGMENT9,
                     C.SEGMENT10,
                     C.SEGMENT11,
                     C.SEGMENT12,
                     C.SEGMENT13,
                     C.SEGMENT14,
                     C.SEGMENT15,
                     C.SEGMENT16,
                     C.SEGMENT17,
                     C.SEGMENT18,
                     C.SEGMENT19,
                     C.SEGMENT20,
                     C.SEGMENT21,
                     C.SEGMENT22,
                     C.SEGMENT23,
                     C.SEGMENT24,
                     C.SEGMENT25,
                     C.SEGMENT26,
                     C.SEGMENT27,
                     C.SEGMENT28,
                     C.SEGMENT29,
                     C.SEGMENT30
                FROM GL_CODE_COMBINATIONS C
               WHERE C.CODE_COMBINATION_ID = P_CCID) UNPIVOT /*INCLUDE NULLS*/(VALUE FOR SEGMENTS IN(SEGMENT1 AS
                                                                                                     'SEGMENT1',
                                                                                                     SEGMENT2 AS
                                                                                                     'SEGMENT2',
                                                                                                     SEGMENT3 AS
                                                                                                     'SEGMENT3',
                                                                                                     SEGMENT4 AS
                                                                                                     'SEGMENT4',
                                                                                                     SEGMENT5 AS
                                                                                                     'SEGMENT5',
                                                                                                     SEGMENT6 AS
                                                                                                     'SEGMENT6',
                                                                                                     SEGMENT7 AS
                                                                                                     'SEGMENT7',
                                                                                                     SEGMENT8 AS
                                                                                                     'SEGMENT8',
                                                                                                     SEGMENT9 AS
                                                                                                     'SEGMENT9',
                                                                                                     SEGMENT10 AS
                                                                                                     'SEGMENT10',
                                                                                                     SEGMENT11 AS
                                                                                                     'SEGMENT11',
                                                                                                     SEGMENT12 AS
                                                                                                     'SEGMENT12',
                                                                                                     SEGMENT13 AS
                                                                                                     'SEGMENT13',
                                                                                                     SEGMENT14 AS
                                                                                                     'SEGMENT14',
                                                                                                     SEGMENT15 AS
                                                                                                     'SEGMENT15',
                                                                                                     SEGMENT16 AS
                                                                                                     'SEGMENT16',
                                                                                                     SEGMENT17 AS
                                                                                                     'SEGMENT17',
                                                                                                     SEGMENT18 AS
                                                                                                     'SEGMENT18',
                                                                                                     SEGMENT19 AS
                                                                                                     'SEGMENT19',
                                                                                                     SEGMENT20 AS
                                                                                                     'SEGMENT20',
                                                                                                     SEGMENT21 AS
                                                                                                     'SEGMENT21',
                                                                                                     SEGMENT22 AS
                                                                                                     'SEGMENT22',
                                                                                                     SEGMENT23 AS
                                                                                                     'SEGMENT23',
                                                                                                     SEGMENT24 AS
                                                                                                     'SEGMENT24',
                                                                                                     SEGMENT25 AS
                                                                                                     'SEGMENT25',
                                                                                                     SEGMENT26 AS
                                                                                                     'SEGMENT26',
                                                                                                     SEGMENT27 AS
                                                                                                     'SEGMENT27',
                                                                                                     SEGMENT28 AS
                                                                                                     'SEGMENT28',
                                                                                                     SEGMENT29 AS
                                                                                                     'SEGMENT29',
                                                                                                     SEGMENT30 AS
                                                                                                     'SEGMENT30'));
  BEGIN
    V_SEG        := '';
    V_CONCAT_SEG := '';
    FOR C_C IN C_SEG LOOP
      V_SEG        := C_C.VALUE;
      V_CONCAT_SEG := V_CONCAT_SEG || '.' || V_SEG;
    END LOOP;
    V_RESULT := SUBSTR(V_CONCAT_SEG, 2);
    --DBMS_OUTPUT.PUT_LINE('Tra ve concatenate segment: ' || V_RESULT);
  END;
END FPT_PUBLIC_ALL_PKG;
/
