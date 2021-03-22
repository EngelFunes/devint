@isTest(seealldata=false)
public class ARV_AP_GWC_WorkFlowsCreation_Test{
private static final string CntrctName='testcntrct';
private static final string CntrctName2='testcntrct2';
private static final string NAME2='AP33RateGrid';
private static final string PROFILENAME1='Retention Sales';
private static final string USERNAME='bcbsm1@bcbsm.com';
    

 @testSetup static void testDataSetup(){
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        List<GA_Group_Segment__c> Gslist= new List<GA_Group_Segment__c>();
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName,
                                     ARV_Tech_SystemCheck2__c='Remove Dental,Add Common Control',ARV_Requested_Effective_Date__c=system.Today()+90,
                                     Status='In Progress'
                                   );
         database.insert(cntrct);
         cntrct.Status='Group Segment Setup Complete';
         database.update(cntrct);
         Contract cntrct2=new Contract(AccountId=acc.id,name=CntrctName2,
                                     ARV_Tech_SystemCheck2__c='Remove Dental,Add Common Control',ARV_Requested_Effective_Date__c=system.Today()+90,
                                     Status='In Progress'
                                   );
         database.insert(cntrct2);

        GA_Group_Segment__c Gs1= new GA_Group_Segment__c(ARV_ContractID__c=cntrct.id,ARV_Tech_GWC_Type__c='Add Benefit Package',GA_Account__c=acc.id,GA_Benefit_Effective_Date__c=system.Today()+90,GA_Carrier__c='BCN',ARV_Pending_ContractId__c=cntrct.id);
        Gslist.add(Gs1);
         GA_Group_Segment__c Gs2= new GA_Group_Segment__c(ARV_ContractID__c=cntrct.id,ARV_Tech_GWC_Type__c='Modify Benefit Package',GA_Account__c=acc.id,GA_Benefit_Effective_Date__c=system.Today()+90,GA_Carrier__c='BCN',ARV_Pending_ContractId__c=cntrct.id);
        Gslist.add(Gs2);
       GA_Group_Segment__c Gs3= new GA_Group_Segment__c(ARV_ContractID__c=cntrct.id,ARV_Tech_GWC_Type__c='Add Benefit Package',GA_Account__c=acc.id,GA_Benefit_Effective_Date__c=system.Today()+90,GA_Carrier__c='BCBSM',ARV_Pending_ContractId__c=cntrct.id);
        Gslist.add(Gs3);
         GA_Group_Segment__c Gs4= new GA_Group_Segment__c(ARV_ContractID__c=cntrct.id,ARV_Tech_GWC_Type__c='Modify Benefit Package',GA_Account__c=acc.id,GA_Benefit_Effective_Date__c=system.Today()+90,GA_Carrier__c='BCBSM',ARV_Pending_ContractId__c=cntrct.id);
        Gslist.add(Gs4);
	database.insert(Gslist);
     list<GA_WFT_workflow__c> wfTepltBenefitChange=new list<GA_WFT_workflow__c>();
     GA_WFT_workflow__c wft1 =new GA_WFT_workflow__c( Name='BCN GWC Benefit Change OneSource', GA_Carrier__c='BCN',
 GA_Method__c='N/A', GA_Process_Subtype__c='Benefit Change - OneSource', GA_Process_Type__c='GWC',GA_File_Type__c='Email;Other');
     GA_WFT_workflow__c wft2=new GA_WFT_workflow__c( Name='BCN GWC New Group Segment OneSource', GA_Carrier__c='BCN', 
                                                    GA_Method__c='N/A', GA_Process_Subtype__c='New Group Segment - OneSource',
                                                    GA_Process_Type__c='GWC',GA_File_Type__c='Email;Other');
     GA_WFT_workflow__c wft3=new GA_WFT_workflow__c(Name='BCBSM GWC Blue Cross OneSource Manual', GA_Carrier__c='BCBSM', 
                                                    GA_Method__c='Manual', GA_Process_Subtype__c='Blue Cross OneSource', 
                                                    GA_Process_Type__c='GWC',GA_File_Type__c='Email;Other');
    GA_WFT_workflow__c wft4=new GA_WFT_workflow__c( Name='BCBSM GWC New Group Segment OneSource Manual', GA_Carrier__c='BCBSM', 
                                                   GA_Method__c='Manual', GA_Process_Subtype__c='New Group Segment - OneSource', 
                                                   GA_Process_Type__c='GWC',GA_File_Type__c='Email;Other');
wfTepltBenefitChange.add(wft1);
     wfTepltBenefitChange.add(wft2);
     wfTepltBenefitChange.add(wft3);
     wfTepltBenefitChange.add(wft4);
     database.insert(wfTepltBenefitChange);        
        user usr = ARV_AP05_TestDataCreation.UsrRec('System Administrator');
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
    
    
    }
