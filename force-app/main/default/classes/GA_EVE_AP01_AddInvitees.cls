/*******************************************************************************************************************************
@Author             :   Dilip Junapala
@Name               :   GA_EVE_AP01_AddInvitees
@CreatedDate        :   02 - Jan 2018 
@Description        :   GA_EVE_AP01_AddInvitees is for creating event relation records(invites) on an Event.
@version            :   1.0  
********************************************************************************************************************************/
public with sharing class GA_EVE_AP01_AddInvitees {
    public static boolean isExecuting = false;
    public static final string ClsName  ='GA_EVE_AP01_AddInvitees';
    public static final string methodNme  ='addInvites';
    public static final string addInviteesErrMsg = 'Could not add invitees :';
    public static final String actmNbSc = 'New Business Sales Consultant';
    public static final String actmRsR = 'Retention Sales Representative';
    public static final String kLA = 'KLA';
    
    /*******************************************************************************************************************************
@Description        :   addInvites() method 
@Name               :   addInvites
@Param              :   list<Event> evtList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    public static void addInvites(list<Event> evtList){
        try{
            Set<Id> setEventId = new Set<ID>();
            
            Id whtId;
            Id actHndovrId;
            Id actId;
            map<id,id> evnthndovrMap=new map<id,id>();
            if(!evtList.isEmpty()){
                for(Event evt : evtList){
                    evnthndovrMap.put(evt.id, evt.whatid);
                }
                
                Id accOwnerId;
                Set<Id> setAchId = new Set<ID>();
                map<id,id> hnovrAccMap=new map<id,id>();
                List<GA_AccountHandOver__c> achList = [Select Id, GA_CompanyFullLegalName__c, GA_CompanyFullLegalName__r.OwnerId, GA_CompanyFullLegalName__r.GA_Account_Type__c From GA_AccountHandOver__c Where Id IN : evnthndovrMap.values() Limit 5001];
                if(!achList.isEmpty()){
                    for(GA_AccountHandOver__c ach : achList){
                        hnovrAccMap.put(ach.id,ach.GA_CompanyFullLegalName__c);
                        if(ach.GA_CompanyFullLegalName__r.GA_Account_Type__c == kLA)
                        {
                            accOwnerId =ach.GA_CompanyFullLegalName__r.OwnerId;
                        }
                    }
                }
                
                Set<Id> userIds = new Set<Id>();
                map<id,Set<Id>> accActMbrMap=new map<id,Set<Id>>();
                /*for(AccountTeamMember atmbr:([select AccountId, userId, TeamMemberRole from AccountTeamMember 
                                              Where AccountId IN : hnovrAccMap.values()  
                                              AND (TeamMemberRole = :actmNbSc
                                                   OR TeamMemberRole = :actmRsR) Limit 5001]))*/
                for(AccountTeamMember atmbr:([select AccountId, userId, TeamMemberRole from AccountTeamMember 
                                              Where AccountId IN : hnovrAccMap.values()  
                                              AND TeamMemberRole = :actmNbSc Limit 5001]))
                    
                {
                    
                    if(accActMbrMap.get(atmbr.AccountId) !=null)
                    {
                        userIds= accActMbrMap.get(atmbr.AccountId);
                    }
                    else
                    {
                        userIds=new Set<id>();  
                    }
                    
                    if(atmbr.TeamMemberRole == actmNbSc){
                        userIds.add(atmbr.userId);
                    }
                    /*
                    if(atmbr.TeamMemberRole == actmRsR){
                        userIds.add(atmbr.userId);
                    }
*/
                    accActMbrMap.put(atmbr.AccountId, userIds);
                }
                
                List<EventRelation> ErList = new List<EventRelation>();
                Set<id> usrMbr=new Set<id>();
                EventRelation er = new EventRelation();
                if (!evtList.isEmpty()){
                    for(Event evt : evtList){
                        if(!userIds.isEmpty()){
                            usrMbr=accActMbrMap.get(hnovrAccMap.get(evnthndovrMap.get(evt.id)));
                        }
                        if(!String.isEmpty(accOwnerId))
                        {
                            usrMbr.add(accOwnerId);
                        }
                        if( usrMbr != null && !usrMbr.isEmpty() ){
                            for(id usrId:usrMbr){
                                er = new EventRelation();
                                er.RelationId = usrId;
                                er.EventId = evt.Id;
                                ErList.add(er);
                            }
                        }
                    }
                }
                if(!ErList.isEmpty()){
                    Database.insert(ErList, false); 
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            evtList[0].adderror(addInviteesErrMsg);
        }
    }
}