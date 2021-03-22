/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_WrkflwUpadteCompDatesCls 
@CreatedDate: 03 - MAR 2019 
@Description: GA_WrkflwUpadteCompDatesCls class is for udpating completed dates
@version : 1.0  
********************************************************************************************************************************/
public class GA_WrkflwUpadteCompDatesCls {
    public static final string GrpAdmin  ='GA ';
    public static final string GrpAdminMgr  ='Group Admin ';
    public static final string rateCntrl  ='Rate ';
    public static final string bcnGmt  ='GMT';
    public static final string bcnUndrwrtr  ='BCN Underwriter';
    public static final string smllGrp  ='Small Group';
    public static final string clsdVal='Closed';   
    public static final string ClsName='GA_WrkflwUpadteCompDatesCls';
    public static final string UpdteCompDatesmthd='UpdteCompDates';
    public static final string updateWflwFieldsmthd='updateWflwFields';
    public static final string pcs  ='PCS';
    public static final string wm  ='West Michigan';
    public static final string supprt  ='Support';
    public static final string salesSpprt  ='Sales Support';
    public static void UpdteCompDates(list<GA_WF_Workflow__c> wrkFLwLst, map<id,GA_WF_Workflow__c> wrkflowOldMap)
    {
        try
        {
            list<id> wrfwIds=new list<id>();
            
            
            GA_WF_Workflow__c wfOld=new GA_WF_Workflow__c();
            for(GA_WF_Workflow__c wflw:wrkFLwLst) 
            {
                wfOld=wrkflowOldMap.get(wflw.Id);
                if(wflw.GA_Status__c==clsdVal && (wfOld.GA_Status__c !=wflw.GA_Status__c))
                {
                    wrfwIds.add(wflw.Id);
                }
            }
            if(wrfwIds.size()>0)
                updateWflwFields(wrfwIds);   
        }
        catch(exception e)
        {
           GA_LogExceptionCls.LogExcp(e, ClsName, UpdteCompDatesmthd); 
        }
        
    }
    @future
    public static void updateWflwFields(list<id> wrfwIds)
    {
        try
        {
        list<GA_WF_Group_Segment__c> wfProcessRecds=[select id,OwnerId,GA_OwnerRole__c,GA_Workflow_ID__c,GA_Date_Closed__c from GA_WF_Group_Segment__c 
                                                     where GA_Workflow_ID__c in:wrfwIds order by GA_Date_Closed__c desc];
        map<id, map<string,list<GA_WF_Group_Segment__c>>> wfwfPrcsssMap=new map<id, map<string,list<GA_WF_Group_Segment__c>>>();
        list<GA_WF_Group_Segment__c> wfwfPrcsssLstTmp=new list<GA_WF_Group_Segment__c>();
        map<string,list<GA_WF_Group_Segment__c>> wfrolWfProcssMap=new map<string,list<GA_WF_Group_Segment__c>>();
        for(GA_WF_Group_Segment__c wfPrcss:wfProcessRecds)
        {
            if(wfwfPrcsssMap.get(wfPrcss.GA_Workflow_ID__c)!=null)
            {
                wfrolWfProcssMap=wfwfPrcsssMap.get(wfPrcss.GA_Workflow_ID__c);
            }
            else
                wfrolWfProcssMap=new map<string,list<GA_WF_Group_Segment__c>>();
            if(wfrolWfProcssMap.get(wfPrcss.GA_OwnerRole__c) !=null)
            {
                wfwfPrcsssLstTmp= wfrolWfProcssMap.get(wfPrcss.GA_OwnerRole__c);
            }
            else
                wfwfPrcsssLstTmp=new list<GA_WF_Group_Segment__c>();
            wfwfPrcsssLstTmp.add(wfPrcss);
            wfrolWfProcssMap.put(wfPrcss.GA_OwnerRole__c,wfwfPrcsssLstTmp);
            wfwfPrcsssMap.put(wfPrcss.GA_Workflow_ID__c,wfrolWfProcssMap);
        }
        
        list<GA_WF_Workflow__c> wfLsttoUpdate=new list<GA_WF_Workflow__c>();
        for(id wflwId:wfwfPrcsssMap.keyset())
        {
            map<string,list<GA_WF_Group_Segment__c>> rolwWfPrcssMpTmp=wfwfPrcsssMap.get(wflwId);
            GA_WF_Workflow__c wflwToUpdte=new GA_WF_Workflow__c();
            wflwToUpdte.id=wflwId;
            boolean existRole=false;
            for(string RoleAssgn:rolwWfPrcssMpTmp.keySet())
            {
                list<GA_WF_Group_Segment__c> grpSgmntLst=rolwWfPrcssMpTmp.get(RoleAssgn);
                
                if(grpSgmntLst.size()>0)
                {
                    GA_WF_Group_Segment__c grpLtst=grpSgmntLst[0];
                    if(grpLtst.GA_Date_Closed__c!=null){
                        if(RoleAssgn.contains(GrpAdmin) || RoleAssgn.contains(GrpAdminMgr))
                        {
                            wflwToUpdte.GA_Completed_Date__c=date.valueof(grpLtst.GA_Date_Closed__c);
                            existRole=true;
                        }
                        if(RoleAssgn.contains(rateCntrl))
                        {
                            wflwToUpdte.GA_Rate_Control_Completed_Date__c=date.valueof(grpLtst.GA_Date_Closed__c);
                            existRole=true;
                        }
                        if(RoleAssgn.contains(bcnGmt))
                        {
                            wflwToUpdte.GA_BCN_GMT_Completed_Date__c=date.valueof(grpLtst.GA_Date_Closed__c);
                            existRole=true;
                        }
                        if(RoleAssgn.contains(bcnUndrwrtr))
                        {
                            wflwToUpdte.GA_BCN_Underwriting_Completed_Date__c=date.valueof(grpLtst.GA_Date_Closed__c);
                            existRole=true;
                        }
                        if(RoleAssgn.contains(smllGrp))
                        {
                            wflwToUpdte.GA_SG_Underwriting_Completed_Date__c=date.valueof(grpLtst.GA_Date_Closed__c);
                            existRole=true;
                        }
                        if( RoleAssgn.contains(pcs) ||  RoleAssgn.contains(wm) ||  RoleAssgn.equalsIgnoreCase(supprt) || RoleAssgn.contains(salesSpprt) )
                        {
                            wflwToUpdte.GA_Sales_Support_Completed_Date__c=date.valueof(grpLtst.GA_Date_Closed__c);
                            existRole=true;
                        }
                    }
                }
                
            }
            if(existRole)
            {
                wfLsttoUpdate.add(wflwToUpdte);
            }
        }
        database.update(wfLsttoUpdate);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, updateWflwFieldsmthd); 
        }
    }
}