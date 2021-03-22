/********************************************************************************************
    Class Name   : ARV_AP101_GenerateRenwlPkgsForGroup. 
    Date Created : 01-June-2020
    Created By   : IDC Offshore 
    Description  : This is called from Generate Renewal Packages process builder to Initiate CongaGroup renewal packages
                   upon changing the status to Document Generation of Renewal Contracts.
*******************************************************************************************/
public class ARV_AP101_GenerateRenwlPkgsForGroup implements Queueable,Database.AllowsCallouts {
    private Id contractid;
    private string prdType;
    private String carrierType;
    private Date RenewalEffectiveDate;
    /*************************************************************
    Method Name  : Constructor 
    Description  : To initialize Contract , producttype and carriertype
    **************************************************************/ 
    public ARV_AP101_GenerateRenwlPkgsForGroup(Id cntId, String pkgType,String carrType,Date effectiveDate){
        contractid=cntId;
        prdType=pkgType;
        carrierType=carrType;
        RenewalEffectiveDate=effectiveDate;
    }
    /*************************************************************
    Method Name  : execute method 
    Description  : This execute metthod to call CongaAgent and Conga Group packages generation 
    **************************************************************/ 
    public void execute(QueueableContext context) {
        List<Contract> cntrct=[select vlocity_ins__ExpiredContractId__c,ARV_Tech_DocumentGeneration__c from contract where id=:contractid];
        Id parentCntrctId=cntrct[0].vlocity_ins__ExpiredContractId__c;
        if(prdType=='CongaGroup'){
            cntrct[0].ARV_Tech_CongaGrpDocGen__c='Yes';
            database.update(cntrct[0],false);
            ARV_AP100_GenerateRenwlPkgs.prepareGroupRenewalPackage(parentCntrctId,contractid,prdType,carrierType,RenewalEffectiveDate); 
        }
    }
}