/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_TPBH_AP02_RestrictTPBHCreation 
@CreatedDate: 29 - May 2019 
@Description: GA_TPBH_AP02_RestrictTPBHCreation class is for restricting Third Party Biller History record creation on Group Segment.
@version : 1.0  
********************************************************************************************************************************/

public  without sharing class GA_TPBH_AP02_RestrictTPBHCreation {
    Public static boolean isExecuting=false;
    public Static final string clsName  = 'GA_TPBH_AP02_RestrictTPBHCreation';
    public Static final string mtdRstrctThrdPrtyBilrHstryCrtn  = 'restrictThirdPrtyBilrHstryCrtn';
    public static final string intUser='Integration User';
    public static final string sysAdmin='System Administrator';
    public static final string errorMsg='You do not have privileges to perform this action. Please contact the System Administrator';
    /*******************************************************************************************************************************
@Description  :  restrictThirdPrtyBilrHstryCrtn 
@Name         :   restrictThirdPrtyBilrHstryCrtn
@Param        :   List<GA_Third_Party_Biller_History__c> tPBList
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    
    Public static void restrictThirdPrtyBilrHstryCrtn(List<GA_Third_Party_Biller_History__c> tPBList)  
    {
        try
        {
            String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
            if((profileName!=sysAdmin) && (profileName!=intUser))
            {
                Set<Id> gsIds = New Set<Id>();
                Set<Id> gsaIds = New Set<Id>();
                
                //Capturing Ids of records
                for(GA_Third_Party_Biller_History__c tpbh : tPBList)
                {
                    if(tpbh.GA_Group_Segment_Id__c != null)
                    {
                        gsIds.add(tpbh.GA_Group_Segment_Id__c);
                    }
                    if(gsIds.size()>0)
                    {
                        for(GA_Group_Segment__c gs : [select id,name,GA_Association_Id__c from GA_Group_Segment__c where Id IN :gsIds limit 1])
                        {
                            if(gs.GA_Association_Id__c != null)
                            {
                                gsaIds.add(gs.GA_Association_Id__c);  
                            }
                        }
                    }
                }
                
                //Restricting Third Party Biller History records creation for small group GS records.
                for(GA_Third_Party_Biller_History__c tpbh : tPBList)
                {
                    if(gsIds.size()>0)
                    {
                        for(GA_Group_Segment__c gs : [select id,name,GA_Association_Id__c,GA_TPB_Eligible__c from GA_Group_Segment__c where Id IN :gsIds limit 1])
                        { 
                            if(gsaIds.size()>0)
                            { 
                                for(Account assAccont : [select id,name,GA_Third_Party_Biller_Account_Id__c from Account where Id IN :gsaIds limit 1])
                                {
                                    if((gs.GA_Association_Id__c != null)&&(assAccont.GA_Third_Party_Biller_Account_Id__c != null))
                                    {
                                        tpbh.addError(errorMsg);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }            
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, mtdRstrctThrdPrtyBilrHstryCrtn);
        }
    }
    
}