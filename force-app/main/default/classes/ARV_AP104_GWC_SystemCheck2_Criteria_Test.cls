@isTest(seealldata=false)
public class ARV_AP104_GWC_SystemCheck2_Criteria_Test {
    
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string PACKAGE1='Package';
    private static final string DENTPROD='DENTPROD';
    private static final string VISIONPROD='VISIONPROD';
    private static final string VOL='VOLUNTARYY';
    private static final string NonVOL='VOLUNTARY';
    private static final string DentalVolNewProdCode='dennvolnewprodcode';
    private static final string DentalVolOldProdCode='denvololdprodcode';
    private static final string BCNMedicalOldProdCode='bcnmedoldprodcode';
    private static final string BCNMedicalNewProdCode='bcnmednewprodcode';
    private static final string VisionNonVolProdCode='visnonvolprodcode';
    private static final string gwcCntrctName='testcntrct2';
    private static final string prevCntrctName='testcntrct1';
    private static final string GSNAME1 ='Group Segment: GS-00039775';
    private static final string GSNAME2 ='Group Segment: GS-00039776';
    private static final string PRODFAMILY1='Healthy Blue Achieve';
    private static final string PRODFAMILY2='HSA';
    private static final string BCBSMMedicalOldProdCode='bcbsmmedoldprodcode';
    private static final string BCBSMMedicalNewProdCode='bcbsmmednewprodcode';
    private static final string VisionVolOldProdCode='visvololdprodcode';
    private static final string VisionVolNewProdCode='visvolnewprodcode';
    private static final string BCBSCARRIER='BCBS';
    private static final string BCNCARRIER='BCN';
    private static final string Medical='med';
    private static final string Medical1='med1';
    private static final string NewCDHPackage='newpackage';
    private static final string OldCDHPackage='oldpackage';
    private static final string NewVisionPlan='VISIONPROD1';
    private static final string OldDentalPlan='DENTPROD1';
    private Static String GSSTATUS='In Progress';
    private static final String  SPACE='';
    private Static String NOTOFFERED='Not Offered';
    
    private static string id_cntrct(map<String,Object> dd) 
    {
        Package__C pack=[SELECT Id, ARV_Contract_Id__c FROM Package__C WHERE Name=:PACKAGE1 LIMIT 1];
        String blobdata=JSON.serialize(dd);
        pack.ARV_GWC_Package_Change_Attributes__c=blobdata;
        update pack;
        System.assert(blobdata!='Null');
        return String.valueOf(pack.ARV_Contract_Id__c);
    }
    
    @testsetup
    public static void testDataSetup()
    {
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);

        List<Contract> con=new List<Contract>();
        Contract cntrct=new Contract(AccountId=acc.id,name=prevCntrctName,
                                     ARV_RatingArea__c='A',ARV_Requested_Effective_Date__c=system.Today()+90);
        
