/********************************************************************************************
Class Name   : ARV_AP_GWC_DeleteUnpackagedPlans. 
Date Created : 12-Nov-2020
Created By   : IDC Offshore 
Description  : This is used for deleting unpackaged plans from original contract after Cencos                
*******************************************************/
global without sharing class ARV_AP_GWC_DeleteUnpackagedPlans implements vlocity_ins.VlocityOpenInterface {
private Id ContractId;
public List<Package__c> pckRec{get;set;}
private static string conId='contractId';
    
/*****************************************************************************************
Method Name  : invokeMethod. 
Date Created : 12-Nov-2020
Created By   : IDC Offshore
Description  : This is the class for deleting unpackaged plans from original contract after Cencos
*******************************************************************************************/
global Boolean invokeMethod(String methodName, Map<String,Object> input,Map<String,Object> output, Map<String,Object> options){           
                                    Boolean success = true;
                                    try{
                                        if(methodName == 'gwcDeletePlans') {
                                        gwcDeletePlans(input,output,options);
                                        }
                                    }catch(Exception e){
                                    }
                                    return success;
}
public static void gwcDeletePlans(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
{
    //Map<String,Object> input, Map<String,Object> output,Map<String,Object> options
    //String contractid=conid;
    String contractId= String.valueof(input.get(conId));
    List<vlocity_ins__ContractLineItem__c> clilst=[select id,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId];
	List<Package__c> packlist =[select id,ARV_Contract_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,ARV_Pediatric_Vision_Plan__c from Package__c where ARV_Contract_Id__c=:contractId];
    System.debug('packlist:::'+packlist);
    System.debug('clilst:::'+clilst);
    System.debug('clilstCount:::'+clilst.size()); 
    List<id> planids = new List<id>();
    List<vlocity_ins__ContractLineItem__c> delclilst= new List<vlocity_ins__ContractLineItem__c>();
    if(clilst!=null){
        if(packlist!=null){
            for(vlocity_ins__ContractLineItem__c pln:clilst){
                for(Package__c pkg:packlist){
                    if(pkg.ARV_Medical_Plan__c==pln.id ||pkg.ARV_Dental_Plan__c==pln.id||pkg.ARV_Vision_Plan__c==pln.id||pkg.ARV_Pediatric_Vision_Plan__c==pln.id){
                        planids.add(pln.id);
                    }
                    //if(pkg.ARV_Pediatric_Vision_Plan__c!=null){
                      //  system.debug('planped'+pln.id);
                       // planids.add(pln.id);
                   // }
                    
                    
                }
            }
            for(vlocity_ins__ContractLineItem__c pln:clilst){
                if(!(planids.contains(pln.id))){
               delclilst.add(pln);
               }
            }
        }
        System.debug('delclilstcount:::'+delclilst.size());
        System.debug('delclilst:::'+delclilst);
        if(delclilst.size()>0)
        delete delclilst;
    }
}
}