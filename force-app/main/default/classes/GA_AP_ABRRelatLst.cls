/**
@Author : Prasant Kumar Satpathy
@Name: GA_AP_ABRRelatLst 
@CreatedDate: 8 - June 2018 
@Description: GA_AP_ABRRelatLst class is viewing and creating Account Benifit Review list in Account record page.
@version : 1.0  
*/
public with sharing class GA_AP_ABRRelatLst {
    public static final string ABRERRMSG = 'ABR not retrived :';
    public static final string CLSNAME  ='GA_AP_ABRRelatLst';
    public static final string METHODNAMEABRTLST  ='abrLst';
    public static final string METHODNAMEACTREC  ='actRec';
    public static final string METHDNAMECREATEACCSS  ='createAccss';
    public static final string METHODNAMEDELACCS ='deleteAccss';
    public static final string ABRQURY='select id,name,GA_ABR_Type__c,GA_Status__c,createddate from GA_Account_Benefit_Review__c ';
    public static final string ABRWHERE='where GA_Account__c in';
    public static final string ABRORDBY='order by createddate desc';
    public static final string ABRLMT=' Limit 4';
    public static final string ACRQURY='select Id,Name,GA_Territory__r.GA_ABR_Specialist__c from account ';
    public static final string ACTWHERE='where id in'; 
    public static final string ACTLIMIT=' limit 1';
    public static final string SYSADMIN='System Administrator';
    public static final string ACTV= 'Active';
    public static final string PNDG= 'Pending';
    public static final string OPN= 'Open';
     public static final string DELETEXCEP= 'Unable to delete auth: ';
     public static final string EXCPMSG='Unable get ';
    /**Class to throw exception*/
    public with sharing class ValidateException extends Exception {}
/**
@Description: abrLstRecs() method 
@Name : abrLstRecs
@Param : string currentId
@Return : List<GA_Account_Benefit_Review__c>
@throws Exception : ValidateException;
*/ 
    @AuraEnabled
    public static List<GA_Account_Benefit_Review__c> abrLstRecs(string currentId) {
        List<GA_Account_Benefit_Review__c> abrtLst =  New List<GA_Account_Benefit_Review__c> ();
        try{
            set<id> curIdSet=new set<id>();
            curIdSet.add(currentId);
            String actIdString = GA_Util08_FilterProcessHelper.idSet(curIdSet);
            abrtLst = GA_Util_AbrDataAccessHelper.fetchAbrLst(ABRQURY, ABRWHERE + actIdString, ABRORDBY, ABRLMT);
            return abrtLst;    
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAMEABRTLST);
            throw new AuraHandledException(ABRERRMSG);
        }
        
    }
/**
@Description: actRec() method 
@Name : actRec
@Param : string currentId
@Return : Account
@throws Exception : ValidateException;
*/
    @AuraEnabled
    public static Account actRec(string currentId) {
        Account acc=new account();
        try{
            set<id> curIdSet=new set<id>();
            curIdSet.add(currentId);
            String actIdString = GA_Util08_FilterProcessHelper.idSet(curIdSet);            
            acc=GA_Util03_AccountDataAccessHelper.fetchAccountsMap(ACRQURY, ACTWHERE+actIdString, GA_Util03_AccountDataAccessHelper.BLANK, ACTLIMIT).values()[0];
            return acc;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAMEACTREC);
            throw new AuraHandledException(ABRERRMSG);
        }
        
    }
/**
@Description: createAccss() method 
@Name : createAccss
@Param : string currentId
@Return : boolean
@throws Exception : N/A ;
*/
    @AuraEnabled
    public static boolean createAccss(String currentId) {
   
        if(Schema.sObjectType.GA_Account_Benefit_Review__c.isCreateable())
        {
            
            String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
            if(profileName==SYSADMIN)
            {
                return true;  
            }
            if(!Approval.isLocked(currentId))
            {
                return true;
            }  
        }
        return false;
  
    }
/**
@Description: deleteAccss() method 
@Name : deleteAccss
@Param : string currentId
@Return : boolean
@throws Exception : N/A ;
*/
    @AuraEnabled
    public static boolean deleteAccss(String currentId) {
     
        if(Schema.sObjectType.GA_Account_Benefit_Review__c.isDeletable())
        {
            String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
            if(profileName==SYSADMIN)
            {
                return true;  
            }
            if(!Approval.isLocked(currentId))
            {
                 return true;
            }  
        }
        return false;
     
    }
/**
@Description: deleteData() method 
@Name : deleteData
@Param : string currentId
@Return : void
@throws Exception : ValidateException ;
*/ 
    @AuraEnabled
    public static void deleteData(String currentId) {
        try {
            if(Schema.sObjectType.GA_Account_Benefit_Review__c.isDeletable())
            {
                GA_Account_Benefit_Review__c abr=new GA_Account_Benefit_Review__c();
                abr.id=currentId;
                database.delete(abr);  
            }
            
        } 
        catch (Exception e) {
            //GA_LogExceptionCls.LogExcp(e, CLSNAME, deletegrpseg);
            throw new AuraHandledException(DELETEXCEP + e.getMessage());
        }
    }
/**
@Description: loadGroupSegmentsSize() method 
@Name : loadGroupSegmentsSize
@Param : string currentId
@Return : Integer
@throws Exception : ValidateException ;
*/   
    @AuraEnabled
    public static Integer loadGroupSegmentsSize(string currentId)
    {
        try{
            List<GA_Group_Segment__c> gsEmptyReturn = new List<GA_Group_Segment__c>();
            Map<id,GA_Group_Segment__c> gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c FROM GA_Group_Segment__c WHERE GA_Account__c = :currentId and (Status__c =: ACTV or Status__c =: PNDG)  Limit 5000]);
            
         /** Commented for Req 2328
         *       
       List<GA_WF_Group_Segment__c> wfPList = [select id, GA_Status__c, GA_Group_Segment_ID__c from GA_WF_Group_Segment__c Where GA_Group_Segment_ID__c In: gsMap.keySet() AND GA_Status__c='Open' AND GA_WF_Step_ID__c<>null];
            
           for(GA_WF_Group_Segment__c wfP: [select id, GA_Status__c, GA_Group_Segment_ID__c from GA_WF_Group_Segment__c Where GA_Group_Segment_ID__c In: gsMap.keySet() AND GA_Status__c=: OPN AND GA_WF_Step_ID__c<>null Limit 5000]){
                if(gsMap.containsKey(wfP.GA_Group_Segment_ID__c)){
                    gsMap.remove(wfP.GA_Group_Segment_ID__c);
                }
            } 	**/			
	
            Integer gsSize = gsMap.keyset().size();
            return gsSize;
        }
        catch (Exception e) {
            throw new AuraHandledException(EXCPMSG + e.getMessage());
        }
    }
}