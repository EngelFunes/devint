/*
#########################################################################################
Project Name..........: <ABR> 
File..................: <ABR_Creation_ABR_Plan_Mod_Test> 
Version...............: <1.0> 
Created by............: <Accenture> 
Created Date..........: <01/05/2021> 
Last Modified by......: <Accenture>
Last Modified Date....: <01/05/2021>
Description...........: <The ABR_Creation_ABR_Plan_Mod_Test is used to provide supportive methods for the PlanModBenefitCategory based triggers
History...............:       
                        <01/05/2021 - Creation   Insert_ABR_Plan_Mod() method to create records
#########################################################################################
*/
@isTest
public with sharing class ABR_Creation_ABR_Plan_Mod_Test {
    public static ABR_Plan_Mod__c Insert_ABR_Plan_Mod() {
        ABR_Plan_Mod__c planMod = new ABR_Plan_Mod__c();

        Insert planMod;

        Return planMod;
    }
}