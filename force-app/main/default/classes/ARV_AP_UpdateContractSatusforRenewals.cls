/*****************************************************************************************
Class Name   : ARV_AP_UpdateContractSatusforRenewals 
Created By   : IDC  Offshore
Description  :it updates the Previous future contracts status to cancelled when Renewal contract is generated. 
******************************************************************************************/
global without sharing class ARV_AP_UpdateContractSatusforRenewals implements vlocity_ins.VlocityOpenInterface2 {
  public static final string MTHD_UPDATEFUTURESTATUS='updateFutureConStatus';
  public static final string PREV_CONTRID='previousConId';
  public static final string RENW_CONTRID='generatedConId';
  public static final string C_CANCELLED='Cancelled'; 
  public static set<String> conStatus= New Set<String>{'Cancelled','Activated'};
 /*****************************************************************************************
Method Name   : invokeMethod 
Date Created : May 2020
Created By   : IDC Offshore
Description  :This is used in Remoteaction in Ip Renewals. 
******************************************************************************************/ 
    global  Boolean invokeMethod(String methodName, Map<String,Object> inputMap,Map <String, Object> outMap, 
                                 Map<String,Object> options){
      		 try{
                	if(MTHD_UPDATEFUTURESTATUS.equals(methodName)){                                                   
              			updateFutureConStatus(inputMap,outMap,options);    
                    } 
             }
             catch(Exception ex){ex.getmessage();}
             return true;
                                           
    } 
 /*****************************************************************************************
Method Name   : updateFutureConStatus 
Date Created : May 2020
Created By   : IDC Offshore
Description  :This method updates parent Renewal Contract status to Cancelled
******************************************************************************************/   
    public static void updateFutureConStatus(Map<String, Object> inputMap,Map < String, Object > outMap, 
                                         Map < String, Object > options){
                
                        String parentConId=(String)options.get(PREV_CONTRID);
                        String renConId =(String)options.get(RENW_CONTRID);
                       If(parentConId !=null && renConId!=null){
                        List<Contract>conlist = New List<Contract>();
                        for(Contract con:[select id,Status from Contract 
                                                where vlocity_ins__ExpiredContractId__c =:parentConId
                                          		and Id !=: renConId
                                                and Status NOT IN:conStatus
                                                Limit 100 ]){
                                con.Status=C_CANCELLED;
                               conlist.add(con);                     
                              }
                             if(conlist.size()>0){database.update(conlist);}
     
             }
        }
}