trigger ARV_CRCTrigger on Carrier_Rate_Comparison__c (after insert) {
if(trigger.isAfter&&trigger.isInsert){
ARV_AP_CRCTriggerHandler.updateIPCoRCData(trigger.new);
    //updateIpCorcdata
}
}