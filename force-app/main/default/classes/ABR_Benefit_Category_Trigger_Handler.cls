public class ABR_Benefit_Category_Trigger_Handler {

    public static void textFormatBenefitCategory(List<ABR_Plan_Mod_Benefit_Category__c> listBenefit){

        for(ABR_Plan_Mod_Benefit_Category__c planBenefitRec :listBenefit){
            planBenefitRec.ABR_Narration_A__c = formatingText(planBenefitRec.ABR_Narration_A__c);
            planBenefitRec.ABR_Narration_B__c = formatingText(planBenefitRec.ABR_Narration_B__c);
        }

    }
     public static String formatingText(String text){
        String border1 = 'border="1"';
        String border0 = 'border="0"';
        String strOpen = 'width="';
        String strClose = '">';
        String strPercentage = '100%';
        String strOpenFont = 'font-size:';
        String strCloseFont = ';';
        String strFontSize = '11.5pt';

               
        if( !String.isBlank(text) ){
            //Setup border from 1 to 0 
            text = text.replace(border1, border0);                
        
            //Width fix in 100%
            String wNumber = text.substringBetween(strOpen,strClose);
            String strWidthInicial = strOpen + wNumber + strClose;
            String strWidthFinal = strOpen + strPercentage + strClose;
            text = text.replace(strWidthInicial, strWidthFinal);

            //Font size setup in 11.5pt
            String fontNumber = text.substringBetween(strOpenFont,strCloseFont);
            String strFontInicial = strOpenFont + '[^>]*'+ strCloseFont;
            String strFontFinal = strOpenFont + strFontSize + strCloseFont;
            text = text.replaceAll(strFontInicial, strFontFinal);

        }

        return text;
     }

public static void insertBenefitCategory(List<ABR_Plan_Mod_Benefit_Category__c> listBenefit){
        
        Map<Id, Integer> maxCountBenefitMap = new Map<Id, Integer>();
        Set<Id> planModIdSet= new Set<Id>();
    
        system.debug('listBenefit '+ listBenefit);
        for(ABR_Plan_Mod_Benefit_Category__c planBenefitRec :listBenefit){
            planModIdSet.add(planBenefitRec.ABR_Plan_Mod__c);
        }
        
        List <AggregateResult> maxResults = [SELECT Max(ABR_Benefit_Counter__c), ABR_Plan_Mod__c FROM ABR_Plan_Mod_Benefit_Category__c WHERE 
                                         ABR_Plan_Mod__c IN :planModIdSet GROUP BY ABR_Plan_Mod__c];

        system.debug('maxResults '+ maxResults);

        for (AggregateResult result : maxResults){
            maxCountBenefitMap.put((Id)result.get('ABR_Plan_Mod__c'), Integer.valueOf(result.get('expr0')));
        }
    

        for(ABR_Plan_Mod_Benefit_Category__c planBenefitRec :listBenefit){
            Integer tempCount= maxCountBenefitMap.get(planBenefitRec.ABR_Plan_Mod__c);
            if(tempCount == null)
                tempCount = 0;
            tempCount=tempCount+1;
            planBenefitRec.ABR_Benefit_Counter__c=tempCount;
            maxCountBenefitMap.put(planBenefitRec.ABR_Plan_Mod__c,tempCount);
            
        }
         system.debug('maxCountBenefitMap '+ maxCountBenefitMap);
    }
    


public static void deleteBenefitCategory(List<ABR_Plan_Mod_Benefit_Category__c> oldListBenefit){
        
    Map<Id, List<ABR_Plan_Mod_Benefit_Category__c>> planModAndBenefitMap = new Map<Id, List<ABR_Plan_Mod_Benefit_Category__c>>();
    Set<Id> planModIdSet= new Set<Id>();
    List<ABR_Plan_Mod_Benefit_Category__c> abrBenefitDeleteList = new List<ABR_Plan_Mod_Benefit_Category__c>();

    for(ABR_Plan_Mod_Benefit_Category__c planBenefitRec : oldListBenefit){
        planModIdSet.add(planBenefitRec.ABR_Plan_Mod__c);
    }
    
    for(ABR_Plan_Mod_Benefit_Category__c abrBenefit: [select ABR_Benefit_Counter__c,ABR_Plan_Mod__c,CreatedDate from 
        ABR_Plan_Mod_Benefit_Category__c where ABR_Plan_Mod__c in: planModIdSet order by CreatedDate ]){
            if(planModAndBenefitMap.containsKey(abrBenefit.ABR_Plan_Mod__c)) {
                planModAndBenefitMap.get(abrBenefit.ABR_Plan_Mod__c).add(abrBenefit);
            } 
            else{
                planModAndBenefitMap.put(abrBenefit.ABR_Plan_Mod__c, new List<ABR_Plan_Mod_Benefit_Category__c> {abrBenefit});
            }
    }
    
    system.debug('planModAndBenefitMap'+ planModAndBenefitMap.size());
    for(Id planModId : planModAndBenefitMap.keyset()){
        Integer tempCount= 1;
        for(ABR_Plan_Mod_Benefit_Category__c planBenefitRec : planModAndBenefitMap.get(planModId)){
            
            planBenefitRec.ABR_Benefit_Counter__c=tempCount;
            
            tempCount=tempCount+1;
            system.debug('tempCount '+ tempCount);
            abrBenefitDeleteList.add(planBenefitRec);
        }
    }
    system.debug('abrBenefitDeleteList'+ abrBenefitDeleteList);
    if(!abrBenefitDeleteList.isEmpty()){
        update abrBenefitDeleteList;
    }
         
}    
}