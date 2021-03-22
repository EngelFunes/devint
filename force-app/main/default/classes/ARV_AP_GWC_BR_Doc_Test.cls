@isTest(seeAllData=false)
public class ARV_AP_GWC_BR_Doc_Test {
private static final string CntrctName='testcntrct';
private static final string NAME2='AP33RateGrid';
private static final string PROFILENAME1='Retention Sales';
private static final string USERNAME='bcbsm1@bcbsm.com';
private static final String title='BCBSMBNRRateSchedule';
private static final String UNTTST ='Unit.Test';
private static final blob pdf1=blob.valueOf(UNTTST);
    
@testSetup static void testDataSetup(){
     Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        List<GA_Group_Segment__c> Gslist= new List<GA_Group_Segment__c>();
        Contract cntrct=new Contract(AccountId=acc.id,
                                     ARV_Tech_SystemCheck2__c='Remove Dental',ARV_Requested_Effective_Date__c=system.Today()+90,
                                     Status='In Progress'
                                   );
        database.insert(cntrct);
        cntrct.Status='Expired';
        database.update(cntrct);
        Contract cntrct1=new Contract(AccountId=acc.id,name=CntrctName,vlocity_ins__ExpiredContractId__c=cntrct.id,
                                     ARV_Tech_SystemCheck2__c='Remove Dental',ARV_Requested_Effective_Date__c=system.Today()+90,
                                     Status='In Progress'
                                   );
         database.insert(cntrct1);
         user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
    
}
    
@isTest
    static void ARV_AP_GWC_BR_Doc(){
        
        user usr1= [SELECT Id from User where LastName =:NAME2 limit 1];
        Contract contract=[select id ,AccountId,ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,status
                                        from Contract where name=:CntrctName limit 1];
               String myString = 'StringToBlob';
               Blob myBlob = Blob.valueof(myString);
       system.runAs(usr1){   
         try{       
                system.test.startTest();
                 String cntrctid=String.valueOf(contract.id);
               
                 ARV_AP_GWC_BR_Doc ar= new ARV_AP_GWC_BR_Doc(contract.id);
               
                 ARV_AP_GWC_BR_Doc.getGroupSegmentPackageInfo(contract.id);
                 
                ID jobID = System.enqueueJob(ar);
                 system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
        
    }
@isTest
    static void ARV_AP_GWC_BR_Doc1(){
        
        user usr1= [SELECT Id from User where LastName =:NAME2 limit 1];
        Contract contract=[select id ,AccountId,ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,status
                                        from Contract where name=:CntrctName limit 1];
            system.runAs(usr1){   
         try{       
                system.test.startTest();
                 String cntrctid=String.valueOf(contract.id);
                //ARV_AP_GWC_BR_Doc.ARV_AP_GWC_BR_Doc(contract.id);                
                  ARV_AP_GWC_BR_Doc.getBNRRateSchedule(contract.id,cntrctid,'testprd','BCBSM');
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
        
    }
    @isTest
    static void ARV_AP_GWC_BR_Doc2(){
        
        user usr1= [SELECT Id from User where LastName =:NAME2 limit 1];
        Contract contract=[select id ,AccountId,ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,status
                                        from Contract where name=:CntrctName limit 1];
               String myString = 'StringToBlob';
               Blob myBlob = Blob.valueof(myString);
       system.runAs(usr1){   
         try{       
                system.test.startTest();
                 String cntrctid=String.valueOf(contract.id);
               
                 ARV_AP_GWC_BR_Doc ar= new ARV_AP_GWC_BR_Doc(contract.id);
               
                 ARV_AP_GWC_BR_Doc.getGroupSegmentPackageInfo(contract.id);
                 ARV_AP_GWC_BR_Doc.getBNRRateSchedule(contract.id,cntrctid,'testprd','BCN');
                 
                ID jobID = System.enqueueJob(ar);
                 system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
@isTest
 static void ARV_AP_GWC_BR_Doc3(){
        
        user usr1= [SELECT Id from User where LastName =:NAME2 limit 1];
        Contract contract=[select id ,AccountId,ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,status
                                        from Contract where name=:CntrctName limit 1];
        
            system.runAs(usr1){   
         try{       
                system.test.startTest();
                 String cntrctid=String.valueOf(contract.id);
                                
                  ARV_AP_GWC_BR_Doc.fileCreation('BCBSMBNRRateSchedule',pdf1,cntrctid);
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
        }
    }