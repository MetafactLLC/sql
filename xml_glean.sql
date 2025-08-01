
USE ReportServer


DECLARE @i INT, @c INT , @email VARCHAR(100), @settingvalue VARCHAR(2000), @settingname VARCHAR(1000), @reportname VARCHAR(1000) 
DECLARE @t TABLE(id INT IDENTITY(1,1), insertid INT, reportname VARCHAR(1000), settingname VARCHAR(5), settingvalue VARCHAR(1000))
;WITH subscriptionXmL AS (
        SELECT c.Name AS reportname, CONVERT(XML, ExtensionSettings) AS ExtensionSettingsXML 
        FROM Subscriptions s 
		INNER JOIN dbo.ReportSchedule rs ON rs.SubscriptionID = s.SubscriptionID
		INNER JOIN dbo.Catalog c ON c.ItemID = rs.ReportID
) , 
emails AS (
	SELECT ROW_NUMBER() OVER(ORDER BY x.reportname) id, x.reportname, ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'), 'Value') AS SettingName , Settings.value('(./*:Value/text())[1]', 'nvarchar(max)') AS SettingValue
	FROM subscriptionXmL x		 
		CROSS APPLY x.ExtensionSettingsXML.nodes('//*:ParameterValue') Queries ( SETTINGS )			 
	WHERE ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'), 'Value')  IN('TO','CC','BCC')
)
INSERT INTO @t
SELECT id, reportname, SettingName, SettingValue FROM emails

SELECT TOP 1 @i = id FROM @t ORDER BY id desc
SET @c = 1

while @c < (@i + 1)
BEGIN
	SELECT @settingvalue=settingvalue, @settingname=settingname, @reportname=reportname FROM @t WHERE id = @c
	
	while CHARINDEX(';',@settingvalue) > 0
	BEGIN
		-- get first email address from parsed string
		SET @email = LEFT(@settingvalue,CHARINDEX(';',@settingvalue))

		-- take it out of the original string
		UPDATE @t SET settingvalue = REPLACE(settingvalue,@email, '') WHERE id = @c
		
		-- insert single email by itself
		INSERT INTO @t ( insertid , reportname, settingname, settingvalue)
		VALUES(@c, @reportname, @settingname, @email)

		-- get new @settingvalue to continue (inside) loop
		SELECT @settingvalue=settingvalue, @settingname=settingname, @reportname=reportname FROM @t WHERE id = @c
    end

	SET @c = @c + 1
END 
--SELECT * FROM @t 
SELECT DISTINCT reportname, settingname, settingvalue FROM @t WHERE CHARINDEX('cebglobal',settingvalue) = 0 






/*
WITH moXML AS (
	SELECT CONVERT(XML,DataSettings) AS dSettings FROM dbo.Subscriptions WHERE DataSettings IS NOT NULL
	)
SELECT ISNULL(theQuery.value('(./*:CommandText/text())[1]', 'nvarchar(max)'), 'Value') AS extractedSQL 
FROM moXML
	CROSS APPLY moXML.dSettings.nodes('//*:Query') Queries ( theQuery )
*/


/*
WITH subscriptionXmL
          AS (
               SELECT
                SubscriptionID ,
                OwnerID ,
                Report_OID ,
                Locale ,
                InactiveFlags ,
                ExtensionSettings ,
                CONVERT(XML, ExtensionSettings) AS ExtensionSettingsXML ,
                ModifiedByID ,
                ModifiedDate ,
                Description ,
                LastStatus ,
                EventType ,
                MatchData ,
                LastRunTime ,
                Parameters ,
                DeliveryExtension ,
                Version
               FROM
                Subscriptions
             ) 
SELECT ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'), 'Value') AS SettingName , Settings.value('(./*:Value/text())[1]', 'nvarchar(max)') AS SettingValue
FROM subscriptionXmL			 
	CROSS APPLY subscriptionXmL.ExtensionSettingsXML.nodes('//*:ParameterValue') Queries ( SETTINGS )			 
*/


			 /*,
                 -- Get the settings as pairs
        SettingsCTE
          AS (
               SELECT
                SubscriptionID ,
                ExtensionSettings ,
    -- include other fields if you need them.
                ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'),
                       'Value') AS SettingName ,
                Settings.value('(./*:Value/text())[1]', 'nvarchar(max)') AS SettingValue
               FROM
                subscriptionXmL
                CROSS APPLY subscriptionXmL.ExtensionSettingsXML.nodes('//*:ParameterValue') Queries ( Settings )
             )
    SELECT
        *
    FROM
        SettingsCTE
    WHERE
        settingName IN ( 'TO', 'CC', 'BCC' )


		*/






/*
WITH subscriptionXmL
          AS (
               SELECT
                SubscriptionID ,
                OwnerID ,
                Report_OID ,
                Locale ,
                InactiveFlags ,
                ExtensionSettings ,
                CONVERT(XML, ExtensionSettings) AS ExtensionSettingsXML ,
                ModifiedByID ,
                ModifiedDate ,
                Description ,
                LastStatus ,
                EventType ,
                MatchData ,
                LastRunTime ,
                Parameters ,
                DeliveryExtension ,
                Version
               FROM
                ReportServer.dbo.Subscriptions
             ),
                 -- Get the settings as pairs
        SettingsCTE
          AS (
               SELECT
                SubscriptionID ,
                ExtensionSettings ,
    -- include other fields if you need them.
                ISNULL(Settings.value('(./*:Name/text())[1]', 'nvarchar(1024)'),
                       'Value') AS SettingName ,
                Settings.value('(./*:Value/text())[1]', 'nvarchar(max)') AS SettingValue
               FROM
                subscriptionXmL
                CROSS APPLY subscriptionXmL.ExtensionSettingsXML.nodes('//*:ParameterValue') Queries ( Settings )
             )
    SELECT
        *
    FROM
        SettingsCTE
    WHERE
        settingName IN ( 'TO', 'CC', 'BCC' )

*/







