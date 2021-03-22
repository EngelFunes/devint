/**
@Name: ARV_AP_ScheduleCensusMemberRates
@CreatedDate: 15-July-2020
@Description:ARV_AP_ScheduleCensusMemberRates calss is for update census memberrates
@version : 1.0 
*/
global class ARV_AP_ScheduleCensusMemberRates implements Schedulable {
    global void execute(SchedulableContext Sc) {
      ARV_AP_CalculateCensuMemberRates.dailyLoad();
    }
    
}