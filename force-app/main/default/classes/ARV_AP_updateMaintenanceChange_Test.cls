/*********************************************
@Author : IDC Offshore
@Name: ARV_AP_updateMaintenanceChange_Test
@CreatedDate: 30-Nov-2020
@Description: ARV_AP_updateMaintenanceChange_Test 
@version : 1.0 
**********************************************/
@isTest
public class ARV_AP_updateMaintenanceChange_Test {
    Private static final String TEST_VAL='Test';
    Private static final String ACTIVE='Active';
    private static final string PROFILENAME='System Administrator';
    private static final string NAME='AP61LastName';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string PROFILENAME1='BCBSM FSA';
    private static final string METHODNAME='updateGWC';
    
    /******************************************************************************************************
@Description: testDataSetup1() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/

    private static testMethod void updateRecordtest()
    {
        Id recordTypeId = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
        Map<String,Object> inputMap = new Map<String,Object> ();
        Map<String,Object> outMap   = new Map<String,Object> ();
        Map<String,Object> options  = new Map<String,Object> ();     
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        usr.Username=USERNAME;
        database.insert(usr);
        
        system.runAs(usr){
           
            Account acc=ARV_AP05_TestDataCreation.accRec();
            acc.CID__c = '601703';
            database.insert(acc);
            
            ARV_GWC_Transaction_Table__c gwc = ARV_AP05_TestDataCreation.gwcTransaction(acc.id);
            gwc.RecordTypeId = recordTypeId;
            gwc.Is_common_control__c= true;
            gwc.Status__c = 'In Progress';
            gwc.GWC_Batch_ID__c = 'M32938';
            gwc.RatingAreaFlag__c = true;
            database.insert(gwc);
            
            ARV_GWC_Transaction_Table__c gwc2 = ARV_AP05_TestDataCreation.gwcTransaction(acc.id);
            gwc2.RecordTypeId = recordTypeId;
            gwc2.Status__c = 'In Progress';
            gwc2.GWC_Batch_ID__c = 'M32938';
            database.insert(gwc2);
            
            inputMap.put('ContextId',acc.Id);
            options.put('UniqueBatchID',gwc.GWC_Batch_ID__c);
                       
            ARV_AP_updateMaintenanceChangeRecord.invokeMethod(METHODNAME,inputMap, outMap, options);
        }
    }
}