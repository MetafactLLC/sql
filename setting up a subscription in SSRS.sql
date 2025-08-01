



select * from [dbo].[editreportschedule]
where TextData like '%schedule%'


/*
-- updates the subscription only
exec UpdateSubscription @id='C2044C42-8942-4DF7-904C-AFF89492A7A3',@OwnerSid=0x01050000000000051500000051CED61AA52192D7B001334A61321D00,@OwnerName=N'AMER\MEM8593',@OwnerAuthType=1,@Locale=N'en-US',@DeliveryExtension=N'Report Server Email',@InactiveFlags=0,@ModifiedBySid=0x01050000000000051500000051CED61AA52192D7B001334A61321D00,@ModifiedByName=N'AMER\MEM8593',@ModifiedByAuthType=1,@ModifiedDate='2013-07-10 09:37:24.120',@Description=N'Send e-mail to michael_e_meeks@homedepot.com',@LastStatus=N'Mail sent to michael_e_meeks@homedepot.com',@EventType=N'TimedSubscription',@ExtensionSettings=N'<ParameterValues><ParameterValue><Name>TO</Name><Value>michael_e_meeks@homedepot.com</Value></ParameterValue><ParameterValue><Name>CC</Name><Value>DAVID_DIRRING@homedepot.com</Value></ParameterValue><ParameterValue><Name>IncludeReport</Name><Value>True</Value></ParameterValue><ParameterValue><Name>RenderFormat</Name><Value>PDF</Value></ParameterValue><ParameterValue><Name>Subject</Name><Value>@ReportName was executed at @ExecutionTime</Value></ParameterValue><ParameterValue><Name>Comment</Name><Value>The report is attached.</Value></ParameterValue><ParameterValue><Name>IncludeLink</Name><Value>True</Value></ParameterValue><ParameterValue><Name>Priority</Name><Value>NORMAL</Value></ParameterValue></ParameterValues>',@MatchData=N'<ScheduleDefinition xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><StartDateTime xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/03/01/ReportServer">2013-07-02T09:45:00.000-04:00</StartDateTime><MinuteRecurrence xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/03/01/ReportServer"><MinutesInterval>60</MinutesInterval></MinuteRecurrence></ScheduleDefinition>',@Parameters=N'<ParameterValues />',@Version=3

-- notification for sql job agent (this may not be needed)
exec master.dbo.xp_sqlagent_notify @op_type=N'G',@job_id=default,@schedule_id=default,@alert_id=default,@action_type=default

-- get the schedule id and information for this subscription
exec GetTimeBasedSubscriptionSchedule @SubscriptionID='C2044C42-8942-4DF7-904C-AFF89492A7A3'

-- notification for sql job agent (this may not be needed)
exec master.dbo.xp_sqlagent_notify @op_type=N'G',@job_id=default,@schedule_id=default,@alert_id=default,@action_type=default

-- update the schedule
exec UpdateTask @Name=N'b4a76edc-8165-4293-a761-b7a7364014c1',@ScheduleID='79E193C4-C0ED-4B0C-8241-86A18E14775B',@StartDate='2013-07-02 10:00:00',@Flags=0,@RecurrenceType=2,@State=1,@LastRunStatus=N'',@ScheduledRunTimeout=0,@NextRunTime='2013-07-10 10:00:00',@LastRunTime='2013-07-03 07:44:07.107',@MinutesInterval=60

-- notification for sql job agent (this may not be needed)
exec master.dbo.xp_sqlagent_notify @op_type=N'G',@job_id=default,@schedule_id=default,@alert_id=default,@action_type=default

-- update the schedule (may not need to happen twice)
exec UpdateTask @Name=N'b4a76edc-8165-4293-a761-b7a7364014c1',@ScheduleID='79E193C4-C0ED-4B0C-8241-86A18E14775B',@StartDate='2013-07-02 09:45:00',@Flags=0,@RecurrenceType=2,@State=1,@LastRunStatus=N'',@ScheduledRunTimeout=0,@LastRunTime='2013-07-03 07:44:07.107',@MinutesInterval=60

-- job for this schedule is obtained and used here - this returns job & schedule info
exec sp_executesql N'EXECUTE msdb.dbo.sp_help_jobschedule @job_id = @P1, @include_description = 0',N'@P1 uniqueidentifier','950841D3-A86A-4900-830B-47C32BEA7FDB'

-- the the next run date for null in the job activity table for this job
exec sp_executesql N'UPDATE msdb.dbo.sysjobactivity SET next_scheduled_run_date = NULL WHERE session_id = @P1 AND job_id = @P2',N'@P1 int,@P2 uniqueidentifier',5003,'950841D3-A86A-4900-830B-47C32BEA7FDB'

-- obtain additional schedule information regarding the job
exec sp_executesql N'EXECUTE msdb.dbo.sp_help_schedule @schedule_id = @P1, @attached_schedules_only = 1, @include_description = 0',N'@P1 int',2012

-- update the next run date for the job (from null)
exec sp_executesql N'DECLARE @nextScheduledRunDate DATETIME SET @nextScheduledRunDate = msdb.dbo.agent_datetime(@P1, @P2) UPDATE msdb.dbo.sysjobactivity SET next_scheduled_run_date = @nextScheduledRunDate WHERE session_id = @P3 AND job_id = @P4',N'@P1 int,@P2 int,@P3 int,@P4 uniqueidentifier',20130710,94500,5003,'950841D3-A86A-4900-830B-47C32BEA7FDB'

-- add a new schedule (prior schedule changes are still saved in the database, but set to 'inactive'
exec msdb.dbo.sp_add_jobschedule @job_name=N'79E193C4-C0ED-4B0C-8241-86A18E14775B',@name=N'Schedule_1',@freq_type=4,@active_start_date=20130702,@active_start_time=94500,@freq_interval=1,@freq_subday_type=4,@freq_subday_interval=60,@active_end_time=94400

*/



