



Update dbo.EMER_SCHN_VSBL_EVNT_PARM
-- Times                1                                       1   1   1                                       1   1  
-- Values               2   1   2   3   4   5   6   7   8   9   0   1   2   1   2   3   4   5   6   7   8   9   0   1  
-- -----------          -----------------------------------------------------------------------------------------------
--  Set  PARM_CHAR_VAL = '1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0'
--  Set  PARM_CHAR_VAL = '1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0'
      Set  PARM_CHAR_VAL = '1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0'
  where  EMER_SCHNV_PARM_TYP_CD = 1000
--    and  EMER_SCHN_VSBL_EVNT_PARM_NM = 'Emergency Visibility - IPR New Order Follow Up *Excel' 
Select  EMER_SCHN_VSBL_EVNT_PARM_NM, PARM_CHAR_VAL  from  dbo.EMER_SCHN_VSBL_EVNT_PARM  where  EMER_SCHNV_PARM_TYP_CD = 1000;





/*
Update dbo.EMER_SCHN_VSBL_EVNT_PARM
-- Times                1                                       1   1   1                                       1   1  
-- Values               2   1   2   3   4   5   6   7   8   9   0   1   2   1   2   3   4   5   6   7   8   9   0   1  
-- -----------          -----------------------------------------------------------------------------------------------
  Set  PARM_CHAR_VAL = '1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0'
  where  EMER_SCHNV_PARM_TYP_CD = 1000
    and  EMER_SCHN_VSBL_EVNT_PARM_NM = 'Emergency Visibility - IPR New Order Follow Up *Excel' 
--    and  EMER_SCHN_VSBL_EVNT_PARM_NM in ( 'Emergency Visibility Company Shipments *Excel'
--                                        , 'Emergency Visibility Company Shipments PDF *PDF')
Select  EMER_SCHN_VSBL_EVNT_PARM_NM, PARM_CHAR_VAL  from  dbo.EMER_SCHN_VSBL_EVNT_PARM  where  EMER_SCHNV_PARM_TYP_CD = 1000;
*/





