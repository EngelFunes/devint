/**
@Author : ARV Team
@Name: ARV_ContractTrigger
@CreatedDate:27-March-2020
@Description: ARV_ContractTrigger   trigger is for update Contract
@version : 1.0  
*/

trigger ARV_ContractTrigger on Contract(after update, before Insert, before update, after insert) {
    static final String STATUS = 'Processing GWC';
    static final String INT_USER_NAME = 'Informatica Admin User';
    static final String INT_PROFILE_NAME = 'Integration User';

    if (!GA_Profile_ByPass__c.getInstance().Bypass__c) {
        if (trigger.isafter) {
            ARV_AP87_ContractTriggerHandler.afterupdate(trigger.new, trigger.oldmap);
        }

        system.debug('trigger.isafter' + trigger.isafter);
        system.debug('trigger.isupdate' + trigger.isupdate);

        if (trigger.isafter && trigger.isupdate && ARV_AP87_ContractTriggerHandler.flagDocGen) {

            ARV_AP87_ContractTriggerHandler.getContractStatusBCNSheet(Trigger.new, Trigger.oldMap);
            ARV_AP87_ContractTriggerHandler.flagDocGen = ARV_AP41_StringLiteralUtils.FALSE_VALUE;
        }

        if (trigger.isafter && trigger.isupdate && ARV_AP87_ContractTriggerHandler.isEmailSent) {

            for (Contract con: Trigger.new) {
                Contract oldCon = Trigger.oldMap.get(con.ID);
                if (con.status != oldCon.status && (con.ARV_Enrollment_StatusFormula__c == STATUS)) {
                    System.debug('**Old  :' + oldCon.status);
                    System.debug('**New :' + con.status);
                    ARV_AP87_ContractTriggerHandler.aprGWCEmail(con.ARV_TECH_Account_Name__c, con.ARV_Account_CID__c);
                    ARV_AP87_ContractTriggerHandler.isEmailSent = ARV_AP41_StringLiteralUtils.FALSE_VALUE;
                }
            }
        }

    }

    if (trigger.isafter && trigger.isupdate) {

        for (Contract con: Trigger.newMap.values()) {
             {
                 if(con.vlocity_ins__EnrollmentCensusId__c!=null && con.vlocity_ins__FinalRatingGroupCensusId__c!=null && con.RecordTypeId!=null /*&& (con.LastModifiedBy.Name == INT_USER_NAME || con.LastModifiedBy.Profile.Name==INT_PROFILE_NAME)*/){
                    ARV_AP87_ContractTriggerHandler.updateCensusMembers(con.RecordTypeId,con.vlocity_ins__EnrollmentCensusId__c,con.vlocity_ins__FinalRatingGroupCensusId__c);
                }
            }
        }
    }
    if (trigger.isafter && trigger.isupdate) {
        
		ARV_AP87_ContractTriggerHandler.updatedGWCRecords(trigger.new);
        
        for (Contract con: Trigger.newMap.values()) {
             {
                 if(con.vlocity_ins__EnrollmentCensusId__c!=null && con.vlocity_ins__FinalRatingGroupCensusId__c!=null && con.ARV_Contract_Type__c =='Small Group Renewal'){
                    ARV_AP87_ContractTriggerHandler.updateCensusMembers(con.RecordTypeId,con.vlocity_ins__EnrollmentCensusId__c,con.vlocity_ins__FinalRatingGroupCensusId__c);
                }
            }
        }
    }
}