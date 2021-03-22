/*****************************************************************************************
Class Name   : ARV_AP53_CencosVoluntaryVldtns. 
Date Created : 12-Dec-2019
Created By   : IDC Offshore
Description  : This is the class for validating census in enrollment process.
******************************************************************************************/
global without sharing class ARV_AP53_CencosVoluntaryVldtns implements vlocity_ins.VlocityOpenInterface2{ 
    private final static string METHODNAME1='getContract';
    private final static string VOLUNTARY ='Voluntary';
    private final static string CONTEXTID = 'ContextId';
    private final static string REJECTED = 'Rejected';
    private final static string RJCTREASON = 'Did not meet minimum participation requirements';
    private string contractId;
    private final static string NONVOLUNTARY='Non-Voluntary';
    private final static string DENTALVOLUNTARY='DentalVountary';
    private final static string VISIONVOLUNTARY='VisionVoluntary';
    private final static string DENTALNONVOLUNTARY='DentalNonVoluntary';
    private final static string INVLDPARTCPTN='invalid participation';
    PRIVATE set<id> pckId = NULL;
    PRIVATE map<string, list<id>> dentPlnId = NULL;
    Private Map<Id,Package__c> pckgId = NULL;
    Private list<vlocity_ins__ContractLineItem__c> plns = NULL;
    Private List<vlocity_ins__GroupCensusMember__c> eligibleEmplys = new List<vlocity_ins__GroupCensusMember__c>();
    private static final string CLSNAME  ='ARV_AP53_CencosVoluntaryVldtns';
    private static final string METHODNAME  ='invokeMethod';   
    private static final String ERRORMSG='Unable to  Id'; 
    private String denvol;
    private String visvol;
    private static final String ENROLLING='Enrolling';
    private static final String DENTAL='Dental';
    private static final String VISION='Vision';
    private static final String PEDIATRIC='%Pediatric%';
    private boolean isdentalselected = false; 
    private boolean isvisionselected= false; 
    private string censusId;
    private boolean check =FALSE ;
    private static final string BLANK='';
    Private list<contract> cntrct = new list<contract>();
    Private map<Id,vlocity_ins__ContractLineItem__c> cliItemMap = new map<Id,vlocity_ins__ContractLineItem__c>(); 
    Private map<Id,Integer> dentalMap = new map<Id,Integer>();
    Private map<Id,Integer> visionMap = new map<Id,Integer>();
    Private list<package__c> dentalPackgeList = new list<package__c>();
    Private list<package__c> visionPackgeList = new list<package__c>();
    Private list<vlocity_ins__ContractLineItem__c> perPlns = new list<vlocity_ins__ContractLineItem__c>(); 
    Private integer denEmpCount = 0; 
    Private integer visEmpCount = 0; 
    Private integer empCount; 
    Private Double partPer; 
    Private Double totalElgibleEmp;
    Private Map<String,List<vlocity_ins__GroupCensusMember__c>> mbrCount = new Map<String,
        List<vlocity_ins__GroupCensusMember__c>>();
    private static final string CONTRACTQUERY='select id,vlocity_ins__EnrollmentCensusId__c,Status,'
    + 'ARV_Rejection_Reason__c,ARV_Tech_Selected_Plans__c,ARV_MLR_No_Employees_Cov_Through_Spouse__c,Account.GA_Total_Eligible__c from contract';
    private static final string CONTRACTWHERE=' where id =:paramId1';
    private static final STRING ORDERBYCLAUSE='';
    private static final STRING LIMITCLAUSE=' Limit 1';
    private static final STRING LIMITCLAUSE2=' Limit 200';
    private static final string ELGEMPQUERY='SELECT Id, Name, vlocity_ins__CensusId__c, '+
    'vlocity_ins__IsPrimaryMember__c, Status__c, ARV_Is_Medical_Selected__c, ARV_Is_Dental_Selected__c,'+
    'ARV_Is_Vision_Selected__c, ARV_Package__c FROM vlocity_ins__GroupCensusMember__c';
    private static final string ELGEMPWHERE=' where vlocity_ins__CensusId__c =:paramId1 '+
        'and vlocity_ins__IsPrimaryMember__c=:paramName4 and Status__c = :paramName2';
    private list<string> denvis = new list<string>{DENTAL,VISION};
    private static Integer EligibleEmpCount;
        
        /**************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :invokeMethod() method 
*************/
        global Object invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output,
                                   Map<String,Object> options) 
    {
        try{
            if(methodName ==METHODNAME1)
            {
                getContract(input, output,options);
            }
        }catch(exception e){
            //system.debug('line number@@ '+e.getLineNumber());
            //system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
            //throw new AuraHandledException(ERRORMSG+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage());
             }
        return true;
    }
    /*****************************************************************************************
Method Name   : getContract. 
Date Created : 23-Dec-2019
Created By   : IDC Offshore
Description  : This is the method for Cencos Voluntary validation.
******************************************************************************************/
    Public void getContract(Map<String, Object> input, Map<String, Object> output, Map<String,Object> options){
        contractId = String.valueOf(input.get(CONTEXTID));
        // contractId = '800c0000000mTlDAAU';
        ARV_AP07_QueryDataHelper.paramId1 = contractId;
        cntrct= ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE,ORDERBYCLAUSE,LIMITCLAUSE);
        censusId = cntrct[0].vlocity_ins__EnrollmentCensusId__c;
        pckgId = new Map<Id,Package__c>([SELECT Id,ARV_Contract_Id__c,Name,ARV_Vision_Plan__c,
                                         ARV_Vision_Plan__r.Voluntary_Contributory__c,
                                         ARV_Dental_Plan__c,ARV_Dental_Plan__r.Voluntary_Contributory__c 
                                         FROM Package__c where ARV_Contract_Id__c = :contractId LIMIT 10]);
        ARV_AP07_QueryDataHelper.paramId1 = censusId;
        ARV_AP07_QueryDataHelper.paramName4 = true;
        ARV_AP07_QueryDataHelper.paramName2 = ENROLLING;
        eligibleEmplys = ARV_AP07_QueryDataHelper.getsObjects(ELGEMPQUERY,ELGEMPWHERE,ORDERBYCLAUSE,LIMITCLAUSE2);
        //system.debug('eligibleEmplys size @@'+eligibleEmplys.size());
        DENVOL = [SELECT ARV_Dental_Plan__r.Voluntary_Contributory__c 
                  FROM Package__c where ARV_Contract_Id__c = :contractId LIMIT 1].ARV_Dental_Plan__r.Voluntary_Contributory__c;
        VISVOL = [SELECT ARV_Vision_Plan__r.Voluntary_Contributory__c 
                  FROM Package__c where ARV_Contract_Id__c = :contractId LIMIT 1].ARV_Vision_Plan__r.Voluntary_Contributory__c;
        if(cntrct[0].ARV_Tech_Selected_Plans__c != null && cntrct[0].ARV_Tech_Selected_Plans__c != BLANK){
            ISDENTALSELECTED = cntrct[0].ARV_Tech_Selected_Plans__c.contains(DENTAL);
            ISVISIONSELECTED = cntrct[0].ARV_Tech_Selected_Plans__c.contains(VISION);
        }
        getMemberVolData();
        volNonvolCheck();
        updateContract();
        planCalculation();
        planUpdate();
    }
    /**************  
Method name : getMemberVolData
Params     : map
Return Type : null
Description : Checks the number of Dental voluntary, Vision Voluntary and Dental Non vol and add to the map.
*************/
    public void getMemberVolData(){
        //mbrCount = new Map<String,List<vlocity_ins__GroupCensusMember__c>>();
        for(vlocity_ins__GroupCensusMember__c mem: eligibleEmplys){
            //system.debug('mem.ARV_Package__c @@'+mem.ARV_Package__c);
            //system.debug('pckgId.get(mem.ARV_Package__c) @@'+pckgId.get(mem.ARV_Package__c));
            //system.debug('pckgId.   @@'+pckgId.get(mem.ARV_Package__c).ARV_Dental_Plan__r.Voluntary_Contributory__c);
            
            if(ISDENTALSELECTED && mem.ARV_Is_Dental_Selected__c && 
               pckgId.get(mem.ARV_Package__c).ARV_Dental_Plan__r.Voluntary_Contributory__c.equals(VOLUNTARY)){
                   if(!mbrCount.containsKey(DENTALVOLUNTARY)){
                       mbrCount.put(DENTALVOLUNTARY, new List<vlocity_ins__GroupCensusMember__c>());
                   }
                   mbrCount.get(DENTALVOLUNTARY).add(mem);
               }
            else if(ISDENTALSELECTED && mem.ARV_Is_Dental_Selected__c && 
                    pckgId.get(mem.ARV_Package__c).ARV_Dental_Plan__r.Voluntary_Contributory__c.equals(NONVOLUNTARY)){
                        if(!mbrCount.containsKey(DENTALNONVOLUNTARY)){    
                            mbrCount.put(DENTALNONVOLUNTARY, new List<vlocity_ins__GroupCensusMember__c>());
                        }
                        mbrCount.get(DENTALNONVOLUNTARY).add(mem);
                    }
            if(mem.ARV_Is_Vision_Selected__c && ISVISIONSELECTED &&
               pckgId.get(mem.ARV_Package__c).ARV_Vision_Plan__r.Voluntary_Contributory__c.equals(VOLUNTARY)){
                   if(!mbrCount.containsKey(VISIONVOLUNTARY)){    
                       mbrCount.put(VISIONVOLUNTARY, new List<vlocity_ins__GroupCensusMember__c>());
                   }
                   mbrCount.get(VISIONVOLUNTARY).add(mem);                                                      
               }                                                                   
         }
    }
    /**************  
Method name : volNonvolCheck
Params     : map
Return Type : null
Description : Rejects the contract if plans are selected participation percentage is below or members are waived.
*************/
    public void volNonvolCheck(){
        //system.debug('DENVOL@@ '+DENVOL);
        //system.debug('ISDENTALSELECTED  @@ '+ISDENTALSELECTED );
        //system.debug('mbrCount @@ '+mbrCount);
        if(VOLUNTARY.equalsIgnoreCase(DENVOL) && true == ISDENTALSELECTED && !mbrCount.containsKey(DENTALVOLUNTARY)){                    
            check = true;
       }
       if(NONVOLUNTARY.equalsIgnoreCase(DENVOL) && DENTAL.equals(cntrct[0].ARV_Tech_Selected_Plans__c)&&
          !mbrCount.containsKey(DENTALNONVOLUNTARY)){
            check = true;
        }
        if((VOLUNTARY.equalsIgnoreCase(VISVOL) && true == ISVISIONSELECTED && !mbrCount.containsKey(VISIONVOLUNTARY))){
            check = true;                 
        }
        for(String s:mbrCount.keyset()){
            if(DENTALVOLUNTARY.equals(s) || VISIONVOLUNTARY.equals(s)){
                if(mbrCount.containsKey(s) && 
                   (mbrCount.get(s).size() < 10 || mbrCount.get(s).size() < (0.3 * eligibleEmplys.size()))){
                       check = true;        
                   }else{}
            }                
            else if( DENTAL.equals(cntrct[0].ARV_Tech_Selected_Plans__c) && DENTALNONVOLUNTARY.equals(s) && 
                    mbrCount.containsKey(s) && ((eligibleEmplys.size()<10 && mbrCount.get(s).size() != eligibleEmplys.size())
                     || (eligibleEmplys.size() >= 10 && mbrCount.get(s).size() < (0.75 * eligibleEmplys.size())))){
                         check = true;   
                     }else{}
        }
    }
    /**************  
Method name : updateContract
Params     : map
Return Type : null
Description :  
*************/
    public void updateContract(){
            //system.debug(' line 200 :::check:::'+check);
        //system.debug(' line 201::::censusId:::'+censusId);
        
 
       
        EligibleEmpCount =[select count() from vlocity_ins__GroupCensusMember__c where ARV_LocationPackage__r.ARV_Segment__c!='Retiree' and
         ARV_COBRA_Enrollment_Reason__c=null and ARV_Original_qualifying_date__c=null and vlocity_ins__IsPrimaryMember__c = true and vlocity_ins__CensusId__c=:censusId];
              cntrct[0].ARV_Eligible_Enrolling__c = EligibleEmpCount;
        system.debug(' first  EligibleEmpCount :::'+EligibleEmpCount );
            //cntrct[0].ARV_Eligible_Enrolling__c = eligibleEmplys.size();
             if(check){
            cntrct[0].Status = REJECTED;
            cntrct[0].ARV_Rejection_Reason__c= RJCTREASON;
            cntrct[0].Is_Open_Enrollment__c = false;
             } 
            //UPDATE cntrct;
            database.update(cntrct);
       
    }
    /**************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :invokeMethod() method 
*************/
    public void planCalculation(){
        
        for(vlocity_ins__ContractLineItem__c pln: [SELECT Id,vlocity_ins__ContractId__c,vlocity_ins__ProductType__c,
                                                   ARV_Participation_Percentage__c FROM vlocity_ins__ContractLineItem__c 
                                                   where vlocity_ins__ContractId__c =:contractId and 
                                                   vlocity_ins__ProductType__c in :denvis and 
                                                   (NOT name like :PEDIATRIC) limit 100])
        {       
            cliItemMap.put(pln.Id,pln);     
        }    
        //dentalPackgeList = [select ARV_Dental_Plan__c,(select id from Census_Members__r where vlocity_ins__IsPrimaryMember__c=true and Status__c = :ENROLLING and ARV_is_Dental_selected__c =true limit 100) from package__c where ARV_Dental_Plan__c in :cliItemMap.keyset() limit 50];
        for(package__c pck: [select ARV_Dental_Plan__c,(select id from Census_Members__r where 
                                                        vlocity_ins__IsPrimaryMember__c=true and Status__c = :ENROLLING and 
                                                        ARV_is_Dental_selected__c =true limit 100) from package__c where 
                                                        ARV_Dental_Plan__c in :cliItemMap.keyset() limit 50]){
                                 if(!dentalMap.containskey(pck.ARV_Dental_Plan__c)){
                                     dentalMap.put(pck.ARV_Dental_Plan__c,pck.Census_Members__r.size());            
                                 }else{
                                     Integer temp = dentalMap.get(pck.ARV_Dental_Plan__c) + pck.Census_Members__r.size();
                                     dentalMap.put(pck.ARV_Dental_Plan__c,temp);             
                                 }
                             }
        //visionPackgeList = [select ARV_Vision_Plan__c,(select id from Census_Members__r where vlocity_ins__IsPrimaryMember__c=true and Status__c = :ENROLLING and ARV_is_vision_selected__c =true limit 100) from package__c where ARV_Vision_Plan__c in :cliItemMap.keyset() limit 50];
        
    }
        /**************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :invokeMethod() method 
*************/
    public void planUpdate(){
    
    EligibleEmpCount =[select count() from vlocity_ins__GroupCensusMember__c where ARV_LocationPackage__r.ARV_Segment__c!='Retiree' and
         ARV_COBRA_Enrollment_Reason__c=null and ARV_Original_qualifying_date__c=null and vlocity_ins__CensusId__c=:censusId];
        TotalElgibleEmp = eligibleEmplys.size();
        for(package__c pck1:[select ARV_Vision_Plan__c,(select id from Census_Members__r where 
                                                        vlocity_ins__IsPrimaryMember__c=true and Status__c = :ENROLLING 
                                                        and ARV_is_vision_selected__c =true limit 100) from package__c 
                                                        where ARV_Vision_Plan__c in :cliItemMap.keyset() limit 50]){          
                                 //visionMap.put(pck1.ARV_Vision_Plan__c,pck1.Census_Members__r.size());
                                 if(!visionMap.containskey(pck1.ARV_Vision_Plan__c)){
                                 system.debug(':::line 257::: '+pck1);
                                     visionMap.put(pck1.ARV_Vision_Plan__c,pck1.Census_Members__r.size());            
                                 }else{
                                     Integer temp = visionMap.get(pck1.ARV_Vision_Plan__c) + pck1.Census_Members__r.size();
                                     visionMap.put(pck1.ARV_Vision_Plan__c,temp);             
                                 }
                             }
        for(Id cliId: cliItemMap.keySet()){
        
            empCount=cliItemMap.get(cliId).vlocity_ins__ProductType__c == DENTAL ? dentalMap.get(cliId) : visionMap.get(cliId);    
            if(cntrct[0].Account.GA_Total_Eligible__c!=null){
            partPer = (EligibleEmpCount/(cntrct[0].Account.GA_Total_Eligible__c-cntrct[0].ARV_MLR_No_Employees_Cov_Through_Spouse__c))*100;        // (empCount/TotalElgibleEmp)*100;
             }
            //system.debug('::::partPer2 :::'+partPer);
            cliItemMap.get(cliId).ARV_Participation_percentage__c = partPer;            
        }
        if(!cliItemMap.isEmpty()){
            database.update(cliItemMap.values());
        }
    }
}