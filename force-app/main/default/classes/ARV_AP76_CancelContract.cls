/*****************************************************************************************
Class Name   : ARV_AP76_CancelContract
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status In progress
******************************************************************************************/
public without sharing class ARV_AP76_CancelContract {  
private static final String CONTRACTQUERY='select id,status from contract';
private static final String CONTRACTWHERECLAUSE=' where id=:paramId1';
private static final String CONTRACTANDCLAUSE=' where id=:paramId5 and status=:paramName1';
private static final String LIMIT1=' limit 1';
private static final String CANCELLED='Cancelled';
private static final String INPROGRESS='In Progress';
    @AuraEnabled
    /*****************************************************************************************
Method Name   : saveContract
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status In progress
******************************************************************************************/
    public static Contract saveContract(Id recordId){
    ARV_AP07_QueryDataHelper.paramId1=recordId;
        Contract con = [SELECT Id,Status FROM Contract WHERE Id=:recordId limit 1];
      /*  list<Contract>contractrec=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERECLAUSE,NULL,LIMIT1);
        Contract con= contractrec.get(0);
        */
        con.Status = CANCELLED;
        
        database.update(con);
        return con;
    }
    
    @AuraEnabled
    /*****************************************************************************************
Method Name   : getContract
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status In progress
******************************************************************************************/
    public static Contract getContract(Id recordId){
    Contract con;
    ARV_AP07_QueryDataHelper.paramName1=INPROGRESS;
    ARV_AP07_QueryDataHelper.paramId5 =recordId;
    list<Contract>contractrec=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTANDCLAUSE,NULL,LIMIT1);
    if(contractrec.size()>0)
         con= contractrec.get(0);
        
        
        return con;       
    }
}