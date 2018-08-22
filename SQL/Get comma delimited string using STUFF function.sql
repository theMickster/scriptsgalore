/**************************************************************************************
** CREATED BY:   Mick Letofsky
** CREATED DATE: 2018.08.06
** CREATION:     Quick script to get a comma separated list of data. 
**************************************************************************************/

DECLARE @patient_list VARCHAR(MAX)
SET @patient_list  = (SELECT STUFF((SELECT ','+ CAST(p.PersonID AS VARCHAR(10)) FROM dbo.People p
WHERE p.PersonID BETWEEN 1 AND 1000
FOR XML PATH('')), 1, 1, ''));

SELECT @patient_list