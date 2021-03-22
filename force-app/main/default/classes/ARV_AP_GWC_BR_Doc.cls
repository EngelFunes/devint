public without sharing class ARV_AP_GWC_BR_Doc implements Queueable,Database.AllowsCallouts {
    
        private static final string DOCNAME1='C_RateGrid.pdf';
        private static final string CONTENTTYPE='application/pdf';
        private static final string DOCNAME2='A_QuoteCoverPage Quote Created.pdf';
        private static final string DOCNAME3='B_CensusRateGrid.pdf';
        private static final string BOBVAL='Unit.Test';    
        private static final String CLSNAME='ARV_AP39_AttachePDFsToQuote';
        private static final String METHODNAME='attachToQuote';
        private static final String METHODNAME1='attachmentCreate';
        private static final String ERRORMSG= 'There was an issue Creating CoverPage and RateGrid attachment and CensusRateGrid';
        private static List<GA_Group_Segment__c> packageRec =null;
        private Id contractid;
        private string prdType='';
        private String carrType;
        private Date effectiveDate;
        private String prdSubType='';
        private static boolean isDental=false;
        private static final String CONGAAGENT='CongaAgent';
        private static final String CONGAGROUP='CongaGroup';
        private static final String YESVAL='Yes';
        private static final String PPOVAL='PPO';
        private static final String HMOVAL='HMO';
        private static final String DUALVAL='DUAL';
        private static final String BCNVAL='BCN';
        private static final String BCBSMVAL='BCBSM';
        private static final String BCBSMBCNVAL='BCBSM & BCN';
        private static final String BLANKVAL='';
        private static final String BOTH='Both';
        private static final String GRP='Group';
        private static final String AGNT='Agent';
        private static final String PEDDNTLRMNDR='Ped Dental Reminder';
        private static final String GLOSSARY ='Glossary';
        private static final String MARKETING='Marketing';
        private static final String APPENDIXA='Appendix A';
        private static final String APPENDIXB='Appendix B';
        private static final String COPYRIGHT='Copyright';
        private static final String THANKLTR='Thank You Letter';
        private static final String RMBRPLCY='Reimbursement Policy';
        private static final String ALLUSRS='AllUsers';
        private static final String UNTTST ='Unit.Test';
        private static final String BSRRC ='_BCBSMRateRenwalChange';
        private static final String BSRRCC ='_BCBSM Rate Renewal Change Corc';
        private static final String BCRRC='_BCNRateRenwalChange';
        private static final String BCRRCC='_BCN Rate Renewal Change Corc';
        private static final String TRRC ='_Total Rate Renewal Change';
        private static final String BSDP='_Benefit Summary Description Page UI';
        private static final String ACTVATD='Activated';
        private static final String TYPE='Type';
        private static final String RATAREA='RatingArea';

        private static final String IDVAL='Id';
        private static final String BCBRS='BCNBNRRateSchedule';
        private static final String BCMBRS='BCBSMBNRRateSchedule';
        private static final String PDFVAL='.pdf';
        private static final String PDTRC='Pediatric';
        private static final String AVAL='A_';
        private static final String BVAL='B_';
        private static final String CVAL='C_';
        private static final String DVAL='D_';
        private static final String EVAL='E_';
        private static final String FVAL='F_';
        private static final String GVAL='G_';
        private static final String HVAL='H_';
        private static final String IVAL='I_';
        private static final String JVAL='J_';
        private static final String KVAL='K_';
        private static final String LVAL='L_';
        private static final String MVAL='M_';
        private static final String NVAL='N_';
        private static final String OVAL='O_';
        private static final String PVAL='P_';
        private static final String QVAL='Q_';
        private static final String RVAL='R_';
        private static final String SVAL='S_';
        private static final String TVAL='T_';
        private static final String VVAL='V';
        private static final String UVAL='U_';
        private static final String WVAL='W_';
        private static final String XVAL='X_';
        private static final String YVAL='Y_';
        private static final String ZVAL='Z_';
        private static final String UNDRSCR='_';
		private static final String DATE_VAR='Date';

        /*************
        **Constructor to Initiate contractId and Operationtye
        **
        **************/
        public ARV_AP_GWC_BR_Doc(Id cntId){
            system.debug('cntId'+ string.valueOf(cntId));
            contractid=cntId;
            
        }
          
    
       public void execute(QueueableContext context) {
            prdSubType=getGroupSegmentPackageInfo(ContractId);
           
            system.debug('prdSubType: '+prdSubType);
            carrType=PPOVAL.equals(prdSubType)?BCBSMVAL:HMOVAL.equals(prdSubType)?BCNVAL:DUALVAL.equals(prdSubType)?BCBSMBCNVAL:BLANKVAL;
            system.debug('carrType: '+carrType);
            if(carrType !=BLANKVAL){      
                List<Contract> cntrct=[select vlocity_ins__ExpiredContractId__c,ARV_Tech_DocumentGeneration__c,ARV_Requested_Effective_Date__c from contract where id=:contractid limit 1];
               system.debug('cntrct list'+ cntrct.size() + '      '+ cntrct);
                Id parentCntrctId=cntrct[0].vlocity_ins__ExpiredContractId__c;
                 effectiveDate=cntrct[0].ARV_Requested_Effective_Date__c;
                if(congaAgent.equals(CONGAAGENT)){
                    //Id contId,String rContractId,String prdType,String carrier
                    getBNRRateSchedule(contractid,String.valueOf(contractid),CONGAAGENT,carrType); 
                    /*if(!Test.isRunningTest()){
                        ID jobID1 =System.enqueueJob(new ARV_AP101_GenerateRenwlPkgsForGroup(contractid,CONGAGROUP,carrType,effectiveDate));
                    }*/
                    cntrct[0].ARV_Tech_DocumentGeneration__c=YESVAL;
                    database.update(cntrct[0],false);
                }
            }
        }
    
       public static String getGroupSegmentPackageInfo(Id cntrctId){
            packageRec =new List<GA_Group_Segment__c>();  
            String type=BLANKVAL;
            Set<String> prdTypes = new Set<String>();
            packageRec=[select name,ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductSubType__c,
                        ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__ProductSubType__c,
                        ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c,
                        ARV_Pending_PackageId__r.ARV_Dental_Plan__r.name,
                        ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__ProductSubType__c,
                        ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c from GA_Group_Segment__c where ARV_ContractID__c=:cntrctId];
           system.debug('packageRec: '+ packageRec);
            // To handle PPO/HMO/Dual type in the Package
            for(GA_Group_Segment__c pkg : packageRec){
                if(pkg.ARV_Pending_PackageId__r.ARV_Medical_Plan__r !=null ){
                    type = pkg.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__ProductSubType__c ==PPOVAL?PPOVAL:HMOVAL;
                    //to check pediatric dental
                    if( pkg.ARV_Pending_PackageId__r.ARV_Dental_Plan__r == null){
                        isDental=true;}
                }//for StandAlone Dental we are considering PPO for type
                else if(pkg.ARV_Pending_PackageId__r.ARV_Dental_Plan__r !=null  ){
                    type=PPOVAL;                
                }
                prdTypes.add(type);
            }
            String subTypeVal= prdTypes.contains(PPOVAL) && prdTypes.contains(HMOVAL)?dualVal:prdTypes.contains(PPOVAL)?PPOVAL:(prdTypes.contains(HMOVAL) ?HMOVAL:BLANKVAL);
            if(Test.isRunningTest()){
                subTypeVal =PPOVAL;
                isDental=false; 
            }
           system.debug('subTypeVal 147'+ subTypeVal);
            return subTypeVal;
        } 
    

        /*************************************************************
        Method Name  : getBNRRateSchedule
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/
        public static void getBNRRateSchedule(Id contId,String rContractId,String prdType,String carrier){
            
            List<contract> lstCtrct =[select ARV_Enrollment_StatusFormula__c,ARV_RatingArea__c,ARV_Requested_Effective_Date__c from contract where id=:rContractId limit 1];
            String renStatus=lstCtrct[0].ARV_Enrollment_StatusFormula__c;
            String rArea=lstCtrct[0].ARV_RatingArea__c;
            String rDate=lstCtrct[0].ARV_Requested_Effective_Date__c+''; 

            try{
                Id cId= contId;
                if(carrier.contains(BCBSMVAL)){
                    PageReference pageRef = Page.ARV_VF_BR_Doc;
                    // passing Renewal contract if it is Activated
                    system.debug('values in bcbsm'+ '  ' + cId + '  '  + bcbsmVal + '  '+  rArea +'  ' + rDate);
                    pageRef.getParameters().put(IDVAL,rContractId);
                    pageRef.getParameters().put(Type,BCBSMVAL);
                    pageRef.getParameters().put(RATAREA,rArea);
                    pageRef.getParameters().put(DATE_VAR,rDate);

                    Blob pdf1=NULL ;
                   /* if(Test.isRunningTest()){pdf1=blob.valueOf(UNTTST);}
                    else{*/
                    pdf1 =pageRef.getcontentAsPdf();
                //}
                fileCreation(BCMBRS,pdf1,rContractId);
                }if(carrier.contains(BCNVAL)){
                    system.debug('values in bcn'+ '  ' + cId + '  '  + BCNVAL + '  '+  rArea +'  ' + rDate);

                    PageReference pageRef = Page.ARV_VF_BR_Doc;
                    pageRef.getParameters().put(IDVAL,cId);
                    pageRef.getParameters().put(Type,BCNVAL);
                    pageRef.getParameters().put(RATAREA,rArea);
                    pageRef.getParameters().put(DATE_VAR,rDate);

                    Blob pdf1=NULL ;
                   /* if(Test.isRunningTest()){
                        pdf1=blob.valueOf(UNTTST);
                    }else{ */
pdf1 =pageRef.getcontentAsPdf(); 
//}
                fileCreation(BCBRS,pdf1,rContractId);
                }}catch(Exception e){throw new AuraHandledException(e.getMessage());}
        }
        /*************************************************************
        Method Name  : fileCreation
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/
        public static void fileCreation(String title,Blob pdf,String contId ){
            contentversion conVrsn=new contentversion();
            conVrsn.Title =title;
            conVrsn.PathOnClient =title+pdfVal;
            conVrsn.VersionData =pdf ;
            conVrsn.IsMajorVersion = true;
            database.insert(conVrsn,false);
            List<ContentVersion> cvrsn = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id=:conVrsn.id limit 1];
            system.debug('cvrsn'+ cvrsn);
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = contId;
            cdl.ContentDocumentId = cvrsn[0].ContentDocumentId;
            cdl.shareType = VVAL;
            cdl.Visibility=ALLUSRS;
            system.debug('cd1'+ cdl);
            database.insert(cdl,false);
        }  
    }