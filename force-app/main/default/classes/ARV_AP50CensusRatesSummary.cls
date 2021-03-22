/*****************************************************************************************
Class Name   : ARV_AP50CensusRatesSummary 
Date Created : 21-July-2019
Created By   : Onshore
Description  : Used to clear out / delete what's deselected in the cart
******************************************************************************************/
global with sharing class ARV_AP50CensusRatesSummary implements vlocity_ins.VlocityOpenInterface2 
 {
     private static final string QUOTEID='quoteId';
     private static final string CENSUSID='censusId';
     private static final string ENROLLING='Enrolling';
     private static final string MEMBERS='member';
     private static final string PLANS='plans';
     private static final string SECTION='section3';
     private static final String QUOTSELECTQRY = 'SELECT Id,Product_Name__c,Type__c,vlocity_ins__CensusMemberId__c,'+
         'vlocity_ins__TotalPrice__c from vlocity_ins__QuoteLineItemRateBreakout__c ';
     private static final String QUOTEWHERECLAUSE = ' where vlocity_ins__QuoteId__c =:paramName';
     private static final String QUOTEORDERBYCLAUSE = ' ORDER BY vlocity_ins__CensusMemberId__c ASC';
     private static final String CENSUSMEMSELECTQRY = 'SELECT Id,vlocity_ins__LastName__c,vlocity_ins__RelatedCensusMemberId__c,'+
         'vlocity_ins__IsPrimaryMember__c,vlocity_ins__Birthdate__c,vlocity_ins__MemberType__c,Relationship__c,'+
         'MemberAge__c,vlocity_ins__FirstName__c,Status__c from vlocity_ins__GroupCensusMember__c ';
     private static final String CENSUSMEMWHERECLAUSE = ' where vlocity_ins__CensusId__c=:paramName and Status__c =:paramName1' ;
     private static final String CLSNAME='ARV_AP50CensusRatesSummary';
     private static final String METHODNAME='getData';
     private static final String ERRORMSG=  'There was an issue while fetching CensusRates';
/*************************************************************************************************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :this method is used to invoke the enrollMedicalValidation method
******************************************************************************************************/     
     global Boolean  invokeMethod(String methodName, Map < String, Object > inputMap,Map < String, Object > outMap, 
                                  Map < String, Object > options) {
    
        try{
            getData(inputMap,outMap,options);
        }catch(Exception e){
         GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME  );
         throw new AuraHandledException(ERRORMSG+e.getMessage());   
        }
        return true;    
    }
 /*************************************************************************************************************  
Method name : getData
Params     : map
Return Type : null
Description :getData() method is used to fetch censusmembers and QuotedRateBreakout records
***********************************************************************************************************/     
    public Boolean getData(Map < String, Object > inputMap,Map < String, Object > outMap, Map < String, Object > options) {
        try{
    	String quoteId= (String)inputMap.get(QUOTEID);
     	String censusId= (String)inputMap.get(CENSUSID);
     	Map<id,vlocity_ins__GroupCensusMember__c> censusMember=new Map<id,vlocity_ins__GroupCensusMember__c>([SELECT Id,vlocity_ins__LastName__c,vlocity_ins__RelatedCensusMemberId__c,
                                                                                                              vlocity_ins__IsPrimaryMember__c,vlocity_ins__Birthdate__c,vlocity_ins__MemberType__c,Relationship__c,MemberAge__c,
                                                                                                              vlocity_ins__FirstName__c,Status__c,ARV_Group_Segment__c,ARV_Group_Segment__r.name from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c=:censusId and Status__c =: ENROLLING]);	 		 
     	//ARV_AP07_QueryDataHelper.paramName = censusId;
        //ARV_AP07_QueryDataHelper.paramName1 = ENROLLING;
        //Map<id,vlocity_ins__GroupCensusMember__c> censusMember=new Map<id,vlocity_ins__GroupCensusMember__c>(ARV_AP07_QueryDataHelper.getsObjects(CENSUSMEMSELECTQRY,CENSUSMEMWHERECLAUSE,
                                                                  // NULL, null ));
        ARV_AP07_QueryDataHelper.paramName = quoteId;
        List <vlocity_ins__QuoteLineItemRateBreakout__c> quoteRateList = ARV_AP07_QueryDataHelper.getsObjects(QUOTSELECTQRY,
                                                                                                              QUOTEWHERECLAUSE, QUOTEORDERBYCLAUSE, null ); 
        List<Object> results=new List<Object>();	 
		Map<Id,List<vlocity_ins__QuoteLineItemRateBreakout__c>>	censusMbrRateMap= 
            new Map<Id,List<vlocity_ins__QuoteLineItemRateBreakout__c>>();		
        List<vlocity_ins__GroupCensusMember__c > censusMbrOrdList = new List<vlocity_ins__GroupCensusMember__c>();
        
        for(vlocity_ins__QuoteLineItemRateBreakout__c qli: quoteRateList){			
			if(!censusMbrRateMap.containsKey(qli.vlocity_ins__CensusMemberId__c)){
				censusMbrRateMap.put(qli.vlocity_ins__CensusMemberId__c, new List<vlocity_ins__QuoteLineItemRateBreakout__c>());
			}
			censusMbrRateMap.get(qli.vlocity_ins__CensusMemberId__c).add(qli);
		}		
		censusMbrOrdList = sortCensusMbrs(censusMember.values());
		for(vlocity_ins__GroupCensusMember__c member: censusMbrOrdList){
			Map<String,Object> mem=new Map<String,Object>();
            mem.put(MEMBERS,member);
            mem.put(PLANS,censusMbrRateMap.get(member.id));
            results.add(mem);			
		}      
     outMap.put(SECTION,results);
        }
         catch(Exception e){ GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME  );       
                           throw new AuraHandledException(ERRORMSG+e.getMessage());}
	 return true;	 
    }
 /*************************************************************************************************************  
Method name : sortCensusMbrs
Params     : map
Return Type : null
Description :sortCensusMbrs() method is used to sort censusmembers in such a way that dependents 
are tagged to respective employee
***********************************************************************************************************/
     public List<vlocity_ins__GroupCensusMember__c> sortCensusMbrs(List<vlocity_ins__GroupCensusMember__c> memberList){
         Map<id,List<vlocity_ins__GroupCensusMember__c>> empFamilyMap = new Map<id,List<vlocity_ins__GroupCensusMember__c>>();
         List<vlocity_ins__GroupCensusMember__c> mbrOrdrList = new List<vlocity_ins__GroupCensusMember__c>();
         for(vlocity_ins__GroupCensusMember__c member: memberList){
			if(!member.vlocity_ins__IsPrimaryMember__c){                
                id employeeid = member.vlocity_ins__RelatedCensusMemberId__c; 
                if(!empFamilyMap.containsKey(employeeid)){
                    empFamilyMap.put(employeeid,new List<vlocity_ins__GroupCensusMember__c>());
                }
                empFamilyMap.get(employeeid).add(member);
            }			
		}				
		for(vlocity_ins__GroupCensusMember__c mbr: memberList){
			if(mbr.vlocity_ins__IsPrimaryMember__c){
				mbrOrdrList.add(mbr);
				if(empFamilyMap.containsKey(mbr.id) && empFamilyMap.get(mbr.id).size() > 0){
                    mbrOrdrList.addAll(empFamilyMap.get(mbr.id));
                }
			}			
		}
         return mbrOrdrList;
     } 
     
  }