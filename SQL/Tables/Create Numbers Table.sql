/**************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.25
** CREATION:     Create a numbers table for future use. 
                 Code courtsey of Itzik Ben-Gan
**************************************************************************/
SET NOCOUNT ON;

IF EXISTS (SELECT 'x' FROM sys.tables WHERE OBJECT_ID = OBJECT_ID ('dbo.numbers'))
BEGIN
	DROP TABLE dbo.numbers
END

CREATE TABLE dbo.numbers 
(
	number INTEGER NOT NULL CONSTRAINT PK_numbers PRIMARY KEY CLUSTERED (number) 
	WITH( FILLFACTOR = 100)
);

WITH
  L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
  L1   AS(SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
  L2   AS(SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
  L3   AS(SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
  L4   AS(SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
  L5   AS(SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
  Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
INSERT INTO dbo.numbers
SELECT	n
FROM	Nums 
WHERE	n <= 100000000
ORDER BY n;

SELECT COUNT(*) 
FROM dbo.numbers
