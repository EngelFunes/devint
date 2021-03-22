/**********************************************************************************************************************************************
@Author : Dilip
@Name: GA_AccountBatchToUpdateContactOwner 
@CreatedDate: 07 - May 2018 
@Description: GA_AccountBatchToUpdateContactOwner class to change owner on contacts on change of territory.
@version : 1.0  
**********************************************************************************************************************************************/
global class GA_AccountBatchToUpdateContactOwner implements Database.Batchable<sObject> {
    global final string query;
    global final Set<id> idLst=new Set<id>();
    public Static boolean isInvodedFrmBtch = false;
    global final Map<Id,ID> accntsIdtoProcessL = new Map<Id,ID>();
    /**Constructor*/
    global GA_AccountBatchToUpdateContactOwner(string qryUpdateContcts, Map<Id,ID> accntsIdtoProcess)
    {
        query=qryUpdateContcts;
        idLst.addAll(accntsIdtoProcess.keyset());
        accntsIdtoProcessL.putAll(accntsIdtoProcess);
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
       return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Contact> scope)
    {	
        GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
        Map<Id,Contact> conMap = New Map<Id,Contact>();
        List<Contact> cLstToUpdte = New List<Contact>();
        if(!accntsIdtoProcessL.isEmpty()){
            for(Id accId : accntsIdtoProcessL.keySet()){
                for(Contact c : scope){
                    c.ownerId = accntsIdtoProcessL.get(accId);
                    cLstToUpdte.add(c);
                }
            }
        }
        conMap.putAll(cLstToUpdte);
        
        if(conMap.size()>0){
            Database.update(conMap.values(), false);
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}