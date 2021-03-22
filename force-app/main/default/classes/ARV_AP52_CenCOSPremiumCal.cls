/*****************************************************************************************
Class Name   : ARV_AP52_CenCOSPremiumCal 
Date Created : 18-Nov-2019
Created By   : IDC Offshore
Description  : This  class is used for getting SBC document from external systems on Compare Modal Screen..
******************************************************************************************/
global without sharing class ARV_AP52_CenCOSPremiumCal implements vlocity_ins.VlocityOpenInterface2{       
    private static final string METHODNAME='getCensusMembers';
    private Id contractId;
    private string ratingArea ;
    public string productCode ;
    public string censusId ;
    public string renMnth ;
    public Date RenDate;
    public Date EffDate;
    private Date DOBMember;
    public Integer Age;
    private set<string> PrdCodes;
    private set<id> empIds;
    private set<decimal> CMAge;
    private map<string,Decimal> getRates;
    private list<vlocity_ins__GroupCensusMember__c> censusMemberList;
    private static final String METADAWHERECLAUSE = '  where DeveloperName=:paramName ';
    private static final String SOQLWHERE=' where vlocity_ins__CensusId__c =:censusId and status__c =';
    private static final String ENROLLING='Enrolling';
    private static final BOOLEAN TRUE_VAL = true;
    private static final BOOLEAN FALSE_VAL = false;
    private  final string doublestar='**';
    private list<contract> contrctList;
    
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options) 
    {           
        Boolean success = TRUE_VAL;
        try{
            if (methodName == METHODNAME) 
            {
                getCensusMembers(input,output,options);
            }
        }catch(Exception e){
            success = FALSE_VAL;
        }
        return success;
    }
    
    global void getCensusMembers(Map<String, Object> input,Map<String, Object> output,Map<String, Object> options){
        contractId = (Id)input.get('ContextId');
        contrctList = [select id,Accountid,vlocity_ins__EnrollmentCensusId__c,account.ARV_Requested_Renewal_Date__c,account.Renewal_Month__c,
                       ARV_RatingArea__c, ARV_Requested_Effective_Date__c from contract where id =: contractId];        
        censusId = contrctList[0].vlocity_ins__EnrollmentCensusId__c;
        RenDate = contrctList[0].account.ARV_Requested_Renewal_Date__c;        
        ratingArea = contrctList[0].ARV_RatingArea__c;        
        renMnth = contrctList[0].account.Renewal_Month__c;        
        CMAge = new set<decimal>();
        censusMemberList = [select id,name,vlocity_ins__CensusId__c,ARV_LocationPackage__c,vlocity_ins__Birthdate__c,
                            ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,
                            ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c, 
                            ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c,
                            ARV_Package__c, vlocity_ins__RelatedCensusMemberId__c,
                            MemberAge__c,ARV_Is_Medical_Selected__c,
                            vlocity_ins__RelatedCensusMemberId__r.ARV_Is_Valid__c,
                            ARV_Is_Dental_Selected__c, ARV_Is_Vision_Selected__c, 
                            Medical_Premium__c,Dental_Premium__c,
                            Vision_Premium__c,ARV_Last_Rated_Date__c,
                            vlocity_ins__IsPrimaryMember__c,ARV_Is_Valid__c
                            from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c =:censusId 
                            and status__c = 'Enrolling'];        
                
        for(vlocity_ins__GroupCensusMember__c cenM:censusMemberList){
            CMAge.add(cenM.MemberAge__c);
        }        
        list<Package__c> pckg =[SELECT Id, ARV_Dental_Plan__r.vlocity_ins__ProductCode__c, 
                                ARV_Vision_Plan__r.vlocity_ins__ProductCode__c, ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,
                                ARV_Contract_Id__c FROM Package__c where ARV_Contract_Id__c = :contractId ];
        
        PrdCodes = new set<string>();
        for(Package__c pck : pckg){
            PrdCodes.add(pck.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c);
            PrdCodes.add(pck.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c);
            PrdCodes.add(pck.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c);
            
        }
        System.debug('@@PCK'+PrdCodes);
        getRatesPremium();
        updatecensusMem();
    }
    
    public void updatecensusMem(){
        System.debug('updatecensusMem - outside of FOR loop');
        for(vlocity_ins__GroupCensusMember__c cml :censusMemberList ){
            System.debug('updatecensusMem - inside of FOR loop');
            if((cml.ARV_Is_Valid__c == true && cml.vlocity_ins__IsPrimaryMember__c == true) ||
               (cml.vlocity_ins__IsPrimaryMember__c == false && cml.vlocity_ins__RelatedCensusMemberId__r.ARV_Is_Valid__c == true)){
                   System.debug('updatecensusMem - inside of 1st IF');
                                      
                if(cml.ARV_Is_Medical_Selected__c &&  (getRates.containskey(cml.ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c + doublestar + cml.MemberAge__c))){
                    System.debug('updatecensusMem - inside of 2nd IF');
                    cml.Medical_Premium__c = getRates.get(cml.ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c + doublestar + cml.MemberAge__c);
                    cml.ARV_Last_Rated_Date__c = datetime.now();                                              
                } 
                if(cml.ARV_Is_Dental_Selected__c &&  (getRates.containskey(cml.ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c + doublestar + cml.MemberAge__c))){
                     System.debug('updatecensusMem - inside of 3rd IF');
                       cml.Dental_Premium__c = getRates.get(cml.ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c + doublestar + cml.MemberAge__c);
                       cml.ARV_Last_Rated_Date__c = datetime.now();                       
                }
                if(cml.ARV_Is_Vision_Selected__c  && (getRates.containskey(cml.ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c + doublestar + cml.MemberAge__c))){
                    System.debug('updatecensusMem - inside of 4th IF');
                       cml.Vision_Premium__c = getRates.get(cml.ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c + doublestar + cml.MemberAge__c);
                       cml.ARV_Last_Rated_Date__c = datetime.now();                       
                       system.debug('vvvv'+cml.Vision_Premium__c);
                }                   
            }            
            else if(cml.Medical_Premium__c != null || cml.Dental_Premium__c != Null || cml.Vision_Premium__c !=Null){
                cml.Medical_Premium__c = null;
                cml.Dental_Premium__c = null;
                cml.Vision_Premium__c = null; 
            }
            update censusMemberList;
            
        }
    }  
               
    
    Public void getRatesPremium(){
        String metaDataQry=System.label.ARV_CL37_CM03_RATEGRIDEFFDATE_QRY;
        ARV_AP07_QueryDataHelper.paramName =renMnth; // need to get this
        list<ARV_CM03_RateGridEffectiveDateFetch__mdt> mdt=ARV_AP07_QueryDataHelper.getsObjects(metaDataQry,
                                                                                                METADAWHERECLAUSE,null,null);         
        string mtdEDate=contrctList[0].account.ARV_Requested_Renewal_Date__c.year()+ARV_AP41_StringLiteralUtils.HYPHENVAL+mdt[0].value__C; 
                
        list<ARV_CO02_RateGridStaticData__c> Prdrates = [SELECT Id, Name, ARV_RatingArea__c, ARV_HIOSPlanId__c, 
                                                         ARV_EffectiveDate__c, ARV_Age__c, ARV_Rate__c, planType__c, 
                                                         ProductName__c FROM ARV_CO02_RateGridStaticData__c where 
                                                         ARV_RatingArea__c = :ratingArea  and 
                                                         ARV_HIOSPlanId__c in:PrdCodes and 
                                                         ARV_EffectiveDate__c = :date.valueof(mtdEDate) 
                                                         and ARV_Age__c in :CMAge 
                                                        ];
        
        getRates = new map<string,Decimal>();
        for(ARV_CO02_RateGridStaticData__c rateGrid:Prdrates){            
            string PrdAdge = rateGrid.ARV_HIOSPlanId__c + doublestar + rateGrid.ARV_Age__c;
            getRates.put(PrdAdge,rateGrid.ARV_Rate__c);            
        }
        
    }
    
    
}