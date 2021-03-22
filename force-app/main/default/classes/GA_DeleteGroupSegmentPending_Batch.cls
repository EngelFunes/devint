public class GA_DeleteGroupSegmentPending_Batch {
    /*********************************************************************************
Apex class : GA_DeleteGroupSegmentPending_Batch 
Author: Knocky Lo
Description: Deletes Group Segment Class
**********************************************************************************/
    public static void deleteGroupSegment(List<GA_Group_Segment__c> gslist){
        try{ 
            Set<id> recordId=new Set<id>();
            List<GA_AOR_Group_Segment__c> gsrelatedaordelete = new List <GA_AOR_Group_Segment__c>();
            List<GA_Group_Segment__c> gsdelete = new List<GA_Group_Segment__c>();
            for(GA_Group_Segment__c grp:gslist){
                recordId.add(grp.id);
            }
            List<GA_Group_Segment__History> historyList =[SELECT CreatedById,CreatedDate,Field,Id,IsDeleted, NewValue,OldValue,ParentId FROM GA_Group_Segment__History WHERE ParentId =: recordId and Field = 'Status__c'];
            for(GA_Group_Segment__History h:historyList){
                if(recordid.contains(h.parentid)){
                    if(h.newvalue=='Active' || h.oldvalue == 'Active'){
                        recordId.remove(h.parentId);
                    }            
                }
            }
            List<GA_Group_Segment__c> groupSegment = [SELECT Id,(SELECT id FROM AOR_Group_Segments__r),Status__c,GA_Post_Transaction__c,GA_Transaction_Posted__c FROM GA_Group_Segment__c WHERE Id =: recordId];
            List<GA_Group_Segment__c> groupList = [SELECT id, (SELECT id,GA_WF_Step_ID__c FROM GA_WF_Group_Segment__r
                                                               WHERE GA_WF_Step_ID__r.GA_Status__c = 'Open') 
                                                   FROM GA_Group_Segment__c WHERE id  =: recordId];
            List<GA_WF_Group_Segment__c> workflowProcessList = [SELECT id,GA_Workflow_ID__c,GA_Workflow_ID__r.GA_Status__c,
                                                                GA_WF_Step_ID__c FROM GA_WF_Group_Segment__c WHERE GA_Group_Segment_ID__c != NULL and GA_Group_Segment_ID__c =: recordid];
            Set<Id> deleteWorkflowRules = new Set<Id>();
            Set<Id> deleteWorkflowStepIds = new Set<Id>();
            //system.debug('----groupSegment.groupSegment---'+groupSegment);
            //system.debug('----groupSegment.AOR_Group_Segments__r.size()---'+groupSegment.AOR_Group_Segments__r.size());
            for (GA_Group_Segment__c gsseg: groupSegment){
                if(gsseg.Status__c == 'Pending'){
                    List<GA_WF_Group_Segment__c> groupsegmentWF = new List<GA_WF_Group_Segment__c>();
                    Set<Id> groupSetIds = new Set<Id>();
                    Map<Id,GA_WF_Workflow__c> workflowMap = new Map<Id,GA_WF_Workflow__c>();
                    Map<String,List<GA_WF_Group_Segment__c>> groupSegAndStepMap = new Map<String,List<GA_WF_Group_Segment__c>>();
                    
                    for(GA_Group_Segment__c gs : groupList){
                        for(GA_WF_Group_Segment__c junction : gs.GA_WF_Group_Segment__r){
                            groupSetIds.add(junction.GA_WF_Step_ID__c);
                        }
                    }
                    for(GA_WF_Group_Segment__c groupsegmentWFID : workflowProcessList)
                    {
                        if(groupSetIds.contains(groupsegmentWFID.GA_WF_Step_ID__c))
                        {
                            groupsegmentWF.add(groupsegmentWFID);
                        }
                    }
                    
                    system.debug('---workflowProcessList---'+workflowProcessList);
                    system.debug('---workflowProcessList.size()---'+workflowProcessList.size());
                    
                    for(GA_WF_Group_Segment__c wp :groupsegmentWF){
                        if(groupSegAndStepMap.containskey(wp.GA_WF_Step_ID__c)){
                            groupSegAndStepMap.get(wp.GA_WF_Step_ID__c).add(wp);
                        }else{
                            groupSegAndStepMap.put(wp.GA_WF_Step_ID__c,new List<GA_WF_Group_Segment__c>{wp});
                        }
                    }
                    
                    system.debug('---groupSegAndStepMap---'+groupSegAndStepMap);
                    
                    
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
                    
                    
                    gsdelete.add(gsseg);
                    
                    for (GA_AOR_Group_Segment__c gsaorid :  gsseg.AOR_Group_Segments__r)
                    {
                        gsrelatedaordelete.add(gsaorid);
                    }
                }
            }
            if(deleteWorkflowStepIds.size() > 0){
                delete [select id from GA_WF_Step__c where id In: deleteWorkflowStepIds];
            }
            if(deleteWorkflowRules != null && deleteWorkflowRules.size() > 0){
                delete [select Id from GA_WF_Workflow__c where Id in: deleteWorkflowRules];
                //delete deleteWorkflowRules;// workflowMap.keyset();
            }
            delete gsrelatedaordelete;
            delete gsdelete;
        }catch(System.DmlException e){
            throw new AuraHandledException(e.getDmlMessage(0)); 
        }
    }
}