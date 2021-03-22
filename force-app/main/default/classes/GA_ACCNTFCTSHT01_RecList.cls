/**
@Author : Prasant Kumar Satpathy
@Name: GA_ACCNTFCTSHT01_RecList
@CreatedDate: 21 - Aug 2017 
@Description: GA_ACCNTFCTSHT01_RecList class is viewing and creating Account Factsheet related list in Account record page.
@version : 1.0  
*/
public with sharing class GA_ACCNTFCTSHT01_RecList {
    public static final string actPlanErrMsg = 'Account Factsheet not retrived :';
    public static final string ClsName  ='GA_ACCNTFCTSHT01_RecList';
    public static final string methodNmeactFctshtLst  ='actfctshtLst';
    public static final string methodNmeactRec  ='actRec';
    public static final string actFctQuery='select id,name,Record_Url_Edit__c,GA_RenewalMonth__c,GA_Industry__c,GA_RenewalDate__c,GA_OriginalEffectiveDate__c,GA_Record_Url__c from GA_Account_Fact_Sheet__c ';
    public static final string actFctWhere='where GA_Account__c in';
    public static final string actFctOrdrBy='order by createddate desc';
    public static final string actFctLimit=' Limit 3';
    public static final string actQuery='select Id,Description,Servicing_Agent__r.Account_Name__c, Medicare_Retiree_Coverage__c, Agency_Association__c,Agency_Association__r.name,GA_Decision_Maker__r.Title,GA_CEO__r.name,GA_Decision_Maker__c,GA_Decision_Maker__r.GA_Contact_Role__c,GA_Decision_Maker__r.phone,GA_Decision_Maker__r.email,GA_Original_Enrollment_Date__c,GA_Total_Eligible__c,Renewal_Month__c,Total_Members__c,GA_Total_Contract_Count__c,Industry,(select Id,GA_StrengthsAdditionalDetail__c,GA_WeaknessesAdditionalDetail__c,GA_OpportunitiesAdditionalDetail__c,GA_ThreatsAdditionalDetail__c from Account_Plans__r order by createddate desc limit 1),name,CID__c,NumberOfEmployees,GA_Total_Medical_Contracts__c,GA_LinesOfBusiness__c,GA_AgentName__c,GA_AgentName__r.Phone,GA_AgentName__r.Email,GA_StrengthsCategory__c,GA_WeaknessCategory__c,GA_OpportunitiesCategory__c,GA_ThreatsCategory__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,(select Id from Contacts) from account ';
    public static final string actWhere='where id in'; 
    public static final string actLimit=' limit 1';
    /**Class to throw exception*/
    public with sharing class ValidateException extends Exception {}
    /**
@Description: actfctshtLst() method 
@Name : actfctshtLst
@Param : string currentId
@Return : List<GA_Account_Fact_Sheet__c>
@throws Exception : ValidateException;
*/ 
    @AuraEnabled
    public static Map<String,Object> actfctshtLst(string currentId) {
		Map<String,Object> mapofaccount = new Map<String,object>();
        List<GA_Account_Fact_Sheet__c> acntfctshtLst =  New List<GA_Account_Fact_Sheet__c> ();
        try{
            set<id> CurIdSet=new set<id>();
            CurIdSet.add(currentId);
            String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);            
            acntfctshtLst = GA_Util05_AcntFctShtDataAccessHelper.fetchAcntFcstShtLst(actFctQuery, actFctWhere + ActIdString, actFctOrdrBy, actFctLimit);
            mapofaccount.put('acntfct',acntfctshtLst);
            List <GA_AOR__c> aor= [select id, GA_Contact_Id__c, GA_Account_Id__c from GA_AOR__c where GA_Account_Id__c =: currentId AND GA_Service_End_Date__c > today limit 1];
            if(aor != null && aor.size()>0){
                List<contact> con = [select id,Email,Phone,Title,GA_Contact_Role__c from contact where id =: aor[0].GA_Contact_Id__c limit 1];
                if(con != null && con.size()>0){
                	mapofaccount.put('AOR_Contact',con[0]);
                }
            }
           
			return mapofaccount;    
        }
        catch(Exception e){
          system.debug(e.getLineNumber());  
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeactFctshtLst);
            throw new AuraHandledException(actPlanErrMsg);
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
            set<id> CurIdSet=new set<id>();
            CurIdSet.add(currentId);
            String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);            
            acc=GA_Util03_AccountDataAccessHelper.fetchAccountsMap(actQuery, actWhere+ActIdString, GA_Util03_AccountDataAccessHelper.BLANK, actLimit).values()[0];
            system.debug(acc.Agency_Association__c);
            return acc;
        }
        catch(Exception e){
            system.debug('exception' +e);
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeactRec);
            throw new AuraHandledException(actPlanErrMsg);
        }
        
    }
}