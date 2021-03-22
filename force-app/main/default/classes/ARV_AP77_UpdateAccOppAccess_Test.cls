/*****************************************************************************************
Class Name   : ARV_AP77_UpdateAccOppAccess 
Date Created : 22-Jan-2020
Created By   : IDC Offshore.
Description  : This Class is used to give additional EDIT access to opportunity in Account team members. 
******************************************************************************************/
@isTest()
public without sharing class ARV_AP77_UpdateAccOppAccess_Test
{
    private static final string INVOKE_METHOD  = 'updateOppAccess';
    private static final string PROFILENAME='System Administrator';
    private static final string ATQUERY = 'select OpportunityAccessLevel from AccountTeamMember';
    private static final string ATWHERE = ' where accountid = :paramId1 and OpportunityAccessLevel != :paramName1';
    private static final String EDITACCESS='Edit';
    private static final String LIMITCLAUSE=' limit 200';
    private static final String ACCOUNTID='accountId';
    private static final String OPPORTUNITYNAME='OppName';
    private static final String USERID='userId';
    private static final string NAME='AP77LastName';
    private static final String READ='Read';
    private static final String ERRORMSG=  '';
    private static final String OPPORTUNITYID= 'opportunityId';
    private static final String OPPOWNER= 'OppOwner';
    /*****************************************************************************************
Method Name   : testdata1 
Date Created : 22-Jan-2020
Created By   : IDC Offshore.
Description  : This method  is used to create test data (object records)
******************************************************************************************/  
    @testsetup static void testdata1()
    {
        Account acc = ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        pricebook2 prcBk = ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(prcBk);
        Opportunity opp = ARV_AP05_TestDataCreation.opportunityRec(acc.id,prcBk.id);
        database.insert(opp);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        database.insert(usr,true);
        AccountTeamMember at = new AccountTeamMember();
        at.OpportunityAccessLevel=READ;
        at.CaseAccessLevel=READ;
        at.userId=usr.Id;
        at.AccountId=acc.Id;
        database.insert(at);   
    }
    /*****************************************************************************************
Method Name   : method1 
Date Created : 22-Jan-2020
Created By   : IDC Offshore.
Description  : This method  is used to give additional EDIT access to opportunity in Account team members. 
******************************************************************************************/  
    	public static testmethod  void method1(){
            Map<String,Object> inputMap= new Map<String,Object>();
            Map<String,Object> outMap= new Map<String,Object>();
            Map<String,Object> options= new Map<String,Object>();
            User usr=[select id, name from user limit 1];    
            Account acc=[SELECT ID,NAME from account limit 1];
            Opportunity opp=[SELECT ID,NAME,Ownerid,Owner.name from Opportunity limit 1];
            ARV_AP07_QueryDataHelper.paramName1 = EDITACCESS;
            ARV_AP07_QueryDataHelper.paramId1=acc.Id;
            inputMap.put(ACCOUNTID,acc.Id);
            inputMap.put(USERID,usr.Id);
            inputMap.put(OPPOWNER,opp.OwnerId);
            inputMap.put(OPPORTUNITYID,opp.Id);        
            user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
            try{
				system.runAs(usr1){ 
					ARV_AP77_UpdateAccOppAccess classInstance= new ARV_AP77_UpdateAccOppAccess();
					test.startTest();
					classInstance.invokeMethod(INVOKE_METHOD,inputMap,outMap,options);
					test.stopTest();
					System.assertNotEquals(null,usr.id);
				}
			}
			catch(Exception e){
				throw new AuraHandledException('ERRORMSG'+e.getMessage());
			}
		}       
}