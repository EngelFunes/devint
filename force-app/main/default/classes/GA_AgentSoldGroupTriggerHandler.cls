public class GA_AgentSoldGroupTriggerHandler
{
    public static final String ClsName  ='GA_AgentSoldGroupTriggerHandler';
    public static final String methodNmeafterinsert  ='afterInsert';
    public static final String methodNmeafterupdate  ='afterUpdate';
    public static void updateAgentSoldEnrollment(List<GA_Agent_Sold_Group__c> lstASG, Map<Id, GA_Agent_Sold_Group__c> oldMap)
    {
        List<Id> lstASEIds = new List<Id>();
        List<GA_Agent_Sold_Enrollment__c> lstASEForUpdate = new List<GA_Agent_Sold_Enrollment__c>();
        
        for(GA_Agent_Sold_Group__c objASG : lstASG)
        {
            if(oldMap != null && objASG.GA_Benefit_Effective_Date__c != oldMap.get(objASG.Id).GA_Benefit_Effective_Date__c)
            {
                lstASEIds.add(objASG.GA_Managing_Agent_Sale_Enroll_Id__c);    
            }
            else
            {
                lstASEIds.add(objASG.GA_Managing_Agent_Sale_Enroll_Id__c); 
            }
        }
        System.debug('=====lstASEIds==='+lstASEIds);
        
        //Get all ASE records with blank effective date and update them with ASG benefit effective date
        for(GA_Agent_Sold_Enrollment__c objASE : [SELECT Id ,GA_Benefit_Effective_Date__c, (SELECT Id, GA_Benefit_Effective_Date__c FROM Agent_Sold_Groups__r  order by GA_Benefit_Effective_Date__c) FROM GA_Agent_Sold_Enrollment__c WHERE Id In:lstASEIds])
        {
            
            for(GA_Agent_Sold_Group__c objASG : objASE.Agent_Sold_Groups__r)
            {
                //Update at field level
                objASE.GA_Benefit_Effective_Date__c =  objASG.GA_Benefit_Effective_Date__c;
                
                lstASEForUpdate.add(objASE);    
                
                break; 
            }
        }
        System.debug('=====lstASEForUpdate==='+lstASEForUpdate);
        if(lstASEForUpdate.size() > 0)
        {
           try
           {
               update lstASEForUpdate;
           }
           catch(Exception e)
           {
           		 GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterupdate);
           }
        }
    }
}