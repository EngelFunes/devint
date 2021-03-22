public without sharing class ARV_AP104_GWC_Systemcheck2_new{ //implements vlocity_ins.VlocityOpenInterface {
    private static Boolean CheckVolVis =ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean CheckVolDen=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean RemoveDen=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean RemoveVis=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean CarrierChangeBCNBCBS=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean CarrierChangeBCBSBCN=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean RemovePackageFlag=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean SwitchDental=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean BCNHBL=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean BCNHSA=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean BCNHRA=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean BCNMASSPLAN=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean RETROGWC=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean AddMedPlanLob= ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean RemoveMedPlanLob= ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean AddCDH= ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean SwitchVision= ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean additionalSegement= ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static Boolean AddCCSegmentflag= ARV_AP41_StringLiteralUtils.FALSE_VALUE;
    private static final String HBLSTRING=ARV_AP41_StringLiteralUtils.HBAVAL;
    private static final String HSASTRING='HSA';    
    private static final String HRASTRING='HRA';    
    private static final String TRUESTRING ='true';
    Private Static String AddMedicalPlan='Add Medical LOB';
    Private Static String RemoveMedicalPlan ='Remove Medical LOB';
    Private Static String ADDCDHPlan= 'ADD CDH';
    Private Static String SwitchDentalPlan='Switch Dental Plan';
    Private Static String SwitchVisionPlan='Switch Vision Plan';  
    Private Static String additionalSegementplan='Add Employee Class';
    Private Static String AddCommon= 'Add Common Control ';
    Private Static String RemovePackage='Remove Package';
    Private Static String CheckVolDental='Check Vol Dental';
    Private Static String CheckVolVision='Check Vol Vision';
    Private Static String RemoveDental='Remove Dental';
    Private Static String RemoveVision='Remove Vision';
    Private Static String CheckHBL='Check HBL';
    Private Static String CheckHRA='BCN HRA';
    Private Static String CheckHSA=ARV_AP41_StringLiteralUtils.HSA;
    Private Static String CheckRetroGWC='Retro GWCs';
    Private Static String CheckBCNMASSPLAN='BCN Mass Plan Changes';
    Private Static String CarrierChangeBCNToBCBS='Check Carrier Change BCN BCBS';
    Private Static String CarrierChangeBCBSToBCS='Check Carrier Change BCBS BCN';
    Private Static String GSSTATUS=ARV_AP41_StringLiteralUtils.GSGWCCMP;
    private Static String  SPACE=ARV_AP41_StringLiteralUtils.MYBLANKVAL;
    Private Static string COMMA=ARV_AP41_StringLiteralUtils.COMMAVAL;
    
    public static void gwcSystemCheck2(string conId,string gwcReqEffDate,string prvsContrctReqEffDate,string AddCCSegment,string additionalSegementRadio,Boolean DeleteGSFlag)
    {
        try{
        system.debug('Delete'+DeleteGSFlag);
        set<string> tempStatus=new set<string>();
        String contractId=conId ;
        //String contractid=conid;
        system.debug('Contract::'+contractId);
        Contract con = new Contract();
        con = [select id,Status,ARV_GWC_System_Check_1_Status__c,AccountId,ARV_TypeofCheck__c,
               ARV_Requested_Effective_Date__c,ARV_Tech_SystemCheck2__c,vlocity_ins__ExpiredContractId__c,
               GWC_Request_Type__c from Contract where id=:contractId];
        Contract parentcon = new Contract();
        parentcon = [select id,ARV_Requested_Effective_Date__c from Contract where id=:con.vlocity_ins__ExpiredContractId__c];
        Date gwcreqEffectiveDate=con.ARV_Requested_Effective_Date__c;
        Date prevconreqeffdate=parentcon.ARV_Requested_Effective_Date__c;
        system.debug('con:'+con); 
        List<Package__c> packlist =[select id,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Medical_Transaction__c from Package__c where 
                                    ARV_Contract_Id__c=:contractId];
        for(Package__c Pkg:packlist) {
            if(pkg!=null){
                if(pkg.ARV_GWC_Package_Change_Attributes__c!=ARV_AP41_StringLiteralUtils.NULLSTRING){
                    Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(pkg.ARV_GWC_Package_Change_Attributes__c);   
                    System.debug('obj'+obj);
                    string newDentalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWDENTALPLAN);
                    string newVisionPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWVISIONPLAN);
                    string newDentalType=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWDENTALTYPE);
                    string oldDentalType=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDDENTALTYPE);
                    string newDentalProdCode=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWDENTALPRODCODE);
                    string oldDentalProdCode=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDDENTALPRODCODE);
                    string newVisionType=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWVISIONTYPE);
                    string oldVisionType=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDVISIONTYPE);
                    string newVisionProdCode=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWVISIONPRODCODE);
                    string oldVisionProdCode=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDVISIONPRODCODE);
                    string newCarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWCARRIER);
                    string oldCarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDCARRIER);
                    string oldProductFamily=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDPRODUCTFAMILY);
                    string newProductFamily=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWPRODUCTFAMILY);
                    string oldMedicalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDMEDICALPLAN);
                    string newMedicalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWMEDICALPLAN);
                    String newCDHPlan =(string)obj.get(ARV_AP41_StringLiteralUtils.NEWCDHPLAN);
                    String oldCDHPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDCDHPLAN);    
                    
                    /*
                     * Logic to get Details from meta data
                     */
                    List<Systemcheck2_WFT__mdt> wftmdt=new List<Systemcheck2_WFT__mdt>();
					wftmdt=[select id, Carrier__c,Manual_Automated__c,  
                                                        Method__c,Transaction__c,Type_Of_Change__c,WF_Sub_Type__c,
                                                        WF_Type__c,DeveloperName,MasterLabel,WFT_ID__c from 
                                                        Systemcheck2_WFT__mdt where Manual_Automated__c='Manual'];
			 set<String> wftTransset = new set<String>();
			 for (Systemcheck2_WFT__mdt wftmtdrect : wftmdt) {
				 wftTransset.add(wftmtdrect.Transaction__c);
			 }
			 system.debug('WFT Trasacations size -----' + wftTransset.size());
			 system.debug('WFT Trasacations -----' + wftTransset);
         
           			
                    
                    if(TRUESTRING.equals(system.label.ARV_CL_AllSystemCheck2) && con.status==GSSTATUS){    
                        if(newCarrier==ARV_AP41_StringLiteralUtils.BCBSTYPE)
                        {
                            system.debug('*****Adding Voluntary Dental*****');
                            if(TRUESTRING.equals(system.label.ARV_CL_AddNewVolDental_SystemCheck2) ){
                                if((oldDentalProdCode!=newDentalProdCode) && ((oldDentalType!=ARV_AP41_StringLiteralUtils.VOLUNTARY || oldDentalType==ARV_AP41_StringLiteralUtils.NULLSTRING) && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY))
                                {
                                    CheckVolDen=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    system.debug('**CheckVolDen**'+CheckVolDen);
                                }
                            }
                            system.debug('*****Adding Voluntary Vision*****');
                            if(TRUESTRING.equals(system.label.ARV_CL_AddNewVolVision_SystemCheck2)){
                                if((oldVisionProdCode!=newVisionProdCode) && ((oldVisionType!=ARV_AP41_StringLiteralUtils.VOLUNTARY || oldVisionType==ARV_AP41_StringLiteralUtils.NULLSTRING) && newVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY))
                                {
                                    CheckVolVis=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            system.debug('*****Removing Voluntary Dental*****');
                            if(TRUESTRING.equals(system.label.ARV_CL_RemoveDentalLOB_SystemCheck2)){
                                if(newDentalPlan==ARV_AP41_StringLiteralUtils.NOTOFFERED && (oldDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY || oldDentalType== ARV_AP41_StringLiteralUtils.NONVOLUNTARY))
                                {
                                    RemoveDen=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            system.debug('*****Removing Voluntary Vision*****');
                            if(TRUESTRING.equals(system.label.ARV_CL_RemoveVisionLOB_SystemCheck2)){
                                if(newVisionPlan==ARV_AP41_StringLiteralUtils.NOTOFFERED && (oldVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY || oldVisionType== ARV_AP41_StringLiteralUtils.NONVOLUNTARY))
                                {
                                    RemoveVis=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            
                            if(wftTransset.contains('Retro GWCs')){
                                Date prvreqEffectiveDate= date.valueOf(prvsContrctReqEffDate);
                                Date currentDate=system.Today();
                                system.debug('prevconreqeffdate::'+prevconreqeffdate);
                                system.debug('gwcreqEffectiveDate::'+gwcreqEffectiveDate);
                                if(gwcreqEffectiveDate < prevconreqeffdate ){
                                    RETROGWC=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            //Add Medical Plan Lob Scenario
                            if(wftTransset.contains('Add Medical LOB')){
                                if(oldMedicalPlan!=newMedicalPlan &&(newMedicalPlan!=ARV_AP41_StringLiteralUtils.NULLSTRING)){
                                    
                                    AddMedPlanLob=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }    
                            }
                            //Remove package Check
                            if(wftTransset.contains('Remove Package	')) {
                                if(DeleteGSFlag==ARV_AP41_StringLiteralUtils.TRUE_VALUE) {
                                    RemovePackageFlag= ARV_AP41_StringLiteralUtils.TRUE_VALUE; 
                                    system.debug('RemovePackageFlag'+RemovePackageFlag);
                                }
                            }  
                            
                            // Remove MedicalPlan Lob scenario  
                            if(wftTransset.contains('Remove Medical LOB')) {
                                if(oldMedicalPlan!=newMedicalPlan &&  (newMedicalPlan== ARV_AP41_StringLiteralUtils.NOTOFFERED)) {
                                    
                                    RemoveMedPlanLob= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }          
                            }  
                            // Add CDH to medical Plan 
                            if(wftTransset.contains('Add CDH')){
                                if(oldMedicalPlan==newMedicalPlan && (newCDHPlan != ARV_AP41_StringLiteralUtils.NULLSTRING)){
                                    
                                    AddCDH= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }   
                            
                            if(wftTransset.contains('Switch vision or dental LOB')){
                                if((oldDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType== ARV_AP41_StringLiteralUtils.NONVOLUNTARY)||(oldDentalType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY && newDentalType== ARV_AP41_StringLiteralUtils.VOLUNTARY)){
                                    
                                    SwitchDental=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }
                            if(wftTransset.contains('Common Control')){
                                if(AddCCSegment==ARV_AP41_StringLiteralUtils.YESVAL){
                                    system.debug('AddCCSegment...'+AddCCSegment);
                                    AddCCSegmentflag= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            if(wftTransset.contains('Add Employee Class')){
                                if(additionalSegementRadio==ARV_AP41_StringLiteralUtils.YESVAL){
                                    additionalSegement= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }  
                            
                        }
                        
                        if(wftTransset.contains('Replace Package – Different Carrier')){
                            if(oldCarrier!=newCarrier){
                                system.debug('oldCarrier::'+oldCarrier);
                                system.debug('newCarrier::'+newCarrier);
                                system.debug('Package Id::'+pkg.Id);
                                if(oldCarrier==ARV_AP41_StringLiteralUtils.BCNTYPE)
                                {
                                    CarrierChangeBCNBCBS=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                                if(oldCarrier==ARV_AP41_StringLiteralUtils.BCBSTYPE)
                                {
                                    CarrierChangeBCBSBCN=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                        }
                        if(newCarrier==ARV_AP41_StringLiteralUtils.BCNTYPE){
                            system.debug('*****Adding Voluntary Dental*****');
                            if(TRUESTRING.equals(system.label.ARV_CL_AddNewVolDental_SystemCheck2) && con.status==GSSTATUS){
                                if((oldDentalProdCode!=newDentalProdCode) && ((oldDentalType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY || oldDentalType==ARV_AP41_StringLiteralUtils.NULLSTRING) && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY))
                                {
                                    CheckVolDen=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    system.debug('**CheckVolDen**'+CheckVolDen);
                                }
                            }
                            if(TRUESTRING.equals(system.label.ARV_CL_AddNewVolVision_SystemCheck2)){
                                if((oldVisionProdCode!=newVisionProdCode) && ((oldVisionType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY || oldVisionType==ARV_AP41_StringLiteralUtils.NULLSTRING) && newVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY))
                                {
                                    CheckVolVis=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            if(TRUESTRING.equals(system.label.ARV_CL_RemoveDentalLOB_SystemCheck2)){
                                if(newDentalPlan==ARV_AP41_StringLiteralUtils.NOTOFFERED && (oldDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY || oldDentalType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY))
                                {
                                    RemoveDen=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            system.debug('*****Removing Voluntary Vision*****');
                            if(TRUESTRING.equals(system.label.ARV_CL_RemoveVisionLOB_SystemCheck2)){
                                if(newVisionPlan==ARV_AP41_StringLiteralUtils.NOTOFFERED && (oldVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY || oldVisionType== ARV_AP41_StringLiteralUtils.NONVOLUNTARY))
                                {
                                    RemoveVis=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            //Add Medical Plan Lob Scenario
                            if(wftTransset.contains('Add Medical LOB')){
                                if(oldMedicalPlan!=newMedicalPlan &&(newMedicalPlan!=ARV_AP41_StringLiteralUtils.NULLSTRING)){
                                    
                                    AddMedPlanLob=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }    
                            }
                            //Remove package Check
                            if(wftTransset.contains('Remove Package	')) {
                                if(DeleteGSFlag==ARV_AP41_StringLiteralUtils.TRUE_VALUE) {
                                    RemovePackageFlag= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }  
                            // Remove MedicalPlan Lob scenario  
                            if(wftTransset.contains('Remove Medical LOB')) {
                                if(oldMedicalPlan!=newMedicalPlan &&  (newMedicalPlan== ARV_AP41_StringLiteralUtils.NOTOFFERED)) {
                                    
                                    RemoveMedPlanLob= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }          
                            }  
                            // Add CDH to medical Plan 
                            if(wftTransset.contains('Add CDH')){
                                if(oldMedicalPlan==newMedicalPlan && (newCDHPlan != ARV_AP41_StringLiteralUtils.NULLSTRING)){
                                    
                                    AddCDH= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }   
                            
                            if(wftTransset.contains('Switch vision or dental LOB')){
                                if((oldDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY)||(oldDentalType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY && newDentalType== ARV_AP41_StringLiteralUtils.VOLUNTARY)){
                                    
                                    SwitchDental=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }
                            if(wftTransset.contains('Common Control')){
                                if(AddCCSegment==ARV_AP41_StringLiteralUtils.YESVAL){
                                    system.debug('AddCCSegment...'+AddCCSegment);
                                    AddCCSegmentflag= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    system.debug('AddCCSegmentflag'+AddCCSegmentflag);
                                }
                            }
                            if(wftTransset.contains('Add Employee Class')){
                                if(additionalSegementRadio==ARV_AP41_StringLiteralUtils.YESVAL){
                                    additionalSegement= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }   
                            
                            if(wftTransset.contains('Switch vision or dental LOB')){
                                if((oldVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY && newVisionType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY)||(oldVisionType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY && newVisionType== ARV_AP41_StringLiteralUtils.VOLUNTARY)){
                                    
                                    SwitchVision=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            } 
                            if(wftTransset.contains('BCN HBL')){
                                if(oldProductFamily==HBLSTRING && newProductFamily!=HBLSTRING && oldMedicalPlan!=newMedicalPlan)
                                {
                                    
                                    BCNHBL=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }
                            if(wftTransset.contains('BCN HSA')){
                                if(newMedicalPlan.contains(HSASTRING)){
                                    BCNHSA=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }
                            if(wftTransset.contains('BCN HRA')){
                                if(newMedicalPlan.contains(HRASTRING)){
                                    BCNHRA=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }
                            //Added for BCN Mass Plan Check
                            if(wftTransset.contains('BCN Mass Plan Changes')){
                                if(prvsContrctReqEffDate==gwcReqEffDate && pkg.ARV_GWC_Medical_Transaction__c=='Update'){
                                    BCNMASSPLAN=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }
                            //ends here
                            if (wftTransset.contains('Retro GWCs')){
                           // if(TRUESTRING.equals(system.label.ARV_CL_Retro_GWC_SystemCheck2)){
                                Date prvreqEffectiveDate= date.valueOf(prvsContrctReqEffDate);
                                Date currentDate=system.Today();
                                system.debug('prevconreqeffdate::'+prevconreqeffdate);
                                system.debug('gwcreqEffectiveDate::'+gwcreqEffectiveDate);
                                if(gwcreqEffectiveDate < prevconreqeffdate ){
                                    RETROGWC=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                           
                           /* if(wftTransset.contains('Common Control	')){
                                if(AddCCSegment==ARV_AP41_StringLiteralUtils.YESVAL){
                                    AddCCSegmentflag= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }
                            if(TRUESTRING.equals(system.label.ARV_AddSegmentRadio_SystemCheck2)){
                                if(additionalSegementRadio==ARV_AP41_StringLiteralUtils.YESVAL){
                                    additionalSegement= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }
                            }
                            //Add Medical Plan Lob Scenario
                            if(wftTransset.contains('Add Medical LOB')){
                                if(oldMedicalPlan!=newMedicalPlan &&(newMedicalPlan!=ARV_AP41_StringLiteralUtils.NULLSTRING)){
                                    
                                    AddMedPlanLob=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                    
                                }    
                            }
                            // Remove MedicalPlan Lob scenario  
                            if(wftTransset.contains('Remove Medical LOB')) {
                                if(oldMedicalPlan!=newMedicalPlan &&  (newMedicalPlan== ARV_AP41_StringLiteralUtils.NOTOFFERED)) {
                                    
                                    RemoveMedPlanLob= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }          
                            }  
                            // Add CDH to medical Plan 
                            if(wftTransset.contains('Add CDH')){
                                if(oldMedicalPlan==newMedicalPlan && (newCDHPlan != ARV_AP41_StringLiteralUtils.NULLSTRING)){
                                    
                                    AddCDH= ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }   
                            
                            if(wftTransset.contains('Switch vision or dental LOB')){
                                if((oldDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY)||(oldDentalType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY && newDentalType== ARV_AP41_StringLiteralUtils.VOLUNTARY)){
                                    SwitchDental=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }                   
                            if(wftTransset.contains('Switch vision or dental LOB')){
                                if((oldVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY && newVisionType== ARV_AP41_StringLiteralUtils.NONVOLUNTARY)||(oldVisionType==ARV_AP41_StringLiteralUtils.NONVOLUNTARY && newVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY)){
                                    SwitchVision=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                                }
                            }*/
                            
                            
                        }
                        tempStatus.add(RemovePackageFlag?RemovePackage+COMMA:SPACE);
                        tempStatus.add(AddMedPlanLob?AddMedicalPlan+COMMA:SPACE);
                        tempStatus.add(RemoveMedPlanLob?RemoveMedicalPlan+COMMA:SPACE);
                        tempStatus.add(AddCDH?ADDCDHPlan+COMMA:SPACE);
                        tempStatus.add(SwitchDental?SwitchDentalPlan+COMMA:SPACE);
                        tempStatus.add(SwitchVision?SwitchVisionPlan+COMMA:SPACE);
                        tempStatus.add(additionalSegement?additionalSegementplan+COMMA:SPACE);
                        tempStatus.add(AddCCSegmentflag?AddCommon+COMMA:SPACE);
                        tempStatus.add(CheckVolDen?CheckVolDental+COMMA:SPACE);
                        tempStatus.add(CheckVolVis?CheckVolVision+COMMA:SPACE);
                        tempStatus.add(RemoveDen?RemoveDental+COMMA:SPACE);
                        tempStatus.add(RemoveVis?RemoveVision+COMMA:SPACE);
                        tempStatus.add(CarrierChangeBCNBCBS?CarrierChangeBCNToBCBS+COMMA:SPACE);
                        tempStatus.add(CarrierChangeBCBSBCN?CarrierChangeBCBSToBCS+COMMA:SPACE);
                        tempStatus.add(BCNHBL?CheckHBL+COMMA:SPACE);
                        tempStatus.add(BCNHSA?CheckHSA+COMMA:SPACE);
                        tempStatus.add(BCNHRA?CheckHRA+COMMA:SPACE);
                        tempStatus.add(BCNMASSPLAN?CheckBCNMASSPLAN+COMMA:SPACE);
                        tempStatus.add(RETROGWC?CheckRetroGWC+COMMA:SPACE);
                        string tempstatuscheck=ARV_AP41_StringLiteralUtils.EMPTYSTRNG;
                        for(string str:tempStatus){
                            tempstatuscheck+=str;
                        }
                        //string tempStatuscheck = tempStatus.removeEnd(COMMA);
                        if(tempstatuscheck!=ARV_AP41_StringLiteralUtils.EMPTYSTRNG){
                            con.ARV_Tech_SystemCheck2__c = tempstatuscheck;
                            //con.status = 'Manual GWC Setup – Ready';
                            system.debug('tempStatus***'+tempstatuscheck);
                            system.debug('ARV_Tech_SystemCheck2__c***'+con.ARV_Tech_SystemCheck2__c);
                        }
                        update con;
                    }
                }
            } 
            
        }
        List<GA_Group_Segment__c> gslist=[select id,ARV_ContractID__c,ARV_GWC_Type__c,ARV_BCN_HRA__c,ARV_BCN_HSA__c,GA_Benefit_Effective_Date__c,GA_Carrier__c from GA_Group_Segment__c where ARV_Pending_ContractId__c=:con.id];
            system.debug('gslist::'+gslist);
            //ARV_AP_GWC_WorkFlowsCreation.manualWorkFlow(gslist,con,con.AccountId);
            ARV_AP_GWC_WorkFlowsCreationNew.manualWorkFlow(gslist,con,con.AccountId,BCNHSA,BCNHRA,BCNHBL,BCNMASSPLAN,RETROGWC);
    }
    
    catch(Exception e){
        
           
            system.debug('excep::'+e.getLineNumber()+','+e.getMessage());

    }
}
}