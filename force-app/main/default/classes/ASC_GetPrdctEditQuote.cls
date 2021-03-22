/*************************************************************
Class Name   : ASC_getPrdctEditQuote
Description  : Get Prdcts to displon on 2nd and 3rrd Screen

---Modified --
@US-3253(R3) - Sequencing Products on Product Selection Screen , Added the condition on getPrdctsRem method.
*****************************************************************/
Global with sharing class ASC_GetPrdctEditQuote implements vlocity_ins.VlocityOpenInterface2{
    public list<map<string,object>> lstrec;
    /***************************************************************************************************  
Method name : invokeMethod
Param 1     : inputMap, outputMap and Options
Return Type : void
Description : To invoke the method called from Remote Action
****************************************************************************************************/
    Global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) 
    {      
        system.debug('in Class @@');
       /* if (methodName == 'getPrdctsCarout') 
        {
            system.debug('in Class mt1@@');
            getPrdctsCarout(input, output);
        }*/
        if (methodName == 'getPrdctsRem') 
        {
            system.debug('in Class mt1@@');
            getPrdctsRem(input, output);
        }
        return true;
    }
    
    public void createJson(Id Quteid,list<product2> prdct){
        system.debug('inmtcreateJson@@');
        set<id> qtpid = new set<id>();
        
        list<quotelineitem> qtl = [select Product2id from quotelineitem where quoteid = :Quteid];
        for(quotelineitem qtli : qtl){
            qtpid.add(qtli.Product2id);
        }
        system.debug('qtpid@@'+qtpid);
        lstrec = new list<map<string,object>>();
        map<string,object> mp1 ;
        for(product2 pr : prdct){
            mp1 = new map<string,object>();
            mp1.put('ProductCode',pr.productCode);
            mp1.put('Name',pr.name);
            mp1.put('Id',pr.Id);
            if(qtpid.contains(pr.id)){
                mp1.put('isSelected',true);
            }
            lstrec.add(mp1);
            system.debug('lstrec@@'+lstrec);
        }
        
    }
    /***************************************************************************************************  
Method name : getPrdctsCarout
Param 1     : input and outPut  Map
Return Type : void
Description : Get Prdcts to display on 3rd Screen.
****************************************************************************************************/
  /*  public void getPrdctsCarout(Map<String, Object> input, Map<String, Object> output){
        string qtID = (string)input.get('ContextId');
        system.debug('qtID@@'+qtID);
        list<product2> crvPrdct = [Select id,name,productCode, Family from Product2 where vlocity_ins__LineOfBusiness__c='Non-Benefit' and vlocity_ins__SubType__c='ASC Product' and vlocity_ins__Type__c='ASC Product' And vlocity_ins__RecordTypeName__c='product' And Family In('Carve-Outs','Processing Options') Order By Name ASC limit 5000];
        createJson(qtID,crvPrdct);
        system.debug('lstrec@@'+lstrec);
        output.put('records',lstrec);
    }*/
    
    /***************************************************************************************************  
Method name : getPrdctsRem
Param 1     : input and outPut  Map
Return Type : void
Description : Get Prdcts to display on 3rd Screen.
****************************************************************************************************/
    public void getPrdctsRem(Map<String, Object> input, Map<String, Object> output){
        string qtID = (string)input.get('ContextId');
        
        Set<String> familyValueSet = new Set<String>{
            'Medical','Vision','Dental','Specialty','Medicare Advantage','Drugs','BCN Medical','Hearing','MM','Medicare Supplement','CDH','Data Feeds','Admin Fees','Shared Savings','Stop-Loss','Misc Fees and Credits','Rx Add-On Services & Programs','Terms Conditions and Disclosures','Buy Ups'
                ,'Carve-Outs','Processing Options' };
                    list<product2> remPrdct = [Select Id,Name,Productcode from Product2 where Family IN:familyValueSet
                                               and RecordType.Name = 'Product'
                                               and vlocity_ins__LineOfBusiness__c = 'Non-Benefit'
                                               and vlocity_ins__SubType__c = 'ASC Product'
                                               and vlocity_ins__Type__c = 'ASC Product'
                                               and IsActive = true Order by ASC_Product_Sequence__c ASC 
                                               Limit :UTIL_SLB.retrieveQueryLimitValue()];
        
        createJson(qtID,remPrdct);
        output.put('records',lstrec);
        
    }
    
}