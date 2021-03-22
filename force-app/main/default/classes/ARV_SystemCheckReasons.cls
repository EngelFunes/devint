/*****************************************************************************************
Class Name   : ARV_SystemCheckReasons. 
Date Created : 24-DEC-2019
Created By   : IDC Offshore
Description  :This class is used to create contacts given through Part-B to use in E-sign/Wet-Sign.
******************************************************************************************/
public without sharing class ARV_SystemCheckReasons {
    
    public static final String EMPTYSTRNG='';
    public static final String COMMA = ',';
    public  static final String CONTRACTQRY = System.label.ARV_CL46_CONTRACTQUERY;
    public  static final String WHERECLAUSE=' WHERE Id =: paramId1 ' ;
    
    /*****************************************************************************************
    Method Name   :  getCheckValues	
    Description   :This method is used to get check Values.
	******************************************************************************************/
    @AuraEnabled
    public static List<String> getCheckValues(Id recordId){
        
        ARV_AP07_QueryDataHelper.paramId1 = recordId; 
        //Contract con = [SELECT Id, ARV_System_Check_1_Status__c FROM Contract WHERE Id=:recordId];
        List<Contract> conList = ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQRY, WHERECLAUSE, null, null);
        system.debug('conList ::'+conList);
        System.debug('conList'+conList);
        String values = EMPTYSTRNG;
        List<String> checkValues = new List<String> ();
            try{
                if(conList.get(0).ARV_System_Check_1_Status__c != null && conList.get(0).ARV_System_Check_1_Status__c != EMPTYSTRNG){
                    values = String.valueOf(conList.get(0).ARV_System_Check_1_Status__c);
                    checkValues = values.split(COMMA);
                    System.debug('checkValues'+checkValues);
                }   
            }
            catch(Exception e) { throw new AuraHandledException(e.getMessage()+e.getlinenumber());}
      return checkValues;
    }
    
    @AuraEnabled
    public static List<String> getGWCCheckValues(Id recordId){
        Contract con = [SELECT Id, ARV_GWC_System_Check_1_Status__c FROM Contract WHERE Id=:recordId];
        String gwcvalues = EMPTYSTRNG;
        List<String> gwccheckValues = new List<String> ();
        Set<String> uniquevalset = new Set<String>();
        if(con.ARV_GWC_System_Check_1_Status__c != null && con.ARV_GWC_System_Check_1_Status__c != EMPTYSTRNG){
            gwcvalues = String.valueOf(con.ARV_GWC_System_Check_1_Status__c);
            gwccheckValues = gwcvalues.split(',');
            uniquevalset.addAll(gwccheckValues);
            gwccheckValues.clear();
            gwccheckValues.addAll(uniquevalset);
        }
        return gwccheckValues;
    }
}