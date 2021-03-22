/**************************************************************************************************************************
@Author : Offshore
@Name: Dfund_CreateDfundGroupSegments_Test
@CreatedDate: 08 Feb 2021
@Description: Dfund_CreateDfundGroupSegments_Test  class is used to cover Dfund_CreateDfundGroupSegments class
@version : 1.0  
****************************************************************************************************************************/
@isTest(seeAllData = false)
public class Dfund_CreateDfundGroupSegments_Test {    
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final string PROF_NAM1 = 'Integration User';
    private static final string ACCNAME  ='NAME';
    private static final string PHONE = '7207885567';
    private static final string CIDC  ='345'; 
    private static final string RENEWALYEAR  ='2019'; 
    private static final string NETWORKC  ='MOS'; 
    private static final string GROUPSGNAME  ='tESTER';  
    private static final string STATUS  ='Active';
    private static final string GROUPSGTYPE = 'Teja';
    private static final string FUNNAME  ='test';
    private static final string DFUNDTYPE  ='Credit';  
    private static final string FLATAMOUNT1  ='2455'; 
    private static final string FLATAMOUNT2 =  '25600';
    private static final string NAME1  ='XYZ';
    private static final string NAME2  = 'Kiran';
    private static final string RATINGTYPE  ='No Cluster Code'; 
    private static final Integer REMAININGAMOUNT1  = 2350; 
    private static final Decimal REMAININGAMOUNT2  = 0.0; 
    private static final Integer TOTALADJAMOUNT  = 5000;      
    private static final string WSRID =  'ZXPHX';
    private static final string ERROR =  'error';
    private static final String jsonV1='[{"groupSegType": "MOS","Id":"a1We0000003BK4eEAG","isChecked":true,"name":"GS-00020355","ratingType":"No Cluster Code","flatAmt":"30000.25"}]';
    private static final String jsonV2='[{"groupSegType": "MOS","Id":"a1We0000003BK4eEAG","isChecked":false,"name":"GS-00020355","ratingType":"No Cluster Code","flatAmt":"30000.25"}]';
    private static final String jsonV4='[{"groupSegType": "COS","Id":"a1We0000003BK4eEAG","isChecked":true,"name":"GS-00020355","ratingType":"No Cluster Code","flatAmt": null }]';
    /*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/   
    @TestSetup static void initData(){
        //insert Account
        Account acc=new Account();
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        acc.Name =ACCNAME;
        acc.Phone=PHONE;
        acc.CID__c=CIDC;
        insert acc;
        //insert Dfund Request
        Dfund_Request__c Dreq = new Dfund_Request__c();
        Dreq.Account__c=acc.Id;
        Dreq.Renewal_Year__c = RENEWALYEAR ;
        insert Dreq;
        //insert GA Group Segment
        GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        grpSgmntRec.Network__c=NETWORKC;
        grpSgmntRec.Name = GROUPSGNAME;
        grpSgmntRec.Status__c = STATUS;
        insert grpSgmntRec;
        //insert fund
        Fund__c fun=new Fund__c();
        fun.Name=FUNNAME;
        insert fun;
        //insert Dfund Request Detail
        Dfund_Request_Detail__c  dfundr = new Dfund_Request_Detail__c();
        dfundr.Dfund_Request__c=Dreq.id;
        dfundr.Dfund_Type__c =DFUNDTYPE;
        dfundr.DRD_Fund__c=fun.id;
        dfundr.Flat_Amount__c=20;
        insert dfundr;
        Dfund_Request_Detail__c  dfundr1 = new Dfund_Request_Detail__c();
        dfundr1.Dfund_Request__c=Dreq.id;
        dfundr1.Dfund_Type__c =DFUNDTYPE;
        dfundr1.DRD_Fund__c=fun.id;
        dfundr1.Flat_Amount__c=0;
        insert dfundr1;
        //insert Dfund Group segment
        Dfund_Group_Segment__c dfundgroupsegment=new Dfund_Group_Segment__c();
        dfundgroupsegment.Dfund_Request_Detail__c =  dfundr.Id;
        dfundgroupsegment.Allocated_Amount__c=0;
        insert dfundgroupsegment;
        Dfund_CreateDfundGroupSegments.gsWrapRecord gwr = new Dfund_CreateDfundGroupSegments.gsWrapRecord(); 
        gwr.flatAmt = FLATAMOUNT1;
        gwr.groupSegType = GROUPSGTYPE;
        gwr.Id = acc.Id; 
        gwr.isChecked = True;
        gwr.name = NAME1;
        gwr.ratingType = RATINGTYPE;
        Dfund_CreateDfundGroupSegments.gsListWrapper gwp = new Dfund_CreateDfundGroupSegments.gsListWrapper(True,GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc),'a1We0000003BK4eEAG', gwr,5000.0,2765);
        gwp.d = 0.5 ;
        gwp.wrapRec = gwr;
        Dfund_CreateDfundGroupSegments.gsListWrapper gwp2 = new Dfund_CreateDfundGroupSegments.gsListWrapper(True,GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc),'a1We0000003BK4eEAG', gwr,5000.0,0.0);
        gwp2.d = 0.4 ;
        gwp2.isChecked = True;
        gwp2.objAccount = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        gwp2.remainingAmt = REMAININGAMOUNT2;
        gwp2.totalAdjamount = TOTALADJAMOUNT;
        gwp2.wrapRec = gwr;         
        
        Dfund_CreateDfundGroupSegments.WrapperSelectedRecords wsr = new Dfund_CreateDfundGroupSegments.WrapperSelectedRecords();
        wsr.flatAmt = FLATAMOUNT2 ;
        wsr.Id = WSRID;
        wsr.isChecked = True;
        wsr.name = NAME2;
        Dfund_CreateDfundGroupSegments.ErrorWrapper ew = new Dfund_CreateDfundGroupSegments.ErrorWrapper();
        ew.error = ERROR;
        ew.remainingAmt = 1;
        ew.rId  = acc.Id;
        List<Dfund_CreateDfundGroupSegments.WrapperSelectedRecords> selrecList = new List<Dfund_CreateDfundGroupSegments.WrapperSelectedRecords>();
        Map<String, String> selrecMap = new Map<String, String>();
    }
    
    //*******************************************************************************************************************************
    //@Description: This test method is used to call updateGSrecords method
    //@Name : testMethodForJson
    //@Param : None
    //@Return : void
    //@throws Exception : N/A;
    //********************************************************************************************************************************/
    
