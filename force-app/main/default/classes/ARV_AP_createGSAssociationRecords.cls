/*****************************************************************************************
Class Name   : ARV_AP_createGSAssociationRecords
Date Created : 3 February 2021
Created By   : IDC Offshore
Description  : This is the class for creating records for Group Segment Association object
******************************************************************************************/

global without sharing class ARV_AP_createGSAssociationRecords implements vlocity_ins.VlocityOpenInterface2 {
private static string SPONPLANWASCHGD='f_SponsoredPlanAcronym_WasChanged';
private static string TRUEVALUE='true';
public static final string BCBSMCLUSTERNULL ='00';  
    
    global ARV_AP_createGSAssociationRecords(){}
    
    /*****************************************************************************************
    Method Name   : invokeMethod
    Created By   : IDC Offshore
    Description  : This is the invokeMethod
    ******************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options)
    {
        Boolean success = true;
        try
        {
            if (methodName.contains('createGSARecords')) {
                createGSARecords(input,output,options);
            }
        }
        catch(Exception e){
            system.debug('Error at::'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
        }
        return success;
    }

    /*****************************************************************************************
    Method Name   : createGSARecords
    Created By   : IDC Offshore
    Description  : This is the method updating GSA records 
    ******************************************************************************************/
    public static void createGSARecords(Map<String,object> input,Map<String,object> output,Map<String,object> options){
        try{
            
            //information needed from Omniscript
            String accountStrngId= String.valueOf(input.get('ContextId'));//since the context ID is Account here
            system.debug('main account '+accountStrngId);
            map<String, Object> maintenanceStrObj = (map<String, Object>)input.get('MaintenanceChange');
            map<String, Object> accountInfoMap = (map<String, Object>)maintenanceStrObj.get('AccountInfo');
            map<String, Object> TypeAheadSPAMap = (map<String,Object>)accountInfoMap.get('TypeAhead_SponsoredPlanAcronym-Block');
            String typeahead = String.valueOf(TypeAheadSPAMap.get('TypeAhead_SponsoredPlanAcronym'));
            String reDate = String.valueOf(accountInfoMap.get('SponsorPlanAcronymEffectiveDate'));
            Date reqEffDate = date.valueOf(reDate);
            String assocAccountId = typeahead;
            Boolean spachnge= Boolean.valueof(accountInfoMap.get(SPONPLANWASCHGD));
            system.debug('date?'+reqEffDate);
            
            //declaring variables to be used in logic
            Id oldGA;
            ID accID;
            List<GA_Group_Segment__c> listOfGS = new List<GA_Group_Segment__c>(); //to fetch existing GS
            listOfGS = [select id, GA_Association_Id__c,GA_Account__c from GA_Group_Segment__c where GA_Account__c =:accountStrngId];
            List<GA_Group_Segment__c> listOfUpdatedGS = new List<GA_Group_Segment__c>(); // to store updated GS 
            List<Account> assocAccountList = new List<Account>(); //to fetch existing Account-Association records
            assocAccountList = [select id, GA_Acronym__c from Account where GA_Acronym__c =:assocAccountId limit 1];
            system.debug('assocAccountList'+assocAccountList[0].id);
            List<GA_Group_Association__c> oldGAs = new List<GA_Group_Association__c>(); //to fetch all relevant Group Segment Association objects
            List<GA_Group_Association__c> updatedGAs = new List<GA_Group_Association__c>(); //to store updated GAs
            //GA_Group_Association__c ga = new GA_Group_Association__c(); //object instance for later use

            //logic for updating end date field on current record on Group Segment for GA_Association_Id__c 
            if(!listOfGS.isEmpty()){
                oldGA = listOfGS[0].GA_Association_Id__c;
                oldGAs = [select id, GA_End_Date__c,GA_Account__c from GA_Group_Association__c where GA_Account__c =: oldGA AND GA_Group_Segment__r.Status__c = 'Active' AND GA_Group_Segment__r.GA_Account__c =:accountStrngId];
                if(!oldGAs.isEmpty()){
                    for(GA_Group_Association__c ga2: oldGAs){
                        ga2.GA_End_Date__c = reqEffDate.addDays(-1);
                        updatedGAs.add(ga2);
                    }
                }
            }
            Database.SaveResult[] results = Database.update(updatedGAs,false);
            
            List<GA_Group_Association__c> updatedGAs2 = new List<GA_Group_Association__c>();
            accId = assocAccountList[0].Id;
            
            //logic for adding new records for Group Segment Association Record + simultaneously updating Group Segments
            if(listOfGS!= null && assocAccountList!= null && !listOfGS.isEmpty() && !assocAccountList.isEmpty()){
                
                for(GA_Group_Segment__c gs: listOfGS){
                    GA_Group_Association__c ga=new GA_Group_Association__c();
                    
                    ga.GA_Account__c=gs.GA_Account__c;
                    //system.debug('ga.GA_Account__c'+ga.GA_Account__c);
                    ga.GA_Group_Segment__c = gs.Id;
                    //system.debug('ga.GA_Group_Segment__c'+ga.GA_Group_Segment__c);
                    ga.GA_Start_Date__c = reqEffDate;
                    //system.debug('ga.GA_Start_Date__c'+ga.GA_Start_Date__c);
                    ga.GA_End_Date__c = reqEffDate;
                    updatedGAs2.add(ga);
                    /*ga.clear();
                    gs.GA_Association_Id__c = accId;*/
                    system.debug('gs.GA_Association_Id__c'+gs.GA_Association_Id__c);
                    listOfUpdatedGS.add(gs);
                    system.debug('listOfUpdatedGS'+listOfUpdatedGS.size());
                    system.debug('listOfUpdatedGS'+listOfUpdatedGS);
                }
                Database.SaveResult[] results3 = Database.insert(updatedGAs2, false);
                Database.SaveResult[] results2 = Database.update(listOfUpdatedGS);
                system.debug('results2'+results2);
            }

        updateGSFutureClusterCode(accountStrngId,spachnge,assocAccountId);
        }
        catch(exception e){
            //throw new AuraHandledException(e.getMessage()+e.getlinenumber());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP_createGSAssociationRecords', 'createGSARecords');
            system.debug('line number@@ MCOS '+e.getLineNumber());
            system.debug('getMessage @@ MCOS '+e.getMessage());
        }
       

    }
/*****************************************************************************************
Method Name   : updateGSFutureClusterCode
Created By   : IDC Offshore
Description  : This is the method for Updating Cluster Code Existing Group Segments
******************************************************************************************/
public static void updateGSFutureClusterCode(String accId,Boolean spaChngd,String AccclusterId)
{
    try{
        system.debug('entering:::');
        List<GA_Group_Segment__c> GSList = new List<GA_Group_Segment__c>();
        List<GA_Group_Segment__c> gsListnew=new List<GA_Group_Segment__c>();
        GSList = [select id,GA_Current_Cluster_Code__c, GA_Group_Factor_Cluster_Code__c,ARV_ContractID__c,ARV_Pending_ContractId__c,GA_Association_Id__c,GA_Carrier__c from GA_Group_Segment__c where GA_Account__c =:accId];
        system.debug('GSList'+GSList);
        Contract con=[select id,ARV_RatingArea__c from Contract where ID=:GSList[0].ARV_Pending_ContractId__c];
        String RatingArea=con.ARV_RatingArea__c;
        system.debug('RatingArea'+RatingArea);
        Set<Id> assclist= new Set<Id>();
        /*for(GA_Group_Segment__c gs: GSList)
        {
            assclist.add(gs.GA_Association_Id__c);
        }
        system.debug('assclist'+assclist);
        if(!assclist.isEmpty()){
        Account acc=[select id,ARV_Association_Cluster_Code__c from Account where id IN : assclist];
        String asscluster=acc.ARV_Association_Cluster_Code__c!=null?acc.ARV_Association_Cluster_Code__c:BCBSMCLUSTERNULL;
        system.debug('asscluster'+asscluster);
        
        system.debug('assclist'+assclist);*/
        Account assClusterAcc = new Account(); //to fetch existing Account-Association records
        
        assClusterAcc = [select id, GA_Acronym__c,ARV_Association_Cluster_Code__c from Account where GA_Acronym__c =:AccclusterId limit 1];
        system.debug('assClusterAcc'+assClusterAcc);
        String asscluster=assClusterAcc.ARV_Association_Cluster_Code__c!=null?assClusterAcc.ARV_Association_Cluster_Code__c:BCBSMCLUSTERNULL;
        system.debug('asscluster'+asscluster);
        if(spaChngd==true && RatingArea!=null)
        {
            system.debug('entering into the if::');
            for(GA_Group_Segment__c gs:GSList)
                {
                    if(gs.GA_Carrier__c==ARV_AP41_StringLiteralUtils.BCBSMVAL /*&& gs.GA_Group_Factor_Cluster_Code__c!=ARV_AP41_StringLiteralUtils.NULLSTRING*/)
                    {
                      gs.GA_Group_Factor_Cluster_Code__c='F'+RatingArea+asscluster;
                    }
                    else
                    {
                      gs.GA_Group_Factor_Cluster_Code__c=gs.GA_Current_Cluster_Code__c; 
                    }
                    gsListnew.add(gs);
                }
            if(gsListnew.size()>0)
            {
                database.update(gsListnew);
            }
        }
        //}
    }
        catch(Exception e){
        system.debug('Error att::'+e.getLineNumber()+' '+e.getMessage());
        throw new AuraHandledException('error:' +e.getMessage()+e.getlinenumber());
    }
    
    
}
}