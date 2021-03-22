/**
@Author : Prasant Kumar Satpathy
@Name: GA_AccntFctShtTrgrCls
@CreatedDate:  3- Jan 2018 
@Description: GA_AccntFctShtTrgrCls class is for updating Account Factsheet information based on associated Contact Name
@version : 1.0  
*/ 
public with sharing class GA_AccntFctShtTrgrCls {
    
    public static final String ClsName  ='GA_AccntFctShtTrgrCls';
    public static final String methodNmeBefore  ='prepopulateFactsht';
    public static final String BLANK='';
    public static final String Contact='Contact';
    public static final String Agent='Agent';
    public static boolean isExecuting=false;
    public static final string ErrMsg = 'Could not update contact information';
    /**
@Description: prepopulateFactsht() method 
@Name : prepopulateFactsht
@Param : list<GA_Account_Fact_Sheet__c> actFcshtLst,map<id,GA_Account_Fact_Sheet__c> actfctshtmap
@Return : void
@throws Exception : N/A;
*/
    public static void prepopulateFactsht(list<GA_Account_Fact_Sheet__c> actFcshtLst,map<id,GA_Account_Fact_Sheet__c> actfctshtmap)
    {
        try{
            
            map<id,map<string,id>> actFctshtCntids=new map<id,map<string,id>>();
            id fcstshtid;
            boolean cntNmChng=false;
            boolean agntNmChng=false;
            set<id> allCntIds=new set<id>();
            map<string,id> cntTypeCntMap=new map<string,id>();
            for(GA_Account_Fact_Sheet__c actFcsht:actFcshtLst)
            {
                fcstshtid=actFcsht.id;
                if(actfctshtmap !=null)
                {
                    GA_Account_Fact_Sheet__c afctshtOld=actfctshtmap.get(actFcsht.id);
                    if(afctshtOld.GA_Contact_Name__c != actFcsht.GA_Contact_Name__c)
                    {
                        if(actFcsht.GA_Contact_Name__c !=null)
                        {
                            cntTypeCntMap.put(Contact, actFcsht.GA_Contact_Name__c);
                            actFctshtCntids.put(fcstshtid,cntTypeCntMap); 
                            allCntIds.addall(cntTypeCntMap.values());
                        }
                        cntNmChng=true;
                    }
                    if(afctshtOld.GA_AgentName__c != actFcsht.GA_AgentName__c)
                    {
                        if(actFcsht.GA_AgentName__c !=null)
                        {
                            if(actFctshtCntids.get(fcstshtid) !=null)
                            {
                                cntTypeCntMap=actFctshtCntids.get(fcstshtid);
                            }
                            else
                                cntTypeCntMap=new map<string,id>();
                            cntTypeCntMap.put(Agent, actFcsht.GA_AgentName__c);
                            actFctshtCntids.put(fcstshtid,cntTypeCntMap); 
                            allCntIds.addall(cntTypeCntMap.values());
                        }
                        agntNmChng=true;
                    }
                }
                else
                {
                    if(actFcsht.GA_Contact_Name__c !=null)
                    {
                        cntTypeCntMap.put(Contact, actFcsht.GA_Contact_Name__c);
                        actFctshtCntids.put(fcstshtid,cntTypeCntMap);
                        allCntIds.addall(cntTypeCntMap.values());
                    }
                    if(actFcsht.GA_AgentName__c !=null)
                    {
                        if(actFctshtCntids.get(fcstshtid) !=null)
                        {
                            cntTypeCntMap=actFctshtCntids.get(fcstshtid);
                        }
                        else
                            
                            cntTypeCntMap=new map<string,id>();
                        cntTypeCntMap.put(Agent, actFcsht.GA_AgentName__c);
                        actFctshtCntids.put(fcstshtid,cntTypeCntMap); 
                        allCntIds.addall(cntTypeCntMap.values());
                    }
                    agntNmChng=true;
                } 
            }
            map<id,contact> cntlstRecMap=new map<id,contact>([select id,Email,phone,GA_Contact_Role__c,title from contact where id in:allCntIds limit 20000]);
            if(actFctshtCntids.keyset().size()>0)
            {
                for(GA_Account_Fact_Sheet__c actFcshtRec:actFcshtLst)
                {
                    if(cntNmChng)
                    {
                        if(actFcshtRec.GA_Contact_Name__c !=null)
                        {
                            actFcshtRec.GA_Contact_Title__c=cntlstRecMap.get(actFctshtCntids.get(actFcshtRec.id).get(Contact)).title;
                            actFcshtRec.GA_Contact_Role__c=cntlstRecMap.get(actFctshtCntids.get(actFcshtRec.id).get(Contact)).GA_Contact_Role__c;
                            actFcshtRec.GA_Contact_Phone__c=cntlstRecMap.get(actFctshtCntids.get(actFcshtRec.id).get(Contact)).phone;
                            actFcshtRec.GA_Contact_Email__c=cntlstRecMap.get(actFctshtCntids.get(actFcshtRec.id).get(Contact)).Email;  
                        }
                        else
                        {
                            actFcshtRec.GA_Contact_Title__c=BLANK;
                            actFcshtRec.GA_Contact_Role__c=BLANK;
                            actFcshtRec.GA_Contact_Phone__c=BLANK;
                            actFcshtRec.GA_Contact_Email__c=BLANK;
                        }
                    }
                    if(agntNmChng)
                    {
                        if(actFcshtRec.GA_AgentName__c !=null)
                        {
                            actFcshtRec.GA_AgentPhoneNumber__c=cntlstRecMap.get(actFctshtCntids.get(actFcshtRec.id).get(Agent)).Phone;
                            actFcshtRec.GA_AgentEmail__c=cntlstRecMap.get(actFctshtCntids.get(actFcshtRec.id).get(Agent)).Email;
                        }
                        else
                        {
                            actFcshtRec.GA_AgentPhoneNumber__c=BLANK;
                            actFcshtRec.GA_AgentEmail__c=BLANK;
                        }
                    }
                    
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeBefore);
            actFcshtLst[0].adderror(ErrMsg);
        }
    }
}