/*******************************************************************************************************************************
@Author             :   Dilip Junapala
@Name               :   GA_CON_AP01_Owner_Update
@CreatedDate        :   19 - Apr 2018 
@Description        :   GA_CON_AP01_Owner_Update is for performing required logic on insert/update of contact.
@version            :   1.0  
********************************************************************************************************************************/
public without sharing class GA_CON_AP01_Owner_Update {
    public static boolean isExecuting = false;
    public static final string delErrMsg = 'Unable to update owner as Account owner :';
    public static final string ClsName  ='GA_CON_AP01_Owner_Update';
    public static final string methodNme  ='updateContactOwner';
    
/*******************************************************************************************************************************
@Description        :   updateContactOwner() method 
@Name               :   updateContactOwner
@Param              :   list<Contact> cntList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
        public static void updateContactOwner(list<Contact> cntList)
    {
        try{
            for(Contact con : cntList){
                con.OwnerId = con.GA_OwnerId__c;
                }                 
            }
        catch (Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            cntList[0].adderror(delErrMsg);
        }
    }
/*******************************************************************************************************************************
@Description        :   updateContactOwner() method 
@Name               :   updateContactOwner
@Param              :   list<Contact> cntList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void updateContactOwnerOnAccChange(list<Contact> cntList, map<id,Contact> cntoldMap)
    {
        try{
            for(Contact con : cntList){
                if(con.OwnerId != con.GA_OwnerId__c){
                    con.OwnerId = con.GA_OwnerId__c;
                }
            }                 
        }
        catch (Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            cntList[0].adderror(delErrMsg);
        }
    }
}