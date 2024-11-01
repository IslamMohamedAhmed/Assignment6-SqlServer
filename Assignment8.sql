
/*
Assignment 8
Part 1
1.	Create the following tables with all the 
required information and load the required 
data as specified in each 
table using insert statements[at least two rows]

Department -> Create it programmatically
[By Code]

*/

create table Department(
DeptNo int primary key identity(1,1),
DeptName varchar(20),
Location varchar(10),
)

insert into Department values 
('Research','NY'),
('Accounting','DS'),
('Marketing','KW')

/*
Assignment 8
Part 1
1.	Create the following tables with all the 
required information and load the required 
data as specified in each 
table using insert statements[at least two rows]

Employee
1-Create it programmatically
2-PK constraint on EmpNo
3-FK constraint on DeptNo
4-Unique constraint on Salary
5-EmpFname, EmpLname don’t accept null values 

[By Code]

*/

create table Employee(
EmpNo int primary key,
EmpFname varchar(20) not null,
EmpLname varchar(20) not null,
DeptNo int references Department(DeptNo),
salary dec(18,2) unique
)



insert into Employee values
(25348,'Mathew','Smith',3,2500),
(10102,'Ann','Jones',3,3000),
(18316,'John','Barrymore',1,2400),
(29346,'James','James',2,2800),
(9031,'Lisa','Bertoni',2,4000),
(2581,'Elisa','Hansel',2,3600),
(28559,'Sybl','Moser',1,2900)





/*
Testing Referential Integrity
1-Add new employee with EmpNo =11111 In the works_on table [what will happen]
*/
insert into [RouteCompany].dbo.Works_on values (11111)  -- Project number and enterdate must be provided


/*
Testing Referential Integrity
2-Change the employee number 10102  to 11111  in the works on table [what will happen]
*/

update [RouteCompany].dbo.Works_on set EmpNo = 11111
where EmpNo = 10102  -- there will be a conflict as the empno is a foreign key that is a primary key for another table

/*
Testing Referential Integrity
3-Modify the employee number 10102 in the employee table to 22222. [what will happen]
*/

update [RouteCompany].dbo.Employee set EmpNo = 22222
where EmpNo = 10102 --conflict because of the works_on table

/*
Testing Referential Integrity
4-Delete the employee with id 10102
*/


delete from [RouteCompany].dbo.Employee where EmpNo = 10102 --conflict because of the works_on table


/*
Table Modification
1-Add  TelephoneNumber column to the employee table[programmatically]
*/

alter table employee add  PhoneNumber varchar(11)

/*
Table Modification
2-drop this column[programmatically]
*/

alter table employee drop column  PhoneNumber


/*
2.	Create the following schema and transfer the following tables to it 
a.	Company Schema 
i.	Department table 
ii.	Project table 
b.	Human Resource Schema
i.	  Employee table 


*/

create schema Company
alter schema Company 
transfer Department

alter schema Company 
transfer Project

create schema HR

alter schema HR
transfer Employee

/*
3.	Increase the budget of the project where the manager number is 10102 by 10%.
*/
update p
set p.budget = budget *1.1
from Company.Project p inner join dbo.Works_on wo
on p.ProjectNo = wo.ProjectNo inner join HR.Employee e
on e.EmpNo  = wo.EmpNo
where lower(wo.job) = 'manager' and e.EmpNo = 10102
/*
4.Change the name of the department for which the employee named James works.The new department name is Sales.
*/

update d 
set d.deptname = 'Sales'
from Company.department d inner join hr.employee e
on d.deptno = e.deptno and lower(e.empfname) = 'james'

/*
5.	Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.
*/

update wo
set wo.enterdate = '2007-12-12'
from hr.employee e inner join company.department d
on e.deptno = d.deptno and lower(d.deptname) = 'sales'
inner join dbo.works_on wo on e.empno = wo.empno
inner join company.project p on p.projectno  = wo.projectno and p.projectno = 1

/*
6.	Delete the information in the works_on table for all employees who work for the department located in KW.
*/
delete wo
from hr.employee e inner join company.department d 
on e.deptno = d.deptno and lower(d.location) = 'kw'
inner join dbo.works_on wo on wo.empno  = e.empno

/*
Part 4
1.	Create a trigger to prevent anyone from inserting a new record in the Department table ( Display a message for user to tell him that he can’t insert a new record in that table )
*/
create or alter trigger tri_one
on department 
instead of insert 
as
print 'you cant enter a new record in the table'

