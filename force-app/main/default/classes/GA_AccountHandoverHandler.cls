/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_AccountHandoverHandler
@CreatedDate: 15 - Dec 2017 
@Description: GA_AccountHandoverHandler class is for creating/updating When Account Handover is changed.
@version : 1.0  
********************************************************************************************************************************/
public with sharing class GA_AccountHandoverHandler {
    public static final String ClsName  ='GA_AccountHandoverHandler';
    public static final String methodNmeafterinsert  ='afterinsert';
    public static final String methodNmeafterupdate  ='afterupdate';
    public static final String  qryCreateTsks='SELECT Id, Name, GA_CompanyFullLegalName__c from GA_AccountHandOver__c where id in:idLst';
    /*******************************************************************************************************************************
@Description        :   afterinsert() method 
@Name               :   afterinsert
@Param              :   list<GA_AccountHandOver__c> achList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void afterinsert(list<GA_AccountHandOver__c> achList)
    {
        try
        {
            if((!achList.isEmpty()) && (!GA_AccountBatchApexClassForHandover.isBatchHandoInsert) ){
                if(!GA_ACH_AP01_CreateHandoverTasks.isExecuting ){
                    GA_ACH_AP01_CreateHandoverTasks.isExecuting = true;
                    GA_ACH_AP01_CreateHandoverTasks.createtasks(achList);
                } 
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterinsert);
        }
    }
    /*******************************************************************************************************************************
@Description        :   afterupdate() method 
@Name               :   afterupdate
@Param              :   list<GA_AccountHandOver__c> achList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void afterupdate(list<GA_AccountHandOver__c> achList, map<id,GA_AccountHandOver__c> achNewMap,map<id,GA_AccountHandOver__c>  acholdMap)
    {
        try
        {            
            List<GA_AccountHandOver__c> achToMailList = new List<GA_AccountHandOver__c>();
            if(!achList.isEmpty()){
                for(GA_AccountHandOver__c ach : achList){
                    if(ach.Status__c == 'Transition to Retention Account Manager' && achNewMap.get(ach.Id).Status__c != achOldMap.get(ach.Id).Status__c){
                        achToMailList.add(ach);
                    }
                }
                
                system.debug('achToMailList.size()'+achToMailList.size());
                if(achToMailList.size() > 0){
                     GA_AccountHandoverSendEmail.sendEmail(achToMailList); // US 3266
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterupdate);
        }
    }
    
}