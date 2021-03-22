/**
@Name: ARV_AP_CalculateCensuMemberRates
@CreatedDate: 6-June-2020
@Description:ARV_AP104_UpdateCensuMemberRates List views for contract.....
@version : 1.0 
*/
public class ARV_AP_CalculateCensuMemberRates {
    Public static final String PROCEDURE_NAME = 'UpdateContracts_Batch';
    public static final String ID1= 'Id';
    Public static final String MERGEDATA1='mergeData';
    private static final String CONTRACTTYPE='ContractType';
    private static final String MULTIPLE ='Multiple';
    private static final String SINGLE='Single';
    private static final String APEXJOBID='ApexJobId';
    private static final String MONTHNAME='April';
    private static  Integer countVar;
    private static final String PROFILENAME='Integration User';
    private static  List<string> finalMonths=new List<string>{'February','March','May'};
        /**
@Description: getUserId() method
@Name : getUserId
@Param : 
@Return : void
@throws Exception : N/A;
*/ 
        public static id getUserId(){
            Id profileId=[select id, Name from Profile where Name=:PROFILENAME].Id;
            return profileId;
        }
         /**
@Description: getListforContracts() method
@Name : getListforContracts
@Param : 
@Return : void
@throws Exception : N/A;
*/   
    public static void getListforContracts(){
        Id profileId=getUserId();
        List<Contract> contractList=[select Id,Name,vlocity_ins__FinalRatingGroupCensusId__c,Account.Renewal_Month__c from Contract where createdby.ProfileId =: profileId and vlocity_ins__FinalRatingGroupCensusId__c !=NULL and  vlocity_ins__QuoteId__c=null  order by contractNumber];
        map<String,Object> tempMap = new map<String,Object>();
        List<map<String,Object>> finalContractIds = new List<map<String,Object>>(); 
        for(Contract cId:contractList){
            tempMap = new Map<String,Object>();
            tempMap.put(ID1, cId.Id);
            finalContractIds.add(tempMap);
        } 
        if(finalContractIds.size()>0){
       multipleThreadForRates(finalContractIds);
        }
    }
    /**
@Description: multipleThreadForRates() method
@Name : multipleThreadForRates
@Param : 
@Return : void
@throws Exception : N/A;
*/    
    public static void multipleThreadForRates(List<map<String,Object>> finalContractIds){
         List<map<String,Object>> finalContractIds1 = new List<map<String,Object>>();   
        List<map<String,Object>> finalContractIds2 = new List<map<String,Object>>();   
        List<map<String,Object>> finalContractIds3 = new List<map<String,Object>>();   
        List<map<String,Object>> finalContractIds4 = new List<map<String,Object>>();   
        List<map<String,Object>> finalContractIds5 = new List<map<String,Object>>();   
        if(finalContractIds.size()>0){
            integer splitsize =(finalContractIds.size()/5);
            for(integer i=0;i<finalContractIds.size();i++){
                if(i<=splitsize-1){
                    finalContractIds1.add(finalContractIds[i]);	
                }
                else if(i>splitsize-1 && i<=2*splitsize-1 ){
                    finalContractIds2.add(finalContractIds[i]);  
                }
                else if(i>2*splitsize-1 && i<=3*splitsize-1){
                    finalContractIds3.add(finalContractIds[i]); 
                }
                else if(i>3*splitsize-1 && i<=4*splitsize-1){
                    finalContractIds4.add(finalContractIds[i]);
                }
                else if(i>=4*splitsize-1){
                    finalContractIds5.add(finalContractIds[i]);  
                }
                
            }
            
        }
        if(finalContractIds1.size()>0){
            initiateBatch1(finalContractIds1);
        }
         if(finalContractIds2.size()>0){
            initiateBatch1(finalContractIds2);
        }
         if(finalContractIds3.size()>0){
            initiateBatch1(finalContractIds3);
        }
         if(finalContractIds4.size()>0){
            initiateBatch1(finalContractIds4);
        }
         if(finalContractIds5.size()>0){
            initiateBatch1(finalContractIds5);
        }
    }
    /**
@Description: initiateBatch() method
@Name : initiateBatch
@Param : 
@Return : void
@throws Exception : N/A;
*/
    public static void initiateBatch1(List<map<String,Object>> finalContractIds){ 
        if(finalContractIds.size()>0) {
            Map <String, Object> ipInput = new Map <String,Object>();
            Map <String, Object> ipOutput = new Map <String,Object>();
            Map <String, Object> ipOptions = new Map <String,Object>();
            String jobName = Null;
            if (finalContractIds.size()>1){
                jobName = MULTIPLE;
            } else if (finalContractIds.size()==1){ 
                jobName = SINGLE;
            }
            else{}
            ipInput.put(CONTRACTTYPE,jobName);
            ipInput.put(MERGEDATA1, finalContractIds);
            ipOutput = (Map <String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService(PROCEDURE_NAME, 
                                                                                                            ipInput, ipOptions);
            String apexJobId = String.valueof(ipOutput.get(APEXJOBID));
        }
    }   
    /**
@Description: getListforCM() method
@Name : getListforCM
@Param : 
@Return : void
@throws Exception : N/A;
*/
    public static void dailyLoad(){
        Id profId=getUserId();
        List<Contract> contractList=[select Id,Name,createdby.ProfileId,vlocity_ins__QuoteId__c from Contract where createdby.ProfileId =: profId and vlocity_ins__FinalRatingGroupCensusId__c !=null and  vlocity_ins__QuoteId__c=null and createdDate = today  order by contractNumber];
        set<id> contractIds=new set<id>();
        for(Contract cnt:contractList){
                contractIds.add(cnt.Id);
        }
        List<vlocity_ins__GroupCensusMember__c> cenMemList=[select id,Name from vlocity_ins__GroupCensusMember__c where createdby.ProfileId =: profId and createdDate = today ];
        set<id> censusId=new set<id>();
        set<id> cenmemId=new set<id>();
        for(vlocity_ins__GroupCensusMember__c cmList:cenMemList){
                cenmemId.add(cmList.Id);
        }    
        list<vlocity_ins__GroupCensusMemberPlan__c> gcmpList=[Select id,Name,vlocity_ins__GroupCensusMemberId__c from vlocity_ins__GroupCensusMemberPlan__c where vlocity_ins__GroupCensusMemberId__c in:cenmemId];
        Map<Id,vlocity_ins__GroupCensusMemberPlan__c> gcmpKey=new map<Id,vlocity_ins__GroupCensusMemberPlan__c>();
        for(vlocity_ins__GroupCensusMemberPlan__c gmp:gcmpList){
            gcmpKey.put(gmp.vlocity_ins__GroupCensusMemberId__c,gmp);
        }
        for(vlocity_ins__GroupCensusMember__c cmList:cenMemList){
            if(gcmpKey.containsKey(cmList.Id)){
                censusId.add(cmList.vlocity_ins__CensusId__c); 
            }
        }   
        list<contract> contractList2=[select Id,Name,vlocity_ins__FinalRatingGroupCensusId__c from contract where vlocity_ins__FinalRatingGroupCensusId__c in:cenMemId  order by contractNumber];
        for(contract cls:contractList2){
            contractIds.add(cls.Id);
        }
        map<String,Object> tempMap = new map<String,Object>();
        List<map<String,Object>> finalContractIds = new List<map<String,Object>>(); 
        for(Id cId:contractIds){
            tempMap = new Map<String,Object>();
            tempMap.put(ID1, cId);
            finalContractIds.add(tempMap);
        } 
        if(finalContractIds.size()>0){
          multipleThreadForRates(finalContractIds);
        }
    }
}