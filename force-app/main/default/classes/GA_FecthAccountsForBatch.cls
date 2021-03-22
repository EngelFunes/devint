/**
@Author : IDC offshore
@Name: GA_FecthAccountsForBatch
@CreatedDate: 31 - Jul 2017 
@Description: GA_FecthAccountsForBatch class to fetch account list for batch
@version : 1.0  
*/
public with sharing  class GA_FecthAccountsForBatch {
    
    public static final String systemOfRecord = 'GA_System_of_Record__c';
    public static final String territory = 'GA_Territory__c';
    public static final String SMART = 'SMART';
    public static final  Id CustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.GA_CustomerRecType).getRecordTypeId();
    public static final  Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.GA_ProspectRecType).getRecordTypeId();
    Public Static final String ClsName = 'GA_FecthAccountsForBatch';
    Public Static final String fetchAccount = 'fetchAccount';
    
    
    /**
@Description: fetchLockedAccounts() method 
@Name : fetchLockedAccounts
@Param : list<Account> accList, map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static List<Id> fetchLockedAccounts(list<Account> accList, map<id,Account>  accoldMap)
    {	try
    {
        List<Id> lockedAccounts = New  List<Id>();
        for(Account acc : accList)
        {
            if((String)acc.get(systemOfRecord) != (String)accoldMap.get(acc.id).get(systemOfRecord)   )
            {
                lockedAccounts.add(acc.id); 
            }
        }
        
        return lockedAccounts;
        
    }
     catch(exception e)
     {
         GA_LogExceptionCls.LogExcp(e, ClsName, fetchAccount);
         return null;
     }
     
    }
    
    /**
@Description: fetchLockedAccountsOnInsert() method 
@Name : fetchLockedAccountsOnInsert
@Param : list<Account> accList
@Return : void
@throws Exception : N/A;
*/ 
    public static List<Id> fetchLockedAccountsOnInsert(list<Account> accList)
    {	
        try{
            List<Id> lockedAccounts = New  List<Id>();
            for(Account acc : accList){
                if((String)acc.get(systemOfRecord) == SMART )
                {
                    lockedAccounts.add(acc.id); 
                }
            }
            
            return lockedAccounts;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchAccount);
            return null;
        }
        
        
    }
    
    
    /**
@Description: fetchTerrFlippedAccs() method 
@Name : fetchTerrFlippedAccs
@Param : list<Account> accList, map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static List<Id> fetchTerrFlippedAccs(list<Account> accList, map<id,Account>  accoldMap)
    {
        try{
            List<Id> terrFlippedAccs = New  List<Id>();
            for(Account selAcct : accList){
                if(  (String.isNotBlank(selAcct.GA_Territory__c))  && ((String)selAcct.get(territory) != (String)accoldMap.get(selAcct.id).get(territory)) && (selAcct.RecordTypeId  == CustomerRecordTypeId || selAcct.RecordTypeId  == ProspectRecordTypeId ) && String.isNotBlank(selAcct.GA_Retention_Sales_Rep__c)  )
                {
                    terrFlippedAccs.add(selAcct.id); 
                }
            }
            
            return terrFlippedAccs;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchAccount);
          return null;
        }
          
    }
    /**
@Description: fetchTerrFlippedAccsOnInsert() method 
@Name : fetchTerrFlippedAccsOnInsert
@Param : list<Account> accList
@Return : void
@throws Exception : N/A;
*/ 
    public static List<Id> fetchTerrFlippedAccsOnInsert(list<Account> accList)
    {
        try{
            List<Id> terrFlippedAccs = New  List<Id>();
            for(Account selAcct : accList){
                if(  (String.isNotBlank(selAcct.GA_Territory__c))  && (selAcct.RecordTypeId  == CustomerRecordTypeId || selAcct.RecordTypeId  == ProspectRecordTypeId ) && String.isNotBlank(selAcct.GA_Retention_Sales_Rep__c)  )
                {
                    terrFlippedAccs.add(selAcct.id); 
                }
            }
            
            return terrFlippedAccs;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchAccount);
          return null;
        }
    }
    
    /**
@Description: prospectToCustomerAccs() method 
@Name : prospectToCustomerAccs
@Param : list<Account> accList, map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static List<Id> prospectToCustomerAccs(list<Account> accList, map<id,Account>  accoldMap)
    {
        try
        {
            List<Id> prospectToCustomerAccs = New  List<Id>();
            for(Account selAcct : accList){
                if(  selAcct.RecordTypeId != (accoldMap.get(selAcct.id).RecordTypeId)  )
                {
                    prospectToCustomerAccs.add(selAcct.id); 
                }
            }
            
            return prospectToCustomerAccs;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchAccount);
             return null;
        }
    }
    
    /**
@Description: updateContactOwnerAccs() method 
@Name : updateContactOwnerAccs
@Param : list<Account> accList, map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static Map<Id,Id> updateContactOwnerAccs(list<Account> accList, map<id,Account>  accoldMap)
    {
        try
        {
            Map<Id,Id> accOwnrMap = New Map<Id,Id>();
            for(Account acc : accList){
                if((acc.ownerId != accoldMap.get(acc.Id).ownerId) || ((String)acc.get(territory) != (String)accoldMap.get(acc.id).get(territory)) ){
                    accOwnrMap.put(acc.id, acc.ownerId);
                }  
            }
            return accOwnrMap;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchAccount);
             return null;
        }
    }
}