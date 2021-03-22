/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ACC_AP_UpdtAssmntOwnrMgrChnge
@CreatedDate: 10 - Jan 2017 
@Description: GA_ACC_AP_UpdtAssmntOwnrMgrChnge class to update Account owner manager on latest 
Account assessment on changing Account owner 
@version : 1.0  
**********************************************************************************************************************************************/
public with sharing class GA_ACC_AP_UpdtAssmntOwnrMgrChnge {
    
    public static boolean isExecuting=false;
    public static final String ClsName  ='GA_ACC_AP_UpdtAssmntOwnrMgrChnge';
    public static final String updtownrMgrEml  ='updtownrMgrEml';
    /*********************************************************************************************************************************************
@Description: updtownrMgrEml() method 
@Name : bypassRollUpFldsUpdate
@Param :list<account> accLst
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void updtownrMgrEml(list<account> accLst)
    {        
        try
        {
            list<id> accIds=new list<id>();
            for(account acc:accLst)
            {
                accIds.add(acc.Id); 
            }
            list<account> accAssmntLst=[select id,GA_Account_Owner_Manager__c,
                                        (select id from Account_Plans__r order by createddate desc limit 1) 
                                        from account  where id in:accIds Limit 20000];
            list<Account_Plan__c> accAssntLst=new list<Account_Plan__c>();
            for(account acc:accAssmntLst)
            {
                if(acc.Account_Plans__r.size()>0)
                {
                    Account_Plan__c accAssmnt=new Account_Plan__c();
                    accAssmnt.id=acc.Account_Plans__r[0].id;
                    accAssmnt.GA_Account_Owner_Manager_Email__c=acc.GA_Account_Owner_Manager__c;
                    accAssntLst.add(accAssmnt);  
                }
                
            } 
            database.update(accAssntLst);
        }
        catch(exception ex)
        {
             GA_LogExceptionCls.LogExcp(ex, ClsName, updtownrMgrEml);
        }
        
    }
}