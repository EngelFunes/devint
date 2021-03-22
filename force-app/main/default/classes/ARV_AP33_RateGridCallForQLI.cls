/*************************************************************
Class Name   : ARV_AP33_RateGridCallForQLI 
Date Created : 18-June-2019
Created By   : IDC Offshore
Description  : As part of RateGrip PDF generation, this class will call the ARV_AP34_QuoteLineItemQueueableIP class by passing each quoteLineItem **/
global with sharing class ARV_AP33_RateGridCallForQLI implements vlocity_ins.VlocityOpenInterface {
    
    private static final string CLSNAME  = 'ARV_AP33_RateGridCallForQLI';
    private static final string QLIQUEUEABLEINVOCATION  = 'qliQueueableInvocation';
    private static final string INVOKE_METHOD  = 'invokeMethod';    
    private static final String ERRORMSG=  'There was an issue processing quotelineItem to send'+
											'to ARV_AP34_QuoteLineItemQueueableIP ';
    private static final string QUOTEID  = 'quoteId';
    private static final string UPDATEQUOTE  = 'updateQuote';
    private static final string CREATEQUOTEFIRED  = 'CreateQuotefired';
    private static final string GETMETADATLABELS  = 'getMetadataLabels';       
    private static final String WHERECLAUSE  =   ' where Active__c= true ' ;        
    private static final string LIMITCLAUSE  =   ' LIMIT 50';
    private static final String QUOTEIDCM = 'quoteIdCM' ;
    private static final String QUOTENAMECM = 'quoteNameCM' ;    
    private static final String QUOTENAMEWHERECLAUSE = '  where id= : paramName  ' ;
      
    
    /*************************************************************
    Method Name   : invokeMethod 
    Date Created : 18-June-2019
    Created By   : IDC Offshore
    Description  : this method is used to invoke the qliQueueableInvocation method **/
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, 
								Map<String,Object> outMap, Map<String,Object> options)
		{  
			try{    
				if( GETMETADATLABELS.equals( methodName) ) {
					getMetadataLabels(inputMap, outMap, options);                
				}
			}catch(Exception e){ 
			   GA_LogExceptionCls.LogExcp(e, CLSNAME, INVOKE_METHOD  );
			   throw new AuraHandledException(ERRORMSG+e.getMessage());
			}
			return true;        
		}    
    
     /*************************************************************
    Method Name   : getMetadataLabels 
    Date Created : 18-June-2019
    Created By   : IDC Offshore
    Description  : This metod is used to get Custom Metadata values and passing them to Docgen template to make template urls dynamic.  **/     
    public static void getMetadataLabels(Map<String,Object> inputMap, Map<String,Object> outMap,
										 Map<String,Object> options)
		{
	    //Reading ARV_CL35_CM02_MDT_QRY	select query from custom labels.
		String metadataLabelsSelectQry=system.label.ARV_CL35_CM02_MDT_QRY;
        // calling ARV_AP07_QueryDataHelper to fetch the ARV_CM02_VlocityCustomData__mdt.
        List<ARV_CM02_VlocityCustomData__mdt> metadataList =   ARV_AP07_QueryDataHelper.getsObjects
                                                               (metadataLabelsSelectQry, WHERECLAUSE,null,LIMITCLAUSE);
		//Reading ARV_CL26_QUOTEQUERY select query from custom labels.
        String quotNameSelectQry = system.label.ARV_CL26_QUOTEQUERY; 
        try{
			for( ARV_CM02_VlocityCustomData__mdt labeldata : metadataList )
			  { 
			
				 outMap.put(labeldata.MasterLabel,labeldata.Value__c);
				 outMap.put(QUOTEIDCM ,options.get( ARV_AP41_StringLiteralUtils.QUOID));
                 ARV_AP07_QueryDataHelper.paramName = (string)options.get(QUOTEID);                  
                 list<quote> quotNameList = ARV_AP07_QueryDataHelper.getsObjects
                                                 (quotNameSelectQry, QUOTENAMEWHERECLAUSE,NULL,NULL); 
                  if(quotNameList.size()>0){
                      string qname = quotNameList[0].name;                      
                      outMap.put(QUOTENAMECM ,qname);
                  }
  
			   } 
			}catch(Exception e){
				
						GA_LogExceptionCls.LogExcp(e, CLSNAME, GETMETADATLABELS  );
						throw new AuraHandledException(ERRORMSG+e.getMessage());
					}			   
    }   
}