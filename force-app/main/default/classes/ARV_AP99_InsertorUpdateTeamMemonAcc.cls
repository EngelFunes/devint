/****************************************************************************************************
@Name: ARV_AP99_InsertorUpdateTeamMemonAcc
@CreatedDate: May-05-2020 
@Description:1.It is called in GA_AccountTriggerHandlr in After update event.
       2.It is used to Update AccountTeammember access to Read/write when owner changes and also inserts
         logged in MA user to Accteam when Sign/upload is completed.
*********************************************************************************************/
public without sharing class ARV_AP99_InsertorUpdateTeamMemonAcc{
    private static final String EDITACCESS = 'Edit';
    private static final String READACCESS = 'read';
    private static final String ISPARTNERUSR = 'PowerPartner';
    private static final String MANAGINGAGENTPNAME = 'Managing Agent Community User';
    //private static final String MANAGINGAGENTPNAME = 'System Administrator';
    private static final String BCBSMAGENT = 'BCBSM Agent';
    private static final String MAROLE = 'Agent';
    private static final String RECTYPE_PROSP = 'Account - Prospect';
 /******************************************************************************************************
@Name : updateAccountTeamAccess
@Param :  map<id,Account> accNewMap,map<id,Account>accoldMap  
@Return : void
@throws Exception : N/A;
*******************************************************************************************************/
    public static void updateAccountTeamAccess(map <id,Account> accNewMap, map <id, Account> accoldMap){
        string extenalAgent= userinfo.getUserType();
        if(ISPARTNERUSR.equalsIgnoreCase(extenalAgent)){        
        set <id> accids = New Set <id>();
        string pname = null;
        List <AccountTeamMember> accteamlst = new List <AccountTeamMember> ();
        for (Account acc: accNewMap.values()) {
            if (acc.ownerid != accoldMap.get(acc.id).ownerid && RECTYPE_PROSP.equalsIgnoreCase(acc.GA_RecordType__c)){
                accids.add(acc.Id);
            }
        }
        if (accids.size() > 0) {
            Profile p = [select id, name from profile where id =: userinfo.getProfileId()];
        	pname = p.name;
            for (AccountTeamMember teammem: [select id, accountId, UserId, AccountAccesslevel, TeamMemberRole
                                 from AccountTeamMember
                                 where accountId IN: accids and User.Profile.name =: BCBSMAGENT
                      ]){
                teammem.AccountAccessLevel = EDITACCESS;
                teammem.OpportunityAccessLevel =EDITACCESS;
                accteamlst.add(teammem);
            }
        }
        else{}
        if (accteamlst.size() > 0) {
            database.update(accteamlst);
        }
        else{}
        if (MANAGINGAGENTPNAME.equalsIgnoreCase(pname) && accids.size() > 0) {
            insertMAUSertoAccTeam(accids);
        }
        else{}
    }
    else{
        
    }
    }
 /******************************************************************************************************
@Name : insertMAUSertoAccTeam
@Param : set<Id> accoids 
@Return : void
@throws Exception : N/A;
***************************/
    private static void insertMAUSertoAccTeam(set<Id> accoids) {
        List <AccountTeamMember> accteamlst2 = new List <AccountTeamMember> ();
        AccountTeamMember newatmem=null;
        for (Id acId: accoids) {
          newatmem = new AccountTeamMember();  
            newatmem.AccountId = acId;
            newatmem.TeamMemberRole = MAROLE;
            newatmem.UserId = UserInfo.getUserId();
            newatmem.AccountAccessLevel = EDITACCESS;
            newatmem.OpportunityAccessLevel = EDITACCESS;
            accteamlst2.add(newatmem);
        }
        if (accteamlst2.size() > 0) {
            database.insert(accteamlst2);
        }
        else{}
    }
}