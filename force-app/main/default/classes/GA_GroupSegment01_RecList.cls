public with sharing class GA_GroupSegment01_RecList {
    public static final string grpSegmntErrMsg = 'Group Segment not retrived :';
    public static final string actRecErrMsg = 'Account or Physical city or Mailing city not retrived :';
    public static final string ClsName  ='GA_GroupSegment01_RecList';
    public static final string methodNmeLst  ='gSgmtLst';
    public static final string methodNmeactRec  ='actRec'; 
    public static final string methodNmeCityRec = 'CityRec';
    public static final string gSgmtQuery='select id,name, GA_Record_Url__c, GA_Group_Name__c, Status__c, GA_MTV_Group__c, GA_Group_Effective_Date__c, GA_Rate_Renewal_Date__c,'+
        'GA_Sales_Office_Code__c, GA_Regional_Office_Code__c,GA_Retention_Rep_Name__c , GA_Territory__c, '+
        'GA_Billing_Contact_Id__c, GA_Administrative_Contact_Id__c, GA_Federal_Tax_ID_Number__c, GA_Physical_Address_1__c, '+
        'GA_Physical_City__c, GA_Physical_State__c, GA_Physical_County_Id__c, GA_Physical_Zip__c, GA_Mailing_Address_1__c, '+
        'GA_Mailing_City__c, GA_Mailing_State__c, GA_Mailing_County_Id__c,GA_Mailing_Zip__c,GA_Account__r.GA_GroupSegment_Count__c from GA_Group_Segment__c ';
    
    public static final string gSgmtWhere='where GA_Account__c in';
    public static final string gSegOrdrBy='order by createddate desc';
    public static final string gsLstLimit=' Limit 3';
    public static final string actQuery='select Id, Name, GA_Renewal_Date__c, GA_Territory__r.GA_Sales_Office_Code__c, GA_Territory__r.GA_Regional_Office_Code__c,'+
        'OwnerId, GA_Territory__c, GA_AgentName__c, GA_Principal_Admin__c, Federal_Tax_ID__c, ShippingStreet, ShippingCity, '+
        'ShippingStateCode, GA_Physical_County_Id__c, ShippingPostalCode, BillingStreet, BillingCity, BillingStateCode, '+
        'GA_Mailing_County_id__c, BillingPostalCode from account ';
    public static final string gsBilingConQuery='select id, GA_Billing_Contact_Id__c from GA_Group_Segment__c ';
    public static final string gsBilingConWhere='where GA_Billing_Contact_Id__c !=null AND GA_Account__c in';
    public static final string gsAdminConQuery='select id, GA_Administrative_Contact_Id__c from GA_Group_Segment__c ';
    public static final string gsAdminConWhere='where GA_Administrative_Contact_Id__c !=null AND GA_Account__c in';
    public static final string gsConLimit=' Limit 01';
    public static final string actWhere='where id in'; 
    public static final string actLimit=' limit 1';
    /**Class to throw exception*/
    public with sharing class ValidateException extends Exception {}
    /**
@Description: gSgmtLst() method 
@Name : gSgmtLst
@Param : string currentId
@Return : List<GA_Group_Segment__c>
@throws Exception : ValidateException;
*/ 
    @AuraEnabled
    public static List<GA_Group_Segment__c> gSgmtLst(string currentId) {
        List<GA_Group_Segment__c> grpSgmntLst =  New List<GA_Group_Segment__c> ();
        try{
            //List<GA_Group_Segment__c> grpSgmntFinLst =  New List<GA_Group_Segment__c> ();
            set<id> CurIdSet=new set<id>();
            CurIdSet.add(currentId);
            String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);
            grpSgmntLst = GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(gSgmtQuery, gSgmtWhere + ActIdString, gSegOrdrBy, gsLstLimit).values();
            
            /*if(!grpSgmntLst.isEmpty())
            {
                grpSgmntFinLst= grpSgmntLst;  
            }
            return grpSgmntFinLst;*/
            return grpSgmntLst;
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeLst);
            throw new AuraHandledException(grpSegmntErrMsg);
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
    public static acctaddrswrp actRec(string currentId) {
        Account acc=new account();
        Id bilConGs;
        Id adminConGs;
        try{
            set<id> CurIdSet=new set<id>();
            CurIdSet.add(currentId);
            String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);            
            acc=GA_Util03_AccountDataAccessHelper.fetchAccountsMap(actQuery, actWhere+ActIdString, GA_Util03_AccountDataAccessHelper.BLANK, actLimit).values()[0];
            List<GA_Group_Segment__c> bilGsList=GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(gsBilingConQuery, gsBilingConWhere + ActIdString, GA_Util17_GrpSgmntDataAccesHelper.BLANK, gsConLimit).values();
            List<GA_Group_Segment__c> admGSList=GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(gsAdminConQuery, gsAdminConWhere + ActIdString, GA_Util17_GrpSgmntDataAccesHelper.BLANK, gsConLimit).values();
            if(!bilGsList.isEmpty()){
                bilConGs=bilGsList[0].GA_Billing_Contact_Id__c;
            }
            if(!admGSList.isEmpty()){
                adminConGs=admGSList[0].GA_Administrative_Contact_Id__c;
            }
            acctaddrswrp accsddwrpRec=new acctaddrswrp();
            accsddwrpRec.accRec=acc;
            accsddwrpRec.physicalCityVal=CityRec(acc.ShippingCity);
            accsddwrpRec.mailingCityVal=CityRec(acc.BillingCity);
            accsddwrpRec.billingCont=bilConGs;
            accsddwrpRec.adminCont=adminConGs;
            return accsddwrpRec;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeactRec);
            throw new AuraHandledException(actRecErrMsg);
        }
    }
    /**
@Description: CityRec() method 
@Name : CityRec
@Param : string City
@Return : Account
@throws Exception : ValidateException;
*/
    @AuraEnabled
    public static Id CityRec(string City) {
        
        try{
            ID CityId;
            if(string.isNotEmpty(City)){
                List<GA_City_Code__c> cList=[select id, name from GA_City_Code__c Where Name =: City Limit 1];
                if(!cList.isEmpty()){
                    CityId = cList[0].id;
                }
            }
            if(CityId!=null){
                return CityId;
            }
            else{
                return null;
            } 
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeCityRec);
            throw new AuraHandledException(grpSegmntErrMsg);
        }
    }
    
    @AuraEnabled
    public static boolean createAccss(String currentId) {
         if(Schema.sObjectType.GA_Group_Segment__c.isCreateable())
         {

             String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
             if(profileName=='System Administrator')
             {
               return true;  
             }
             if(!Approval.isLocked(currentId))
             return true;
         }
      return false;
    }
       @AuraEnabled
    public static boolean editAccss(String currentId) {
         if(Schema.sObjectType.GA_Group_Segment__c.isUpdateable())
         {

             String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
             if(profileName=='System Administrator')
             {
               return true;  
             }
             if(!Approval.isLocked(currentId))
             return true;
         }
      return false;
    }
        @AuraEnabled
    public static boolean deleteAccss(String currentId) {
         if(Schema.sObjectType.GA_Group_Segment__c.isDeletable())
         {
             String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
             if(profileName=='System Administrator')
             {
               return true;  
             }
             if(!Approval.isLocked(currentId))
             return true;
         }
      return false;
    }
    @AuraEnabled
    public static void deleteData(String currentId) {
        try {
            if(Schema.sObjectType.GA_Group_Segment__c.isDeletable())
            {
                GA_Group_Segment__c gs=new GA_Group_Segment__c();
                gs.id=currentId;
                delete gs;  
            }
          } 
        catch (Exception e) {
            throw new AuraHandledException('Unable to delete auth: ' + e.getMessage());
        }
    }
    public class acctaddrswrp{
        @AuraEnabled
        public account accRec;
        @AuraEnabled
        public id mailingCityVal;
        @AuraEnabled
        public id physicalCityVal;
        @AuraEnabled
        public id billingCont;
        @AuraEnabled
        public id adminCont;
        
    }
}