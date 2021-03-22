/*****************************************************************************************
Class Name   : LaunchQuoteController . 
Date Created : 27-MAY-2020
Created By   : IDC Offshore
Description  :This is the class that checks the quote record type and account record type to display alternateQuote button.
******************************************************************************************/
public with sharing class LaunchQuoteController {
    private static final  String SMALLGRP='SG';
    private static final String ACCUSTOMER='Account - Customer';
    private static final  String ACCQUERY='select id,RecordType.name,ARV_Renewal_Account_Type__c from  account';
    private static final String QUOTQRY='select id,RecordType.name from  Quote ';
    private static final  String ACCWHERE=' where id=:paramId1';
    private static final  String LIMITCL=' limit 1';
    private static  String QUOTE1;
    private static  String quote;
    /********************************************************************************************
    Constructor Name   : LaunchQuoteController.    
    Description  : This constructor is used to initiation of Variables.
    **************************************************************************/
    public LaunchQuoteController(){
         quote=QUOTE1;
    }
    
    @AuraEnabled
    /*****************************************************************************************
Method Name   : AltQuoteCondition. 
Date Created : 27-MAY-2020
Created By   : IDC Offshore
Description  :This is the method that checks the quote record type and account record type to display alternateQuote button.
******************************************************************************************/
    public static Boolean altQuoteCondition(Id AccId)
        
    {
    try{
        //system.debug('enter the method in class');
        Boolean returnval=True;
        //Account acc=[select id,RecordType.name,ARV_Renewal_Account_Type__c from  account where id=:AccId];
        ARV_AP07_QueryDataHelper.paramId1 = AccId;
        List<Account> acc1=ARV_AP07_QueryDataHelper.getsObjects(ACCQUERY,ACCWHERE,NULL,LIMITCL) ;
        Account acc= acc1.get(0);
         if(acc.ARV_Renewal_Account_Type__c!=SMALLGRP|| acc.RecordType.Name!=ACCUSTOMER)
       {        returnval=false;      }
        //system.debug('returnval:::'+returnval);
      return returnval;
      }catch(Exception e)
      {        throw new AuraHandledException(e.getMessage());}
       
    }
    
     @AuraEnabled
     /*****************************************************************************************
Method Name   : AltQSGQuoteCondition 
Date Created : 27-MAY-2020
Created By   : IDC Offshore
Description  :This is the method that checks the quote record type and account record type to display alternateQuote button.
******************************************************************************************/
    public static Boolean altQSGQuoteCondition(Id qId)
        
    {
        //system.debug('enter the method in class');
        try{
        Boolean returnval=True;
          ARV_AP07_QueryDataHelper.paramId1 = qId;
        List<Quote>qlist= ARV_AP07_QueryDataHelper.getsObjects(QUOTQRY,ACCWHERE,NULL,LIMITCL) ;
        //Quote quo=[select id,RecordType.name from  Quote where id=:qid];
        Quote quo=qlist.get(0);
         if(quo.RecordType.Name!=QUOTE)
        {
           returnval=false;
        }
        //system.debug('returnval:::'+returnval);
      return returnval;
     }catch(Exception e)
     {       throw new AuraHandledException(e.getMessage());}  
    }
    @AuraEnabled
    /*****************************************************************************************
Method Name   : AltQuoteCondition. 
Date Created : 27-MAY-2020
Created By   : IDC Offshore
Description  :This is the method that checks the quote record type and account record type to display alternateQuote button.
******************************************************************************************/
    public static Boolean getAccountrecord(Id AccId)
        
    {
    try{
        
        Boolean returnval=false;
        Account acc=[select id,RecordType.name,ARV_Renewal_Account_Type__c from  account where id=:AccId];
         if(acc.RecordType.Name==ACCUSTOMER)
       {
        returnval=true;
        }
        //system.debug('returnval:::'+returnval);
      return returnval;
      }catch(Exception e)
      {
        throw new AuraHandledException(e.getMessage());
      }
       
    }   
    @Auraenabled
     public static Boolean getGroupSegment(string AccId)
        
    {
    try{
        
        Boolean groupSeg=true;
        list<GA_Group_Segment__c> grpSec=[select id,GA_Account__c from  GA_Group_Segment__c where GA_Account__c=:AccId];
         if(grpSec.size()>1)
       {groupSeg=false;}
        system.debug('groupSeg:::'+groupSeg);
      return groupSeg;
      }catch(Exception e)
      {        throw new AuraHandledException(e.getMessage());
      }
       
    }   

}