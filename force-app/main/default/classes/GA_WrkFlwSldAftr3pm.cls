/*****************************************************************************************
Class Name   : GA_WrkFlwSldAftr3pm
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : This GA_WrkFlwSldAftr3pm class is used for updating the
workflow process based on some parameters. 
******************************************************************************************/
public with sharing class GA_WrkFlwSldAftr3pm {
    public static final String ClsName  ='GA_WrkFlwSldAftr3pm';
    public static final String methodNmeAfter  ='afterUpdate';
    public static  List<GA_WF_Group_Segment__c> wfgsLst ;
    public static  List<id> wfgsLsttoUpdateBtch=new  List<id>();
    public static  map<id,string> wfgsLsttoclnBtch=new  map<id,string>();
    public static Map<Id,List<GA_WF_Group_Segment__c>> wfGsMap;
    public static List<GA_WF_Step__c> preprocessingStps ;
    public static Map<Id,GA_WF_Step__c> wfstpMap;
    public static Map<Id,Id> wfTmpMap;
    public static Map<Id,list<Id>> wfTmpWfMap;
    public static List<GA_WFT_Step__c> completeTmpLst;
    public static List<GA_WF_Step__c> completeStpsLst;
    public static Map<Id,List<GA_WFT_Step__c>> comTmpMap;
    public static Map<String,GA_WFT_Step__c> resultTmpMap ;
    public static List<GA_WFT_Step__c> wftTmpStpLst;
    public static list<string> condAssignNms;
    public static list<string> queNams;
    public static map<string,list<id>> wrkflwWfNmGrpSgmntMap;
    public static map<Id,map<id,id>> prntWFPrcssMap;
    public static boolean isCallBatch=false;
    public static boolean isRecursive=false;
    public static set<id> wfgsSetId;
    public static list<id> wfgsLstId;
    public static map<id,list<string>> cnslStpGrpsMap=new map<id,list<string>>();
    public static string hyphen='-';
    public static string OpenVal='Open';
    public static string CmpVal='Completed';
    public static string SuccssVal='Success Report';
    public static string ClsVal='Closed';
    public static string CnclVal='Canceled';
    public static string DespRpVal='Discrepancy Report';
    public static string PrjSupVal='Project Support - to Review';
    public static string NwLnVal='\n';
    public static string PndgRpVal='Pending Report';
    public static string GWCAssgnVal='GWC - for Assignment';
    public static string AtmedVldtnVal='Automated Validation';
    public static string PrePrssngVal='Pre-Processing';
    public static string RsultVal='GA_Result__c'; 
    public static string stsVal='GA_Status__c';
    public static string BlnkVal='';
    public static string rtcntlPrcssr='GA_Rate_Control_Processor_QueueWFGS';
    public static string rateCotrlQuality='GA_Rate_Control_Quality_WFGSQueue';
    public static string rateContrlTeam='Rate_Control_Team_Lead_WFGSQueue';
    public static string SalesSuppPcs='GA_Sales_Support_PCS_WFGSQueue';
    public static string WMPcs='West_Michigan_Support_PCS_Queue';
    public static string smallGrp='GA_Small_Group_Underwriting_Queue';
    public static TimeZone tz = UserInfo.getTimeZone();
    public static Datetime currenttime = system.now();
    public static final String methodNmebeforeupdate  ='beforeupdate';
    public static final String methodNmefetchWFGSLst  ='fetchWFGSLst';
    public static final String methodNmeupdtPCSNotification  ='updtPCSNotification';
    public static final String methodNmeupdtNotification  ='updtNotification';
    public static final String QueVal  ='Queue';
    public static final Datetime MYDT = Datetime.now();
    public static final String DTFRMT = myDT.format('MM/dd/yyyy h:mm:ss a');
    public static final String SPACE = ' ';
    public static final String COMMA = ',';
    public static final String DLMTR = '\n' ;
    /**
@Description: afterUpdate() method 
@Name : afterUpdate
@Param :Map<Id,GA_WF_Group_Segment__c> newmap, Map<Id,GA_WF_Group_Segment__c> oldmap
@Return : void
@throws Exception : N/A; 
*/
    public static void afterUpdate(Map<Id,GA_WF_Group_Segment__c> newmap, Map<Id,GA_WF_Group_Segment__c> oldmap)
        
    {  
        try{
            boolean ConditionalAssing=false;
            
            if(wfgsLst.size()>0)
            {
                list<id> prntWFPrcssWFIds=new list<id>();
                prntWFPrcssWFIds.addAll(wfGsMap.keyset());
                prntWFPrcssMap=fetchParentWEFPrcess(prntWFPrcssWFIds);
                map<string,id> queMap=new map<string,id>();
                list<GA_WF_Step__c> wrkStpLst=[select id,GA_WF_Workflow_ID__c,Name,GA_Status__c,GA_Notes__c,(select id,ownerId,GA_Group_Segment_ID__c,
                                                                                                             GA_WF_Step_ID__c,GA_Status__c,GA_Workflow_Next_Step__c,GA_Notes__c from GA_WF_Group_Segments__r Limit 2000) 
                                               from GA_WF_Step__c where 
                                               GA_WF_Workflow_ID__c in :wfGsMap.keyset() 
                                               order by createddate asc limit 1000];
                map<string,list<GA_WF_Group_Segment__c>> wrfgrpNoWFGrpRecMap=new map<string,list<GA_WF_Group_Segment__c>>();
                list<GA_WF_Group_Segment__c> grpSgmntLst;
                list<GA_WF_Group_Segment__c> grpSgmntCurrUptLst=new list<GA_WF_Group_Segment__c>();
                map<string,GA_WF_Group_Segment__c> wrfgrpSGmntMap=new map<string,GA_WF_Group_Segment__c>();
                map<string,list<GA_WF_Group_Segment__c>> wrfgrpNoWFGrpRecMapOpen=new map<string,list<GA_WF_Group_Segment__c>>();
                list<GA_WF_Group_Segment__c> grpSgmntLstOpen;
                map<string,GA_WF_Group_Segment__c> wrfgrpSGmntMapOpen=new map<string,GA_WF_Group_Segment__c>();
                map<string,list<GA_WF_Step__c>> wrfwFStpmap=new map<string,list<GA_WF_Step__c>>();
                list<GA_WF_Step__c> wfWfstptpLst;
                list<GA_WF_Step__c> wfstptpClsLst=new list<GA_WF_Step__c>();
                map<string,list<id>> wrfgrpNoWFGrpRecMapOpenGrpId=new map<string,list<id>>();
                list<GA_WF_Step__c> updateWFStps=new list<GA_WF_Step__c>();
                list<id> grpIds;
                if(wrkStpLst.size()>0)
                {
                    for(GA_WF_Step__c wrfstp:wrkStpLst)
                    {
                        if(condAssignNms.contains(wrfstp.Name))
                        {
                            if(wrfgrpNoWFGrpRecMap.get(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name) !=null)
                            {
                                grpSgmntLst=wrfgrpNoWFGrpRecMap.get(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name);
                            }
                            else
                            {
                                grpSgmntLst=new list<GA_WF_Group_Segment__c>();
                            }
                            grpSgmntLst.addall(wrfstp.GA_WF_Group_Segments__r);
                            wrfgrpNoWFGrpRecMap.put(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name,grpSgmntLst);  
                        }
                        if(wrfstp.GA_Status__c==OpenVal || wrfstp.Name==CmpVal)
                        {
                            if(wrfgrpNoWFGrpRecMapOpen.get(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name) !=null)
                            {
                                grpSgmntLstOpen=wrfgrpNoWFGrpRecMapOpen.get(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name);
                            }
                            else
                            {
                                grpSgmntLstOpen=new list<GA_WF_Group_Segment__c>();
                            }
                            grpSgmntLstOpen.addall(wrfstp.GA_WF_Group_Segments__r);
                            wrfgrpNoWFGrpRecMapOpen.put(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name,grpSgmntLstOpen);
                            system.debug('wrfgrpNoWFGrpRecMapOpen: '+wrfgrpNoWFGrpRecMapOpen);
                            
                            if( wrfwFStpmap.get(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name) !=null)
                            {
                                wfWfstptpLst=wrfwFStpmap.get(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name);
                            }
                            else
                                wfWfstptpLst=new list<GA_WF_Step__c>(); 
                            wfWfstptpLst.add(wrfstp);
                            wrfwFStpmap.put(wrfstp.GA_WF_Workflow_ID__c+hyphen+wrfstp.Name,wfWfstptpLst); 
                        }
                    }
                    
                    for(string wfid : wrfgrpNoWFGrpRecMap.keyset()){
                        for(GA_WF_Group_Segment__c wrkFlwgs : wrfgrpNoWFGrpRecMap.get(wfid))
                        {
                            wrfgrpSGmntMap.put(wfid+hyphen+wrkFlwgs.GA_Group_Segment_ID__c,wrkFlwgs);
                        }
                    }
                    for(string wfid : wrfgrpNoWFGrpRecMapOpen.keyset()){
                         grpIds=new list<id>();
                        for(GA_WF_Group_Segment__c wrkFlwgs : wrfgrpNoWFGrpRecMapOpen.get(wfid))
                        {
                            wrfgrpSGmntMapOpen.put(wfid+hyphen+wrkFlwgs.GA_Group_Segment_ID__c,wrkFlwgs);
                            if(wrkFlwgs.GA_Workflow_Next_Step__c == null)
                                grpIds.add(wrkFlwgs.id);
                            
                        }
                        system.debug('grpIds: '+grpIds);
                        wrfgrpNoWFGrpRecMapOpenGrpId.put(wfid,grpIds);
                    }
                }
               // list<QueueSobject> queLst=[SELECT Id, Queue.name,QueueId,Queue.developerName FROM QueueSobject where Queue.name in :quenams limit 1000];
                for(QueueSobject queVal:[SELECT Id, Queue.name,QueueId,Queue.developerName FROM QueueSobject where Queue.name in :quenams limit 1000])
                {
                    queMap.put(queVal.Queue.name,queVal.QueueId);
                }
                list<GA_WF_Group_Segment__c> grpSgmntInsrtExistStep=new list<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c WFgrpSgmntCurr;
                GA_WF_Step__c objNextWorkFlowStep ;
                map<id,GA_WF_Step__c> cmpStepsEndDteUpet=new map<id,GA_WF_Step__c>();
                map<id,GA_Group_Segment__c> grpSgmnstsPrccsed=new map<id,GA_Group_Segment__c>();
                GA_Group_Segment__c grpTmp=new GA_Group_Segment__c();
                GA_WF_Step__c wfSTpCmp;
                GA_WF_Step__c wfStpRec;
                for(Id wfid : wfGsMap.keyset()){
                    boolean dispRp=false;
                    boolean pendRp=false;
                    boolean compRp=false;
                    grpIds=new list<string>();
                    
                    for(GA_WF_Group_Segment__c wrkFlwgs : wfGsMap.get(wfid))
                    {
                        boolean stpExist=false;
                        Date TdyDate = System.today();    
                        
                        Datetime preprocessingEndDttime = wfstpMap.get(wfid).GA_End_Time__c;
                        
                        
                        Date processingDt = preprocessingEndDttime.date();            
                        integer dayDiff = processingDt.daysBetween(TdyDate);
                        
                        If((wrkFlwgs.GA_Workflow_ID__r.GA_Sold_After_3PM__c && dayDiff > 1) || !wrkFlwgs.GA_Workflow_ID__r.GA_Sold_After_3PM__c || newmap.get(wrkFlwgs.id).ga_result__c==SuccssVal || newmap.get(wrkFlwgs.id).ga_result__c==PndgRpVal)
                        {    
                            
                            
                            GA_WFT_Step__c objNextWorkFlowTemplateStep ;
                            If(newmap.get(wrkFlwgs.id).ga_result__c == SuccssVal) 
                            {
                                if(wrfgrpNoWFGrpRecMapOpen.get(wfid+hyphen+CmpVal) ==null)
                                {
                                    if(!compRp)
                                    {
                                        objNextWorkFlowStep=new GA_WF_Step__c();  
                                        objNextWorkFlowTemplateStep =resultTmpMap.get(wfid+hyphen+CmpVal);
                                        objNextWorkFlowStep.GA_Status__c = ClsVal;
                                        objNextWorkFlowStep.GA_End_Time__c =currenttime;                                        
                                        
                                        stpExist=false;
                                    }
                                }
                                else
                                {
                                    GA_WF_Group_Segment__c WFgrpSgmnt=preprGrpSgmntsRec(wrfwFStpmap.get(wfid+hyphen+CmpVal)[wrfwFStpmap.get(wfid+hyphen+CmpVal).size()-1],wrkFlwgs,
                                                                                        wrfgrpSGmntMap, queMap);
                                    grpSgmntInsrtExistStep.add(WFgrpSgmnt);
                                    WFgrpSgmntCurr=new GA_WF_Group_Segment__c();
                                    WFgrpSgmntCurr.Id=wrkFlwgs.id;
                                    WFgrpSgmntCurr.GA_Workflow_Next_Step__c=wrfwFStpmap.get(wfid+hyphen+CmpVal)[wrfwFStpmap.get(wfid+hyphen+CmpVal).size()-1].Id;
                                    grpSgmntCurrUptLst.add(WFgrpSgmntCurr);
                                    wfSTpCmp=new GA_WF_Step__c();
                                    wfSTpCmp.Id=wrfwFStpmap.get(wfid+hyphen+CmpVal)[wrfwFStpmap.get(wfid+hyphen+CmpVal).size()-1].Id;
                                    wfSTpCmp.GA_End_Time__c=currenttime;    
                                    cmpStepsEndDteUpet.put(wfSTpCmp.id,wfSTpCmp);
                                    stpExist=true;
                                }
                                
                                if(wrkFlwgs.GA_Workflow_Next_Step__r.Name==CnclVal)
                                {
                                    if(cnslStpGrpsMap.get(wrkFlwgs.GA_Workflow_Next_Step__c) !=null)
                                    {
                                        grpIds= cnslStpGrpsMap.get(wrkFlwgs.GA_Workflow_Next_Step__c);
                                    }
                                    else
                                    {
                                        grpIds=new list<string>();  
                                    }
                                    grpIds.add(wrkFlwgs.GA_Group_Segment_ID__c);
                                    cnslStpGrpsMap.put(wrkFlwgs.GA_Workflow_Next_Step__c,grpIds);   
                                }
                                
                               
                                
                                grpTmp=new GA_Group_Segment__c();
                                grpTmp.Id=wrkFlwgs.GA_Group_Segment_ID__c;
                                grpTmp.GA_In_Progress__c=false;
                                grpTmp.GA_In_Progress_Type__c='';
                                grpTmp.GA_Is_Mass_Updating__c=True;
                                grpSgmnstsPrccsed.put(wrkFlwgs.GA_Group_Segment_ID__c,grpTmp);
                                
                                
                            }
                            if(newmap.get(wrkFlwgs.id).ga_result__c == DespRpVal){
                                if(wrfgrpNoWFGrpRecMapOpen.get(wfid+hyphen+PrjSupVal) ==null)
                                {
                                    if(!dispRp)
                                    {
                                        objNextWorkFlowStep = new GA_WF_Step__c(); 
                                        stpExist=false;
                                        
                                        
                                    }
                                }
                                else
                                {
                                    GA_WF_Group_Segment__c WFgrpSgmnt=preprGrpSgmntsRec(wrfwFStpmap.get(wfid+hyphen+PrjSupVal)[wrfwFStpmap.get(wfid+hyphen+PrjSupVal).size()-1],wrkFlwgs,
                                                                                        wrfgrpSGmntMap, queMap);
                                    
                                    grpSgmntInsrtExistStep.add(WFgrpSgmnt);
                                    WFgrpSgmntCurr=new GA_WF_Group_Segment__c();
                                    WFgrpSgmntCurr.Id=wrkFlwgs.id;
                                    WFgrpSgmntCurr.GA_Workflow_Next_Step__c=wrfwFStpmap.get(wfid+hyphen+PrjSupVal)[wrfwFStpmap.get(wfid+hyphen+PrjSupVal).size()-1].Id;
                                    grpSgmntCurrUptLst.add(WFgrpSgmntCurr);
                                    
                                 /**   if(wrkFlwgs.GA_Notes__c !=null)
                                    {
                                        wfStpRec=new GA_WF_Step__c();                                   
                                        wfStpRec=wrfwFStpmap.get(wfid+hyphen+PrjSupVal)[wrfwFStpmap.get(wfid+hyphen+PrjSupVal).size()-1];
                                        
                                        if(!String.isEmpty(wfStpRec.GA_Notes__c))
                                            wfStpRec.GA_Notes__c=wfStpRec.GA_Notes__c+NwLnVal+wrkFlwgs.GA_Notes__c;
                                        else
                                            wfStpRec.GA_Notes__c= wrkFlwgs.GA_Notes__c;
                                        updateWFStps.add(wfStpRec);    
                                    }**/
                                    
                                    stpExist=true;
                                }
                                objNextWorkFlowTemplateStep =resultTmpMap.get(wfid+hyphen+PrjSupVal);
                                
                            }
                            if(newmap.get(wrkFlwgs.id).ga_result__c == PndgRpVal){
                                
                                if(wrfgrpNoWFGrpRecMapOpen.get(wfid+hyphen+GWCAssgnVal) ==null)
                                {
                                    if(!pendRp)
                                    {
                                        objNextWorkFlowStep = new GA_WF_Step__c(); 
                                        
                                        stpExist=false;
                                        
                                    }
                                }
                                else
                                {
                                    
                                    if(wrfgrpSGmntMapOpen.get(wfid+hyphen+GWCAssgnVal+hyphen+wrkFlwgs.GA_Group_Segment_ID__c) ==null)
                                    {
                                        GA_WF_Group_Segment__c WFgrpSgmnt=preprGrpSgmntsRec(wrfwFStpmap.get(wfid+hyphen+GWCAssgnVal)[wrfwFStpmap.get(wfid+hyphen+GWCAssgnVal).size()-1],wrkFlwgs,
                                                                                            wrfgrpSGmntMap, queMap);
                                        grpSgmntInsrtExistStep.add(WFgrpSgmnt);
                                        WFgrpSgmntCurr=new GA_WF_Group_Segment__c();
                                        WFgrpSgmntCurr.Id=wrkFlwgs.id;
                                        WFgrpSgmntCurr.GA_Workflow_Next_Step__c=wrfwFStpmap.get(wfid+hyphen+GWCAssgnVal)[wrfwFStpmap.get(wfid+hyphen+GWCAssgnVal).size()-1].Id;
                                        grpSgmntCurrUptLst.add(WFgrpSgmntCurr);
                                        stpExist=true;
                                       /** if(wrkFlwgs.GA_Notes__c !=null)
                                        {
                                            wfStpRec=new GA_WF_Step__c();
                                            wfStpRec=wrfwFStpmap.get(wfid+hyphen+GWCAssgnVal)[wrfwFStpmap.get(wfid+hyphen+GWCAssgnVal).size()-1];                                       
                                              if(!String.isEmpty(wfStpRec.GA_Notes__c))
                                                wfStpRec.GA_Notes__c=wfStpRec.GA_Notes__c+NwLnVal+wrkFlwgs.GA_Notes__c;
                                            else
                                                wfStpRec.GA_Notes__c= wrkFlwgs.GA_Notes__c;
                                            updateWFStps.add(wfStpRec);    
                                        }**/
                                        
                                    }
                                    
                                }
                                
                                objNextWorkFlowTemplateStep =resultTmpMap.get(wfid+hyphen+GWCAssgnVal);
                            }
                           /** if(objNextWorkFlowStep !=null)
                            {
                                if(   !String.isEmpty(objNextWorkFlowStep.GA_Notes__c)  &&   !String.isEmpty(wrkFlwgs.GA_Notes__c  ) )
                                    objNextWorkFlowStep.GA_Notes__c=objNextWorkFlowStep.GA_Notes__c+NwLnVal+wrkFlwgs.GA_Notes__c;   
                            }**/
                            
                            
                            if(!stpExist && ((newmap.get(wrkFlwgs.id).ga_result__c == PndgRpVal && !pendRp) || 
                                             (newmap.get(wrkFlwgs.id).ga_result__c == DespRpVal && !dispRp) || 
                                             (newmap.get(wrkFlwgs.id).ga_result__c == SuccssVal && !compRp)))
                            {
                                if(newmap.get(wrkFlwgs.id).ga_result__c == SuccssVal)
                                {
                                    compRp=true;
                                }
                                
                                if(newmap.get(wrkFlwgs.id).ga_result__c == PndgRpVal)
                                {
                                    pendRp=true;
                                }
                                if(newmap.get(wrkFlwgs.id).ga_result__c == DespRpVal)
                                {
                                    dispRp=true;
                                }
                                objNextWorkFlowStep.Name = objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name; 
                                objNextWorkFlowStep.GA_WF_Workflow_ID__c = wrkFlwgs.GA_Workflow_ID__c;                                
                                objNextWorkFlowStep.GA_WF_Template_Step__c = objNextWorkFlowTemplateStep.id;
                                /**if(objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name !=CmpVal)
                                {
                                    if(wrkFlwgs.GA_Notes__c !=null)          
                                        objNextWorkFlowStep.GA_Notes__c=wrkFlwgs.GA_Notes__c;   
                                }**/
                                
                                objNextWorkFlowStep.GA_Start__c = currenttime;  
                                completeStpsLst.add(objNextWorkFlowStep);    
                            }
                            
                        }
                        
                    }
                    
                    set<id> wrfgrpNoWFGrp=new set<id>();
                    set<id> wrkflwWfNmGrp=new set<id>();
                    system.debug('wrfgrpNoWFGrpRecMapOpenGrpId :'+wrfgrpNoWFGrpRecMapOpenGrpId.get(wfid+hyphen+AtmedVldtnVal));
                    system.debug('wrkflwWfNmGrpSgmntMap :'+ wrkflwWfNmGrpSgmntMap.get(wfid+hyphen+AtmedVldtnVal));
                    if(wrfgrpNoWFGrpRecMapOpenGrpId.get(wfid+hyphen+AtmedVldtnVal) !=null && wrkflwWfNmGrpSgmntMap.get(wfid+hyphen+AtmedVldtnVal) !=null)
                    {
                        wrfgrpNoWFGrp.addall(wrfgrpNoWFGrpRecMapOpenGrpId.get(wfid+hyphen+AtmedVldtnVal));
                        system.debug('wrfgrpNoWFGrp:'+wrfgrpNoWFGrp);
                        wrkflwWfNmGrp.addall(wrkflwWfNmGrpSgmntMap.get(wfid+hyphen+AtmedVldtnVal));
                        system.debug('wrkflwWfNmGrp:'+wrkflwWfNmGrp);
                        
                        //if(wrfgrpNoWFGrpRecMapOpenGrpId.get(wfid+hyphen+AtmedVldtnVal).equals(wrkflwWfNmGrpSgmntMap.get(wfid+hyphen+AtmedVldtnVal)) )
                        if (wrfgrpNoWFGrp.containsAll(wrkflwWfNmGrp)) 
                        {
                            system.debug('Match....!!!');
                            list<GA_WF_Step__c> wfStpRecToClose= wrfwFStpmap.get(wfid+hyphen+AtmedVldtnVal);
                            List<id> opnWfgsidLst = wrkflwWfNmGrpSgmntMap.get(wfid+hyphen+AtmedVldtnVal) ;
                            for(GA_WF_Step__c wfstpcls:wfStpRecToClose)
                            {
                                for(id wfgsid : opnWfgsidLst){
                                wfstpcls.ga_notes__c =  newmap.get(wfgsid).GA_Notes__c + (wfstpcls.GA_Notes__c <> null ? DLMTR +  wfstpcls.GA_Notes__c  : '' ) ;
                                }
                                wfstpcls.GA_Status__c=ClsVal;
                                wfstpcls.GA_End_Time__c=currenttime;
                                wfstptpClsLst.add(wfstpcls); 
                            }
                            
                        }
                        else{
                            system.debug('No Match....!!!');
                            list<GA_WF_Step__c> opnWfStpRecNotes= wrfwFStpmap.get(wfid+hyphen+AtmedVldtnVal);
                            List<id> opnWfgsidLst = wrkflwWfNmGrpSgmntMap.get(wfid+hyphen+AtmedVldtnVal) ;                           
                            for(GA_WF_Step__c wfstpopn :opnWfStpRecNotes)
                            {
                                for(id wfgsid : opnWfgsidLst){
                                wfstpopn.ga_notes__c =  newmap.get(wfgsid).GA_Notes__c + (wfstpopn.GA_Notes__c <> null ? DLMTR +  wfstpopn.GA_Notes__c  : '' ) ;
                                }
                                wfstptpClsLst.add(wfstpopn); 
                            }
                        }
                    }
                    
                }
                
                Database.insert(completeStpsLst);
                List<GA_WF_Group_Segment__c> currentWFgsLst =New List<GA_WF_Group_Segment__c>();
                List<GA_WF_Group_Segment__c> compWfgsLst = new List<GA_WF_Group_Segment__c>();
                map<string,string> stpNmGrpRsltMap=new  map<string,string>();
                stpNmGrpRsltMap.put(GWCAssgnVal,PndgRpVal);
                stpNmGrpRsltMap.put(PrjSupVal,DespRpVal);
                stpNmGrpRsltMap.put(CmpVal,SuccssVal);
                GA_WF_Group_Segment__c currentWFgrpSgmnt;
                for( GA_WF_Step__c wfStp : completeStpsLst){
                    for(GA_WF_Group_Segment__c wrkFlwgs : wfGsMap.get(wfStp.GA_WF_Workflow_ID__c)) {
                        GA_WF_Group_Segment__c WFgrpSgmnt;
                        if(stpNmGrpRsltMap.get(wfStp.Name)==newmap.get(wrkFlwgs.id).ga_result__c)
                        {
                            
                            WFgrpSgmnt=preprGrpSgmntsRec(wfStp,wrkFlwgs,
                                                         wrfgrpSGmntMap, queMap);
                            
                            compWfgsLst.add(WFgrpSgmnt);  
                            currentWFgrpSgmnt=new GA_WF_Group_Segment__c(id = wrkFlwgs.id,
                                                                GA_Workflow_Next_Step__c  =  wfStp.id);
                            currentWFgsLst.add(currentWFgrpSgmnt);
                            
                        }
                        
                        
                        
                        
                        
                    }
                }
                compWfgsLst.addall(grpSgmntInsrtExistStep);
                database.insert(compWfgsLst);
                currentWFgsLst.addAll(grpSgmntCurrUptLst);
                database.update(currentWFgsLst); 
                database.update(wfstptpClsLst); 
                map<id,integer> wrfStpCnt=new map<id,integer>();
                map<id,integer> wrfStpCntCls=new map<id,integer>();
                integer stpCnt=0;
                integer stpCntCls=0;
                set<id> wfIdsToCls=new set<id>();
                for(GA_WF_Step__c wfSTp:wfstptpClsLst)
                {
                    if(wfSTp.GA_WF_Workflow_ID__c <> null){
                    wfIdsToCls.add(wfSTp.GA_WF_Workflow_ID__c);
                        }
                }
                
               for(GA_WF_Step__c wfstp:[select id,GA_WF_Workflow_ID__c,Name,GA_Status__c
                                                  from GA_WF_Step__c where 
                                                  GA_WF_Workflow_ID__c in :wfIdsToCls 
                                                  order by createddate asc limit 1000])
                {
                    if(wrfStpCnt.get(wfstp.GA_WF_Workflow_ID__c) !=null)
                    {
                        stpCnt=wrfStpCnt.get(wfstp.GA_WF_Workflow_ID__c);
                    }
                    else
                    {
                        stpCnt=0;
                    }
                    stpCnt++;
                    wrfStpCnt.put(wfstp.GA_WF_Workflow_ID__c, stpCnt);
                    if(wfstp.GA_Status__c ==ClsVal)
                    {
                        if(wrfStpCntCls.get(wfstp.GA_WF_Workflow_ID__c) !=null)
                        {
                            stpCntCls=wrfStpCntCls.get(wfstp.GA_WF_Workflow_ID__c);
                        }
                        else
                        {
                            stpCntCls=0;
                        }
                        stpCntCls++;
                        wrfStpCntCls.put(wfstp.GA_WF_Workflow_ID__c, stpCntCls);
                    }
                    
                }
                list<GA_WF_Workflow__c> wrfToCls=new list<GA_WF_Workflow__c>();
                GA_WF_Workflow__c wf;
                for(id wfId:wrfStpCntCls.keySet())
                {
                    if(wrfStpCntCls.get(wfId)==wrfStpCnt.get(wfId))
                    {
                        wf=new  GA_WF_Workflow__c();  
                        wf.id=wfId;
                        wf.GA_Date_Closed__c=system.today();
                        wf.GA_Status__c=ClsVal;
                        wrfToCls.add(wf);
                    }
                }
                database.update(wrfToCls);
                
                
                if(updateWFStps.size()>0)
                    database.update(updateWFStps);
                if(cnslStpGrpsMap.keySet().size()>0)
                {
                    deleteCnelGrpsmnt(cnslStpGrpsMap);
                }
                if(cmpStepsEndDteUpet.keyset().size()>0)
                {
                    database.update(cmpStepsEndDteUpet.values());
                }
                if(grpSgmnstsPrccsed.keyset().size()>0)
                {
                    GA_GS_AP02_Update_Address.isExecuting=true;
                    GA_GS_UpdateRatingType.isExecuting = true;
                    GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                    GA_GroupSegmentTriggerHandler.isExecuting = true;
                    GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                    GA_GS_AP04_UpdtStatus.isExecuting = true;
                    GA_GS_AP04_UpdtStatus.isInvoked = true;
                    GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                    database.update(grpSgmnstsPrccsed.values()); 
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeAfter);
        }
    }
    private static void deleteCnelGrpsmnt(map<id,list<string>> cnslStpGrpsMapTmp)
    {
        set<string> grpIds=new set<string>();
        for(string stepId:cnslStpGrpsMapTmp.keyset())
        {
            grpIds.addAll(cnslStpGrpsMapTmp.get(stepId));
        }
      /**  list<GA_WF_Group_Segment__c> wfGSLst=[select id,GA_Group_Segment_ID__c,GA_WF_Step_ID__c,GA_Workflow_ID__c,GA_Workflow_ID__r.GA_Status__c from GA_WF_Group_Segment__c 
                                              where GA_WF_Step_ID__c in:cnslStpGrpsMapTmp.keySet() limit 5000];**/
        list<GA_WF_Group_Segment__c> wfGStoDlete=new list<GA_WF_Group_Segment__c> ();
        map<id,integer> cnlSTpWFPrcssCnt=new map<id,integer>();
        map<id,id> wfToUpdteId=new map<id,id>();
        integer cntVal=0;
        for(GA_WF_Group_Segment__c wfPrcss:[select id,GA_Group_Segment_ID__c,GA_WF_Step_ID__c,GA_Workflow_ID__c,GA_Workflow_ID__r.GA_Status__c from GA_WF_Group_Segment__c 
                                              where GA_WF_Step_ID__c in:cnslStpGrpsMapTmp.keySet() limit 5000])
        {
            if(cnlSTpWFPrcssCnt.get(wfPrcss.GA_WF_Step_ID__c) !=null)
            {
                cntVal=cnlSTpWFPrcssCnt.get(wfPrcss.GA_WF_Step_ID__c);
            }
            else
                cntVal=0;
            cntVal=cntVal+1;
            cnlSTpWFPrcssCnt.put(wfPrcss.GA_WF_Step_ID__c,cntVal);
            if(wfPrcss.GA_Workflow_ID__r.GA_Status__c ==CnclVal)
                wfToUpdteId.put(wfPrcss.GA_WF_Step_ID__c,wfPrcss.GA_Workflow_ID__c);
        }
        for(GA_WF_Group_Segment__c wfPrcss:[select id,GA_Group_Segment_ID__c,GA_WF_Step_ID__c,GA_Workflow_ID__c,GA_Workflow_ID__r.GA_Status__c from GA_WF_Group_Segment__c 
                                              where GA_WF_Step_ID__c in:cnslStpGrpsMapTmp.keySet() limit 5000])
        {
            if(cnslStpGrpsMapTmp.get(wfPrcss.GA_WF_Step_ID__c).contains(wfPrcss.GA_Group_Segment_ID__c))
            {
                wfGStoDlete.add(wfPrcss);
            }
        }
        list<id> cnclStpstoDlte=new list<id>();
        list<GA_WF_Workflow__c> wftoUpdte=new list<GA_WF_Workflow__c>();
        GA_WF_Workflow__c wfTpUpdteSts;
        for(id stpId:cnslStpGrpsMapTmp.keyset())
        {
            
            if(cnslStpGrpsMapTmp.get(stpId).size()==cnlSTpWFPrcssCnt.get(stpId))
            {
                cnclStpstoDlte.add(stpId);
                wfTpUpdteSts=new GA_WF_Workflow__c();
                wfTpUpdteSts.id=wfToUpdteId.get(stpId);
                wfTpUpdteSts.GA_Status__c=ClsVal;
                wftoUpdte.add(wfTpUpdteSts);
            }
        }
        if(wfGStoDlete.size()>0)
            database.delete(wfGStoDlete);
        if(cnclStpstoDlte.size()>0)
        {
            database.delete(cnclStpstoDlte);
        }
        if(wftoUpdte.size()>0)
        {
            database.update(wftoUpdte);
        }
    }
    private static map<id,map<id,id>> fetchParentWEFPrcess(list<id> wfIdLst)
    {
        //list<GA_WF_Group_Segment__c> wfPrcssLst=;
        map<id,map<id,id>> wfgrpPrntWfPrcssMap=new map<id,map<id,id>>();
        map<id,id> grpPrntWfPrcssMap=new map<id,id>();
        for(GA_WF_Group_Segment__c wfGs:[select id,GA_Group_Segment_ID__c,GA_Workflow_ID__c from GA_WF_Group_Segment__c where GA_WF_Step_ID__c=null and GA_Workflow_ID__c in:wfIdLst limit 5000])
        {
            if(wfgrpPrntWfPrcssMap.get(wfGs.GA_Workflow_ID__c)!=null)
            {
                grpPrntWfPrcssMap=wfgrpPrntWfPrcssMap.get(wfGs.GA_Workflow_ID__c);
            }
            else
            {
                grpPrntWfPrcssMap=new map<id,id>();
            }
            grpPrntWfPrcssMap.put(wfGs.GA_Group_Segment_ID__c,wfGs.id);
            wfgrpPrntWfPrcssMap.put(wfGs.GA_Workflow_ID__c,grpPrntWfPrcssMap);
        }
        return wfgrpPrntWfPrcssMap;
    }
    private static GA_WF_Group_Segment__c preprGrpSgmntsRec(GA_WF_Step__c wfStp,GA_WF_Group_Segment__c wrkFlwgs,
                                                            map<string,GA_WF_Group_Segment__c> wrfgrpSGmntMap, map<string,id> queMap)
    {
        GA_WF_Group_Segment__c WFgrpSgmnt=new GA_WF_Group_Segment__c();
        WFgrpSgmnt.GA_Workflow_ID__c=  wfStp.GA_WF_Workflow_ID__c;
        WFgrpSgmnt.GA_Group_Segment_ID__c = wrkFlwgs.GA_Group_Segment_ID__c;
        WFgrpSgmnt.GA_WF_Step_ID__c =  wfStp.id;
        WFgrpSgmnt.GA_Date_Opened__c = currenttime;
        WFgrpSgmnt.ga_status__c = OpenVal;
        WFgrpSgmnt.GA_Parent_WF_Process__c = prntWFPrcssMap.get(wfStp.GA_WF_Workflow_ID__c).get(wrkFlwgs.GA_Group_Segment_ID__c);
        if(wfStp.Name == CmpVal){
            WFgrpSgmnt.ga_status__c = ClsVal;
        }
        WFgrpSgmnt.OwnerId = userinfo.getUserId();
        if(wfStp.Name == GWCAssgnVal){
            if(wrfgrpSGmntMap.get(wfStp.GA_WF_Workflow_ID__c+hyphen+GWCAssgnVal+hyphen+wrkFlwgs.GA_Group_Segment_ID__c) !=null)
            {
                GA_WF_Group_Segment__c grpPrior=wrfgrpSGmntMap.get(wfStp.GA_WF_Workflow_ID__c+hyphen+GWCAssgnVal+hyphen+wrkFlwgs.GA_Group_Segment_ID__c);
                WFgrpSgmnt.OwnerId=grpPrior.OwnerId; 
            }
            else
            {
                WFgrpSgmnt.OwnerId=queMap.get(resultTmpMap.get(wfStp.GA_WF_Workflow_ID__c+hyphen+GWCAssgnVal).GA_Queue__c);  
            }
        }
        if(wfStp.Name == PrjSupVal){
            if(wrfgrpSGmntMap.get(wfStp.GA_WF_Workflow_ID__c+hyphen+PrjSupVal+hyphen+wrkFlwgs.GA_Group_Segment_ID__c) !=null)
            {
                GA_WF_Group_Segment__c grpPrior=wrfgrpSGmntMap.get(wfStp.GA_WF_Workflow_ID__c+hyphen+PrjSupVal+hyphen+wrkFlwgs.GA_Group_Segment_ID__c);
                WFgrpSgmnt.OwnerId=grpPrior.OwnerId; 
            }
            else
            {
                WFgrpSgmnt.OwnerId=queMap.get(resultTmpMap.get(wfStp.GA_WF_Workflow_ID__c+hyphen+PrjSupVal).GA_Queue__c);  
            }
        }
        return WFgrpSgmnt;
    }
    public static void beforeUpdate(Map<Id,GA_WF_Group_Segment__c> newmap, Map<Id,GA_WF_Group_Segment__c> oldmap)
        
    { 
        try
        {
            set<id> wfgsids = New  set<id>();       
            
            
            Boolean nxtStpsExists = false;
            wfGsMap = New  Map<Id,List<GA_WF_Group_Segment__c>>();
            List<GA_WF_Group_Segment__c> wfgrpLst ;
            wrkflwWfNmGrpSgmntMap=new map<string,list<id>> ();
            list<id> grpsgmntsIdLst;
            if(wfgsLst.size()>0)
            {
                for(GA_WF_Group_Segment__c wrkFlwgs : wfgsLst)
                {
                    if(wfGsMap.get(wrkFlwgs.GA_Workflow_ID__c) != null){
                        wfgrpLst = wfGsMap.get(wrkFlwgs.GA_Workflow_ID__c);
                    }
                    else{
                        wfgrpLst = New   List<GA_WF_Group_Segment__c>();
                        
                    }
                    wfgrpLst.add(wrkFlwgs); 
                    wfGsMap.put(wrkFlwgs.GA_Workflow_ID__c,wfgrpLst);
                    
                    if(wrkflwWfNmGrpSgmntMap.get(wrkFlwgs.GA_Workflow_ID__c+hyphen+wrkFlwgs.GA_WF_Step_ID__r.Name) != null){
                        grpsgmntsIdLst = wrkflwWfNmGrpSgmntMap.get(wrkFlwgs.GA_Workflow_ID__c+hyphen+wrkFlwgs.GA_WF_Step_ID__r.Name);
                    }
                    else{
                        grpsgmntsIdLst = New   List<id>();
                        
                    }
                    grpsgmntsIdLst.add(wrkFlwgs.id);
                    wrkflwWfNmGrpSgmntMap.put(wrkFlwgs.GA_Workflow_ID__c+'-'+wrkFlwgs.GA_WF_Step_ID__r.Name,grpsgmntsIdLst);
                }
                
                wfstpMap= New Map<Id,GA_WF_Step__c>();
                wfTmpMap= New Map<Id,Id>();
                wfTmpWfMap= New Map<Id,list<Id>>();
                list<id> wrfIds;
                for( GA_WF_Step__c wfstp : [Select id,GA_End_Time__c,GA_WF_Workflow_ID__c,
                                                          GA_WF_Workflow_ID__r.GA_Workflow_Template__c 
                                                          from GA_WF_Step__c where  GA_WF_Workflow_ID__c in :wfGsMap.keyset() 
                                                          and Name = :PrePrssngVal limit 5000 ]){            
                    wfstpMap.put(wfstp.GA_WF_Workflow_ID__c,wfstp); 
                    wfTmpMap.put(wfstp.GA_WF_Workflow_ID__c,wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template__c );
                    if(wfTmpWfMap.get(wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template__c) !=null)
                    {
                        wrfIds=wfTmpWfMap.get(wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template__c);
                    }
                    else
                    {
                        wrfIds=new list<id>();
                    }
                    wrfIds.add(wfstp.GA_WF_Workflow_ID__c);
                    wfTmpWfMap.put(wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template__c,wrfIds);
                }
                
                list<string> wftmplStrng=new list<string>();
                wftmplStrng.add(CmpVal);
                wftmplStrng.add(GWCAssgnVal);
                wftmplStrng.add(PrjSupVal);
              /**  completeTmpLst = [SELECT Id, Name,GA_Queue__c,GA_WFT_Workflow_ID__c, GA_WFT_Inventory_Step_ID__r.Name,GA_Conditional_Assignment__c FROM GA_WFT_Step__c 
                                  WHERE GA_WFT_Inventory_Step_ID__r.Name in :wftmplStrng                              
                                  and GA_WFT_Workflow_ID__c in : wfTmpMap.values() limit 100];**/
                comTmpMap = New  Map<Id,List<GA_WFT_Step__c>>();
                resultTmpMap = new  Map<String,GA_WFT_Step__c> ();
                condAssignNms=new list<string>();
                queNams=new list<string>();
                for( GA_WFT_Step__c wfTmpstp : [SELECT Id, Name,GA_Queue__c,GA_WFT_Workflow_ID__c, GA_WFT_Inventory_Step_ID__r.Name,GA_Conditional_Assignment__c FROM GA_WFT_Step__c 
                                  WHERE GA_WFT_Inventory_Step_ID__r.Name in :wftmplStrng                              
                                  and GA_WFT_Workflow_ID__c in : wfTmpMap.values() limit 100]){
                    
                    condAssignNms.add(wfTmpstp.GA_Conditional_Assignment__c);
                    queNams.add(wfTmpstp.GA_Queue__c);
                    
                    for(id wrfId:wfTmpWfMap.get(wfTmpstp.GA_WFT_Workflow_ID__c))
                    {
                        resultTmpMap.put(wrfId +hyphen+ wfTmpstp.GA_WFT_Inventory_Step_ID__r.Name,wfTmpstp);  
                    }
                    
                }
                
                completeStpsLst = new List<GA_WF_Step__c>();
                
                for(Id wfid : wfGsMap.keyset()){
                    for(GA_WF_Group_Segment__c wrkFlwgs : wfGsMap.get(wfid))
                    {
                        Date TdyDate = System.today();    
                        
                        Datetime preprocessingEndDttime = wfstpMap.get(wfid).GA_End_Time__c;
                        
                        
                        Date processingDt = preprocessingEndDttime.date();            
                        integer dayDiff = processingDt.daysBetween(TdyDate);
                        
                        If((wrkFlwgs.GA_Workflow_ID__r.GA_Sold_After_3PM__c && dayDiff > 1) || 
                           newmap.get(wrkFlwgs.id).ga_result__c==SuccssVal || 
                           newmap.get(wrkFlwgs.id).ga_result__c==PndgRpVal || !(wrkFlwgs.GA_Workflow_ID__r.GA_Sold_After_3PM__c))
                        {
                            wfgsids.add(wrkFlwgs.id);
                        }
                    }
                }
                for(GA_WF_Group_Segment__c wrkFlwgs : newmap.values())
                {
                     wrkFlwgs.GA_Notes__c = DTFRMT + SPACE + userinfo.getName() + SPACE + wrkFlwgs.GA_Group_Segment_Name__c +SPACE  +  wrkFlwgs.GA_Notes__c ; 
                    if( wfgsids.contains(wrkFlwgs.id)){
                        
                        if(!System.isBatch())
                        {  
                            wrkFlwgs.GA_Date_Closed__c = currenttime;                
                            wrkFlwgs.GA_Status__c = ClsVal;   
                        }
                        
                        wfgsLsttoUpdateBtch.add(wrkFlwgs.id);
                    }
                    else
                    {
                        if(!System.isBatch())
                            wrkFlwgs.GA_Result__c=BlnkVal;
                        else
                            wfgsLsttoclnBtch.put(wrkFlwgs.id, wrkFlwgs.GA_Result__c);   
                    }
                }
            }   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeupdate);
        }
        
    }
    
    
    public static void fetchWFGSLst(Map<Id,GA_WF_Group_Segment__c> newmap, Map<Id,GA_WF_Group_Segment__c> oldmap){
        try
        {
            wfgsSetId = New Set<Id>();
            list<string> grpIds=new list<string>();
            list<GA_WF_Group_Segment__c> wfgrpsgmntLst=new list<GA_WF_Group_Segment__c>();
            wfgsLst=new list<GA_WF_Group_Segment__c>();
            for(GA_WF_Group_Segment__c wfgs : newmap.values()){
                
                if( (wfgs.get(RsultVal) != oldmap.get(wfgs.Id).get(RsultVal)) 
                   && wfgs.get(RsultVal)  != NULL 
                   &&(wfgs.get(stsVal) !=CnclVal || wfgs.get(RsultVal)==SuccssVal)){
                       
                       wfgsSetId.add(wfgs.id);
                       
                   }  
            }
            wfgsLstId=new list<id>();
            wfgsLstId.addAll(wfgsSetId);
            if(wfgsSetId.size()<=100)
            {
                
                for(GA_WF_Group_Segment__c wfGsmnt:[Select id,GA_Workflow_ID__r.GA_Workflow_Template__c,GA_Workflow_Next_Step__r.Name,GA_Workflow_Next_Step__c,GA_Workflow_ID__r.GA_Sold_After_3PM__c,
                                 GA_Group_Segment_Name__c,GA_Result__c,GA_Date_Closed__c,GA_Status__c,GA_Group_Segment_ID__c,GA_WF_Step_ID__c,GA_WF_Step_ID__r.Name,GA_Notes__c
                                 from GA_WF_Group_Segment__c where id in :wfgsSetId limit 1000])
                {
                    wfGsmnt.GA_Notes__c=  newmap.get(wfGsmnt.id).GA_Notes__c; 
                    wfgsLst.add(wfGsmnt);
                }
                
            }
            else
            {
                isCallBatch=true; 
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmefetchWFGSLst);
        }
    }
    
    
    public static void updtPCSNotification(List<GA_WF_Group_Segment__c> wfgsList,Map<Id,GA_WF_Group_Segment__c> newmap, Map<Id,GA_WF_Group_Segment__c> oldmap){
        try
        {
        Set<ID> wfgsId =New Set<ID>();
        for(GA_WF_Group_Segment__c wfgs : wfgsList)
        { 
            if(oldmap!=null){
                
                GA_WF_Group_Segment__c wfgsOld = oldmap.get(wfgs.id);
                if(wfgsOld.GA_Date_Opened__c!=wfgs.GA_Date_Opened__c){
                    wfgsId.add(wfgs.Id);
                }
            }
            else
            {
                if(wfgs.GA_Date_Opened__c !=null)
                    wfgsId.add(wfgs.Id);
            }
        }
        if(!wfgsId.isEmpty()){
            updtNotification(wfgsId);
        }
        }
        catch(exception e)
        {
         GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdtPCSNotification);   
        }
    }
    
    @future (callout=true)
    public static void updtNotification(Set<ID> wfgsId){
        try
        {
       // List<GA_WF_Group_Segment__c> updtWFGSLst = ;
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE isdefault  = true limit 1];
        list<string> quDvNms=new list<string>(); 
        quDvNms.add(rtcntlPrcssr);
        quDvNms.add(rateCotrlQuality);
        quDvNms.add(rateContrlTeam);
        quDvNms.add(SalesSuppPcs);
        quDvNms.add(WMPcs);
        quDvNms.add(smallGrp);
        set<id> queIdSet;
      /**  list<Group> grpLst=[SELECT Id,DeveloperName FROM Group where Type = :QueVal and 
                            DeveloperName in :quDvNms limit 10];    **/
        map<id,Datetime> grpnotictDtmap=new map<id,Datetime>();
        for(GA_WF_Group_Segment__c wfgs: [SELECT ID,OWNERID,GA_Date_Opened__c,GA_PCS_Notification_Date__c FROM GA_WF_Group_Segment__c WHERE ID IN:wfgsId limit 5000]){
            Integer elapsed = 0;
            Datetime dtOpn = wfgs.GA_Date_Opened__c ;
            Datetime notificationDate = null;
            boolean dtCalc = false;            
            queIdSet=new set<id>();
            id smallGrpQueueId;
            for(Group grp:[SELECT Id,DeveloperName FROM Group where Type = :QueVal and 
                            DeveloperName in :quDvNms limit 10])
            {
                if(grp.DeveloperName==smallGrp)
                {
                    smallGrpQueueId=grp.Id;
                }
                else
                    queIdSet.add(grp.Id);   
            }
            if(queIdSet.contains(wfgs.OwnerId))
            {              
                notificationDate = BusinessHours.addGMT(bh.Id, dtOpn, 1000 * 60 * 60 * 16);
                dtCalc = true;
            }
            if(wfgs.OwnerId == smallGrpQueueId ){
                
                notificationDate = BusinessHours.add(bh.Id, dtOpn, 1000 * 60 * 60 * 24);
                dtCalc = true;
            }  
            if(dtCalc)
                grpnotictDtmap.put(wfgs.Id,notificationDate);
        }
        list<GA_WF_Group_Segment__c> dtWFGSLst=new list<GA_WF_Group_Segment__c>();
        GA_WF_Group_Segment__c wfps;    
        for(id wfgsTmpId: grpnotictDtmap.keySet()){
            
            wfps= new GA_WF_Group_Segment__c();
            wfps.id=wfgsTmpId;
            wfps.GA_PCS_Notification_Date__c=grpnotictDtmap.get(wfgsTmpId);
            dtWFGSLst.add(wfps);  
        }
        isRecursive = true;
        Database.update(dtWFGSLst);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdtNotification);   
        }
    }
}