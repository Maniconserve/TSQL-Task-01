/*1. Select all departments in all locations where the Total Salary of a Department is Greater than twice the Average Salary for the department.
And max basic for the department is at least thrice the Min basic for the department*/
SELECT DEPT_NAME,DEPT_LOC 
FROM DEPARTMENTS3
WHERE DEPT_ID IN 
(SELECT DEPT_ID FROM EMPLOYEES3 GROUP BY DEPT_ID HAVING SUM(SALARY)>2*AVG(SALARY) AND MAX(SALARY)> 3*MIN(SALARY));

/*2. As per the companies rule if an employee has put up service of 1 Year 3 Months and 15 days in office, Then She/he would be eligible for a Bonus.
the Bonus would be Paid on the first of the Next month after which a person has attained eligibility. Find out the eligibility date for all the employees. 
And also find out the age of the Employee On the date of Payment of the First bonus. Display the Age in Years, Months, and Days.
 Also Display the weekday Name, week of the year, Day of the year and week of the month of the date on which the person has attained the eligibility*/
WITH EligibilityCTE AS (
    SELECT
        Emp_ID,
        Emp_Name,
        DOB,
        DateOfJoining,
        DATEADD(DAY, 15, DATEADD(MONTH, 3, DATEADD(YEAR, 1, DateOfJoining))) AS Eligibility_Date,
        DATEADD(DAY, 1, EOMONTH(DATEADD(DAY, 15, DATEADD(MONTH, 3, DATEADD(YEAR, 1, DateOfJoining))))) AS Eligibility_Date_Next
    FROM Employees
)
SELECT
    Emp_ID,
    Emp_Name,
    DateOfJoining,
    DOB,
    Eligibility_Date,
    CONCAT(
        DATEDIFF(YEAR, Eligibility_Date_Next, DOB), ' Years ',
        (DATEDIFF(MONTH, Eligibility_Date_Next, DOB) % 12), ' Months ',
        (DATEDIFF(DAY, Eligibility_Date_Next, DOB) % 30), ' Days'
    ) AS Age_On_Eligibility_Date
FROM EligibilityCTE;

/*3. Company Has decided to Pay a bonus to all its employees. The criteria is as follows
1. Service Type 1. Employee Type 1. Minimum service is 10. Minimum service left should be 15 Years. Retirement age will be 60
Years
2. Service Type 1. Employee Type 2. Minimum service is 12. Minimum service left should be 14 Years . Retirement age will be 55
Years
3. Service Type 1. Employee Type 3. Minimum service is 12. Minimum service left should be 12 Years . Retirement age will be 55
Years
3. for Service Type 2,3,4 Minimum Service should Be 15 and Minimum service left should be 20 Years . Retirement age will be 65
Years
Write a query to find out the employees who are eligible for the bonus.*/
WITH EmployeeService AS (
    SELECT
        Emp_ID,
        Emp_Name,
        DOB,
        DateOfJoining,
        ServiceType,
        EmployeeType,
        DATEDIFF(YEAR, DateOfJoining, GETDATE()) AS YearsOfService,
        CASE 
            WHEN ServiceType = 1 AND EmployeeType = 1 THEN 60
            WHEN ServiceType = 1 AND EmployeeType = 2 THEN 55
            WHEN ServiceType = 1 AND EmployeeType = 3 THEN 55
            ELSE 65
        END AS RetirementAge,
        CASE 
            WHEN ServiceType = 1 AND EmployeeType = 1 THEN 10
            WHEN ServiceType = 1 AND EmployeeType = 2 THEN 12
            WHEN ServiceType = 1 AND EmployeeType = 3 THEN 12
            ELSE 15
        END AS MinService,
        CASE 
            WHEN ServiceType = 1 AND EmployeeType = 1 THEN 15
            WHEN ServiceType = 1 AND EmployeeType = 2 THEN 14
            WHEN ServiceType = 1 AND EmployeeType = 3 THEN 12
            ELSE 20
        END AS MinServiceLeft
    FROM Employees
),
EligibleEmployees AS (
    SELECT 
        Emp_ID,
        Emp_Name,
        DOB,
        DateOfJoining,
        YearsOfService,
        RetirementAge - DATEDIFF(YEAR, DOB, GETDATE()) AS YearsLeft,
        MinService,
        MinServiceLeft
    FROM EmployeeService
    WHERE
        YearsOfService >= MinService AND
        (RetirementAge - DATEDIFF(YEAR, DOB, GETDATE())) >= MinServiceLeft
)
SELECT 
    Emp_ID,
    Emp_Name,
    DOB,
    DateOfJoining,
    YearsOfService,
    YearsLeft,
    MinService,
    MinServiceLeft
