/*Employee Management System:
Consider three tables: employees2, departments, and salaries.
 
employees2 table: employee_id, employee_name, department_id, hire_date
departments table: department_id, department_name
salaries table: employee_id, salary_amount, salary_date
Write a SQL query to retrieve the names of employees2 along with their department names and the latest salary amount.*/

SELECT e.employee_id,e.employee_name, d.department_name, s.salary_amount
FROM employees2 e
JOIN departments d ON e.department_id = d.department_id
JOIN (
    SELECT s1.employee_id, s1.salary_amount
    FROM salaries s1
    JOIN (
        SELECT employee_id, MAX(salary_date) AS latest_salary_date
        FROM salaries
        GROUP BY employee_id
    ) s2 ON s1.employee_id = s2.employee_id AND s1.salary_date = s2.latest_salary_date
) s ON e.employee_id = s.employee_id ORDER BY employee_id;

/*Product Inventory:
You have tables products, categories, and orders.
 
products table: product_id, product_name, category_id, price
categories table: category_id, category_name
orders table: order_id, product_id, quantity, order_date
Write a SQL query to find out the total revenue generated from each category in the last month.*/

SELECT 
    c.category_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM 
    products p
JOIN 
    orders o ON p.product_id = o.product_id
JOIN 
    categories c ON p.category_id = c.category_id
WHERE 
    DATEPART(MONTH, o.order_date) = DATEPART(MONTH, GETDATE()) - 1
    AND DATEPART(YEAR, o.order_date) = DATEPART(YEAR, GETDATE())
GROUP BY 
    c.category_name;

/*Library Management System:
You're dealing with books, authors, and borrowers tables.
 
books table: book_id, book_title, author_id, publication_date
authors table: author_id, author_name, author_country
borrowers table: borrower_id, book_id, borrower_name, borrow_date, return_date
Write a SQL query to list all books along with their authors and the borrowers who borrowed them, including the borrow and return dates.*/
SELECT 
    b.book_title, 
    a.author_name, 
    br.borrower_name, 
    br.borrow_date, 
    br.return_date
FROM 
    books b
JOIN 
    authors a ON b.author_id = a.author_id
JOIN 
    borrowers br ON b.book_id = br.book_id;

/*University Enrollment:
There are tables students, courses, enrollments, and grades.
 
students table: student_id, student_name, student_major
courses table: course_id, course_name, course_department
enrollments table: enrollment_id, student_id, course_id, enrollment_date
grades table: grade_id, enrollment_id, grade_value
Write a SQL query to calculate the average grade for each course.*/

SELECT c.course_name, AVG(g.grade_value) AS Course_Avg
FROM
	courses c
JOIN
	enrollments e ON e.course_id = c.course_id
JOIN
	grades g ON g.enrollment_id = e.enrollment_id
GROUP BY 
c.course_name;

/*E-commerce Analysis:
You have tables customers, orders, and products.
 
customers table: customer_id, customer_name, customer_country
orders table: order_id, customer_id, product_id, order_date, order_quantity
products table: product_id, product_name, product_price
Write a SQL query to find out the total revenue generated from customers in each country.*/

SELECT c.customer_country,SUM(o.order_quantity*p.product_price) as Total_Revenue
FROM 
	customers c 
JOIN 
	orders o ON c.customer_id = o.order_id
JOIN 
	products p ON p.product_id = o.product_id
GROUP BY c.customer_country;

	


 
