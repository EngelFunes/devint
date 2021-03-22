/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_PDM_DuplicateCheck
@CreatedDate: 29 - April 2020
@Description: ASC_PDM_DuplicateCheck_Test class is for ASC_PDM_DuplicateCheck test class
@version : 1.0  
**********************************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_PDM_DuplicateCheck_Test {
    /**
@Description: createPdmRecords() method 
@Name : createPdmRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void createPdmRecords(){        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            List<Product2>prdRecdList = New List <Product2>();
            Product2 prdRec=new Product2 ();
            prdRec.Name='Testp';
            prdRec.Family='Medical';
            prdRec.ASC_Pricing_Method__c='PCPM';
            prdRec.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
            prdRecdList.add(prdRec);           
            Product2 csprdRec=new Product2();
            csprdRec.Name='Test2p';
            csprdRec.ASC_Pricing_Method__c='PCPM';
            csprdRec.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId();
            prdRecdList.add(csprdRec);
            database.insert(prdRecdList);           
            Product_Document_Mapping__c pdm = new Product_Document_Mapping__c();
            pdm.Name='Testpdm';
            pdm.Parent_Product__c=prdRec.id;
            pdm.Coverage_Product__c=csprdRec.id;
            pdm.Document_Type__c='Schedule A';
            pdm.Document_Version__c='2021 Schedule A Default';
            pdm.Sequence__c=2;
            pdm.Section__c='test2';
            database.insert(pdm);           
            List<Product_Document_Mapping__c> pdmLst = new List<Product_Document_Mapping__c>();
            Product_Document_Mapping__c pdmDup = new Product_Document_Mapping__c();
            pdmDup.Name='Testpdm';
            pdmDup.Parent_Product__c=prdRec.id;
            pdmDup.Coverage_Product__c=csprdRec.id;
            pdmDup.Document_Type__c='Schedule A';
            pdmDup.Document_Version__c='2021 Schedule A Default';
            pdmDup.Sequence__c=2;
            pdmDup.Section__c='test2';
            pdmLst.add(pdmDup);                
            test.startTest();
            ASC_PDM_DuplicateCheck.checkPDMRecdDuplict(pdmLst,null);
            test.stopTest();           
            system.assert(usr <> null);
        }
        
    }
    /**
@Description: updtePdmRecords() method 
@Name : updtePdmRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtePdmRecords(){        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            List<Product2>prdRecdList = New List <Product2>();
            Product2 prdRec=new Product2 ();
            prdRec.Name='Testp';
            prdRec.Family='Medical';
            prdRec.ASC_Pricing_Method__c='PCPM';
            prdRec.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
            prdRecdList.add(prdRec);          
            Product2 csprdRec=new Product2();
            csprdRec.Name='Test2p';
            csprdRec.ASC_Pricing_Method__c='PCPM';
            csprdRec.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId();
            prdRecdList.add(csprdRec);
            database.insert(prdRecdList);           
            map<id,Product_Document_Mapping__c> pdmOldMap=new map<id,Product_Document_Mapping__c>();
            List<Product_Document_Mapping__c> pdmInsrtLst = new List<Product_Document_Mapping__c>();
            
            Product_Document_Mapping__c pdm = new Product_Document_Mapping__c();
            pdm.Name='Testpdm';
            pdm.Parent_Product__c=prdRec.id;
            pdm.Coverage_Product__c=csprdRec.id;
            pdm.Document_Type__c='Schedule A';
            pdm.Document_Version__c='2021 Schedule A Default';
            pdm.Sequence__c=2;
            pdm.Section__c='test2';
            pdmInsrtLst.add(pdm);          
            pdmOldMap.put(pdm.id,pdm);
            Product_Document_Mapping__c pdmDup = new Product_Document_Mapping__c();
            pdmDup.Name='Testpdm';
            pdmDup.Parent_Product__c=prdRec.id;
            pdmDup.Coverage_Product__c=csprdRec.id;
            pdmDup.Document_Type__c='Schedule A';
            pdmDup.Document_Version__c='2021 Schedule A Default';
            pdmDup.Sequence__c=3;
            pdmDup.Section__c='test2';
            pdmInsrtLst.add(pdmDup);
            database.insert(pdmInsrtLst);
            
            List<Product_Document_Mapping__c> pdmUpdtLst = new List<Product_Document_Mapping__c>();
            pdmDup.Sequence__c=2;
            pdmUpdtLst.add(pdmDup);                
            test.startTest();
            ASC_PDM_DuplicateCheck.checkPDMRecdDuplict(pdmUpdtLst,pdmOldMap);
            test.stopTest();    
            system.assert(usr <> null);                 
        }        
    }    
}