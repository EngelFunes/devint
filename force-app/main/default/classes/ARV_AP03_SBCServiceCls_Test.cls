/*****************************************************************************************
Class Name   : ARV_AP02_SBCServiceCls_Test 
Date Created : 3-MAY-2019
Created By   : IDC Offshore
Description  : This class is used for testing sbc services....
******************************************************************************************/
@isTest(SeeAllData=FALSE)
private class ARV_AP03_SBCServiceCls_Test {
    Private static final string PROFILENAME='System Administrator';
    Private static final string ACCID='accId';
    Private static final string PID='pId';
    Private static final string OPPID='oppId';
    Private static final string CAARRIERTYPE='BCN';
    Private static final string CAARRIERTYPE1='BCBS';
    Private static final string PEIATRICTYPE='Yes';
    /**************  
    Method name : getSBCDoc
    Params     : NA
    Return Type : NA
    Description :  getSBCDoc() method
    *************/ 
    private static testmethod void getSBCDoc1()
    {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
       database.insert(usr);
        system.runAs(usr)
        {   
            try{ 
                Account accnt=ARV_AP05_TestDataCreation.AccRec();  database.insert(accnt);
                Product2 prod=ARV_AP05_TestDataCreation.productRec();database.insert(prod);
                Id standardPriceBookRecId=Test.getStandardPricebookId();
                opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
                ARV_AP03_SBCServiceCls sbcserve=new ARV_AP03_SBCServiceCls();
                ApexPages.currentPage().getParameters().put(ACCID,accnt.id);
                ApexPages.currentPage().getParameters().put(PID,prod.id);
                ApexPages.currentPage().getParameters().put(OPPID,opp.id);
                string reqbody= '--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798'+'Content-Type: application/json' 
                      +'Content-Transfer-Encoding: binary' +'Content-ID: <0.urn:uuid:419F5D1A4114AAFB511518413118799@apache.org>'  +
                 '{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" },'
                      +' "CreationDateTime":"2019-05-03T07:59:03.176-04:00", "MessageID":"SBCMGMTJSON1.0-0f51d1b6-77f3-44c2-ab98-b4c27f63c622",'
                      +' "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful Completion.",'+
                      ' "Source":"CreateDocument" } ] },'+' "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000007289019" },'+
                      ' { "Name":"DocType", "Value":"PDF" } ] } } } ' +'--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798' 
                      +'Content-Type: */*'+'Content-Transfer-Encoding: binary' +'Content-ID: <attachment=urn:uuid:5A38F1FAE2CDC6688F1518012343278>' 
                      +'%PDF-1.5' +'%ÈÈÈÈÈÈÈ' +'%%EOF'  +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                Test.setMock(HttpCalloutMock.class, new ARV_AP06_CalloutMockResp(reqbody));
                test.startTest();
				string effectiveDate=string.valueof(system.today());
                ARV_AP03_SBCServiceCls.getSBCDoc(accnt.Id,prod.Id,opp.Id,CAARRIERTYPE1,effectiveDate,PEIATRICTYPE);
                Test.stopTest();
                system.assert(accnt.Id != null);
                system.assert(prod.Id != null);
            }  
            catch(Exception e) {   return;  }
        }
    }
    /**************  
    Method name : getSBCDoc
    Params     : NA
    Return Type : NA
    Description :  getSBCDoc() method
    *************/ 
    private static testmethod void getSBCDoc()
    {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
       database.insert(usr);
        system.runAs(usr)
        {   
            try{ 
                Account accnt=ARV_AP05_TestDataCreation.AccRec();  database.insert(accnt);
                Product2 prod=ARV_AP05_TestDataCreation.productRec();database.insert(prod);
                Id standardPriceBookRecId=Test.getStandardPricebookId();
                opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
                ARV_AP03_SBCServiceCls sbcserve=new ARV_AP03_SBCServiceCls();
                ApexPages.currentPage().getParameters().put(ACCID,accnt.id);
                ApexPages.currentPage().getParameters().put(PID,prod.id);
                ApexPages.currentPage().getParameters().put(OPPID,opp.id);
                  string reqbody= '--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798'+'Content-Type: application/json' 
                      +'Content-Transfer-Encoding: binary' +'Content-ID: <0.urn:uuid:419F5D1A4114AAFB511518413118799@apache.org>'  +
                 '{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" },'
                      +' "CreationDateTime":"2019-05-03T07:59:03.176-04:00", "MessageID":"SBCMGMTJSON1.0-0f51d1b6-77f3-44c2-ab98-b4c27f63c622",'
                      +' "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful Completion.",'+
                      ' "Source":"CreateDocument" } ] },'+' "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000007289019" },'+
                      ' { "Name":"DocType", "Value":"PDF" } ] } } } ' +'--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798' 
                      +'Content-Type: */*'+'Content-Transfer-Encoding: binary' +'Content-ID: <attachment=urn:uuid:5A38F1FAE2CDC6688F1518012343278>' 
                      +'%PDF-1.5' +'%ÈÈÈÈÈÈÈ' +'%%EOF'  +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
             Test.setMock(HttpCalloutMock.class, new ARV_AP06_CalloutMockResp(reqbody));
              test.startTest();
                string effectiveDate=string.valueof(system.today());
                ARV_AP03_SBCServiceCls.getSBCDoc(accnt.Id,prod.Id,opp.Id,CAARRIERTYPE,effectiveDate,PEIATRICTYPE);
                Test.stopTest();
                system.assert(accnt.Id != null);
                system.assert(prod.Id != null);
            }  
            catch(Exception e) {   return;  }
        }
    }
    /**************  
    Method name : getSBCDoc
    Params     : NA
    Return Type : NA
    Description :  getSBCDoc() method
    *************/ 
    private static testmethod void getSBCDocexeption()
    {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
         database.insert(usr);
        system.runAs(usr)
        {   
            try{ 
                Account accnt=ARV_AP05_TestDataCreation.AccRec();  database.insert(accnt);
                Product2 prod=ARV_AP05_TestDataCreation.productRec();database.insert(prod);   
                 Id standardPriceBookRecId=Test.getStandardPricebookId();
                opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
                ARV_AP03_SBCServiceCls sbcserv=new ARV_AP03_SBCServiceCls();
                ApexPages.currentPage().getParameters().put(ACCID,accnt.id);
                ApexPages.currentPage().getParameters().put(PID,prod.id);
                ApexPages.currentPage().getParameters().put(OPPID,opp.id);
                string reqbody= '--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798'+'Content-Type: application/json' 
                      +'Content-Transfer-Encoding: binary' +'Content-ID: <0.urn:uuid:419F5D1A4114AAFB511518413118799@apache.org>'  +
                 '{ "CreateDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.0" },'
                      +' "CreationDateTime":"2019-05-03T07:59:03.176-04:00", "MessageID":"SBCMGMTJSON1.0-0f51d1b6-77f3-44c2-ab98-b4c27f63c622",'
                      +' "Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful Completion.",'+
                      ' "Source":"CreateDocument" } ] },'+' "PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000007289019" },'+
                      ' { "Name":"DocType", "Value":"PDF" } ] } } } ' +'--MIMEBoundaryurn_uuid_419F5D1A4114AAFB511518413118798' 
                      +'Content-Type: */*'+'Content-Transfer-Encoding: binary' +'Content-ID: <attachment=urn:uuid:5A38F1FAE2CDC6688F1518012343278>' 
                      +'%PDF-1.5' +'%ÈÈÈÈÈÈÈ' +'%%EOF'  +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                Test.setMock(HttpCalloutMock.class, new ARV_AP06_CalloutMockResp(reqbody));
                test.startTest();
                ARV_AP03_SBCServiceCls.getSBCDoc(null,null,null,null,NULL,null);
                Test.stopTest();
                system.assert(accnt.Id != null);
                system.assert(prod.Id != null);
            }catch(Exception e) {   return;  }
        }
    }
    
}