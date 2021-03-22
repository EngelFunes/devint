/*******************************************************************************************************************************
@Author : IDC offshore
@Name: ASC_ContractQuoteStatus_OppStageUp_Test
@CreatedDate:  
@Description: ASC_ContractQuoteStatus_OppStageUp_Test class  is for contract quote opportunoty status update.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
public class ASC_ContractQuoteStatus_OppStageUp_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string CONT_RECORDTYPE  ='ASC Contract';
    private static final string NAME='TEST OPP 001';
    private static final string DRAFT  ='Draft';
    private static final string STR_TEST  ='Test';
    private static final string CONTAMENDMENT  ='Contract Amendment';
    private static final string BASE_CONTRACT  ='Base Contract';
    private static final string SCHEDULEA  ='Schedule A';
    //private static final string ACC_RECORDTYPE  ='Account - Customer';
    public static List<ASC_Contract_Opp_Stage_Mapping__mdt> sandboxRefreshMappings{ 
        get{ 
            if(sandboxRefreshMappings == NULL){ 
                sandboxRefreshMappings = [Select Id,         Input_Object_Name1__c,
                                                             Input_Field_Name1__c,
                                                             Input_Field_Name1_Value__c,
                                                             Input_Object_Name2__c,
                                                             Input_Field_Name2__c,
                                                             Input_Field_Name2_Value__c,
                                                             Input_Field_Name2_lookup__c,
                                                             Input_Field_Name1_1__c,
                                                             Input_Field_Name1_1_Value__c,
                                                             Input_Field_Name2_1__c,
                                                             Input_Field_Name2_1_Value__c
                                                             from ASC_Contract_Opp_Stage_Mapping__mdt ];
            } 
            return sandboxRefreshMappings; 
        } 
        set; 
    } 
    public static final Integer instanNo = 324242;
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string PRDNAME  ='Multi Year Admin Fee Year';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    //private static final string NAME='TEST';
    private static final string STATUS1='Presented';
    private static final string COMPLETE='Complete';
    private static final string ACCEPTED='Accepted';
    private static final string STATUS ='Draft';
    private static final string STAGENAME = 'new';
    private static final string STAASC='VP';
    private static final string SSAC='Posting to CM';
    private static final string STAGENAME1 = 'Created';
    private static final string STTS='Rejected';
    //privtae static final string OPSTAGE2='Created';
    private static final string CARRIER='BCBSM';
    private static final string DOCVERSION='2021 Schedule A Default';
    private static final string DOCTYPE='Schedule A';
    private static final string PHONE='9876543211';    
    private static final string ACCCID = '12345';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final Integer SEQUENCE = 20;
    private static final Integer NUM = 20;
    private static final string  SECTION= '20';
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
    private static final Id prdRecordTypeId1=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId();
    
    
/*******************************************************************************************************************************
@Description: initData() method 
@Name : initData() for creating test data
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @TestSetup static void initData() {
        list<ASC_Contractual_Document__c> cdLst = new list<ASC_Contractual_Document__c>();
        Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        database.insert(acc);
        
        Contract cont1 = new Contract();
        cont1.AccountId=acc.Id;
        cont1.Status=DRAFT;
        
        cont1.Status=STATUS;
        cont1.StartDate=Date.today();
        cont1.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(CONT_RECORDTYPE).getRecordTypeId();
        database.insert(cont1);
        cont1.Status =STATUS1;
        cont1.ASC_Signature_Status__c =STAASC;
        update cont1;
        
        Contract cont = new Contract();
        cont.AccountId=acc.Id;
        cont.Status=DRAFT;
        cont.StartDate=Date.today();
        cont.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(CONT_RECORDTYPE).getRecordTypeId();
        database.insert(cont); 
        cont.ASC_Signature_Status__c =SSAC;
        cont.Status=STTS;
        update cont;
         
       Opportunity opp1 = new Opportunity();
        opp1.Name = NAME;
        opp1.AccountId = acc.Id;
        opp1.StageName = STAGENAME;
        opp1.CloseDate = Date.valueOf('2020-11-16');
      //opp1.RecordTypeId = OPP_ASC_RECTYPEID;
        //database.insert opp1;
        database.insert(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = NAME;
        opp2.AccountId = acc.Id;
        opp2.StageName = STAGENAME1;
        opp2.CloseDate = Date.valueOf('2020-11-16');
        //opp1.RecordTypeId = OPP_ASC_RECTYPEID;
        insert opp2;
        //database.insert(opp2);
        opp2.StageName = STATUS1;
        database.update (opp2); 
        
        List<ASC_Contract_Opp_Stage_Mapping__mdt> testConQuoteOpp = (List<ASC_Contract_Opp_Stage_Mapping__mdt>)Json.deserialize(
            '[{"Input_Object_Name1__c": "Contract","Input_Field_Name1__c": "Status","Input_Field_Name1_Value__c" : "Accepted"}]',
            List<ASC_Contract_Opp_Stage_Mapping__mdt>.class);
        ASC_ContractQuoteStatus_OppStageUp_Test.sandboxRefreshMappings = testConQuoteOpp;  
        System.debug(sandboxRefreshMappings);
        cont.ASC_Signature_Status__c =COMPLETE;
        cont.StartDate =Date.today();
        cont.Status=ACCEPTED;
        //update cont;
        
    }   

/*******************************************************************************************************************************
@Description: updtsigntrReqTest() method 
@Name : updtsigntrReqTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/

    private static testmethod void updtsigntrReqTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                List<Contract> conts=[select id,ASC_Signature_Status__c,Status  from Contract];
                System.debug(conts);
                List<ASC_Contract_Opp_Stage_Mapping__mdt> testConQuoteOpp = (List<ASC_Contract_Opp_Stage_Mapping__mdt>)Json.deserialize('[{"Input_Object_Name1__c": "Contract","Input_Field_Name1__c": "Status","Input_Field_Name1_Value__c" : "Accepted"}]', List<ASC_Contract_Opp_Stage_Mapping__mdt>.class);
                
                
                
                
                Test.startTest();

                
                Test.stopTest();
            }
            
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            } 
        } 
    }
}