/***************************************************************************************************************************

***************************************************************************************************************************/
global class RemoveDuplicateExtApp_Batch implements Database.Batchable<sObject>
{
    
    String query;
    global RemoveDuplicateExtApp_Batch()
    {
        this.query = 'SELECT Id FROM GA_Group_Segment__c WHERE Network__c = \'MOS\' and Status__c = \'Active\' ';
    }
    global RemoveDuplicateExtApp_Batch(String query)
    {
        this.query = query;
        //query=gsQry;
    }
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(this.query ); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_Group_Segment__c> scope)
    {   
        list<GA_Group_Segment__c> gsList = new list<GA_Group_Segment__c>();
        List<GA_External_Appeal__c> exta = new List<GA_External_Appeal__c>();
        set<ID> gsIDs = new set<ID>();
        
        for(GA_Group_Segment__c gseg : scope){
            if(String.isNotBlank(gseg.id))
            {
                gsIDs.add(gseg.id);
            }
        }
        
        if(gsIDs.size()>0)
        {
            gsList = [select name, id  from GA_Group_Segment__c where ID IN:gsIDs and Network__c = 'MOS' and Status__c = 'Active' ];
            List<GA_External_Appeal__c> myexTapp = new List<GA_External_Appeal__c>();
            
            for (GA_Group_Segment__c gseg2 : gsList)
            {
                List<GA_External_Appeal__c> extaListYes = [select name, id, GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =:gseg2.Id AND GA_NHR_Status__c = 'Grandfather - Yes' and GA_NHR_End_Date__c = NULL and GA_Group_Segment_Id__c!= NULL order by GA_NHR_EFF_Date__c desc Limit 1];
                List<GA_External_Appeal__c> extaListNo = [select name, id, GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =:gseg2.Id AND GA_NHR_Status__c = 'Grandfather - No' and GA_NHR_End_Date__c = NULL and GA_Group_Segment_Id__c!= NULL order by GA_NHR_EFF_Date__c desc Limit 1];
                List<GA_External_Appeal__c> extaListRetiree = [select name, id, GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =:gseg2.Id AND GA_NHR_Status__c = 'Retiree Opt Out' and GA_NHR_End_Date__c = NULL and GA_Group_Segment_Id__c!= NULL order by GA_NHR_EFF_Date__c desc Limit 1];
                
                /* get the Max Value of the Retiree Opt and Put a check on it*/
                if (extaListRetiree.size() > 0  ){
                    extaListRetiree[0].Max_Date_Unique_Value__c = true;
                    myexTapp.add(extaListRetiree[0]);
                }
                
                /* get the Max Value of the GrandFather-Yes and Put a check on it*/
                else if(extaListYes.size() >  0  ){
                    extaListYes[0].Max_Date_Unique_Value__c = true;
                    myexTapp.add(extaListYes[0]);
                }
                /* get the Max Value of the GrandFather-No and Put a check on it*/
                else if (extaListNo.size() > 0 ){
                    extaListNo[0].Max_Date_Unique_Value__c = true;
                    myexTapp.add(extaListNo[0]);
                }                   
            }
            update myexTapp;
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}