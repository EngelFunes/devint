/********************************************************************************************
Class Name   : ARV_AP96_AgentRenewalPckg. 
Date Created : 01-June-2020
Created By   : IDC Offshore 
Description  : This is used for getting Benefitsummary af agent renewal package data                
*******************************************************/
public without sharing class ARV_AP96_AgentRenewalPckg {
    private Id ContractId;
    private static final string IDSTRING = 'id';    
    public integer grpSegment{get;set;}
    public List<GA_Group_Segment__c> gsRec{get;set;}
    public List<wrapperGS> wrapGSList {get; set;}
    /************************************************************************************
Method Name : ARV_AP96_AgentRenewalPckg
Description : This is constructor for initialization and calling in vf
************************************************************************************/
     public ARV_AP96_AgentRenewalPckg(){   
        ContractId = ApexPages.currentPage().getParameters().get(IDSTRING);
        
    }   
/************************************************************************************
Method Name : getActiveContractData
Description : This method is calling in Vf page for getting  data adn show in vf
************************************************************************************/
    public void getActiveContractData(){  
        try{
        grpSegment=3;       
        
        if(wrapGSList == null) {
            wrapGSList = new List<wrapperGS>();
            
            for(GA_Group_Segment__c gsRec: [select Name, ARV_Package__r.name,ARV_Pending_PackageId__r.name,
                                            GA_Group_Name__c,GA_Group_Suffix__c,
                                            GA_GS_Auto_No__c,
                                            GA_Account__r.name,GA_Account__r.CID__c , ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,
                                            ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__AttributeSelectedValues__c,
                                            ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,
                                            ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.name,
                                            ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.name,
                                            ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,
                                            ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c,
                                            ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.Voluntary_Contributory__c,
                                            ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.Voluntary_Contributory__c,
                                            ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.name,
                                            ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.name,
                                            ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.name,
                                            ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.Voluntary_Contributory__c,
                                            ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.Voluntary_Contributory__c,
                                            ARV_Package__r.ARV_Pediatric_Vision_Plan__r.vlocity_ins__Product2Id__r.name,
                                            ARV_Pending_PackageId__r.ARV_Pediatric_Vision_Plan__r.vlocity_ins__Product2Id__r.name,
                                            ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.name,
                                          
                                            (select id,Enrollment_Medical_Premium__c,Enrollment_Dental_Premium__c,Enrollment_Vision_Premium__c FROM Census_Members__r)
                                            FROM GA_Group_Segment__c WHERE ARV_ContractID__c=:ContractId order by name asc]){
                                                wrapGSList.add(new wrapperGS(gsRec));
                                                
                                            }
        }
            }catch(Exception e){
                system.debug('Exception occured at'+e.getlinenumber()+':::msg:::'+e.getMessage());
                 GA_LogExceptionCls.LogExcp(e, 'ARV_AP96_AgentRenewalPckg', e.getlinenumber()+'');
    
            }   
        
    }
    /************************************************************************************
Class Name : wrapperGS
Description : This is wrapper class getting attributes 
************************************************************************************/
    public class wrapperGS{
        Map<String,Object> recordAttr = new Map<String,Object>();
        public GA_Group_Segment__c gs {get; set;}
        private final String DEDUCTIBLE1='Deductible';
        private final String COINSURANCE1='Co-insurance';
        private final String OFFICE1='OfficeVisitCopay';
        private final String EMERGENCY1='EmergencyRoomCopay';
        private final String DRUG1='PrescriptionDrugCoverage';
        private final String METALEVEL1='MetalLevel';
        private final String ANNUALMAX1='AnnualMax(InNetwork)';
        private final String DOLLAR='$';
        private final String PERCENTAGE='%';
        private final String PERCENTAGECOPAY='% Copay';
        private final String COPAY=' Copay';
        private final String UNDERSCRORE='_';
        private final String  GROUPSEGLISTQRY='Select Id,ARV_Package__c,ARV_Pending_PackageId__c from GA_Group_Segment__c';
        private final String  GROUPSEGWHERE= ' where id =:paramId1';
        public String deductible {get; set;}      
        public String coinsurance {get; set;}
        public String office {get; set;} 
        public String emergency {get; set;} 
        public String drug {get; set;} 
        public String metalevel {get; set;}
        public String annualmax {get; set;}
        public String deductiblef {get; set;}      
        public String coinsurancef {get; set;}
        public String officef {get; set;} 
        public String emergencyf {get; set;} 
        public String drugf {get; set;} 
        public String metalevelf {get; set;}
        public String annualmaxf {get; set;}
        public String attr {get; set;}
        public String attrdent {get; set;}       
        public String visionprdname{get; set;}
        public String visionprdnamef{get; set;} 
        public String visionpediatricname{get; set;}
        public String visionpediatricnamef{get; set;}
        public String attrf {get; set;}
        public String attrdentf {get; set;}      
        public decimal allrate {get; set;}
        public decimal allratef {get; set;}
        private decimal allr = 0;
        private decimal allrf = 0;
/************************************************************************************
Method Name : wrapperGS
Description : This is wrapper class constructor 
************************************************************************************/    
        public wrapperGS(GA_Group_Segment__c g) {
            gs = g;           
            Map<String,vlocity_ins__GroupCensusMemberPlan__c> cenMap = new Map<String,vlocity_ins__GroupCensusMemberPlan__c>();
            Map<String,vlocity_ins__GroupCensusMemberPlan__c> cenMap1 = new Map<String,vlocity_ins__GroupCensusMemberPlan__c>();
            /*calculate Total monthly premium for Active and Pending packages as based on groupsegment package id*/
            //if(gs !=null){
                //ARV_AP07_QueryDataHelper.paramId1 = gs.Id;
              // GA_Group_Segment__c glist = ARV_AP07_QueryDataHelper.getsObjects(GROUPSEGLISTQRY,GROUPSEGWHERE,NULL,NULL);
              GA_Group_Segment__c glist = [Select Id,ARV_Package__c,ARV_Pending_PackageId__c from GA_Group_Segment__c where Id =:gs.Id];
                if(glist !=null && glist.ARV_Package__c !=null){
                    for(vlocity_ins__GroupCensusMemberPlan__c cen: [select id,PackageId__c,ARV_Member_Rate__c,vlocity_ins__ContractLineId__c from  vlocity_ins__GroupCensusMemberPlan__c
                                                                    where PackageId__c =:glist.ARV_Package__c]){
                                                                        if(!cenMap.ContainsKey(cen.Id+UNDERSCRORE+cen.PackageId__c+UNDERSCRORE+cen.vlocity_ins__ContractLineId__c)){
                                                                        
                                                                            cenMap.put(cen.Id+UNDERSCRORE+cen.PackageId__c+UNDERSCRORE+cen.vlocity_ins__ContractLineId__c,cen);
                                                                            if(cen.ARV_Member_Rate__c !=null){
                                                                                allr += cen.ARV_Member_Rate__c;
                                                                            }
                                                                        }
                                                                    }
                    allrate = allr;
                }
                if(glist !=null && glist.ARV_Pending_PackageId__c !=null){
                    for(vlocity_ins__GroupCensusMemberPlan__c cen1: [select id,PackageId__c,ARV_Member_Rate__c,vlocity_ins__ContractLineId__c from  vlocity_ins__GroupCensusMemberPlan__c
                                                                     where PackageId__c =:glist.ARV_Pending_PackageId__c]){
                                                                         if(!cenMap1.ContainsKey(cen1.Id+UNDERSCRORE+cen1.PackageId__c+UNDERSCRORE+cen1.vlocity_ins__ContractLineId__c)){
                                                                             
                                                                             cenMap1.put(cen1.Id+UNDERSCRORE+cen1.PackageId__c+UNDERSCRORE+cen1.vlocity_ins__ContractLineId__c,cen1);
                                                                             if(cen1.ARV_Member_Rate__c !=null){
                                                                                 allrf += cen1.ARV_Member_Rate__c;
                                                                             }
                                                                         }
                                                                     }
                    allratef = allrf;
                }
           // }
           /*getting attribute values*/ 
           // attr = g.ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__AttributeSelectedValues__c;
           attr = g.ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c;

            attrdent = g.ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c;            
            //attrf = g.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__AttributeSelectedValues__c;
            attrf = g.ARV_Pending_PackageId__r.ARV_Medical_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c;

            attrdentf = g.ARV_Pending_PackageId__r.ARV_Dental_Plan__r.vlocity_ins__Product2Id__r.vlocity_ins__AttributeDefaultValues__c;           
            visionprdname = g.ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.name;
            visionprdnamef = g.ARV_Pending_PackageId__r.ARV_Vision_Plan__r.vlocity_ins__Product2Id__r.name;
            visionpediatricname = g.ARV_Package__r.ARV_Pediatric_Vision_Plan__r.vlocity_ins__Product2Id__r.name;
            visionpediatricnamef = g.ARV_Pending_PackageId__r.ARV_Pediatric_Vision_Plan__r.vlocity_ins__Product2Id__r.name;
            
            if(attr != null){
                recordAttr = (Map<String,Object>)json.deserializeuntyped(attr);
                for(String recordAttribute : recordAttr.keyset()){ 
                    if(recordAttr.get(recordAttribute) !=null && recordAttribute == DEDUCTIBLE1){
                        deductible =DOLLAR+ String.ValueOf(recordAttr.get(DEDUCTIBLE1)); 
                    }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == COINSURANCE1){
                        coinsurance = String.ValueOf(recordAttr.get(COINSURANCE1)) +PERCENTAGE;
                    }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == OFFICE1){
                        office = String.ValueOf(recordAttr.get(OFFICE1)).remove(DOLLAR)+PERCENTAGECOPAY; 
                    }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == EMERGENCY1){
                        emergency = String.ValueOf(recordAttr.get(EMERGENCY1))+COPAY; 
                    }else 
                        if(recordAttr.get(recordAttribute) !=null && recordAttribute == DRUG1){
                            drug = String.ValueOf(recordAttr.get(DRUG1)); 
                        }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == METALEVEL1){
                            metalevel = String.ValueOf(recordAttr.get(METALEVEL1)); 
                        }
                }                                                         
            }        
            if(attrdent != null){
                recordAttr = (Map<String,Object>)json.deserializeuntyped(attrdent);
                for(String recordAttribute : recordAttr.keySet() ){
                    if(recordAttr.get(recordAttribute) != null && recordAttribute ==ANNUALMAX1){
                        annualmax =DOLLAR+String.ValueOf(recordAttr.get(ANNUALMAX1));
                        
                    }
                }
            }
           
            if(attrf != null){
                recordAttr = (Map<String,Object>)json.deserializeuntyped(attrf);
                for(String recordAttribute : recordAttr.keyset()){ 
                    if(recordAttr.get(recordAttribute) !=null && recordAttribute == DEDUCTIBLE1){
                        deductiblef = DOLLAR+String.ValueOf(recordAttr.get(DEDUCTIBLE1)); 
                    }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == COINSURANCE1){
                        coinsurancef = String.ValueOf(recordAttr.get(COINSURANCE1))+PERCENTAGE; 
                    }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == OFFICE1){
                        officef = String.ValueOf(recordAttr.get(OFFICE1)).remove(DOLLAR) +PERCENTAGECOPAY; 
                    }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == EMERGENCY1){
                        emergencyf = String.ValueOf(recordAttr.get(EMERGENCY1))+COPAY; 
                        
                    }else 
                        if(recordAttr.get(recordAttribute) !=null && recordAttribute == DRUG1){
                            drugf = String.ValueOf(recordAttr.get(DRUG1)); 
                        }else if(recordAttr.get(recordAttribute) !=null && recordAttribute == METALEVEL1){
                            metalevelf = String.ValueOf(recordAttr.get(METALEVEL1)); 
                        }
                }                                                         
            }        
            if(attrdentf != null){
                recordAttr = (Map<String,Object>)json.deserializeuntyped(attrdentf);
                for(String recordAttribute : recordAttr.keySet() ){
                    if(recordAttr.get(recordAttribute) != null && recordAttribute ==ANNUALMAX1){
                        annualmaxf =DOLLAR+String.ValueOf(recordAttr.get(ANNUALMAX1));
                        
                    }
                }
            }
          
        }
        
    }
    
}