/**
@Author : Prasant Kumar Satpathy
@Name: GA_ACTPLN01_RecList
@CreatedDate: 2 - Aug 2017 
@Description: GA_ACTPLN01_RecList class is viewing and creating action plan related list in Account record page.
@version : 1.0  
*/
public with sharing class GA_ACTPLN01_RecList {
    
    public static list<ActionPlanTmpWrapCls>ActionPlanTmpwrap =new list<ActionPlanTmpWrapCls>();
    public static final string lightningUrl='/one/one.app#/alohaRedirect/apex/ActionPlanCreation?refType=Account&refId=';
    public static final string tempId='&templateId=';
    public static final string actPlanErrMsg = 'Action Plans not retrived :';
    public static final string ClsName  ='GA_ACTPLN01_RecList';
    public static final string methodNmeactplnLst  ='actnplnLst';
    public static final string methodNmeactnplnTmpLst  ='actnplnTmpLst';
    public static final string actPlnQuery='select id,name,Description__c,CreatedBy.Name,CreatedDate,GA_Record_Url__c from ActionPlan__c ';
    public static final string actPlnWhere1='where name like ';
    public static final string actPlnWhere2=' and Account__c in ';
    public static final string actPlnLimit=' limit 20';
    public static final string actPlnTmpQuery='select id,Name,Description__c,GA_Record_Url__c from ActionPlanTemplate__c ';
   
    /**
@Description: ValidateException class 
@Name : Exception
@Param : None
@Return : 
@throws Exception : N/A;
*/ 
    public with sharing class ValidateException extends Exception {}
    /**
@Description: actnplnLst() method 
@Name : actnplnLst
@Param : string currentId,string type
@Return : List<ActionPlan__c>
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static List<ActionPlan__c> actnplnLst(string currentId,string type) {
        List<ActionPlan__c> apLst =  New List<ActionPlan__c> ();
        try{

            set<id> CurIdSet=new set<id>();
            CurIdSet.add(currentId);
            String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);
            string typeFiltr=GA_Util08_FilterProcessHelper.FltrString(type);
            apLst = GA_Util06_ActPlnDataAccessHelper.fetchActPlnLst(actPlnQuery, actPlnWhere1+typeFiltr+actPlnWhere2+ActIdString,GA_Util06_ActPlnDataAccessHelper.BLANK , actPlnLimit);
            return apLst;
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeactplnLst);
            throw new ValidateException(actPlanErrMsg, e); 
        }
       
    } 
    /**
@Description: actnplnTmpLst() method 
@Name : actnplnTmpLst
@Param : string type, string accId
@Return : List<ActionPlanTmpWrapCls>
@throws Exception : N/A;
*/
    @AuraEnabled
    public static List<ActionPlanTmpWrapCls> actnplnTmpLst(string type, string accId) {
        
        ActionPlanTmpwrap =new list<ActionPlanTmpWrapCls>();
        try{

            string typeFiltr=GA_Util08_FilterProcessHelper.FltrString(type);
            ActionPlanTmpWrapCls acpWrpCls;
            for(ActionPlanTemplate__c actPlntmplt:GA_Util07_ActPlnTmpDataAccessHelper.fetchActPlnTmpLst(actPlnTmpQuery, actPlnWhere1+typeFiltr,GA_Util06_ActPlnDataAccessHelper.BLANK , actPlnLimit))
            {
                acpWrpCls=new ActionPlanTmpWrapCls(actPlntmplt,lightningUrl+accId+tempId+actPlntmplt.id);
                ActionPlanTmpwrap.add(acpWrpCls);   
            }
            return ActionPlanTmpwrap;
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeactnplnTmpLst);
            throw new ValidateException(actPlanErrMsg, e); 
        }
        
    }  
    /*** 
wrapper class
*/
    public without sharing class ActionPlanTmpWrapCls
    {
        @AuraEnabled
        public ActionPlanTemplate__c actPlnTmp;
        @AuraEnabled
        public string url;
        public ActionPlanTmpWrapCls(ActionPlanTemplate__c actPlnTmpTemp,string urlTemp)
        {
            actPlnTmp=actPlnTmpTemp;
            url=urlTemp;
        }
    }
}