insert into department values (5,'solom','solom2','kika',1,'2020-10-1')


/*
Part 4
2.	Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note)
*/
create table StudentAudit(
 username varchar(128),
 date datetime,
 Note varchar(256)
)



/*
Part 4
3.	Create a trigger on student table after insert to add Row in StudentAudit table 
•	 The Name of User Has Inserted the New Student  
•	Date
•	Note that will be like ([username] Insert New Row with Key = [Student Id] in table [table name]

*/

CREATE TRIGGER student_insert_audit 
ON student
AFTER INSERT 

AS
BEGIN
  -- Get current username and date
  DECLARE @username VARCHAR(128);
  SET @username = SUSER_SNAME();
  DECLARE @date DATETIME;
  SET @date = GETDATE();

  -- Get the inserted student ID
  DECLARE @studentId INT;
  SELECT TOP 1 @studentId = st_id FROM inserted;

  -- Construct the note
  DECLARE @note NVARCHAR(MAX);
  SET @note = CONCAT(@username, ' inserted new row with Key = ',CAST(@studentId AS NVARCHAR(10)), ' in table student');

  -- Insert into StudentAudit table
  INSERT INTO StudentAudit (Username, Date, Note)
  VALUES (@username, @date, @note);
END;

insert into student values(912,'islam','qodeara','shubra',25,10,12)


/*
Part 4
4.	Create a trigger on student table instead of delete to add Row in StudentAudit table 
○	 The Name of User Has Inserted the New Student
○	Date
○	Note that will be like “try to delete Row with id = [Student Id]” 
*/

CREATE TRIGGER student_insert_instead_of_delete_audit 
ON student
instead of delete 

AS
BEGIN
  -- Get current username and date
  DECLARE @username VARCHAR(128);
  SET @username = SUSER_SNAME();
  DECLARE @date DATETIME;
  SET @date = GETDATE();

  -- Get the inserted student ID
  DECLARE @studentId INT;
  SELECT TOP 1 @studentId = st_id FROM deleted;

  -- Construct the note
  DECLARE @note NVARCHAR(MAX);
  SET @note = CONCAT(@username, '“try to delete Row with id = ',CAST(@studentId AS NVARCHAR(10)));

  -- Insert into StudentAudit table
  INSERT INTO StudentAudit (Username, Date, Note)
  VALUES (@username, @date, @note);
END;

delete from student where st_id = 912



/*
Part 4
5.	Create a trigger that prevents the insertion Process for Employee table in March.e )
*/
create or alter trigger  Tri_employeeInsertPreventing
  on employee
   instead of insert
    as
	 if format(getdate(),'mmmm') = 'March'
	   print ' you can not insert into this table in March'
	 else
	 insert into employee
	 select * from inserted


	 insert into employee values ('nano','rules',56,null,'cairkon','maleer',29000,112233,10)
	  


	  /*
Part 4
6.	Create an Audit table with the following structure 

ProjectNo	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
p2	Dbo	2008-01-31	95000	200000

This table will be used to audit the update trials on the Budget column (Project table, Company DB)
If a user updated the budget column then the project number, username that made that update,  the date of the modification and the value of the old and the new budget will be inserted into the Audit table
(Note: This process will take place only if the user updated the budget column)

*/

	  CREATE TABLE Budget_Update_Audit (
  ProjectNo varchar(10) references HR.Project(ProjectNo) not null,
  UserName VARCHAR(50) NOT NULL,
  ModifiedDate DATETIME NOT NULL,
  Budget_Old int not  NULL,
  Budget_New int NOT NULL,
  PRIMARY KEY (ProjectNo, ModifiedDate)  
);

insert into Budget_Update_Audit values(2,'dbo','2008-1-31',95000,200000)

create or alter trigger  Tri_projectBudget
on hr.project 
   after update

    as
	if budget is not null
	 DECLARE @projectNo VARCHAR(10);
    DECLARE @userName NVARCHAR(128);
    DECLARE @modifiedDate DATETIME;
    DECLARE @budgetOld int;
    DECLARE @budgetNew int;

	SET @projectNo = DELETED.ProjectNo; 
    SET @userName = SUSER_SNAME();       
    SET @modifiedDate = GETDATE();        
    SET @budgetOld = DELETED.Budget;      
    SET @budgetNew = INSERTED.Budget; 
	
	 INSERT INTO Budget_Update_Audit (ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
    VALUES (@projectNo, @userName, @modifiedDate, @budgetOld, @budgetNew);

	-- no solution :/