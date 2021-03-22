/*****************************************************************************************
Class Name   : GA_AP_CIDAdjAssnmtCls 
Date Created : 12/11/2018
Created By   : IDC Offshore
Description  : To assign the CID Adjustment records Ownership
******************************************************************************************/
public class GA_AP_CIDAdjAssnmtCls {
    public static final string assignCIDAdjOwnership  ='assignCIDAdjOwnership';
    public static final string ClsName  ='GA_AP_CIDAdjAssnmtCls';
    public static final String excepSepartr=': ';
    public static final String openSgbrc = '[' ;
    public static final String closeSgbrc = ']' ;
    public static final String commaSyb = ',' ;
    public static final String splitStr = '\\s+' ;
    public static final String blankStr = '' ;
    public static final String assignErr = ': : Assignment failed. Return to Queue to refresh and reselect.';
    public static final String successMsg = ': Successfully assigned';
    public static final string queu = 'Queue' ;
    public static final string InProgress = 'In Progress';
    public static final string ApprvlRqrd = 'Approval Required';
    /**
@Description: assignCIDAdjOwnership() method 
@Name : assignCIDAdjOwnership
@Param : string CIDAdjIds,String ownrId
@Return : list<String>
@throws Exception : AuraHandledException
*/      
    @AuraEnabled
    public static  List<String>  assignCIDAdjOwnership(string CIDAdjIds,String ownrId)
    {
        try{           
            
            List<String> assignedmsg = New List<String>();
            list<GA_CID_Adjustment__c> CIDAdjToUpdate=new list<GA_CID_Adjustment__c>();
            string CIDAdjIdsTmp=CIDAdjIds.remove(openSgbrc).remove(closeSgbrc);
            CIDAdjIdsTmp= CIDAdjIdsTmp.replaceAll( splitStr, blankStr);
            list<id> CIDAdjIdsTmpLst=CIDAdjIdsTmp.split(commaSyb);
            set<id> CIDAdjIdsSet=new set<id>();
            CIDAdjIdsSet.addall(CIDAdjIdsTmpLst);
            if(String.isNotBlank(CIDAdjIdsTmp) ){
                list<GA_CID_Adjustment__c> CIDAdjRecs= [Select id,ownerid,Name,owner.type,GA_Territory_Code_Mismatch__c,GA_Federal_Tax_ID_Mismatch__c,GA_Status__c from GA_CID_Adjustment__c where id in :CIDAdjIdsSet Limit 100];
                
                //GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(WFGSSelectQuery,WFGSwhere+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet),GA_Util15_WFGSDataAccesHelper.BLANK,WFGSlimit).values();
                User usr = [Select id,username,name,profile.Name from User where id =: ownrId Limit 1 ];
                
                
                
                for(GA_CID_Adjustment__c CIDAdj:CIDAdjRecs)
                {
                    if(CIDAdj.owner.type == queu )
                    {
                        if((CIDAdj.GA_Territory_Code_Mismatch__c == True) || (CIDAdj.GA_Federal_Tax_ID_Mismatch__c == True))
                        {
                            CIDAdj.ownerId=ownrId;
                            CIDAdj.GA_Status__c = ApprvlRqrd;
                            String msg = CIDAdj.Name+successMsg;
                            assignedmsg.add(msg);
                        }
                        else
                        {
                            CIDAdj.ownerId=ownrId;
                            CIDAdj.GA_Status__c = InProgress;
                            String msg = CIDAdj.Name+successMsg;
                            assignedmsg.add(msg);
                        }
                    }
                    else{
                        String msg = CIDAdj.Name+ assignErr;
                        assignedmsg.add(msg);  
                    }
                    
                    CIDAdjToUpdate.add(CIDAdj);
                }
                database.update(CIDAdjToUpdate);
            }
            
            
            
            return  assignedmsg;
            
            
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, assignCIDAdjOwnership);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }
    
}