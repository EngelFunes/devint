/**
@Author : Dinesh
@Name: ASC_GSPDeleteFlagUpdate
@CreatedDate:  06-29-2020
@Description: ASC_GSPDeleteFlagUpdate class is used to update the Inactive flag using lightning Quick Action button i.e., Activate/Deactivate button, and this Inactive check flag is a read only 
              field on the Page Layout and can be updated only using Quick Action.              
@version : 1.0
@US# :US-3112
*/
public without sharing class ASC_GSPDeleteFlagUpdate {
    
    private static final string CLASSNAME ='ASC_GSPDeleteFlagUpdate';
    private static final string METHODNAMEVERIFYGSP ='verifyGSPdeleteflag';
    private static final string METHODNAMEUPDATEGSP ='updateGSPdeleteflag';
    private static final string ERRMSG = system.label.ASC_GSP_Update_Delete_Flag_Error;
    private static final string DELETESUCCESSMSG = system.label.ASC_DeleteConfirmationMsg;
    private static final string UNDELETESUCCESSMSG = system.label.ASC_UndeleteConfirmationMsg;
    private static final string DUPLICATEERRMSG = system.label.ASC_GSPDuplicateCheck;
    private static final string STR_EMPTY ='';
    private static final List<String> PROFILENAMES = new List<String>{'System Administrator','Integration User'};
    private static final List<String> PERMISSIONSETNAMES = new List<String>{'ASC_Risk_Based_Pricing'};
    private static final string INSUFFMSG = system.label.GA_PostIsuffErrMsg; 

    /*******************************************************************************************************************************
    @Description        :   This method is used to verify the GSP record whether the Inactive flag is checked and then return the message in the lightning component
    @Name               :   verifyGSPdeleteflag
    @Param              :   string gspId
    @Return             :   String
    @throws Exception   :   Aura Exception    
    ********************************************************************************************************************************/           
    @AuraEnabled
    public static string verifyGSPdeleteflag(string gspId)
    {            
        String result = STR_EMPTY;
        try{                        
        List<PermissionSetAssignment> userpermissionSet = [select PermissionSet.Name from PermissionSetAssignment 
                                                   where AssigneeId =:UserInfo.getUserId() 
                                                   AND PermissionSet.Name IN:PERMISSIONSETNAMES
                                                   Limit :UTIL_SLB.retrieveQueryLimitValue()];
        Id profileId=userinfo.getProfileId();    
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        
            if(PROFILENAMES.Contains(profileName) || !userpermissionSet.isEmpty())
            {    
                ASC_Group_Specific_Pricing__c gsprecord =[select id,ASC_Group__c,ASC_Carrier__c,                                                       
                                                         ASC_Effective_Date__c,ASC_Effective_End_Date__c,
                                                         ASC_LOB__c,ASC_Product__c,ASC_Sub_Segment__c,ASC_Deleted__c 
                                                         from ASC_Group_Specific_Pricing__c where id =:gspId LIMIT 1];
                
                List<ASC_Group_Specific_Pricing__c> existingUniqueGSPRec = [select Id,ASC_Group__c,ASC_Carrier__c,ASC_Effective_Date__c,
                           ASC_Effective_End_Date__c,ASC_LOB__c,ASC_Product__c,ASC_Sub_Segment__c from ASC_Group_Specific_Pricing__c 
                           Where ASC_Group__c =:gsprecord.ASC_Group__c
                           AND ASC_Carrier__c =:gsprecord.ASC_Carrier__c
                           AND ASC_Effective_Date__c =:gsprecord.ASC_Effective_Date__c 
                           AND ASC_Effective_End_Date__c =:gsprecord.ASC_Effective_End_Date__c
                           AND ASC_LOB__c =:gsprecord.ASC_LOB__c
                           AND ASC_Product__c =:gsprecord.ASC_Product__c
                           AND ASC_Sub_Segment__c =:gsprecord.ASC_Sub_Segment__c
                           AND Id !=:gsprecord.Id
                           AND ASC_Deleted__c = false
                           Limit :UTIL_SLB.retrieveQueryLimitValue()];
                    
                    if(gsprecord.ASC_Deleted__c && !existingUniqueGSPRec.isEmpty()){  
                        result = DUPLICATEERRMSG;
                    }                     
                    else if(gsprecord.ASC_Deleted__c){                        
                        gsprecord.ASC_Deleted__c=false;                
                        result = UNDELETESUCCESSMSG;
                    }
                    else{
                        gsprecord.ASC_Deleted__c=true;                
                        result = DELETESUCCESSMSG;
                    }                
            }
            else{
               result = INSUFFMSG;
            }                   
        }        
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAMEVERIFYGSP); throw new AuraHandledException(ERRMSG); 
        } 
        return result;
    }
    
    /*******************************************************************************************************************************
    @Description        :   This method is used to update the Inactive checkbox in the GSP record.
    @Name               :   verifyGSPdeleteflag
    @Param              :   string gspId
    @Return             :   String
    @throws Exception   :   Aura Exception    
    ********************************************************************************************************************************/           
    @AuraEnabled
    public static string updateGSPdeleteflag(string gspId)
    {
        String result = STR_EMPTY;
        try{      
           if(String.isNotBlank(gspId)){
            ASC_Group_Specific_Pricing__c gsprecord =[select id,ASC_Deleted__c from ASC_Group_Specific_Pricing__c
                                                      where id =:gspId LIMIT 1];
            
            if(gsprecord.ASC_Deleted__c){
                gsprecord.ASC_Deleted__c=false;                
                database.update(gsprecord); 
                result = UNDELETESUCCESSMSG;               
            }
            else{
                gsprecord.ASC_Deleted__c=true;                
                database.update(gsprecord);
                result = DELETESUCCESSMSG;
            }
           }           
        }        
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAMEUPDATEGSP); throw new AuraHandledException(ERRMSG);             
        } 
        return result;
    }
}