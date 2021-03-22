/*****************************************************************************************
Class Name   : ARV_AP61_UpdateContractDetails 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting. 
******************************************************************************************/
global without sharing class ARV_AP61_UpdateContractDetails implements vlocity_ins.VlocityOpenInterface {
        private static final String PROCEDURE_NAME = 'ContractIP_Approval';    
        private static final String METHODNAME='updatecontractstatus';
        private static final String TRUESTRING ='true';
        private static final String ENROLLING='Enrolling';
        private static final Integer ONE=1;    
        private static final string CONTRACTID= 'contractId';
        private static final String COMMONCONTROL='Common Control = Yes';
        private static final String MULTIPLELOCATIONS='Multiple Locations';
        private static final String SICCODE='SIC Code = 8661';
        private static final String ENROLLINGEMPLYS='Groups with Contracts ≥ 40';
        private static final String COMMUNITYBLUE= 'Product Family = Community Blue HRA';
        private static final String SIMPLYBLUE= 'Product Family = Simply Blue HRA';
        private static final String BCNHRA= 'Product Family = BCN HRA';
        private static final String ENROLLMENTSUBMISSIONDATE='Enrollment Submission Date = ';
        private static final String SEGMENTATIONTYPE='Segmentation Type = ';
        private static final String FREESTANDING='Freestanding Dental';
        private static final String PEDIATRICD='Pediatric Dental';
        private static final String FTEMET='FTE = 1';
        private static final String FEDTAXID='Fed Tax ID = Cancelled before 12 months';
        private  boolean freeStandingDntl = false;
        private static final String CBH= 'Community Blue HRA';
        private static final String SBH= 'Simply Blue HRA';
        private static final String BHRULE= 'BCN HRA';
        private static final String SIC= '8661';
        private static final  String  YES='Yes';
        private static final String  COMMA=',';
        private static final String  SPACE='';
        private Set<Id> pckgPlanId = new Set<Id>();
        private Boolean prodFamilyRule = false;
        private Boolean enrollmentsubmission=false;
        private static final Boolean TRUE_VAL=true;
        private static final  Boolean FALSE_VAL=false;
        private static Boolean FEDTAXCHECK=false;
        private static final String PCKGPLANWHERECLAUSE =' where vlocity_ins__ContractId__c=:paramId1 and '+
      'Id IN: paramId2';
        private static final String CENSMEMWHERECLAUSE1=' where vlocity_ins__CensusId__c=:paramId1  and '+
        ' vlocity_ins__IsPrimaryMember__c=true and Status__c=:paramName ';
        
         private static final String CENSMEMWHERECLAUSE2=' where vlocity_ins__CensusId__c=:paramId1  and '+
        ' vlocity_ins__IsPrimaryMember__c=true and Status__c=:paramName and vlocity_ins__MemberType__c=:paramName2 ';
        private static final String CENSMEMLIMIT=' limit 100';
        private static final String URUR='Underwriting - Under Review';
        private static final String UR='Under Review';
        private static final String APRVDVLDT= 'Approved - Validate Prospect Data/Generate Group Segments';
        private static final String CONTRACTWHERECLAUSE=' where id=:paramId1 ';
        private static final String CONTRACTLIMT=' limit 1';
        private boolean communityRule=false;
        private boolean simplyBlueRule=false;
        private boolean bcnHraRule=false;
        private string tempStatus = SPACE;
        private Date dtVAL=System.Today();
        private Date rq;
        Private string rqstr='';
        Private string rqmon='';
        Private string thisday='';
        Private string thismon='';
        private String sdate=SPACE;
        private Integer datval=ONE;
        private String checkdt=SPACE;
        private static final String LOCKPKGWHERECLAUSE=' where  ARV_ContractId__c=:paramId1 and ARV_TECH_SIC_Code__c=:paramName';
        private static final String BCBS='BCBS';  
        private static final String PEDIATRIC='Pediatric';
        private static final String AUTMTEDENRLMNTINTGRNREDY = 'Automated Enrollment Setup - Integration Ready';
        private  static final String MNULENRLMNTREDY = 'Manual Enrollment Setup - Processing';
         private static Boolean COMPVALUE =false;
        private static Boolean CENCOSCHECK=false;
        private static final String GROUPONE='Groups of  1';
       // private static Boolean PEDIATRICDENTAL=false;
        private static final String UNDERWRITERREVIEW= 'Underwriter UnderReview';
    /*****************************************************************************************
    Method Name : invokeMethod. 
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the class for contract record updation after  submitting. 
    ******************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options){           
        Boolean success = true;
        try{
            if (methodName == METHODNAME){ 
                updatecontractstatus(input,output,options);
            }
        }catch(Exception e){
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP61_UpdateContractDetails11', 'METHODNAME');
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
        }
        return success;
    }          
    /*****************************************************************************************
    Method Name   : updatecontractstatus
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the  method for contract record updation after  submitting. 
    ******************************************************************************************/         
    public void updatecontractstatus(Map<String,Object> input, Map<String,Object> output,
                                     Map<String,Object> options){
        try{ 
            String conId = String.valueof(options.get(CONTRACTID));
            ARV_AP07_QueryDataHelper.paramId1=conId;
            String conqry=System.Label.ARV_CL46_CONTRACTQUERY;
            list<Contract>contractRec1=ARV_AP07_QueryDataHelper.getsObjects(conqry,CONTRACTWHERECLAUSE,null,CENSMEMLIMIT);
            Contract contractRec=contractRec1.get(0);
            Id ACCNID =[select id,Name,AccountId from contract where id=:conId].AccountId;
            Account acc=new Account();
            acc=[select id,Requested_Effective_Date__c from Account where id=:ACCNID];
            Date requestedeffDate=acc.Requested_Effective_Date__c;
            Contract con=new Contract();
            con=[select id,ARV_TECH_Account_Merge__c from Contract where id=:conId];
            if(con.ARV_TECH_Account_Merge__c!=null){
            id ProspectAccountId=con.ARV_TECH_Account_Merge__c;
            Account prospectacc=new Account();
            prospectacc=[select id,Requested_Effective_Date__c,GA_CoverageCancellationDate__c from Account where id=:ProspectAccountId];
            Date prospectaccountreqeffdate=prospectacc.GA_CoverageCancellationDate__c;
            if(prospectaccountreqeffdate!=null){
            Integer monthDiff =prospectaccountreqeffdate.monthsBetween(requestedeffDate);
            if(monthDiff<12)
            {
            FEDTAXCHECK=true;
            }
            }   
            }
            //PEDIATRICDENTAL = contractRec.ARV_ExistingDentalCoverage__c == 'yes' ? true : false;
            
            boolean censusRule=getCensusDetails(contractRec.vlocity_ins__EnrollmentCensusId__c);
            Boolean locsgsic=getLocsegsic(contractRec);
            string statusDesc=getStatusDescription(censusRule,contractRec,locsgsic);
            string contStatus=getContractStatus(contractRec,censusRule,locsgsic);
            udpateContract(statusDesc,contStatus,contractRec);
            system.debug('statusDesc::'+statusDesc);
            system.debug('contStatus::'+contStatus);
        }catch(Exception e){
            system.debug('line numbe22r@@ '+e.getLineNumber());
            system.debug('getMessage22 @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP61_UpdateContractDetails', 'METHODNAME222');
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
        }
    }
    /*****************************************************************************************
    Method Name   : getCensusDetails
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the  method to fetch employees in the census if they only have dental selected(freeStanding Rule)
    ******************************************************************************************/        
    public  boolean getCensusDetails(Id cenId){   
        system.debug('sgsg'+cenId);
       COMPVALUE= CheckCompValue(cenId);
        System.debug('hjghg'+COMPVALUE);
       CENCOSCHECK=cencoscheck(cenId);
       
       // System.debug('PEDIATRICDENTAL222@@@'+PEDIATRICDENTAL);
      // PEDIATRICDENTAL=pediatricdentalcheck(cenId);
        
        
       // system.debug('PEDIATRICDENTAL333@@'+PEDIATRICDENTAL);
        String cenmemqry=System.Label.ARV_CL46CENSUSGROUPMEMBER;
        ARV_AP07_QueryDataHelper.paramId1 =cenId;
        ARV_AP07_QueryDataHelper.paramName=ENROLLING;
        list<vlocity_ins__GroupCensusMember__c> censuslist=ARV_AP07_QueryDataHelper.getsObjects(cenmemqry,CENSMEMWHERECLAUSE1, null,CENSMEMLIMIT);
        for(vlocity_ins__GroupCensusMember__c mem: censuslist){
            if(mem.ARV_Package__c!=null&&mem.ARV_Package__r.ARV_Medical_Plan__r!=null&&mem.ARV_Package__r.ARV_Medical_Plan__r.Carrier_Type__c.equals(BCBS)){
                if(!mem.ARV_Is_Medical_Selected__c && mem.ARV_Is_Dental_Selected__c 
                &&mem.ARV_Package__c!=null&&mem.ARV_Package__r.ARV_Dental_Plan__c!=null&&
                !mem.ARV_Package__r.ARV_Dental_Plan__r.name.contains(PEDIATRIC) && 
                (!mem.ARV_Is_Vision_Selected__c || (mem.ARV_Is_Vision_Selected__c &&
                mem.ARV_Package__c!=null&&
                mem.ARV_Package__r.ARV_Vision_Plan__c!=null &&
                mem.ARV_Package__r.ARV_Vision_Plan__r.name.contains(PEDIATRIC)))){
                    freeStandingDntl = TRUE_VAL;
                }                
            }else{
                freeStandingDntl=FALSE_VAL;
            }
            if(mem.ARV_Package__r.ARV_Medical_Plan__c != null){
                pckgPlanId.add(mem.ARV_Package__r.ARV_Medical_Plan__c);
            }
        }
        return (censuslist.size()>=40)?TRUE_VAL:FALSE_VAL; 
    }
    

    /*****************************************************************************************
    Method Name   : CheckCompValue
    Date Created : 2-7-2020
    Created By   : IDC Offshore
    Description  :This is the  method to set the System Check1 # COMP Data
    US           :2725
    ******************************************************************************************/ 
        public static boolean CheckCompValue(Id cenId){
        boolean Compval;
        String cenmemqry=System.Label.ARV_CL46CENSUSGROUPMEMBER;
             ARV_AP07_QueryDataHelper.paramName=ENROLLING;
             ARV_AP07_QueryDataHelper.paramId1 =cenId;
              ARV_AP07_QueryDataHelper.paramName2= 'Regular';
        System.debug('COMPValuenn2'+cenId);
        list <vlocity_ins__GroupCensusMember__c> censuslist1=ARV_AP07_QueryDataHelper.getsObjects(cenmemqry,CENSMEMWHERECLAUSE2, null,CENSMEMLIMIT);
       
      
    if(censuslist1.size()>0)
        Compval=false;
    else Compval=true;
           System.debug('COMPValueif'+Compval);
              return  Compval;
             
           }
           
 /*****************************************************************************************
    Method Name   : cencoscheck
    Date Created : 3-7-2020
    Created By   : IDC Offshore
    Description  :This is the  method to set the System Check1 # if only one employee in Cencos.
    US           :2655
    ******************************************************************************************/
public Boolean cencoscheck(Id cenId)
{
    Boolean cencoscheckval;
   String cenmemqry=System.Label.ARV_CL46CENSUSGROUPMEMBER;
    list <vlocity_ins__GroupCensusMember__c> censuslist1=
    ARV_AP07_QueryDataHelper.getsObjects(cenmemqry,CENSMEMWHERECLAUSE1, null,CENSMEMLIMIT);
    //system.debug(' line 224 censuslist1 size:::::'+censuslist1.size());
    if(censuslist1.size()==1)
    cencoscheckval=TRUE_VAL;
    else 
    cencoscheckval=FALSE_VAL;
    //system.debug('censuslist1.size::::::::::'+censuslist1.size());
    return cencoscheckval;

}

    /*****************************************************************************************
    Method Name   : getStatusDescription
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the  method to set the System Check1 # Status description
    ******************************************************************************************/      
    public string getStatusDescription(boolean censusStatus,contract contRec,boolean lsgsic){            
        ARV_AP07_QueryDataHelper.paramId1=contRec.Id;
        ARV_AP07_QueryDataHelper.paramId2=pckgPlanId;
        String pckgplnqry=System.Label.ARV_CL47_PCKGPLANS;
        list<vlocity_ins__ContractLineItem__c> planlist=ARV_AP07_QueryDataHelper.getsObjects(pckgplnqry,
        PCKGPLANWHERECLAUSE,null,CENSMEMLIMIT);        
        for(vlocity_ins__ContractLineItem__c plan: planlist){
         
            if(CBH.EQUALS(plan.Product_Family__c)){
                communityRule = TRUE_VAL;
            }else if(SBH.equals(plan.Product_Family__c)){
                simplyBlueRule = TRUE_VAL; 
            }else if(BHRULE.equals(plan.Product_Family__c)){
                bcnHraRule = TRUE_VAL;
            }else{}
        }
        if(communityRule || simplyBlueRule || bcnHraRule){
            prodFamilyRule = TRUE_VAL;
        }
        

        dtVAL= System.Today();
        Date rq= contRec.ARV_Requested_Effective_Date__c;
        rqstr=String.ValueOf(rq);
        rqmon= rqstr.subString(5,7);
        thisday= String.ValueOf(System.Today());
        thismon= thisday.subString(5,7);
        sdate=contRec.ARV_TECH_SubmissionDate__c!=null?
        String.valueOf(contRec.ARV_TECH_SubmissionDate__c):String.valueOf(dtVAL);//feb 18 changes end
        checkdt=sdate.subString(8,10);
        datval= Integer.ValueOf(checkdt);
        if((datval>=Integer.ValueOf(System.Label.ARV_CL50_Submission_Start_Date))&&
        (datval<=Integer.ValueOf(System.Label.ARV_CL51_Submission_End_Date))&&
        (Integer.ValueOf(thismon)+1==Integer.ValueOf(rqmon))){
            enrollmentsubmission=TRUE_VAL;
        }
        tempStatus=getTempstatus(censusStatus,contRec,lsgsic);
        return tempStatus;
    }
    /*****************
    MethodName:getTempstatus
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the  method  that will store the string to be displayed in system check1# status field
    ***************/
    public String getTempstatus(boolean censusStatus,contract contRec,Boolean lsgsic){
        tempStatus+= communityRule ? COMMUNITYBLUE+COMMA :SPACE;
        tempStatus+= simplyBlueRule ? SIMPLYBLUE+COMMA : SPACE;
        tempStatus+= bcnHraRule ? BCNHRA+COMMA : SPACE;
        tempStatus+= censusStatus ? ENROLLINGEMPLYS+COMMA : SPACE;  
        tempStatus+= contRec.ARV_Offices_Branches_OtherLocations__c==YES?MULTIPLELOCATIONS+COMMA :SPACE;
        tempStatus+= contRec.ARV_SIC_CodeFormula__c ==SIC||lsgsic?SICCODE+COMMA : SPACE;
        tempStatus+= contRec.ARV_Total_FTE__c==1?FTEMET+COMMA : SPACE;
        tempStatus+= YES.equals(contRec.ARV_Is_Common_Control__c)?COMMONCONTROL+COMMA : SPACE;
        //tempStatus+= ((datval>=16))&&(datval<=20)?ENROLLMENTSUBMISSIONDATE+sdate+COMMA : SPACE;
        tempStatus+= (enrollmentsubmission==TRUE_VAL)?ENROLLMENTSUBMISSIONDATE+sdate+COMMA : SPACE;
        tempStatus+= contRec.ARV_Segmentation_Type__c!=null?SEGMENTATIONTYPE+
        String.valueOf(contRec.ARV_Segmentation_Type__c)+COMMA : SPACE;       
        tempStatus+= freeStandingDntl?FREESTANDING+COMMA:SPACE;
        tempStatus+= FEDTAXCHECK?FEDTAXID+COMMA:SPACE;
        tempStatus+= (COMPVALUE==TRUE)?'MemberType=Comp'+COMMA :SPACE;
        tempStatus+= (CENCOSCHECK==TRUE_VAL)?GROUPONE+COMMA :SPACE;
        //public string compvalue1=ARV_AP103_GWC_SystemCheck_Criteria.dummymthd(contRec.id);
        //tempStatus+= (ARV_AP103_GWC_SystemCheck_Criteria.dummymthd(contRec.id))?'Check Vol Dental'+COMMA : SPACE;
       // tempStatus+= (PEDIATRICDENTAL==TRUE_VAL)?'Pediatric Dental'+COMMA:SPACE;
        tempStatus+= (TRUESTRING.equals(system.label.ARV_CL44_Additional_Underwriter_Review))?UNDERWRITERREVIEW+COMMA:SPACE;
        return tempStatus;
    }
       
    /*****************************************************************************************
    Method Name  : getContractStatus
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the  method to check what all the crieria are met  finally to  set the system check1 # status description.
    ******************************************************************************************/          
    public string getContractStatus(contract contRec, boolean censusCheck,boolean lsgsic){
        system.debug('@@@@@in class'+contRec);
        system.debug('contRec.ARV_Total_FTE__c@@'+contRec.ARV_Total_FTE__c);
        system.debug('censusCheck@@'+censusCheck);
        system.debug('contRec.ARV_SIC_CodeFormula__c@@'+contRec.ARV_SIC_CodeFormula__c);
        system.debug('SIC@@'+SIC);
        system.debug('enrollmentsubmission@@'+enrollmentsubmission);
        system.debug('freeStandingDntl@@'+freeStandingDntl);
       //system.debug('PEDIATRICDENTAL@@'+PEDIATRICDENTAL);
        system.debug('prodFamilyRule@@'+prodFamilyRule);
        system.debug('lsgsic@@'+lsgsic);
        system.debug('contRec.ARV_Segmentation_Type__c@@'+contRec.ARV_Segmentation_Type__c);
        system.debug('system.label.ARV_CL44_Additional_Underwriter_Review@@'+system.label.ARV_CL44_Additional_Underwriter_Review);
        system.debug('COMPVALUE@@'+COMPVALUE);
        system.debug('CENCOSCHECK@@'+CENCOSCHECK);
        system.debug('contRec.ARV_Is_Common_Control__c@@'+contRec.ARV_Is_Common_Control__c);
        system.debug('contRec.ARV_TECH_Account_Merge__c@@'+contRec.ARV_TECH_Account_Merge__c);
        
        if(( contRec.ARV_Total_FTE__c==ONE || censusCheck || SIC.equals(contRec.ARV_SIC_CodeFormula__c) || 
        enrollmentsubmission || freeStandingDntl  || prodFamilyRule ||lsgsic||
        contRec.ARV_Segmentation_Type__c!=Null ||  YES.equals(contRec.ARV_Is_Common_Control__c) || 
        FEDTAXCHECK ||YES.equals(contRec.ARV_Offices_Branches_OtherLocations__c))
        || TRUESTRING.equals(system.label.ARV_CL44_Additional_Underwriter_Review ) || COMPVALUE||CENCOSCHECK) 
        {            
            tempStatus = URUR; 
            System.debug('tempStatus::'+tempStatus);
                
            
        }
       
      
        else{                               
            tempStatus=APRVDVLDT;
        }
        return tempStatus;
    }
    /*****************************************************************************************
    Method Name   : udpateContract
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the  method to check that updates Contract Status and Contract System check1 # status.
    ******************************************************************************************/          
    public void udpateContract(string cStatusDesc,string conStatus,contract contRecord1){
        try{    
            String tempterm=SPACE;
            contract contRecord = new contract(Id=contRecord1.Id);
            contRecord.ARV_Submitting_User__c=UserInfo.getUserId();
            contRecord.ARV_Date_Submitted__c=System.Today();
            if(URUR.equals(conStatus)){
                contRecord.status= conStatus;
                contRecord.ARV_Is_Mass_Updating__c=True;
                if(cStatusDesc.endsWith(COMMA)){
                    tempterm = cStatusDesc.removeEnd(COMMA);
                    cStatusDesc =tempterm;
                    contRecord.ARV_System_Check_1_Status__c = cStatusDesc;                
                }
            }
            //system.debug(':::contRecord.ARV_System_Check_1_Status__c line  :::'+ contRecord.ARV_System_Check_1_Status__c);
            else if(APRVDVLDT.equals(conStatus)){
                contRecord.ARV_System_Check_1_Status__c = SPACE;
                contRecord.status= conStatus;
                Map <String, Object> ipInput = new Map <String, Object>();
                Map <String, Object> ipOutput = new Map <String, Object>();
                Map <String, Object> ipOptions = new Map <String, Object>();
                ipInput.put('contractID',contRecord.id);
                 vlocity_ins.IntegrationProcedureService.runIntegrationProcedureQueueable(PROCEDURE_NAME,ipInput,ipOptions);
                //contRecord use this to pass as ContextID for our IP
                //ARV_AP66_ApproveContractcreateRecrds.aprvUnmatchContrct(contRecord.id);
                contRecord.ARV_TECH_Hide_Approve_Button__c=true;
            } else {}            
            database.update(contRecord);                       
        }catch(Exception e){
            //throw new AuraHandledException(e.getMessage()+e.getlinenumber());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP61_UpdateContractDetails11', 'udpateContract');
        }
    }   
    /****************************
    Method Name   : getContractStatus
    Date Created : 27-DEC-2019
    Created By   : IDC Offshore
    Description  :This is the  method to check SIC code under common control section in PARTB 
    ******************************/
    public Boolean getLocsegsic(Contract cont){
        String locpkgqry=System.Label.ARV_CL_45_LocSegment;
        ARV_AP07_QueryDataHelper.paramId1=cont.Id;
        ARV_AP07_QueryDataHelper.paramName=SIC;
        List<LocationPackage__c> locseg=ARV_AP07_QueryDataHelper.getsObjects(locpkgqry,LOCKPKGWHERECLAUSE,null,CENSMEMLIMIT);
        return (locseg.size()>0)?TRUE_VAL:FALSE_VAL;
     }
}