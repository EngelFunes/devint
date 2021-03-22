/*****************************************************************************************
Class Name   : GA_AP_ASEPAssnmtCls
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to assign the ASEP Ownership
******************************************************************************************/
public class GA_AP_ASEPAssnmtCls {
      public static final string assignASEPOwnership  ='assignASEPOwnership';
    public static final string ClsName  ='GA_AP_ASEPAssnmtCls';
    public static final String excepSepartr=': ';
     public static final String openSgbrc = '[' ;
    public static final String closeSgbrc = ']' ;
    public static final String commaSyb = ',' ;
    public static final String splitStr = '\\s+' ;
    public static final String blankStr = '' ;
    public static final String assignErr = ': : Assignment failed. Return to Queue to refresh and reselect.';
    public static final String successMsg = ': Successfully assigned';
    public static final string queu = 'Queue' ;
    public static final string assigned = 'Assigned';
     /**
@Description: FectWKGrpSgmntSteps() method 
@Name : FectWKGrpSgmntSteps
@Param : string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp
@Return : list<GA_WF_Group_Segment__c>
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static  List<String>  assignASEPOwnership(string asepIds,String ownrId)
    {
        try{           
           
              List<String> assignedmsg = New List<String>();
            list<GA_Agent_Sold_Enrollment__c> asepToUpdate=new list<GA_Agent_Sold_Enrollment__c>();
            string asepIdsTmp=asepIds.remove(openSgbrc).remove(closeSgbrc);
            asepIdsTmp= asepIdsTmp.replaceAll( splitStr, blankStr);
            list<id> asepIdsTmpLst=asepIdsTmp.split(commaSyb);
            set<id> asepIdsSet=new set<id>();
            asepIdsSet.addall(asepIdsTmpLst);
            if(String.isNotBlank(asepIdsTmp) ){
                list<GA_Agent_Sold_Enrollment__c> asepRecs= [Select id,ownerid,Name,owner.type from GA_Agent_Sold_Enrollment__c where id in :asepIdsSet Limit 100];
                    
                    //GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(WFGSSelectQuery,WFGSwhere+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet),GA_Util15_WFGSDataAccesHelper.BLANK,WFGSlimit).values();
                User usr = [Select id,username,name,profile.Name from User where id =: ownrId Limit 1 ];
                
               
                
                for(GA_Agent_Sold_Enrollment__c asep:asepRecs)
                {
                    if(asep.owner.type == queu ){  
                        asep.ownerId=ownrId;
                        asep.GA_ASEP_Status__c = assigned;
                        String msg = asep.Name+successMsg;
                        assignedmsg.add(msg);
                    }
                    else{
                        String msg = asep.Name+ assignErr;
                        assignedmsg.add(msg);  
                    }
                    
                    asepToUpdate.add(asep);
                }
                database.update(asepToUpdate);
            }
            
           
            
            return  assignedmsg;

           
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, assignASEPOwnership);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }

}