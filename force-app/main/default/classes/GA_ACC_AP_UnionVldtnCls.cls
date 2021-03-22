/*********************************************************************************************************************************************
@Author :IDC Offshore
@Name: GA_ACC_AP_UnionVldtnCls
@CreatedDate: 10 - Dec 2018
@Description: GA_ACC_AP_UnionVldtnCls class to validate Union Account changes
To show error for sales profile in case any account union field is updated apart from Plan Type
@version : 1.0  
**********************************************************************************************************************************************/
public with sharing class GA_ACC_AP_UnionVldtnCls {
    public static final string AccUnLbl='Account - Union';
    public static final string NoEditPermMsg='You don\'t have permission to edit : ';
    public static final string ClsName='GA_ACC_AP_UnionVldtnCls';
    public static final string methodNme='showValiderror';
    public static final string ErrMsg='Could not update Account Union record:';
/*********************************************************************************************************************************************
@Description: showValiderror() method 
@Name : showValiderror
@Param : list<account> accLst,map<id,account> accOldMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/     
    public static void showValiderror(list<account> accLst,map<id,account> accOldMap)
    {
        try
        {
            GA_Trigger_Functionality_By_Pass__c bypssErr=GA_Trigger_Functionality_By_Pass__c.getInstance();
            if(bypssErr.GA_Account_Union_Validation__c)
            {
                string accRecTypUnion=Schema.SObjectType.Account.getRecordTypeInfosByName().get(AccUnLbl).getRecordTypeId();
                list<user> usr=[select id, profile.Name from user where id=:userInfo.getUserId() Limit 1];  
                 list<string> errFlds=new list<string>();
                for(account acc:accLst)
                {                   
                    if(acc.RecordTypeId==accRecTypUnion)
                    {
                        account accOld=accOldMap.get(acc.Id);
                        for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.GA_Account_UnionValid.getFields()) {
                            if(accOld.get(f.getFieldPath()) != acc.get(f.getFieldPath()))
                            {
                                errFlds.add(f.label); 
                            }
                        }
                        if(errFlds.size()>0)
                        {
                            acc.addError(NoEditPermMsg+string.valueof(errFlds));
                        }
                    }
                    
                }      
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme); 
            accLst[0].adderror(ErrMsg);
        }
        
    }
}