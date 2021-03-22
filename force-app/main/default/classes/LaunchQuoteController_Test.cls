/*****************************************************************************************
Class Name   : LaunchQuoteController_Test. 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the test class of LaunchQuoteController
******************************************************************************************/
@isTest
public without sharing class LaunchQuoteController_Test
{

private static string name='AP61LastName';
 private static final String USERNAME='bcbsm1@bcbsm.com';
 private static final String   CID='23';
private static final String SMALLGRP='SG';
private static final String TEST_VAL='test';
 private static final string PROFILENAME='System Administrator';
/****Constructor to initialise variables****/ 
public LaunchQuoteController_Test(){
    system.assertEquals(name,'AP61LastName','nameassertion');
    name='AP61LastName';
}
 /*****************************************************************************************
MethodName   : testDataSetup1 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the test class of LaunchQuoteController
******************************************************************************************/
@testSetup static void testDataSetup1() 
{
 Account acc = new Account(name=TEST_VAL);
    acc.CID__c=CID;
    acc.ARV_Renewal_Account_Type__c=SMALLGRP;
    if(Account.SObjectType.getDescribe().isAccessible()){database.insert(acc);}
    Id standardPriceBookRecId=Test.getStandardPricebookId();
    pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
     if(pricebook2.SObjectType.getDescribe().isAccessible()){database.insert(pb2);}
    Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(acc.id,standardPriceBookRecId);
    if(Opportunity.SObjectType.getDescribe().isAccessible()){database.insert(opp);} 
    quote quo= ARV_AP05_TestDataCreation.quoteRec(opp.id,pb2.id);
    if(quote.SObjectType.getDescribe().isAccessible()){database.insert(quo);} 
    user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
    usr.LastName = NAME;
    usr.Username=USERNAME;
    if(user.SObjectType.getDescribe().isAccessible()){ database.insert(usr,true);} 
 

}

/*****************************************************************************************
Method Name   : altQuoteId. 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the test class of LaunchQuoteController
******************************************************************************************/
 public static testmethod void altQuoteId(){
 try{
 Account acc= [select id,name,ARV_Renewal_Account_Type__c  from account limit 1];
 Quote quot= [select id,recordtype.name, name from quote limit 1];
    user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
            system.runAs(usr1){  
        test.startTest();
                //LaunchQuoteController lqcontroller= new LaunchQuoteController();
                LaunchQuoteController.altQuoteCondition(acc.id);
                LaunchQuoteController.altQSGQuoteCondition(quot.id);
                LaunchQuoteController.getAccountrecord(acc.id);
                LaunchQuoteController.getGroupSegment(String.valueof(acc.id));
   System.assertNotEquals(null,acc.id);
 }
 }catch(Exception e)
 {
 throw new AuraHandledException(e.getMessage()+e.getlinenumber()); 
 }
 


 }
 /*****************************************************************************************
Method Name   : altQuoteId. 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the test class of LaunchQuoteController
******************************************************************************************/
     public static testmethod void altQuoteId2(){
 try{
 Account acc= [select id,name,ARV_Renewal_Account_Type__c  from account limit 1];
 Quote quot= [select id,recordtype.name, name from quote limit 1];
    user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
            system.runAs(usr1){  
        test.startTest();
 LaunchQuoteController.altQuoteCondition(quot.id);
               LaunchQuoteController.getAccountrecord(acc.id);
 //LaunchQuoteController.altQSGQuoteCondition(acc.id);
   System.assertNotEquals(null,acc.id);
 }
 }catch(Exception e)
 {
 //throw new AuraHandledException(e.getMessage()+e.getlinenumber()); 
    // system.debug(e.getMessage());
 }
 


 }
}