/***************************************************************************************************************************
@Author : Rahul
@Name: Batch_AccountMACleanup 
@CreatedDate:  04/18/2020 
@Description: Batch_AccountMACleanup class to Cleaning up the AccountManagingAgency based on GroupSegment records. 
@version : 1.0  
***************************************************************************************************************************/
global class Batch_AccountMACleanup implements Database.Batchable<sObject>
{
    String query;
    global Batch_AccountMACleanup()
    {
    	this.query = 'SELECT Id, Assigned_Managing_Agency__c FROM Account WHERE Assigned_Managing_Agency__c != null';
    }
    global Batch_AccountMACleanup(String query)
    {
    	this.query = query;
    }
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(this.query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Account> scope)
    {	
        List<Account> lstAccount = new List<Account>();
        List<String> lstStatus = new List<String> {'Active','Pending'};
        Integer totalAccounts = 0;
        for(Account objAcc : [SELECT Id, Assigned_Managing_Agency__c, (SELECT Id, GA_Managing_Agency__c FROM Group_Segments__r WHERE Status__c IN :lstStatus) FROM Account WHERE Id IN: scope])
        {
            Integer count = 0;
            Integer totalCount = 0;
            totalCount = objAcc.Group_Segments__r.size();    
            
            for(GA_Group_Segment__c objGS : objAcc.Group_Segments__r)
            {
            	if(objGS.GA_Managing_Agency__c == null)
                {
                	count++;    
                }
            }
            if(totalCount == count && totalCount > 0)
            {
          		objAcc.Assigned_Managing_Agency__c = null;    
				lstAccount.add(objAcc);
                totalAccounts++;
            }
        }
        Account_Cleanup_Count__c  a = Account_Cleanup_Count__c.getValues('AccountCount');
        a.Total_Accounts__c = (a.Total_Accounts__c == null) ? 0 : a.Total_Accounts__c;  // Initializing total_accounts to '0' for first time execution 
        a.Total_Accounts__c += totalAccounts;
        update a;
        if(lstAccount.size() > 0 && a.Run_Account_Update__c)  //If Custom settings flag == true then only update Accounts
        {
           update lstAccount;
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
    
    }
}