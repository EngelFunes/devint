/**
@Author : IDC offshore
@Name: ASC_Product_TriggerHandlerTest
@CreatedDate: 6 - June 2020 
@Description: ASC_Product_TriggerHandlerTest class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class ASC_Product_TriggerHandlerTest {
    
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();   
    /*******************************************************************************************************************************
@Description        :   createProductRecords() method 
@Name               :   createProductRecords
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void createProductRecords(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = PARPRD_CD;
        prd1.IsActive = true;
        prd1.Name = PRODNAME;
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(prd1, false);   
            ASC_Product_TriggerHandler.beforeInsert(null);
            Test.stopTest();           
            
        }
    }
}