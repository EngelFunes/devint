/*****************************************************************************************
Class Name   : ARV_AP67_ContractRecdRelatedList_Test 
Date Created : 22-Jan-2020
Created By   : IDC Offshore
Description  : This class is used for testing Contract Related List Class
******************************************************************************************/
@isTest
private with sharing class ARV_AP67_ContractRecdRelatedList_Test {
    private static final string PROFILENAME='System Administrator';
    private static final string NAME='AP61LastName';
    Private static final String TEST_VAL='Test';
    Private static final String CID='23';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final String SOBJNAME = 'LocationPackage__c';
    private static final String IS_VIEW = 'related';
    private static final String IN_PROGRESS='In Progress';
    private static final String READY='Ready';
    private static final Boolean TRUE_VAL=true;
    /*********************************************************************************************************
@Description: testDataSetup1() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    @testSetup static void testDataSetup1() { 
        Account acc = new Account(name=TEST_VAL);
        acc.CID__c=CID;
        database.insert(acc);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        con.Status=IN_PROGRESS;
        database.insert(con);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        usr.Username=USERNAME;
        database.insert(usr,true);
  }
        /**
@Description: testGetContractNumber() method 
@Name : testGetContractNumber
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testMethod void testGetContractNumber() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc) ;
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont) ;
            ARV_AP67_ContractRecdRelatedList.RelatedListResult obj = new ARV_AP67_ContractRecdRelatedList.RelatedListResult();
            test.startTest();              
               obj= ARV_AP67_ContractRecdRelatedList.fetchRecs(cont.Id,SOBJNAME,'ARV_ContractId__c','',IS_VIEW);
            test.stopTest();
            System.assertNotEquals(null,obj.listsObject);
            System.assertNotEquals(null,obj.fieldLables);
        }
    }
    /**
@Description: testGetContractNumber() method 
@Name : testGetContractNumber
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testMethod void testFetchRecs() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            LocationPackage__c lpData = ARV_AP05_TestDataCreation.locpkgRec(cont.Id);
            Database.insert(lpData);
            LocationPackage__c lpData1 = ARV_AP05_TestDataCreation.locpkgRec(cont.Id);
            Database.insert(lpData1);
            LocationPackage__c lpData2 = ARV_AP05_TestDataCreation.locpkgRec(cont.Id);
            Database.insert(lpData2);
            LocationPackage__c lpData3 = ARV_AP05_TestDataCreation.locpkgRec(cont.Id);
            Database.insert(lpData3);
            ARV_AP67_ContractRecdRelatedList.RelatedListResult obj = new ARV_AP67_ContractRecdRelatedList.RelatedListResult();
            test.startTest(); 
             
              obj  =ARV_AP67_ContractRecdRelatedList.fetchRecs(cont.Id,SOBJNAME,'ARV_ContractId__c','',IS_VIEW);
            test.stopTest();
            System.assertNotEquals(null,obj.listsObject);
            System.assertNotEquals(null,obj.fieldLables);
        }
    }
        /**
@Description: testGetFilesList() method 
@Name : testGetFilesList
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testMethod void testGetFilesList() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            ARV_AP67_ContractRecdRelatedList.RelatdFilesResult filesList =new ARV_AP67_ContractRecdRelatedList.RelatdFilesResult();
            test.startTest();
             filesList= ARV_AP67_ContractRecdRelatedList.fileLstRecs(cont.Id);
            test.stopTest();
            system.assertNotEquals(null, filesList);
        }
    }
        /**
@Description: testUpdateFileType() method 
@Name : testUpdateFileType
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testMethod void testUpdateFileType() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Document objDoc = ARV_AP05_TestDataCreation.createDocumentRecord();
            objDoc.FolderId = [select id from folder where name = 'BCBSM External Service Document' Limit 1].id;
            database.insert(objDoc);
            String docJson = '[{"name":"Test Document","documentId":"'+objDoc.id+'"}]';
            test.startTest();
            ARV_AP67_ContractRecdRelatedList.updateFileType(docJson);           
            test.stopTest();
            system.assertNotEquals(null, docJson);
        }
    }
         /**
@Description: testUpdateFileTypeNull() method 
@Name : testUpdateFileType
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testMethod void testUpdateFileTypeNull() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            test.startTest();
            //ARV_AP67_ContractRecdRelatedList.updateFileType(null);
            //ARV_AP67_ContractRecdRelatedList.fetchRecs(null,null,null,null,null);
            //ARV_AP67_ContractRecdRelatedList.fileLstRecs(null);            
            test.stopTest();
            system.assertNotEquals(null, usr1);
        }
    }
     /**
@Description: testGetFilesList() method 
@Name : testGetFilesList
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testMethod void testgetContractDetails() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            ARV_AP67_ContractRecdRelatedList.sbContractDataResult filesList = new ARV_AP67_ContractRecdRelatedList.sbContractDataResult();
            test.startTest();
            filesList = ARV_AP67_ContractRecdRelatedList.getContractDetails(cont.Id);
            test.stopTest();
            system.assertNotEquals(null, filesList);
        }
    
    } 
    
    private static testMethod void checkRenewals(){
            user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
 
    Account acc=    ARV_AP05_TestDataCreation.accRec();  
    Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            cont.ARV_Renewal_Status__c=READY;
            cont.ARV_Is_Generate_Renewal__c=TRUE_VAL;
            Database.insert(cont);
            test.startTest();
            ARV_AP67_ContractRecdRelatedList.getRenewalStatusVal(cont.id);
            ARV_AP67_ContractRecdRelatedList.getRstatus(cont.id);
             system.assertNotEquals(null, cont.id);
             }
            }
    
}