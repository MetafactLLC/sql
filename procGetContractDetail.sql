



alter procedure dbo.procGetContractDetail
(
	-- default settings are for test purposes and have no significant meaning
	@iAMClientID int = 8,
	@iInsCoID int = 391, 
	@sLocation varchar(250) = 'C:\'
)
as

declare @filename varchar(50)
--	procGetContractDetail 4, 390
SELECT  
      sProviderName     = amc.sAMClientName, 
      sInsuranceCoName  = inc.sInsCoName, 
      sCodeType         = ct.sCodeTypeName, 
      sCodeValue        = cd.sCodeValue, 
      mAmount           = cd.mApprovedAmount
FROM tblAMClient amc
      INNER JOIN tblInsuranceCo inc   ON amc.iAMClientID  = inc.iAMClientID
      INNER JOIN tblContract ctr      ON inc.iInsCoID     = ctr.iInsCoID 
      INNER JOIN tblContractDetail cd ON ctr.iContractID  = cd.iContractID 
      INNER JOIN tblCodeType ct       ON cd.iCodeTypeID   = ct.iCodeTypeID
WHERE amc.iAMClientID = @iAMClientID
AND	  inc.iInsCoID = @iInsCoID 
AND   cd.dtEndDate    IS NULL
AND   cd.iStatusID    = 0

declare @sql varchar(500)

set @filename = cast(@iAMClientID as varchar) + '_' + cast(@iInsCoID as varchar) + cast(datepart(yy,getdate()) as varchar(4)) + cast(datepart(m,getdate()) as varchar(4)) + cast(datepart(d,getdate()) as varchar(4)) 

set @sql = 'bcp "exec ' + db_name() + '.dbo.procGetContractDetail ' + cast(@iAMClientID as varchar) + ', ' + cast(@iInsCoID as varchar) + ', ''' + @sLocation + ''' " queryout "' + @sLocation + @filename + '.txt" -T -c'

exec master..xp_cmdshell @sql











