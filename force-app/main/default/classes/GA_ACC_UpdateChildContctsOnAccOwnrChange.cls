/*******************************************************************************************************************************
@Author             :   Dilip Junapala
@Name               :   GA_ACC_UpdateChildContctsOnAccOwnrChange
@CreatedDate        :   07 - May 2018 
@Description        :   GA_ACC_UpdateChildContctsOnAccOwnrChange is for performing required logic on insert/update of account.
@version            :   1.0  
********************************************************************************************************************************/
public without sharing class GA_ACC_UpdateChildContctsOnAccOwnrChange {
    public static boolean isExecuting = false;
    public static final string ErrMsg = 'Unable to update account owner on contacts :';
    public static final string ClsName  ='GA_ACC_UpdateChildContctsOnAccOwnrChange';
    public static final string methodNme  ='updateAllChildContactsOwner';
    
    /*******************************************************************************************************************************
@Description        :   updateAllChildContactsOwner() method 
@Name               :   updateAllChildContactsOwner
@Param              :   list<Contact> cntList, map<id,Contact> cntoldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    public static void updateAllChildContactsOwner(list<Account> accList, map<id,Account> accoldMap)
    {
        try{
            
            List<Contact> conListToUpdate = New List<Contact>();
            
            Map<Id,Id> accOwnerMap = New  Map<Id,Id>();
            
            for(Account acc : accList){
                if(acc.ownerId != accoldMap.get(acc.Id).ownerId){
                    accOwnerMap.put(acc.Id,acc.ownerId);
                }                 
            }
            List<Contact>  conLst = [Select Id, AccountId, OwnerId from Contact Where AccountId IN : accOwnerMap.keyset() Limit 50000];
            
            
            if(!accOwnerMap.isEmpty() && !conLst.isEmpty()) {
                for(Id accId : accOwnerMap.keyset()){
                    for(Contact con : conLst){
                        if(con.AccountId == accId){
                            con.OwnerId = accOwnerMap.get(accId);
                            conListToUpdate.add(con);
                        }
                    }
                }
            }
            Database.update(conListToUpdate);
            
        }catch (Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            accList[0].adderror(ErrMsg);
        }
    }
}