FROM 
    EligibleEmployees;

/*4.write a query to Get Max, Min and Average age of employees, service of employees by service Type , Service Status for each Centre(display in years and Months)*/
WITH EmployeeDetails AS (
    SELECT
        Center_ID,
        ServiceType,
        ServiceStatus,
        Emp_ID,
        Emp_Name,
        DATEDIFF(YEAR, DOB, GETDATE()) AS AgeYears,
        DATEDIFF(MONTH, DOB, GETDATE()) % 12 AS AgeMonths,
        DATEDIFF(YEAR, DateOfJoining, GETDATE()) AS ServiceYears,
        DATEDIFF(MONTH, DateOfJoining, GETDATE()) % 12 AS ServiceMonths
    FROM Employees
),
AgeServiceSummary AS (
    SELECT
        Center_ID,
        ServiceType,
        ServiceStatus,
        MAX(AgeYears * 12 + AgeMonths) AS MaxAgeInMonths,
        MIN(AgeYears * 12 + AgeMonths) AS MinAgeInMonths,
        AVG(AgeYears * 12 + AgeMonths) AS AvgAgeInMonths,
        MAX(ServiceYears * 12 + ServiceMonths) AS MaxServiceInMonths,
        MIN(ServiceYears * 12 + ServiceMonths) AS MinServiceInMonths,
        AVG(ServiceYears * 12 + ServiceMonths) AS AvgServiceInMonths
    FROM EmployeeDetails
    GROUP BY Center_ID, ServiceType, ServiceStatus
)
SELECT
    c.Center_Name,
    a.ServiceType,
    a.ServiceStatus,
    a.MaxAgeInMonths / 12 AS MaxAgeYears,
    a.MaxAgeInMonths % 12 AS MaxAgeMonths,
    a.MinAgeInMonths / 12 AS MinAgeYears,
    a.MinAgeInMonths % 12 AS MinAgeMonths,
    a.AvgAgeInMonths / 12 AS AvgAgeYears,
    a.AvgAgeInMonths % 12 AS AvgAgeMonths,
    a.MaxServiceInMonths / 12 AS MaxServiceYears,
    a.MaxServiceInMonths % 12 AS MaxServiceMonths,
    a.MinServiceInMonths / 12 AS MinServiceYears,
    a.MinServiceInMonths % 12 AS MinServiceMonths,
    a.AvgServiceInMonths / 12 AS AvgServiceYears,
    a.AvgServiceInMonths % 12 AS AvgServiceMonths
FROM
    AgeServiceSummary a
    JOIN Centers c ON a.Center_ID = c.Center_ID;

/*5. Write a query to list out all the employees where any of the words (Excluding Initials) in the Name starts and ends with the same
character. (Assume there are not more than 5 words in any name )*/
WITH SplitNames AS (
    SELECT
        Emp_ID,
        Emp_Name,
        LTRIM(RTRIM(SUBSTRING(Emp_Name, 1, CHARINDEX(' ', Emp_Name + ' ') - 1))) AS Word1,
        LTRIM(RTRIM(SUBSTRING(Emp_Name, CHARINDEX(' ', Emp_Name + ' ') + 1, CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) - CHARINDEX(' ', Emp_Name + ' ') - 1))) AS Word2,
        LTRIM(RTRIM(SUBSTRING(Emp_Name, CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) + 1, CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) + 1) - CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) - 1))) AS Word3,
        LTRIM(RTRIM(SUBSTRING(Emp_Name, CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) + 1) + 1, CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) + 1) + 1) - CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) + 1) - 1))) AS Word4,
        LTRIM(RTRIM(SUBSTRING(Emp_Name, CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ', CHARINDEX(' ', Emp_Name + ' ') + 1) + 1) + 1) + 1, LEN(Emp_Name)))) AS Word5
    FROM Employees
)
SELECT
    Emp_ID,
    Emp_Name
FROM
    SplitNames
WHERE
    (
        LEN(Word1) > 1 AND LEFT(Word1, 1) = RIGHT(Word1, 1)
    ) OR (
        LEN(Word2) > 1 AND LEFT(Word2, 1) = RIGHT(Word2, 1)
    ) OR (
        LEN(Word3) > 1 AND LEFT(Word3, 1) = RIGHT(Word3, 1)
    ) OR (
        LEN(Word4) > 1 AND LEFT(Word4, 1) = RIGHT(Word4, 1)
    ) OR (
        LEN(Word5) > 1 AND LEFT(Word5, 1) = RIGHT(Word5, 1)
    );
