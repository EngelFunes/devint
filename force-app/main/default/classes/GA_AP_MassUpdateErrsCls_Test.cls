/*****************************************************************************************
Class Name   : GA_AP_MassUpdateErrsCls
Date Created : 09/12/2018
Created By   : IDC Offshore
Description  : 1. This is controller class to mass update errors
******************************************************************************************/
@isTest
public class GA_AP_MassUpdateErrsCls_Test {
    /**
@Description: fetchRecsTest() method 
@Name : fetchRecsTest
@Param : NA
@Return : NA
@throws Exception : AuraHandledException;
*/    
   public static testmethod void fetchRecsTest()
    {
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestEnrlmnt','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpSgmntRec.Status__c = 'Active';
               //   grpSgmntRec.GA_Future_Plan_Package_Chk__c = true;
               //  grpSgmntRec.GA_Current_Plan_Package__c = true;
                database.insert(grpSgmntRec);
        
        GA_AP_MassUpdateErrsCls.fetchRecs('[{"errFieldLbl":"Group Effective Date","errfieldNme":"GA_Group_Effective_Date__c","errfieldType":"Date","errmessage":"Group Effective Date cannot be null","errObjNme":"GA_Group_Segment__c","errRecId":"a1Lc0000001TFflEAG","errRecIdUrl":"/a1Lc0000001TFflEAG","errRecName":"GS-00001454"}]');
        GA_AP_MassUpdateErrsCls.updtRecs('[{"fieldLabel":"Group Effective Date","fieldName":"GA_Group_Effective_Date__c","fieldType":"Date","ObjType":"GA_Group_Segment__c","recIds":"a1Lc0000001TFflEAG","inputVal":"2019-02-08"}]');
          GA_AP_MassUpdateErrsCls.fetchRecs('');
                 GA_AP_MassUpdateErrsCls.updtRecs('');
                
                 }
            catch(exception e)
            {
                //system.assert(e !=null);
            }
        }
    }
    

}