/**
@Author : IDC Offshore
@Name: GA_GSRatingTypeBatch
@CreatedDate: 25 - Oct - 2018 
@Description: GA_GSRatingTypeBatch batch class to update Rating Type information on GS.
*/
global class GA_GSRatingTypeBatch implements Database.Batchable<sObject>{
    global final string query;
    global  List<Database.SaveResult> srList = new List<Database.SaveResult>();
    global List<GA_Group_Segment__c> gsLst = New  List<GA_Group_Segment__c>();
    /**
@Description: GA_GSRatingTypeBatch() Constructer method 
@Name : GA_GSRatingTypeBatch
@Param : string gsaQry
@Return : void
@throws Exception : N/A;
*/ 
    global GA_GSRatingTypeBatch(string gsaQry)
    {
        query=gsaQry;
    }
    /**
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**
@Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
*/ 
    global void execute(Database.BatchableContext bc, List<GA_Group_Segment__c> scope)
    {
            
        for(GA_Group_Segment__c gs :scope){
            gs.GA_Is_Mass_Updating__c = true;
            if(gs.GA_Account_Type__c=='IBU'){
                gs.GA_Rating_Type__c='IB';
            }else if(gs.GA_System_of_Record__c == 'SMART' && gs.GA_Smart_Rating_Type__c !=null){
                gs.GA_Rating_Type__c = gs.GA_Smart_Rating_Type__c;
            }else if(gs.GA_System_of_Record__c == 'SMART' && gs.GA_Smart_Rating_Type__c ==null){
                gs.GA_Rating_Type__c ='No Rating Type';
            }else if(gs.GA_Current_Cluster_Code__c == null){
                gs.GA_Rating_Type__c='No Cluster Code';
            }else{
                List<GA_GS_Rating_Type_Config__mdt> ratngType = [select GA_Rating_Type__c,GA_Rating_Method__c,GA_Start_Cluster_Code__c, 
                                                                 GA_End_Cluster_Code__c,GA_Sort_Order__c
                                                                 from GA_GS_Rating_Type_Config__mdt where 
                                                                 //GA_Start_Cluster_Code__c<=:gs.GA_Cluster_Code_Formula__c AND 
                                                                 //GA_End_Cluster_Code__c>=:gs.GA_Cluster_Code_Formula__c 
                                                                 GA_Start_Cluster_Code__c<=:gs.GA_Current_Cluster_Code__c AND 
                                                                 GA_End_Cluster_Code__c>=:gs.GA_Current_Cluster_Code__c 
                                                                 ORDER BY GA_Sort_Order__c DESC Limit 50];
                
                if(ratngType.size()>0){
                    for(GA_GS_Rating_Type_Config__mdt rtngtp:ratngType){
                        if(rtngtp.GA_Rating_Method__c == null){
                            gs.GA_Rating_Type__c=rtngtp.GA_Rating_Type__c;
                        }
                        else if(rtngtp.GA_Rating_Method__c == gs.GA_Rating_Method__c){
                            gs.GA_Rating_Type__c=rtngtp.GA_Rating_Type__c;
                        }
                    }
                }
                else{
                    gs.GA_Rating_Type__c = 'See System Administrator';
                }
            }
            
            gsLst.add(gs);
        }
        GA_GS_AP02_Update_Address.isExecuting=true;
        //GA_ExternlaAppleSrvcCls.isExecuting = true;
        GA_GS_UpdateRatingType.isExecuting = true;
        GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
        GA_GroupSegmentTriggerHandler.isExecuting = true;
        GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
        GA_GS_AP04_UpdtStatus.isExecuting = true;
        GA_GS_AP04_UpdtStatus.isInvoked = true;
        GA_GS_UpdatWrappingFileTPA.isExecuting = true;
      
        srList = Database.update(gsLst,false);
        List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
        
        Integer i=0;
        if(!srList.isEmpty()){
            for(Database.SaveResult obj : srList){                
                for(Database.Error objErr : obj.getErrors()){
                    if(!obj.isSuccess()){
                        ExceptionLog__c objLog = new ExceptionLog__c(
                            Object_ID__c =gsLst[i].id,
                            ExceptionDescription__c = objErr.getMessage(),
                            ExceptionCode__c =  String.valueOf(objErr.getStatusCode()),
                            NumberOfTimesOccured__c = 1,
                            ExceptionDetails__c = objErr.getMessage(),
                            Severity__c = 'ERROR');
                        excpLst.add(objLog);
                    } 
                }
                i++;
            }
        }
        if(!excpLst.isEmpty()){
            Database.insert(excpLst);
        }
        
        
    }
    /**
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
*/ 
    global void finish(Database.BatchableContext bc)
    {
        
    }
}