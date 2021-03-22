/**
@Author : Padmahaarika Jayana
@Name: GA_AR_AP01_UpdatePlatinumStatusOnAccount
@CreatedDate: 24- Jul 2017 
@Description: GA_AR_AP01_UpdatePlatinumStatusOnAccount class is for creating/updating Platinum status on customer account if linked
to any Platinum Agency Account
@version : 1.0  
*/
public with sharing class GA_ACC_AP01_CheckPlatinumStatusOnAgency {
    public static boolean isExecuting = false;
    public static final string AgencyRecType  = 'Account - Agency';
    public static final string PlatinumFieldname  ='GA_Platinum__c';
    public static final string AcctStatusFieldname  ='Account_Status__c';
    public static final string PlatErrMsg  ='Platinum  status  is not updated for Account records :';
    public static final string ClsName  ='GA_ACC_AP01_CheckPlatinumStatusOnAgency';
    public static final string methodNme  ='updateCustomerAccountOfAgency';
    public static final string agncyRelQuery='select id,GA_Agency__c,GA_Account__c,GA_EndDate__c from GA_AgencyRelationShip__c ';
    public static final string agncyRelWhere='where GA_Agency__c in ';
    public static final string agncyRelLimit=' Limit 10000';
    public static final Set<Id> agencyAccIdSet = New Set<Id>();
    /**
@Description: updateCustomerAccountOfAgency() method 
@Name : updateCustomerAccountOfAgency
@Param : list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static void updateCustomerAccountOfAgency(list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap )
    {
        try{
            Set<Id> agencyAccIdSet = New Set<Id>();
            map<Id,Account> agencyStatusSet = New map<Id,Account>();
            Map<ID,GA_AgencyRelationShip__c> agencyRelationMap = New  Map<ID,GA_AgencyRelationShip__c>();
            
            Id agencyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(AgencyRecType).getRecordTypeId();
            if(!accList.isEmpty()){
                for(Account a : accList) {  
                    
                    if((a.RecordTypeId  == agencyRecordTypeId ) && ((a.get(PlatinumFieldname) != accoldMap.get(a.Id).get(PlatinumFieldname)) || (a.get(AcctStatusFieldname) != accoldMap.get(a.Id).get(AcctStatusFieldname)))){
                        agencyAccIdSet.add(a.id);
                        if((a.get(AcctStatusFieldname) != accoldMap.get(a.Id).get(AcctStatusFieldname)))
                        agencyStatusSet.put(a.id,a);
                    }            
                }
                
                if(!agencyAccIdSet.isEmpty()){
                    // fetch the set id's in String with comma seperated 
                    String agencyAccIdString = GA_Util08_FilterProcessHelper.idSet(agencyAccIdSet);
                    
                    //Fetch the Agency Relations with all customer accounts based in Agency Acc Id to update the platinum status
                    agencyRelationMap = GA_Util04_AgencyRelDataAccessHelper.fetchAgencyRelationsMap(agncyRelQuery, agncyRelWhere + agencyAccIdString, GA_Util03_AccountDataAccessHelper.BLANK, agncyRelLimit);
                    
                    if(!agencyRelationMap.isEmpty()){
                       
                        list<GA_AgencyRelationShip__c> agencyRelshipLstToUpdte=new list<GA_AgencyRelationShip__c>();
                        GA_AgencyRelationShip__c agncyRlshpTmp=new GA_AgencyRelationShip__c();
                        for(GA_AgencyRelationShip__c agncyRlshp:agencyRelationMap.values())
                        {
                           agncyRlshpTmp=new GA_AgencyRelationShip__c();
                           if(agencyStatusSet.keyset().contains(agncyRlshp.GA_Agency__c)) 
                           {
                               if(agencyStatusSet.get(agncyRlshp.GA_Agency__c).GA_Active_Account_Status__c && (agncyRlshp.GA_EndDate__c>=system.today() || agncyRlshp.GA_EndDate__c==null))
                               {
                                  agncyRlshpTmp.Id=agncyRlshp.Id;
                                  agncyRlshpTmp.GA_Is_Active__c=true;  
                                  agncyRlshpTmp.GA_By_Pass_Validation__c=true; 
                               }
                               else
                               {
                                   agncyRlshpTmp.Id=agncyRlshp.Id;
                                   agncyRlshpTmp.GA_Is_Active__c=false; 
                                   agncyRlshpTmp.GA_By_Pass_Validation__c=true; 
                               }
                               agencyRelshipLstToUpdte.add(agncyRlshpTmp);
                           }
                           
                        }
                        GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting=true;
                        if(agencyRelshipLstToUpdte.size()>0)
                        database.update(agencyRelshipLstToUpdte);
                        GA_AR_AP01_UpdatePlatinumStatusOnAccount.createAgencyRelation(agencyRelationMap.values(),agencyRelationMap);
                    }
                }
            }
        }catch (Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);   
            accList[0].adderror(PlatErrMsg);
            
        }
    }
}