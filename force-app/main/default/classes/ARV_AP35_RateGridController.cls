/********************************************************************************************
    Class Name   : ARV_AP35_RateGridController. 
    Date Created : 01-July-2019
    Created By   : IDC Offshore
    Description  : This is VF Page(ARV_VF06_RateGridPage) Controller. It read data from ARV_CO01_IP_RateGridData__c object and display data in vf and generates as PDF*******************************************************/
    public without sharing class ARV_AP35_RateGridController {
        
        public Id finalquoteId{get;set;}    
        public String attachmentId{get;set;}
        public List<Quote> quoteList{get;set;}   
        private static final string AGE = 'Age';            
        private static final string IDSTRING = 'id';
        private static final String CLSNAME='ARV_AP35_RateGridController';
        private static final String METHODNAME='getRates';
        private static final String ERRORMSG='Rate Grid got failed';
        private static final string GET_USER_ATTACHMENT  = 'getUserAttachmentId';  
        private static final String ERRORMSG_ATTACHMENT =  'There was an issue getting the attachmentId ';        
        private static final String QUOTEWHERECLAUSE = '  where id = :paramId1 ' ;
        private static final String QUOTLIMITCLAUSE = '  LIMIT 50 ';        
        private static final String RATEGRIDWHERECLAUSE = ' where  ARV_HIOSPlanId__c  in :docstrings  AND '+
           ' ARV_RatingArea__c =:paramName AND ARV_EffectiveDate__c =:dateVal ';
        private static final String RATEGRIDORDERBYCLAUSE = ' order by plantype__C ASC ' ;       
        private static final String QUOTLNITMWHERECLAUSE = '  WHERE QuoteId = :paramId1  ';
        private static final String QUOTLNITMLIMITCLAUSE = '  LIMIT 50 ';    
        private static final String METADAWHERECLAUSE = '  where DeveloperName=:paramName ';
        private list<ARV_CO02_RateGridStaticData__c> rateGridlist3  = null;
        private Map<string, String> rateGridlist2  = null;
        private Map<String, object> reateMap = null;        
        private set<string> ageSet1  = null;
        private set<string> ageSet3  = null;
        private set<string> qliPrdCodeList  = null;
        public map<integer,set<AgeWrapper>> ageMap1 {get; set;}
        public map<integer,set<AgeWrapper>> ageMap2 {get; set;}    
        public map<integer,set<AgeWrapper>> ageMap3 {get; set;} 
        private set<string> ageSet2  = null;
        private List<string> tableHeaderList = null;
        public map<AgeWrapper,List<string>> rateMatrix32 {get; set;}   
        public map<AgeWrapper,List<string>> rateMatrix65 {get; set;}
        public map<AgeWrapper,List<string>> rateMatrix9999 {get; set;}
        public set<integer> tableCount {get; set;}
        public map<integer,List<string>> tableHeaderMap {get; set;}
        public integer noOftables {get; set;}
        private integer tempSize = 0;
        private Map<String, string> agePremiumMap = null;
         private Map<String, string> compPremiumMap = null;
        private boolean iterateComplete = false;
        private set<AgeWrapper> wrapObjSet1 = null;
        private set<AgeWrapper> wrapObjSet2 = null;
         private set<AgeWrapper> wrapObjSet3 = null;
        private map <string,AgeWrapper> wrapObjMap = null;
        private  Map<string,string> staticAgemap = null;
        private  Map<string,string> hiosplanIdMap = null;   
        private AgeWrapper wrapObj = null;
        private integer iRateGridSize = 0;   
        private static final String NO1='65';
        private static final String NO2='65+';
        private static final String NO3='0';
        private static final String COMPVAL='9999';
        private static final String COMP='COMP';
        private map<String,Map<String,String>> prodIdAgeRateMap = new  map<String,Map<String,String>>();
        private map<String,string> finalAgeMaP = new  map<String,String>();
        
        /************************************************************************************
        Method Name : ARV_AP35_RateGridController
        Description : This is VF consturctor to initialize data.
        ************************************************************************************/
        public ARV_AP35_RateGridController(){
            rateMatrix32 = new map<AgeWrapper,List<string>>();
            rateMatrix65 = new map<AgeWrapper,List<string>>();
            rateMatrix9999 = new map<AgeWrapper,List<string>>();
            tableHeaderMap = new map<integer,List<string>>();
            ageMap1 = new map<integer,set<AgeWrapper>>();
            ageMap2 = new map<integer,set<AgeWrapper>>();
            ageMap3 = new map<integer,set<AgeWrapper>>();
            ageSet1 = new set<string>();
            tableCount = new set<integer>();
            quoteList = new List<Quote>();
            for(integer i=0;i<=32;i++){
                ageSet1.add(string.valueOf(i));
            }
            ageSet2 = new set<string>();
            for(Integer i=33;i<=65;i++){
                ageSet2.add(string.valueOf(i));
            }
            ageSet3 = new set<string>();        
                
            ageSet3.add(COMP);      
            // to fetch the QuoteId
            finalquoteId=ApexPages.currentPage().getParameters().get(IDSTRING);
        }     
        /************************************************************************************
        Method Name : getRates
        Description : This method is invoked as VF page action. It reads data from ARV_CO01_IP_RateGridData__c and prepare data to display in UI.
        ************************************************************************************/
        public void getRates(){
           
                //Query Data
                selectDataLayer(finalquoteId);   
                //Initialize variables
                initializeVariables();
                if(!rateGridlist2.isEmpty()){
                    //It prepares data to display UI
                    setPageDisplayData();
                }
            
        }      
        /************************************************************************************
        ClassName : AgeWrapper
        Description : This is wrapper class.
        ************************************************************************************/
        public with sharing class AgeWrapper{
            public string age {get; set;}     
        }   
        /************************************************************************************
        Method Name : initializeVariables
        Description : To initialize variables. This is called from 'getRates' method.
        ************************************************************************************/
        private void initializeVariables(){
            iRateGridSize = rateGridlist2.size(); 
            wrapObjMap = new map<string,AgeWrapper>();
            wrapObjSet1 =  new set<AgeWrapper>();
            wrapObjSet2 =  new set<AgeWrapper>();
            wrapObjSet3 =  new set<AgeWrapper>();
            agePremiumMap = new map<string,string>(); //compPremiumMap
            compPremiumMap = new map<string,string>();
            tempSize = 0;
        } 
        /************************************************************************************
        Method Name : setPageDisplayData
        Description : It loops ARV_CO01_IP_RateGridData__c record and prepare data to display.This is called from 'getRates' method.
        ************************************************************************************/
        private void setPageDisplayData(){
            noOftables = getTableCount(iRateGridSize);
            tableHeaderList =  new string[tempSize];
            tableHeaderList.add(AGE);                         
            integer mInt = 0; 
            integer zInt = 0;       
            integer iRateSize = iRateGridSize;
            for(String hiosStr : hiosplanIdMap.keyset()){
                    iRateSize--;  
                    tableHeaderList.add(hiosplanIdMap.get(hiosStr));                   
                    getPremiumMap(finalAgeMaP.get(hiosStr));
                    setRateMatrixMap(ageSet1,32,mInt);
                    setRateMatrixMap(ageSet2,65,mInt);
                    setRateMatrixMap(ageSet3,9999,mInt);
                    iterateComplete = true;
                    mInt++;                    
                    if(mInt == 3 || mInt == iRateGridSize || iRateSize == 0){                                           
                            mInt = 0;
                            zInt++;                                   
                            breakTableTosetData(zInt);
                    }
            }
        }     
        /************************************************************************************
        Method Name : getTableCount
        Description : This to Table counts and prepare tableCount set for UI. This is called from 'setPageDisplayData' method.
        ************************************************************************************/
        private integer getTableCount(integer gridSize){
            Integer notables = 0;
            if(gridSize<=3){
                notables =1;
                tempSize= gridSize;
            }
            else{
                Decimal sdInt = Decimal.valueOf(gridSize);
                String toRound = string.valueOf((sdInt)/3);
                tempSize=3;
                if(toRound.length()==1){
                    notables = Integer.valueOf(toRound);                  
                }
                else{
                    Decimal decim = Decimal.valueOf(toRound);
                    notables=Integer.valueOf(decim) + 1;                  
                }               
            }
            for(Integer k=1;k<=notables;k++){
                tableCount.add(k);
            }
            return notables;
        }  
        /************************************************************************************
        Method Name : setRateMatrixMap
        Description : It set data into rateMatrix32 and rateMatrix65 maps to display in UI.This is called from 'setPageDisplayData' method.
        ************************************************************************************/
        private object setRateMatrixMap(set<string> ageSet,integer ageLimit,Integer mIntger){       
            List<string> tempList = new List<string>();
            boolean setRes = false;     
            Object  retVal = null;
            
            for(string age:ageSet){
                wrapObj = new AgeWrapper();
                if(!iterateComplete){
                    
                    // to keep 65+ if AGE IS 65
                    wrapObj.age = age==NO1?NO2:age;             
                    wrapObjMap.put(age,wrapObj);                
                    setRes = ageLimit == 32?wrapObjSet1.add(wrapObj):ageLimit == 65?wrapObjSet2.add(wrapObj):
                                         wrapObjSet3.add(wrapObj);
                                    
                }
                else{
                    wrapObj = wrapObjMap.get(age);              
                }
                
                if(ageLimit == 32){
                    tempList = rateMatrix32.get(wrapObj)!=null?rateMatrix32.get(wrapObj):new string[tempSize];
                    
                }
                else if(ageLimit == 65){
                    tempList = rateMatrix65.get(wrapObj)!=null?rateMatrix65.get(wrapObj):new string[tempSize];
                    
                }else{
                    tempList = rateMatrix9999.get(wrapObj)!=null?rateMatrix9999.get(wrapObj):new string[tempSize];
                    
                }               
                if(agePremiumMap.containsKey(age)){
                            
                    tempList.add(mIntger,(string)agePremiumMap.get(age)); 
                                
                }else if(compPremiumMap.containsKey(age)){              
                    
                     tempList.add(mIntger,(string)compPremiumMap.get(age)); 
                    
                } else{}             
               retVal = ageLimit == 32?rateMatrix32.put(wrapObj,tempList): ageLimit == 65?
			                        rateMatrix65.put(wrapObj,tempList):rateMatrix9999.put(wrapObj,tempList);
                
            }
            
            return setRes?retVal:null;
        }  
        /************************************************************************************
        Method Name : breakTableTosetData
        Description : It breaks the loop for 3 products and prepare a data to UI. This is called from 'setPageDisplayData' method.
        ************************************************************************************/
        private void breakTableTosetData(integer keyInt){                   
            List<string> tableHeaders = new List<string>(tableHeaderList);
            tableHeaderMap.put(keyInt,tableHeaders);
            ageMap1.put(keyInt,wrapObjSet1);
            ageMap2.put(keyInt,wrapObjSet2);
            ageMap3.put(keyInt,wrapObjSet3);
            
            wrapObjSet1 = new set<AgeWrapper>();
            wrapObjSet2 = new set<AgeWrapper>();                  
            wrapObjSet3 = new set<AgeWrapper>();  
            wrapObjMap = new map<string,AgeWrapper>();
            iterateComplete = false;
            if(keyInt<noOftables && (keyInt+1) != noOftables){
                tempSize = 3;
            }
            else if((keyInt+1) == noOftables){
                tempSize = iRateGridSize - (keyInt*3);                        
            }
            else{
                iterateComplete = false;
            }
            tableHeaderList =  new string[tempSize];
            tableHeaderList.add(AGE);
        }  
        /************************************************************************************
        Method Name : selectDataLayer
        Description : It queries Data from Quote and ARV_CO01_IP_RateGridData__c objects.This is called from 'getRates' method.
        ************************************************************************************/
        private void selectDataLayer(Id quoteId){
			String quotSelectQry =system.label.ARV_CL26_QUOTEQUERY;
            // setting the quoteid to paramId1 to be use in ARV_AP07_QueryDataHelper.  
            ARV_AP07_QueryDataHelper.paramId1 = quoteId;
            quoteList = ARV_AP07_QueryDataHelper.getsObjects(quotSelectQry,QUOTEWHERECLAUSE,null, QUOTLIMITCLAUSE );
            //Done as part of US2277 to read data from static object based on effective date.
            String ratingArea = quoteList[0].ARV_CF_Tech_RatingArea__c;     
            String renewalMnth =quoteList[0].Renewal_Month__c.split(ARV_AP41_StringLiteralUtils.SPACEVAL)[0];
			String metaDataQry=System.label.ARV_CL37_CM03_RATEGRIDEFFDATE_QRY;
            ARV_AP07_QueryDataHelper.paramName =renewalMnth;
            list<ARV_CM03_RateGridEffectiveDateFetch__mdt> mdt=ARV_AP07_QueryDataHelper.getsObjects(metaDataQry,
                                                                                        METADAWHERECLAUSE,null,null);         
            string mtdEDate=quoteList[0].Requested_Renewal_Date__c.year()+ARV_AP41_StringLiteralUtils.HYPHENVAL+
                											mdt[0].value__C;                       
            //passing quoteLineItems to handle back and forth issues of plans selection and deselection
			String quotLnItmSelectQry =System.label.ARV_CL23_QUOTELINEQUERY;
            list<QuoteLineItem> qlilist = new List<QuoteLineItem>();
            ARV_AP07_QueryDataHelper.paramId1 = quoteId;
            qlilist = ARV_AP07_QueryDataHelper.getsObjects(quotLnItmSelectQry,QUOTLNITMWHERECLAUSE,null, QUOTLNITMLIMITCLAUSE );
            list<string> qliStr = new list<string>();
            list<string> qliPrdList = new list<string>();
            for(QuoteLineItem qli : qlilist){
                qliPrdList.add(qli.product2.productcode);
                qliStr.add(qli.id);
            }
            processRateGrid(qliPrdList,ratingArea,mtdEDate);               
            // Calling ARV_AP29_AgentLogoUtil to get the Agent attachmentId.
            attachmentId = ARV_AP29_AgentLogoUtil.getAgentLogo(quoteId);
            
        } 
         /************************************************************************************
        Method Name : processRateGrid
        Description : It queries Data from Quote and ARV_CO01_IP_RateGridData__c objects.This is called from 'getRates' method.
        ************************************************************************************/
        private void processRateGrid(List<String> prdctsLst,String ratingArea,String effDate){
            String selectRateGridQry=System.label.ARV_CL36_CO02_RATEGRIDSTATICDATA_QRY;
            ARV_AP07_QueryDataHelper.docstrings = prdctsLst;
            ARV_AP07_QueryDataHelper.paramName = ratingArea;
            ARV_AP07_QueryDataHelper.dateVal = Date.valueOf(effDate);
            rateGridlist3 =   ARV_AP07_QueryDataHelper.getsObjects(selectRateGridQry,RATEGRIDWHERECLAUSE,
                                                                   RATEGRIDORDERBYCLAUSE, null );                   
           
            hiosplanIdMap = new Map<string,string>();
            staticAgemap = new Map<string,string>();            
            for(ARV_CO02_RateGridStaticData__c a : rateGridlist3){     
                    hiosplanIdMap.put(a.ARV_HIOSPlanId__c,a.ProductName__c);
                    staticAgemap.put(String.valueof(a.ARV_age__c),string.valueof(a.ARV_Rate__c));                
                    prodIdAgeRateMap.put(a.ARV_HIOSPlanId__c,staticAgemap);                    
                    String str = a.ARV_age__c+ARV_AP41_StringLiteralUtils.COLONVAL+a.ARV_Rate__c;                   
                    //To set the map value in the format of HiosplanIdVal+;+AgeVal+:+PremiumVal
                    finalAgeMaP.put(a.ARV_HIOSPlanId__c,finalAgeMaP.get(a.ARV_HIOSPlanId__c) !=null? 
					                finalAgeMaP.get(a.ARV_HIOSPlanId__c)+ARV_AP41_StringLiteralUtils.SEPERATOR+
                                    a.ARV_age__c+ARV_AP41_StringLiteralUtils.COLONVAL+a.ARV_Rate__c : a.ARV_age__c+
									ARV_AP41_StringLiteralUtils.COLONVAL+a.ARV_Rate__c);
            }
            rateGridlist2 = hiosplanIdMap;           
        }   
        /************************************************************************************
        Method Name : getPremiumMap
        Description : It gets premium for each age and QuoteLineItem and prepare a Map to use in other methods.
		This is called from 'setPageDisplayData' method.
        ************************************************************************************/
        private void getPremiumMap(String premiumMap){         
            
            string[] myarr = premiumMap.split(ARV_AP41_StringLiteralUtils.SEPERATOR);              
          
            for(String str : myarr ){
                string[] tarr = str.split(ARV_AP41_StringLiteralUtils.COLONVAL);
                if(tarr[0] != COMPVAL ){
                  agePremiumMap.put(tarr[0],tarr[1]);
                }
                else{
                    compPremiumMap.put(COMP,tarr[1]);
                }
            }
            
        }

    }