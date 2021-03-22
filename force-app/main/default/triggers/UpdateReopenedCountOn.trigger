trigger UpdateReopenedCountOn on Testing_Defect__c (before update) {

    List<Testing_Defect__c> oldDef = new List<Testing_Defect__c>((Testing_Defect__c[])Trigger.old);
    List<Testing_Defect__c> newDef = new List<Testing_Defect__c>((Testing_Defect__c[])Trigger.new);
    
    try{
        String  CurStat = newDef.get(0).Current_status__c;
        String  PrevStat = oldDef.get(0).Current_status__c;
        Decimal ReopenCount;

        if (oldDef.get(0).Times_Reopened__c <> null){
            ReopenCount = oldDef.get(0).Times_Reopened__c;
            }
        else
        	ReopenCount = 0;   
        
        if(CurStat.length()>=9){
            CurStat = newDef.get(0).Current_status__c.substring(0,9);
        }
        if(PrevStat.length()>=9){
            PrevStat = oldDef.get(0).Current_status__c.substring(0,9);
        }

        if(CurStat.equalsIgnoreCase('RE-OPENED') & !PrevStat.equalsIgnoreCase('RE-OPENED')){
            newDef[0].Times_Reopened__c = ReopenCount + 1;
        }
    }
    catch(NullPointerException e){
        System.debug(e.getMessage());
    }
}