    public static testmethod void testMethodForUpdate(){
        try{
            Dfund_Request_Detail__c Dobject = [Select ID,Dfund_Request__r.account__C,Dfund_Request__c,Dfund_Type__c,DRD_Fund__c,Flat_Amount__c from Dfund_Request_Detail__c limit 1 ]; 
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){ 
                Test.startTest();
                Dfund_CreateDfundGroupSegments.fetchGSWrapper(Dobject.Id);
                Dfund_CreateDfundGroupSegments.fetchGSWrapper(null);
                Test.stopTest();
                system.assert(Dobject <> null);
            }
        }
        Catch(exception e)
        {
            system.assert(e <> null);
            return;   
        }
        
    }
    //*******************************************************************************************************************************
    //@Description: This test method is used to call updateGSrecords method
    //@Name : testMethodForJson
    //@Param : None
    //@Return : void
    //@throws Exception : N/A;
    //********************************************************************************************************************************/
    
    public static testmethod void testMethodForJson(){
        try{
            Dfund_Request_Detail__c Drobject = [Select id,Dfund_Request__c,Dfund_Type__c,DRD_Fund__c,Flat_Amount__c from Dfund_Request_Detail__c limit 1];   
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){  
                Test.startTest();        
                Dfund_CreateDfundGroupSegments.updateGSrecords(jsonV1,Drobject.Id );
                Dfund_CreateDfundGroupSegments.updateGSrecords(jsonV2,Drobject.Id );
                Dfund_CreateDfundGroupSegments.updateGSrecords(jsonV4,Drobject.Id);
                Test.stopTest();
                system.assert(usr <> null);
            }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
    } 
  //*******************************************************************************************************************************
    //@Description: This test method is used to cover ASC_DfundGroupSegment_Trigger
    //@Name : testMethod1
    //@Param : None
    //@Return : void
    //@throws Exception : N/A;
    //********************************************************************************************************************************/   
   public static testmethod void testMethod1(){
        try{
            Dfund_Request_Detail__c Drobject = [Select id,Dfund_Request__c,Dfund_Type__c,DRD_Fund__c,Flat_Amount__c from Dfund_Request_Detail__c limit 1];   
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM1);
            database.insert(usr);
            system.runAs(usr){  
                Test.startTest();        
               Dfund_CreateDfundGroupSegments.updateGSrecords(jsonV4,Drobject.Id);
                Test.stopTest();
                system.assert(usr <> null);
            }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
    }  
    
}