/*****************************************************************************************
Trigger Name   : ARV_GWCTrigger. 
Date Created : 12-JAN-2021
Created By   : IDC Offshore
Description  :This trigger is for changes/additions to GWC Transaction Table records.
******************************************************************************************/

trigger ARV_GWCTrigger on ARV_GWC_Transaction_Table__c (after insert,after update ) {
   
    if(Trigger.IsAfter && Trigger.isUpdate){
        
        //for sending email whenever Rating Area Change is approved
        if(ARV_Maintenance_Approval_Criteria.isEmailSent){
            if(Trigger.new != null && Trigger.new.size()>0){	
                for (ARV_GWC_Transaction_Table__c con: Trigger.new){
                    ARV_GWC_Transaction_Table__c oldCon = Trigger.oldMap.get(con.ID);
                    if(con.Status__c != oldCon.Status__c && (con.RatingAreaFlag__c == true && con.Status__c =='Approval Process - Approved')){         
                        String AcId=con.Account_ID__c;
                        Account cid =[select CID__c from Account where id=:AcId limit 1];
                        String CAccID= String.valueOf(cid);
                        ARV_Maintenance_Approval_Criteria.sendEmailMC(con.Account_Name__c,CAccID);
                        ARV_Maintenance_Approval_Criteria.isEmailSent = false;
                   }                
                }
            }
        }
        
        //insert Common Control record
        ARV_AP107_GWCTransacTableTriggerHandler.insertCommonControl(Trigger.oldMap, Trigger.new);
	}
}