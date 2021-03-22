/**
@Author : Rohith Adulla
@Name: GA_GroupSegmentRelation_RecList
@CreatedDate: 17 - May 2018 
@Description: GA_GroupSegmentRelation_RecList class is viewing and creating Group Segment Relationship related list in Case record page.
@version : 1.0  
*/
public with sharing class GA_GroupSegmentRelation_RecList {
    public static final string ACTPLANERRMSG  = 'Group Segments not retrived :';
    public static final string CLSNAME   ='GA_GroupSegmentRelation_RecList';
    public static final string METHODNAMEGRPLST  ='grpSegRelLst';
    public static final string METHODNAMEGRPREC  ='grpSegRec';
    public static final string METHODGETCHID  ='getChildren';
    public static final string METHODDLTACC  = 'deleteAccss';
    public static final string METHODEDITACC = 'editAccss';
    public static final string METHODCRTACC = 'createAccss';
    public static final string METHODADDPRNT  ='addGroupSegmentRelation';
    public static final string METHODDELDATA  ='deleteData';
    public static final string EXCPSPRTR=': ';
    public static final string ACTIVESTS='Active';
    public static final boolean CRTACCSS=GS_Rlshp_Create_Access__c.getInstance().GA_By_Pass__c;
    public static final string SYSADMINPROFILE = 'System Administrator';
    public static final string WMSUPPRTPROFILE = 'West Michigan Support';
    public static final string PCSWMSUPPPROFILE = 'PCS - West Michigan Support';
    public static final string SALESOPPROFILE = 'Sales Operations';
    public static final string SUPPROFILE = 'Support';
    public static final string SUPPRTSNRANLYSTPROF = 'Support Senior Analyst';
    public static final string profileNmePCSSupp = 'PCS - Support';
    public static final string SMRTRECD = 'SMART';
    public static final string errMsg = 'Unable to delete auth: ';
    public static final string SuppRectypeNm = 'Support - Request';
    public static final string SuppWMRectypeNm = 'Support - Support / West Michigan';  
    public static final string StatusCancelled = 'Canceled'; // US 3548
    public static final Id SuppRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(SuppRectypeNm).getRecordTypeId();
    public static final Id SuppWMRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(SuppWMRectypeNm).getRecordTypeId();
    /**Class to throw exception*/
    public with sharing class ValidateException extends Exception {}
    /**
@Description: grpSegRelLst() method 
@Name : grpSegRelLst
@Param : string currentId
@Return : List<GA_Support_Request__c>
@throws Exception : ValidateException;
*/ 
    @AuraEnabled
    public static List<GA_Group_Support_Request__c> grpSegRelLst(String currentId) {
        List<GA_Group_Support_Request__c> grpgslst =  New List<GA_Group_Support_Request__c> ();
        try{
            if(String.isNotBlank(currentId) && String.isNotEmpty(currentId)){
                grpgslst = [SELECT id,Name,GA_Support_Request__c,GA_Record_Url__c FROM GA_Group_Support_Request__c WHERE GA_Support_Request__c =: currentId limit 4];
            }
            return grpgslst;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAMEGRPLST);
            throw new AuraHandledException(ACTPLANERRMSG);
        }
        
    }
    /**
@Description: grpSegRec() method 
@Name : grpSegRec
@Param : string currentId
@Return : GA_Support_Request__c
@throws Exception : ValidateException;
*/
    @AuraEnabled
    public static List<Case> getStatus(String recordId){
        //system.debug('recordId: '+recordId);
        List<Case> newCase = [SELECT Id,Status FROM Case WHERE Id =:recordId];
        //system.debug('newCase: '+newCase);
        return newCase;
    }
    
    @AuraEnabled
    public static List<GA_Group_Segment__c> grpSegRec(String currentId) {
        Integer count = 0;
        //total list of active group segments related to the account related to the case
        List<GA_Group_Segment__c> totalList = new List<GA_Group_Segment__c>();
        try{
            if(String.isNotBlank(currentId) && String.isNotEmpty(currentId)){
                Case updtCs = new Case();
                updtCs=[SELECT id,AccountId FROM Case where id =:currentId limit 100];
                if(updtCs.AccountId != NULL){
                    totalList=[SELECT id,name,GA_Account__c,GA_Carrier__c,Status__c FROM GA_Group_Segment__c 
                               WHERE GA_Account__c =: updtCs.AccountId limit 100];
                }
            }
            return totalList;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAMEGRPREC);
            throw new AuraHandledException(ACTPLANERRMSG);
        }
    }
    
    /**
@Description: getChildren() method 
@Name : getChildren
@Param : string currentId
@Return : GA_Support_Request__c
@throws Exception : ValidateException;
*/
    @AuraEnabled
    public static List<GA_Group_Segment__c> getChildren(String recordId,Boolean isDisabled) {
        List<GA_Group_Segment__c> totalList = new List<GA_Group_Segment__c>();
        List<GA_Group_Segment__c> lstgs = new List<GA_Group_Segment__c>();
        //try{
            Integer count = 0;
            Case updtCs = new Case();
            if(String.isNotBlank(recordId) && String.isNotEmpty(recordId)){
                updtCs=[SELECT id,AccountId FROM Case where id =:recordId limit 100];
                if(updtCs.AccountId != NULL){
                    //total list of group segments that dont have a relation with the case
                    totalList=[SELECT id,name,GA_Account__c,GA_Carrier__c,Status__c FROM GA_Group_Segment__c 
                               WHERE GA_Account__c =: updtCs.AccountId AND Status__c !=: StatusCancelled ORDER BY Name ASC]; 
                }
                //list of Group segment Relationships related to the case
                List<GA_Group_Support_Request__c> lstgrpsegrel = new List<GA_Group_Support_Request__c>();
                if(updtCs!=null){
                    lstgrpsegrel = [SELECT GA_Group_Segment__c FROM GA_Group_Support_Request__c
                                    WHERE GA_Support_Request__c=:updtCs.Id ORDER BY GA_Group_Segment_Name__c ASC];
                }
                if(totalList.size()>0){
                    for(Integer i=0;i<totalList.size();i++){
                        for(Integer j=0;j<lstgrpsegrel.size();j++){
                            if(lstgrpsegrel[j].GA_Group_Segment__c == totalList[i].id) 
                            {
                                count++;
                            }
                        }
                        if(count==0){
                            lstgs.add(totalList[i]);
                        }
                        count=0;
                    }
                }
            }
            
        /*}
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODGETCHID); 
        }*/
        return lstgs;
    }
    
    /** US 3548
@Description: getChildren() method 
@Name : getChildren
@Param : string currentId
@Return : GA_Support_Request__c
@throws Exception : ValidateException;
*/
    @AuraEnabled
    public static List<GA_Group_Segment__c> sortChildren(String recordId,boolean isAsc) {
        List<GA_Group_Segment__c> totalList = new List<GA_Group_Segment__c>();
        List<GA_Group_Segment__c> lstgs = new List<GA_Group_Segment__c>();
        String GSSoql = 'SELECT ID, Name, GA_Account__c, GA_Carrier__c, Status__c FROM GA_Group_Segment__c WHERE Status__c !=: StatusCancelled';
        String supReqSoql = 'SELECT GA_Group_Segment__c FROM GA_Group_Support_Request__c ';
        try {
            Integer count = 0;
            Case updtCs = new Case();
            if(String.isNotBlank(recordId) && String.isNotEmpty(recordId)){
                updtCs=[SELECT id,AccountId FROM Case where id =:recordId limit 100];
                if(updtCs.AccountId != NULL){
                    GSSoql += ' AND GA_Account__c =\''+updtCs.AccountId +'\' ORDER BY Name ';
                    // if isAsc is equal to ture then set 'asc' order otherwise set 'desc' order.
                    if (isAsc) {
                        GSSoql += 'ASC ';
                    } else {
                        GSSoql += 'DESC ';
                    }
                    //total list of group segments that dont have a relation with the case
                    system.debug('GSSoql: '+GSSoql);
                    totalList= database.query(GSSoql);
                    system.debug('totalList: '+totalList);
                }
                //list of Group segment Relationships related to the case
                List<GA_Group_Support_Request__c> lstgrpsegrel = new List<GA_Group_Support_Request__c>();
                if(updtCs!=null){
                    supReqSoql += 'WHERE GA_Support_Request__c =\''+updtCs.Id +'\' ORDER BY GA_Group_Segment_Name__c ';
                    // if isAsc is equal to ture then set 'asc' order otherwise set 'desc' order.
                    if (isAsc) {
                        supReqSoql += 'ASC ';
                    } else {
                        supReqSoql += 'DESC ';
                    }
                    system.debug('supReqSoql: '+supReqSoql);
                    lstgrpsegrel = database.query(supReqSoql);
                    system.debug('lstgrpsegrel: '+lstgrpsegrel);
                }
                if(totalList.size()>0){
                    for(Integer i=0;i<totalList.size();i++){
                        for(Integer j=0;j<lstgrpsegrel.size();j++){
                            if(lstgrpsegrel[j].GA_Group_Segment__c == totalList[i].id){
                                count++;
                            }
                        }
                        if(count==0){
                            lstgs.add(totalList[i]);
                        }
                        count=0;
                    }
                }
            }
        } 
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODGETCHID); 
        }
        return lstgs;
    } 
    /**
@Description: deleteAccss() method 
@Name : deleteAccss
@Param : N/A
@Return : boolean
@throws Exception : ValidateException;
*/    
    @AuraEnabled
    public static boolean deleteAccss() {
        try{
            if(Schema.sObjectType.GA_Group_Support_Request__c.isDeletable())
            {
                return true;
            }
            return false;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODDLTACC); 
            throw new AuraHandledException(ACTPLANERRMSG);
        }
    }
    
    /**
@Description: editAccss() method 
@Name : editAccss
@Param : N/A
@Return : boolean
@throws Exception : ValidateException;
*/    
    @AuraEnabled
    public static boolean editAccss(string suppId) {
        try{
            if(Schema.sObjectType.GA_Group_Support_Request__c.isUpdateable())
            {
                case cse=[select id,GA_System_of_Record__c,recordTypeId from case where id=:suppId limit 1];
                string smartRec=cse.GA_System_of_Record__c;
                String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
                if(profileName== SYSADMINPROFILE)
                {
                    return true;  
                }
                if(smartRec!=SMRTRECD)
                {
                    if(((profileName==SUPPROFILE || profileName==SUPPRTSNRANLYSTPROF ||
                         profileName==WMSUPPRTPROFILE || profileName==profileNmePCSSupp || profileName==PCSWMSUPPPROFILE || 
                         profileName==SALESOPPROFILE) && cse.recordTypeId==SuppWMRecTypeId)
                       ||(cse.recordTypeId!=SuppWMRecTypeId)){
                           return true; 
                       }
                }
            }
            return false;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODEDITACC); 
            throw new AuraHandledException(ACTPLANERRMSG);
        }
    }
    /**
@Description: createAccss() method 
@Name : createAccss
@Param : N/A
@Return : boolean
@throws Exception : ValidateException;
*/        
    @AuraEnabled
    public static boolean createAccss(string suppId) {
        try{
            Boolean rtrnResp = false;
            if(CRTACCSS)
            {
                case cse=[select id,GA_System_of_Record__c,recordTypeId from case where id=:suppId limit 1];
                string smartRec=cse.GA_System_of_Record__c;
                String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
                if(profileName== SYSADMINPROFILE)
                {
                    rtrnResp = true;  
                }
                if(smartRec <> SMRTRECD)
                {
                    if(((profileName==SUPPROFILE || profileName==SUPPRTSNRANLYSTPROF 
                         || profileName==WMSUPPRTPROFILE || profileName==profileNmePCSSupp ||
                         profileName==PCSWMSUPPPROFILE || profileName==SALESOPPROFILE) && cse.recordTypeId==SuppWMRecTypeId)
                       ||(cse.recordTypeId!=SuppWMRecTypeId)){
                           rtrnResp =  true; 
                       }
                }
                
            }
            return rtrnResp;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODCRTACC); 
            throw new AuraHandledException(ACTPLANERRMSG);
        }
    }
    /**
@Description: deleteData() method 
@Name : deleteData
@Param : N/A
@Return : boolean
@throws Exception : ValidateException;
*/     
    @AuraEnabled
    public static void deleteData(String currentId) {
        try {
            if(String.isNotBlank(currentId) && String.isNotEmpty(currentId)){
                List<GA_Group_Support_Request__c> evG = [SELECT GA_Group_Segment__c FROM GA_Group_Support_Request__c WHERE id=:currentId limit 100];
                if(Schema.sObjectType.GA_Group_Support_Request__c.isDeletable()){
                    Database.delete(evG);}
            }
        } catch (Exception e) {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODDELDATA);
            throw new AuraHandledException(errMsg + e.getMessage());
        }
    }
    
    
    /**
@Description: addGroupSegmentRelation() method 
@Name : addGroupSegmentRelation
@Param : N/A
@Return : void
@throws Exception : ValidateException;
*/         
    @AuraEnabled
    public static void addGroupSegmentRelation(String recordId , List<String> lstOfGSIds){
        list<GA_Group_Support_Request__c> lstGrpSupReq = new list<GA_Group_Support_Request__c>();
        try{
            if(String.isNotBlank(recordId) && String.isNotEmpty(recordId) && !lstOfGSIds.isEmpty()){
                Case cas = [SELECT id,AccountId,CaseNumber FROM Case where id =:recordId limit 1];
                Map<id,GA_Group_Segment__c> gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name FROM GA_Group_Segment__c WHERE Id IN:lstOfGSIds limit 1500]);
                GA_Group_Support_Request__c oGS = New GA_Group_Support_Request__c();
                Case updtCase = New Case();
                GA_Group_Segment__c grpSgmnt = New GA_Group_Segment__c();
                for(string gSId : lstOfGSIds){
                    oGS = new GA_Group_Support_Request__c();
                    updtCase = new Case();
                    grpSgmnt = new GA_Group_Segment__c();
                    updtCase=cas;                    
                    grpSgmnt = gsMap.get(gSId);
                    oGS.Name = updtCase.CaseNumber + grpSgmnt.Name;
                    oGS.GA_Group_Segment__c = gSId;
                    oGS.GA_Support_Request__c = recordId;
                    oGS.GA_External_ID__c = oGS.Name;
                    oGS.GA_Is_Mass_Updating__c=True;
                    lstGrpSupReq.add(oGS);
                }
                upsert lstGrpSupReq GA_External_ID__c;                
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODADDPRNT); 
            throw new AuraHandledException(errMsg + e.getMessage());
        }
    }
    
    
    
    
    
    //New
    @AuraEnabled
    public static List<GA_Group_Segment__c> getChildrenViaRecord(String recordId,Boolean isDisabled) {
        List<GA_Group_Segment__c> finalGroupSegmentList = new List<GA_Group_Segment__c>();
        try{
            if(String.isNotBlank(recordId) && String.isNotEmpty(recordId)){
                List<GA_Group_Support_Request__c> GSList = new List<GA_Group_Support_Request__c>([SELECT Id,GA_Group_Segment__c FROM GA_Group_Support_Request__c WHERE GA_Support_Request__c =: recordId limit 100]);
                Set<Id> groupSegmentIds = new Set<Id>();
                for(integer i=0;i<GSList.size();i++){
                    groupSegmentIds.add(GSList[i].GA_Group_Segment__c);
                }
                finalGroupSegmentList = [SELECT Id,Name,GA_Account__c,GA_Carrier__c,Status__c FROM GA_Group_Segment__c WHERE Id IN: groupSegmentIds];
            }            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODGETCHID); 
        }
        return finalGroupSegmentList;
    }
    
    @AuraEnabled
    public static void removeGroupSegmentRelation(String recordId , List<String> lstOfGSIds){
        list<GA_Group_Support_Request__c> lstGrpSupReq = new list<GA_Group_Support_Request__c>();
        try{
            if(String.isNotBlank(recordId) && String.isNotEmpty(recordId) && !lstOfGSIds.isEmpty()){
                lstGrpSupReq = [SELECT Id,GA_Support_Request__c,GA_Group_Segment__c FROM GA_Group_Support_Request__c WHERE GA_Support_Request__c =:recordId AND GA_Group_Segment__c IN: lstOfGSIds];
                if(lstGrpSupReq.size()>0){
                    delete lstGrpSupReq;
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODADDPRNT); 
            throw new AuraHandledException(errMsg + e.getMessage());
        }
    }
}