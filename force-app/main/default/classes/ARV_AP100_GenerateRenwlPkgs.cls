/********************************************************************************************
    Class Name   : ARV_AP100_GenerateRenwlPkgs. 
    Date Created : 02-march-2020
    Created By   : IDC Offshore 
    Description  : This is called from ARV_AP97_GenerateRenwlPackages, to generate Individual files and attach to renewal contract object
    *******************************************************/
    public  without sharing class ARV_AP100_GenerateRenwlPkgs implements Queueable,Database.AllowsCallouts{
        
        private static final string DOCNAME1='C_RateGrid.pdf';
        private static final string CONTENTTYPE='application/pdf';
        private static final string DOCNAME2='A_QuoteCoverPage Quote Created.pdf';
        private static final string DOCNAME3='B_CensusRateGrid.pdf';
        private static final string BOBVAL='Unit.Test';    
        private static final String CLSNAME='ARV_AP39_AttachePDFsToQuote';
        private static final String METHODNAME='attachToQuote';
        private static final String METHODNAME1='attachmentCreate';
        private static final String ERRORMSG= 'There was an issue Creating CoverPage and RateGrid attachment and CensusRateGrid';
        private static List<Package__C> packageRec =null;
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


        /*************
        **Constructor to Initiate contractId and Operationtye
        **
        **************/
        public ARV_AP100_GenerateRenwlPkgs(Id cntId, String pkgType){
            contractid=cntId;
            prdType=pkgType;
        }
        /*************************************************************
        Method Name  : execute method 
        Description  : This execute metthod to call CongaAgent and Conga Group packages generation 
        **************************************************************/ 
        public void execute(QueueableContext context) {
            prdSubType=getGroupSegmentPackageInfo(ContractId);
            carrType=PPOVAL.equals(prdSubType)?BCBSMVAL:HMOVAL.equals(prdSubType)?BCNVAL:DUALVAL.equals(prdSubType)?BCBSMBCNVAL:BLANKVAL;
            if(carrType !=BLANKVAL){      
                List<Contract> cntrct=[select vlocity_ins__ExpiredContractId__c,ARV_Tech_DocumentGeneration__c,ARV_Requested_Effective_Date__c from contract where id=:contractid];
                Id parentCntrctId=cntrct[0].vlocity_ins__ExpiredContractId__c;
                 effectiveDate=cntrct[0].ARV_Requested_Effective_Date__c;
                if(congaAgent.equals(prdType)){
                    system.debug('beforepackages'+contractid);
                    prepareAgentRenewalPackage(parentCntrctId,contractid,prdType,carrType,effectiveDate); 
                    if(!Test.isRunningTest()){
                        ID jobID1 =System.enqueueJob(new ARV_AP101_GenerateRenwlPkgsForGroup(contractid,CONGAGROUP,carrType,effectiveDate));
                    }
                    cntrct[0].ARV_Tech_DocumentGeneration__c=YESVAL;
                    database.update(cntrct[0],false);
                }
            }
            
        }
        /*************************************************************
        Method Name  : prepareGroupRenewalPackage
        Date Created : 6-April-2020
        Created By   : IDC Offshore
        Description  : This Method is used to prepare Agent Renewal Package. 
        **************************************************************/    
        public static void prepareGroupRenewalPackage(Id ContractId,String rContractId,string prdType,String carrType,Date effectiveDate)
        { 
            getBNRRateSchedule(ContractId,rContractId,prdType,carrType);
            MarketDocattachment(ContractId,rContractId,prdType,both,grp,effectiveDate);
            getRateRenewalChange(ContractId,rContractId,prdType,carrType);
            getTotalRateRenewalChange(ContractId,rContractId,prdType,carrType);            
        }   
        /*************************************************************
        Method Name  : prepareAgentRenewalPackage
        Date Created : 6-April-2020
        Created By   : IDC Offshore
        Description  : This Method is used to prepare Agent Renewal Package. 
        **************************************************************/    
        public static void prepareAgentRenewalPackage(Id ContractId,String rContractId,string prdType,String carrType,Date effectiveDate)
        { 
            getBNRRateSchedule(ContractId, rContractId,prdType,carrType);
            marketDocattachment(ContractId,rContractId,prdType,both,agnt,effectiveDate);
            getRateRenewalChangeCorc(ContractId,rContractId,prdType,carrType);
            getTotalRateRenewalChange(ContractId,rContractId,prdType,carrType);
            getBenefitSummary(ContractId,rContractId,prdType,carrType);
        }   
        
        /*************************************************************
        Method Name  : MarketDocattachment
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will create coverPageAtt attachment in Quote object. 
        **************************************************************/    
        public static void marketDocattachment(Id ContractId,String rContractId,string PackageType,string PackageType1,string PackageType3,Date effectiveDate)
        {   
            String prdSType=getGroupSegmentPackageInfo(ContractId);
            if(prdSType!=BLANKVAL){
            set<Id> recordIds = New Set <Id> ();
            List<ARV_RenewalContractStaticDocs_Config__c> docId =[ select ID from ARV_RenewalContractStaticDocs_Config__c where (ARV_Product_Type__c=:prdSType or ARV_Product_Type__c=:BLANKVAL) and (ARV_Package_Type__c=:PackageType3 or ARV_Package_Type__c=:PackageType1) and (ARV_Start_Date__c<=:effectiveDate and ARV_End_Date__c>=:effectiveDate) ]; 
            if(docId.size()>0){
            for(ARV_RenewalContractStaticDocs_Config__c cfid : docId){
                recordIds.add(cfid.id);
            } 
            set<Id> contdocIds = New Set <Id> ();
            for (ContentDocumentLink cdl: [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :recordIds]) {
                contdocIds.add(cdl.ContentDocumentId);
            }
            List<contentversion> cvList = new List<contentversion>();
            List<contentversion> attList1 =New List<contentversion>();
            List<contentversion> attList2 =New List<contentversion>();
            for(contentversion att:[select id, title,versiondata, ContentDocumentId from contentversion where ContentDocumentId in:contdocIds] ){
                if(!att.title.contains(pedDntlRmndr)){
                    contentversion conVrsn=new contentversion();
                    conVrsn.Title = att.title;
                    conVrsn.PathOnClient =att.title+pdfVal;
                    conVrsn.VersionData = att.versiondata;
                    conVrsn.IsMajorVersion = true;
                    if(string.isNotBlank(att.Title)){
                        if(att.Title.contains(glossary))
                        {
                            conVrsn.Title=MVAL+PackageType+UNDRSCR+att.Title; 
                        }else if(att.Title.contains(MARKETING)){
                            conVrsn.Title=PVAL+PackageType+UNDRSCR+att.Title;
                        } else if(att.Title.contains(APPENDIXA)){
                            conVrsn.Title=SVAL+PackageType+UNDRSCR+att.Title;
                        } 
                        else if(att.Title.contains(APPENDIXB)){
                            conVrsn.Title=XVAL+PackageType+UNDRSCR+att.Title;
                        } 
                        else if(att.Title.contains(COPYRIGHT)){
                            conVrsn.Title=ZVAL+PackageType+UNDRSCR+att.Title;
                        } 
                        else if(att.Title.contains(THANKLTR)){
                            conVrsn.Title=BVAL+PackageType+UNDRSCR+att.Title;
                        }
                        else if(att.Title.contains(RMBRPLCY)){
                            conVrsn.Title=FVAL+PackageType+UNDRSCR+att.Title;
                        }
                    }   
                    attList1.add(conVrsn); 
                }
                if(att.Title.contains(pedDntlRmndr) && isDental)  {
                    ContentVersion conAtt1=new ContentVersion();                       
                    conAtt1.Title=YVAL+PackageType+UNDRSCR+att.Title;
                    conAtt1.PathOnClient =att.title+pdfVal;
                    conAtt1.VersionData = att.versiondata;
                    conAtt1.IsMajorVersion = true;  
                    attList2.add(conAtt1);   
                }                         
            }
            if(attList2.size()>0){attList1.addAll(attList2);}
            database.saveresult[] cvListCreated= database.insert(attList1,false);
            List<id> cntnVrsnLst = new List<Id>();             
            for (Database.SaveResult sr : cvListCreated) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    cntnVrsnLst.add(sr.getId());}
            }
            List<ContentVersion> cvrsnList = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id In :cntnVrsnLst];
            List<ContentDocumentLink> cdlst = new List<ContentDocumentLink>();
            for(ContentVersion cv : cvrsnList){
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = rContractId;
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.shareType = VVAL;
                cdl.Visibility=ALLUSRS;
                cdlst.add(cdl);
            }
            if(cdlst.size()>0){database.saveresult[] cvListCreated1=database.insert(cdlst,false); }
            }
            }
        }
        /*************************************************************
        Method Name  : getGroupSegmentPackageInfo
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/     
        public static String getGroupSegmentPackageInfo(Id cntrctId){
            packageRec =new List<Package__C>();  
            String type=BLANKVAL;
            Set<String> prdTypes = new Set<String>();
            packageRec=[select name,ARV_Medical_Plan__r.vlocity_ins__ProductSubType__c,
                        ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,ARV_Dental_Plan__r.vlocity_ins__ProductSubType__c,
                        ARV_Dental_Plan__r.vlocity_ins__ProductCode__c,ARV_Dental_Plan__r.name,
                        ARV_Vision_Plan__r.vlocity_ins__ProductSubType__c,ARV_Vision_Plan__r.vlocity_ins__ProductCode__c from Package__C where ARV_Contract_Id__c=:cntrctId
                        ];
            // To handle PPO/HMO/Dual type in the Package
            for(Package__C pkg : packageRec){
                if(pkg.ARV_Medical_Plan__r !=null ){
                    type = pkg.ARV_Medical_Plan__r.vlocity_ins__ProductSubType__c ==PPOVAL?PPOVAL:HMOVAL;
                    //to check pediatric dental
                    if( pkg.ARV_Dental_Plan__r == null){
                        isDental=true;}
                }//for StandAlone Dental we are considering PPO for type
                else if(pkg.ARV_Dental_Plan__r !=null  ){
                    type=PPOVAL;                
                }
                prdTypes.add(type);
            }
            String subTypeVal= prdTypes.contains(PPOVAL) && prdTypes.contains(HMOVAL)?dualVal:prdTypes.contains(PPOVAL)?PPOVAL:(prdTypes.contains(HMOVAL) ?HMOVAL:BLANKVAL);
            if(Test.isRunningTest()){
                subTypeVal =PPOVAL;
                isDental=false; 
            }
            return subTypeVal;
        }
        /*************************************************************
        Method Name  : getRateRenewalChange
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/   
        private static void getRateRenewalChange(Id contId,String rContractId,String productType,String carrierType){
            if(carrierType.contains(BCBSMVAL)){
                PageReference pageRef = Page.ARV_VF13_BCBSM_RateRenewalChangePage;
                pageRef.getParameters().put(IDVAL,rContractId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1=blob.valueOf(UNTTST);
                }else{ pdf1 =pageRef.getcontentAsPdf(); }
                fileCreation(DVAL+productType+BSRRC,pdf1,rContractId);    
            } if(carrierType.contains(BCNVAL)){
                PageReference pageRef = Page.ARV_VF14_BCN_RateRenewalChangePage;
                pageRef.getParameters().put(IDVAL,rContractId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1=blob.valueOf(UNTTST);
                }
                else{pdf1 =pageRef.getcontentAsPdf();}
                fileCreation(DVAL+productType+BCRRC,pdf1,rContractId);   
            }
        }   
        /*************************************************************
        Method Name  : getRateRenewalChangeCorc
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/  
        private static void getRateRenewalChangeCorc(Id contId,String rContractId,String productType,String carrierType){
            if(carrierType.contains(bcbsmVal)){
                PageReference pageRef = Page.ARV_VF16_BCBSM_RateRenewalChangeCorc;
                pageRef.getParameters().put(IDVAL,rContractId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1=blob.valueOf(UNTTST);
                }
                else{pdf1 =pageRef.getcontentAsPdf();}
                fileCreation(DVAL+productType+BSRRCC,pdf1,rContractId);    
            } if(carrierType.contains(BCNVAL)){
                PageReference pageRef = Page.ARV_VF15_BCN_RateRenewalChangeCorc;
                pageRef.getParameters().put(IDVAL,rContractId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1=blob.valueOf(UNTTST);
                }else{pdf1 =pageRef.getcontentAsPdf();}
                fileCreation(DVAL+productType+bcRRCC,pdf1,rContractId);   
            }
        }
        /*************************************************************
        Method Name  : getTotalRateRenewalChange
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/
        private static void getTotalRateRenewalChange(Id contId,String rContractId,String productType,String carrierType){
            if(bcbsmbcnVal.equals(carrierType)){
                PageReference pageRef = Page.ARV_VF11_RateRenewalChangePage;
                pageRef.getParameters().put(IDVAL,rContractId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1=blob.valueOf(UNTTST);
                }else{pdf1 =pageRef.getcontentAsPdf();}
                fileCreation(CVAL+productType+trrc,pdf1,rContractId);    
            } 
        }
        /*************************************************************
        Method Name  : getBenefitSummary
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/
        private static void getBenefitSummary(Id contId,String rContractId,String productType,
           String carrierType){
            PageReference pageRef = Page.ARV_VF17_AgentRenewalPckg_BenefitSummary;
            pageRef.getParameters().put(IDVAL,contId);
            Blob pdf1=NULL ;
            if(Test.isRunningTest()){
                pdf1=blob.valueOf(UNTTST);
            }else{pdf1 =pageRef.getcontentAsPdf();}
            fileCreation(EVAL+productType+BSDP,pdf1,rContractId);    
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
                Id cId= renStatus==actvatd?Id.valueof(rContractId):contId;
                if(carrier.contains(bcbsmVal)){
                    PageReference pageRef = Page.ARV_VF20_BCBSMBNRRateSheet;
                    // passing Renewal contract if it is Activated
                    pageRef.getParameters().put(IDVAL,cId);
                    pageRef.getParameters().put(type,bcbsmVal);
                    pageRef.getParameters().put(RATAREA,rArea);
                    pageRef.getParameters().put('Date',rDate);

                    Blob pdf1=NULL ;
                    if(Test.isRunningTest()){pdf1=blob.valueOf(UNTTST);}
                    else{
                    pdf1 =pageRef.getcontentAsPdf();
                }
                fileCreation(UVAL+prdType+BCMBRS,pdf1,rContractId);
                }if(carrier.contains(BCNVAL)){
                    PageReference pageRef = Page.ARV_VF20_BCBSMBNRRateSheet;
                    pageRef.getParameters().put(IDVAL,cId);
                    pageRef.getParameters().put(type,BCNVAL);
                    pageRef.getParameters().put(RATAREA,rArea);
                    pageRef.getParameters().put('Date',rDate);

                    Blob pdf1=NULL ;
                    if(Test.isRunningTest()){
                        pdf1=blob.valueOf(UNTTST);
                    }else{ pdf1 =pageRef.getcontentAsPdf(); }
                fileCreation(VVAL+UNDRSCR+prdType+BCBRS,pdf1,rContractId);
                }}catch(Exception e){throw new AuraHandledException(e.getMessage());}
        }
        /*************************************************************
        Method Name  : fileCreation
        Date Created : 19-June-2019
        Created By   : IDC Offshore
        Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
        **************************************************************/
        private static void fileCreation(String title,Blob pdf,String contId ){
            contentversion conVrsn=new contentversion();
            conVrsn.Title =title;
            conVrsn.PathOnClient =title+pdfVal;
            conVrsn.VersionData =pdf ;
            conVrsn.IsMajorVersion = true;
            database.insert(conVrsn,false);
            List<ContentVersion> cvrsn = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id=:conVrsn.id limit 1];
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = contId;
            cdl.ContentDocumentId = cvrsn[0].ContentDocumentId;
            cdl.shareType = VVAL;
            cdl.Visibility=ALLUSRS;
            database.insert(cdl,false);
        }  
    }