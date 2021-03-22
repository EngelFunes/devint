/********************************************************************************************
Class Name   : ARV_AP44_CensusRateGridController 
Date Created : 01-July-2019
Created By   : IDC Offshore
Description  : This is VF Page(ARV_VF06_RateGridPage) Controller. It read data from ARV_CO01_IP_RateGridData__c object and display data in vf and generates as PDF.
*******************************************************/
public with sharing class ARV_AP44_CensusRateGridController{    
    public String attachmentId{get;set;}
    public List<Quote> quoteList{get;set;}
    public List<vlocity_ins__GroupCensusMember__c > censusMbrList{get;set;}
    //public Map<id,vlocity_ins__GroupCensusMember__c> censusMbrMap{get;set;}
    public integer pageCount{get;set;}
    public integer noOfTables{get;set;}
    private List<vlocity_ins__QuoteLineItemRateBreakout__c> qLBreakOutList = null;
    //public Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>> mbrBreakout{get;set;}        
    public Map<Integer,List<wrapperCensusBreakout>> censusWrapMap{get;set;}
    public Map<Integer,List<vlocity_ins__GroupCensusMember__c>> census2WrapMap{get;set;}
    private Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>> mdclMap = null;
    private Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>> dntlMap = null;
    private Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>> vsnMap = null;
    private Map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>> medicalMap = null;
    private Map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>> dentalMap = null;
    private Map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>> visionMap = null;
    //private integer tCount;
    public set<integer> tableCount {get; set;}
    private static final String QUOTESELECTQRY = 'select id,Name,QuoteNumber,ARV_IsCensus2Check__c,'+
    'ARV_CF02_SelectedPlans__c,Account.name,vlocity_ins__GroupCensusId__c from Quote ';
    private static final String QUOTEWHERECLAUSE = '  where id = :paramId1 ' ;
    private static final string CENSUSMBRSLCTQUERY = System.Label.ARV_CL29_CensusMbrQuery;
    private static final string CENSUSMBRWHRCLAUSE = ' where vlocity_ins__CensusId__c = :paramId1 '+
        'and Status__c=: paramName1 ';
    private static final String QUOTEBRKOUTSLCTQRY = 'select id,vlocity_ins__CensusMemberId__c,Product_Id__r.name,'+
    'vlocity_ins__TotalPrice__c,TotalPriceText__c,Product_Id__r.vlocity_ins__Type__c '+
        'from vlocity_ins__QuoteLineItemRateBreakout__c ';
    private static final String BRKOUTWHERECLAUSE = '  where vlocity_ins__QuoteId__c = :paramId1 ' ;
    public Id quoteId{get;set;} 
    //public Id quoteId = '0Q0n0000000GLv2CAG';//0Q0n0000000G2srCAC;0Q0n0000000G2vCCAS
    public String census2Check{get;set;}
    public String quoteName{get;set;}
    public boolean medicalLob{get;set;}
    public boolean dentalLob{get;set;}
    public boolean visionLob{get;set;}
    private static final string ENROLLING = 'Enrolling';
    private static final string MEDICAL = 'Medical';
    private static final string DENTAL = 'Dental';
    private static final string VISION = 'Vision';
    private static final string IDSTRING = 'id';    
    private static final string CENSUSNO='No' ;
    private static final string PRIMARY = 'primary';
    private static final string TEMPCOUNT1 = 'tempCount1';
    private static final string TEMPCOUNT2 = 'tempCount2';
    private static final string DOLLAR = '$';
    private List<vlocity_ins__QuoteLineItemRateBreakout__c> productNames = null;
    private Map<id,vlocity_ins__GroupCensusMember__c> censusMbrTempMap = null;
    private string maxProduct;    
    private integer maxDisplay = Integer.valueOf(System.Label.ARV_CL31_CensusRatePageSize);
    private integer maxDisplay2 = Integer.valueOf(System.Label.ARV_CL32_Census2RatePageSize);
    private integer pboCount = 0;
    private integer dntlCount = 0;
    private integer vsnCount = 0;
    private map<integer,set<Id>> tableCensusMap = null;
    /************************************************************************************
    Method Name : ARV_AP44_CensusRateGridController
    Description : This is VF consturctor to initialize data.
    ************************************************************************************/
    public ARV_AP44_CensusRateGridController(){ 
        quoteList= new List<Quote>();
        censusMbrList = new List<vlocity_ins__GroupCensusMember__c>(); 
        qLBreakOutList = new List<vlocity_ins__QuoteLineItemRateBreakout__c>();
        //mbrBreakout = new Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>>();        
        censusWrapMap = new Map<Integer,List<wrapperCensusBreakout>>();
        census2WrapMap = new Map<Integer,List<vlocity_ins__GroupCensusMember__c>>();
        mdclMap = new Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>>();
        dntlMap = new Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>>();
        vsnMap = new Map<id,List<vlocity_ins__QuoteLineItemRateBreakout__c>>();
        tableCount = new set<Integer>();
        productNames = new List<vlocity_ins__QuoteLineItemRateBreakout__c>();        
        pageCount = 1; 
        censusMbrTempMap = new Map<id,vlocity_ins__GroupCensusMember__c>();
        quoteId=ApexPages.currentPage().getParameters().get(IDSTRING);
    }     
    /************************************************************************************
    Method Name : getCensusRates
    Description : This method is invoked as VF page action.
    ************************************************************************************/
    public void getCensusRates(){
        try{
            //Query Data
            ARV_AP07_QueryDataHelper.paramId1 = quoteId;
            quoteList = ARV_AP07_QueryDataHelper.getsObjects(QUOTESELECTQRY,QUOTEWHERECLAUSE,null, null );                                  
            id censusId = quoteList[0].vlocity_ins__GroupCensusId__c;
            census2Check = quoteList[0].ARV_IsCensus2Check__c;
            quoteName = quoteList[0].Name;
            medicalLob = quoteList[0].ARV_CF02_SelectedPlans__c.contains(MEDICAL)?true:false;
            dentalLob = quoteList[0].ARV_CF02_SelectedPlans__c.contains(DENTAL)?true:false;
            visionLob = quoteList[0].ARV_CF02_SelectedPlans__c.contains(VISION)?true:false;
            ARV_AP07_QueryDataHelper.paramId1 = censusId;
            ARV_AP07_QueryDataHelper.paramName1 = ENROLLING;             
            List<vlocity_ins__GroupCensusMember__c > mbrOrdList = queryData();
            if(census2Check == CENSUSNO ||String.isBlank(census2Check)){
                ARV_AP07_QueryDataHelper.paramId1 = quoteId;
                qLBreakOutList = ARV_AP07_QueryDataHelper.getsObjects(QUOTEBRKOUTSLCTQRY,BRKOUTWHERECLAUSE,null, null ); 
                productBreakout();
                memberLevelBreakout(); 
            }
            else{
                censusMbrList=mbrOrdList;
                createCensus2Data(censusMbrList);                
            }
            attachmentId = ARV_AP29_AgentLogoUtil.getAgentLogo(quoteId);           
        }
        catch(exception e){
            return;
        }
    }
    /************************************************************************************
    Method Name : createCensus2Data
    Description : This method is used to create a map with pagenumber and list of censusMembers
    ************************************************************************************/
    private void createCensus2Data(List<vlocity_ins__GroupCensusMember__c> censusTempList){
        for(vlocity_ins__GroupCensusMember__c member: censusTempList){
            if(member.Dental_Product_Id__r.Name != null && !dentalLob){
                dentalLob = true;
                break;
            }
        }
        integer tabCount = 1;
        for(vlocity_ins__GroupCensusMember__c member: censusTempList){
            pboCount++;                 
            if(!census2WrapMap.containsKey(tabCount)){
                census2WrapMap.put(tabCount,new List<vlocity_ins__GroupCensusMember__c>());
            }
            census2WrapMap.get(tabCount).add(member);   
            if(pboCount == maxDisplay2){
                pboCount = 0;
                tabCount++;
            }
        }
        for(Integer k=1;k<=census2WrapMap.size();k++){
            tableCount.add(k);
        }
        noOfTables=census2WrapMap.size();   
    }
    /************************************************************************************
    Method Name : queryData
    Description : This method is used to create a map with censusmemberId and list of QuoteLineItemBreakout for 
    each type(Medical, Dental, Vision)
    ************************************************************************************/ 
    private List<vlocity_ins__GroupCensusMember__c > queryData(){
        List<vlocity_ins__GroupCensusMember__c > censusList = new List<vlocity_ins__GroupCensusMember__c >();
        censusList = ARV_AP07_QueryDataHelper.getsObjects(CENSUSMBRSLCTQUERY,CENSUSMBRWHRCLAUSE,null, null );        
        Map<id,vlocity_ins__GroupCensusMember__c> empMap = new Map<id,vlocity_ins__GroupCensusMember__c>();
        Map<id,List<vlocity_ins__GroupCensusMember__c>> empFamilyMap = new Map<id,List<vlocity_ins__GroupCensusMember__c>>();           
            
        for(vlocity_ins__GroupCensusMember__c member: censusList){
            member.vlocity_ins__FirstName__c = (member.vlocity_ins__FirstName__c!=null && member.vlocity_ins__FirstName__c.length()>6)? 
                formatName(member.vlocity_ins__FirstName__c) : member.vlocity_ins__FirstName__c;
            member.vlocity_ins__LastName__c = (member.vlocity_ins__LastName__c !=null && !String.valueOf(member.id).contains(member.vlocity_ins__LastName__c) && member.vlocity_ins__LastName__c.length()>6)? 
                formatName(member.vlocity_ins__LastName__c) : member.vlocity_ins__LastName__c;
            if(member.vlocity_ins__IsPrimaryMember__c && !empMap.containsKey(member.id)){
                empMap.put(member.Id,member);
            }
        }
        for(vlocity_ins__GroupCensusMember__c member: censusList){
            if(!member.vlocity_ins__IsPrimaryMember__c){
                //id employeeid = member.vlocity_ins__IsPrimaryMember__c? member.id:member.vlocity_ins__RelatedCensusMemberId__c;
                id employeeid = member.vlocity_ins__RelatedCensusMemberId__c; 
                if(!empFamilyMap.containsKey(employeeid)){
                    empFamilyMap.put(employeeid,new List<vlocity_ins__GroupCensusMember__c>());
                }
                empFamilyMap.get(employeeid).add(member);
            }
        }
        List<vlocity_ins__GroupCensusMember__c > censusMbrOrdList = new List<vlocity_ins__GroupCensusMember__c>();
        for(vlocity_ins__GroupCensusMember__c member: censusList){
            if(member.vlocity_ins__IsPrimaryMember__c){
                censusMbrOrdList.add(member);
                if(empFamilyMap.containsKey(member.id) && empFamilyMap.get(member.id).size() > 0){
                    censusMbrOrdList.addAll(empFamilyMap.get(member.id));
                }
            }
        }           
        for(vlocity_ins__GroupCensusMember__c member: censusMbrOrdList){                        
            censusMbrTempMap.put(member.Id,member);
        }        
        return censusMbrOrdList;
    }
    /************************************************************************************
    Method Name : formatName
    Description : This method is used to wrap the name in pdf if it has more than six characters
    ************************************************************************************/     
    private String formatName(String name){
        String fName = name;
        List<Integer> sortList = new List<Integer>();                   
        integer nameCount =0;
        for (Integer i = 0; i< fName.length(); i++) {                   
            sortList.add(fName.charAt(i));
            nameCount++;
            if(nameCount == 10){
                sortList.add(32);
                nameCount = 0;
            }
        }       
        fName = String.fromCharArray(sortList);                     
        return fName;
    }
    /************************************************************************************
    Method Name : productBreakout
    Description : This method is used to create a map with censusmemberId and list of QuoteLineItemBreakout for 
    each type(Medical, Dental, Vision)
    ************************************************************************************/    
    private void productBreakout(){
        set<Id> censusIdSet = new set<Id>();
        for(vlocity_ins__QuoteLineItemRateBreakout__c QlB : qLBreakOutList){            
            QlB.TotalPriceText__c = DOLLAR + String.valueOf(QlB.vlocity_ins__TotalPrice__c);
            censusIdSet.add(QlB.vlocity_ins__CensusMemberId__c);                 
            if(QlB.Product_Id__r.vlocity_ins__Type__c == MEDICAL){
                if(!mdclMap.containsKey(QlB.vlocity_ins__CensusMemberId__c)){
                    mdclMap.put(QlB.vlocity_ins__CensusMemberId__c,new List<vlocity_ins__QuoteLineItemRateBreakout__c>());
                }                               
                mdclMap.get(QlB.vlocity_ins__CensusMemberId__c).add(QlB);
            }
            else if(QlB.Product_Id__r.vlocity_ins__Type__c == DENTAL){
                if(!dntlMap.containsKey(QlB.vlocity_ins__CensusMemberId__c)){
                    dntlMap.put(QlB.vlocity_ins__CensusMemberId__c,new List<vlocity_ins__QuoteLineItemRateBreakout__c>());
                }
                dntlMap.get(QlB.vlocity_ins__CensusMemberId__c).add(QlB);
                
            }else {
                if(!vsnMap.containsKey(QlB.vlocity_ins__CensusMemberId__c)){
                    vsnMap.put(QlB.vlocity_ins__CensusMemberId__c,new List<vlocity_ins__QuoteLineItemRateBreakout__c>());
                }
                vsnMap.get(QlB.vlocity_ins__CensusMemberId__c).add(QlB);
            } 
        }         
        dentalLob = dntlMap.size()>0?true:false;
        for(Id mbrid: censusMbrTempMap.keySet()){           
            if(censusIdSet.contains(mbrid)){
                censusMbrList.add(censusMbrTempMap.get(mbrid));
            }
        }
                
    }
/************************************************************************************
    Method Name : getPrdMap
    Description : This method is used to break the data in to 9 rows in each table
    ************************************************************************************/      
    private map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>> getPrdMap(
        map<Id, List<vlocity_ins__QuoteLineItemRateBreakout__c>> bPrdMap, 
        vlocity_ins__GroupCensusMember__c censusRec,
        boolean maxPrd,integer tCount,string temp1){        
        integer tabCount = tCount;
        map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>> prdMap = 
            new map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>>();                       
        //integer prdSize=maxDisplay;     
        if(bPrdMap.containsKey(censusRec.Id)){  
            
            for(vlocity_ins__QuoteLineItemRateBreakout__c qlb: bPrdMap.get(censusRec.Id))
            {                
                if(!prdMap.containsKey(censusRec.Id+String.valueOf(tabCount) )){
                    prdMap.put(censusRec.Id+String.valueOf(tabCount),new List<vlocity_ins__QuoteLineItemRateBreakout__c>());
                }
                prdMap.get(censusRec.Id+String.valueOf(tabCount) ).add(qlb);                              
                pboCount = maxPrd?pboCount+1:pboCount;
                dntlCount = !maxPrd&&temp1 == TEMPCOUNT1?dntlCount+1:dntlCount;
                vsnCount = !maxPrd&&temp1 == TEMPCOUNT2?vsnCount+1:vsnCount;                
                
                if(maxPrd){                 
                    if(!tableCensusMap.containsKey(tabCount)){
                        tableCensusMap.put(tabCount,new set<Id>());
                    }
                    tableCensusMap.get(tabCount).add(censusRec.Id);                 
                }                               
                if(pboCount ==  maxDisplay){                    
                    tabCount = tabCount+1;
                    pageCount = maxPrd?pageCount+1:pageCount;                   
                    pboCount= 0;                    
                }
                if(dntlCount == maxDisplay && temp1 == TEMPCOUNT1){
                    tabCount = tabCount+1;
                    dntlCount= 0;
                }
                if(vsnCount == maxDisplay && temp1 == TEMPCOUNT2){
                    tabCount = tabCount+1;
                    vsnCount= 0;
                }               
            }           
        }
        return  prdMap; 
    }
/************************************************************************************
    Method Name : productBreakout2
    Description : This method is used to break the data based on category having the highest products selected
    ************************************************************************************/        
    private void productBreakout2(){
        medicalMap = new map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>>();
        dentalMap = new map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>>();
        visionMap = new map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>>(); 
        //map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>> tempMap = new map<string, List<vlocity_ins__QuoteLineItemRateBreakout__c>>();
        tableCensusMap =  new map<integer,set<Id>> ();
        integer tempCount = 0;         
        pageCount = 1;
        for(vlocity_ins__GroupCensusMember__c census : censusMbrList){            
            tempCount =  pageCount;
            if(maxProduct == MEDICAL && !mdclMap.isEmpty()){                
                medicalMap.putAll(getPrdMap(mdclMap,census,true,tempCount,PRIMARY));                
                dentalMap.putAll(getPrdMap(dntlMap,census,false,tempCount,TEMPCOUNT1));                
                visionMap.putAll(getPrdMap(vsnMap,census,false,tempCount,TEMPCOUNT2));                
            }
            else if(maxProduct == DENTAL && !dntlMap.isEmpty()){
                dentalMap.putAll(getPrdMap(dntlMap,census,true,tempCount,PRIMARY));
                medicalMap.putAll(getPrdMap(mdclMap,census,false,tempCount,TEMPCOUNT1));               
                visionMap.putAll(getPrdMap(vsnMap,census,false,tempCount,TEMPCOUNT2));
            }
            else if(!vsnMap.isEmpty()){
                visionMap.putAll(getPrdMap(vsnMap,census,true,tempCount,PRIMARY));
                dentalMap.putAll(getPrdMap(dntlMap,census,false,tempCount,TEMPCOUNT1));
                medicalMap.putAll(getPrdMap(mdclMap,census,false,tempCount,TEMPCOUNT2));
            }else{}
            
            dntlCount = pboCount;
            vsnCount = pboCount;                                                                                
        }        
        for(Integer k=1;k<=tableCensusMap.size();k++){
            tableCount.add(k);
        }
        noOfTables=tableCensusMap.size();        
    }
    
    /************************************************************************************
    Method Name : memberLevelBreakout
    Description : This method is used to take a map of censusid and related quotedRatebreakout records for each product category
    ************************************************************************************/   
    private void memberLevelBreakout(){        
        getProductSize();
        productBreakout2();        
        for(Integer count: tableCount){            
            List<wrapperCensusBreakout> censusMbrWrap = new List<wrapperCensusBreakout>();            
            for(Id mbr: tableCensusMap.get(count) ){                
                List<vlocity_ins__QuoteLineItemRateBreakout__c> mdclList = new List<vlocity_ins__QuoteLineItemRateBreakout__c>();
                List<vlocity_ins__QuoteLineItemRateBreakout__c> dntlList = new List<vlocity_ins__QuoteLineItemRateBreakout__c>();
                List<vlocity_ins__QuoteLineItemRateBreakout__c> vsnList = new List<vlocity_ins__QuoteLineItemRateBreakout__c>();
                                               
                if(medicalMap.containsKey(mbr+String.valueOf(count) ) ){                                 
                    mdclList=medicalMap.get(mbr+String.valueOf(count) );
                }                
                if(dentalMap.containsKey(mbr+String.valueOf(count) )){                   
                    dntlList=dentalMap.get(mbr+String.valueOf(count));
                }                
                if(visionMap.containsKey(mbr+String.valueOf(count) )){                   
                    vsnList=visionMap.get(mbr+String.valueOf(count));
                }                
               productNames = maxProduct == MEDICAL?mdclList: (maxProduct == DENTAL?dntlList:vsnList);
                if(medicalMap.containsKey(mbr+String.valueOf(count) ) || dentalMap.containsKey(mbr+String.valueOf(count) ) ||
                   visionMap.containsKey(mbr+String.valueOf(count) )){
                    censusMbrWrap.add(new wrapperCensusBreakout(censusMbrTempMap.get(mbr),mdclList,dntlList,vsnList,productNames));
                    censusWrapMap.put(count,new list<wrapperCensusBreakout>(censusMbrWrap));                
                }
            }             
        }        
    }
    /************************************************************************************
    Method Name : getProductSize
    Description : This method is used to get the maximum products selected in each category
    ************************************************************************************/       
    private void getProductSize(){
        Integer mdclSize = !mdclMap.isEmpty()?mdclMap.values()[0].size():0;
        Integer dntlSize = !dntlMap.isEmpty()?dntlMap.values()[0].size():0;
        Integer vsnSize =  !vsnMap.isEmpty()?vsnMap.values()[0].size():0;
        if(mdclSize >= dntlSize){
            if(mdclSize >= vsnSize){
                productNames = mdclMap.values()[0];
                maxProduct = MEDICAL;
            }
            else{
                productNames = vsnMap.values()[0];
                maxProduct = VISION;
            }       
        }
        else if(dntlSize >= vsnSize){
            productNames = dntlMap.values()[0];
            maxProduct = DENTAL;
        }
        else{
            productNames = vsnMap.values()[0];
            maxProduct = VISION;
        }
    }
    
/************************************************************************************
Wrapper Class Name : wrapperCensusBreakout
Description : This wrapper class is used to hold the data of censusMember and the list of QuoteLineItemRateBreakout 
************************************************************************************/    
    public with sharing class WrapperCensusBreakout{
        public vlocity_ins__GroupCensusMember__c member{get; set;}              
        public List<vlocity_ins__QuoteLineItemRateBreakout__c> mdclList{get; set;}
        public List<vlocity_ins__QuoteLineItemRateBreakout__c> dntlList{get; set;}
        public List<vlocity_ins__QuoteLineItemRateBreakout__c> vsnList{get; set;}
        public List<vlocity_ins__QuoteLineItemRateBreakout__c> dummyList{get; set;}        
        /************************************************************************************
        Method Name : WrapperCensusBreakout
        Description : This method is used to create records for wrapper class
        ************************************************************************************/ 
        public WrapperCensusBreakout(vlocity_ins__GroupCensusMember__c mbr,List<vlocity_ins__QuoteLineItemRateBreakout__c> mList,
                                     List<vlocity_ins__QuoteLineItemRateBreakout__c> dList,List<vlocity_ins__QuoteLineItemRateBreakout__c> vList,
                                     List<vlocity_ins__QuoteLineItemRateBreakout__c> maxProducts){
                                         member=mbr;                                         
                                         mdclList=mList;
                                         dntlList=dList;
                                         vsnList=vList; 
                                         dummyList=maxProducts;                                         
                                     }
    }
    
    
}