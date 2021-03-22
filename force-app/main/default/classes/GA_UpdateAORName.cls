/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_UpdateAORName 
@CreatedDate: 13 - August 2019 
@Description: GA_UpdateAORName class for AOR clone/update.
@version : 1.0  
********************************************************************************************************************************/
public class GA_UpdateAORName {
    public static final String CLSNAM  = 'GA_UpdateAORName';
    public static final String METHODNAME  = 'updateAORName' ;
    public static Boolean isExecuting = false;
    public static final string SPC=' ';
    public static final string dtFormat='yyyy-MM-dd';
    /*******************************************************************************************************************************
@Description    :  updateAORGSInfo 
@Name         :   updateAORGSInfo
@Param         :  list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updateAORName(list<GA_AOR__c> aorLst){
        try{
            Date todayDt = system.today();
            string formatedDt;
            formatedDt = DateTime.newInstance(todayDt.year(),todayDt.month(),todayDt.day()).format(dtFormat);
            for(GA_AOR__c aor : aorLst){
                aor.Name =  aor.GA_Agent_Contact_Name__c +SPC+ aor.GA_Agent_Code__c + formatedDt;
            }
        }
        catch(Exception excpDtls){
            GA_LogExceptionCls.LogExcp(excpDtls, CLSNAM, METHODNAME);
        }
        
    }
    
}