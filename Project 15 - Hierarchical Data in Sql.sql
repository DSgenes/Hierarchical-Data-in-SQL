/*

Hierarchical data in Sql

*/

--Problem Statement: Find Hierarchy of employees
--For each employee, showcase all the employee's working under them(including themselves).
--Such that, when the child tree expands i.e every new employee should be dynamically assigned to their
--managers till the top level hierarchy.
drop table employee_hierarchy;
create table employee_hierarchy
            (emp_id int , reporting_id int);

insert into employee_hierarchy
values      (1, null),
            (2, 1),
			(3, 1),
			(4, 2),
			(5, 2),
			(6, 3),
			(7, 3),
			(8, 4),
			(9, 4);
select * from employee_hierarchy;

--Recursive Query Syntax
--recursive sql queries means the query will execute multiple times until the termination condition is met
with recursive cte as 
    (base query
	union all 
	recursive part of the query
	termination / exit condition)
select *
from cte;

--base query
--The first point is our base query should have access to all of these nine employee IDs 
--the second point is if i look at my input data and as per the given requirement each employee
--under this employee hierarchy needs to have themselves atleast even if an employee does not have any employees
--under them they should still have a mention of themselves under that hierarchy 

select emp_id, emp_id as emp_hierarchy
from employee_hierarchy;

--the next thing i need to do is each of this employee i need to match them in reporting id column and see what other
--employees are reporting to this endpoint in my recursive part of the query

--1st Iteration
select emp_id, emp_id as emp_hierarchy
from employee_hierarchy;

--2nd Iteration
select cte.emp_id, eh.emp_id as emp_hierarchy
from  (select emp_id, emp_id as emp_hierarchy
       from employee_hierarchy where emp_id = 1) cte
join employee_hierarchy eh on cte.emp_id = eh.reporting_id

--3rd Iteration
select cte.emp_id, eh.emp_id as emp_hierarchy
from (select cte.emp_id, eh.emp_id as emp_hierarchy
      from (select emp_id, emp_id as emp_hierarchy
	        from employee_hierarchy where emp_id = 1) cte
	  join employee_hierarchy eh on cte.emp_id = eh.reporting_id) cte
join employee_hierarchy eh on cte.emp_hierarchy = eh.reporting_id
-----------------------------------------------------------------------------------------------------
with recursive cte as 
    (select emp_id, emp_id as emp_hierarchy
	from employee_hierarchy where emp_id = 1
   union all
   select cte.emp_id, eh.emp_id as emp_hierarchy
   from cte 
   join employee_hierarchy eh on cte.emp_hierarchy = eh.reporting_id)
select *
from cte;
------------------------------------------------------------------------------------------------------