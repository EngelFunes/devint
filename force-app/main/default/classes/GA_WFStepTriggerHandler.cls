/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_WFStepTriggerHandler
@CreatedDate: 20-10
@Description: GA_WFStepTriggerHandler class is for  WF Step 
@version : 1.0  
**********************************************************************************************************************************************/

public class GA_WFStepTriggerHandler {
     public static final String ClsName  ='GA_WFStepTriggerHandler';
    public static final String methodNmebeforeupdate  ='beforeupdate';
    public static final String methodNmeafterupdate  ='afterupdate';
    public static final String methodNmeafterinsert  ='afterinsert';
    public static final String methodNmebeforeinsert = 'beforeinsert';
/***********************************************************************************************************************************************
@Description: afterinsert() method 
@Name : afterinsert
@Param :list<GA_WF_Step__c> wkflProcssList,
map<id,GA_WF_Step__c> wkflProcssMap, map<id,Account>  wkflProcssMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void afterInsert(list<GA_WF_Step__c> wkflStpList,
                                   map<id,GA_WF_Step__c> wkflStpNewMap)
    {
        GA_WFStp_SendASEPNotifications.sendASEPNotificationToUsers(wkflStpList,wkflStpNewMap) ; 
    }

/***********************************************************************************************************************************************
@Description: beforeinsert() method 
@Name : beforeinsert
@Param :list<GA_WF_Step__c> lstWFStep
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/
    public static void beforeInsert(List<GA_WF_Step__c> lstWFStep){
        Set<String> setAccountNames = new Set<String>();
        for(GA_WF_Step__c objWFStep :lstWFStep){
            if(objWFStep.GA_Account__c != null){
                setAccountNames.add(objWFStep.GA_Account__c); // Get all Account's to fetch there related ASR Names
            }
        }
        Map<String, String> mapAccountName_ASREmail = new Map<String, String>();
        if(setAccountNames.size() > 0){
            for(Account objAcc :[SELECT Id, Name, Account_Services_Representative__c, Account_Services_Representative__r.Email 
                                 FROM Account 
                                 WHERE Name IN :setAccountNames]) // Fetch ASR email details for Account's 
                mapAccountName_ASREmail.put(objAcc.Name, objAcc.Account_Services_Representative__r.Email);  
            }
        if(mapAccountName_ASREmail.size() > 0){
            for(GA_WF_Step__c objWFStep :lstWFStep){
                if(objWFStep.GA_Account__c != null){
                objWFStep.Account_ASR_Email__c = mapAccountName_ASREmail.get(objWFStep.GA_Account__c); // map Account ASR email to WFstep Account ASR field. 
                }
            }
        } 
    }
}