/*
#########################################################################################
Project Name..........: <ABR> 
File..................: <ABR_Benefir_Category_Trigger_HandlerTest> 
Version...............: <1.0> 
Created by............: <Accenture> 
Created Date..........: <01/05/2021> 
Last Modified by......: <Accenture>
Last Modified Date....: <01/05/2021>
Description...........: <The ABR_Benefir_Category_Trigger_HandlerTest is used to provide supportive methods for the PlanModBenefitCategory based triggers
History...............:       
                        <01/05/2021 - Creation   insertPlanModBenefitCategoryRecord() method to create records
#########################################################################################
*/
@isTest
public with sharing class ABR_Benefit_Category_Trigger_HandlerTest {
    @isTest
    static void insertPlanModBenefitCategoryRecord() {
        
        ABR_Plan_Mod__c planMod = ABR_Creation_ABR_Plan_Mod_Test.Insert_ABR_Plan_Mod();
        
        List<ABR_Plan_Mod_Benefit_Category__c> lstPlanModBenefitCategory = ABR_Creation_PlanModBenefitCategory_Test.InsertList( planMod );
        List<ABR_Plan_Mod_Benefit_Category__c> lstPlanModBenefitCategory2 = ABR_Creation_PlanModBenefitCategory_Test.InsertList( planMod );

        Update lstPlanModBenefitCategory;

        Update lstPlanModBenefitCategory2;

        Delete lstPlanModBenefitCategory;

        Delete lstPlanModBenefitCategory2;
    }
}