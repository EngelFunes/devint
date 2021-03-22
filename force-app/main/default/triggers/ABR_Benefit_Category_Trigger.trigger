trigger ABR_Benefit_Category_Trigger on ABR_Plan_Mod_Benefit_Category__c (before insert, after delete, before update) {

  if( Trigger.isBefore && Trigger.isUpdate ){
    system.debug('trigger' + trigger.new);
    system.debug('@@@@trigger' + 'isUpdate');
    List<ABR_Plan_Mod_Benefit_Category__c> Ids = new List<ABR_Plan_Mod_Benefit_Category__c>();

    for (ABR_Plan_Mod_Benefit_Category__c abrBenefitCategory : trigger.new){
      Ids.add(abrBenefitCategory);
    }
    ABR_Benefit_Category_Trigger_Handler.textFormatBenefitCategory(Ids);
  }
    
  if( Trigger.isBefore && trigger.isInsert){
      system.debug('trigger' + trigger.new);
      system.debug('@@@@trigger' + 'isInsert');
      List<ABR_Plan_Mod_Benefit_Category__c> Ids = new List<ABR_Plan_Mod_Benefit_Category__c>();

      for (ABR_Plan_Mod_Benefit_Category__c abrBenefitCategory : trigger.new){
      Ids.add(abrBenefitCategory);
      }
      ABR_Benefit_Category_Trigger_Handler.insertBenefitCategory(Ids);
      ABR_Benefit_Category_Trigger_Handler.textFormatBenefitCategory(Ids);
  }
    
  if(Trigger.isDelete){
    system.debug('@@@@trigger' + 'isDelete');
    List<ABR_Plan_Mod_Benefit_Category__c> benefitIds = new List<ABR_Plan_Mod_Benefit_Category__c>();

    for (ABR_Plan_Mod_Benefit_Category__c abrBenefitCategory : trigger.old){
      benefitIds.add(abrBenefitCategory);
    }
    ABR_Benefit_Category_Trigger_Handler.deleteBenefitCategory(benefitIds);
  }
}