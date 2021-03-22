/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_AP_BAAGServiceCls_Test
@CreatedDate: 09 - Feb 2018 
@Description: GA_AP_BAAGServiceCls_Test class is for GA_AP_BAAGServiceCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AP_BAAGServiceCls_Test {
    
    /*******************************************************************************************************************************
@Description        :   getBenefitDoc() method 
@Name               :   getBenefitDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getBenefitDoc()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);  
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmnt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmnt.Name='720001_0001';
                grpSgmnt.GA_Account__c = accnt.id;
                grpSgmnt.Network__c = 'MOS';
                grpSgmnt.GA_MTV_Group__c = '007925467';
                grpSgmnt.GA_MTV_Group_Division__c = '0003';
                grpSgmnt.GA_Carrier__c = 'BCBSM';
                grpSgmnt.GA_Is_Mass_Updating__c = true;
                database.insert(grpSgmnt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmnt);
                plPkg.GA_Class__c = 'GA_Class__c'; 
                plPkg.GA_Plan_Package__c ='0740W' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                database.insert(plPkg);
                
                
                String createBenefDocResp= '--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: application/json'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <0.urn:uuid:BF8ECB5A24513C815B1518414105873@apache.org>'
                    
                    +'{ "CreateBenefitDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.1" }, "CreationDateTime":"2018-02-14T05:46:22.914-05:00", "MessageID":"BNFTMGMTJSON1.0-24bda5ad-50b4-4591-8c65-90d59cc99c81", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful completion.", "Source":"CreateBenefitDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827758" }, { "Name":"DocType", "Value":"PDF" } ] } } }  '
                    
                    
                    +'--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: */*'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <attachment=urn:uuid:BF8ECB5A24513C815B1518414105870>'
                    
                    +'%PDF-1.5'
                    +'%ÈÈÈÈÈÈÈ'
                    +'%%EOF'
                    
                    +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createBenefDocResp));
                GA_AP_BAAGServiceCls.getBenefitDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    
    /*******************************************************************************************************************************
@Description        :   getBenefitDocNascoValid() method 
@Name               :   getBenefitDocNascoValid
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getBenefitDocNascoValid()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);  
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmnt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmnt.Name='720001_0001';
                grpSgmnt.GA_Account__c = accnt.id;
                grpSgmnt.Network__c = 'NASCO';
                grpSgmnt.GA_MTV_Group__c = '007925467';
                grpSgmnt.GA_MTV_Group_Division__c = '0003';
                grpSgmnt.GA_Carrier__c = 'BCBSM';
                grpSgmnt.GA_Is_Mass_Updating__c = true;
                database.insert(grpSgmnt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmnt);
                plPkg.GA_Class__c = 'GA_Class__c'; 
                plPkg.GA_Plan_Package__c ='0740W' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                database.insert(plPkg);
                
                String createBenefDocResp= '--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: application/json'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <0.urn:uuid:BF8ECB5A24513C815B1518414105873@apache.org>'
                    
                    +'{ "CreateBenefitDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.1" }, "CreationDateTime":"2018-02-14T05:46:22.914-05:00", "MessageID":"BNFTMGMTJSON1.0-24bda5ad-50b4-4591-8c65-90d59cc99c81", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful completion.", "Source":"CreateBenefitDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827758" }, { "Name":"DocType", "Value":"PDF" } ] } } }  '
                    
                    
                    +'--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: */*'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <attachment=urn:uuid:BF8ECB5A24513C815B1518414105870>'
                    
                    +'%PDF-1.5'
                    +'%ÈÈÈÈÈÈÈ'
                    +'%%EOF'
                    
                    +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createBenefDocResp));
                GA_AP_BAAGServiceCls.getBenefitDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    /*******************************************************************************************************************************
@Description        :   getBenefitDocNASCO() method 
@Name               :   getBenefitDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getBenefitDocNASCO()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestNASCO','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmnt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmnt.Name='000071436_1000';
                grpSgmnt.GA_Account__c = accnt.id;
                grpSgmnt.GA_Account_Type__c = 'NASCO';
                grpSgmnt.GA_MTV_Group__c = '000071436';
                grpSgmnt.GA_MTV_Group_Division__c = '1000';
                grpSgmnt.Network__c = 'NASCO';
                grpSgmnt.GA_Is_Mass_Updating__c = true;
                database.insert(grpSgmnt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmnt);
                plPkg.Name = '001'; 
                plPkg.GA_Plan_Package__c ='Plan Package' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                database.insert(plPkg);
                
                
                String createBenefDocResp= '--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: application/json'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <0.urn:uuid:BF8ECB5A24513C815B1518414105873@apache.org>'
                    
                    +'{ "CreateBenefitDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.1" }, "CreationDateTime":"2018-02-14T05:46:22.914-05:00", "MessageID":"BNFTMGMTJSON1.0-24bda5ad-50b4-4591-8c65-90d59cc99c81", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful completion.", "Source":"CreateBenefitDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827758" }, { "Name":"DocType", "Value":"PDF" } ] } } }  '
                    
                    
                    +'--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: */*'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <attachment=urn:uuid:BF8ECB5A24513C815B1518414105870>'
                    
                    +'%PDF-1.5'
                    +'%ÈÈÈÈÈÈÈ'
                    +'%%EOF'
                    
                    +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createBenefDocResp));
                GA_AP_BAAGServiceCls.getBenefitDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    
    /*******************************************************************************************************************************
@Description        :   getBenefitDocNoReqFiled() method 
@Name               :   getBenefitDocNoReqFiled
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getBenefitDocNoReqFiled()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr) ;
        
        system.runAs(usr)
        {   
            try{
                
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmnt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmnt.GA_Account__c = accnt.id;
                grpSgmnt.GA_MTV_Group__c = '123';
                grpSgmnt.Network__c = 'NASCO';
                grpSgmnt.GA_Is_Mass_Updating__c = true;
                //gs.GA_Group_Suffix__c='0001';
                database.insert(grpSgmnt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmnt);
                plPkg.GA_Class__c = ''; 
                plPkg.GA_Plan_Package__c ='Plan Package' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                database.insert(plPkg);
                
                
                String createBenefDocResp= '--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: application/json'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <0.urn:uuid:BF8ECB5A24513C815B1518414105873@apache.org>'
                    
                    +'{ "CreateBenefitDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.1" }, "CreationDateTime":"2018-02-14T05:46:22.914-05:00", "MessageID":"BNFTMGMTJSON1.0-24bda5ad-50b4-4591-8c65-90d59cc99c81", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful completion.", "Source":"CreateBenefitDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827758" }, { "Name":"DocType", "Value":"PDF" } ] } } }  '
                    
                    
                    +'--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: */*'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <attachment=urn:uuid:BF8ECB5A24513C815B1518414105870>'
                    
                    +'%PDF-1.5'
                    +'%ÈÈÈÈÈÈÈ'
                    +'%%EOF'
                    
                    +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createBenefDocResp));
                GA_AP_BAAGServiceCls.getBenefitDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    
    /*******************************************************************************************************************************
@Description        :   getBenefitFaildResp() method 
@Name               :   getBenefitFaildResp
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getBenefitFaildResp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr) ;
        
        system.runAs(usr)
        {   
            try{
                
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmnt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmnt.Name='000720001_0001';
                grpSgmnt.GA_Account__c = accnt.id;
                grpSgmnt.GA_MTV_Group__c = '123';
                grpSgmnt.GA_Is_Mass_Updating__c = true;
                //  gs.Network__c = 'NASCO';
                //gs.GA_Group_Suffix__c='0001';
                database.insert(grpSgmnt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmnt);
                plPkg.GA_Class__c = ''; 
                plPkg.GA_Plan_Package__c ='Plan Package' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                database.insert(plPkg);
                
                
                String createBenefDocResp= '--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: application/json'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <0.urn:uuid:BF8ECB5A24513C815B1518414105873@apache.org>'
                    
                    +'{ "CreateBenefitDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.1" }, "CreationDateTime":"2018-02-14T05:46:22.914-05:00", "MessageID":"BNFTMGMTJSON1.0-24bda5ad-50b4-4591-8c65-90d59cc99c81", "Status":"UNSUCCESSFUL", "SystemMessage":[ { "Code":"S0006", "Description":"No Data Found.", "Source":"CreateBenefitDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827758" }, { "Name":"DocType", "Value":"PDF" } ] } } }  '
                    
                    
                    +'--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: */*'
                    +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <attachment=urn:uuid:BF8ECB5A24513C815B1518414105870>'
                    
                    +'%PDF-1.5'
                    +'%ÈÈÈÈÈÈÈ'
                    +'%%EOF'
                    
                    +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createBenefDocResp));
                GA_AP_BAAGServiceCls.getBenefitDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
}