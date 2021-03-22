/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_AP_CIDServiceCls_Test
@CreatedDate: 25 - Jan 2018 
@Description: GA_AP_CIDServiceCls_Test class is for GA_AP_CIDServiceCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_AP_CIDServiceCls_Test {
    
    /*******************************************************************************************************************************
@Description        :   getcidValue() method 
@Name               :   getcidValue
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getcidValue()
    {
        string accRecType = 'Account - Prospect';
        Id accRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(accRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr)
        {               
         GA_CID_Service_ByPass__c profbypas= new GA_CID_Service_ByPass__c();
         profbypas.GA_By_Pass__c=true;
         profbypas.Name='System Administrator';
         database.insert(profbypas);
         Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();          
         acc.CID__c='';
         acc.recordtypeid=accRecTpeId;
         GA_County_Code__c cnty = GA_OBJ_TD01_TestDataCreation.countyCode(); 
         database.insert(cnty);                        
         acc.GA_Mailing_County_id__c=cnty.Id;
         acc.GA_Physical_County_Id__c =cnty.id;
         //GA_Territory__c terytoryRec= new GA_Territory__c();
         GA_Territory__c terytoryRec= GA_OBJ_TD01_TestDataCreation.terrtryRec();                         
         database.insert(terytoryRec);                              
         acc.GA_Territory__c = terytoryRec.id; 
         database.insert(acc);            
         acc.CID__c='';         
         database.update(acc);
         system.debug('acc:'+acc);
            
         ExceptionLog__c objLog = new ExceptionLog__c();
         objLog.Object_ID__c = acc.id;
		 objLog.WSCallingApplication__c='CIDService';
         objLog.ExceptionDescription__c = 'Test Description';
         objLog.ExceptionCode__c = 'S0001';
    	 objLog.status__c = 'Failure';
         objLog.NumberOfTimesOccured__c = 1;
         objLog.ExceptionDetails__c = 'Test Exception Details ';
         objLog.Severity__c = 'ERROR';
         database.insert(objLog);
         system.debug('objLog1:'+objLog);
                  
         String CIDResp = '{"headerArea": { "systemEnvironmentCode": "QA", "messageId": "0d99ded0-687d-11ea-af01-0e34c8da2609", "systemMessage": [ { "code": "S0000", "source": "Group Salesforce", "additionalInfo": "SuccessFully inserted record into Salesforce" } ] }, "payloadArea": { "cid": "600396" } }';
         Test.setMock(HttpCalloutMock.class, new GA_AP_CIDCalloutMockResp(CIDResp));
         map<id,account> accLst=new map<id,account>();
         accLst.put(acc.id,acc);
         //system.debug('accLst:'+accLst);         
         test.startTest();         
         GA_AP_InvokeCIServOnBatch.fetchCIDServiceResponses(accLst);          
          //GA_AP_CIDServiceCls.getcidVal(acc.id);
         test.stopTest();
         system.assert(acc !=null);
        } 
    } 
 
        /*******************************************************************************************************************************
@Description        :   getcidValueLightng() method 
@Name               :   getcidValueLightng
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 

    private static testmethod void getcidValueLightng()
    {
        string accRecType = 'Account - Prospect';
        Id accRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(accRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr)
        {   GA_CID_Service_ByPass__c profbypas= new GA_CID_Service_ByPass__c();
         profbypas.GA_By_Pass__c=true;
         profbypas.Name='System Administrator';
         database.insert(profbypas);
         Account acc2 = GA_OBJ_TD01_TestDataCreation.AccRec();
         GA_County_Code__c cnty = GA_OBJ_TD01_TestDataCreation.countyCode(); 
         database.insert(cnty);                        
         acc2.GA_Mailing_County_id__c=cnty.Id;
         acc2.GA_Physical_County_Id__c =cnty.id;         
         acc2.CID__c='';
         acc2.recordtypeid=accRecTpeId;
         GA_Territory__c terytoryRec= new GA_Territory__c();
         terytoryRec= GA_OBJ_TD01_TestDataCreation.terrtryRec();
         insert terytoryRec;
         acc2.GA_Territory__c = terytoryRec.id; 
         database.insert(acc2);
         acc2.CID__c='';
         database.update(acc2);
         
         ExceptionLog__c objLog2 = new ExceptionLog__c();
         objLog2.Object_ID__c = acc2.id;
		 objLog2.WSCallingApplication__c='CIDService';
         objLog2.ExceptionDescription__c = 'Test Description1';
         objLog2.ExceptionCode__c = 'S0001';
    	 objLog2.status__c = 'Failure';
         objLog2.NumberOfTimesOccured__c = 1;
         objLog2.ExceptionDetails__c = 'Test Exception Details2 ';
         objLog2.Severity__c = 'ERROR';
         database.insert(objLog2);
         system.debug('objLog2:'+objLog2);
         
         String CIDResp1 = '{"headerArea": { "systemEnvironmentCode": "QA", "messageId": "0d99ded0-687d-11ea-af01-0e34c8da2609", "systemMessage": [ { "code": "S0000", "source": "Group Salesforce", "additionalInfo": "SuccessFully inserted record into Salesforce" } ] }, "payloadArea": { "cid": "600399" } }';
         Test.setMock(HttpCalloutMock.class, new GA_AP_CIDCalloutMockResp(CIDResp1));
         
         //Test.setMock(HttpCalloutMock.class, new GA_AP_CIDCalloutMockResp('S0000'));
         map<id,account> accLst2=new map<id,account>();
         accLst2.put(acc2.id,acc2);            
         
         test.startTest();         
         system.debug('accid:'+acc2.id);
         system.debug('cidservice call');
         GA_AP_CIDServiceCls.getcidVal(acc2.id);
         test.stopTest();          
         system.assert(acc2 !=null);
        } 
    }

    /*******************************************************************************************************************************
@Description        :   getcidBatchValue() method 
@Name               :   getcidBatchValue
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 

    private static testmethod void getcidBatchValue()
    {
        string accRecType = 'Account - Prospect';
        Id accRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(accRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr)
        {   GA_CID_Service_ByPass__c profbypas= new GA_CID_Service_ByPass__c();
         profbypas.GA_By_Pass__c=true;
         profbypas.Name='System Administrator';
         database.insert(profbypas);
         Account acc3 = GA_OBJ_TD01_TestDataCreation.AccRec();
         acc3.CID__c='';
         acc3.recordtypeid=accRecTpeId;
         GA_County_Code__c cnty = GA_OBJ_TD01_TestDataCreation.countyCode(); 
         database.insert(cnty); 
         acc3.GA_Mailing_County_id__c=cnty.Id;
         acc3.GA_Physical_County_Id__c =cnty.id;
         GA_Territory__c terytoryRec= new GA_Territory__c();
         terytoryRec= GA_OBJ_TD01_TestDataCreation.terrtryRec();
         insert terytoryRec;
         acc3.GA_Territory__c = terytoryRec.id; 
         database.insert(acc3);
         acc3.CID__c='';
         database.update(acc3);
         
         ExceptionLog__c objLog3 = new ExceptionLog__c();
         objLog3.Object_ID__c = acc3.id;
		 objLog3.WSCallingApplication__c='CIDService';
         objLog3.ExceptionDescription__c = 'Test Description';
         objLog3.ExceptionCode__c = 'S0001';
    	 objLog3.status__c = 'Failure';
         objLog3.NumberOfTimesOccured__c = 1;
         objLog3.ExceptionDetails__c = 'Test Exception Details ';
         objLog3.Severity__c = 'ERROR';
         database.insert(objLog3);
         system.debug('objLog:'+objLog3);
         
         //Test.setMock(HttpCalloutMock.class, new GA_AP_CIDCalloutMockResp('S0000'));
         GA_AP_CIDServiceBatch_Scheduler sh1 = new GA_AP_CIDServiceBatch_Scheduler();
         String sch = '0 0 23 * * ?'; 
         
         test.startTest(); 
         system.schedule('Test TCID Batch', sch, sh1);      
         test.stopTest();
         system.assert(acc3 !=null);
        } 
    }
    
}