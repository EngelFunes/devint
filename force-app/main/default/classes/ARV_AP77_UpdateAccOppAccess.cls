/*****************************************************************************************
Class Name   : ARV_AP77_UpdateAccOppAccess 
Date Created : 22-Jan-2020
Created By   : IDC Offshore.
Description  : This Class is used to give additional EDIT access to opportunity in Account team members. 
******************************************************************************************/
global without sharing class ARV_AP77_UpdateAccOppAccess implements vlocity_ins.VlocityOpenInterface{
    private static final string INVOKE_METHOD  = 'invokeMethod';    
    private static final String ERRORMSG=  '';
    private static final String METHODNAME='updateOppAccess';
    private static final String CLSNAME='AP77';
    private static final String EDITACCESS='Edit';
    private static final String ACCTID='accountId';
    private static final String USERID='userId';
    private static final string ATQUERY = 'select OpportunityAccessLevel from AccountTeamMember';
    private static final string ATWHERE = ' where accountid = :paramId1 and OpportunityAccessLevel != :paramName1 and createdbyid = :paramId5';
    private static final string ORDERBYCLAUSE = '';
    private static final string LIMITCLAUSE = ' Limit 200';
/*************************************************************
Method Name   : invokeMethod 
Date Created : 22-Jan-2020
Created By   : IDC Offshore
Description  : this method is used to invoke the updateOppAccess method 
*************************************************************/
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, 
                                Map<String,Object> outMap, Map<String,Object> options)
    {  
        try{    
            if( methodName == METHODNAME) {
                updateOppAccess(inputMap, outMap, options);                
            }
        }catch(Exception e){ 
            //GA_LogExceptionCls.LogExcp(e, CLSNAME, INVOKE_METHOD  );
            //system.debug('*****'+e.getLineNumber()+':::'+e.getMessage());
            throw new AuraHandledException(ERRORMSG+e.getMessage());
        }
        return true;        
    }    
/*************************************************************
Method Name   : getMetadataLabels 
Date Created : 18-June-2019
Created By   : IDC Offshore
Description  : This method fetches all the Account team members and update the OpportunityAccess to Edit.
*****************************************************************/
    public static void updateOppAccess(Map<String,Object> inputMap,
                                       Map<String,Object> outMap,Map<String,Object> options){
        String accid = string.valueof(inputMap.get(ACCTID));
        String usrId = string.valueof(inputMap.get(USERID));
        system.debug('usrId::::'+usrId);
        ARV_AP07_QueryDataHelper.paramId1 = accid;
        ARV_AP07_QueryDataHelper.paramId5 = usrId;
        ARV_AP07_QueryDataHelper.paramName1 = EDITACCESS;
        list<AccountTeamMember> aTeamlst = ARV_AP07_QueryDataHelper.getsObjects(ATQUERY,
                                                                                ATWHERE,ORDERBYCLAUSE,LIMITCLAUSE);
        system.debug('access::'+aTeamlst);                                                                        
        for(AccountTeamMember act : aTeamlst){
            act.OpportunityAccessLevel = EDITACCESS;
            act.AccountAccessLevel = EDITACCESS;  // Added this change since account access is not upgraded to Read/Write after Upgrade
        }
        Database.update(aTeamlst);
    }
}