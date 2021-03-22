/**********************************************************************************************************************************
    Class Name   : ARV_AP23_InProgressGWC
    Created Date : 29-Sept-2020
    Created By   : IDC Offshore
    Description  : It is used to fetch InProgress Maintenance Change (Save For Later)in the Lightning Component.
  *******************************************************************************************************************************/
	public with sharing class ARV_AP23_InProgressGWC{
    private static final String PROFLEQRY = 'select Id, Name from Profile';
    private static final String LIMITCLAUSE = ' Limit 50';
    private static final String SELECTQRY = System.Label.ARV_CL28_SavedOmniscriptsQry;
    private static final String INPROGRESS = 'In Progress';
    private static final String GWC = 'SmallGroupGWC';
    private static final String WHERECLAUSE1 =' where vlocity_ins__ObjectId__c =:paramId1 And vlocity_ins__Status__c=:paramName1 And Name like :paramName';
    private static final String WHERECLAUSE2 =' where Id=:paramId1';
    private static final String ORDERBYCLAUSE =' ORDER BY LastModifiedDate DESC';
    private static final string CLSNAME = 'ARV_AP22_InProgressMaintenanceChange';
    private static final string METHODNAME1 = 'getInProcessQuotesList';
    private static final string METHODNAME2 = 'getCurrentUserProfile';
    private static final string EXCEPSEPRATR = ':';
    private static final string ERRORMSG = 'There was an issue processing Saved Omniscripts';
/******************************************************************************************************************************
        Method Name : getInProcessContractList
        Parameters  : String accId 
        Return type : List<vlocity_ins__OmniScriptInstance__c>
        Description : This method is used to fetch the Maintenance Change record based on Account Id,OmniScriptType,SubType
*********************************************************************************************************************************/
    @AuraEnabled
    public static list<vlocity_ins__OmniScriptInstance__c> getInProcessContractList(String accId) {
        string qId;
        system.debug('AccountID'+accId);
        List <Quote> quoteID =[select Id from Quote where AccountId=:accId and Name like '%AQ%'];
        List<Id> quoteIDs = new List<Id>();
        for(Quote quoteIdList : quoteID)
        {
            quoteIDs.add(quoteIdList.id);
        }
        String strQId = String.valueOf(quoteIDs);
        system.debug('QuoteString'+strQId);
        system.debug('QuoteId'+quoteID);
      /*  ARV_AP07_QueryDataHelper.paramId1 ='0Q00U0000005f1PSAQ';
        ARV_AP07_QueryDataHelper.qtId = strQId;
        ARV_AP07_QueryDataHelper.paramName1 = INPROGRESS;
        ARV_AP07_QueryDataHelper.paramName = GWC;*/

        List < vlocity_ins__OmniScriptInstance__c >savedOmniscripts = new List < vlocity_ins__OmniScriptInstance__c > ();
        try { 
                /*ARV_AP07_QueryDataHelper.qtId = strQId;
                ARV_AP07_QueryDataHelper.paramName1 = INPROGRESS;
                ARV_AP07_QueryDataHelper.paramName = GWC;
                     for(Quote quoteIdList : quoteID)
                     {
                         ARV_AP07_QueryDataHelper.paramId1 =String.valueOf(quoteIdList.id);
                         system.debug('quoteIdList.id'+quoteIdList.id);
                         system.debug('paramID1'+ARV_AP07_QueryDataHelper.paramId1);
                   //savedOmniscripts =ARV_AP07_QueryDataHelper.getsObjects(SELECTQRY,WHERECLAUSE1,ORDERBYCLAUSE,LIMITCLAUSE);
                 	/*savedOmniscripts = [Select Id,Name,vlocity_ins__ObjectId__c,vlocity_ins__ObjectName__c,vlocity_ins__RelativeResumeLink__c,vlocity_ins__ResumeLink__c,vlocity_ins__Status__c ,
                                     LastModifiedBy.Name From vlocity_ins__OmniScriptInstance__c where vlocity_ins__ObjectId__c IN:quoteIDs And vlocity_ins__Status__c=:INPROGRESS 
                                     And Name like :GWC ORDER BY LastModifiedDate DESC Limit 50];
                  }*/
            savedOmniscripts = [Select Id,Name,vlocity_ins__ObjectId__c,vlocity_ins__ObjectName__c,vlocity_ins__RelativeResumeLink__c,vlocity_ins__ResumeLink__c,vlocity_ins__Status__c ,
                                     LastModifiedBy.Name From vlocity_ins__OmniScriptInstance__c where vlocity_ins__ObjectId__c IN:quoteIDs And vlocity_ins__Status__c=:INPROGRESS 
                                     And Name like :GWC ORDER BY LastModifiedDate DESC Limit 50];
            system.debug('savedOS++'+savedOmniscripts);
            }
        catch(Exception e) {throw new AuraHandledException(ERRORMSG+EXCEPSEPRATR+e.getMessage());                     
        }
        return savedOmniscripts;
    }

/***************************************************************************************************************************
            Method Name : getCurrentUserProfile
            Parameters  : None
            Return type : String
            Description : This method is used to fetch the current Logged In user Profile and returns Profile Name
****************************************************************************************************************************/
    @AuraEnabled
    public static String getCurrentUserProfile() {
        String profileName = '';
         ARV_AP07_QueryDataHelper.paramId1 =userinfo.getProfileId();
        try {
            List<Profile>profilelist = ARV_AP07_QueryDataHelper.getsObjects(PROFLEQRY,WHERECLAUSE2, null, LIMITCLAUSE);
			if (!profilelist.isEmpty()) {
                profileName = profilelist[0].Name;
            }
        }
        catch(Exception e) {throw new AuraHandledException(ERRORMSG+EXCEPSEPRATR+e.getMessage()); 
        }
        return profileName;
    }

}