public class workflowErrorController {
	@AuraEnabled(cacheable=true)
    public static List<String> getErrorMessages(String recordId){
        List<String> errorMessages = new List<String>();
        
        GA_WF_Workflow__c w = [SELECT Id, ARV_Enrollment_Contract__c FROM GA_WF_Workflow__c WHERE Id =: recordId LIMIT 1];
        
        String contractId = w.ARV_Enrollment_Contract__c;
        
        Contract con = [SELECT Id, ARV_BCN_Group_Error_Message__c, ARV_BCN_Member_Error_Message__c, ARV_BCBSM_Group_Error_Message__c, ARV_BCBSM_Member_Error_Message__c
                       FROM Contract where Id =: contractId LIMIT 1];
        
        if (con.ARV_BCN_Group_Error_Message__c != null){
            errorMessages.add(con.ARV_BCN_Group_Error_Message__c);
        	} else { errorMessages.add('false');
        }
        
        if (con.ARV_BCN_Member_Error_Message__c != null){
            errorMessages.add(con.ARV_BCN_Member_Error_Message__c);
        	} else { errorMessages.add('false');
        }
        
        if (con.ARV_BCBSM_Group_Error_Message__c != null){
            errorMessages.add(con.ARV_BCBSM_Group_Error_Message__c);
        	} else { errorMessages.add('false');
        }
        
        if (con.ARV_BCBSM_Member_Error_Message__c != null){
            errorMessages.add(con.ARV_BCBSM_Member_Error_Message__c);
        	} else { errorMessages.add('false');
        }
        
        return errorMessages;
    }
}