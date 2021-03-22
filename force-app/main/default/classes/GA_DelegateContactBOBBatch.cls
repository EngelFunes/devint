global class GA_DelegateContactBOBBatch implements Database.Batchable<sObject>, Database.Stateful,Schedulable {

    private  String COMPLETED_BATCH = 'Completed';
    private static integer MAX_SIZE = 8000;
    global  List<CaseShare> caseSharestobeshared = new List<CaseShare>();
    public  List<CaseShare> caseSharestobeDeleted = new List<CaseShare>();
    public  List<AccountShare> AccountShareToBeDeleted = new List<AccountShare>(); 
    public  DelegateContactBOBBatchHelper.wrapRetunLists returnWrap = new DelegateContactBOBBatchHelper.wrapRetunLists(); 
     global String query='select id, name , accountid,Active__c from contact where Active__c=true and LastModifiedDate = LAST_N_DAYS:3 and vlocity_ins__Type__c='+'\'' + System.label.Contact_Type_Delegate  + '\'' ; 
   
   // global String query='select id, name , accountid,Active__c from contact where LastModifiedDate = LAST_N_DAYS:3';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
    //id recTypeIdofcontact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(System.label.Contact_Delegate_Agent_Record_Type).getRecordTypeId();
     //   query=query+ ' and recordtype.id='+'\'' + String.valueOf(recTypeIdofcontact)  + '\'' ;

        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC,List<Contact> scope)    {
        system.debug('*******scope*******'+scope);
        List<CaseShare> caseSharestobesharedtemp = new List<CaseShare>();
       returnWrap = DelegateContactBOBBatchHelper.delegateContactAccountCaseBOB(scope);
       system.debug('returnWrap.caseShareToInsert'+returnWrap.caseShareToInsert.size());
        if( returnWrap.caseShareToInsert <> null ){              
              caseSharestobesharedtemp  = returnWrap.caseShareToInsert;
              try{ 
                  if(caseSharestobesharedtemp.size() > 0 && caseSharestobesharedtemp.size()<=MAX_SIZE){                 
                            List<Database.SaveResult> sr = Database.insert(caseSharestobesharedtemp  ,false);           
                   }else{ 
                      caseSharestobeshared.addall(caseSharestobesharedtemp);
                    }
              }catch(Exception e){     
                     system.debug(logginglevel.error,+ e.getMessage());
                     GA_LogExceptionCls.LogExcp(e, 'GA_DelegateContactBOBBatch ', 'execute');                 
              } 
              system.debug('case share in loop '+caseSharestobeshared);
        }
        if( returnWrap.caseShareToDelete <> null ){
            caseSharestobeDeleted = returnWrap.caseShareToDelete; 
        }
       
      // AccountShareToBeDeleted = returnWrap.accountsharetoDelete; 
      
    }
    global void finish(Database.BatchableContext BC)
    {
    
    system.debug('$$$$$caseSharestob111111111111111eshared$$$$$$$$'+caseSharestobeshared);
        if(caseSharestobeshared.size() > 0){
            CaseShareSeq02Batch  inserBatch=new CaseShareSeq02Batch(caseSharestobeshared);        
        Database.executeBatch(inserBatch, 1500);
        }
        if(caseSharestobeDeleted.size() > 0){
             CaseShareDeleteSeq02Batch delteBatch01 = new CaseShareDeleteSeq02Batch(caseSharestobeDeleted); 
        Database.executeBatch(delteBatch01, 200); 
        }
          GA_UpdateAORSRBOBBatch finalstageBatch = new GA_UpdateAORSRBOBBatch(); 
        Database.executeBatch(finalstageBatch, 5);  
        
        
        // CaseShareDeleteSeq02Batch delteBatch02 = new CaseShareDeleteSeq02Batch(AccountShareToBeDeleted); 
        // Database.executeBatch(delteBatch02, 200); 
        

     }
    
    
    global void execute(SchedulableContext sc) {
        GA_DelegateContactBOBBatch batch = new GA_DelegateContactBOBBatch();
        Database.executeBatch(batch, 50);
        
    }
    
    }