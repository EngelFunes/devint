/******************************************************************************************************************************************
@Author : Offshore
@Name: ASC_GSPStagingTriggerHandler
@CreatedDate: 15 - May - 2020 
@Description: 
@version : 1.0  
*****************************************************************************************************************************************/

public class ASC_GSPStagingTriggerHandler {
    
    private static final string CLSNAME  ='ASC_GSPStagingTriggerHandler';
    private static final string METHODNMEAFTERINSERT  ='afterinsert';
    private static final string METHODNMEBEFOREINSERT  ='beforeinsert';
    private static final string METHODNMEAFTERUPDATE='afterupdate';
    private static final String DATASOURCE = 'ASC_Data_Source__c';
    private static boolean isExecuting = false;
    
    /*********************************************************************************************************************************************
    @Description: 
    @Name : afterinsert
    @Param : list<ASC_Group_Specific_Pricing_Staging__c> grpSpecList
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void afterinsert(List<ASC_Group_Specific_Pricing_Staging__c> gspsList,Map<id,ASC_Group_Specific_Pricing_Staging__c> gspsNewMap,Map<id,ASC_Group_Specific_Pricing_Staging__c> gspsOldMap)
    {
        try
        {   
           /*US-2852 -Added By Dinesh -  after insert - Group Specific Pricing Staging object that will trasform the data from this object and populate 
           it in Group Specific Pricing Object. */        
           ASC_GSPStagingTriggerHelper.createUpdateGSPRecords(gspsList);           
        } 

        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERINSERT);}
    } 
    /*********************************************************************************************************************************************
    @Description:
    @Name : beforeinsert
    @Param : list<ASC_Group_Specific_Pricing_Staging__c> gspsList
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void beforeinsert(list<ASC_Group_Specific_Pricing_Staging__c> gspsList)
    {
        try
        {               
            /*US-2852 -Added By Dinesh -  before insert - validate the data on Group Specific Pricing Staging object that will coming from HiPS System */
            ASC_GSPStagingTriggerHelper.validateGSPStagingRecords(gspsList);
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREINSERT);}
    }     
}