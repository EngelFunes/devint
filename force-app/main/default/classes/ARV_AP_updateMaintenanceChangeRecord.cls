/*****************************************************************************************
Class Name   : ARV_AP_updateMaintenanceChangeRecord 
Date Created : 29-Oct-2020
Created By   : IDC Onshore
Description  :This is the class to update Maintenance Change record status to Submitted.
******************************************************************************************/
global class ARV_AP_updateMaintenanceChangeRecord implements vlocity_ins.VlocityOpenInterface {
    private static final String METHODNAME='updateGWC';
    private static final String METHODNAME2 = 'deleteGWC';
    private static final String SUBMITTED='Submitted';
    private static final String COMPLETED='Completed';
    public static final string UNIQUEBATCHID='UniqueBatchID';
    public static final String CMMA=',';
    public static final String EMPTYSTRING='';
    

/*****************************************************************************************
Description  :This method is to call the updateGWC method to execute status field update.
******************************************************************************************/
    global static Boolean invokeMethod(String methodName, Map<String,Object> input,Map<String,Object> output, Map<String,Object> options){           
                                    Boolean success = true;
                                    try{
                                        if (methodName == METHODNAME) 
                                            updateGWC(input,output,options);
                                        
                                        if(methodName.equals(METHODNAME2))
                                            deleteGWC(input,output,options);  
                                    }
                                    catch(Exception e){throw new AuraHandledException(e.getMessage()+e.getlinenumber());}
                                    return success;
                                }
/*****************************************************************************************
Description  :This method is to execute status field update.
******************************************************************************************/    
    public static void updateGWC(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)  {
        string acc = string.valueOf(input.get('ContextId'));
        system.debug('accId'+acc);
        String BatchId = (String)options.get(UNIQUEBATCHID);
        List <ARV_GWC_Transaction_Table__c>  gwcid = [select id,Account_ID__c,status__c,Is_common_control__c, RatingAreaFlag__c from ARV_GWC_Transaction_Table__c where Account_ID__c=:acc and GWC_Batch_ID__c=:BatchId and RecordType.name=:'Maintenance Change'and status__c =:'In Progress' ];
        List <ARV_GWC_Transaction_Table__c>  newgwcid = new List <ARV_GWC_Transaction_Table__c>();
        for(ARV_GWC_Transaction_Table__c gwc:gwcid){
            if (gwc.Is_common_control__c== true || gwc.RatingAreaFlag__c == true) 
                {
                gwc.Status__c= 'Under Review';
                }
            else {
                gwc.Status__c=SUBMITTED;
            }
                newgwcid.add(gwc);}
        if(newgwcid.size()>0)
        {
            database.update(newgwcid);
        }
    }
    
/*****************************************************************************************
Description  :This method is to delete GWC Transaction Records.
******************************************************************************************/    
    public static void deleteGWC(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)  {
        string acc = string.valueOf(input.get('ContextId'));
        String BatchId = (String)options.get(UNIQUEBATCHID);
        List <ARV_GWC_Transaction_Table__c>  gwcid = [select id,Account_ID__c,status__c,Is_common_control__c, RatingAreaFlag__c from ARV_GWC_Transaction_Table__c where Account_ID__c=:acc and GWC_Batch_ID__c=:BatchId and RecordType.name=:'Maintenance Change'/*and status__c =:'In Progress'*/ ];
        system.debug('list'+gwcid);
        if(gwcid.size()>0)
        {
            Database.DeleteResult[] DR_Dels = Database.delete(gwcid,false);
        }
    }
}