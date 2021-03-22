/**
@Author : Dilip
@Name: GA_CAS_MassUpdateController
@CreatedDate: 19 - June 2018 
@Description: GA_CAS_MassUpdateController class is for mass updation of case fields.
@version : 1.0  
*/ 
public without Sharing class GA_CAS_MassUpdateController {
    public static final string casQuery='select id, caseNumber, GA_Quote_ID__c, AccountId,status,GA_System_of_Record__c from Case ';
    public static final string casWhere='where AccountId in'; 
    public static final string casWhere2=' and id !=';
    public static final string casWhere3=' and Status !=';
    public static final string casWhere4=' and recordtypeid =';
    public static final Id WmSupportReqId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Support / West Michigan').getRecordTypeId();
    public static final string casStatus='Closed';
    public static final string casOrdrBy='order by createddate desc';
    public static final string casLstLimit=' Limit 800';
    public static final string casLstLimit1=' Limit 1';
    public static final string ClsName='GA_GS_MassUpdateController';
    public static final string methodNmeLst='gSgmtLst';
    public static final string casErrMsg='Unable to fetch Support Requests';
    public static final string methodPrcsng='processSelectedRecords';
    public static final string PrcsngErrMsg='Unable to process';
    public static final string smartStr = 'SMART';
    public static final string insuffPrv = 'Insufficient privilege';
    public static final string NoSR = 'No Support Requests';
    public static final string NoQuoteId =  'No Quote ID';
    public static final string whereId =  '  where  id =';
    
    /**
@Description: caseLst() method 
@Name : caseLst
@Param : string accId, string currentId  
@Return : List
@throws Exception : N/A;
*/   
    @AuraEnabled     
    public static List<caseWrapper> caseLst(string accId, string currentId) {
        List<caseWrapper> gSWrperLst =  New List<caseWrapper> ();
        List<Case> cLst = New List<Case>();
        try{
            GA_Mass_Update_Access__c mssUpdtAccess =  GA_Mass_Update_Access__c.getInstance();
            if(mssUpdtAccess.Access__c){
                set<id> CurIdSet=new set<id>();
                CurIdSet.add(accId);
                String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);
                Map<Id,Case> csMap  = GA_Util19_CaseDataAccessHelper.fetchCaseMap(casQuery, casWhere + ActIdString  + casWhere3 + GA_Util08_FilterProcessHelper.FltrString(casStatus) +
                                                                                  casWhere4 + GA_Util08_FilterProcessHelper.FltrString(WmSupportReqId), casOrdrBy, casLstLimit);
                
                if(csMap.containsKey(currentId)){
                    Case currRec =  csMap.get(currentId);
                    if(currRec.GA_System_of_Record__c == smartStr){
                        caseWrapper obj = new caseWrapper();
                        obj.csId = insuffPrv;
                        
                        List<caseWrapper> Wrplst =  New List<caseWrapper> ();
                        Wrplst.add(obj);
                        return Wrplst;   
                    }
                    
                    if(String.isEmpty(currRec.GA_Quote_ID__c)  ){
                        caseWrapper obj = new caseWrapper();
                        obj.csId = NoQuoteId;
                        
                        List<caseWrapper> Wrplst =  New List<caseWrapper> ();
                        Wrplst.add(obj);
                        return Wrplst;  
                    }
                    csMap.remove(currentId); 
                    
                    for(Case cs : csMap.values()){
                        
                        caseWrapper obj = new caseWrapper();
                        obj.csId = cs.id;
                        obj.Num = cs.CaseNumber;
                        obj.isSelected = true;
                        obj.csSts = cs.Status; 
                        gSWrperLst.add(obj);
                    } 
                }
                
                if(gSWrperLst.size() == 0){
                    caseWrapper obj = new caseWrapper();
                    obj.csId = NoSR;
                    gSWrperLst.add(obj);
                }
            }
            else{
                caseWrapper obj = new caseWrapper();
                obj.csId = insuffPrv;
                gSWrperLst.add(obj);
            }
            return gSWrperLst;  
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeLst);
            throw new AuraHandledException(casErrMsg);
        }
    }
    /**
@Description: processSelectedRecords() method 
@Name : processSelectedRecords
@Param : string caseRecords,String currentCase  
@Return : N/A
@throws Exception : N/A;
*/     
    @AuraEnabled
    Public static void processSelectedRecords(string caseRecords,String currentCase){
        
        try{
            List<caseWrapper> cSList = new  List<caseWrapper>();
            List<Case> cLst = GA_Util19_CaseDataAccessHelper.fetchCaseMap(casQuery, whereId +GA_Util08_FilterProcessHelper.FltrString(currentCase), casOrdrBy, casLstLimit1).values();
            List<Case> uptCsLst = New   List<Case> ();
            
            if(!string.isBlank(caseRecords)){
                cSList = (List<caseWrapper>)System.JSON.deserialize(caseRecords,List<caseWrapper>.class);
                for(caseWrapper cw :cSList ){
                    Case  cs = New Case();
                    cs.id = cw.csId;
                    cs.GA_Quote_ID__c = cLst[0].GA_Quote_ID__c;
                    cs.GA_Is_Mass_Updating__c = true;
                    uptCsLst.add(cs); 
                }
                if(!uptCsLst.isEmpty()){
                    Database.update(uptCsLst, false);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodPrcsng);
            throw new AuraHandledException(PrcsngErrMsg);
        }
    }
    /**
@Description: caseWrapper wrapper
@Name : caseWrapper
@Param : N/A 
@Return : N/A
@throws Exception : N/A;
*/    
    public without sharing class caseWrapper{
        @AuraEnabled
        public String csId {get;set;}
        @AuraEnabled
        public String Num {get;set;}
        @AuraEnabled
        public boolean isSelected {get;set;}
        @AuraEnabled
        public String csSts {get;set;}
    }
}