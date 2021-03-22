public class updateAccountDC {
     public static void updateAccountDConGS(list<GA_Group_Segment__c> gSList){
        //added for US3686
        list<Account> accList=new List<Account>();
        set<id> updateAccountId=new set<id>();
        set<Id> accId=new set<id>();
        integer gsVar=0;
        if(isNoGroupSegementsDC(gSList)){
        for (GA_Group_Segment__c gsRec : gSList){
            accId.add(gsRec.GA_Account__c); 
        }
        List<Account> accounList=[select id,name,ARV_Tech_DC_SmallGroup__c from Account where id in :accId];
        for (Account accRec :accounList ){
                accRec.ARV_Tech_DC_SmallGroup__c=true;
                accList.add(accRec);
            }
        }
         else{
        for (GA_Group_Segment__c gsRec : gSList){
            accId.add(gsRec.GA_Account__c); 
        }
        for (Account accRec : [select id,name,ARV_Tech_DC_SmallGroup__c from Account where id in :accId]){
                accRec.ARV_Tech_DC_SmallGroup__c=false;
                accList.add(accRec);
            }

    	}
         if(accList.size()>0){
                update accList;
            }
     }
    
    
    private static Boolean isNoGroupSegementsDC(List<GA_Group_Segment__c> groupSegements) {
        Integer count = 0;
        for(GA_Group_Segment__c gs:groupSegements) {
            if(gs.GA_DC_Small_Group__c==false) {
                count++;
            }
        }
        
        return count>0?false:true;
    }

}