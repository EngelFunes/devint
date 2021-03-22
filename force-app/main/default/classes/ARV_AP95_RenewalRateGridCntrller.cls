/********************************************************************************************
    Class Name   : ARV_AP95_RenewalRateGridCntrller. 
    Date Created : 01-July-2019
    Created By   : IDC Offshore 
    Description  : This is VF Page(ARV_VF06_RateGridPage) Controller. It read data from ARV_CO01_IP_RateGridData__c object and display data in vf and generates as PDF*******************************************************/
    public without sharing class ARV_AP95_RenewalRateGridCntrller {
        public Id finalContractId{get;set;} 
        public String carrierType{get;set;} 
        public String ratArea{get;set;} 
        public String fromDate{get;set;} 
        public String subGrp{get;set;} 
        public String sbGrpName{get;set;} 
        public String grpId{get;set;} 
        public List<String> cmpMedShrtDsc1{get;set;}
        public String cls{get;set;} 
        public String clsNam{get;set;} 
        public String toDate{get;set;} 
        private static final string AGE = 'Age';            
        private static final string IDSTRING = 'id';
        private static final string RATINGAREA = 'RatingArea';
        private static final string TYPE = 'Type';
        private static final string NOFORM = 'NOFORM';
        private static final String CLSNAME='ARV_AP95_RenewalRateGridCntrller';
        private static final String METHODNAME='getRates';
        private static final String ERRORMSG='Rate Grid got failed';
        private static final string GET_USER_ATTACHMENT  = 'getUserAttachmentId';  
        private static final String ERRORMSG_ATTACHMENT =  'There was an issue getting the attachmentId ';        
        private static final String RATEGRIDWHERECLAUSE = ' where  ARV_HIOSPlanId__c  in :docstrings  AND '+
           ' ARV_RatingArea__c =:paramName AND ARV_EffectiveDate__c =:dateVal ';
        private static final String RATEGRIDORDERBYCLAUSE = ' order by plantype__C ASC ' ;       
        private static final String METADAWHERECLAUSE = '  where DeveloperName=:paramName ';
        private set<string> ageSet1  = null;
        private set<string> ageSet3  = null;
        public Transient map<integer,set<AgeWrapper>> ageMap1 {get; set;}
        public Transient map<integer,set<AgeWrapper>> ageMap2 {get; set;}    
        public Transient map<integer,set<AgeWrapper>> ageMap3 {get; set;} 
        public Transient map<integer,set<AgeWrapper>> ageMap4 {get; set;} 
        
        public String accountName{get;set;}
        public String cid{get;set;}
        public String grpDvsn{get;set;}
        public String fndngType{get;set;}
        public String rtngarea{get;set;}
        public List<String> grpDvsnList{get;set;} 
        public String grpSgmntName{get;set;}
        public Map<Id,String> gsNameMap = new Map<Id,string>();

        private set<string> ageSet2  = null;
        private List<string> tableHeaderList = null;
        public Transient map<AgeWrapper,List<string>> rateMatrix32 {get; set;}   
        public Transient map<AgeWrapper,List<string>> rateMatrix65 {get; set;}
        public Transient map<AgeWrapper,List<string>> rateMatrix9999 {get; set;}
        public set<integer> tableCount {get; set;}
        public map<integer,List<string>> tableHeaderMap {get; set;}
        public map<integer,string> tableCompHeaderMap {get; set;}

        public integer noOftables {get; set;}
        private integer tempSize = 0;
        private Map<String, string> agePremiumMap = null;
         private Map<String, string> compPremiumMap = null;
        private boolean iterateComplete = false;
        private Transient set<AgeWrapper> wrapObjSet1 = null;
        private Transient set<AgeWrapper> wrapObjSet2 = null;
        private Transient set<AgeWrapper> wrapObjSet3 = null;
        private Transient set<AgeWrapper> wrapObjSet4 = null;

        private Transient map <string,AgeWrapper> wrapObjMap = null;
        private Transient Map<string,string> staticAgemap = null;
        private Transient Map<string,string> hiosplanIdMap = null;   
        private AgeWrapper wrapObj = null;
        private integer iRateGridSize = 0;   
        private static final String NO1='65';
        private static final String NO2='65+';
        private static final String NO3='0';
        private static final String COMPVAL='9999';
        private static final String COMP='All';
        private map<String,Map<String,String>> prodIdAgeRateMap = new  map<String,Map<String,String>>();
        private map<String,string> finalAgeMaP = new  map<String,String>();
        Map<String,Decimal> finalSummationMap=null;
        private list<ARV_CO02_RateGridStaticData__c> rateGridlistMed  = null;
        private list<ARV_CO02_RateGridStaticData__c> rateGridlistDentl  = null;
        private list<ARV_CO02_RateGridStaticData__c> rateGridlistVsn  = null;
        private static final String MRATEGRIDWHERECLAUSE = ' where  ARV_HIOSPlanId__c  = :paramId1  AND '+
           ' ARV_RatingArea__c =:paramName AND ARV_EffectiveDate__c =:dateVal  AND planType__c =:paramName1 ';
        private static final String DRATEGRIDWHERECLAUSE = ' where  ARV_HIOSPlanId__c  = :paramId1  AND '+
           ' ARV_RatingArea__c =:paramName AND ARV_EffectiveDate__c =:dateVal   AND planType__c =:paramName2  ';
        private static final String VRATEGRIDWHERECLAUSE = ' where  ARV_HIOSPlanId__c  = :paramId1  AND '+
           ' ARV_RatingArea__c =:paramName AND ARV_EffectiveDate__c =:dateVal  AND planType__c =:paramName3   ';
        private map<String,Map<String,Decimal>> finalRenewMaP=null;
        private Map<String,map<String,Map<String,Decimal>>> gsRenewMaP = new Map<String,map<String,Map<String,Decimal>>>();

        Transient Map<String,Decimal> compMap=new Map<String,Decimal>();
        Transient Map<String,String> grpMedList = new Map<String,String>();
        Transient Map<String,String> grpDntlList = new Map<String,String>();
        Transient Map<String,String> grpVsnList = new Map<String,String>();
        public Map<String,string> medFormsMap{get;set;}
        public Transient Map<String,String> cmpMedMap{get;set;}
        public Transient Map<String,String> regMedMap{get;set;}
        public Transient Map<String,String> cmpPharmacyMap{get;set;}
        public Transient Map<String,String> regPharmacyMap{get;set;}
        public Transient Map<String,String> cmpDntlMap{get;set;}
        public Transient Map<String,String> regDntlMap{get;set;}
        public Transient Map<String,String> cmpVsnMap{get;set;}
        public Transient Map<String,String> regVsnMap{get;set;}
        public Transient List<Map<String,String>> regMedMap1{get;set;}
        public Transient Map<Integer,List<Map<String,string>>> BRInfoMapLst{get;set;}
        public Transient List<Map<String,String>> cmpMedMap1{get;set;}
        public Transient List<Map<String,String>> cmpPharmacyMap1{get;set;}
        public Transient List<Map<String,String>> regPharmacyMap1{get;set;}
        public Transient List<Map<String,String>> cmpDntlMap1{get;set;}
        public Transient List<Map<String,String>> regDntlMap1{get;set;}
        public Transient List<Map<String,String>> cmpVsnMap1{get;set;}
        public Transient List<Map<String,String>> regVsnMap1{get;set;}
        public Transient List<Integer> gsrCnt{get;set;}
        public Transient List<String> regMedNameList{get;set;}
        public Transient List<String> cmpMedNameList{get;set;}
        public Transient List<String> regPharmacyNameList{get;set;}
        public Transient List<String> cmpPharmacyNameList{get;set;}
        public Transient List<String> regDntlNameList{get;set;}
        public Transient List<String> cmpDntlMapNameList{get;set;}
        public Transient List<String> regVsnNameList{get;set;}
        public Transient List<String> cmpVsnNameList{get;set;}
        private static final string GMTFMT = 'MM/dd/yyyy';            
        private static final string SGR ='Small Group Rated';
        private static final string BLNK ='';
        private static final string CMA =',';
        private static final string CLN =':';
        private static final string UDSCR ='_';
        private static final string ZRVL ='0';
        private static final string MDCL ='Medical';
        private static final string DNTL ='Dental';
        private static final string VSN ='Vision';
        private static final string AVAL ='A';
        private static final string BVAL ='B';
        private static final string CVAL ='C';
        private static final string DVAL ='D';
        private static final string QVAL ='Q';
        private static final string VVAL ='V';
        private static final string MVAL ='M';
        private static final string NON ='None';
        private static final string FR9 ='9999';
        private static final string ALL ='All';
        private static final string TTL ='Total';
        private static final string BCBSM ='BCBSM';
        private static final string BCN ='BCN';
        private static final string HBA ='Healthy Blue Achieve';
        private static final string RGLR ='Regular';
        private static final string CMP ='Comp';
        private static final string PRMCY ='Pharmacy';
        private static final string CRTFCT ='CERTIFICATE';
        private static final string BLSHLD ='BLUE SHIELD';

        /************************************************************************************
        Method Name : ARV_AP95_RenewalRateGridCntrller
        Description : This is VF consturctor to initialize data.
        ************************************************************************************/
        public ARV_AP95_RenewalRateGridCntrller(){
            rateMatrix32 = new map<AgeWrapper,List<string>>();
            rateMatrix65 = new map<AgeWrapper,List<string>>();
            rateMatrix9999 = new map<AgeWrapper,List<string>>();
            tableHeaderMap = new map<integer,List<string>>();
            ageMap1 = new map<integer,set<AgeWrapper>>();
            ageMap2 = new map<integer,set<AgeWrapper>>();
            ageMap3 = new map<integer,set<AgeWrapper>>();
            ageMap4 = new map<integer,set<AgeWrapper>>();
            tableCompHeaderMap =new map<integer,string>();
            tableCompHeaderMap.put(0,AGE);
            tableCompHeaderMap.put(1,'Total');
            tableCompHeaderMap.put(2,'Med/Rx');
            tableCompHeaderMap.put(3,'Dental');
            tableCompHeaderMap.put(4,'Vision');
            ageSet1 = new set<string>();
            tableCount = new set<integer>();
            grpDvsnList = new List<String>();

            for(integer i=0;i<=34;i++){
                ageSet1.add(string.valueOf(i));
            }
            ageSet2 = new set<string>();
            for(Integer i=35;i<=65;i++){
                ageSet2.add(string.valueOf(i));
            }
            ageSet3 = new set<string>();        
                
            ageSet3.add(COMP);      
            // to fetch the ContractId
            finalContractId=ApexPages.currentPage().getParameters().get(IDSTRING);
            carrierType=ApexPages.currentPage().getParameters().get(TYPE);
            rtngarea=ApexPages.currentPage().getParameters().get(RATINGAREA);
            fromDate=ApexPages.currentPage().getParameters().get('Date');
            //fromDate =s.formatGMT(GMTFMT);
            cmpMedMap= new Map<String,String>();
            regMedMap= new Map<String,String>();
            cmpPharmacyMap= new Map<String,String>();
            regPharmacyMap= new Map<String,String>();
            cmpDntlMap= new Map<String,String>();
            regDntlMap= new Map<String,String>();
            cmpVsnMap= new Map<String,String>();
            regVsnMap= new Map<String,String>();
            regMedMap1= new List<Map<String,String>>();
            cmpMedMap1= new List<Map<String,String>>();         
            cmpPharmacyMap1= new List<Map<String,String>>();
            regPharmacyMap1= new List<Map<String,String>>();
            cmpDntlMap1= new List<Map<String,String>>();
            regDntlMap1= new List<Map<String,String>>();
            cmpVsnMap1= new List<Map<String,String>>();
            regVsnMap1= new List<Map<String,String>>();
            gsrCnt = new List<Integer>();
            regMedNameList = new List<String>();
            regPharmacyNameList=new List<String>();
            cmpPharmacyNameList=new List<String>();
            regDntlNameList=new List<String>();
            cmpDntlMapNameList=new List<String>();
            regVsnNameList=new List<String>();
            cmpVsnNameList=new List<String>();
        }     
        /************************************************************************************
        Method Name : getRates
        Description : This method is invoked as VF page action. It reads data from ARV_CO01_IP_RateGridData__c and prepare data to display in UI.
        ************************************************************************************/
        public void getRates(){
            //Query Data
            try{
                selectDataLayer(finalContractId,carrierType,rtngarea);  
                getBRINfo(finalContractId,carrierType) ;
                //Initialize variables
                initializeVariables();
                if(!gsRenewMaP.isEmpty()){
                    //It prepares data to display UI
                    setPageDisplayData();
                }
            }catch(Exception e){
                GA_LogExceptionCls.LogExcp(e,'ARV_AP95_RenewalRateGridCntrller','getRates()');
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
        public void initializeVariables(){
            iRateGridSize = gsRenewMaP.size(); 
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
            tableHeaderList.add(TTL);                         
            tableHeaderList.add('Medical+\n pharmacy');                         
            tableHeaderList.add(DNTL);                         
            tableHeaderList.add(VSN);                         
            integer mInt = 0; 
            integer zInt = 0;       
            integer iRateSize = iRateGridSize;
            for(String hiosStr : gsRenewMaP.keyset()){
                iRateSize--;
                grpSgmntName=hiosStr;
                for(String str : finalRenewMaP.keyset()){
                    getPremiumMapForGS(hiosStr,str);
                    setRateMatrixMap1(ageSet1,32,mInt);
                    setRateMatrixMap1(ageSet2,65,mInt);
                    setRateMatrixMap1(ageSet3,9999,mInt);
                    mInt++; 
                    iterateComplete = true;
                }
                if(mInt == 4 || mInt == iRateGridSize || iRateSize == 0){                                           
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
            notables=gridSize;
            tempSize= gridSize;
            for(Integer k=1;k<=notables;k++){
                tableCount.add(k);
            }
            return notables;
        }  
        /************************************************************************************
        Method Name : setRateMatrixMap1
        Description : It set data into rateMatrix32 and rateMatrix65 maps to display in UI.This is called from 'setPageDisplayData' method.
        ************************************************************************************/
        private object setRateMatrixMap1(set<string> ageSet,integer ageLimit,Integer mIntger){

            boolean setRes = false;     
            Object  retVal = null;
            try{            
                List<string> tempList = new List<string>();
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
                    } 
                    
                   retVal = ageLimit == 32?rateMatrix32.put(wrapObj,tempList): ageLimit == 65?
                                        rateMatrix65.put(wrapObj,tempList):rateMatrix9999.put(wrapObj,tempList);
                    
                }
            }catch(Exception e){
                GA_LogExceptionCls.LogExcp(e,'ARV_AP95_RenewalRateGridCntrller','setRateMatrixMap1()');
                //system.debug('error occured'+e.getlinenumber()+'::::'+e.getmessage());
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
            ageMap4.put(keyInt,wrapObjSet4);
            wrapObjSet1 = new set<AgeWrapper>();
            wrapObjSet2 = new set<AgeWrapper>();                  
            wrapObjSet3 = new set<AgeWrapper>(); 
            wrapObjMap = new map<string,AgeWrapper>();
            iterateComplete = false;
            tempSize =keyInt*4;
            tableHeaderList =  new string[tempSize];
            tableHeaderList.add(AGE);
            tableHeaderList.add(TTL);                         
            tableHeaderList.add('Medical+\n pharmacy');                         
            tableHeaderList.add(DNTL);                         
            tableHeaderList.add(VSN);
        }  
        /************************************************************************************
        Method Name : selectDataLayer
        Description : It queries Data from Quote and ARV_CO01_IP_RateGridData__c objects.This is called from 'getRates' method.
        ************************************************************************************/
        public void selectDataLayer(Id cntrctId,String carrier,String ratArea){
            Map<Id,String> gsMap = new Map<Id,string>();
            List<GA_Group_Segment__c> grpSgmntLst=[select Name, ARV_Package__r.name,Facets_Class_Description__c,
            GA_Group_Name__c,GA_Facet_Group_Name__c,GA_Facets_Group_ID__c,GA_Facets_Class_ID__c,
            GA_Facets_Sub_Group_Number__c,
            GA_Account__r.Renewal_Month__c,              
            GA_Account__r.name,GA_Account__r.CID__c ,
            ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c,
            ARV_ContractID__r.ARV_Requested_Effective_Date__c,                                      
            ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductSubType__c,ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductSubType__c,
            ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c,
            ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductSubType__c,ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c
            FROM GA_Group_Segment__c WHERE ARV_ContractID__c =:cntrctId and GA_Carrier__c=:carrier order by name asc limit 50];
            if(grpSgmntLst.size()>0){
                DateTime fDate =grpSgmntLst[0].ARV_ContractID__r.ARV_Requested_Effective_Date__c;
                /*if(fDate !=null){
                    //fromDate=fDate.formatGMT(GMTFMT);
                }*/
                DateTime tDate =null;
                Date tDate1 =null;
                if(Test.isRunningTest()){
                    tDate=system.today();
                    tDate1=system.today();
                }
                else{tDate =Date.valueOf(fromDate);tDate1 =Date.valueOf(fromDate);}
                Date effDate=null;
                accountName=grpSgmntLst[0].GA_Account__r.name;
                fndngType=SGR;
                grpId=grpSgmntLst[0].GA_Facets_Group_ID__c; 
                sbGrpName=grpSgmntLst[0].GA_Facet_Group_Name__c;
                subGrp=grpSgmntLst[0].GA_Facets_Sub_Group_Number__c;
                clsNam=grpSgmntLst[0].Facets_Class_Description__c;
                cls=grpSgmntLst[0].GA_Facets_Class_ID__c;
                cid=grpSgmntLst[0].GA_Account__r.CID__c;
                date myDate =null;
                if(Test.isRunningTest())
                {
                    myDate=system.today();
                }
                else{ myDate =Date.valueof(fromDate);}
                DateTime rDate=myDate.addYears(1).addDays(-1);
                toDate=rDate.formatGMT(GMTFMT);
                fromDate=tDate.formatGMT(GMTFMT);

                effDate=getQuarterInfo(grpSgmntLst[0].GA_Account__r.Renewal_Month__c,tDate1.year());
                system.debug('grpSgmntLst'+grpSgmntLst.size());
                for(GA_Group_Segment__c gsp:grpSgmntLst){
                    integer ival=1;
                    ival++;
                    grpDvsnList.add(gsp.Name);
                    gsNameMap.put(gsp.id,gsp.Name);
                    String ids=BLNK;
                    if(gsp.ARV_Package__r.ARV_Medical_Plan__r !=null ){        
                        ids=AVAL+UDSCR+MDCL+CLN+gsp.ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c;
                    }else{              
                        ids=AVAL+UDSCR+MDCL+CLN+ZRVL;
                    }   
                    if(gsp.ARV_Package__r.ARV_Dental_Plan__r !=null){        
                        ids=ids+CMA+BVAL+UDSCR+DNTL+CLN+gsp.ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c;
                    }else{
                        ids=ids+CMA+BVAL+UDSCR+DNTL+CLN+ZRVL;
                    }
                    if(gsp.ARV_Package__r.ARV_Vision_Plan__r !=null){        
                        ids=ids+CMA+CVAL+UDSCR+VSN+CLN+gsp.ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c;
                    }else{
                        ids=ids+CMA+CVAL+UDSCR+VSN+CLN+ZRVL;
                    }                   
                    gsMap.put(gsp.id,ids);
                }
                processRateGrid(gsMap,ratArea,effDate); 
            }
        } 
        /************************************************************************************
        Method Name : processRateGrid
        Description : It queries Data from Quote and ARV_CO01_IP_RateGridData__c objects.This is called from 'getRates' method.
        ************************************************************************************/
        private void processRateGrid(Map<Id,String> gsMap,String rateArea,Date effdate ){
            
            Map<String,Decimal> sumDntlMap=new Map<String,Decimal>();
            Map<String,Decimal> sumVsnMap=new Map<String,Decimal>();
            for(Id ids:gsMap.keyset()){
                String[] prdMap=gsMap.get(ids).split(CMA);              
                Map<String,Decimal> medMap=new Map<String,Decimal>();
                Map<String,Decimal> dntlMap=new Map<String,Decimal>();
                Map<String,Decimal> vsnMap=new Map<String,Decimal>();
                finalRenewMaP = new  map<String,Map<String,Decimal>>();
                finalSummationMap = new Map<String,Decimal>();
                for(String str : prdMap){
                    String[] sgmnt= str.split(CLN);
                    List<ARV_CO02_RateGridStaticData__c> rglst =[select ARV_Rate__c,ARV_age__c from ARV_CO02_RateGridStaticData__c where ARV_HIOSPlanId__c =: sgmnt[1] and ARV_RatingArea__c=:rateArea and planType__c= :sgmnt[0] and arv_effectivedate__C =:effdate ]; 
                    if((AVAL+UDSCR+MDCL).equals(sgmnt[0]) && rglst.size()>0){
                            for(ARV_CO02_RateGridStaticData__c rategrd :rglst ){
                                if(rategrd.ARV_age__c !=9999){  
                                    medMap.put(String.valueof(rategrd.ARV_age__c),rategrd.ARV_Rate__c);
                                }else{
                                    medMap.put(COMP,rategrd.ARV_Rate__c);
                                }   
                            }   
                        }else if((AVAL+UDSCR+MDCL).equals(sgmnt[0]) && rglst.size()<=0){
                            for(integer i=0;i<=65;i++){
                                medMap.put(String.valueof(i),0);
                            }
                            medMap.put(String.valueof(9999),0);
                        }
                        if((BVAL+UDSCR+DNTL).equals(sgmnt[0]) && rglst.size()>0){  
                            for(ARV_CO02_RateGridStaticData__c rategrd :rglst ){
                                 if(rategrd.ARV_age__c !=9999){                         
                                    dntlMap.put(String.valueof(rategrd.ARV_age__c),rategrd.ARV_Rate__c);
                                }else{
                                    dntlMap.put(COMP,rategrd.ARV_Rate__c);
                                }
                            }
                        }else if((BVAL+UDSCR+DNTL).equals(sgmnt[0]) && rglst.size()<=0){
                            for(integer i=0;i<=65;i++){
                                dntlMap.put(String.valueof(i),0);
                            }
                            dntlMap.put(String.valueof(COMP),0);
                        }
                        if((CVAL+UDSCR+VSN).equals(sgmnt[0]) && rglst.size()>0){  
                            for(ARV_CO02_RateGridStaticData__c rategrd :rglst ){
                                if(rategrd.ARV_age__c !=9999){                          
                                    vsnMap.put(String.valueof(rategrd.ARV_age__c),rategrd.ARV_Rate__c);
                                }else{
                                    vsnMap.put(COMP,rategrd.ARV_Rate__c);
                                }
                            }
                        }else if((CVAL+UDSCR+VSN).equals(sgmnt[0]) && rglst.size()<=0){
                            for(integer i=0;i<=65;i++){
                                vsnMap.put(String.valueof(i),0);
                            }
                            vsnMap.put(COMP,0);
                        } 
                }
                for(String age :medMap.keyset()){
                    String ageVal=age==FR9?ALL:age;
                    Decimal total =medMap.get(age);
                    if(dntlMap.size()>0){
                        sumDntlMap.put(ageVal,dntlMap.get(ageVal));
                        if(ageVal!=null)
                        total+=dntlMap.get(ageVal);
                    }
                    if(vsnMap.size()>0){
                        sumVsnMap.put(ageVal,vsnMap.get(ageVal));
                        total+=vsnMap.get(ageVal);
                    }
                    finalSummationMap.put(ageVal,total);
                    staticAgemap = new Map<string,string>();        
                    //rateGridlist2 = hiosplanIdMap;  
                    finalRenewMaP.put(TTL,finalSummationMap );
                    finalRenewMaP.put(MDCL,medMap);
                    finalRenewMaP.put(DNTL,dntlMap );
                    finalRenewMaP.put(VSN,vsnMap );
                    gsRenewMaP.put(String.valueof(ids),finalRenewMaP);
                }
                hiosplanIdMap = new Map<string,string>();
            }           
        }   
        /************************************************************************************
        Method Name : getPremiumMapForGS
        Description : It gets premium for each age and QuoteLineItem and prepare a Map to use in other methods.
        This is called from 'setPageDisplayData' method.
        ************************************************************************************/
         private void getPremiumMapForGS(String gsId, String keyVal){ 
           agePremiumMap = new map<string,string>(); 
            compPremiumMap = new map<string,string>();             
            Map<String,Decimal> mydMap1=gsRenewMaP.get(gsId).get(keyVal);
            for(String ageVal : mydMap1.keyset()){
                if(ageVal!= COMPVAL ){
                    agePremiumMap.put(ageVal,String.valueof(mydMap1.get(ageVal)));  
                }else{
                    compPremiumMap.put(COMP,String.valueof(mydMap1.get(ageVal)));
                }                 
            }     
        }
        /************************************************************************************
        Method Name : getQuarterInfo
        Description : to know the quarter info by passing month and year.
        ************************************************************************************/
        private Date getQuarterInfo(String month,Integer year){
            String renewalMnth =month;           
            String metaDataQry=System.label.ARV_CL37_CM03_RATEGRIDEFFDATE_QRY;
            ARV_AP07_QueryDataHelper.paramName =renewalMnth;
            list<ARV_CM03_RateGridEffectiveDateFetch__mdt> mdt=ARV_AP07_QueryDataHelper.getsObjects(metaDataQry,METADAWHERECLAUSE,null,null);         
            string mtdEDate=year+ARV_AP41_StringLiteralUtils.HYPHENVAL+mdt[0].value__C;  
            return Date.valueOf(mtdEDate);
        }
        /************************************************************************************
        Method Name : getBRINfo
        Description : To get B&RINfo  to display in VF20 page.
        ************************************************************************************/
        public void getBRINfo(Id cntrctId,String carrier){
           List<GA_Group_Segment__c> gsRec = new List<GA_Group_Segment__c>();
           BRInfoMapLst=new Map<Integer,List<Map<String,string>>>();
           cmpMedNameList=new List<String>();
           Map<String,String> regVsnMapMed =new Map<String,String>();
           try{
                gsRec=[select Name, 
                ARV_Pending_PackageId__r.name,ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,
                ARV_Pending_PackageId__r.ARV_Medical_Plan__r.Product_Family__c,
                ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c ,
                ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,
                ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,    
                ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.name,
                ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.name,
                ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.name,
                ARV_ContractID__r.ARV_Requested_Effective_Date__c, 
                ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c
                FROM GA_Group_Segment__c WHERE ARV_ContractID__c=:cntrctId and GA_Carrier__c=:carrier];
                Integer ival=0;
                for(GA_Group_Segment__c gsr:gsRec){
                    regMedMap= new Map<String,String>();
                    cmpMedMap= new Map<String,String>();
                    cmpPharmacyMap= new Map<String,String>();
                    regPharmacyMap= new Map<String,String>();
                    cmpDntlMap= new Map<String,String>();
                    regDntlMap= new Map<String,String>();
                    cmpVsnMap= new Map<String,String>();
                    regVsnMap= new Map<String,String>();
                    regVsnMap= new Map<String,String>();
                    regVsnMapMed= new Map<String,String>();

                    if( BCBSM.equals(carrier) && gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r !=null && 
                     gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c !=null){
                        ARV_AP_BRInfoWrapperclasses.MedicalAttributeWrapper att1= (ARV_AP_BRInfoWrapperclasses.MedicalAttributeWrapper)System.JSON.deserialize(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,ARV_AP_BRInfoWrapperclasses.MedicalAttributeWrapper.class);
                        regMedNameList.add(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.name);
                        if(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.Product_Family__c !=HBA){
                            if(att1.RegularMedicalForms !=null){
                                regMedMap=getBCBSMAttributesInfo(att1.RegularMedicalForms,CVAL,RGLR);
                                // to add peditatric dental which will be default 963f
                                regVsnMapMed =getBCBSMAttributesInfo('963F',VVAL,RGLR);
                                }  
                            if(att1.RegularDrugForms !=null && att1.RegularDrugForms !=NOFORM){
                                regPharmacyMap=getBCBSMAttributesInfo(att1.RegularDrugForms,DVAL,RGLR);
                            }
                            if(att1.RegularDrugForms ==NOFORM || att1.RegularDrugForms ==null){
                                regPharmacyNameList.add(NOFORM);
                            }
                        }else{
                            if(att1.RegularStandardMedicalForms !=null){
                                regMedMap=getBCBSMAttributesInfo(att1.RegularStandardMedicalForms,CVAL,RGLR);
                                regVsnMapMed =getBCBSMAttributesInfo('963F',VVAL,RGLR);
                                }   
                            if(att1.RegularStandardDrugForms !=null){
                                regPharmacyMap=getBCBSMAttributesInfo(att1.RegularStandardDrugForms,DVAL,RGLR);}
                        }
                        if(att1.CompMedicalForms !=null){
                            cmpMedMap=getBCBSMAttributesInfo(att1.CompMedicalForms,CVAL,CMP);}             
                        if(att1.CompDrugForms !=null){
                            cmpPharmacyMap=getBCBSMAttributesInfo(att1.CompDrugForms,DVAL,CMP);}
                    } else if(BCBSM.equals(carrier) &&  gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r ==null){regMedNameList.add(NOFORM);cmpMedNameList.add(NOFORM);regPharmacyNameList.add(NOFORM);cmpPharmacyNameList.add(NOFORM);}
                    if(BCN.equals(carrier) && gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r !=null &&
                        gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c !=null){
                        regMedNameList.add(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.name);
                        regMedMap=getBCNAttributesInfo(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c ,CVAL,MDCL,gsr.ARV_ContractID__r.ARV_Requested_Effective_Date__c,gsr.ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c);
                        
                        regVsnMapMed =getBCNAttributesInfo(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c ,CVAL,VSN,gsr.ARV_ContractID__r.ARV_Requested_Effective_Date__c,gsr.ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c);
                        regPharmacyMap=getBCNAttributesInfo(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,CVAL,PRMCY,gsr.ARV_ContractID__r.ARV_Requested_Effective_Date__c,gsr.ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c);
                    }else if(BCN.equals(carrier) && gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r ==null){regMedNameList.add(NOFORM);regPharmacyNameList.add(NOFORM);}
                    if(BCN.equals(carrier) && gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r !=null &&
                        gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c !=null){
                        
                        ARV_AP_BRInfoWrapperclasses.MedicalAttributeWrapper att1= (ARV_AP_BRInfoWrapperclasses.MedicalAttributeWrapper)System.JSON.deserialize(gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,ARV_AP_BRInfoWrapperclasses.MedicalAttributeWrapper.class);
                        
                        cmpMedMap=getBCNAttributesInfo(att1.CompHIOSID2,MVAL,MDCL,gsr.ARV_ContractID__r.ARV_Requested_Effective_Date__c,gsr.ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c);
                         
                        cmpPharmacyMap=getBCNAttributesInfo(att1.CompHIOSID2,MVAL,PRMCY,gsr.ARV_ContractID__r.ARV_Requested_Effective_Date__c,gsr.ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c);   
                    }else if(BCN.equals(carrier) && gsr.ARV_Pending_PackageId__r.ARV_Medical_Plan__r ==null){cmpMedNameList.add('NOFORM');cmpPharmacyNameList.add('NOFORM');}           
                    if(gsr.ARV_Pending_PackageId__r.ARV_Dental_Plan__r !=null && gsr.ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c !=null ){
                        regDntlNameList.add(gsr.ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.name); 
                        ARV_AP_BRInfoWrapperclasses.DentalAttributeWrapper att2= (ARV_AP_BRInfoWrapperclasses.DentalAttributeWrapper)System.JSON.deserialize(gsr.ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,ARV_AP_BRInfoWrapperclasses.DentalAttributeWrapper.class);
                        if(att2.CompDentalForms !=null){
                            cmpDntlMap=getBCBSMAttributesInfo(att2.CompDentalForms,QVAL,CMP);}
                        if(att2.RegularDentalForms !=null){
                            regDntlMap=getBCBSMAttributesInfo(att2.RegularDentalForms,QVAL,RGLR);}
                    } else{regDntlNameList.add(NOFORM);cmpDntlMapNameList.add(NOFORM);}
                    if(gsr.ARV_Pending_PackageId__r.ARV_Vision_Plan__r !=null && gsr.ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c !=null ){
                        regVsnNameList.add(gsr.ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.name);
                        ARV_AP_BRInfoWrapperclasses.VisionAttributeWrapper att3= (ARV_AP_BRInfoWrapperclasses.VisionAttributeWrapper)System.JSON.deserialize(gsr.ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,ARV_AP_BRInfoWrapperclasses.VisionAttributeWrapper.class);
                        if(att3.RegularVisionForms !=null){
                            regVsnMap=getBCBSMAttributesInfo(att3.RegularVisionForms,VVAL,RGLR);}
                        if(att3.CompVisionForms !=null){
                            cmpVsnMap=getBCBSMAttributesInfo(att3.CompVisionForms,VVAL,CMP);}else{cmpVsnNameList.add(NOFORM);}
                    }else {regVsnNameList.add(NOFORM);cmpVsnNameList.add(NOFORM);}
                    regMedMap1.add(regMedMap); 
                    cmpMedMap1.add(cmpMedMap);
                    regPharmacyMap1.add(regPharmacyMap); 
                    cmpPharmacyMap1.add(cmpPharmacyMap);
                    regDntlMap1.add(regDntlMap); 
                    cmpDntlMap1.add(cmpDntlMap);
                    regVsnMap.putAll(regVsnMapMed);
                    regVsnMap1.add(regVsnMap); 
                    cmpVsnMap1.add(cmpVsnMap);
                    gsrCnt.add(ival);
                    ival++;
                }
            }catch(Exception e){
                GA_LogExceptionCls.LogExcp(e,'ARV_AP95_RenewalRateGridCntrller','getBRINfo()');
            }
        } 
        /************************************************************************************
        Method Name : getBCBSMAttributesInfo
        Description : To get BCBSMAttributesInfo by passing RegularmedForms of Prodcuts attributes and lob.
        ************************************************************************************/  
        public Map<String,string> getBCBSMAttributesInfo(String RegularMedicalForms, String lob,String type){
            String[] medFrms=RegularMedicalForms.split(CMA);
            Map<String,string> attVal= new Map<String,string>();
            List<Benefit_Short_Long_Description__c> medFrmlst =[SELECT LOB__c,Long_Description__c,Short_Description__c FROM Benefit_Short_Long_Description__c WHERE BCBSM_Corp_Form__c IN :medFrms and LOB__c=:lob  limit 50];
            String str=NON;
             try{
            for(Benefit_Short_Long_Description__c BSR: medFrmlst){
                if(type.equals(CMP) && lob.equals(CVAL)){
                    if(NON.equals(str)){
                        str=BSR.Long_Description__c.contains(BLSHLD)?BSR.Short_Description__c:NON;
                    }      
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                    if(!NON.equals(str)){
                        cmpMedNameList.add(str); }                  
                }
                if(type.equals(RGLR) && lob.equals(CVAL)){
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                }
                if(type.equals(RGLR) && lob.equals(DVAL)){
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                    if(NON.equals(str)){
                        str=BSR.Long_Description__c.contains(CRTFCT)?BSR.Short_Description__c:NON;
                    }
                    if(!NON.equals(str)){
                        regPharmacyNameList.add(str);}
                }
                if(type.equals(CMP) && lob.equals(DVAL)){
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                    if(NON.equals(str)){
                        
                        str=BSR.Long_Description__c.contains(CRTFCT)?BSR.Short_Description__c:NON;
                    
                    }
                    if(!NON.equals(str)){
                       
                        cmpPharmacyNameList.add(str);}
                }
                if(type.equals(CMP) && lob.equals(QVAL)){
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                    if(NON.equals(str)){
                        str=BSR.Long_Description__c.contains(CRTFCT)?BSR.Short_Description__c:NON;
                    }
                    if(!NON.equals(str)){
                        cmpDntlMapNameList.add(str);}
                }
                if(type.equals(RGLR) && lob.equals(QVAL)){
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                }
                if(type.equals(RGLR) && lob.equals(VVAL)){
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                }
                if(type.equals(CMP) && lob.equals(VVAL)){
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                    if(NON.equals(str)){
                        str=BSR.Long_Description__c.contains(CRTFCT)?BSR.Short_Description__c:NON;
                    }
                    if(!NON.equals(str)){
                        cmpVsnNameList.add(str);}
                }
            }
                  }catch(Exception e){
                GA_LogExceptionCls.LogExcp(e,'ARV_AP95_RenewalRateGridCntrller','getBRINfo()');
            }
            return attVal;
        }  
        /************************************************************************************
        Method Name : getBCNAttributesInfo
        Description : To get BCNAttributesInfo by passing HIOSID and lob with effective dates
        ************************************************************************************/
        public Map<String,String> getBCNAttributesInfo(String hiosId, String type,String lob,Date sDat,Date eDat){
            Map<String,string> attVal= new Map<String,string>();
            List<Benefit_Short_Long_Description__c> prdFrmlst =[select BCN_Acronym__c , BCN_Plan_Type__c,Long_Description__c,Short_Description__c from Benefit_Short_Long_Description__c where BCN_Plan_Key__c=:hiosId and BCN_Plan_Type__c=:type and lob__C=:lob and
            Effective_Start_Date__c <=:sDat and End_Date__c>=:sDat limit 50];
            String str=NON;
            for(Benefit_Short_Long_Description__c BSR: prdFrmlst){
                attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                if(type.equals(CVAL) && lob.equals(PRMCY)){
                    regPharmacyNameList.add(BSR.BCN_Acronym__c);
                }
                if(type.equals(MVAL) && lob.equals(MDCL)){
                    //cmpMedNameList.add(BSR.BCN_Acronym__c);
                     if(NON.equals(str)){
                        str=BSR.Long_Description__c.contains(BCN)?BSR.Short_Description__c:NON;
                    }      
                    attVal.put(BSR.Short_Description__c,BSR.Long_Description__c);
                    if(!NON.equals(str)){
                        cmpMedNameList.add(str); }
                }
                if(type.equals(MVAL) && lob.equals(PRMCY)){
                    cmpPharmacyNameList.add(BSR.BCN_Acronym__c);
                }
            }
            return attVal;
        }       
    }