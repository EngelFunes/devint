/*****************************************************************************************
    Class Name   : ARV_AP_DeleteContract
    Date Created : 28-SEP-2020
    Created By   : IDC Offshore
    Description  :This class is used to delete contacts on clicking cancel button in GWC flow.
    ******************************************************************************************/
 global without sharing class ARV_AP_DeleteContract implements vlocity_ins.VlocityOpenInterface2
{
    
private static final string METHODNAME1='deletecontractoncancel';    
 /*****************************************************************************************
        Mehtod Name   :  invokeMethod   
        Description  :This class is used to invoke remote methods.
        ******************************************************************************************/ 
        global Boolean invokeMethod(String methodName, Map <String, Object> inputMap,
                                       Map < String, Object > outMap, Map < String, Object > options) {
                                           
         try{
            if (methodName == METHODNAME1) 
            {
                deletecontractoncancel(inputMap,outMap,options);
            }
        }catch(Exception e){
            system.debug('Exception:::'+e.getLineNumber()+':::::'+e.getMessage());
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
}
                       return true;  
                                       }
    /*****************************************************************************************
        Mehtod Name   :  deletecontractoncancel   
        Description  :This class is used to identify unique contacts.
        ******************************************************************************************/ 
        global  void deletecontractoncancel(Map < String, Object > inputMap,
                                          Map <String, Object > outMap, Map <String, Object > options){    
             list<contract> conlist=new List<contract>();
            String contractId= String.valueof(inputMap.get('contractId'));
              system.debug(' gwc contract id is'+    contractId );  
                list<contract> con=[select id from Contract where id=:contractId];
                                              //contract con=new contract(id=contractId);
                 database.delete(con);                             
              }
}