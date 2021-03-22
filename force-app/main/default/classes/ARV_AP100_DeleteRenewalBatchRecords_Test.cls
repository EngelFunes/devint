/********************************************************************************************
@Name: ARV_AP100_DeleteRenewalBatchRecords_Test
@CreatedDate: 24-June-2020
@Description: ARV_AP100_DeleteRenewalBatchRecords_Test for deleting Renewal Batch Logs 
@version : 1.0 
*********************************************************************************************/
@isTest
public class ARV_AP100_DeleteRenewalBatchRecords_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME='Test admin';
    private static final string SUCCCOMPLETEDMESSAGE='Contract Renewal Completed';
    private static final string FAILED='Failed';
    private static final string SUCCESS='Success';
    private static final string QUOTECHARS=Quote.sobjecttype.getDescribe().getKeyPrefix();
    private static final string CENSUSCHARS=vlocity_ins__GroupCensus__c.sobjecttype.getDescribe().getKeyPrefix();
    private static final string OPPCHARS=Opportunity.sobjecttype.getDescribe().getKeyPrefix();
    private static final string CONTCHARS=Contract.sobjecttype.getDescribe().getKeyPrefix();
    /***********************************************************************************************
@Description: testDataSetup1() method 
@Name : testDataSetup
@Param : N/A
@Return : void
@throws Exception : N/A;
*************************************************************************************************/
    @testSetup static void testDataSetup1() { 
        Account acc = ARV_AP05_TestDataCreation.accRec();
        acc.name=NAME;
        database.insert(acc);
        
        Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        con.name=NAME;
        database.insert(con);
        ARV_Renewal_Batch_Log__c rb=new ARV_Renewal_Batch_Log__c();
        rb.ARV_Contract_Id__c=con.id;
        rb.ARV_Renewal_Step_Status__c=SUCCESS;
        rb.ARV_Status_Message__c=SUCCCOMPLETEDMESSAGE;
        database.insert(rb);
        ARV_Renewal_Batch_Log__c rb1=new ARV_Renewal_Batch_Log__c();
        rb1.ARV_Contract_Id__c=con.id;
        rb1.ARV_Renewal_Step_Status__c=SUCCESS;
        database.insert(rb1);
        ARV_Renewal_Batch_Log__c rb3=new ARV_Renewal_Batch_Log__c();
        rb3.ARV_Contract_Id__c=con.id;
        rb3.ARV_Renewal_Record_Id__c=con.id;
        rb3.ARV_Renewal_Step_Status__c=FAILED;
        database.insert(rb3);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME;
        database.insert(usr,true);   
    }
    /*********************************************************************************************************
@Description: testdelRenewalBatchRec() method 
@Name : testdelRenewalBatchRec()
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    private static testMethod void testdelRenewalBatchRec() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            List<ARV_Renewal_Batch_Log__c> rblList=[select id,ARV_Contract_Id__c,ARV_Renewal_Step_Status__c,
                                                    ARV_Status_Message__c from ARV_Renewal_Batch_Log__c where ARV_Renewal_Step_Status__c=:SUCCESS];
            test.startTest();
            ARV_AP100_DeleteRenewalBatchRecords.deletelogRecords(rblList);
            test.stopTest();
            system.assertNotEquals(null,rblList);
        }
    }
    /*********************************************************************************************************
@Description: testdeletefailedRelatedRecords method 
@Name : testdelRenewalBatchRec()
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    private static testMethod void testdelRenewalBatchRec1() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            List<ARV_Renewal_Batch_Log__c> rblList=[select id,ARV_Contract_Id__c,ARV_Renewal_Step_Status__c,ARV_Status_Message__c 
                                                    from ARV_Renewal_Batch_Log__c where ARV_Renewal_Step_Status__c=:FAILED ];
            test.startTest();
            ARV_AP100_DeleteRenewalBatchRecords.deletelogRecords(rblList);
            test.stopTest();
            system.assertNotEquals(null,rblList);
        }
    }
}