public without sharing class ARV_AP_GWC_WorkFlowsCreationNew {
    public static final string CLSNAME = 'ARV_AP_GWC_WorkFlowsCreation';
    public static final string UPDTCNTRCTSTATUSMETHDNME = 'updtCntrctStatus';
    public static final string CHECKTEMPLATEMETHDNME = 'checkTemplate';
    public static final string CREATCONTRACTWRKFLOWMETHDNME = 'creatContractNewwrkflow';
    public static final String BENEFITCHANGE='Benefit Change';
    public static final String NEWGROUPSEGMENT='New Group Segment';
    private  String MNTHYRFRMT = 'MMMM, YYYY';
    private  String BCBSMLBL=ARV_AP41_StringLiteralUtils.BCBSMVAL;
    private  String BCNLBL= ARV_AP41_StringLiteralUtils.BCNTYPE;
    private String HYPNVAL = ARV_AP41_StringLiteralUtils.HYPHENVAL;
    private  String REDYFORINTGRTN = ARV_AP41_StringLiteralUtils.REDYFORINTGRTN;
    private  String MANUL = ARV_AP41_StringLiteralUtils.MANUL;
    private  string ENABLESMLGRPUWINTGN = system.label.ARV_CL40_Small_Group_Enable_Integration;
    private  string BCNHSAAUTOMATE = system.label.ARV_CL54_BCN_HSA_Automate;
    private  string BCNHRAAUTOMATE = system.label.ARV_CL55_BCN_HRA_Automate;
    public static final string CONSTATUS='Group Segment Setup Complete';
    public static final string CONSTATUSMANUAL ='Manual GWC Setup – Processing';
    public static final string CONSTATUSAUTO ='Automated GWC Setup - Integration Ready';
    private String SMALGRPUWQUENAME = 'GA_Small_Group_Underwriting_Queue';
    private string GAUNITLEADERQUENAME = 'GA_Unit_Leader_WFGSQueue';
    public static final String VLOCITYTAG = 'Vlocity';
    public static final String HYPHN = ARV_AP41_StringLiteralUtils.SEPERATEDVAL;
    public static final String DATEFRMT ='MMMM, YYYY';
    public static Boolean isDualcarrier;
    
    
/*****************************************************************************************
Method Name   : cloneGroupSegmentRecord
Created By   : IDC Offshore
Description  : This is the method for group segment creation
******************************************************************************************/
    public static void manualWorkFlow(List<GA_Group_Segment__c> gslist,contract con,string accId, boolean BCNHSA, 
                                      boolean BCNHRA,boolean BCNHBL,boolean BCNMASSPLAN,boolean RETROGWC){
      try{
            boolean isManaulWF = ARV_AP41_StringLiteralUtils.FALSE_VALUE;
           boolean crtWrkflw = ARV_AP41_StringLiteralUtils.FALSE_VALUE;
                 system.debug('gslistSize'+gslist.size());    
            //boolean isAutomatedWF = False;
               List<GA_Group_Segment__c> bcnlist= new List<GA_Group_Segment__c>();
               List<GA_Group_Segment__c> bcbslist= new List<GA_Group_Segment__c>();
               List<Contract> cntrctUpdtLst = new List<Contract> ();
         //Dual carrier: Dividing the GS based on carrier
          for(GA_Group_Segment__c gs:gslist){
              if(gs.GA_Carrier__c==ARV_AP41_StringLiteralUtils.BCNTYPE)
              {
                  bcnlist.add(gs);
              }
              else
              {
                  bcbslist.add(gs);
              }
              }
            system.debug('con.ARV_Tech_SystemCheck2__c::'+con.ARV_Tech_SystemCheck2__c);
          system.debug('con.status::'+con.status);
         // system.debug('check::'+if(con.ARV_Tech_SystemCheck2__c !='' && con.status==CONSTATUS));
         if((con.ARV_Tech_SystemCheck2__c !=null) && con.status==CONSTATUS){
             isManaulWF=True;
              }
         if(isManaulWF)
            {
                system.debug('Manual');
                con.ARV_Integration_Status__c = ARV_AP41_StringLiteralUtils.MANUL;
                con.Status=CONSTATUSMANUAL;
                con.ARV_Is_Mass_Updating__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                cntrctUpdtLst.add(con);
                crtWrkflw = ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            }
          else if((con.ARV_Tech_SystemCheck2__c ==null) && con.status==CONSTATUS){
               system.debug('Auto');
              con.ARV_Integration_Status__c = ARV_AP41_StringLiteralUtils.REDYFORINTGRTN;
              con.Status=CONSTATUSAUTO;
          }
          
            
            if(cntrctUpdtLst.size()>0){
                //List<Database.SaveResult> contrcList = ARV_AP08_DMLHelper.insertSObjects(cntrctUpdtLst,UPDAT,true);
                database.update(cntrctUpdtLst);
            }
            //system.debug('cont status:'+con.Status);
          isDualcarrier = bcnlist.size()>0 && bcbslist.size()>0 ? true : false ;
             // ARV_AP41_StringLiteralUtils.FALSE_VALUE;
              system.debug('bcnlistSize'+bcnlist.size()+'::'+'bcbslistSize'+bcbslist.size());
          if(crtWrkflw)
            {
               /* system.debug('retro carrier');
                if(con.ARV_Tech_SystemCheck2__c=='Retro GWCs,' && con.GWC_Request_Type__c=='Existing Benefit Package No Change'){
              checkTemplate(bcnlist,bcbslist,con,accId);
                }
             else 
*/
                if((bcnlist.size()>0 && bcbslist.isempty())||(bcbslist.size()>0 && bcnlist.isempty()))
              {
               if(bcnlist.size()>0 && bcbslist.isempty()) 
                  {
                      system.debug('bcn carrier');
                   checkTemplate(bcnlist,con,accId);
                  }
                  else if((bcbslist.size()>0 && bcnlist.isempty()))
                  {
                      system.debug('bcbs carrier');
                  checkTemplate(bcbslist,con,accId);
                  } 
              }
            else if(bcnlist.size()>0 && bcbslist.size()>0)   
              { 
                  system.debug('dual carrier');
                  if(BCNHBL==ARV_AP41_StringLiteralUtils.TRUE_VALUE|| BCNHRA==ARV_AP41_StringLiteralUtils.TRUE_VALUE||
                     BCNHSA==ARV_AP41_StringLiteralUtils.TRUE_VALUE||BCNMASSPLAN==ARV_AP41_StringLiteralUtils.TRUE_VALUE|| 
                     RETROGWC==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                             checkTemplate(bcbslist,con,accId);
                             checkTemplate(bcnlist,con,accId);
                     //  checkTemplatebcbs(bcbslist,con,accId);
              }
            }
        }
      }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, UPDTCNTRCTSTATUSMETHDNME, con.id); 
            ARV_AP59_CreateGroupSegmentRecords.errorOccured = true;
            system.debug('excepWF::'+e.getLineNumber()+','+e.getMessage());
        }
    }
    
    /**
@Description: checkTemplate() method 
@Name : checkTemplate
@Param : List<GA_Group_SEgment__C> , Contract ,account 
@Return : void
@throws Exception : N/A
*/   
    public static void checkTemplate(List<GA_Group_Segment__C> grpLst, Contract cntrcRecd,string accId){
        try{
            system.debug('grpLst:'+grpLst.size()+','+grpLst);
            List<string> slectedNewGS = new List<string> ();
            List<string> slectedBenefitChange = new List<string> ();
            List<string> carrierNewGS = new List<string> ();
            List<string> carrierBenefitChange = new List<string> ();
            List<GA_Group_Segment__c> newGSLst = new List<GA_Group_Segment__c> ();
            List<GA_Group_Segment__c> benefitChangeGsLst = new List<GA_Group_Segment__c> ();
            List<String> conTypeOfChange = new List<String>();
            List<String> conTransNames = cntrcRecd.ARV_Tech_SystemCheck2__c.split(ARV_AP41_StringLiteralUtils.COMMAVAL);
            //boolean isNewGSBCBSMCarrier,isNewGSBCNCarrier,isBnftGSBCBSMCarrier,isBnftGSBCNCarrier;
               Boolean retro=((conTransNames.size()==1)&&(conTransNames[0]=='Retro GWCs'))?true:false;
            system.debug('retro'+retro);
                        system.debug('conTransNames::'+conTransNames.size()+','+conTransNames);
            String syschck2val= conTransNames[0];
            //
            if(grpLst.size()>0 && cntrcRecd.GWC_Request_Type__c!='Existing Benefit Package No Change'){
                for(GA_Group_Segment__c grp:grpLst)
                {
                    
                    if(grp.ARV_GWC_Type__c  == ARV_AP41_StringLiteralUtils.TYPEUPDATE){ 
                        conTypeOfChange.add(BENEFITCHANGE);
                       // system.debug('Benefit GS:'+grp.Id);
                        slectedBenefitChange.add(grp.Id);
                        carrierBenefitChange.add(grp.GA_Carrier__c);
                        benefitChangeGsLst.add(grp);
                    }
                    if(grp.ARV_GWC_Type__c == ARV_AP41_StringLiteralUtils.TYPEADD){
                        conTypeOfChange.add(NEWGROUPSEGMENT);
                        //system.debug('New GS:'+grp.Id);
                        slectedNewGS.add(grp.Id);
                        carrierNewGS.add(grp.GA_Carrier__c);
                        newGSLst.add(grp);
                    }
               
                }
                 
            }
            else if(grpLst.size()>0&&retro){
                for(GA_Group_Segment__c grp:grpLst)
                {
                    
                    if(grp.ARV_GWC_Type__c  == 'No Change'){ 
                        conTypeOfChange.add(BENEFITCHANGE);
                       // system.debug('Benefit GS:'+grp.Id);
                        slectedBenefitChange.add(grp.Id);
                        carrierBenefitChange.add(grp.GA_Carrier__c);
                        benefitChangeGsLst.add(grp);
                    }
            }
            }
            system.debug('newGSLst::'+newGSLst);
            system.debug('-- benefitChangeGsLst::'+benefitChangeGsLst );
            system.debug('slectedBenefitChange::'+slectedBenefitChange);
            system.debug(' --- slectedNewGS::'+slectedNewGS);
            
            
            /* 
             * Code  for new Frame work - Enahancement to WF Name
             */
           //Get System check #2  criteris details.
             // get Dual Carrier details.
            List<Systemcheck2_WFT__mdt> syscheckmtdAll= new List<Systemcheck2_WFT__mdt>();
            List<Systemcheck2_WFT__mdt> wftmdt=new List<Systemcheck2_WFT__mdt>();
           
              //get details from meta data for all system check#2 creretio's
            system.debug('conTransNamesLst'+conTransNames);
            system.debug('conTypeOfChangelst'+conTypeOfChange);
            // convert list to set to get uniqu values
            Set<String>  typeofcheckSet = new Set<String>();
            List<String> finaltocList = new List<String>();
            for (String toc : conTypeOfChange) {
              if (typeofcheckSet.add(toc)) {
                finaltocList.add(toc);
              }
            }
            
            
            Set<String>  carrierNGSSet = new Set<String>();
            List<String> finalcarrierNGSList = new List<String>();
            for (String ngsc : carrierNewGS) {
              if (typeofcheckSet.add(ngsc)) {
                finalcarrierNGSList.add(ngsc);
              }
            }
            
            
            Set<String>  carrierBnftSet = new Set<String>();
            List<String> finalcarrierBnftList = new List<String>();
            for (String bnc : carrierBenefitChange) {
              if (carrierBnftSet.add(bnc)) {
                finalcarrierBnftList.add(bnc);
              }
            }
            system.debug('Final carrier for BenefitChange'+finalcarrierBnftList);
            system.debug('Final carrier for NGS'+finalcarrierNGSList);
            system.debug('Final TypeOfChange list'+finaltocList);
             //Get Records from Meta data bsed on System check #2 met criterio's.
             wftmdt=[select id, Carrier__c,Dual_carrier__c,Manual_Automated__c,  
                                                        Method__c,Transaction__c,Type_Of_Change__c,WF_Sub_Type__c,
                                                        WF_Type__c,DeveloperName,MasterLabel,WFT_ID__c from 
                                                        Systemcheck2_WFT__mdt where 
                                                        Transaction__c = :syschck2val  and 
                                                        Type_Of_Change__c in :finaltocList
                                                        and Manual_Automated__c='Manual'];
             system.debug('From Meta Data-----' + wftmdt );
             system.debug(' Original mtd Size --- ' +wftmdt.size() );
            
             List<String> wftIds = new List<String>();
             for (Systemcheck2_WFT__mdt wftmtdrect : wftmdt) {
                 wftIds.add(wftmtdrect.WFT_ID__c);
             }
             system.debug('WFTIds-----' + wftIds);
            
            //unique WFT Id's
            Set<String>  wftempuniqIdset = new Set<String>();
            List<String> finalwftempuniqIds = new List<String>();
            for (String wftidls : wftIds) {
              if (wftempuniqIdset.add(wftidls)) {
                finalwftempuniqIds.add(wftidls);
              }
            }
            system.debug('Unique WFT Ids-----' + finalwftempuniqIds);
            system.debug('Unique WFT Ids List size -----' + finalwftempuniqIds.size());
            
            //Prepare WFT meta records list from Unique WFTID's
            Set<Systemcheck2_WFT__mdt>  wftmtdUniqRecset  = new Set<Systemcheck2_WFT__mdt>();
            List<Systemcheck2_WFT__mdt> wfTepltfinalLst = new List<Systemcheck2_WFT__mdt>();
            for (Systemcheck2_WFT__mdt mtdrec:wftmdt){
                //system.debug('Meta data WFTID' + mtdrec.WFT_ID__c );
                for ( String wftId: finalwftempuniqIds){
                if(mtdrec.WFT_ID__c ==  wftId)
                    if (wftmtdUniqRecset.add(mtdrec)){
                        wfTepltfinalLst.add(mtdrec);
                    }
            }
            }
            system.debug('final WFT Meta data records' + wfTepltfinalLst );
            System.debug('--- Size' +wfTepltfinalLst.size()  );
            
           
            system.debug('wftmdt-Query-Lst'+wftmdt);
            // start : creating Workflow records.
             List<GA_WF_Workflow__c> wfRecLst = new List<GA_WF_Workflow__c> ();
           if(wfTepltfinalLst.size()>0 && (slectedBenefitChange.size()>0 ||slectedNewGS.size() >0) ) {
              //cntrcRecd.status='Manual GWC Setup – Proccessing';
               system.debug('Contract Status' + cntrcRecd.status);
               for (Systemcheck2_WFT__mdt  temprec:wfTepltfinalLst){
                   if (temprec.Type_Of_Change__c ==BENEFITCHANGE  && slectedBenefitChange.size()>0 && finalcarrierBnftList.size()>0) {
                      for ( String bnftcrr: finalcarrierBnftList ) {
                          if ( bnftcrr == temprec.Carrier__c){
                            system.debug('Creating WF for the carrier : ' + bnftcrr + ' in benefitChange WFT Name: '+ temprec.MasterLabel);
                       GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name =  temprec.WF_Type__c + HYPHN + temprec.WF_Sub_Type__c + HYPHN + temprec.Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = temprec.WF_Sub_Type__c,
                                                          GA_Type__c = temprec.WF_Type__c,
                                                          GA_Carrier__c = temprec.Carrier__c,
                                                          GA_Method__c = temprec.Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = temprec.WFT_ID__c,
                                                          GA_Status__c = ARV_AP41_StringLiteralUtils.TYPEOPEN,
                                                          GA_External_Initiated__c=true,
                                                          GA_Selected_Group_Segments__c=string.join(slectedBenefitChange,  ARV_AP41_StringLiteralUtils.COMMAVAL),
                                                          GA_Benefit_Effective_Date__c=benefitChangeGsLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
                system.debug('wfRec:;'+wfRec);
            wfRecLst.add(wfRec);
                       }
                      }
               }
           if (temprec.Type_Of_Change__c ==NEWGROUPSEGMENT && slectedNewGS.size() >0 && finalcarrierNGSList.size() >0) {
               system.debug('In NEW GS');
               system.debug('temprec.WFT_ID__c : ' +  temprec.WFT_ID__c);
              for ( String bnftcrr: finalcarrierNGSList ) {
                   if ( bnftcrr == temprec.Carrier__c){
                            system.debug('Creating WF for the carrier : ' + bnftcrr + ' in new GS. WFT Name: '+ temprec.MasterLabel);
                       GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name =  temprec.WF_Type__c + HYPHN + temprec.WF_Sub_Type__c + HYPHN + temprec.Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = temprec.WF_Sub_Type__c,
                                                          GA_Type__c = temprec.WF_Type__c,
                                                          GA_Carrier__c = temprec.Carrier__c,
                                                          GA_Method__c = temprec.Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = temprec.WFT_ID__c,
                                                          GA_Status__c = ARV_AP41_StringLiteralUtils.TYPEOPEN,
                                                          GA_External_Initiated__c=true,
                                                          GA_Selected_Group_Segments__c=string.join(slectedNewGS,ARV_AP41_StringLiteralUtils.COMMAVAL),
                                                          GA_Benefit_Effective_Date__c=newGSLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
               system.debug('wfRec:;'+wfRec);
            wfRecLst.add(wfRec);
                        }
              }
               
               }
               } 
           }
            //end :
            system.debug ('wfRecLst::'+wfRecLst);
           creatContractNewwrkflow(wfRecLst, cntrcRecd.Id);
        }
        catch(exception e)
        {
            system.debug('In catch Block----' + e.getMessage() +'------' + e.getLineNumber());
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CHECKTEMPLATEMETHDNME, cntrcRecd.Id);
        }
    }
    /**
@Description: creatContractNewwrkflow() method 
@Name : creatContractNewwrkflow
@Param : List<GA_WF_Workflow__c> , string   
@Return : void
@throws Exception : N/A
*/  
    public static void creatContractNewwrkflow(List<GA_WF_Workflow__c> wfRecLst,
                                               string cntrcRecdID)
    {
        try{
                if(wfRecLst.size()>0){
                GA_WorkflowServiceCls.isExecuting=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                database.insert(wfRecLst);
            }
        }
           
            
        catch(exception e){
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CREATCONTRACTWRKFLOWMETHDNME, cntrcRecdID);
            ARV_AP59_CreateGroupSegmentRecords.errorOccured = true;
        }
        
    }
}