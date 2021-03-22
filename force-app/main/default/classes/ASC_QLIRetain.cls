/**********************************************************
Class Name   : ASC_QLIRetain
Description  : To make QLI preSelected.

---Modified --
@TD-1002 - Added the condition to avoid duplicate QLI creation when same Coverage Spec was part of two different products.
**************************************************************/
Global with sharing class ASC_QLIRetain implements vlocity_ins.VlocityOpenInterface2{
    private static final String ISSELQLIMTD='isSelQLI';
    private static final String CLSNAME='ASC_QLIRetain';
    private static final String ERRORMSG='Error';
    private static final String CONTRACTID='ctrctId';
    private static final String PRDCTCDE='ProductCode';
    private static final String RECRDS='records';
    private static final String CHLDPRDCTS='childProducts';
    private static final String ISSLCTD='isSelected';
    private static final String FNLRCD='finalrcd';
    private static final String UNDERSCORE = '_';
    /***************************************************************************************************  
Method name : invokeMethod
Param 1     : inputMap, outputMap and Options
Return Type : void
Description : To invoke the method called from Remote Action
****************************************************************************************************/
    Global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, 
                                Map<String,Object> options) 
    {      
        try{
            //if (methodName == 'isSelQLI'){
            if(ISSELQLIMTD.equalsIgnoreCase(methodName)){
                isSelQLI(input,output,options);
            }
        }
        catch(exception e){
            //system.debug('line number@@ '+e.getLineNumber());
            //system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, CLSNAME, ISSELQLIMTD);
            throw new AuraHandledException(ERRORMSG+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage()); }
        return true;
    }
    
    /***************************************************************************************************  
Method name : isSelQLI
Param 1     : inputMap, outputMap.
Return Type : void
Description : QLI Retenion in JSON
****************************************************************************************************/    
    public static void isSelQLI(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        String ctId = (String) options.get(CONTRACTID);
        Set<String> cliPrdCode = new Set<String>();
        Map<String,Object> rcdAttr = new Map<String,Object>();
        Map<String,Object> chldrecMap = new Map<String,Object>();
        Map<String,Object> inChldrecMap = new Map<String,Object>();
        List<Map<String,Object>> chldMaplst = new List<Map<String,Object>>();
        List<object> chldLstRcd  = new List<object>();
        List<object> rcds  = (List<object>)input.get(RECRDS);

        for(vlocity_ins__ContractLineItem__c pcd:[Select Id, vlocity_ins__ProductCode__c, 
                                                  vlocity_ins__Product2Id__c,
                                                  Parent_Product_Code__c 
                                                  from vlocity_ins__ContractLineItem__c where 
                                                  vlocity_ins__ContractId__c= :ctId LIMIT 10000]){
                  cliPrdCode.add(pcd.Parent_Product_Code__c+UNDERSCORE+pcd.vlocity_ins__ProductCode__c); //TD-1002 - updated ParentProduct code

        }

        for(object rcd: rcds){
            chldMaplst = new List<Map<String,Object>>();
            rcdAttr= (map<string,object>)rcd;           
            String parentProdCode =  String.valueof(rcdAttr.get(PRDCTCDE));             
            chldrecMap = (map<string,object>)rcdAttr.get(CHLDPRDCTS);
            chldLstRcd = (list<object>)chldrecMap.get(RECRDS);            
            
            for(object chdRcd : chldLstRcd){
                inChldrecMap = (Map<String,Object>)chdRcd;
                string jsCovPC = string.valueOf(inChldrecMap.get(PRDCTCDE));
                
                if(jsCovPC!= NULL){
                    if(cliPrdCode.contains(parentProdCode+UNDERSCORE+jsCovPC)){ //TD-1002 - updated ParentProduct code
                        inChldrecMap.put(ISSLCTD,true);
                    }
                }
                chldMaplst.add((Map<String,Object>)inChldrecMap);
                chldrecMap.put(RECRDS,chldMaplst);
            }
            output.put(FNLRCD,rcds); 
        }
    }
}