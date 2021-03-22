@isTest(seealldata=false)
public class ARV_AP_systemCheckPackageDeletion_Test {
private static final string PROFILENAME1='System Administrator';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CntrctName='testcntrct';
    private static final string GSNAME1 ='Group Segment: GS-00039775';
    private static final string GSNAME2 ='Group Segment: GS-00039776';
    @testsetup
    public static void testDataSetup()
    {
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);

        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName);
        database.insert(cntrct);
        
        GA_Group_Segment__c gseg=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cntrct.id);
        database.insert(gseg);
        gseg.Name=GSNAME1;
        database.update(gseg);
        
        GA_Group_Segment__c gseg1=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cntrct.id);
        database.insert(gseg1);
        gseg1.Name=GSNAME2;
        database.update(gseg1);
        
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
    }
   
    static testmethod void systemCheckAfterPackageDeletion1() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        inputMap.put('contractId',cntrctId);
        
        Map<String,Object> removeSegment = new Map<String,Object>();
        String removeGSID=String.valueOf([select id,name from GA_Group_Segment__c where name=:GSNAME1 limit 1].id);
        removeSegment.put('GSId',removeGSID);
        removeSegment.put('GSCarrier','BCBSM');
        removeSegment.put('GSdenVolType','Voluntary');
        
        List<Map<String,Object>> removeSegmentList = new List<Map<String,Object>>();
        removeSegmentList.add(removeSegment);
        
        inputMap.put('GroupSegments',removeSegmentList);
        
        Map<String,Object> finalGroupSeg = new Map<String,Object>();
		String finalGSID=String.valueOf([select id,name from GA_Group_Segment__c where name=:GSNAME2 limit 1].id);	        
        finalGroupSeg.put('groupSegmentId',finalGSID);
        
        List<Map<String,Object>> finalGroupSegmentList = new List<Map<String,Object>>();
        finalGroupSegmentList.add(finalGroupSeg);
        
        inputMap.put('finalGroupSegmentsPlans',finalGroupSegmentList);

        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                     
            ARV_AP_systemCheckAfterPackageDeletion arvGwcSysch1= new ARV_AP_systemCheckAfterPackageDeletion(); 
            try{       
                system.test.startTest(); 
                arvGwcSysch1.invokemethod('systemCheckAfterPackageDeletion',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    
    static testmethod void systemCheckAfterPackageDeletion2() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        inputMap.put('contractId',cntrctId);
        
        Map<String,Object> removeSegment = new Map<String,Object>();
        String removeGSID=String.valueOf([select id,name from GA_Group_Segment__c where name=:GSNAME1 limit 1].id);
        removeSegment.put('GSId',removeGSID);
        removeSegment.put('GSCarrier','BCN');
        removeSegment.put('GSdenVolType','Voluntary');
        

        List<Map<String,Object>> removeSegmentList = new List<Map<String,Object>>();
        removeSegmentList.add(removeSegment);
        
        inputMap.put('GroupSegments',removeSegmentList);
        
        Map<String,Object> finalGroupSeg = new Map<String,Object>();
		String finalGSID=String.valueOf([select id,name from GA_Group_Segment__c where name=:GSNAME2 limit 1].id);	        
        finalGroupSeg.put('groupSegmentId',finalGSID);
        
        List<Map<String,Object>> finalGroupSegmentList = new List<Map<String,Object>>();
        finalGroupSegmentList.add(finalGroupSeg);
        
        inputMap.put('finalGroupSegmentsPlans',finalGroupSegmentList);

        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                     
            ARV_AP_systemCheckAfterPackageDeletion arvGwcSysch1= new ARV_AP_systemCheckAfterPackageDeletion(); 
            try{       
                system.test.startTest(); 
                arvGwcSysch1.invokemethod('systemCheckAfterPackageDeletion',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
}