        con.add(cntrct);
        Contract newCntrct=new Contract(AccountId=acc.id,ARV_RatingArea__c='B',
                                        ARV_Requested_Effective_Date__c=system.Today());
        newCntrct.name=gwcCntrctName;
        newCntrct.Status='In Progress';
        con.add(newCntrct);
        database.insert(con);
        system.debug('conlst'+con);
        newCntrct.Status=ARV_AP41_StringLiteralUtils.GSGWCCMP;
        newCntrct.vlocity_ins__ExpiredContractId__c=cntrct.id;
		database.update(newCntrct);      
         system.debug('newCntrct'+newCntrct.vlocity_ins__ExpiredContractId__c);
        Package__C pack=new Package__C(Name =PACKAGE1,ARV_Contract_Id__c=newCntrct.id);
        database.insert(pack);
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 

}
    
    static testmethod void gwcSystemCheck2(){
        
        Map<String,Object> blobmap=new Map<String,Object>{'New Dental Plan:'=>DENTPROD,
            'New Vision Plan:'=>VISIONPROD,
            'New Dental Type:'=>NonVOL,
            'Old Dental Type:'=>VOL,
            'New Dental Product Code:'=>DentalVolNewProdCode,
            'Old Dental Product Code:'=>DentalVolOldProdCode,
            'New Vision Type:'=>VOL,
            'Old Vision Type:'=>NonVOL,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionNonVolProdCode,
            'Old Product Family:'=>PRODFAMILY2,
            'New Product Family:'=>PRODFAMILY2,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'New CDH Package Combination:'=>NewCDHPackage,
            'Old CDH Package Combination:'=>OldCDHPackage,
            'New Carrier:'=>BCNCARRIER,
            'Old Carrier:'=>BCNCARRIER};
            String cntrctId=id_cntrct(blobmap);
        Contract con = [select id,Status,AccountId,
               ARV_Requested_Effective_Date__c,
               vlocity_ins__ExpiredContractId__c from Contract where id=:cntrctId];
        Contract parentcon  = [select id,ARV_Requested_Effective_Date__c from Contract where id=:con.vlocity_ins__ExpiredContractId__c];
        String gwcreqEffectiveDate=String.valueOf(con.ARV_Requested_Effective_Date__c);
        String prvsContrctReqEffDate=String.valueOf(parentcon.ARV_Requested_Effective_Date__c);
         user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
         system.runAs(usr1){ 
           
            try{       
                test.startTest(); 
                ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(cntrctId,gwcreqEffectiveDate,prvsContrctReqEffDate,'No','No',false);
                test.stoptest();
            }
            Catch(Exception e){
                system.debug('error'+e.getLineNumber()+','+e.getMessage());
                return;
               }
        }
        
    }
  static testmethod void gwcSystemCheck3(){
       
        Map<String,Object> blobmap=new Map<String,Object>{
            'New Dental Type:'=>VOL,
            'Old Dental Type:'=>VOL,
            'New Dental Product Code:'=>DentalVolNewProdCode,
            'Old Dental Product Code:'=>DentalVolOldProdCode
            };
        String cntrctId=id_cntrct(blobmap);
        Contract con = [select id,Status,AccountId,
               ARV_Requested_Effective_Date__c,
               vlocity_ins__ExpiredContractId__c from Contract where id=:cntrctId];
        Contract parentcon  = [select id,ARV_Requested_Effective_Date__c from Contract where id=:con.vlocity_ins__ExpiredContractId__c];
        String gwcreqEffectiveDate=String.valueOf(con.ARV_Requested_Effective_Date__c);
        String prvsContrctReqEffDate=String.valueOf(parentcon.ARV_Requested_Effective_Date__c);
            
         user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
         system.runAs(usr1){ 
           
            try{       
                test.startTest(); 
                ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(cntrctId,gwcreqEffectiveDate,prvsContrctReqEffDate,'Yes','Yes',false);
                test.stoptest();
            }
            Catch(Exception e){
                return;}
        }
        
    }
    static testmethod void gwcSystemCheck4(){
               Map<String,Object> blobmap=new Map<String,Object>{
            'New Vision Type:'=>VOL,
            'Old Vision Type:'=>NonVOL,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionNonVolProdCode
            };
            String cntrctId=id_cntrct(blobmap);
        Contract con = [select id,Status,AccountId,
               ARV_Requested_Effective_Date__c,
               vlocity_ins__ExpiredContractId__c from Contract where id=:cntrctId];
        Contract parentcon  = [select id,ARV_Requested_Effective_Date__c from Contract where id=:con.vlocity_ins__ExpiredContractId__c];
        String gwcreqEffectiveDate=String.valueOf(con.ARV_Requested_Effective_Date__c);
        String prvsContrctReqEffDate=String.valueOf(parentcon.ARV_Requested_Effective_Date__c);
         user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){ 
           
            try{       
                test.startTest(); 
                ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(cntrctId,gwcreqEffectiveDate,prvsContrctReqEffDate,'Yes','Yes',false);
                test.stoptest();
            }
            Catch(Exception e){
                return;}
        }
        
    }
    static testmethod void gwcSystemCheck5(){
               
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCBSCARRIER,
            'Old Product Family:'=>PRODFAMILY1,
            'New Product Family:'=>PRODFAMILY2,
            'Old Medical Product Code:'=>BCBSMMedicalOldProdCode,
            'New Medical Product Code:'=>BCBSMMedicalNewProdCode,
            'Old Carrier:'=>BCBSCARRIER
            };
            String cntrctId=id_cntrct(blobmap);
        Contract con = [select id,Status,AccountId,
               ARV_Requested_Effective_Date__c,
               vlocity_ins__ExpiredContractId__c from Contract where id=:cntrctId];
        Contract parentcon  = [select id,ARV_Requested_Effective_Date__c from Contract where id=:con.vlocity_ins__ExpiredContractId__c];
        String gwcreqEffectiveDate=String.valueOf(con.ARV_Requested_Effective_Date__c);
        String prvsContrctReqEffDate=String.valueOf(parentcon.ARV_Requested_Effective_Date__c);
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP104_GWC_SystemCheck2_Criteria arvGwcSysch = new ARV_AP104_GWC_SystemCheck2_Criteria();      
           try{       
                test.startTest(); 
                ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(cntrctId,gwcreqEffectiveDate,prvsContrctReqEffDate,'Yes','Yes',false);
                test.stoptest();
            }Catch(Exception e){
               return;}
        }
        
    }
    static testmethod void gwcSystemCheck6(){
             
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old CDHPckgComb:'=>OldCDHPackage,
            'New CDHPckgComb:'=>NewCDHPackage,
            'Old Carrier:'=>BCNCARRIER};
       String cntrctId=id_cntrct(blobmap);
        Contract con = [select id,Status,AccountId,
               ARV_Requested_Effective_Date__c,
               vlocity_ins__ExpiredContractId__c from Contract where id=:cntrctId];
        Contract parentcon  = [select id,ARV_Requested_Effective_Date__c from Contract where id=:con.vlocity_ins__ExpiredContractId__c];
        String gwcreqEffectiveDate=String.valueOf(con.ARV_Requested_Effective_Date__c);
        String prvsContrctReqEffDate=String.valueOf(parentcon.ARV_Requested_Effective_Date__c);
        
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP104_GWC_SystemCheck2_Criteria arvGwcSysch = new ARV_AP104_GWC_SystemCheck2_Criteria();      
           try{       
                test.startTest(); 
                ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(cntrctId,gwcreqEffectiveDate,prvsContrctReqEffDate,'Yes','Yes',false);
                test.stoptest();
            }Catch(Exception e){
                return;}
        }
        
    }
    static testmethod void gwcSystemCheck7(){
              Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>NOTOFFERED,
            'Old CDHPckgComb:'=>OldCDHPackage,
            'New CDHPckgComb:'=>NewCDHPackage,
            'Old Carrier:'=>BCNCARRIER};
        String cntrctId=id_cntrct(blobmap);
        Contract con = [select id,Status,AccountId,
               ARV_Requested_Effective_Date__c,
               vlocity_ins__ExpiredContractId__c from Contract where id=:cntrctId];
        Contract parentcon  = [select id,ARV_Requested_Effective_Date__c from Contract where id=:con.vlocity_ins__ExpiredContractId__c];
        String gwcreqEffectiveDate=String.valueOf(con.ARV_Requested_Effective_Date__c);
        String prvsContrctReqEffDate=String.valueOf(parentcon.ARV_Requested_Effective_Date__c);
        
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP104_GWC_SystemCheck2_Criteria arvGwcSysch = new ARV_AP104_GWC_SystemCheck2_Criteria();      
           try{       
                test.startTest(); 
                ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(cntrctId,gwcreqEffectiveDate,prvsContrctReqEffDate,'Yes','Yes',false);
                test.stoptest();
            }Catch(Exception e){
               return;}
        }
        
    }
  }