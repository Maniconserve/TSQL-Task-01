--- Write a script to extracts all the numerics from Alphanumeric String
DECLARE @InputString NVARCHAR(100) = 'a1b2c3';
DECLARE @Length INT = LEN(@InputString);
DECLARE @Position INT = 1;
DECLARE @Result NVARCHAR(100) = '';

WHILE @Position <= @Length
BEGIN
    DECLARE @Char NCHAR(1) = SUBSTRING(@InputString, @Position, 1);
    
    IF @Char LIKE '[0-9]'
    BEGIN
        SET @Result = @Result + @Char;
    END

    SET @Position = @Position + 1;
END

SELECT @Result AS NumericString;

--- Write a script to calculate age based on the Input DOB
DECLARE @DOB DATE='11.04.2002'
SELECT DATEDIFF(YEAR,@DOB,GETDATE())

--- Create a column in a table and that should throw an error when we do SELECT * or SELECT of that column. If we select other columns then we should see results
CREATE TABLE TestTable (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    RestrictedColumn AS (1 / 0) 
);

INSERT INTO TestTable (ID, Name) VALUES (1, 'John'), (2, 'Jane');

SELECT * FROM TestTable;

SELECT ID, Name FROM TestTable;

/*Display Calendar Table based on the input year. If I give the year 2017 then populate data for 2017 only

Date e.g.  1/1/2017 

DayofYear 1 – 365/366 (Note 1)

Week 1-52/53

DayofWeek 1-7

Month 1-12

DayofMonth 1-30/31 (Note 2)

Note 1: DayofYear varies depending on the number of days in the given year.

Note 2: DayofMonth varies depending on number of days in the given month

Weekly calculations are always for a 7 day period Sunday to Saturday.
*/
create table calendar(
[date] date,
[dayofyear] as DATEPART(DAYOFYEAR, [date]),
[week] as DATEPART(WEEK, [date]),
[dayofweek] as DATEPART(WEEKDAY,[date]),
[month] as DATEPART(MONTH, [date]),
[dateofmonth] as DATEPART(DAY, [date])
);
DECLARE @year INT = 2016
DECLARE @date DATE = CONCAT(@year, '/01/01')
 
WHILE (YEAR(@date)=@year)
BEGIN
	INSERT INTO Calander VALUES (@date)
	SET @date = DATEADD(d, 1, @date)
END
select * from calander;


--- Display Emp and Manager Hierarchies based on the input till the topmost hierarchy. (Input would be empid)
--- Output: Empid, empname, managername, heirarchylevel
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    ManagerID INT NULL
);

INSERT INTO Employees (EmpID, EmpName, ManagerID) VALUES
(1, 'Pradeep', NULL),    
(2, 'Raj', 1),
(3, 'Sumith', 2),
(4, 'Team1', 3),
(5, 'Team2', 4),
(6, 'Team3', 5);


WITH heirarchy AS (
	SELECT EmpID,EmpName,ManagerID ,0 AS HeirarchyLevel FROM Employees WHERE EmpID=6
	UNION ALL
	SELECT Employees.EmpID,Employees.EmpName,Employees.ManagerID,heirarchy.HeirarchyLevel+1 FROM Employees JOIN heirarchy ON Employees.EmpID = heirarchy.ManagerID  
)SELECT h1.EmpID,h1.EmpName,h2.EmpName as ManagerName,h1.HeirarchyLevel FROM heirarchy as h1 LEFT JOIN heirarchy as h2 ON h1.managerID = h2.EmpID;
