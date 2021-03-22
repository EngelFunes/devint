public class DeleteGroupSegmentController {
    
    @AuraEnabled
    public static void deleteGroupSegment(Id recordId){
        try{ 
			
            GA_Group_Segment__c groupSegment = [SELECT Id,(SELECT id FROM AOR_Group_Segments__r),Status__c,GA_Post_Transaction__c,GA_Transaction_Posted__c FROM GA_Group_Segment__c WHERE Id =: recordId];
            //system.debug('----groupSegment.groupSegment---'+groupSegment);
            //system.debug('----groupSegment.AOR_Group_Segments__r.size()---'+groupSegment.AOR_Group_Segments__r.size());
            if(groupSegment.Status__c == 'Pending' && (groupSegment.GA_Post_Transaction__c != true && groupSegment.GA_Transaction_Posted__c != true)){
                
                Set<Id> groupSetIds = new Set<Id>();
                Map<Id,GA_WF_Workflow__c> workflowMap = new Map<Id,GA_WF_Workflow__c>();
                Map<String,List<GA_WF_Group_Segment__c>> groupSegAndStepMap = new Map<String,List<GA_WF_Group_Segment__c>>();
                
                List<GA_Group_Segment__c> groupList = [SELECT id, (SELECT id,GA_WF_Step_ID__c FROM GA_WF_Group_Segment__r
                                                                   WHERE GA_WF_Step_ID__r.GA_Status__c = 'Open') 
                                                       FROM GA_Group_Segment__c WHERE id  =: recordId];
                
                for(GA_Group_Segment__c gs : groupList){
                    for(GA_WF_Group_Segment__c junction : gs.GA_WF_Group_Segment__r){
                        groupSetIds.add(junction.GA_WF_Step_ID__c);
                    }
                }
                system.debug('---groupSetIds---'+groupSetIds);
                List<GA_WF_Group_Segment__c> workflowProcessList = [SELECT id,GA_Workflow_ID__c,GA_Workflow_ID__r.GA_Status__c,
                                                                    GA_WF_Step_ID__c FROM GA_WF_Group_Segment__c WHERE 
                                                                    GA_WF_Step_ID__c IN:groupSetIds AND GA_Group_Segment_ID__c != NULL];
                
                system.debug('---workflowProcessList---'+workflowProcessList);
                system.debug('---workflowProcessList.size()---'+workflowProcessList.size());
                
                for(GA_WF_Group_Segment__c wp :workflowProcessList){
                    if(groupSegAndStepMap.containskey(wp.GA_WF_Step_ID__c)){
                        groupSegAndStepMap.get(wp.GA_WF_Step_ID__c).add(wp);
                    }else{
                        groupSegAndStepMap.put(wp.GA_WF_Step_ID__c,new List<GA_WF_Group_Segment__c>{wp});
                    }
                }
                
                system.debug('---groupSegAndStepMap---'+groupSegAndStepMap);
                Set<Id> deleteWorkflowRules = new Set<Id>();
                Set<Id> deleteWorkflowStepIds = new Set<Id>();
                
                for(String key :groupSegAndStepMap.keyset()){
                    GA_WF_Workflow__c workflow = new GA_WF_Workflow__c();
                    system.debug('---groupSegAndStepMap.get(Key).size()---'+groupSegAndStepMap.get(Key).size());
                    if(groupSegAndStepMap.get(Key).size() == 1){
                        workflow.Id = groupSegAndStepMap.get(Key)[0].GA_Workflow_ID__c;
                        workflow.GA_Status__c = 'Canceled';
                        workflowMap.put(workflow.Id,workflow);
                        deleteWorkflowRules.add(groupSegAndStepMap.get(Key)[0].GA_Workflow_ID__c);
                        deleteWorkflowStepIds.add(key);
                    }
                    
                }
                system.debug('---deleteWorkflowStepIds---'+deleteWorkflowStepIds);
                
                if(deleteWorkflowStepIds.size() > 0){
                    delete [select id from GA_WF_Step__c where id In: deleteWorkflowStepIds];
                }
                system.debug('---workflowMap---'+workflowMap);
                if(deleteWorkflowRules != null && deleteWorkflowRules.size() > 0){
                    delete [select Id from GA_WF_Workflow__c where Id in: deleteWorkflowRules];
                    //delete deleteWorkflowRules;// workflowMap.keyset();
                }
                delete groupSegment.AOR_Group_Segments__r;
                delete groupSegment;
            }else{
                SObjectException sObj = new SObjectException();
                sObj.setMessage('Group segment can’t be deleted as it has been posted already. Please contact System admin to delete!');
                throw sObj;
                //throw new Exception('You cant delete the record. As status is not Pending.');
                //throw new AuraHandledException('You cant delete the record. As status is not Pending.');
            }
        }catch(System.DmlException e){
            
            throw new AuraHandledException(e.getDmlMessage(0)); 
        }catch(Exception e){
			system.debug('---e.getMessage()---'+e.getMessage());
            throw new AuraHandledException(e.getMessage()); 
        }
        
    }
}