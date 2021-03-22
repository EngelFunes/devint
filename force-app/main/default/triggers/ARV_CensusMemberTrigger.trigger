/*****************************************************************************************
Trigger Name   : ARV_CensusMemberTrigger. 
Date Created : 4-MARCH-2021
Created By   : IDC Offshore
Description  :This trigger is for changes/additions to Census Member records.
******************************************************************************************/

trigger ARV_CensusMemberTrigger on vlocity_ins__GroupCensusMember__c (before insert, after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        ARV_AP108_CensusMemberTriggerHandler.updateCensusMembers(Trigger.new);
    }
}