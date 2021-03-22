/**
@Author : IDC offshore
@Name: GA_GS_AP04_UpdtStatus
@CreatedDate: 26 - Oct 2018 
@Description: GA_GS_AP04_UpdtStatus class is to update group segment status to cancel and active 
and flip GS related accnt record type to Prospect on customer
@version : 1.0  
*/
public with sharing class GA_GS_AP04_UpdtStatus {
    public static final String ClsName  = 'GA_GS_AP04_UpdtStatus';
    public static boolean isExecuting=false; 
    public static boolean isInvoked = false;
    public static boolean isCnclGSChkd = false;
    public static final String methodNmeupdtActivStatusGS  = 'updtActivStatusGS' ;
    public static final String methodNmeupdtCnclStatusGS  = 'updtCnclStatusGS' ;
    public static final String methodNmeupdtRcrdType = 'updtRecTypeAcc' ;
    public static final String methodNmeupdtCnclGSBfr = 'updtCnclStatusGSBfre';
    public static final String  nullifyTPBtoGS = 'nullifyTPBtoGS';
    public static final String  updtTPBtoGS= 'updtTPBtoGS';
    public static final String  updateEndDateTPB = 'updateEndDateTPB';
    public static final string acctcustRecordTyp =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
    public static final string acctPrspctRecordType =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
    public static List<ID> tpLst = new List<ID>();
    public static map<id,id> grpthridprtyMap=new map<id,id>();
    public static final String  actv='Active';
    public static final String  cancl='Canceled';
    public static final String pendng =  'Pending';
    public static final String  accntCst= 'Account_Customer';
    public static final String  excpDescp='Account related to Group Segment - ';
    public static final String  excpDescp1= ' is Inactive';
    public static final String  excpCode='EX-ACCTINACTIVE';
    public static final integer occurence = 1;
    public static final String  excpDtls= 'Account related to inserted/Updated Group Segment -';
    public static final String  excpDtls1=' is inactive.We cannot update the status';
    public static final String  excpSvrty='ERROR';
    public static final String  cncled= 'Canceled';
    public static final String  inactv= 'Inactive';
    public static final Date futrEndDateAssign = Date.newInstance(2099, 12, 31);
    public static  List<Id> cnclgsList = new List<Id>();
    public static final string profIntUser='Integration User';
    public static final string bcnNtwrk='BCN';
    
    
    /*******************************************************************************************************************************
@Description    :   updtActivStatusGS
@Name         :   updtActivStatusGS
@Param         :   List<GA_Group_Segment__c> gsList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void updtActivStatusGS(List<GA_Group_Segment__c> gsList)
    {
        try{
            Date futrEndDate;
            map<id,integer> gsWFPrcsOpn=new map<id,integer>();
            list<id> gsIdsToprcss=new list<id>();
            String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
            for(GA_Group_Segment__c objGS : gsList){
                
                if(objGS.Status__c==pendng ){
                    gsIdsToprcss.add(objGS.Id);
                }
            }
            
            Map<id,boolean> wfGSMap = new Map<id,boolean>(); // D1691
            list<aggregateResult> wfPrcssLst=[select GA_Group_Segment_ID__c,count(Id) OpenGS from GA_WF_Group_Segment__c where GA_Group_Segment_ID__c in:gsIdsToprcss 
                                              and (GA_Status__c='Closed') and GA_Workflow_Next_Step__c=null and GA_WF_Step_ID__c !=null and GA_Type__c != 'ABR'  group by GA_Group_Segment_ID__c  limit 2000];
            for(aggregateResult agRst:wfPrcssLst)
            {
                 wfGSMap.put(string.valueof(agRst.get('GA_Group_Segment_ID__c')),false); // D1691
                gsWFPrcsOpn.put(string.valueof(agRst.get('GA_Group_Segment_ID__c')),integer.valueof(agRst.get('OpenGS')));   
            }
            
            // Start D1691
            for(GA_WF_Group_Segment__c wfGS : [select GA_Group_Segment_ID__c, GA_Status__c from GA_WF_Group_Segment__c where GA_Group_Segment_ID__c in:gsIdsToprcss and (GA_Status__c='Open') and GA_Workflow_Next_Step__c=null and GA_WF_Step_ID__c !=null and GA_Type__c != 'ABR' limit 2000]){
                                                   
                                                   if(!wfGSMap.containsKey(wfGS.GA_Group_Segment_ID__c)){
                                                       wfGSMap.put(wfGS.GA_Group_Segment_ID__c,true);
                                                   }
                                               }
            // End D1691
            
            for(GA_Group_Segment__c objGS : gsList){
                if(objGS.GA_Group_Effective_Date__c<=system.today() && 
                   objGS.GA_Cancellation_Date__c==null){
                       futrEndDate = futrEndDateAssign;
                   }
                else{
                    futrEndDate = objGS.GA_Cancellation_Date__c;
                }
                if(objGS.Status__c==pendng  && objGS.Network__c==bcnNtwrk && !wfGSMap.get(objGS.Id)){
                    if(gsWFPrcsOpn.get(objGS.Id)>0)
                        objGS.Status__c=actv;
                }
                if(objGS.Status__c==pendng  && (objGS.GA_Transaction_Posted__c || objGS.GA_Post_Transaction__c)  && !wfGSMap.get(objGS.Id)){
                    if(gsWFPrcsOpn.get(objGS.Id)>0)
                        objGS.Status__c=actv;
                }  
                if(profileName==profIntUser){
                    if(objGS.Status__c==cncled && futrEndDate>system.today() && objGS.GA_Group_Effective_Date__c<=system.today())
                    {
                        objGS.Status__c=actv;
                    }   
                }  
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdtActivStatusGS);
        }  
        
    }
    /*******************************************************************************************************************************
@Description    :   updtRecTypeAcc
@Name         :   updtRecTypeAcc
@Param         :   List<GA_Group_Segment__c> gsList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    public static void updtRecTypeAcc(List<GA_Group_Segment__c> gSList)
    {
        try{
            set<id> accIds=new set<id>();
            Date gsfutrEndDate;
            boolean isChnge=false;
            String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
            Map<Id, Date> gsAccMap = new Map<Id, Date>();
            for(GA_Group_Segment__c objGS : gSList){
                gsAccMap.put(objGS.GA_Account__c,objGS.GA_Group_Effective_Date__c);
                if(objGS.Status__c==actv && objGS.Network__c==bcnNtwrk)
                {
                    accIds.add(objGS.GA_Account__c);
                }
                if(objGS.Status__c==actv && (objGS.GA_Transaction_Posted__c || objGS.GA_Post_Transaction__c))
                {
                    accIds.add(objGS.GA_Account__c);
                }
                
                if(profileName==profIntUser){
                    if(objGS.Status__c==cncled && gsfutrEndDate>system.today() && objGS.GA_Group_Effective_Date__c<=system.today())
                    {
                        accIds.add(objGS.GA_Account__c);
                    }
                }
                
            } 
            List<Account>  accLst =[Select id,RecordType.DeveloperName from Account WHERE ID IN :accIds Limit 50000] ;
            List<Account>  updtAccLst = New   List<Account>();
            
            if(!accIds.isEmpty()){
                for(Account objAcc : accLst){
                    if(objAcc.RecordType.DeveloperName != accntCst){
                        objAcc.RecordTypeId = acctcustRecordTyp;
                        objAcc.Account_Status__c=actv;
                        objAcc.GA_CoverageCancellationDate__c=null;
                        objAcc.GA_Is_Mass_Updating__c=true;
                        objAcc.GA_Current_Enrollment_Date__c = gsAccMap.get(objAcc.Id);
                        updtAccLst.add(objAcc);
                    }
                }
            }  
            
            if(!updtAccLst.isEmpty()){
                Database.update(updtAccLst);
            }
            isInvoked= true; 
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdtRcrdType);
            
        }  
    }
    /*******************************************************************************************************************************
@Description    :   updtCnclStatusGSBfre
@Name         :   updtCnclStatusGSBfre
@Param         :   List<GA_Group_Segment__c> grpsgList,map<id,GA_Group_Segment__c> grpsgOldmp
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    public static void updtCnclStatusGSBfre(List<GA_Group_Segment__c> grpsgList,map<id,GA_Group_Segment__c> grpsgOldmp)
    {
        
        try{
            for(GA_Group_Segment__c grp:grpsgList)
            {
                boolean CnclChk=false;
                boolean CnclDteChk=false;
                if(grpsgOldmp!=null)
                {
                    GA_Group_Segment__c grpOld=grpsgOldmp.get(grp.Id);  
                    if(grp.GA_Cancellation_Date__c <> grpOld.GA_Cancellation_Date__c)
                        CnclChk=true;
                    if((grp.Status__c <> grpOld.Status__c) && grp.Status__c==cancl)
                    {
                        CnclDteChk=true;
                    }
                }
                else
                {
                    CnclChk=true;
                    if(grp.Status__c==cancl)
                    {
                        CnclDteChk=true; 
                    }
                }
                
                if(grp.GA_Cancellation_Date__c<=system.today() && CnclChk)
                {
                    grp.Status__c=cancl;
                    cnclgsList.add(grp.Id);
                    
                }
            }
            isCnclGSChkd = true;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdtCnclGSBfr);
            
        }  
    }
    /*******************************************************************************************************************************
@Description    :   updtCnclStatusGS
@Name         :   updtCnclStatusGS
@Param         :   List<GA_Group_Segment__c> grpsgList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    public static void updtCnclStatusGS(List<GA_Group_Segment__c> grpsgList,Map<ID,GA_Group_Segment__c> grpOldMap)
    {
        try{
            
            set<id> cnclAccIdsToPrcss=new set<id>();
            boolean isChnge=false;
            for(GA_Group_Segment__c grp:grpsgList)
            {
                if(grpOldMap !=null)
                {
                    GA_Group_Segment__c grpOld=grpOldMap.get(grp.Id);
                    if(grpOld.GA_Cancellation_Date__c !=grp.GA_Cancellation_Date__c || grpOld.Status__c !=grp.Status__c){
                           isChnge=true;     
                       }
                }
                
                else
                {
                    isChnge=true;
                }
                if(grp.GA_Cancellation_Date__c<=system.today() && isChnge)
                {
                    cnclAccIdsToPrcss.add(grp.GA_Account__c);
                    System.debug('cnclAccIdsToPrcss' + cnclAccIdsToPrcss);
                }
            }
            //Below logic is to update the Account Info for Prospects when the last Group Segment is Canceled.
            if(cnclAccIdsToPrcss.size() > 0){
                
                List<Account> accLst = [Select Id,Account_Status__c,RecordType.DeveloperName ,GA_CoverageCancellationDate__c,
                                        (select Status__c,GA_Cancellation_Date__c from Group_Segments__r ORDER BY LastModifiedDate ASC)
                                        from Account where id in:cnclAccIdsToPrcss Limit 50000];
                List<Account>  acntIdsToPrcs = new List<Account>();
                List<Account>  finalacntIdsToPrcs = new List<Account>();
                Set<Id> processAccIds = New Set<Id>();
                boolean flag = false;
                Set<Id> accActv = New Set<Id> ();
                
                for(Account objAcc :accLst){
                    
                    if(!objAcc.Group_Segments__r.isEmpty()){
                        for(GA_Group_Segment__c objGS : objAcc.Group_Segments__r){
                            system.debug('Line 275' + objGS);
                            system.debug('Line 275 v2' + objAcc.Group_Segments__r);
                            if(objGS.Status__c.equals(actv)/* || objGS.Status__c.equals(pendng)*/){
                                system.debug('Line 279' + objGS.Status__c.equals(actv));
                                flag = true;   
                                accActv.add(objAcc.id);
                                break;
                            }
                            else{
                                if(cnclgsList.contains(objGS.Id) && !processAccIds.contains(objAcc.id) ){
                                    objAcc.GA_CoverageCancellationDate__c=objGS.GA_Cancellation_Date__c;
                                    objAcc.RecordTypeId =acctPrspctRecordType;
                                    objAcc.Account_Status__c=inactv;
                                    objAcc.GA_Is_Mass_Updating__c=true;
                                    //objAcc.GA_Current_Enrollment_Date__c=null;
                                    system.debug('Line 296' + ObjAcc.GA_CoverageCancellationDate__c);
                                    system.debug('Line 297' + ObjAcc.RecordTypeId);
                                    acntIdsToPrcs.add(objAcc); 
                                    processAccIds.add(objAcc.id);
                                }
                            }
                        }
                    }
                } 
                
                //Remove accounts from processing list if they have atleast one active GS 
                if(accActv.size() > 0){
                    processAccIds.removeAll(accActv);
                }
                
                // preparing final list for processing
                for(Account accCus : acntIdsToPrcs){
                    if(processAccIds.contains(accCus.id)){
                        finalacntIdsToPrcs.add(accCus);
                    }
                }
                
                if(finalacntIdsToPrcs.size()>0 ){
                    
                    Database.update(acntIdsToPrcs);
                }
                
            }
            
            isExecuting=true;
            
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdtCnclStatusGS);
        }
    }
    /*******************************************************************************************************************************
@Description    :   updateEndDateTPB
@Name         :   updateEndDateTPB
@Param         :   None
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updateEndDateTPB(List<GA_Group_Segment__c> grpsgList,map<id,GA_Group_Segment__c> grpsgOldmp){
        try{
            List<id> gsIdLst = new List<id>();
            List<GA_Third_Party_Biller_History__c> tPBList = new List<GA_Third_Party_Biller_History__c>(); 
            for(GA_Group_Segment__c grp:grpsgList)
            {
                if(grpsgOldmp!=null)
                {
                    GA_Group_Segment__c grpOld=grpsgOldmp.get(grp.Id);
                    
                    if(grp.GA_Third_Party_Biller_History__c <> grpOld.GA_Third_Party_Biller_History__c){
                        gsIdLst.add(grpOld.GA_Third_Party_Biller_History__c);
                        
                    }
                } 
            }
            if(!gsIdLst.isEmpty()){
                for(GA_Third_Party_Biller_History__c tp : [select id,GA_TPB_End_Date__c,GA_TPB_Start_Date__c from GA_Third_Party_Biller_History__c where ID IN : gsIdLst Limit 50000]){
                                                               tp.GA_TPB_End_Date__c = system.today()-1;
                                                               tPBList.add(tp);                                                      
                                                           }
                Database.update(tPBList);
            }
        }   
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, updateEndDateTPB);
        }
    }
}