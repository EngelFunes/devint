/******************************************************************************************************************************************
@Author : Offshore
@Name: ASC_GroupSpecPricingTriggerHndlr
@CreatedDate: 23 - March 2020 
@Description: ASC_GroupSpecPricingTriggerHndlr contains the helper methods for Group SpecificLock/Unlock process 
@version : 1.0  
*****************************************************************************************************************************************/
public without sharing class ASC_GroupSpecPricingTriggerHndlr {
    
    private static final string CLSNAME  ='ASC_GroupSpecPricingTriggerHndlr';
    private static final string METHODNMEAFTERINSERT  ='afterinsert';
    private static final string METHODNMEAFTERUPDATE='afterupdate';
    private static final string METHODNMEBEFOREDELETE='beforeDelete';
    private static final String DATASOURCE = 'ASC_Data_Source__c';
    private static boolean isExecuting = false;

    /*********************************************************************************************************************************************
    @Description: afterupdate() method 
    @Name : afterupdate
    @Param : list<ASC_Group_Specific_Pricing__c> grpSpecList,map<id,ASC_Group_Specific_Pricing__c> grpSpecOldMap
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void afterupdate(list<ASC_Group_Specific_Pricing__c> grpSpecList,map<id,ASC_Group_Specific_Pricing__c> grpSpecNewMap,map<id,ASC_Group_Specific_Pricing__c> grpSpecOldMap)
    {
        try
        {   
            if(!GA_Util_lockRecords.isExecuting){
            GA_Util_lockRecords.isExecuting = true;         
            GA_Util_lockRecords.onUpdatelockorUnlockRecords(grpSpecList,grpSpecOldMap,DATASOURCE);            
            } 
            
            if(!ASC_GSPUpdateQLILastPriceDate.isExecuting){
            ASC_GSPUpdateQLILastPriceDate.isExecuting = true;         
            ASC_GSPUpdateQLILastPriceDate.updateLastPriceDate(grpSpecList,grpSpecOldMap);
            }
            
            ASC_PricingValidation.UpdateLastGSP(grpSpecList);
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERUPDATE);}
    }
    /*********************************************************************************************************************************************
    @Description: afterupdate() method 
    @Name : afterupdate
    @Param : list<ASC_Group_Specific_Pricing__c> grpSpecList
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void afterinsert(list<ASC_Group_Specific_Pricing__c> grpSpecList,map<id,ASC_Group_Specific_Pricing__c> grpSpecNewMap,map<id,ASC_Group_Specific_Pricing__c> grpSpecOldMap)
    {
        try
        {    if(!GA_Util_lockRecords.isExecuting){
              GA_Util_lockRecords.isExecuting = true;         
              GA_Util_lockRecords.onInsertlockRecords(grpSpecList,DATASOURCE);           
             }
             if(!ASC_GSPUpdateQLILastPriceDate.isExecuting){
              ASC_GSPUpdateQLILastPriceDate.isExecuting = true;         
              ASC_GSPUpdateQLILastPriceDate.updateLastPriceDate(grpSpecList,grpSpecOldMap); 
             }

             
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERINSERT);}
    } 
    /*********************************************************************************************************************************************
    @Description: afterupdate() method 
    @Name : afterupdate
    @Param : list<ASC_Group_Specific_Pricing__c> grpSpecList
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void beforeinsert(list<ASC_Group_Specific_Pricing__c> grpSpecList)
    {
        try
        {    
            ASC_PricingValidation.checkForDuplicateGSP(grpSpecList,null);
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERINSERT);}
    }         
    /*********************************************************************************************************************************************
    @Description: afterupdate() method 
    @Name : afterupdate
    @Param : list<ASC_Group_Specific_Pricing__c> grpSpecList
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void beforeUpdate(list<ASC_Group_Specific_Pricing__c> grpSpecList,map<id,ASC_Group_Specific_Pricing__c> grpSpecOldMap)
    {
        try
        {    
            ASC_PricingValidation.checkForDuplicateGSP(grpSpecList,grpSpecOldMap);
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERUPDATE);}
    } 
    
    
}