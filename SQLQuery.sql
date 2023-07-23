Select *, DATEPART(HOUR, MaxTime)as Godzina, CONVERT(CHAR(10), MaxTime, 120) as Data

FROM
(
SELECT max(REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + '75') as CollectiveDateHour,
	MAX(75) VM,
	MAX('Electa2') Nazwa,
	max(REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + ':00:00') as CalculatedTime,
	COUNT(DH.SIT_ID) as SumaPacjentow,
	max (DH.Tx_DtTm) as MaxTime
FROM Dose_Hst DH
WHERE YEAR(DH.Tx_DtTm) in (2022, 2021)and WasQAMode = 0 
GROUP BY REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + '75'

UNION

SELECT max(REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + '101') as CollectiveDateHour,
	MAX(101) VM,
	MAX('Electa3') Nazwa,
	max(REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + ':00:00') as CalculatedTime,
	COUNT(DH.SIT_ID) as SumaPacjentow,
	max (DH.Tx_DtTm) as MaxTime
FROM Dose_Hst DH
WHERE YEAR(DH.Tx_DtTm) in (2022, 2021) and DATEPART(HOUR, DH.Tx_DtTm) between 7 and 15 and WasQAMode = 0 
GROUP BY REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + '101'

UNION

SELECT max(REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + '67') as CollectiveDateHour,
	MAX(67) VM,
	MAX('Electa1') Nazwa,
	max(REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + ':00:00') as CalculatedTime,
	COUNT(DH.SIT_ID) as SumaPacjentow,
	max (DH.Tx_DtTm) as MaxTime
FROM Dose_Hst DH
WHERE YEAR(DH.Tx_DtTm) in (2022, 2021) and WasQAMode = 0 
GROUP BY REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + '67'
) as WszystkieDaty
WHERE
WszystkieDaty.CollectiveDateHour NOT IN (Select Rzeczywiste.MaszynaDateHour
FROM
(
SELECT REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + ':00:00' as CalculatedTime,
ST.Last_Name,
DH.Machine_ID_Staff_ID,
max(REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + CAST(DH.Machine_ID_Staff_ID as varchar(3))) as MaszynaDateHour,
COUNT(DH.SIT_ID) AS Ile_naprom
FROM Dose_Hst DH INNER JOIN Staff ST ON DH.Machine_ID_Staff_ID=ST.Staff_ID
WHERE YEAR(DH.Tx_DtTm) in (2022, 2021)
GROUP BY DH.Machine_ID_Staff_ID,
	REPLACE(CONVERT(CHAR(10), DH.Tx_DtTm, 120),' ','-') + '-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, DH.Tx_DtTm)), 2) + ':00:00',
	ST.Last_Name
HAVING COUNT(DH.SIT_ID)>1
) as Rzeczywiste
)
ORDER BY CalculatedTime desc;
