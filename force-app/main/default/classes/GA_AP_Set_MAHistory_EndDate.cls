/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP_Set_MAHistory_EndDate 
@CreatedDate: 12 - May 2020 
@Description: GA_AP_Set_MAHistory_EndDate class for MA History update.
@version : 1.0  
********************************************************************************************************************************/

public class GA_AP_Set_MAHistory_EndDate {
    
    public static final String CLSNAM  = 'GA_AP_Set_MAHistory_EndDate';
    public static final String METHODNAME  = 'setMAHistoryEndDate' ;
    public static Boolean isExecuting = false;    
    public static final string dtFormat='yyyy-MM-dd';
    
      /*******************************************************************************************************************************
@Description    :  setMAHistoryEndDate 
@Name           :  setMAHistoryEndDate
@Param          :  list<GA_Managing_Agency_History__c> new
Return          :  void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void setMAHistoryEndDate(list<GA_Managing_Agency_History__c> mahNew){
        try{
            for(GA_Managing_Agency_History__c mah : mahNew){                
                mah.GA_End_Date__c = date.newinstance(2200, 01, 01);	
                mah.MA_Override_End_Date__c = date.newinstance(2200, 01, 01);	
            }
        }
        catch(Exception excpDtls){
            GA_LogExceptionCls.LogExcp(excpDtls, CLSNAM, METHODNAME);
        }
    }
}