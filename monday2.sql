


select replace(ReportName,'_',' ')  +
    replace(RptInputParameter,'/','_') +
    (case RptOutputFormat when 'EXCEL' then '.xls' when 'PDF' then '.pdf' end) as ReportName,
    replace(RptInputParameter,'/','_') as RptInputParameter, RptURLCommand, replace(EmailAddresses,' ','') as EmailAddresses, 
    replace(isnull(EmailBcc,''),' ','') as EmailBcc, 
    EmailSubject, EmailBodyHTML, EmailReplyTo, ProcessFileLocation, ArchiveFileLocation, RptOutputFormat, 
    RptDistID  ,     replace(isnull(EmailCc,''),' ','') as EmailCc 
from STG_RPT_EMER_SCHN_VSBL_RPT_DISTRIBUTION with(nolock)
where (EmailAddresses is not null) and len(rtrim(EmailAddresses)) > 0
union all
select ReportName + '.pdf' as ReportName,
    replace(RptInputParameter,'/','_') as RptInputParameter, 
    replace(RptURLCommand,'Company+Shipments&rs%3AParameterLanguage=en-US&rs:Command=Render&rs:Format=EXCEL','Company+Shipments+PDF&rs%3AParameterLanguage=en-US&rs:Command=Render&rs:Format=PDF') as RptURLCommand, 
    replace(EmailAddresses,' ','') as EmailAddresses, 
    replace(isnull(EmailBcc,''),' ','') as EmailBcc, 
    EmailSubject, EmailBodyHTML, EmailReplyTo, ProcessFileLocation, ArchiveFileLocation, 
    'PDF' as RptOutputFormat, 
    @@rowcount as RptDistID  ,     replace(isnull(EmailCc,''),' ','') as EmailCc
from STG_RPT_EMER_SCHN_VSBL_RPT_DISTRIBUTION with(nolock)
where ReportName = 'Emergency Visibility Company Shipments'




