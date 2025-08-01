


declare @schedule_id int
declare @course_id int
declare @job_id int
declare @course_start_date datetime
declare @enrollment varchar(1)

set @course_start_date = '6/7/2004'
set @job_id = null
set @course_id = 1000002
set @schedule_id = 1000001
set @enrollment = null

SELECT ce.status_code,
		coalesce(ce.status_code,'n') ,
		@enrollment,
		COALESCE(rsu.last_name + ', ' + rsu.first_name + ' ' + rsu.middle_name + '.', rsu.last_name + ', ' + rsu.first_name) AS student_name, 
       CASE WHEN (ce.status_code = 'e') THEN 'y' WHEN (ce.status_code = 'c') THEN 'y' ELSE 'n' END AS enrolled,
       ce.schedule_id, 
       ce.status_code, 
       rsu.user_id AS student_id, rsu.*  
  FROM Rad_Sys_User AS rsu 
  LEFT OUTER JOIN LM_Course_Enrollment AS ce 
    ON rsu.user_id = ce.student_id 
   AND ce.schedule_id = @schedule_id
   AND ce.course_id = @course_id
   where (case when ce.status_code = 'e' then 'e' when ce.status_code = 'c' then 'e' else 'n' end) = coalesce(@enrollment,'n')  
     
	--where ce.status_code not in('e','c')
/*
#IF# @job_id #THEN# 
  JOIN Lab_Employee_Job_List AS ejl
    ON ejl.employee_id = rsu.user_id
   AND ejl.job_id = @job_id
   AND @course_start_date BETWEEN ejl.start_date AND COALESCE(ejl.end_date, @course_start_date)
#ENDIF#
*/




