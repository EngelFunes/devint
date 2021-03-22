@isTest(seealldata=false)
public class ARV_AP_GWCManagePCPs_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string pcpCounty='MACOMB';
    private static final string nonPcpCounty='LAPEER';
    private static final string PRD ='prd';
    private static final string PRD2 ='prd1';
    private static final string CntrctName='testcntrct';
    @testSetup static void testDataSetup()
    {
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc); 
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName);
        database.insert(cntrct);
        //create nonPcpCounty
        GA_County_Code__c nonPCPCounty1 = new GA_County_Code__c(Name=nonPcpCounty);
        database.insert(nonPCPCounty1);
        //create pcpCounty
        GA_County_Code__c pcpCounty1 = new GA_County_Code__c(Name=pcpCounty);
        database.insert(pcpCounty1);
        //product creation
        Product2 prd1 = new Product2(Name = PRD);
        database.insert(prd1);
        Product2 prd2 = new Product2(Name = PRD2);
        database.insert(prd2);
        prd1.ARV_PCPFocus_SisterPlan__c = prd2.id;
        System.debug('The Pcp Sister Plan:'+prd1);
        database.update(prd1);    
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
    }
  
    @isTest    
    static void testGWCPcp1() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> finalgroupseg = new Map<String,Object>();
        Map<String,Object> finalgroupseg2 = new Map<String,Object>();
        Map<String,Object> finalgroupseg3 = new Map<String,Object>();
        List<Map<String,Object>> gslst=new List<Map<String,Object>>();
        //pcp-countylst
        List<Object> countyList = new List<Object>();
        countyList.add(pcpCounty);
        //non pcp-countylst
        List<Object> nonPcpcountyList = new List<Object>();
        nonPcpcountyList.add(nonPcpCounty); 
        Map<String,String> prodMap = new Map<String,String>();
        for(Product2 prod1 : [select id,name from product2 limit 2]){
        prodmap.put(prod1.Name,prod1.Id);
        }
        system.debug('prodMap'+prodMap);
        finalgroupseg.put('pcpFocus',false);
        finalgroupseg.put('physicalCounty',[Select id, Name FROM GA_County_Code__c WHERE Name =:PcpCounty].Name);  
        finalgroupseg.put('medicalType','BCN');
        finalgroupseg.put('medPrdId',prodMap.get(PRD));
        gslst.add(finalgroupseg);
        
        finalgroupseg3.put('pcpFocus',false);
        finalgroupseg3.put('physicalCounty',[Select id, Name FROM GA_County_Code__c WHERE Name =:nonPcpCounty].Name);  
        finalgroupseg3.put('medicalType','BCN');
        finalgroupseg3.put('medPrdId',prodMap.get(PRD));
        gslst.add(finalgroupseg3);
        
        finalgroupseg2.put('pcpFocus',true);
        finalgroupseg2.put('physicalCounty',[Select id, Name FROM GA_County_Code__c WHERE Name =:nonPcpCounty].Name);  
        finalgroupseg2.put('medicalType','BCN');
        finalgroupseg2.put('medPrdId',prodMap.get(PRD2));
        gslst.add(finalgroupseg2);
        
        String accid=String.valueOf([select id from account limit 1].id);
        String conid=String.valueOf([select id from Contract limit 1].id);
        inputMap.put('AccountId',accid);
        inputMap.put('contractId',conid);
        inputMap.put('countyList',countyList);
        inputMap.put('finalGroupSegmentsPlans',gslst);
        
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWCManagePCPs arvProd = new ARV_AP_GWCManagePCPs();      
                       
            try{       
                system.test.startTest(); 
                arvProd.invokemethod('physExistanceRules',inputMap,outMap,options); 
                arvProd.physExistanceRules(inputMap,outMap,options);              
                system.test.stoptest();
            }Catch(Exception e){
                system.debug('line number@@ '+e.getLineNumber()); 
            system.debug('getMessage @@ '+e.getMessage());
                return ;}
        }        }
    }