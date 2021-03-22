/**
@Author : IDC offshore
@Name: GA_GS_UpdatWrappingFileTPA
@CreatedDate: 1/16/2019 
@Description: GA_GS_UpdatWrappingFileTPA class
@version : 1.0  
*/
public class GA_GS_UpdatWrappingFileTPA 
{
    public static boolean isExecuting=false;
      /*******************************************************************************************************************************
@Description    :   updtwrpinFileTPA
@Name         :   updtwrpinFileTPA
@Param         :  list<GA_Group_Segment__c> gsLst,Map<Id,GA_Group_Segment__c> OldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void updtwrpinFileTPA(list<GA_Group_Segment__c> gsLst,Map<Id,GA_Group_Segment__c> OldMap){
        Set<ID> accId = new Set<ID>();
        //Set<ID>  updtAccTPA = New   Set<ID>();
        List<GA_Third_Party_Administrator_History__c> lstTPAH = new List<GA_Third_Party_Administrator_History__c>();
        
        for(GA_Group_Segment__c obj : gsLst){
            if((OldMap==null|| (OldMap.get(obj.Id).GA_Wrapping_File_TPA__c != obj.GA_Wrapping_File_TPA__c)) &&
               (obj.GA_Wrapping_File_TPA__c <> null)){
                   accId.add(obj.GA_Wrapping_File_TPA__c);
                   //updtAccTPA.add(obj.GA_Wrapping_File_TPA__c); 
               }
        }
        if(!accId.isEmpty()){
            list<GA_Group_Segment__c> grpsgmtLst=[Select Id,GA_Wrapping_File_TPA__c from GA_Group_Segment__c where GA_Wrapping_File_TPA__c IN: accId Limit 3000];
            for(GA_Group_Segment__c grpSgmnt : grpsgmtLst){
                GA_Third_Party_Administrator_History__c tpah = new GA_Third_Party_Administrator_History__c();
                tpah.GA_Group_Segment__c = grpSgmnt.Id;
                tpah.GA_File_Carrier_Name__c=grpSgmnt.GA_Wrapping_File_TPA__c;
                tpah.GA_Start_Date__c = System.today();
                lstTPAH.add(tpah);
            }
        }
        if(!lstTPAH.isEmpty()){
            Database.insert(lstTPAH);
        }
        /*if(!updtAccTPA.isEmpty()){
            List<Account> accLst = [Select id, GA_TPA__c from Account where ID IN:updtAccTPA limit 3000];
            for(Account acc : accLst){
                acc.GA_TPA__c=true;
            }
            Database.update(accLst);
        }*/
    }
}