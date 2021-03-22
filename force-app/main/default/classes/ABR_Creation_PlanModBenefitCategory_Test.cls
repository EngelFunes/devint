/*
#########################################################################################
Project Name..........: <ABR> 
File..................: <ABR_Creation_PlanModBenefitCategory_Test> 
Version...............: <1.0> 
Created by............: <Accenture> 
Created Date..........: <01/05/2021> 
Last Modified by......: <Accenture>
Last Modified Date....: <01/05/2021>
Description...........: <The ABR_Benefir_Category_Trigger_HandlerTest is used to provide supportive methods for the PlanModBenefitCategory based triggers
History...............:       
                        <01/05/2021 - Creation   InsertList() method to create record list     
#########################################################################################
*/
@isTest
public with sharing class ABR_Creation_PlanModBenefitCategory_Test {    
    public static List<ABR_Plan_Mod_Benefit_Category__c> InsertList( ABR_Plan_Mod__c planMod ) {
        List<ABR_Plan_Mod_Benefit_Category__c> lstPlanModBenefitCategory = new List<ABR_Plan_Mod_Benefit_Category__c>();
        Decimal decBenefitCounter = 53.0;
        String strHTMLnarration = '<table class="ql-table-blob" border="1" style="margin-left: 5.4pt;" width="756"><tbody><tr style="height: .2in;"><td colspan="1" rowspan="1" valign="top" width="583" style="width: 437.4pt; height: .2in;"> <p class="MsoNormalCxSpFirst" style=""><b><u><span style="font-size: 11.5pt;">A. Coverage Prior to this Modification</span></u></b></p> </td></tr><tr style="height: 5.0pt;"><td colspan="1" rowspan="1" valign="top" width="583" style="width: 437.4pt; height: 5.0pt;"> <p class="MsoNormal" style="margin-left: 0in;"><span style="font-size: 11.5pt;">Under the Simply Blue HSA Group Benefits Certificate with Prescription Drugs ASC (Form Number 453F) with Rider SBD-HSA-D $2000/$4000 IN $4000/$8000-ON ASC (Form Number 533F) and Rider SBD-HSA-OPM $3500-IN $7000-ON ASC (Form Number 550G), payments for most covered services obtained from in-network and out-of-network providers are subject to the following cost sharing requirements:</span></p> <p class="MsoNormal"><strong><u><span style="font-size: 11.5pt;">In-network deductible</span></u></strong><span style="font-size: 11.5pt;"></span></p> <ul><li><span style="font-size: 11.5pt;">$2,000 for a one-person contract</span></li><li style=""><span style="font-size: 11.5pt;">$4,000 for two or more members</span></li></ul> <p class="MsoNormal"><strong><u><span style="font-size: 11.5pt;">Out-of-network deductible</span></u></strong><span style="font-size: 11.5pt;"></span></p> <ul><li><span style="font-size: 11.5pt;">$4,000 for a one-person contract</span></li></ul> <ul><li style=""><span style="font-size: 11.5pt;">$8,000 for two or more members</span></li></ul> <p class="MsoNormal"><strong><u><span style="font-size: 11.5pt;">Coinsurance requirements</span></u></strong><span style="font-size: 11.5pt;"></span></p> <ul><li><span style="font-size: 11.5pt;">20 percent, after deductible, in-network</span></li><li style=""><span style="font-size: 11.5pt;">40 percent, after deductible, out-of-network</span></li></ul> <p class="MsoNormal"><strong><u><span style="font-size: 11.5pt;">In-network out-of-pocket maximum</span></u></strong><span style="font-size: 11.5pt;"></span></p> <ul><li><span style="font-size: 11.5pt;">$3,500 for a one-person contract</span></li><li style=""><span style="font-size: 11.5pt;">$7,000 for two or more members</span></li></ul> <p class="MsoNormal"><strong><u><span style="font-size: 11.5pt;">Out-of-network out-of-pocket maximum</span></u></strong><strong><u><span style="font-size: 11.5pt; font-weight: normal;"></span></u></strong></p> <ul><li><span style="font-size: 11.5pt;">$7,000 for a one-person contract</span></li><li style=""><span style="font-size: 11.5pt;">$14,000 for two or more members</span></li></ul> </td></tr></tbody></table><p><br></p>';

        for( Integer i = 1; i<= 3 ; i++ ){
            lstPlanModBenefitCategory.add( new ABR_Plan_Mod_Benefit_Category__c(
                ABR_Plan_Mod__c = planMod.id,
                ABR_Narration_A__c = strHTMLnarration,
                ABR_Benefit_Counter__c = decBenefitCounter) );
        }

        Insert lstPlanModBenefitCategory;

        Return lstPlanModBenefitCategory;
    }
}