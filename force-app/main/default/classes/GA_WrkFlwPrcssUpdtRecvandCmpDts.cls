/*****************************************************************************************
Class Name   : GA_WrkFlwPrcssUpdtRecvandCmpDts
Date Created : 20-08-2018
Created By   : IDC Offshore
Description  : 1. This class is to update received and completed dates for each workflow department
******************************************************************************************/
public with sharing class GA_WrkFlwPrcssUpdtRecvandCmpDts {
    public static final string ClsName  ='GA_WrkFlwPrcssUpdtRecvandCmpDts';
    public static final string  methodNme ='updtGrpAdminRecandCompDts';
    public static final string  methodNme1 ='rtecntrlupdtRecandCmpDts';
    public static final string  methodNme2 = 'bcnGmtupdtRecandCmpDts';
    public static final string  methodNme3 ='bcnUndrwrtrupdtRecandCmpDts';
    public static final string  methodNme4 ='smallGrpUndrwrtrupdtRecandCmpDts';
    public static final string  methodNme5 ='updteOwnrMngrEml';
    public static final string errMsg  ='Unable to update received or completed dates on Workflow';
    public static final string GrpAdmin  ='GA ';
    public static final string GrpAdminMgr  ='Group Admin ';
    public static final string rateCntrl  ='Rate ';
    public static final string bcnGmt  ='GMT';
    public static final string bcnUndrwrtr  ='BCN Underwriter';
    public static final string smllGrp  ='Small Group';
    public static final string GAQltyAnlyst  ='GA Quality Analyst';
    public static final string pcs  ='PCS';
    public static final string wm  ='West Michigan';
    public static final string supprt  ='Support';
    public static final string salesSpprt  ='Sales Support';
    public static  boolean isExecuting  =false;

    /**
@Description: updtGrpAdminRecandCompDts() method 
@Name : updtGrpAdminRecandCompDts
@Param :map<id,GA_WF_Group_Segment__c> wkflProcssNewMap, map<id,GA_WF_Group_Segment__c>  wkflProcssOldMap
@Return :
@throws Exception : AuraHandledException;
*/    
    public static void updtRecandCompDts(map<id,GA_WF_Group_Segment__c> wkflProcssNewMap, map<id,GA_WF_Group_Segment__c>  wkflProcssOldMap){
        try{
            map<string,Date> wfmap = New  map<string,Date>();
            
           
            for(GA_WF_Group_Segment__c wfgs : wkflProcssNewMap.values()){
                String  ownrRole = wfgs.GA_OwnerRole__c; 
              
                if(!wfgs.GA_Return_to_Step_Chk__c && String.isNotBlank(ownrRole)   &&  ( (ownrRole.contains(GrpAdmin) || ownrRole.contains(GrpAdminMgr)) && !ownrRole.endsWithIgnoreCase(GAQltyAnlyst) ) )
                    wfmap.put(wfgs.GA_Workflow_ID__c+'-'+GrpAdmin,wfgs.GA_Date_Opened__c.date());
                 if(!wfgs.GA_Return_to_Step_Chk__c && String.isNotBlank(ownrRole)   &&  ( ownrRole.endsWithIgnoreCase(GAQltyAnlyst) ) )
                    wfmap.put(wfgs.GA_Workflow_ID__c+'-'+GAQltyAnlyst,wfgs.GA_Date_Opened__c.date());
                 if(!wfgs.GA_Return_to_Step_Chk__c && String.isNotBlank(ownrRole)   &&  ownrRole.contains(rateCntrl) ) 
                    wfmap.put(wfgs.GA_Workflow_ID__c+'-'+rateCntrl,wfgs.GA_Date_Opened__c.date());   
                 if(!wfgs.GA_Return_to_Step_Chk__c && String.isNotBlank(ownrRole)   &&  ownrRole.contains(bcnGmt) ) 
                    wfmap.put(wfgs.GA_Workflow_ID__c+'-'+bcnGmt,wfgs.GA_Date_Opened__c.date());
                 if(!wfgs.GA_Return_to_Step_Chk__c && String.isNotBlank(ownrRole)   &&  ownrRole.contains(bcnUndrwrtr) ) 
                    wfmap.put(wfgs.GA_Workflow_ID__c+'-'+bcnUndrwrtr,wfgs.GA_Date_Opened__c.date());
                if(!wfgs.GA_Return_to_Step_Chk__c && String.isNotBlank(ownrRole)   &&  ownrRole.contains(smllGrp) ) 
                    wfmap.put(wfgs.GA_Workflow_ID__c+'-'+smllGrp,wfgs.GA_Date_Opened__c.date());
                if(!wfgs.GA_Return_to_Step_Chk__c && String.isNotBlank(ownrRole)   && ( ownrRole.contains(pcs) ||  ownrRole.contains(wm) ||  ownrRole.equalsIgnoreCase(supprt) || ownrRole.contains(salesSpprt) ) ) 
                    wfmap.put(wfgs.GA_Workflow_ID__c+'-'+salesSpprt,wfgs.GA_Date_Opened__c.date());
                    
            }
            
            system.debug('wfmap*** '+wfmap);
            set<id> wrkflowIds=new set<id>();
            if(!wfmap.isEmpty()){
                for(string wfVal:wfmap.keySet())
                {
                    wrkflowIds.add(wfVal.split('-')[0]);
                }
                List<GA_WF_Workflow__c> wfList=GA_Util03_WrkflwDataAccessHelper.fetchwrkflowMap('Select id,GA_Received_Date__c,GA_Rate_Control_Received_Date__c,GA_BCN_GMT_Received_Date__c,GA_BCN_Underwriting_Received_Date__c, GA_SG_Underwriting_Received_Date__c,GA_QA_Received_Date__c,GA_Sales_Support_Received_Date__c from GA_WF_Workflow__c', 
                                                                                                ' where id in '+GA_Util08_FilterProcessHelper.idSet(wrkflowIds) 
                                                                                                + ' and (GA_Received_Date__c = null or GA_Rate_Control_Received_Date__c = null or 	GA_QA_Received_Date__c = null ' 
                                                                                                +' or GA_BCN_GMT_Received_Date__c = null or GA_SG_Underwriting_Received_Date__c = null or GA_BCN_Underwriting_Received_Date__c = null or 	GA_Sales_Support_Received_Date__c = null)',
                                                                                                '',
                                                                                                ' limit 2000').values();
                List<GA_WF_Workflow__c> updtWrkFlwLst =  New  List<GA_WF_Workflow__c>();
                for(GA_WF_Workflow__c wrkFlw : wfList){
                  
                    //if(wfmap.keyset().contains(wrkFlw.id))
                    {
                        GA_WF_Workflow__c updtWrkFlw = New GA_WF_Workflow__c();
                       // updtWrkFlw.Id=wrkFlw.Id;
                        if(wfmap.get(wrkFlw.id+'-'+GrpAdmin) !=null && wrkFlw.GA_Received_Date__c == null)
                        {
                                updtWrkFlw.Id=wrkFlw.Id;
                            updtWrkFlw.GA_Received_Date__c =wfmap.get(wrkFlw.id+'-'+GrpAdmin);
                             updtWrkFlwLst.add(updtWrkFlw); 
                        }
                        
                        if(wfmap.get(wrkFlw.id+'-'+GAQltyAnlyst) !=null && wrkFlw.GA_QA_Received_Date__c == null)
                        {
                            updtWrkFlw.Id=wrkFlw.Id;
                            updtWrkFlw.GA_QA_Received_Date__c =wfmap.get(wrkFlw.id+'-'+GAQltyAnlyst);
                            updtWrkFlwLst.add(updtWrkFlw); 
                        }
                        if(wfmap.get(wrkFlw.id+'-'+rateCntrl) !=null && wrkFlw.GA_Rate_Control_Received_Date__c == null)
                        {
                                updtWrkFlw.Id=wrkFlw.Id;
                            updtWrkFlw.GA_Rate_Control_Received_Date__c =wfmap.get(wrkFlw.id+'-'+rateCntrl);
                             updtWrkFlwLst.add(updtWrkFlw); 
                        }
                        if(wfmap.get(wrkFlw.id+'-'+bcnGmt) !=null && wrkFlw.GA_BCN_GMT_Received_Date__c == null)
                        {
                                updtWrkFlw.Id=wrkFlw.Id;
                            updtWrkFlw.GA_BCN_GMT_Received_Date__c =wfmap.get(wrkFlw.id+'-'+bcnGmt);
                             updtWrkFlwLst.add(updtWrkFlw); 
                        }
                        if(wfmap.get(wrkFlw.id+'-'+bcnUndrwrtr) !=null && wrkFlw.GA_BCN_Underwriting_Received_Date__c == null)
                        {
                                updtWrkFlw.Id=wrkFlw.Id;
                            updtWrkFlw.GA_BCN_Underwriting_Received_Date__c =wfmap.get(wrkFlw.id+'-'+bcnUndrwrtr);
                             updtWrkFlwLst.add(updtWrkFlw); 
                        }
                        if(wfmap.get(wrkFlw.id+'-'+smllGrp) !=null && wrkFlw.GA_SG_Underwriting_Received_Date__c == null)
                        {
                                updtWrkFlw.Id=wrkFlw.Id;
                            updtWrkFlw.GA_SG_Underwriting_Received_Date__c =wfmap.get(wrkFlw.id+'-'+smllGrp);
                             updtWrkFlwLst.add(updtWrkFlw); 
                        }
                        if(wfmap.get(wrkFlw.id+'-'+salesSpprt) !=null && wrkFlw.GA_Sales_Support_Received_Date__c == null)
                        {
                                updtWrkFlw.Id=wrkFlw.Id;
                            updtWrkFlw.GA_Sales_Support_Received_Date__c =wfmap.get(wrkFlw.id+'-'+salesSpprt);
                             updtWrkFlwLst.add(updtWrkFlw); 
                        }
                        
                     }
                    
                }
                
               
                if(updtWrkFlwLst.size() > 0)
                    database.update(updtWrkFlwLst);
            }
            
            
            
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
        }
    }
    
   
    /**
@Description: updteOwnrMngrEml() method 
@Name : updteOwnrMngrEml
@Param : list<GA_WF_Group_Segment__c> wfGsLst    
@Return : void
@throws Exception : N/A;
*/ 
    public static void updteOwnrMngrEml(list<GA_WF_Group_Segment__c> wfGsLst)
    {  
        try{
            for(GA_WF_Group_Segment__c wfGs:wfGsLst)
            {
                wfGs.GA_Owners_Mngr_Email__c=wfGs.GA_Owners_Manager__c;
                wfGs.GA_Owner_Mngrs_Mngr_Email__c=wfGs.GA_Owner_Managers_Manager__c  ;
            }
        } catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme5);
        }
    }
}