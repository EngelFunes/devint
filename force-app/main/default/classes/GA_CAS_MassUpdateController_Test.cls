/**
@Author : Dilip
@Name: GA_CAS_MassUpdateController_Test
@CreatedDate: 8 - June 2018 
@Description: GA_CAS_MassUpdateController_Test class is for GA_CAS_MassUpdateController class.
@version : 1.0  
*/ 
@isTest 
private class GA_CAS_MassUpdateController_Test {
    
    private Static final String SupWMRecType = 'Support - Support / West Michigan';
    private Static final Id supportWMRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(SupWMRecType).getRecordTypeId();
    /**
@Description: CaseMAssUpdate() method 
@Name : CaseMAssUpdate
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/      
    private static testMethod void CaseMAssUpdate()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            Case case1 = GA_OBJ_TD01_TestDataCreation.CaseRec(); 
            case1.GA_WorkOrderCategory__c='Support Request';
            case1.RecordTypeid = supportWMRecTpeId;
            case1.AccountId = acc1.id;
            case1.GA_Corporate_Received_Date__c=system.today()-4;
            case1.Status='New';
            case1.GA_SupportRequest_Type__c='Crosswalk';
            case1.Subject='WM rec';
            case1.Description='wm rec';
            case1.GA_Due_Date__c=system.today()+5;
            case1.GA_Quote_ID__c='21313';
            database.insert(case1);
            
            GA_Mass_Update_Access__c cusset = new GA_Mass_Update_Access__c();
            cusset.Access__c=True;
            database.insert(cusset);
           
            system.debug('current case id ***'+case1.Id);
            GA_CAS_MassUpdateController.caseLst(acc1.id, case1.Id);
            
            
            case1.GA_Quote_ID__c='234234';
            
            database.update(case1);
            GA_CAS_MassUpdateController.caseLst(acc1.id, case1.Id);
          
            
          //  acc1.GA_System_of_Record__c='SMART';
          //  database.update(acc1);
            GA_CAS_MassUpdateController.caseLst(acc1.id, case1.Id);
            
            List<Case> Clist = [Select Id, GA_Quote_ID__c from Case where GA_Is_Selected__c = true AND  Subject= 'WM rec' limit 100];
            system.debug('query list.......'+Clist);
            String csStringList = '[{"csId":"caseid","csSts":"New","isSelected":true,"Num":"021562"}]';
           csStringList = csStringList.replace('caseid', String.valueOf(case1.Id));
            //String csCurrectSting = String.valueOf(case1);
            system.debug('csStringList.......'+csStringList);
            GA_CAS_MassUpdateController.processSelectedRecords(csStringList, case1.Id);
        }
    }
    /**
@Description: caseQuoteIsBlank() method 
@Name : caseQuoteIsBlank
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/           
    private static testMethod void caseQuoteIsBlank()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            Case case1 = GA_OBJ_TD01_TestDataCreation.CaseRec(); 
            case1.GA_WorkOrderCategory__c='Support Request';
            case1.RecordTypeid = supportWMRecTpeId;
            case1.AccountId = acc1.id;
            case1.GA_Corporate_Received_Date__c=system.today()-4;
            case1.Status='New';
            case1.GA_SupportRequest_Type__c='Crosswalk';
            case1.Subject='WM rec';
            case1.Description='wm rec';
            case1.GA_Due_Date__c=system.today()+5;
            case1.GA_Quote_ID__c='21313';
            database.insert(case1);
            
            /*GA_Mass_Update_Access__c cusset = new GA_Mass_Update_Access__c();
            cusset.Access__c=True;
            database.insert(cusset);*/
            insert new GA_Mass_Update_Access__c(SetupOwnerId=UserInfo.getOrganizationId(), Access__c=true);

   
            system.debug('current case id ***'+case1.Id);
            GA_CAS_MassUpdateController.caseLst(acc1.id, case1.Id);
            
            
            case1.GA_Quote_ID__c='';
            database.update(case1);
            GA_CAS_MassUpdateController.caseLst(acc1.id, case1.Id);
          
        
        }
    }
    /**
@Description: CaseAccountIsSmart() method 
@Name : CaseAccountIsSmart
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/     
    private static testMethod void CaseAccountIsSmart()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            Case case1 = GA_OBJ_TD01_TestDataCreation.CaseRec(); 
            case1.GA_WorkOrderCategory__c='Support Request';
            case1.RecordTypeid = supportWMRecTpeId;
            case1.AccountId = acc1.id;
            case1.GA_Corporate_Received_Date__c=system.today()-4;
            case1.Status='New';
            case1.GA_SupportRequest_Type__c='Crosswalk';
            case1.Subject='WM rec';
            case1.Description='wm rec';
            case1.GA_Due_Date__c=system.today()+5;
            case1.GA_Quote_ID__c='21313';
            database.insert(case1);
            
            GA_Mass_Update_Access__c cusset = new GA_Mass_Update_Access__c();
            cusset.Access__c=True;
            database.insert(cusset);
            
            List<Case> casList1 = New List<Case>();  
            for(Integer i=0; i<1; i++)
            {
                case cs1 = GA_OBJ_TD01_TestDataCreation.CaseRec();
                cs1.Subject = 'TESTSub'+i;
                cs1.accountid = acc1.id;
                cs1.GA_Is_Selected__c = true;
                cs1.GA_WorkOrderCategory__c='Support Request';
                cs1.RecordTypeid = supportWMRecTpeId;
                cs1.GA_Corporate_Received_Date__c=system.today()-4;
                /**cs1.Status='New1';**/
                cs1.GA_SupportRequest_Type__c='Crosswalk';
                cs1.Subject='WM rec';
                cs1.Description='wm rec';
                cs1.GA_Due_Date__c=system.today()+5;
                
                casList1.add(cs1);
            }
           
            database.insert(casList1);
            system.debug('current case id ***'+case1.Id);
            GA_CAS_MassUpdateController.caseLst(acc1.id, case1.Id);
            
         
            
            acc1.GA_System_of_Record__c='SMART';
            database.update(acc1);
            GA_CAS_MassUpdateController.caseLst(acc1.id, case1.Id);
         
        }
        
        
    }
    /**
@Description: CaseMAssUpdateSales() method 
@Name : CaseMAssUpdateSales
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/     
     private static testMethod void CaseMAssUpdateSales()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Specialty Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            string accid = 'test';
            string caseid = 'case1id';
            
            GA_CAS_MassUpdateController.caseLst(accid, caseid);
            
        }
        
    }
}