@isTest    
    static void manualWorkFlow() 
    {
        user usr1= [SELECT Id from User where LastName =:NAME2 limit 1];
        Contract contract=[select id ,AccountId,ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,status
                                        from Contract where name=:CntrctName limit 1];
        String Accid=string.valueof(contract.AccountId);
        List<GA_Group_Segment__c> gslist=[select id,ARV_ContractID__c,ARV_GWC_Type__c,ARV_BCN_HRA__c,
                                          ARV_BCN_HSA__c,GA_Benefit_Effective_Date__c,GA_Carrier__c
                                          from GA_Group_Segment__c where ARV_Pending_ContractId__c=:contract.id limit 4];     
        system.runAs(usr1){   
         try{       
                system.test.startTest();
                ARV_AP_GWC_WorkFlowsCreation.manualWorkFlow(gslist,contract,Accid,false,false,false,false,true); 
                system.test.stoptest();
            }Catch(Exception e){
                 system.debug('Linenumber11'+e.getLineNumber()+','+e.getMessage());
                return ;}
        }
    }
    
  @isTest    
    static void manualWorkFlow1() 
    {
        user usr1= [SELECT Id from User where LastName =:NAME2 limit 1];
        Contract contract=[select id ,AccountId,ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,status
                                        from Contract where name=:CntrctName limit 1];
        String Accid=contract.AccountId;
         List<GA_Group_Segment__c> gslist1=[select id,ARV_ContractID__c,ARV_GWC_Type__c,ARV_BCN_HRA__c,
                                          ARV_BCN_HSA__c,GA_Benefit_Effective_Date__c,GA_Carrier__c
                                          from GA_Group_Segment__c where ARV_Pending_ContractId__c=:contract.id and GA_Carrier__c='BCN' limit 2];      
        system.runAs(usr1){   
         try{       
                system.test.startTest();
                ARV_AP_GWC_WorkFlowsCreation.manualWorkFlow(gslist1,contract,Accid,false,false,false,false,false); 
                system.test.stoptest();
            }Catch(Exception e){
                 system.debug('Linenumber22'+e.getLineNumber()+','+e.getMessage());
                return ;}
        }
    }
    
     @isTest    
    static void manualWorkFlow2() 
    {
        user usr1= [SELECT Id from User where LastName =:NAME2 limit 1];
        Contract contract=[select id ,AccountId,ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,status
                                        from Contract where name=:CntrctName limit 1];
        String Accid=contract.AccountId;
         List<GA_Group_Segment__c> gslist2=[select id,ARV_ContractID__c,ARV_GWC_Type__c,ARV_BCN_HRA__c,
                                          ARV_BCN_HSA__c,GA_Benefit_Effective_Date__c,GA_Carrier__c
                                          from GA_Group_Segment__c where ARV_Pending_ContractId__c=:contract.id and GA_Carrier__c='BCBSM' limit 2];  
        
        system.debug('ARV_GWC_Type__c'+gslist2[0].ARV_GWC_Type__c);
        
        
        system.runAs(usr1){   
         try{      
                system.test.startTest();
                ARV_AP_GWC_WorkFlowsCreation.manualWorkFlow(gslist2,contract,Accid,false,false,false,false,false); 
                system.test.stoptest();
            }Catch(Exception e){
                 system.debug('Linenumber33'+e.getLineNumber()+','+e.getMessage());
                return ;}
        }
    }
}