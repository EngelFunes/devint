/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_updateAORSrvcCommissionDate 
@CreatedDate: 13 - August 2019 
@Description: GA_updateAORSrvcCommissionDate class for AOR ASEP.
@version : 1.0  
********************************************************************************************************************************/

public class GA_updateAORSrvcCommissionDate {
    
   public static final String CLSNAM  = 'GA_updateAORSrvcCommissionDate';
    public static final String METHODNAME  = 'updateAORdates' ;
    public static Boolean isExecuting = false;   
    public static final string dtFormat='yyyy-MM-dd';
    
     public static void updateAORdates(list<GA_AOR__c> aorLst){
        try{
            Date todayDt = system.today();
            for(GA_AOR__c aor : aorLst){
                aor.GA_Service_Start_Date__c = todayDt;
			    aor.GA_Service_End_Date__c = date.newinstance(2200, 01, 01);
			    aor.GA_Commission_End_Date__c = date.newinstance(2200, 01, 01);              
            }
            
        }
        catch(Exception excpDtls){
            GA_LogExceptionCls.LogExcp(excpDtls, CLSNAM, METHODNAME);
        }
        
    }

}