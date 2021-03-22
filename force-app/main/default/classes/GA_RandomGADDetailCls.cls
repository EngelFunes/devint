public class GA_RandomGADDetailCls {
    @AuraEnabled
    public static list<GA_WF_Group_Segment__c> wfProcssLstRecs(string status)
    {
        date tmrDate=system.today()+1;
        list<GA_WF_Group_Segment__c> wfProcssLst=[select id,Ownerid,GA_Workflow_ID__r.GA_Benefit_Effective_Date__c,GA_Cluster_Code__c,
                                                  GA_Tracking_Status__c,GA_Current_Status_Dt__c,GA_Account__c,
                                                  GA_Group_5_3__c,GA_MTV_Division_4__c,GA_Group_Segment_Name__c,
                                                  GA_Sales_Type__c,GA_Workflow_ID__r.GA_Corporate_Received_Date__c,
                                                  GA_Workflow_ID__r.GA_Received_Date__c,GA_Date_Closed__c,GA_Work_Type__c,
                                                  GA_Workflow_ID__r.Name,Owner.Name,GA_OwnerRole__c,GA_Priority__c from GA_WF_Group_Segment__c 
                                                  where  lastmodifieddate>=:system.today() and lastmodifieddate<:tmrDate 
                                                  and GA_status__c=:status and (GA_OwnerRole__c like 'GA%' or GA_OwnerRole__c like 'Group Admin%') 
                                                  and 	GA_Step_Name__c= 'QA - To Review' order by Owner.Name limit 100];
        map<string,list<GA_WF_Group_Segment__c>> ownrWfprocssMap=new map<string,list<GA_WF_Group_Segment__c>>();
        list<GA_WF_Group_Segment__c> wfPrcssLstTmp=new list<GA_WF_Group_Segment__c>();
        for(GA_WF_Group_Segment__c wfPrcss:wfProcssLst)
        {
            if(ownrWfprocssMap.get(wfPrcss.Owner.Name) !=null)
                wfPrcssLstTmp=ownrWfprocssMap.get(wfPrcss.Owner.Name);
            else
                wfPrcssLstTmp=new list<GA_WF_Group_Segment__c>();
            wfPrcssLstTmp.add(wfPrcss);
            ownrWfprocssMap.put(wfPrcss.Owner.Name,wfPrcssLstTmp);
        }
        list<GA_WF_Group_Segment__c> wfProcsstoDisply=new list<GA_WF_Group_Segment__c>();
        for(string ownr:ownrWfprocssMap.keyset())
        {
            integer i=1;
            for(GA_WF_Group_Segment__c wfPrcssTmp:ownrWfprocssMap.get(ownr))
            {
                if(math.mod(i, 3)==0)
                {
				wfProcsstoDisply.add(wfPrcssTmp);                  
                }
                i++;
            }
        }
        return wfProcsstoDisply;
    }
}