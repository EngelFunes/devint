/*
 *  
 */
global without sharing  class ARV_AP103_GWC_SystemCheck_Criteria implements vlocity_ins.VlocityOpenInterface { 
private static Boolean CheckVolDen1 =false;
private static Boolean CheckVolDen2 =false;
private static Boolean CheckVolDentalFlag =false;
private static Boolean CheckVolVis1 =false;
private static Boolean CheckVolVis2 =false;
private static Boolean CheckVolVis3 =false;
private static Boolean CheckVolVisionFlag = false;
private static Boolean DeleteGSFlag=false;
private static Boolean CheckHBA1=false;
private static Boolean CheckHBA2=false;
private static Boolean CheckHBAFlag=false;
private static Boolean CheckBCNCDH1=false;
private static Boolean CheckBCNCDH2=false;
private static Boolean CheckBCNCDHFlag=false;
private static Boolean CheckVolDenVis1=false;
private static Boolean CheckVolDenVis2=false;
private static Boolean CheckVolDenVis3=false;
private static Boolean CheckVolDenVis4=false;
private static Boolean CheckVolDenVisFlag=false;
private static boolean RetroactiveFlag=false;
private static boolean GWCRenPrdFlag=false;
public  static string  AddCCSegment; 
public  static string  AdditionalSegementRadio;
private static final string OPENBRACE  = '[';
private static final string CLOSEBRACE  = ']';
private static final string PACKAGESELECTION='PackageSelection';
private static final string PACKAGEQUERY = 'select Id,ARV_Pediatric_Dental_Plan__c, '+
' ARV_Dental_Plan__r.vlocity_ins__ProductType__c,ARV_Vision_Plan__r.vlocity_ins__ProductType__c from Package__c';
private static final string PACKAGEWHERE =' where ARV_Contract_Id__c=:paramId1 and '+
' (ARV_Dental_Plan__r.Voluntary_Contributory__c=:paramName or ARV_Vision_Plan__r.Voluntary_Contributory__c=:paramName)'+
' and (ARV_Dental_Plan__r.vlocity_ins__ProductType__c=:paramName1 or '+ 
' ARV_Vision_Plan__r.vlocity_ins__ProductType__c=:paramName1) ';
Private Map<Id,Package__c> packageId = NULL; 
Private Map<Id,List<Package__c>> packListMap = NULL;
private static final String SPACE='';
private static string COLON=':';
Private Static String CheckVolDental='Check Vol Dental';
Private Static String CheckVolVision='Check Vol Vision';
Private Static String CheckHBA='Check HBA';
Private Static String CheckBCNCDH='Check BCN CDH';
Private Static string CheckVolDencomb='Check Vol Dental';
Private Static string CheckVolViscomb='Check Vol Vision';
private static final String UNDERREVIEW= 'Under Review';
private static final String UNDERWRITING= 'UW';
private static final String Administrative= 'Administrative';
private static final String NOTOFFERED= 'Not Offered';
private String VOLUNTARY= ARV_AP41_StringLiteralUtils.VOLUNTARY;
public static final String PROFILENAMEADM='System Administrator';
public static final String PROFILENAMESUP='Support Admin';
public static final String PROFILENAMEUW='Small Group Underwriter';
public static final String PROFILENAMEUWM='Small Group Underwriting Manager';
private String NONVOLUNTARY= ARV_AP41_StringLiteralUtils.NONVOLUNTARY;
private String BCBS= ARV_AP41_StringLiteralUtils.BCBSTYPE;
private String BCN= ARV_AP41_StringLiteralUtils.BCNTYPE;
private static String SMALLGRPGWC = 'Small Group GWC';
private String BCNHSA=ARV_AP41_StringLiteralUtils.HSA;
private String HEALTHBLUEACHIEVE=ARV_AP41_StringLiteralUtils.HBAVAL;
Private Static string contempStatus='';
Private Static string COMMA=',';
private Static String SKIPSTATUS='Approved – validate data/setup Group segments';
Private Static String GWCSTATUS='GWC Submitted';
Private Static String GWCRenPrd='GWC Late in Renewal Period';
Private Static String Retroactive='Retro GWC';
Private static String RatingCheck='Rating Area Change';
public static final String SCSSMSGAPPRV=system.label.ARV_CL_GWC_Apprve_Message;
public static final String ERRMSG=system.label.ARV_CL43_Contract_Update_Error;
public static final string CLSNAME='ARV_AP103_GWC_SystemCheck_Criteria';
public static final string METHODNME='aprvGWCContrct';
private static final string typeOfApproval  = '';
public static final String SCSSMSGREJ='Contract is successfully rejected.';



/*****************************************************************************************
Method Name : invokeMethod. 
Date Created : 28-SEP-2020
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting GWC Flow
*******************************************************************************************/
global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options){           
                                    Boolean success = true;
                                 try{
                                        if (methodName == 'gwcPlansSystemCheck') 
                                        gwcPlansSystemCheck(input,output,options);
                                        
                                    }catch(Exception e){
                                     system.debug('line number@@ '+e.getLineNumber()); 
                                     system.debug('error is::'+e.getMessage());  
                                    }
                                    return success;
}
global void gwcPlansSystemCheck(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
{
     system.debug('contract in main class');
     String contractId= String.valueof(input.get('contractId')); 
    
     DeleteGSFlag=boolean.valueOf(input.get('deleteGSFlag'));
    system.debug('contract in main class'+contractId);
    Map<string,Object> groupInfoMap = (Map<string,Object>)input.get('GroupInformation');
    Map<String,Object> productSelection=(Map<string,Object>)input.get('Productselection');
     AddCCSegment=string.valueOf(productSelection.get('AddCCSegment')); 
     system.debug('AddCCSegment'+AddCCSegment);
     AdditionalSegementRadio=string.valueOf(productSelection.get('additionalSegementRadio'));
     String gwcReqEffDate=String.valueOf(groupInfoMap.get('GWCReqEffDateFormula'));
     String prvsContrctReqEffDate=String.valueOf(input.get('finalContReqEffDate'));
    Map<string,Object> quoteMap = (Map<string,Object>)input.get('quoteDetail');
        string gwcRatingArea=String.valueOf(quoteMap.get('ARV_CF_Tech_RatingArea__c'));
        string prvsContrctRatingArea=String.valueOf(input.get('finalContRA'));
       //String contractid=conid;
       System.debug('::: Contract Id::'+contractId);
       String pckName= null;
       System.debug('::: Contract Id::'+contractId);
    updatePckGroupSeg(contractId);
            Contract con = new Contract();
        con = [select id,Status,ARV_GWC_System_Check_1_Status__c,ARV_TypeofCheck__c,ARV_Tech_GWC_SystemChcek1_Status__c from Contract where id=:contractId];
        List<Package__c> packlist =[select id,ARV_GWC_Package_Change_Attributes__c from Package__c where 
                                    ARV_Contract_Id__c=:contractId];
        System.debug('::: Packlist::'+packlist[0].ARV_GWC_Package_Change_Attributes__c);
        for(Package__c Pkg:packlist) {
            if(pkg!=null){
                if(pkg.ARV_GWC_Package_Change_Attributes__c!=null){
                Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(pkg.ARV_GWC_Package_Change_Attributes__c);   
                System.debug('obj'+obj);
                string newDentalPlan=(string)obj.get('New Dental Plan:');
                string oldDentalPlan=(string)obj.get('Old Dental Plan:');
                string newVisionPlan=(string)obj.get('New Vision Plan:');
                string oldVisionPlan=(string)obj.get('Old Vision Plan:');
                string newDentalProdCode=(string)obj.get('New Dental Product Code:');
                string oldDentalProdCode=(string)obj.get('Old Dental Product Code:');
                string newVisionProdCode=(string)obj.get('New Vision Product Code:');
                string oldVisionProdCode=(string)obj.get('Old Vision Product Code:');
                System.debug('newDentalPlan' +newDentalPlan);
                System.debug('oldDentalPlan'+oldDentalPlan);
                System.debug('newVisionPlan' +newVisionPlan);
                System.debug('oldVisionPlan'+oldVisionPlan);
                string newDentalType=(string)obj.get('New Dental Type:');
                string oldDentalType=(string)obj.get('Old Dental Type:');
                string newVisionType=(string)obj.get('New Vision Type:');
                string oldVisionType=(string)obj.get('Old Vision Type:');
                string oldCarrier=(string)obj.get('Old Carrier:');
                string newCarrier=(string)obj.get('New Carrier:');
                string oldMedicalPlan=(string)obj.get('Old Medical Plan:');
                string newMedicalPlan=(string)obj.get('New Medical Plan:');
                string newMedProdCode=(string)obj.get('New Medical Product Code:');
                string oldMedProdCode=(string)obj.get('Old Medical Product Code:');
                string oldProductFamily=(string)obj.get('Old Product Family:');
                string newProductFamily=(string)obj.get('New Product Family:');
                string oldCDHPckgComb=(string)obj.get('Old CDH Package Combination:');
                string newCDHPckgComb=(string)obj.get('New CDH Package Combination:');
                System.debug('newDentalType' +newDentalType);
                System.debug('oldDentalType'+oldDentalType);
                    if(newCarrier==BCBS || newCarrier==BCN){
                        
                        system.debug('*****Condition1*****');
                        if((oldDentalProdCode!=newDentalProdCode) && (oldDentalType==VOLUNTARY && newDentalType==VOLUNTARY))
                        {
                            CheckVolDen2=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            system.debug('**CheckVolDen2**'+CheckVolDen2);
                            
                        }
                        system.debug('*****Condition2*****');
                        if(oldDentalType==VOLUNTARY && newDentalType==NONVOLUNTARY)
                        {    CheckVolDen1=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            }
                        
                        
                    }
                    if(newCarrier==BCBS){
                            system.debug('*****Condition3*****');
                            if((oldProductFamily==HEALTHBLUEACHIEVE && newProductFamily==HEALTHBLUEACHIEVE) && (oldMedicalPlan!=newMedicalPlan))
                            {
                                                            CheckHBA1=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
                            }
                            system.debug('*****Condition4*****');
                            if(oldProductFamily==HEALTHBLUEACHIEVE && newProductFamily!=HEALTHBLUEACHIEVE)
                            {
                                CheckHBA2=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                system.debug('****CheckHBA2****'+CheckHBA2);
                                   
                            
                            }  
                    }
                    if(newCarrier==BCN){
                        system.debug('*****Condition5*****');
                        if((oldVisionProdCode!=newVisionProdCode) && (oldVisionType==VOLUNTARY && newVisionType==VOLUNTARY))
                            {
                            
                                CheckVolVis2=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
                            }
                            //US-4328
                            system.debug('*****Condition6*****');
           
                            //Group has  Voluntary Vision and replaces with a NonVoluntary Vision plan 
                            if(oldVisionType==VOLUNTARY && newVisionType==NONVOLUNTARY)
                            {
                                CheckVolVis1=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            }
                            
                            system.debug('*****Condition7*****');
                            if(newVisionPlan!=null){
                               // Group has Voluntary and replaces with no Vision plan (PedVision)  Vision plan
								if(oldVisionType==VOLUNTARY && (newVisionPlan.contains('Pediatric') || newVisionPlan==NOTOFFERED)){
                                	system.debug('*****EmteredCondition7*****');
                                    CheckVolVis3=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            	}
                        	}
                        //US-4328 ends
                           system.debug('*****Condition8*****');
                        
                            if(oldProductFamily==BCNHSA &&newProductFamily==BCNHSA &&oldCDHPckgComb!=ARV_AP41_StringLiteralUtils.NOVAL &&newCDHPckgComb!=ARV_AP41_StringLiteralUtils.NOVAL &&oldMedicalPlan!=newMedicalPlan)
                            {
                                    CheckBCNCDH1=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
                            }
                            system.debug('*****Condition9*****');
                            if(oldProductFamily==BCNHSA &&newProductFamily!=BCNHSA &&oldCDHPckgComb!=ARV_AP41_StringLiteralUtils.NOVAL && (newCDHPckgComb==ARV_AP41_StringLiteralUtils.NOVAL ||newCDHPckgComb==null) &&oldMedicalPlan!=newMedicalPlan)
                                {
                                    CheckBCNCDH2=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                             
                                }
                            system.debug('*****Condition10*****');
                            if(oldDentalType==VOLUNTARY && oldVisionType==VOLUNTARY && newVisionType==VOLUNTARY && newDentalType==VOLUNTARY && oldDentalProdCode!=newDentalProdCode && oldVisionProdCode!=newVisionProdCode)
                            {
                                
                             
                                    CheckVolDenVis1=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                             
                            }
                            system.debug('*****Condition11*****');
                            if(oldDentalType==VOLUNTARY && oldVisionType==VOLUNTARY && newVisionType==NONVOLUNTARY && newDentalType==NONVOLUNTARY )
                            {
                                    CheckVolDenVis2=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                              
                            }
                            system.debug('*****Condition12*****');
                            if(oldDentalType==VOLUNTARY && oldVisionType==VOLUNTARY && newDentalType==VOLUNTARY && newVisionType==NONVOLUNTARY && oldDentalProdCode!=newDentalProdCode)
                            {
                                    CheckVolDenVis3=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                              
                            }
                            system.debug('*****Condition13*****');
                        if(oldDentalType==VOLUNTARY && oldVisionType==VOLUNTARY && newDentalType==NONVOLUNTARY && newVisionType==VOLUNTARY && oldVisionProdCode!=newVisionProdCode)
                            {
                                    CheckVolDenVis4=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                              
                            }
                    }
                }
            }
        }  
           /* Retro active Code Block*/
    
   String ACCID =String.valueof([select id,Name,accountId from contract where id=:contractId][0].AccountId);
      List<Contract> cntrctlist=[select id,ARV_Requested_Effective_Date__c from contract where accountid=:ACCID Order by CreatedDate DESC limit 1];
        if(cntrctlist.size()>0){
            Date reqeffdate= cntrctlist[0].ARV_Requested_Effective_Date__c; 
            Date currentDate=system.Today();
            System.debug('cntrctlist:::'+cntrctlist);
            System.debug('reqeffdate::'+reqeffdate);
            if(reqeffdate < currentDate){
              RetroactiveFlag= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            output.put('RetroactiveFlag',true);
        }
    else{
        RetroactiveFlag=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
         output.put('RetroactiveFlag',false);
        }
        }
    
    //Retro END
    
    
    
/* Late in Renewal Code block */
    
        String ACCNID =String.valueof([select id,Name,accountId from contract where id=:contractId][0].AccountId);
        System.debug('ACCID::'+ACCID);
        List<Contract> cntrctlist1=[select id,RecordType.Name,ARV_Requested_Effective_Date__c from contract where accountid=:ACCNID and RecordType.name ='Renewal' Order by CreatedDate DESC limit 1 ];
        List<Contract> cntrctlist2=[select id,ARV_Requested_Effective_Date__c,ARV_Requested_Renewal_Date_Month__c from contract where accountid=:ACCNID  Order by CreatedDate DESC limit 1 ];
        System.debug('CNTCRTKJ::'+cntrctlist1);
        System.debug('CNTCRTKJ::'+cntrctlist2);
        if(cntrctlist1.size()>0 && cntrctlist2.size()>0){
            Date gwcContract= cntrctlist2[0].ARV_Requested_Effective_Date__c; 
            System.debug('gwcContract '+ gwcContract);
            
            Date gwcrendate =cntrctlist2[0].ARV_Requested_Renewal_Date_Month__c;
            System.debug('gwcrendate '+ gwcrendate);
            Date Renewalcontract= cntrctlist1[0].ARV_Requested_Effective_Date__c;
            Integer monthDiff1 = gwcContract.month()-Renewalcontract.month();
            system.debug('monthDiff1 '+monthDiff1);
            Integer yearDiff= gwcContract.year()-Renewalcontract.year();
            System.debug('NEW::'+gwcContract);
            System.debug('old::'+Renewalcontract);
            System.debug('monthDiff1::'+monthDiff1);
            if(yeardiff==0 && (monthDiff1==-1 || monthDiff1==-2 || monthDiff1==-3)){
                GWCRenPrdFlag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                System.debug('GWCRenPrdFlag:::'+GWCRenPrdFlag);
                
                output.put('GWCRenPrdFlag',true);
            }
            
            else {
                GWCRenPrdFlag=ARV_AP41_StringLiteralUtils.FALSE_VALUE; 
                output.put('RetroactiveFlag',false);
            }
        }
        
       
         
    /* Rating Check Block */
  boolean RatingCheckFlag=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
  
if(prvsContrctRatingArea!=null && (gwcRatingArea!=prvsContrctRatingArea)){
RatingCheckFlag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
output.put('RatingCheckFlag',true);
}
else{
RatingCheckFlag=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
// output.put('RatingCheckFlag',false);
}
System.debug('RatingCheckFlag::'+RatingCheckFlag);

    
    //End Of Contract Related Code Blocks //
    
          
        if(CheckVolDen1||CheckVolDen2){
            CheckVolDentalFlag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
           // output.put('CheckVolDentalFlag','true');
            system.debug('***CheckVolDentalFinal***'+CheckVolDental);
        }
    else{
        CheckVolDentalFlag=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
       // output.put('CheckVolDentalFlag','false');
    }
        if(CheckVolVis1||CheckVolVis2||CheckVolVis3){
            CheckVolVisionFlag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            //output.put('CheckVolVisionFlag','true');
           
        }
    else{
        CheckVolVisionFlag=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
       // output.put('CheckVolVisionFlag','false');
    }
        if(CheckHBA1||CheckHBA2){
            CheckHBAFlag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            system.debug('***CheckHBAFinal***'+CheckHBA);
        }
        if(CheckBCNCDH1||CheckBCNCDH2){
            CheckBCNCDHFlag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            system.debug('***CheckBCNCDHFinal***'+CheckBCNCDH);
        }
        if(CheckVolDenVis1||CheckVolDenVis2||CheckVolDenVis3||CheckVolDenVis4){
            CheckVolDenVisFlag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            system.debug('***CheckVolDenVisFinal***'+CheckVolDencomb+','+CheckVolViscomb);
        }
        
    
    if(CheckVolDentalFlag||CheckVolVisionFlag||CheckHBAFlag||CheckBCNCDHFlag||CheckVolDenVisFlag){
    con.ARV_TypeofCheck__c= Administrative; 
    }
    if(RetroactiveFlag||GWCRenPrdFlag||RatingCheckFlag){
        if(con.ARV_TypeofCheck__c!=null){
        con.ARV_TypeofCheck__c = con.ARV_TypeofCheck__c+';'+UNDERWRITING; 
        }
        else{
           con.ARV_TypeofCheck__c = UNDERWRITING;
           }
    }
    
    if(CheckVolDentalFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=CheckVolDental+COMMA;
    }
    if(CheckVolVisionFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=CheckVolVision+COMMA;
    }
    if(CheckHBAFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=CheckHBA+COMMA;
    }
    if(CheckBCNCDHFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=CheckBCNCDH+COMMA;
    }
    if(CheckVolDenVisFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=CheckVolDencomb+COMMA+CheckVolViscomb+COMMA;
    }
    if(RetroactiveFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=Retroactive+COMMA;
    }
    if(GWCRenPrdFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=GWCRenPrd+COMMA;
    }
    if(RatingCheckFlag== ARV_AP41_StringLiteralUtils.TRUE_VALUE){
      contempStatus+=RatingCheck+COMMA;
    }
    contempStatus = contempStatus.removeEnd(COMMA);
    system.debug('contempStatus::'+contempStatus);
    if(con.ARV_GWC_System_Check_1_Status__c==null){
    con.ARV_GWC_System_Check_1_Status__c=contempStatus;
    }
    else
    {
    con.ARV_GWC_System_Check_1_Status__c+=COMMA;
    con.ARV_GWC_System_Check_1_Status__c+=contempStatus;
    }
    if(String.isNotBlank(contempStatus) || String.isNotBlank(con.ARV_GWC_System_Check_1_Status__c)){
    con.Status = UNDERREVIEW;
    system.debug('statusforflgs***'+con.status);
    }
    else
    {
    con.status=SKIPSTATUS;
        //ARV_GWC_CloneGroupSegments.cloneGroupSegmentRecord(con.Id);
    }
    System.debug('FinalStatus--->'+con.ARV_GWC_System_Check_1_Status__c);
   if (con.ARV_GWC_System_Check_1_Status__c == null || con.ARV_GWC_System_Check_1_Status__c == '' )
   {
       con.ARV_Tech_GWC_SystemChcek1_Status__c ='GWC Criteria Did Not Met';
   }
   System.debug('ARV_Tech_GWC_SystemChcek1_Status__c @@@ '+con.ARV_Tech_GWC_SystemChcek1_Status__c);
       // output.put('CheckVolDentalFlag2','true');
    update con;
    ARV_GWC_CloneGroupSegments.cloneGroupSegmentRecord(con.Id);
    try{
    system.debug('AddCCSegment'+AddCCSegment);
    //ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(con.Id,gwcReqEffDate,prvsContrctReqEffDate,AddCCSegment,AdditionalSegementRadio,DeleteGSFlag);
    }
    Catch(Exception e){
        system.debug('Check2ErrorLineNumber::'+e.getLineNumber());
        system.debug('Check2ErrorMsg::'+e.getMessage());
    }
   // ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(con.Id);
         
}
@AuraEnabled
    public static string aprvGWCContrct(string contractId)
    {           
        try{
            id userid=UserInfo.getUserId();
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            system.debug('profileName::'+profileName);
            Id gwcTTRcrdTypId = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Group Wide Changes').getRecordTypeId();
            List<ARV_GWC_Transaction_Table__c> gwcTTList=[select id,Contract__c,Approver__c,Approved_Date__c,RecordTypeId from ARV_GWC_Transaction_Table__c where RecordTypeId=:gwcTTRcrdTypId AND Contract__c=:contractId ];
            Contract contRecQry =[select id,ARV_Type_of_Approval__c,ARV_TypeofCheck__c,ARV_UW_Approval__c,name,AccountId,Status,ARV_TECH_Account_Merge__c,ARV_Is_Mass_Updating__c,ARV_Contract_Type__c,ARV_Requested_Effective_Date__c from contract where id =:contractId ];
            system.debug('contRecQry::'+contRecQry);
            system.debug('type check::'+contRecQry.ARV_TypeofCheck__c);
            List<contract> contactList=[select id,accountId,recordtype.name,ARV_Contract_Type__c,ARV_Requested_Effective_Date__c,ARV_GWC_AddCCSegment__c,ARV_GWC_additionalSegmentRadio__c,ARV_GWC_DeleteGSFlag__c from contract where accountId=:contRecQry.AccountId];
            string prvsContReqEffDate='';
            for(Contract cont:contactList){
                if(cont.ARV_Contract_Type__c=='Small Group Renewal'){
                    prvsContReqEffDate=string.valueof(cont.ARV_Requested_Effective_Date__c);
                }
                else if(cont.ARV_Contract_Type__c=='Small Group Enrollment'){
                    prvsContReqEffDate=string.valueof(cont.ARV_Requested_Effective_Date__c);
                } else if(cont.ARV_Contract_Type__c=='Small Group GWC'){
                    AddCCSegment=cont.ARV_GWC_AddCCSegment__c;
                    AdditionalSegementRadio=cont.ARV_GWC_additionalSegmentRadio__c;
                    DeleteGSFlag=cont.ARV_GWC_DeleteGSFlag__c;                  
                }
            }
            system.debug('prvsContReqEffDate::'+prvsContReqEffDate);
            string typecheck=contRecQry.Arv_typeofcheck__c;
            if(contRecQry.ARV_Contract_Type__c=='Small Group GWC' && contRecQry.Status==UNDERREVIEW){
                system.debug('inside main if');
                system.debug(typecheck=='UW');
                if(contRecQry.ARV_TypeofCheck__c.containsOnly(UNDERWRITING) &&(profileName==PROFILENAMEUW)||(profileName==PROFILENAMEUWM)){
                    system.debug('inside condition 1');
                    contRecQry.ARV_UW_Approval__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                    contRecQry.Status=SKIPSTATUS;
                    contRecQry.ARV_Type_of_Approval__c=profileName;
                    database.update(contRecQry);
                }
                if(contRecQry.ARV_TypeofCheck__c.containsOnly(Administrative) &&(profileName==PROFILENAMEADM ||profileName==PROFILENAMESUP)){
                system.debug('inside condition 2');
                contRecQry.ARV_Is_Mass_Updating__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                contRecQry.Status=SKIPSTATUS;
                contRecQry.ARV_Type_of_Approval__c=profileName;
                database.update(contRecQry);
                if(gwcTTList.size()>0){
                    for(ARV_GWC_Transaction_Table__c gwcTT:gwcTTList){
                        gwcTT.Approver__c=userid;
                        gwcTT.Approved_Date__c=system.now();
                    }
                    update gwcTTList;
                }
               // ARV_GWC_CloneGroupSegments.cloneGroupSegmentRecord(contractId);
            }
            
            
            // Dual Approval condition
                if(typecheck=='Administrative;UW'){
                    if(profileName==PROFILENAMEADM ||profileName==PROFILENAMESUP){
                    system.debug('inside condition 3');
                    contRecQry.ARV_Is_Mass_Updating__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                    contRecQry.Status=SKIPSTATUS;
                    contRecQry.ARV_Type_of_Approval__c=profileName;
                    database.update(contRecQry);
                    }
                    if(profileName==PROFILENAMEUW||(profileName==PROFILENAMEUWM)){
                         system.debug('inside condition 4');
                        contRecQry.ARV_UW_Approval__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                        system.debug('ARV_UW_Approval__c '+contRecQry.ARV_UW_Approval__c);
                        contRecQry.ARV_Type_of_Approval__c=profileName;
                        //contRecQry.Status='Under Review';
                        database.update(contRecQry);
                    }
                 }
            }
            
            
            //END
            String gwcReqEffeDate=string.valueof(contRecQry.ARV_Requested_Effective_Date__c);
            system.debug('Calling GS class');
            ARV_GWC_CloneGroupSegments.cloneGroupSegmentRecord(contractId);
            system.debug(' After Calling GS class');
            //ARV_AP104_GWC_SystemCheck2_Criteria.gwcSystemCheck2(contractId,gwcReqEffeDate,prvsContReqEffDate,AddCCSegment,AdditionalSegementRadio,DeleteGSFlag);
            return SCSSMSGAPPRV;        
        }
        
        catch(exception e)
        {
            //ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);
            system.debug('Error::'+e.getLineNumber()) ;   
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, METHODNME, contractId);
            return ERRMSG;
        }
        
    }
    /* @AuraEnabled 
    public static void fetchUserprof(Id conId){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        contract cnt=[Select id,ARV_Type_of_Approval__c from contract where id=:conId];
        cnt.ARV_Type_of_Approval__c=profileName;
        update cnt;
    }
    */
    public static void updatePckGroupSeg(String conId){
     List<Package__c> pckfinal= [select id,  ARV_GWC_Benefit_Package_Type__c, GS_number__c from  Package__c where ARV_GWC_Benefit_Package_Type__c='Terminate' and ARV_Contract_Id__c=:conId ];  
              Map<string,Id> mapVal=new Map<string,Id>();
              set<string> gsName=new set<string>();
              if(!pckfinal.isEmpty()){
                  for(Package__c pck:pckfinal){
                      gsName.add(pck.GS_number__c);
                    mapVal.put(pck.GS_number__c,pck.Id);
                 }
                     

                 List<GA_Group_Segment__c> gslist=[select id,Name,ARV_Pending_PackageId__c from GA_Group_Segment__c  where Name in:gsName];
                  system.debug('gslist::'+gslist);
                 List<GA_Group_Segment__c> gslistupddate=new list<GA_Group_Segment__c>();
                    GA_Group_Segment__c gsdec;
                    for(GA_Group_Segment__c ga:gslist){
                         gsdec=new GA_Group_Segment__c();
                         gsdec.Id=ga.Id;
                         gsdec.ARV_Pending_PackageId__c=mapVal.get(ga.Name);
                         gslistupddate.add(gsdec);
                    }
                 
                    if(gslistupddate.size()>0){
                    update gslistupddate;
                    }
                   
              }
    }
@AuraEnabled 
    public static void fetchUserprof(Id conId){
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
             contract cnt=[Select id,ARV_Type_of_Approval__c from contract where id=:conId];
            cnt.ARV_Type_of_Approval__c=profileName;
            update cnt;
        }
}