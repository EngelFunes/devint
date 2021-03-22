trigger CRMTicketsDuplicateCIDWithStatusCheck on CRM_Tickets__c (before insert,before update) 
{
    for(CRM_Tickets__c crmTicket:Trigger.new)
        {
        if (crmTicket.CID__c != NULL && !crmTicket.Status__c.Contains('Closed'))
        {
            String ErrorMessage = 'You cannot create CRM Ticket with duplicate CID';
            List<CRM_Tickets__c> crmTickets = [SELECT CID__c FROM CRM_Tickets__c WHERE CID__c=:crmTicket.CID__c AND (NOT Status__c LIKE 'Closed%')];        
            if(Trigger.isUpdate)
            {
                for(CRM_Tickets__c crmTicket_old:Trigger.old) 
                {
                    if(crmTicket.CID__c==crmTicket_old.CID__c && crmTickets.size() > 1)
                    {
                            crmTicket.adderror(ErrorMessage);
                    }
                    if(crmTicket.CID__c!=crmTicket_old.CID__c && crmTickets.size() > 0)
                    {
                            crmTicket.adderror(ErrorMessage);
                    }
                }
            }
            if(Trigger.isInsert && crmTickets.size() > 0)
            {
                crmTicket.adderror(ErrorMessage);
            }
        }
    }
}