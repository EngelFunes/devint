@isTest
public class ReUsableMultiSelectLookupCtrlTest {
    
    public static testmethod void resulsblemultiselect()
    {
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
               
                /*GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
                tRec.GA_RetentionSalesRepresentative__c=usr.id;
                database.insert(tRec);*/
                GA_Territory__c terytoryRec=new GA_Territory__c();
                terytoryRec.Name='Test Territory Name';
                terytoryRec.GA_TerritoryType__c='Account Manager';
                terytoryRec.GA_TerritoryCode__c='23';
                terytoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
                insert terytoryRec;
                //terytoryRec.Active__c=true;
                update terytoryRec;
                
               
               Territory_ASR_Assignment_List__c tsa = new Territory_ASR_Assignment_List__c();
               tsa.Territory__c= terytoryRec.id; 
               tsa.Active__c=true;
               tsa.ASR__c=usr.id;
          
               tsa.Territory_Region__c='123654';
               tsa.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region Territory Map').getRecordTypeId();        
               insert tsa;
               
              
               tsa.RecordTypeId =  Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();        
               tsa.Active__c=false;
               update tsa;
               
               Territory_ASR_Assignment_List__c tsa1 = new Territory_ASR_Assignment_List__c();
               tsa1.Territory__c= terytoryRec.id; 
               tsa1.Active__c=false;
               tsa1.ASR__c=usr.id;
               
               tsa1.Territory_Region__c='1236547';
               tsa1.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();        
               insert tsa1;
              
               
               reUsableMultiSelectLookupCtrl.getselectOptions();
               reUsableMultiSelectLookupCtrl.getSelectedTerritories('West MI');
               reUsableMultiSelectLookupCtrl.getUsers();
               reUsableMultiSelectLookupCtrl.addRegionPicListValue('123654');
               reUsableMultiSelectLookupCtrl.fetchLookUpValues('testr','GA_Territory__c',new List<GA_Territory__c> {terytoryRec}, '');
               reUsableMultiSelectLookupCtrl.getSelectedUsers('West MI');
               reUsableMultiSelectLookupCtrl.saveChanges('123654',new List<GA_Territory__c> {terytoryRec}, new list<User> {usr});
               reUsableMultiSelectLookupCtrl.checkValidTerr('123654',new List<GA_Territory__c> {terytoryRec}, new list<User> {usr});
            reUsableMultiSelectLookupCtrl.deleteRegionAssigments('123654');
                reUsableMultiSelectLookupCtrl.renameRegion('123654', '12');
 
               }
        }   

}