/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_AP_SBCServiceCls_Test
@CreatedDate: 09 - Feb 2018 
@Description: GA_AP_SBCServiceCls_Test class is for GA_AP_SBCServiceCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AP_SBCServiceCls_Test {
    
    /*******************************************************************************************************************************
@Description        :   getSBCDoc() method 
@Name               :   getSBCDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A
********************************************************************************************************************************/ 
    private static testmethod void getSBCDoc()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmt.Name='000087281_0060';
                grpSgmt.GA_Account__c = accnt.id;
                grpSgmt.GA_MTV_Group__c = '000087281';
                grpSgmt.GA_MTV_Group_Division__c='0060';                
                grpSgmt.Network__c = 'NASCO';
                grpSgmt.GA_Carrier__c = 'BCBSM';
                grpSgmt.GA_Current_Cluster_Code__c = 'D800';
                grpSgmt.GA_Rating_Type__c = 'ASC National ITS';
                database.insert(grpSgmt);
                system.debug('grpSgmt:'+grpSgmt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmt);
                plPkg.GA_Class__c = 'test'; 
                plPkg.GA_Plan_Package__c ='' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                plPkg.GA_Coverage_End_Date__c = date.newInstance(2200, 12, 31); 
                database.insert(plPkg);
                system.debug('plPkg:'+plPkg);
                Asset sldPrd=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plPkg,accnt);
                sldPrd.GA_Form_Numbers__c='Test2';
                database.insert(sldPrd);
                system.debug('sldPrd:'+sldPrd);
             
                String createDocResp = '--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798Content-Type: application/jsonContent-Transfer-Encoding: binaryContent-ID: <0.urn:uuid:419F5D1A4114AAFB511518413118799@apache.org>{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" }, "CreationDateTime":"2018-02-12T00:25:15.469-05:00", "MessageID":"SBCMGMTJSON1.0-355fa698-88c0-4de0-9756-ceaba401efb7", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful Completion.", "Source":"CreateDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827380" }, { "Name":"DocType", "Value":"WORD" } ] } } } --MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798Content-Type: */*Content-Transfer-Encoding: binaryContent-ID: <attachment=urn:uuid:5A38F1FAE2CDC6688F1518012343278>%PDF-1.5%ÈÈÈÈÈÈÈ%%EOF--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createDocResp));
                GA_AP_SBCServiceCls.getSBCDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
                system.assert(usr <> null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
        
    }
    
    
    /*******************************************************************************************************************************
@Description        :   getSBCDocNASCO() method 
@Name               :   getSBCDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    private static testmethod void getSBCDocNASCO()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmt.Name='000720001_0001';
                grpSgmt.GA_Account__c = accnt.id;
                grpSgmt.GA_Account_Type__c = 'NASCO';
                grpSgmt.GA_MTV_Group__c = '000720001';
                grpSgmt.Network__c = 'NASCO';
                grpSgmt.GA_Carrier__c = 'BCBSM';
                grpSgmt.GA_MTV_Group_Division__c = '1000';
                grpSgmt.GA_Current_Cluster_Code__c = 'D000';
                grpSgmt.GA_Rating_Type__c = 'Self-Funded (ASC)';
                database.insert(grpSgmt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmt);
                 plPkg.GA_Class__c = 'testa'; 
                plPkg.Name = '010'; 
                plPkg.GA_Plan_Package__c ='' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                plPkg.GA_Coverage_End_Date__c = date.newInstance(2200, 12, 31); 
                database.insert(plPkg);
                Asset sldPrd=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plPkg,accnt);
                sldPrd.GA_Form_Numbers__c='Test';
                database.insert(sldPrd);
                
               String createDocResp = '--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798Content-Type: application/jsonContent-Transfer-Encoding: binaryContent-ID: <0.urn:uuid:419F5D1A4114AAFB511518413118799@apache.org>{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" }, "CreationDateTime":"2018-02-12T00:25:15.469-05:00", "MessageID":"SBCMGMTJSON1.0-355fa698-88c0-4de0-9756-ceaba401efb7", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful Completion.", "Source":"CreateDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827380" }, { "Name":"DocType", "Value":"WORD" } ] } } } --MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798Content-Type: */*Content-Transfer-Encoding: binaryContent-ID: <attachment=urn:uuid:5A38F1FAE2CDC6688F1518012343278>%PDF-1.5%ÈÈÈÈÈÈÈ%%EOF--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                              
               test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createDocResp));
                GA_AP_SBCServiceCls.getSBCDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
                system.assert(usr <> null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    /*******************************************************************************************************************************
@Description        :   getSBCDocMos() method 
@Name               :   getSBCDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    private static testmethod void getSBCDocMos()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpsg = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpsg.Name='720001_0001';
                grpsg.GA_Account__c = accnt.id;
                grpsg.Network__c = 'MOS';
                grpsg.GA_MTV_Group__c = '007925467';
                grpsg.GA_MTV_Group_Division__c = '0003';
                grpsg.GA_Carrier__c = 'BCBSM';
                grpsg.GA_Current_Cluster_Code__c = 'D549';
                grpsg.GA_Rating_Type__c = 'ASC 25-49';
                database.insert(grpsg);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpsg);
                
                plPkg.Name = '001'; 
                plPkg.GA_Plan_Package__c ='0740W' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                plPkg.GA_Coverage_End_Date__c = date.newInstance(2099, 12, 16); 
                database.insert(plPkg);
                Asset sldPrd=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plPkg,accnt);
                sldPrd.GA_Form_Numbers__c='Test3';
                database.insert(sldPrd);
                
                String createDocResp = '--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798Content-Type: application/jsonContent-Transfer-Encoding: binaryContent-ID: <0.urn:uuid:419F5D1A4114AAFB511518413118799@apache.org>{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" }, "CreationDateTime":"2018-02-12T00:25:15.469-05:00", "MessageID":"SBCMGMTJSON1.0-355fa698-88c0-4de0-9756-ceaba401efb7", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful Completion.", "Source":"CreateDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827380" }, { "Name":"DocType", "Value":"PDF" } ] } } } --MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798Content-Type: */*Content-Transfer-Encoding: binaryContent-ID: <attachment=urn:uuid:5A38F1FAE2CDC6688F1518012343278>%PDF-1.5%ÈÈÈÈÈÈÈ%%EOF--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createDocResp));
                GA_AP_SBCServiceCls.getSBCDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
                system.assert(usr <> null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    
    
    /*******************************************************************************************************************************
@Description        :   getSBCBCNDoc() method 
@Name               :   getSBCBCNDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getSBCBCNDoc()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpsg = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpsg.Name='00178830_0001_0001';
                grpsg.GA_Account__c = accnt.id;
                grpsg.GA_MTV_Group__c = '00178830';
                grpsg.GA_Group_Name__c='Test';
                grpsg.GA_Carrier__c = 'BCN';
                grpsg.Network__c = 'BCN';
                grpsg.GA_Rating_Type__c = 'HMO';
                database.insert(grpsg);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpsg);
                plPkg.GA_Class__c = 'Test'; 
                plPkg.GA_Plan_Package__c ='Plan Package' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                plPkg.GA_Coverage_End_Date__c = date.newInstance(2200, 12, 16);
                database.insert(plPkg);
                Asset sldPrd=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plPkg,accnt);
                sldPrd.GA_Plan_Type__c = 'MRGHCG01';
                sldPrd.GA_Product_Family__c = 'Dental';
                sldPrd.GA_Form_Numbers__c='89F,314F';
                database.insert(sldPrd);
                
                String createDocResp = '--MIMEBoundaryurn_uuid_7808C30A1ED3FF259E1587864387584	Content-Type: application/json Content-Transfer-Encoding: binary Content-ID: <0.urn:uuid:7808C30A1ED3FF259E1587864387585@apache.org>{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" }, "CreationDateTime":"2020-04-25T21:26:23.629-04:00", "MessageID":"SBCMGMTJSON1.0-ea9cb107-8dee-4acd-beef-89eb8c2e6f4d", "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful Completion.", "Source":"CreateDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000007381121" }, { "Name":"DocType", "Value":"PDF" } ] } } } --MIMEBoundaryurn_uuid_7808C30A1ED3FF259E1587864387584 Content-Type: */*Content-Transfer-Encoding: binary Content-ID: <attachment=urn:uuid:7808C30A1ED3FF259E1587864387583>';                

                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createDocResp));
                GA_AP_SBCServiceCls.getSBCDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
                system.assert(sldPrd != null);
                system.assert(usr <> null);
                
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    
    
        /*******************************************************************************************************************************
@Description        :   getSBCDocErr() method 
@Name               :   getSBCDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A
********************************************************************************************************************************/ 
    private static testmethod void getSBCDocErr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpSgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpSgmt.Name='000087281_0070';
                grpSgmt.GA_Account__c = accnt.id;
                grpSgmt.GA_MTV_Group__c = '000087281';
                grpSgmt.GA_MTV_Group_Division__c='0070';                
                grpSgmt.Network__c = 'NASCO';
                grpSgmt.GA_Carrier__c = 'BCBSM';
                grpSgmt.GA_Current_Cluster_Code__c = 'D800';
                grpSgmt.GA_Rating_Type__c = 'ASC National ITS';
                database.insert(grpSgmt);
                system.debug('grpSgmt:'+grpSgmt);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmt);
                plPkg.GA_Class__c = 'test'; 
                plPkg.GA_Plan_Package__c ='' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                plPkg.GA_Coverage_End_Date__c = date.newInstance(2200, 12, 31); 
                database.insert(plPkg);
                system.debug('plPkg:'+plPkg);
                Asset sldPrd=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plPkg,accnt);
                sldPrd.GA_Form_Numbers__c='Test2';
                database.insert(sldPrd);
                system.debug('sldPrd:'+sldPrd);
             
                String createDocResp ='--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798 Content-Type: application/json Content-Transfer-Encoding: binary Content-ID: <0.urn:uuid:419F5D1A4114AAFB511518413118799@apache.org> { "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" }, "CreationDateTime":"2018-02-12T00:25:15.469-05:00", "MessageID":"SBCMGMTJSON1.0-355fa698-88c0-4de0-9756-ceaba401efb7", "Status":"UNSUCCESSFUL", "SystemMessage":[ { "Code":"S0006", "Description":"No data found.", "Source":"CreateDocument" } ] }, "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000000827380" }, { "Name":"DocType", "Value":"PDF" } ] } } } --MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798 Content-Type: */* Content-Transfer-Encoding: binary Content-ID: <attachment=urn:uuid:5A38F1FAE2CDC6688F1518012343278> %PDF-1.5 %ÈÈÈÈÈÈÈ %%EOF --MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
					
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createDocResp));
                GA_AP_SBCServiceCls.getSBCDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
                system.assert(usr <> null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
        
    }
    
        /*******************************************************************************************************************************
@Description        :   getSBCDocMosErr() method 
@Name               :   getSBCDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    private static testmethod void getSBCDocMosErr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpsg = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpsg.Name='720001_0004';
                grpsg.GA_Account__c = accnt.id;
                grpsg.Network__c = 'MOS';
                grpsg.GA_MTV_Group__c = '007925467';
                grpsg.GA_MTV_Group_Division__c = '0004';
                grpsg.GA_Carrier__c = 'BCBSM';
                grpsg.GA_Current_Cluster_Code__c = 'D549';
                grpsg.GA_Rating_Type__c = 'ASC 25-49';
                database.insert(grpsg);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpsg);
                
                plPkg.Name = '001'; 
                plPkg.GA_Plan_Package__c ='0740W' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                plPkg.GA_Coverage_End_Date__c = date.newInstance(2099, 12, 16); 
                database.insert(plPkg);
                Asset sldPrd=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plPkg,accnt);
                sldPrd.GA_Form_Numbers__c='Test3';
                database.insert(sldPrd);
                
                String createDocResp = '{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" }, "CreationDateTime":"2020-04-26T18:14:58.846-04:00", "MessageID":"SBCMGMTJSON1.0-e3d1dfd4-5233-4637-beb3-89eb8c2e96be", "Status":"PARTIAL", "SystemMessage":[ { "Code":"S0006", "Description":"No data found.", "Source":"Coverage-OBI", "SubCode":"0002" } ] } } }';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createDocResp));
                GA_AP_SBCServiceCls.getSBCDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
                system.assert(usr <> null);
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    
        /*******************************************************************************************************************************
@Description        :   getSBCBCNDocErr() method 
@Name               :   getSBCBCNDoc
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void getSBCBCNDocErr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBAAG','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        
        system.runAs(usr)
        {   
            try{
                Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
                GA_County_Code__c countyCode=new GA_County_Code__c();
                countyCode.name='OUT OF STATE';
                database.insert(countyCode);
                GA_Group_Segment__c  grpsg = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                grpsg.Name='00178830_0001_0002';
                grpsg.GA_Account__c = accnt.id;
                grpsg.GA_MTV_Group__c = '';
                grpsg.GA_Group_Name__c='TestBCN';
                grpsg.GA_Carrier__c = 'BCN';
                grpsg.Network__c = 'BCN';
                grpsg.GA_Rating_Type__c = 'HMO';
                database.insert(grpsg);
                GA_Plan_Package__c plPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(grpsg);
                plPkg.GA_Class__c = 'Test'; 
                plPkg.GA_Plan_Package__c ='Plan Package' ;
                plPkg.GA_Coverage_Begin_Date__c = system.today();
                plPkg.GA_Coverage_End_Date__c = date.newInstance(2200, 12, 16);
                database.insert(plPkg);
                Asset sldPrd=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plPkg,accnt);
                sldPrd.GA_Plan_Type__c = 'MRGHCG01';
                sldPrd.GA_Product_Family__c = 'Dental';
                sldPrd.GA_Form_Numbers__c='89F,314F';
                database.insert(sldPrd);
                String createDocRespBCN = '{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" }, "CreationDateTime":"2020-04-26T18:31:05.241-04:00", "MessageID":"SBCMGMTJSON1.0-b887fc25-e5eb-4050-b185-89eb8c2e579d", "Status":"UNSUCCESSFUL", "SystemMessage":[ { "Code":"S9999", "Description":"Unable to process request.", "Source":"Coverage-BCN", "SubCode":"9999", "AdditionalInfo":"CertificateErrors: EC02: CLSSSM BCN65 &#124; AccronymErrors: EC03:  VSP&#124; RuleErrors: EC04: NULL&#124; " } ] } } }';
                test.startTest();
                Test.setMock(HttpCalloutMock.class, new GA_AP_CalloutMockResp(createDocRespBCN));
                GA_AP_SBCServiceCls.getSBCDoc(plPkg.Id);
                test.stopTest();
                system.assert(plPkg != null);
                system.assert(sldPrd != null);
                system.assert(usr <> null);
                
            }
            catch(Exception e) 
            {
                return;
            }
        } 
    }
    
    
}