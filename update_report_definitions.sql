SQL:


use eRevClient

update tblreport
set sDescription = 'detailed information on the patient payments received, principal applied against the line, and any applicable fees charged by the Provider'
where iReportID = 23

update tblreport
set sDescription = 'this report will show all payments received for the selected posting period'
where iReportID = 24

update tblreport
set sDescription = 'this report will list all open patient notes, the payment date, payment amount, service charge, late fees, principal paid and interest paid'
where iReportID = 25
