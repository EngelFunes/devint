/*
@Author : IDC offshore
@Name: GA_ChangeSRTypeCls_Test 
@CreatedDate: 2/26/2019
@Description: GA_ChangeSRTypeCls_Test Test class
@version : 1.0  
*/
@isTest
private class GA_ChangeSRTypeCls_Test {
    /*
@method: fetchChangrSRTypeAccess
@param: NA
*/
    private static testMethod void fetchChangrSRTypeAccess(){
        UserRole usrRleId = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative');
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        usr.UserRoleId = usrRleId.id;
        
        database.insert(usr);
        system.runAs(usr)
        {
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.GA_SupportRequest_Type__c='Account Cancellation';
            insert cas;
            
            test.startTest();
            
            GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Change_SR_Type__c = true;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
            
     
            GA_ChangeSRTypeCls.fetchChangrSRTypeAccess();
            GA_ChangeSRTypeCls.fetchServiceRequestPicklistValues();
            try{
                GA_ChangeSRTypeCls.updateCategoryBasedonSRType(cas.GA_SupportRequest_Type__c, cas.Id);
            }Catch(Exception e){

            }
            try{
                GA_ChangeSRTypeCls.updateCategoryBasedonSRType('', cas.Id);
            }Catch(Exception e){

            }
            
            try{
                GA_ChangeSRTypeCls.updateCategoryBasedonSRType('test', cas.Id);
            }Catch(Exception e){

            }
            
            test.stopTest();
            
        }
    }
}