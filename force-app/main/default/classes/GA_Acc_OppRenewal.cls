/*****************************************************************************************
Class Name   : GA_Acc_OppRenewal
Date Created : 11/22/2017
Created By   : IDC Offshore
Description  : 1. This is the class for renewal opportunity creation.
******************************************************************************************/
public with sharing class GA_Acc_OppRenewal {
    
    public static final string opptycrteErrMsg = 'Could not create opportunity :';
    public static final string ClsName  ='GA_Acc_OppRenewal';
    public static final string methodNme  ='createoppty';
    public static final string methodNmedml  ='dmloprtions';
    public static final string CustomerRecType = 'Account - Customer';
    public static Id CustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CustomerRecType).getRecordTypeId();
    public static final string actQuery='select id,OwnerId,GA_IsOwnerActive__c,GA_Owner_Profile__c,Account_Status__c,GA_Renewal_Notification_Date__c,GA_Opportunity_Renewal_Date__c,(select id,createddate from opportunities order by createddate desc limit 1) from account ';
    public static final string actWhere=' where GA_Opportunity_Renewal_Date__c>=';
    public static final string actWhere1=' and recordtypeid in'; 
    public static final string actwhere2 = ' and GA_System_of_Record__c<>';
    public static final string actwhere3 = ' and Account_Status__c !=\'Inactive\'';
    public static final string smartString= 'SMART';
    public static final string actLimit=' limit 5001';
    public static final string oppName='Renewal Opportunity';
    public static final string oppStage='Created';
    public static final string oppType='Renewal';
    public static final string opptRecType='Opportunity - Renewals';
    public static final string profIntUser='Integration User';
    public static id opptRecId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(opptRecType).getRecordTypeId();
    public static final string tdy=string.valueof(date.today().addDays(-60)); //string.valueof(date.today());
    //public static final string tdy=string.valueof(date.today()); //string.valueof(date.today());
    public static integer oppRenewlLmt=Integer.valueof(system.label.GA_Opp_Renewal_Limit);
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    
    /****************************************************************************************************
Method Name : createoppty
Parameters  : N/A
Return type : Void
Description : This method is used to create the Opportunity record based on account renewal notification date.
******************************************************************************************************/
    public static void createoppty()
    {
        try{
            set<id> CurIdSet=new set<id>();
            CurIdSet.add(CustomerRecordTypeId);
            String ActRecIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);
            String Smart = GA_Util08_FilterProcessHelper.FltrString(smartString);
            
            list<account> accLst=GA_Util03_AccountDataAccessHelper.fetchAccountsMap(actQuery, actWhere+tdy+actwhere2+Smart+actWhere1+ActRecIdString+actwhere3, GA_Util03_AccountDataAccessHelper.BLANK, actLimit).values(); 
            system.debug('accLst---->'+JSON.serializepretty(accLst));

            if(accLst.size()<oppRenewlLmt)
            {
                dmloprtions(accLst);
            }
            
            else
            {
                string q=actQuery+actWhere+tdy+actwhere2+Smart+actWhere1+ActRecIdString+actwhere3;
                GA_Acc_OppRenewal_Batch uptcntAccoptRenwlBtch=new GA_Acc_OppRenewal_Batch(q);
                ID batchprocessid = Database.executeBatch(uptcntAccoptRenwlBtch,200);
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new ValidateException(opptycrteErrMsg,e);
        }
    }
    
    /****************************************************************************************************
Method Name : dmloprtions
Parameters  : list<account> accLst
Return type : Void
Description : This method is used to create the Opportunity/update account record based on account renewal notification date.
******************************************************************************************************/
    public static void dmloprtions(list<account> accLst)
    {
        try
        {
            integer currYr=date.today().year();
            
            list<account> accLstForOppty=new list<account>();
            list<account> accLstForCurOppty=new list<account>();
            list<account> accLstUpdateRenwNotf=new list<account>();
            
            system.debug('accLst---->'+JSON.serializepretty(accLst));
            
            for(account acc:accLst)
            {
                if(acc.opportunities.size()>0)
                {
                    if(currYr>acc.opportunities[0].createddate.year())
                    {
                        accLstForOppty.add(acc);
                    }
                    if(currYr==acc.opportunities[0].createddate.year())
                    { 
                        //Update Opportunity Renewal date for exisiting oppty for current year
                        //acc.GA_Opportunity_Renewal_Date__c=acc.GA_Opportunity_Renewal_Date__c.addYears(1);
                        //accLstForCurOppty.add(acc);
                    }
                }
                else
                {
                    accLstForOppty.add(acc);
                }
            }
            String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
            
            list<opportunity> opptyLst=new list<opportunity>();
            opportunity oppCrt=new opportunity();
            for(account acc:accLstForOppty)
            {
               if(acc.GA_IsOwnerActive__c && acc.GA_Owner_Profile__c <> profIntUser){
                    oppCrt=new opportunity();
                    oppCrt.AccountId=acc.id;
                    oppCrt.Name=oppName;
                    oppCrt.CloseDate=date.today();
                    oppCrt.StageName=OppStage;
                    oppCrt.RecordTypeId=opptRecId;
                    oppCrt.Type=OppType;
                    oppCrt.OwnerId = acc.ownerid;
                    oppCrt.CreatedById = acc.ownerid;
                    oppCrt.LastModifiedById = acc.ownerid;
                    oppCrt.System_Created__c = true;
                    opptyLst.add(oppCrt);
                }
                //Update Opportunity Renewal date
                //acc.GA_Opportunity_Renewal_Date__c = acc.GA_Opportunity_Renewal_Date__c.addYears(1);
                //accLstUpdateRenwNotf.add(acc);
            }
            system.debug('opptyLst--->'+JSON.serializepretty(opptyLst));
            
            if(accLst != null && accLst.size() > 0){
                for(Account acc : accLst){
                    if(acc.GA_Opportunity_Renewal_Date__c == system.today()){
                        acc.GA_Opportunity_Renewal_Date__c = acc.GA_Opportunity_Renewal_Date__c.addYears(1);
                        accLstUpdateRenwNotf.add(acc);
                    }
                }
            }
            
            
            if(accLstForCurOppty.size()>0){
                accLstUpdateRenwNotf.addAll(accLstForCurOppty);  
            }
            
            
            
            GA_Util10_OpportunityDataAccessHelper.dmlOnOpportunity(opptyLst, GA_Util10_OpportunityDataAccessHelper.INSERT_OPERATION);
            GA_Util03_AccountDataAccessHelper.dmlOnAccount(accLstUpdateRenwNotf, GA_Util03_AccountDataAccessHelper.UPDATE_OPERATION);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmedml);
            throw new ValidateException(opptycrteErrMsg,e);
        }
    }
}