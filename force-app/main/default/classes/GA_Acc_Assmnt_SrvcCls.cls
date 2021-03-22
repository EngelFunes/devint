/**
@Author : IDC offshore
@Name: GA_Acc_Assmnt_SrvcCls 
@CreatedDate: 05-Jan-2018  
@Description: GA_Acc_Assmnt_SrvcCls class to set Manager Email field for Email notification
@version : 1.0  
*/
public without sharing class GA_Acc_Assmnt_SrvcCls {
/*********************************************************************************************************************************************
@Description: updtAccAssmntInfo() method 
@Name : updtAccAssmntInfo
@Param : list<Account_Plan__c> accntAssmntLst
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 

    public static void updtAccAssmntInfo(list<Account_Plan__c> accntAssmntLst)
    {
        for(Account_Plan__c accsmnt:accntAssmntLst)
        {
            accsmnt.GA_Account_Owner_Manager_Email__c=accsmnt.GA_Account_Owner_Manager_Email_Frmla__c;
        }
    }
}