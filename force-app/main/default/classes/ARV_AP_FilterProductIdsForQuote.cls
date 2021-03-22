global class ARV_AP_FilterProductIdsForQuote implements vlocity_ins.VlocityOpenInterface2 {
    private static final String GETPRDIDS = 'getfilterProdids';
    private static final string CLASSNAME ='ARV_AP_FilterProductIdsForQuote';
    private static final string METHODNAME ='getfilterProdids';
   global Boolean invokeMethod(String methodName,Map<String,Object>inputMap,Map<String,Object>outMap,Map<String,Object>options){
        Boolean result = true;
       try{
           if (GETPRDIDS.equals(methodName)) {
            getfilterProdids(inputMap, outMap, options);
        	}
          }
       
       catch(Exception ex){
           system.debug('line number@@ '+ex.getLineNumber());
            system.debug('getMessage @@ '+ex.getMessage());
          GA_LogExceptionCls.LogExcp(ex, CLASSNAME, METHODNAME); throw ex; 
       }
      return result;
	}
    
    private static void getfilterProdids (Map<String,Object>inputMap,Map<String,Object>outMap,Map<String,Object>options){
        List<Object> records= (List<Object>)inputMap.get('Lineitems');
        string effdate1 =(string)inputMap.get('RenewalEffDateFormat');
        date effdate =date.valueOf(effdate1);
        set<id> prdids=new set<id>(); 
        for(Object obj:records){
            map<String,Object> m = (map<String,Object>)obj;
            string prdid=(string) m.get('Productid');
           prdids.add(prdid);
        }
      List<product2> prdts=[select id,name,vlocity_ins__ReplacementProductId__c,vlocity_ins__EndDate__c from product2 where id IN:prdids]; 
        set<string> filterPrds=New set<string>();
        for(product2 prd:prdts){
            if(prd.vlocity_ins__EndDate__c !=null && effdate > prd.vlocity_ins__EndDate__c && prd.vlocity_ins__ReplacementProductId__c !=null){
                filterPrds.add('id:'+prd.vlocity_ins__ReplacementProductId__c);
                system.debug('&&&&	prd'+filterPrds);
            }
            if(prd.vlocity_ins__EndDate__c ==null|| effdate< prd.vlocity_ins__EndDate__c){
               filterPrds.add('id:'+prd.id); 
            }
        }
        List<string>prdlst=new list<string>(filterPrds);
        system.debug('filterPrds++'+filterPrds);
        String s = String.join(prdlst, ',');
        outMap.put('prdIdfilter',s);
    }
}