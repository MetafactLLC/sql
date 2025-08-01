

SELECT mix.MenuItemXrefId, 
	(
		CASE
			WHEN (mix.MenuItemXrefId IS NOT NULL) AND (rtimi.RTIMenuItemId IS NULL) THEN 'RTI'
			WHEN (mix.MenuItemXrefId IS NULL) AND (afami.AFAMenuItemID IS NOT NULL) THEN 'AFA'
			ELSE 'MIX'
		END 
	) AS source_table,
	rtimi.RTIMenuItemId, 
	afami.AFAMenuItemID 
FROM etl.MenuItemXref mix
	FULL OUTER JOIN etl.AFAMenuItem afami ON mix.AFAMenuItemId = afami.AFAMenuItemID
	LEFT JOIN etl.RTIMenuItems rtimi ON mix.RTIMenuItemId = rtimi.RTIMenuItemId


SELECT afami.*	
FROM etl.AFAMenuItem afami
	INNER JOIN etl.RADItem radi ON radi.RADMenuItemDesc = afami.AFAProductDesc



--SELECT COUNT(DISTINCT radi.RADMenuItemId) 
SELECT rtimi.*, '-------' AS spacer, radi.*
FROM etl.RTIMenuItems rtimi
	INNER JOIN etl.RADItem radi ON rtimi.RTILongDesc = radi.RADMenuItemDesc

--SELECT COUNT(DISTINCT xpnim.ItemMasterId) 
SELECT rtimi.*, '-------' AS spacer, xpnim.*
FROM etl.RTIMenuItems rtimi
--	INNER JOIN etl.XPNItemMaster xpnim ON rtimi.RTILongDesc = xpnim.XPNLongDesc
	INNER JOIN etl.XPNItemMaster xpnim ON rtimi.RTILongDesc = xpnim.XPNMenuItemDesc

SELECT * FROM etl.XPNItemMaster WHERE  XPNActvFlg = 1


SELECT COUNT(DISTINCT mix.AFAMenuItemId) 
FROM etl.MenuItemXref mix
	INNER JOIN etl.AFAMenuItem afami ON mix.AFAMenuItemId = afami.AFAMenuItemID


SELECT COUNT(DISTINCT mix.RTIMenuItemId) 
FROM etl.MenuItemXref mix
	INNER JOIN etl.RTIMenuItems rtimi ON mix.RTIMenuItemId = rtimi.RTIMenuItemId


SELECT COUNT(1) FROM etl.MenuItemXref
-- 7973

SELECT COUNT(1) FROM etl.RTIMenuItems 
-- 6397

SELECT count(1) FROM etl.AFAMenuItem
-- 2881

SELECT COUNT(1) FROM etl.RADItem
-- 2298

SELECT COUNT(1) FROM etl.XPNItemMaster
-- 5923


SELECT * FROM etl.AFAMenuItem

