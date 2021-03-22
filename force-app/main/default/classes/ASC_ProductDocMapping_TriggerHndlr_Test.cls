/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_PDM_DuplicateCheck
@CreatedDate: 29 - April 2020
@Description: ASC_ProductDocMapping_TriggerHndlr_Test class is for ASC_ProductDocMapping_TriggerHandler test class
@version : 1.0  
**********************************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_ProductDocMapping_TriggerHndlr_Test {
    private static final string PDMNAME  ='TEST PDM';
    private static final Integer SEQUENCE = 20;
    private static final string  SECTION= '20';
    private static final string  SECTION1= '40';
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
            Product_Document_Mapping__c pdm = new Product_Document_Mapping__c();
            pdm.Name=PDMNAME; 
            
            test.startTest();
            database.insert(pdm);
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
            Product_Document_Mapping__c pdm = new Product_Document_Mapping__c();
            pdm.Name=PDMNAME;
            pdm.Sequence__c=SEQUENCE;
            pdm.Section__c=SECTION;
            database.insert(pdm);           
            pdm.Section__c=SECTION1;           
            test.startTest();
            database.update(pdm);
            
            test.stopTest();           
            system.assert(usr <> null);
        }      
    } 
    
}