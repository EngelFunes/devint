/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_ACC_AccStatusWFVldtnCls 
@CreatedDate: 22 - Jan 2019 
@Description: GA_ACC_AccStatusWFVldtnCls class to validate users from changing Account status to Inactive if the account is in an open workflow.
@version : 1.0  
********************************************************************************************************************************/
public with sharing  class GA_ACC_AccStatusWFVldtnCls {
    public static final string ClsName='GA_ACC_AccStatusWFVldtnCls';
    public static final string methodNme='valdteInctvStatus';
    public static final string accCustRecTyp =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
    public static final string accPrspctRecType =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
    public static final string NoUpdtPermMsg=System.label.GA_OpenWFMessage;
    public static final string inactiveStr =  'Inactive';
    public static final string accObjApiNm = 'GA_Account__c';
    public static final string opnWf = 'OpenWF';
    public static final string opnSts = 'Open';
    /*******************************************************************************************************************************
@Description  : valdteInctvStatus 
@Name         : valdteInctvStatus
@Param        : List<Account> accList,Map<ID,Account> accOldMap
@Return       : void
@throws Exception : N/A;
********************************************************************************************************************************/     
    public static void valdteInctvStatus(List<Account> accList,Map<ID,Account> accOldMap){
        try{
            list<id> accIdsToprcss=new list<id>();
            map<id,integer> accWFOpn=new map<id,integer>();
            boolean isChnge=false;
            for(Account objAcc : accList){
                String recTypeId = objAcc.RecordTypeId;
                String accsts = objAcc.Account_Status__c;
                if(accOldMap !=null){
                    Account accOld=accOldMap.get(objAcc.Id);
                    if(accOld.Account_Status__c != objAcc.Account_Status__c){
                        isChnge=true;
                    } 
                }
                else{
                    isChnge=true;
                }
                if((  recTypeId.equalsIgnoreCase(accCustRecTyp)  ||  recTypeId.equalsIgnoreCase(accPrspctRecType)  ) 
                   && accsts.endsWithIgnoreCase(inactiveStr)  && isChnge){
                       accIdsToprcss.add(objAcc.Id);
                   } 
            }
            if(!accIdsToprcss.isEmpty()){
                list<aggregateResult> wrkflwLst=[select GA_Account__c,count(Id) OpenWF from GA_WF_Workflow__c where GA_Account__c in:accIdsToprcss 
                                                 and (GA_Status__c=: opnSts) group by GA_Account__c  limit 2000];     
                for(aggregateResult agRst:wrkflwLst)
                {
                    accWFOpn.put(string.valueof(agRst.get(accObjApiNm)),integer.valueof(agRst.get(opnWf)));   
                }
                for(Account objAcc : accList){
                    
                    if(accWFOpn.get(objAcc.Id)>0){
                        objAcc.addError(NoUpdtPermMsg);
                    }
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme); 
        }
    }
}