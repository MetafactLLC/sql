
-- delete from pdsausers

declare @t table(iuser_id int identity primary key,
		iUserCategory_id int,
		sAppName varchar(20),
		sFirstName varchar(25),
		sLastName varchar(25),
		sInitials char(4),
		sEmailAddress varchar(100),
		sLoginID varchar(100),
		sPassword varchar(255),
		bIsLockedOut tinyint,
		bIsActive tinyint,
		bNotify tinyint,
		sPhoneNumber varchar(50),
		sEmployeeNumber varchar(100),
		dtLastLogin_dt datetime,
		sOtherUserString_id varchar(255),
		bResetPwd_fl tinyint,
		dtLastPwdReset datetime,
		sSecurityQuestion varchar(255),
		sSecurityAnswer varchar(255),
		sStyleSheet varchar(255),
		sExtraInfo text,
		sLang char(6),
		sInsert_id varchar(50),
		dtInsert_dt datetime,
		sLastUpdate_id varchar(50),
		dtLastUpdate_dt datetime,
		iConcurrency_id smallint,
		iOtherUser_id int,
		iEmployeeID int) 

insert into @t(iUserCategory_id, sAppName, 
	sFirstName, sLastName, sInitials, 
	sEmailAddress, sLoginID, sPassword, 
	bIsLockedOut, bIsActive, 
	bNotify, sPhoneNumber, sEmployeeNumber, 
	dtLastLogin_dt, iOtherUser_id,  bResetPwd_fl, 
	dtLastPwdReset, sSecurityQuestion, sSecurityAnswer, sStyleSheet, 
	sExtraInfo, sLang, sInsert_id, dtInsert_dt, 
	sLastUpdate_id,	dtLastUpdate_dt, iConcurrency_id, 
	iEmployeeID)

select 1 as iUserCategory_id, 'eRevNet' as sAppName, 
	Fname as sFirstName, Lname as sLastName,  left(Fname,1) + left(isnull(Mname,''),1) + left(Lname,1) as sInitials,
	isnull(Emailid,'') as sEmailAddress, Userid as sLoginID, 'X03MO1qnZdYdgyfeuILPmQ==' as sPassword,
	0 as blsLockedOut, (case when termdate is null then 0 else 1 end) as blsActive,
	0 as blsNotify, Phone as sPhoneNumber, 1 as sEmployeeNumber, -- is employee number provided?  what is blsnotify?
	getdate() as dtLastLogin_dt, Clientid as iOtherUser_id, 1 as bResetPwd_fl, 
	LastPasswordUpdate as dtLastPwdReset, '' as sSecurityQuestion, '' as sSecurityAnswer, '' as sStyleSheet, 
	'' as sExtraInfo, '' as sLang, 'FWADMIN' as sInsert_id, dtInsert_dt as dtInsert_dt,  
	sLastUpdate_id as sLastUpdate_id, dtLastUpdate_dt as dtLastUpdate_dt, iConcurrency_id as iConcurrency_id,
	pk_id as iEmployeeID
--,Bankid, Hiredate, Access, Created, Lastuserid, Lastupdate, Department, Address1, Address2, City, State, Zip, Ssn, Dob, UserTypeID, Country, Fax, Statusdatechange, Statuschangedby, 
from employee

insert into pdsausers(iuser_id, iUserCategory_id, sAppName, 
	sFirstName, sLastName, sInitials, 
	sEmailAddress, sLoginID, sPassword, 
	bIsLockedOut, bIsActive, 
	bNotify, sPhoneNumber, sEmployeeNumber, 
	dtLastLogin_dt, iOtherUser_id, /*sOtherUserString_id, */ bResetPwd_fl, 
	dtLastPwdReset, sSecurityQuestion, sSecurityAnswer, sStyleSheet, 
	sExtraInfo, sLang, sInsert_id, dtInsert_dt, 
	sLastUpdate_id,	dtLastUpdate_dt, iConcurrency_id, 
	iEmployeeID)
select iuser_id, iUserCategory_id, sAppName, 
	sFirstName, sLastName, sInitials, 
	(case len(sEmailAddress) when 0 then 'change'+cast(iuser_id as varchar)+'@unalisys.com' else sEmailAddress end), sLoginID, sPassword, 
	bIsLockedOut, bIsActive, 
	bNotify, sPhoneNumber, sEmployeeNumber, 
	dtLastLogin_dt, iOtherUser_id, /*sOtherUserString_id, */ bResetPwd_fl, 
	dtLastPwdReset, sSecurityQuestion, sSecurityAnswer, sStyleSheet, 
	sExtraInfo, sLang, sInsert_id, dtInsert_dt, 
	sLastUpdate_id,	dtLastUpdate_dt, iConcurrency_id, 
	iEmployeeID from @t



