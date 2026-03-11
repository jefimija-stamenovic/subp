select *
from employee
left join salary_history on employee.emp_no = salary_history.emp_no
where employee.emp_no = 1001

