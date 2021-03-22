/*******************************************************************************************************************************
@Author 			: 	Dilip Junapala
@Name				: 	GA_ACC_AP05_CreateHandoverRecord
@CreatedDate		: 	15 - Dec 2017 
@Description		: 	GA_ACC_AP05_CreateHandoverTasks is for creating Handover Form Checklist record on change of prospect to Customer Account.
@version 			: 	1.0  
********************************************************************************************************************************/
public with sharing class GA_ACC_AP05_CreateHandoverRecord {
    public Static boolean isExecuting = false;
    public static final String ClsName  ='GA_ACC_AP05_CreateHandoverRecord';
    public static final String methodNmeToCreateHandover  ='createhandoverrec';
    public static final String ErrMsg = 'Failed to peform action :';
    public Static final String prospectRecType = 'Account - Prospect';
    public Static final string customerRecType = 'Account - Customer';
    public Static final string implmntMgr='Implementation Manager';
    public Static final Id prospectRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(prospectRecType).getRecordTypeId();
    public Static final Id customerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(customerRecType).getRecordTypeId();
    
    /*******************************************************************************************************************************
@Description		: 	createhandoverrec() method 
@Name 				: 	createhandoverrec
@Param 				: 	list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap
@Return 			: 	void
@throws Exception 	: 	N/A;
********************************************************************************************************************************/
    public static list<GA_AccountHandOver__c> createhandoverrec(list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap){	
        list<account> accListProcess=new list<account>();
        try{
            
            for(account acc:accList)
            {
                if(acc.ownerId !=system.label.GA_Informatica_User)
                {
                    accListProcess.add(acc);
                }
            }
            list<SObject> hndoverRecLst=new list<GA_AccountHandOver__c>();
            list<AccountTeamMember> actTmMemLst = [select AccountId, userId, TeamMemberRole from AccountTeamMember 
                                                   Where AccountId IN : accoldMap.keySet()  
                                                   AND TeamMemberRole = :implmntMgr Limit 5001];

            if(!accListProcess.isEmpty() && !actTmMemLst.isEmpty()){
                SObject hndoverRec = new GA_AccountHandOver__c();
                for(Account a : accListProcess){  
                    Id oldRecType = accoldMap.get(a.id).RecordTypeId;
                    if((oldRecType == prospectRecTpeId) && (a.RecordTypeId == customerRecTypeId)){
                        hndoverRec = new GA_AccountHandOver__c();
                        for(GA_Handover_Form_Checklist__mdt hndoverAccMap:([SELECT GA_Account_Field_Name__c, GA_Handover_Field_Name__c FROM GA_Handover_Form_Checklist__mdt limit 50])){
                            hndoverRec.put(hndoverAccMap.GA_Handover_Field_Name__c, a.get(hndoverAccMap.GA_Account_Field_Name__c));                
                        }
                        hndoverRecLst.add(hndoverRec);
                    }
                }
            }
            if(!hndoverRecLst.isEmpty()){
            database.insert(hndoverRecLst, true); 
            }
           return hndoverRecLst;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeToCreateHandover);
        }
        return null;
    }    
}