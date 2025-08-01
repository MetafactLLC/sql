

-- add extra column to company shipments table for STP_SFLOC_ALIAS_NM 
-- add STP_SFLOC_ALIAS_NM to company shipments table so you can pull into new order report
-- add [STP_SFLOC_ALIAS_ID] to company shipments table so you can pull into new order report


SELECT        *
FROM            dbo.VW_EMER_SCHN_VSBL_MAIN_LNDG WITH (nolock)
WHERE        (SHOW_STR_RPT_FLG = 'Y') AND (STP_SFLOC_ALIAS_ID IS NOT NULL) AND (LEN(ISNULL(STR_MGR_EMAIL, 0)) > 0) --AND (STP_SFLOC_ALIAS_ID IN (@Store))
ORDER BY STP_SFLOC_ALIAS_ID, RPT_GRPG_SRTR, TAB_GRPG_SRTR, STP_STATUS_SRTR, EST_DL, SUBDEPT, CONTENTS, TC_SHP_ID, PO_NBR



select top 100 * from STG_RPT_EMER_SCHN_VSBL_PULLREPORT





