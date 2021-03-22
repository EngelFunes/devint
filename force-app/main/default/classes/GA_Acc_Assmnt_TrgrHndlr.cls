/*********************************************************************************************************************************************
@Author : IDC offshore
@Name: GA_Acc_Assmnt_TrgrHndlr
@CreatedDate: 31 - Jul 2017 
@Description: GA_Acc_Assmnt_TrgrHndlr class is for creating/updating Account Assessment is changed
@version : 1.0  
**********************************************************************************************************************************************/
public without sharing class GA_Acc_Assmnt_TrgrHndlr {
    public Static Final String CLSNAME  ='GA_Acc_Assmnt_TrgrHndlr';
    public Static Final String METHODNUMBERBEFOREINSERT  ='beforeInsert';
    public static Final String  methodName= 'populateAccFields';
    /*********************************************************************************************************************************************
@Description: beforeinsert() method 
@Name : beforeinsert
@Param : list<Account> accList, map<id,Account> accNewMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void beforeInsert(list<Account_Plan__c> accntAssmntLst)
    {
        try
        {
            if(!accntAssmntLst.isEmpty())
            {
                GA_Acc_Assmnt_SrvcCls.updtAccAssmntInfo(accntAssmntLst);
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNUMBERBEFOREINSERT);
        }
        
    }
    
    public static void populateAccFields(list<Account_Plan__c> lstAA)
    {
        try
        {
            Set<Id> setAccIds = new Set<Id>();
            Map<Id, Account> mapAccId_Acc = new Map<Id, Account>();
            String optyNames = '';
            
            for(Account_Plan__c objAA : lstAA)
            {
                if(objAA.Account__c != null)
                {
                    setAccIds.add(objAA.Account__c );
                } 
            }
            
            if(setAccIds.size() > 0)
            {
                for(Account objAcc : [SELECT Id, Name, GA_Decision_Maker__c, GA_CEO__c, (SELECT Id, GA_Servicing_Agent__c from Group_segments__r WHERE Status__c = 'Active' LIMIT 1) FROM Account WHERE Id IN :setAccIds])
                {
                    mapAccId_Acc.put(objAcc.Id, objAcc);
                }
            }
            for(Account_Plan__c objAA : lstAA)
            {
                if(objAA.Account__c != null)
                {
                    if(mapAccId_Acc.containsKey(objAA.Account__c))
                    {
                        objAA.GA_CEO__c = mapAccId_Acc.get(objAA.Account__c).GA_CEO__c;
                        objAA.GA_Decision_Maker__c = mapAccId_Acc.get(objAA.Account__c).GA_Decision_Maker__c;
                        if(mapAccId_Acc.get(objAA.Account__c).Group_segments__r != null)
                        {
                            objAA.Agent__c = mapAccId_Acc.get(objAA.Account__c).Group_segments__r[0].GA_Servicing_Agent__c;
                        }
                    }
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, methodName);
        }
    }
}