/*****************************************************************************************
    Class Name   : ARV_GWC_PackageCreations
    Date Created : 29/09/2020
    Created By   : IDC Offshore
    Description  : This is the class for packages creation......
    ******************************************************************************************/
    global without sharing class ARV_GWC_PackageCreations implements vlocity_ins.VlocityOpenInterface  {
        public static boolean flag=false;
        public static boolean planCreated=false;
        public static boolean createTerminatePackageforVol=false;
        public static string CLASSNAME='ARV_GWC_PackageCreations';
        private static final String conid='contractId';
        private static final String pediatricDental='pediatricDental';
        private static final string PRODUCTCODE='ProductCode';
        private static final string PRODUCTNAME='ProductName';
        private static final string PRODUCTID='ProductId';
        private static final string PEDIATRICVISION='pediatricVision';
        private static final string DENTALCOVERAGE='ExistingDentalCoverageGWC';
        private static final string PRODSELECTION='Productselection';
        private static final string FINALGSPLANS='finalGroupSegmentsPlans';
        private static final string LOCATIONGS='NewLocationDetails_JS_No';
        private static final string PLANCOMB='M,Da,Va;M,Da,Va;';
        private static final string ADD='Add';
        private static final string TERMINATE='Terminate';
        private static final string BENEFITTPACKAGE='Add Benefit Package';
        private static final string ADDLOCATION='Add Location';
        private static final string ADDLOCDIFFCARR='Add Location Different Carrier';
        private static final string BENEFITTPACKAGEDIFFCARRIER='Add Benefit Package Different Carrier';
        private static final string ADDED='Added'; 
        private static String PEDIATRIC= 'Pediatric';
        private static String GSPACKAGE='GS-Package';
        private static final string NO='No';
        private static String NA= 'NA';
        private static String HBALEVEL='HBA Level:';
        private static String ZIPCODE='ZipCode:';
        private static String NEWLOC='New Location:';
        private static String NAME='name';
        private static String GROUPSEGMENT='Group Segment:';
        private static String COUNTY='County:';
        private static String BCNHSAMEMOPTN='BCN HSA Member Option:';
        private static final string NOTOFFERED='Not Offered';
        private static final string NOM='NOM';
        private static final string RM='RM';
        private static final string NOD='NOD';
        private static final string NOV='NOV';
        private static String PACKAGENOTOFFEREDBLUDENTAL= 'Not Offered-Blue Dental PPO Plus℠ 80/50/50 Pediatric SG-Not Offered';
        private static final string TRANSACTIONUPDATE='Update';
        private static final string NOCHANGE='No Change';
        private static final string MODIFYBENEFIT='Modify Benefit Package';
        private static final string NOCHANGECDH='No Change CDH';
        private static final string UPDATECDH='Update CDH';
        private static final string ADDCDH='Add CDH';
        private static final string ACTIVE='Active';
        private static final string EXISTINGBENEFIT='Existing Benefit Package No Change';
        private static Boolean DeleteGSegFlag=false;
        private static string deletedGSArr='deletedGSArr';
        Private Static String groupSegmentId='groupSegmentId';
        Private static String groupSegmentName='groupSegmentName';
        
    /*****************************************************************************************
    Method Name   : invokeMethod
    Created By   : IDC Offshore
    Description  : This is the invokeMethod
    ******************************************************************************************/
        global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                    Map<String,Object> output, Map<String,Object> options){           
                                        Boolean success = true;
                                        try{
                                            if (methodName == 'createPackages') 
                                                createPackages(input,output,options);
                                            
                                        }catch(Exception e){
                                            system.debug('Error ::'+e.getLineNumber());
                                            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'invokeMethod'); 
                                        }
                                        return success;
                                    }   
    /*****************************************************************************************
    Method Name   : createPackages
    Created By   : IDC Offshore
    Description  : This is the method for packages creation
    ******************************************************************************************/
        global void createPackages(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
        {
            
            set<id> gsSet=new set<id>();
            map<String,object> blobmap= new map<String,object>();
            map<String,object> gsblobmap= new map<String,object>();
            map<String,object> gslocblobmap= new map<String,object>();
            map<String,object> blobmaplc= new map<String,object>();
            String blobdata;
            String gsblobdata;
            String gslocblobdata;
            String blobmaplcdata;
            Id RecTypeId;
            String contractId= String.valueof(input.get(conid));    
            map<Id,Id> prdidmap = new map<Id,Id>();
            List<Package__c> packlist = new List<Package__c>();
            List<Package__c> gspacklist = new List<Package__c>();
            List<Package__c> packlistlc = new List<Package__c>();
             List<Package__c> packlistlcloc = new List<Package__c>();
            Package__c packLc = new Package__c();
            Package__c packLcloc = new Package__c();
            Map<string,Object> peddentMap = (Map<string,Object>)input.get(pediatricDental);
            string pedDentalCode=String.valueOf(peddentMap.get(PRODUCTCODE));
            string pedDentalPrdId=String.valueOf(peddentMap.get(PRODUCTID));
            String pedDentName=String.valueOf(peddentMap.get(PRODUCTNAME));
            Map<string,Object> dentQuestMap = (Map<string,Object>)input.get(PRODSELECTION);
            string pedDentalQuest=String.valueOf(dentQuestMap.get(DENTALCOVERAGE));
            Map<string,Object> pedvsnMap = (Map<string,Object>)input.get(PEDIATRICVISION);
            string pedVisonCode=String.valueOf(pedvsnMap.get(PRODUCTCODE));
            string pedVisionPrdId=String.valueOf(pedvsnMap.get(PRODUCTID));
            String pedVsnName=String.valueOf(pedvsnMap.get(PRODUCTNAME));
            DeleteGSegFlag=boolean.valueOf(input.get('deleteGSFlag'));
            
            List<BenefitWrapper> pkgslist= new  List<BenefitWrapper>();
            List<BenefitWrapperLocation> locationlist= new  List<BenefitWrapperLocation>();
            system.debug('pkgslistinside');
            pkgslist=jsonToList(input.get(FINALGSPLANS));
            system.debug('pkgslist'+pkgslist);
 
            system.debug('locationlist1'+locationlist);
            set<id> medCLISet=new set<id>();
            set<id> medGsPrdId=new set<id>();
            vlocity_ins__ContractLineItem__c newClis;
            map<Id,String> medprdmap = new map<Id,String>();
            List<vlocity_ins__ContractLineItem__c> newClilist= new  List<vlocity_ins__ContractLineItem__c>();
            
        
            for(BenefitWrapper bw  : pkgslist)
            {
            system.debug('bw.medPrdId@@@'+bw.medPrdId);
                 if(bw.medPrdId != NOM && bw.medPrdId!= RM && bw.medPrdId!= '' && bw.medicalPlan != NOTOFFERED ){
                     medGsPrdId.add(bw.medPrdId);
                     medprdmap.put(bw.medPrdId,bw.medicalPlan);
                 }
            }
            for(vlocity_ins__ContractLineItem__c plan: [select id,name,vlocity_ins__ProductType__c,
                                                           vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c 
                                                           from vlocity_ins__ContractLineItem__c where 
                                                           vlocity_ins__ContractId__c=:contractId])
            {
                medCLISet.add(plan.vlocity_ins__Product2Id__c);
            }
            for(Id Ids:medGsPrdId )
            {
                if(!medCLISet.contains(Ids) )
                {
                  newClis = new vlocity_ins__ContractLineItem__c();
                  newClis.Name = medprdmap.get(Ids);
                  newClis.vlocity_ins__Product2Id__c=Ids;
                  newClis.vlocity_ins__ContractId__c=contractId; 
                  newClilist.add(newClis);  
                }
            }
             if(newClilist.size()>0){
                database.insert(newClilist);
                //system.debug('gspacklist size::'+gspacklist.size());
            }
                    
            
           
            list<vlocity_ins__ContractLineItem__c> plans =[select id,name,vlocity_ins__ProductType__c,
                                                           vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c 
                                                           from vlocity_ins__ContractLineItem__c where 
                                                           vlocity_ins__ContractId__c=:contractId];
            
            list<String> grpselected= new list<String>();
             String packname;
            //system.debug(':::plans size:::'+plans.size());
            for(vlocity_ins__ContractLineItem__c plan: plans)
            {
                prdidmap .put(plan.vlocity_ins__Product2Id__c,plan.Id);
                
            }
            map<id,string> dentMap=new Map<id,string>();
            Map<string,string> pediatricMap=new Map<string,string>();
            contract con=[select id,accountid from contract where id=:contractId];
            system.debug('con::'+con.AccountId);
            List<GA_Group_Segment__c> gsloclist=[select id,name,GA_Account__c from GA_Group_Segment__c where GA_Account__c=:con.accountId and Status__c=:ACTIVE];
            system.debug('gslist:'+gsloclist.size());
            string gsloc=gsloclist[0].name;
            for(BenefitWrapper bw  : pkgslist)
            { 
                //string gsLoc=bw.groupSegmentName;
                string prvsmedicaltype=bw.oldMedicalType;
                system.debug('prvsmedicaltype::'+prvsmedicaltype);
                Package__c pack = new Package__c();
                RecTypeId= Schema.getGlobalDescribe().get('Package__c').getDescribe().getRecordTypeInfosByName().get('Group Segment Package').getRecordTypeId();
                pack.ARV_Contract_Id__c =Id.valueof(contractId);
              //  if(bw.isLocSelected!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                string addLocgsName;
                 if(bw.isNewGS==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                    if(bw.isAddSegLoc==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                        
                            addLocgsName=bw.selectedGS[0].remove(GROUPSEGMENT);
                        
                        List<string> loclist=new List<string>();
                        loclist.add(addLocgsName);
                        system.debug('addLocgsName::'+addLocgsName);
                        for(string gslocname:loclist){
                                    String packageComb=bw.medicalPlan +'-'+ bw.dentalPlan +'-' +bw.visionPlan;
                                    if(packageComb!=PACKAGENOTOFFEREDBLUDENTAL){
                                    Package__c locpack = new Package__c();
                                    locpack.ARV_Contract_Id__c =Id.valueof(contractId);
                                    locpack.name=bw.groupSegmentNameLoc+'_'+ bw.groupSegmentName;
                                    locpack.GS_number__c=gslocname;
                                    locpack.ARV_Tech_GWC_Legacy_Id__c=gslocname;
                                    system.debug('ARV_Tech_GWC_Legacy_Id__c::'+locpack.ARV_Tech_GWC_Legacy_Id__c);
                                    locpack.ARV_Plan_Package_Combinations__c=PLANCOMB;
                                    locpack.RecordtypeId=RecTypeId;
                                    locpack.ARV_GWC_Vision_Transaction__c=ADD;
                                    locpack.ARV_GWC_Medical_Transaction__c=ADD;
                                    locpack.ARV_GWC_Dental_Transaction__c=ADD;
                                    if(bw.cdhPlanSelcted!='' && bw.cdhPlanSelcted!=null){
                                    locpack.ARV_GWC_CDH_Transaction__c=ADDCDH; 
                                        }
                                       
                                    /*if(!gsprevsmedicatlType.contains(bw.medicalType)){
                                        locpack.ARV_GWC_Benefit_Package_Type__c=BENEFITTPACKAGEDIFFCARRIER;
                                    }
                                    else{*/
                                        system.debug('entered:');
                                        if(bw.medicalType!=bw.addsegprvmedtyp && bw.addsegprvmedtyp!='' && bw.addsegprvmedtyp!=null){
                                         locpack.ARV_GWC_Benefit_Package_Type__c= ADDLOCDIFFCARR;
                                        
                                            }
                                        else{
                                            locpack.ARV_GWC_Benefit_Package_Type__c=ADDLOCATION;
                                        }
                                    //}
                                    if(bw.cdhPlanSelcted!='' && bw.cdhPlanSelcted!=NO){
                                    locpack.ARV_CDH_Package_Combination__c=bw.cdhPlanSelcted;
                                    }
                                    //system.debug('PD1::'+bw.dentalPlan);
                                    if(bw.medPrdId!=null && bw.medPrdId!=NOM &&  bw.medPrdId!=RM && bw.medPrdId!=ARV_AP41_StringLiteralUtils.MYBLANKVAL && prdidmap.keyset().contains(bw.medPrdId)){  
                                    locpack.ARV_Medical_Plan__c=prdidmap.get(bw.medPrdId);}
                                    if(( bw.dentalPlan==NOTOFFERED) && pedDentalQuest==NO ){
                                        //system.debug('PD::'+prdidmap.get(pedDentalPrdId));
                                       if(prdidmap.get(pedDentalPrdId)==null){
                                        vlocity_ins__ContractLineItem__c newPedDental=new vlocity_ins__ContractLineItem__c(name=pedDentName,vlocity_ins__Product2Id__c=pedDentalPrdId,vlocity_ins__ContractId__c=contractId);
                                        database.insert(newPedDental);
                                        prdidmap.put(pedDentalPrdId,newPedDental.id);}
                                    
                                        locpack.ARV_Dental_Plan__c=prdidmap.get(pedDentalPrdId);
                                        //system.debug('Dental remove::'+locpack.ARV_Dental_Plan__c);
                                    }
                                        else if(bw.denPrdId!=null  && bw.denPrdId!='' && bw.dentalPlan!=NOTOFFERED && pedDentalQuest!=NO && prdidmap.keyset().contains(bw.denPrdId)  ){
                                            locpack.ARV_Dental_Plan__c=prdidmap.get(bw.denPrdId);
                                        }
                                        
                                    
                                      if(bw.visPrdId==NOV || bw.visionPlan==NOTOFFERED){
                                        //system.debug('pv:'+prdidmap.get(pedVisionPrdId));
                                        if(prdidmap.get(pedVisionPrdId)==null && bw.medicalPlan != NOTOFFERED){
                                            vlocity_ins__ContractLineItem__c newPedVision=new vlocity_ins__ContractLineItem__c(name=pedVsnName,vlocity_ins__Product2Id__c=pedVisionPrdId,vlocity_ins__ContractId__c=contractId);
                                            database.insert(newPedVision);
                                            prdidmap.put(pedVisionPrdId,newPedVision.id);
                                         }
                                        if(bw.medicalPlan != NOTOFFERED){
                                            locpack.ARV_Vision_Plan__c=prdidmap.get(pedVisionPrdId);
                                        }
                                     }
                                    else if(bw.visPrdId!=null  && bw.visPrdId!='' && prdidmap.keyset().contains(bw.visPrdId)){
                                        if((bw.medicalType == ARV_AP41_StringLiteralUtils.BCBSTYPE || bw.medicalType == ARV_AP41_StringLiteralUtils.BCBSMVAL) && bw.visVolType==ARV_AP41_StringLiteralUtils.VOLUNTARY){
                                            locpack.ARV_Pediatric_Vision_Plan__c=prdidmap.get(pedVisionPrdId);}
                                        locpack.ARV_Vision_Plan__c= prdidmap.get(bw.visPrdId);
                                          
                                     }
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWMEDICALPLAN,bw.medicalPlan);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDMEDICALPLAN,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALPLAN,bw.dentalPlan);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALPLAN,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONPLAN,bw.visionPlan);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONPLAN,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDCARRIER,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWCARRIER,bw.medicalType);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALTYPE,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALTYPE,bw.denVolType);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONTYPE,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONTYPE,bw.visVolType);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDPRODUCTFAMILY,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWPRODUCTFAMILY, bw.ProductFamily);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDCDHPLAN,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWCDHPLAN,bw.CdhPlan);
                                    gslocblobmap.put(HBALEVEL,bw.groupSegmentHBALevel);
                                    gslocblobmap.put(BCNHSAMEMOPTN,bw.groupSegmentBCNHSAOption);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALPRODCODE,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALPRODCODE, bw.denPrdCode);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONPRODCODE,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONPRODCODE, bw.visPrdCode);
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.OLDMEDICALPRODCODE,'null');
                                    gslocblobmap.put(ARV_AP41_StringLiteralUtils.NEWMEDICALPRODCODE, bw.medPrdCode);
                                    gslocblobmap.put(NEWLOC, bw.groupSegmentNameLoc);
                                    gslocblobmap.put(ZIPCODE, bw.ZipCode);
                                    if(bw.County.get(NAME)!='N/A' )
                                    {
                                    GA_County_Code__c physicalcounty=[select id,name from GA_County_Code__c where name=:bw.County.get(NAME) limit 1];
                                     gslocblobmap.put(COUNTY, physicalcounty.id);
                                    }
                                    
                                    gslocblobdata=JSON.serialize(gslocblobmap);
                                    locpack.ARV_GWC_Package_Change_Attributes__c=gslocblobdata;
                                    //system.debug('::gslocblobdata::'+ gslocblobdata);
                                    gspacklist.add(locpack);
                                   } 
                                } 
                    }
                   
                   else{
                   List<String> gsLst=new List<String>();
                    string addgsName=bw.selectedGS[0];
                     string gsprevsmedicatlType=bw.selectedGS[1].remove('ParentGSPrvsMedType:');
                     system.debug('addgsName::'+addgsName);
                     system.debug('gsprevsmedicatlType::'+gsprevsmedicatlType);
                    List<String> gsSelected=new List<String>() ;
                     gsSelected.add(addgsName);
                    for(String str:gsSelected){
                        String st=str.remove(GROUPSEGMENT);
                        gsLst.add(st);
                    }
                    bw.benefitPkdAdd=ADDED;
                    for(string gsname:gsLst)  
                    {
                        String packageComb=bw.medicalPlan +'-'+ bw.dentalPlan +'-' +bw.visionPlan;
                        if(packageComb!=PACKAGENOTOFFEREDBLUDENTAL){
                        Package__c pack1 = new Package__c();
                        pack1.ARV_Contract_Id__c =Id.valueof(contractId);
                        pack1.name='GS-'+ bw.groupSegmentName;
                        pack1.GS_number__c=gsname;
                        pack1.ARV_Tech_GWC_Legacy_Id__c=gsname;
                        pack1.ARV_Plan_Package_Combinations__c=PLANCOMB;
                        pack1.RecordtypeId=RecTypeId;
                        pack1.ARV_GWC_Vision_Transaction__c=ADD;
                        pack1.ARV_GWC_Medical_Transaction__c=ADD;
                        pack1.ARV_GWC_Dental_Transaction__c=ADD;
                        if(bw.cdhPlanSelcted!=''){
                        pack1.ARV_GWC_CDH_Transaction__c=ADDCDH;
                        }
                           
                        if(!gsprevsmedicatlType.contains(bw.medicalType)){
                            pack1.ARV_GWC_Benefit_Package_Type__c=BENEFITTPACKAGEDIFFCARRIER;
                        }
                        else{
                            system.debug('entered:');
                            pack1.ARV_GWC_Benefit_Package_Type__c=BENEFITTPACKAGE;
                        }
                        if(bw.cdhPlanSelcted!='' && bw.cdhPlanSelcted!=NO){
                        pack1.ARV_CDH_Package_Combination__c=bw.cdhPlanSelcted;
                        }
                        //system.debug('PD1::'+bw.dentalPlan);
                        if(bw.medPrdId!=null && bw.medPrdId!=NOM &&  bw.medPrdId!=RM && bw.medPrdId!='' && prdidmap.keyset().contains(bw.medPrdId)){  
                        pack1.ARV_Medical_Plan__c=prdidmap.get(bw.medPrdId);}
                        if(( bw.dentalPlan==NOTOFFERED) && pedDentalQuest==NO ){
                            //system.debug('PD::'+prdidmap.get(pedDentalPrdId));
                           if(prdidmap.get(pedDentalPrdId)==null){
                            vlocity_ins__ContractLineItem__c newPedDental=new vlocity_ins__ContractLineItem__c(name=pedDentName,vlocity_ins__Product2Id__c=pedDentalPrdId,vlocity_ins__ContractId__c=contractId);
                            database.insert(newPedDental);
                            prdidmap.put(pedDentalPrdId,newPedDental.id);}
                        
                            pack1.ARV_Dental_Plan__c=prdidmap.get(pedDentalPrdId);
                            //system.debug('Dental remove::'+pack1.ARV_Dental_Plan__c);
                        }
                            else if(bw.denPrdId!=null  && bw.denPrdId!='' && bw.dentalPlan!=NOTOFFERED && pedDentalQuest!=NO && prdidmap.keyset().contains(bw.denPrdId)  ){
                                pack1.ARV_Dental_Plan__c=prdidmap.get(bw.denPrdId);
                            }
                            
                        
                          if(bw.visPrdId==NOV || bw.visionPlan==NOTOFFERED){
                            //system.debug('pv:'+prdidmap.get(pedVisionPrdId));
                            if(prdidmap.get(pedVisionPrdId)==null && bw.medicalPlan != NOTOFFERED){
                                vlocity_ins__ContractLineItem__c newPedVision=new vlocity_ins__ContractLineItem__c(name=pedVsnName,vlocity_ins__Product2Id__c=pedVisionPrdId,vlocity_ins__ContractId__c=contractId);
                                database.insert(newPedVision);
                                prdidmap.put(pedVisionPrdId,newPedVision.id);
                             }
                            if(bw.medicalPlan != NOTOFFERED){
                                pack1.ARV_Vision_Plan__c=prdidmap.get(pedVisionPrdId);
                            }
                         }
                        else if(bw.visPrdId!=null  && bw.visPrdId!='' && prdidmap.keyset().contains(bw.visPrdId)){
                            if((bw.medicalType == ARV_AP41_StringLiteralUtils.BCBSTYPE || bw.medicalType == ARV_AP41_StringLiteralUtils.BCBSMVAL) && bw.visVolType==ARV_AP41_StringLiteralUtils.VOLUNTARY){
                                pack1.ARV_Pediatric_Vision_Plan__c=prdidmap.get(pedVisionPrdId);}
                            pack1.ARV_Vision_Plan__c= prdidmap.get(bw.visPrdId);
                              
                         }
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWMEDICALPLAN,bw.medicalPlan);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDMEDICALPLAN,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALPLAN,bw.dentalPlan);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALPLAN,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONPLAN,bw.visionPlan);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONPLAN,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDCARRIER,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWCARRIER,bw.medicalType);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALTYPE,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALTYPE,bw.denVolType);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONTYPE,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONTYPE,bw.visVolType);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDPRODUCTFAMILY,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWPRODUCTFAMILY, bw.ProductFamily);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDCDHPLAN,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWCDHPLAN,bw.CdhPlan);
                        blobmap.put(HBALEVEL,bw.groupSegmentHBALevel);
                        blobmap.put(BCNHSAMEMOPTN,bw.groupSegmentBCNHSAOption);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALPRODCODE,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALPRODCODE, bw.denPrdCode);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONPRODCODE,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONPRODCODE, bw.visPrdCode);
                        blobmap.put(ARV_AP41_StringLiteralUtils.OLDMEDICALPRODCODE,'null');
                        blobmap.put(ARV_AP41_StringLiteralUtils.NEWMEDICALPRODCODE, bw.medPrdCode);
                        blobdata=JSON.serialize(blobmap);
                        pack1.ARV_GWC_Package_Change_Attributes__c=blobdata;
                        //system.debug('::blobdata::'+ blobdata);
                        gspacklist.add(pack1);
                       } 
                        
                    }
                  } 
                }
                else {
                    //Added for4175
                    Boolean createTerminatePackage=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
                    String isNewCarrier=bw.medicalType;
                    string isOldCarrier=bw.previousPlanMedicalType;
                    string OldGroupSegmentId;
                    string oldDentaltype=bw.oldDenVolType;
                    string newDentaltype=bw.denVolType;
                    string oldDentalPlan=bw.oldDentalPlan;
                    system.debug('oldDentalPlan'+oldDentalPlan);
                    string oldVisiontype=bw.oldvisVolType;
                    string newVisiontype=bw.visVolType;
                    system.debug('pkkk'+isOldCarrier+'isNewCarrier'+isNewCarrier);
                    //system.debug('mmmm'+bw.groupSegmentName);
                     Boolean isBCN ; Boolean isBCBS;Boolean NoMedical=false;
                    if(isOldCarrier==ARV_AP41_StringLiteralUtils.BCNTYPE){
                       isBCN = (isOldCarrier==ARV_AP41_StringLiteralUtils.BCNTYPE && isNewCarrier==ARV_AP41_StringLiteralUtils.BCNTYPE)?true:false;
                    }
                    if(isOldCarrier==ARV_AP41_StringLiteralUtils.BCBSTYPE){
                     isBCBS=(isOldCarrier==ARV_AP41_StringLiteralUtils.BCBSTYPE && isNewCarrier==ARV_AP41_StringLiteralUtils.BCBSTYPE)?true:false;
                     }
                     if(isOldCarrier==Null && isNewCarrier==ARV_AP41_StringLiteralUtils.BCNTYPE){
                       NoMedical=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                     }
                    //system.debug('heel'+isBCN+'ee2222'+NoMedical);
                    if(isBCN== ARV_AP41_StringLiteralUtils.FALSE_VALUE || isBCBS==ARV_AP41_StringLiteralUtils.FALSE_VALUE|| NoMedical){
                        createTerminatePackage=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                        OldGroupSegmentId=bw.groupSegmentId;
                    }
                    if((oldDentaltype==ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentaltype==ARV_AP41_StringLiteralUtils.NONVOLUNTARY) || (oldVisiontype==ARV_AP41_StringLiteralUtils.VOLUNTARY && newVisiontype==ARV_AP41_StringLiteralUtils.NONVOLUNTARY))
                    {
                       createTerminatePackageforVol=ARV_AP41_StringLiteralUtils.TRUE_VALUE; 
                    }
                    if(createTerminatePackageforVol==ARV_AP41_StringLiteralUtils.TRUE_VALUE)
                    {
                        if(oldDentalPlan!=null && oldDentalPlan!=''){
                        if(oldDentalPlan.contains(PEDIATRIC))
                        {
                            system.debug('entering into this loop');
                            Package__c packTer = new Package__c();
                            packTer.ARV_Vision_Plan__c=null;
                            packTer.ARV_Dental_Plan__c=null;
                            packTer.ARV_Medical_Plan__c=null;
                            packTer.ARV_GWC_Benefit_Package_Type__c=TERMINATE;
                            packTer.name='GS-Package' +ARV_AP41_StringLiteralUtils.SEPERATEDVAL+ bw.groupSegmentName+ARV_AP41_StringLiteralUtils.SEPERATEDVAL+'Terminated';
                            packTer.ARV_Tech_GWC_Legacy_Id__c=bw.groupSegmentName;
                            packTer.RecordtypeId=RecTypeId;
                            packTer.GS_number__c=bw.groupSegmentName;
                            packTer.ARV_Contract_Id__c=contractId;
                            gspacklist.add(packTer);
                        }
                        }
                        
                    }
                    
                    
                    String packageComb=bw.medicalPlan +ARV_AP41_StringLiteralUtils.SEPERATEDVAL+ bw.dentalPlan +ARV_AP41_StringLiteralUtils.SEPERATEDVAL +bw.visionPlan;
                    if(packageComb!=PACKAGENOTOFFEREDBLUDENTAL){
                    pack.name='GS-Package' +ARV_AP41_StringLiteralUtils.SEPERATEDVAL+ bw.groupSegmentName;
                    pack.GS_number__c=bw.groupSegmentName;
                    pack.ARV_Plan_Package_Combinations__c=PLANCOMB;
                    pack.ARV_Tech_GWC_Legacy_Id__c=bw.groupSegmentName;
                    pack.RecordtypeId=RecTypeId;
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDCARRIER,bw.previousPlanMedicalType);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWCARRIER,bw.medicalType);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALTYPE,bw.oldDenVolType);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALTYPE,bw.denVolType);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONTYPE,bw.oldvisVolType);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONTYPE,bw.visVolType);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDPRODUCTFAMILY,bw.previousPlanProductFamily);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWPRODUCTFAMILY, bw.ProductFamily);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDCDHPLAN,bw.PrevcdhPlanSelcted);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWCDHPLAN,bw.cdhPlanSelcted);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWMEDICALPLAN,bw.medicalPlan);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDMEDICALPLAN,bw.oldMedicalPlan);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALPLAN,bw.dentalPlan);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALPLAN,bw.oldDentalPlan);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONPLAN,bw.visionPlan);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONPLAN,bw.oldVisionPlan);
                    gsblobmap.put(HBALEVEL,bw.groupSegmentHBALevel);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDDENTALPRODCODE,bw.olddenPrdCode);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWDENTALPRODCODE, bw.denPrdCode);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDVISIONPRODCODE,bw.oldvisPrdCode);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWVISIONPRODCODE, bw.visPrdCode);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.OLDMEDICALPRODCODE,bw.oldmedPrdCode);
                    gsblobmap.put(ARV_AP41_StringLiteralUtils.NEWMEDICALPRODCODE, bw.medPrdCode);
                    gsblobmap.put(BCNHSAMEMOPTN,bw.groupSegmentBCNHSAOption);    
                    
                    gsblobdata=JSON.serialize(gsblobmap);
                    pack.ARV_GWC_Package_Change_Attributes__c=gsblobdata;
                    //system.debug('::GS blobdata::'+ gsblobdata);
                    //system.debug('Dental plan::'+bw.dentalPlan);
                      
                    if(bw.cdhPlanSelcted!='' && bw.cdhPlanSelcted!=NO){
                        pack.ARV_CDH_Package_Combination__c=bw.cdhPlanSelcted;
                        }
                      if(bw.medPrdId!='' && bw.medPrdId!=NOM && bw.medPrdId!=RM && bw.medPrdId!=null && prdidmap.keyset().contains(bw.medPrdId)){
                      pack.ARV_Medical_Plan__c=prdidmap.get(bw.medPrdId);
                      }
                      
                        if((bw.denPrdId==NOD || bw.dentalPlan==NOTOFFERED) && pedDentalQuest==NO ){
                        
                           if(prdidmap.get(pedDentalPrdId)==null){
                          vlocity_ins__ContractLineItem__c newPedDental=new vlocity_ins__ContractLineItem__c(name=pedDentName,vlocity_ins__Product2Id__c=pedDentalPrdId,vlocity_ins__ContractId__c=contractId);
                          database.insert(newPedDental);
                          prdidmap.put(pedDentalPrdId,newPedDental.id);}
                        
                          pack.ARV_Dental_Plan__c=prdidmap.get(pedDentalPrdId);
                       }
                      
                      else if(bw.denPrdId!=null && bw.denPrdId!=ARV_AP41_StringLiteralUtils.MYBLANKVAL && prdidmap.keyset().contains(bw.denPrdId)){
                      pack.ARV_Dental_Plan__c=prdidmap.get(bw.denPrdId);
                        }
                      
                      
                      else{}
                      if(bw.visPrdId==NOV || bw.visionPlan==NOTOFFERED){
                        if(prdidmap.get(pedVisionPrdId)==null && bw.medPrdId!=ARV_AP41_StringLiteralUtils.MYBLANKVAL && bw.medPrdId!=NOM && bw.medPrdId!=RM){
                          vlocity_ins__ContractLineItem__c newPedVision=new vlocity_ins__ContractLineItem__c(name=pedVsnName,vlocity_ins__Product2Id__c=pedVisionPrdId,vlocity_ins__ContractId__c=contractId);
                          database.insert(newPedVision);
                          prdidmap.put(pedVisionPrdId,newPedVision.id);
                         }
                         if(bw.medPrdId!=ARV_AP41_StringLiteralUtils.MYBLANKVAL && bw.medPrdId!=NOM && bw.medPrdId!=RM){   
                          pack.ARV_Vision_Plan__c=prdidmap.get(pedVisionPrdId);
                         }
                      }
                      
                      else if(bw.visPrdId!=null  && bw.visPrdId!=ARV_AP41_StringLiteralUtils.MYBLANKVAL && prdidmap.keyset().contains(bw.visPrdId)){
                          if((bw.medicalType == ARV_AP41_StringLiteralUtils.BCBSTYPE || bw.medicalType == ARV_AP41_StringLiteralUtils.BCBSMVAL) && bw.visVolType==ARV_AP41_StringLiteralUtils.VOLUNTARY){
                                pack.ARV_Pediatric_Vision_Plan__c=prdidmap.get(pedVisionPrdId);}
                          pack.ARV_Vision_Plan__c= prdidmap.get(bw.visPrdId);
                        }
                        
                    //system.debug('Selected Med Plan::'+bw.selectedMedPlan);
                    if(bw.medicalPlan!=bw.oldMedicalPlan ){
                      pack.ARV_GWC_Medical_Transaction__c=TRANSACTIONUPDATE;        
                    }
                    else{
                      pack.ARV_GWC_Medical_Transaction__c=NOCHANGE;
                    }
                    if( (bw.dentalPlan!=bw.oldDentalPlan && bw.olddenPrdCode !=bw.denPrdCode) ){
                      pack.ARV_GWC_Dental_Transaction__c=TRANSACTIONUPDATE;        
                    }
                    else if(bw.dentalPlan ==bw.oldDentalPlan && bw.olddenPrdCode !=bw.denPrdCode){
                      pack.ARV_GWC_Dental_Transaction__c=TRANSACTIONUPDATE;
                        }
                      else if(bw.dentalPlan !=bw.oldDentalPlan && bw.olddenPrdCode ==bw.denPrdCode){
                      pack.ARV_GWC_Dental_Transaction__c=TRANSACTIONUPDATE;
                        }
                    else{
                      pack.ARV_GWC_Dental_Transaction__c=NOCHANGE;
                        }
                    
                    if((bw.visionPlan!=bw.oldVisionPlan && bw.visPrdCode!=bw.oldvisPrdCode) || bw.visionPlan==NOTOFFERED){
                      pack.ARV_GWC_Vision_Transaction__c=TRANSACTIONUPDATE;        
                    }
                    else if(bw.visionPlan == bw.oldVisionPlan &&  bw.visPrdCode!=bw.oldvisPrdCode){
                      pack.ARV_GWC_Vision_Transaction__c=TRANSACTIONUPDATE;
                        }
                      else if(bw.visionPlan != bw.oldVisionPlan &&  bw.visPrdCode==bw.oldvisPrdCode){
                      pack.ARV_GWC_Vision_Transaction__c=TRANSACTIONUPDATE;
                        }
                    else{
                      pack.ARV_GWC_Vision_Transaction__c=NOCHANGE;
                        }
                    
                    if(bw.PrevcdhPlanSelcted==NA && bw.isCDHOptionSelected==ARV_AP41_StringLiteralUtils.YESVAL && bw.cdhPlanSelcted!=NO &&  bw.cdhPlanSelcted!=ARV_AP41_StringLiteralUtils.MYBLANKVAL ){
                           pack.ARV_GWC_CDH_Transaction__c=ADDCDH; 
                        }
                    else if(bw.cdhPlanSelcted!=bw.PrevcdhPlanSelcted && bw.cdhPlanSelcted!=NO && bw.cdhPlanSelcted!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
                      pack.ARV_GWC_CDH_Transaction__c=UPDATECDH;
                    }
                    else{
                      pack.ARV_GWC_CDH_Transaction__c=NOCHANGECDH;
                    }
                      if( pack.ARV_GWC_Vision_Transaction__c==TRANSACTIONUPDATE 
                       || pack.ARV_GWC_Dental_Transaction__c==TRANSACTIONUPDATE 
                       || pack.ARV_GWC_Medical_Transaction__c==TRANSACTIONUPDATE){
                      // Done changes as per TD-2113
                           if((bw.dentalPlan==NOD || bw.dentalPlan==NOTOFFERED) && (bw.oldDentalPlan==NOD || bw.oldDentalPlan==NOTOFFERED ||bw.oldDentalPlan==null)){
                              pack.ARV_GWC_Benefit_Package_Type__c=EXISTINGBENEFIT;
                            }
                          else{
                               pack.ARV_GWC_Benefit_Package_Type__c=MODIFYBENEFIT;
                              
                            }
                      }
                    else if((pack.ARV_GWC_CDH_Transaction__c==NOCHANGECDH || pack.ARV_GWC_CDH_Transaction__c==UPDATECDH || pack.ARV_GWC_CDH_Transaction__c==ADDCDH) &&  
                        pack.ARV_GWC_Vision_Transaction__c==NOCHANGE &&
                        pack.ARV_GWC_Dental_Transaction__c==NOCHANGE && 
                        pack.ARV_GWC_Medical_Transaction__c==NOCHANGE)
                    {
                      pack.ARV_GWC_Benefit_Package_Type__c=EXISTINGBENEFIT;
                    }
                     if(createTerminatePackage){
                         pack.ARV_GWC_Benefit_Package_Type__c=BENEFITTPACKAGEDIFFCARRIER;  
                     }
                    pack.Original_Package_Id__c=bw.groupSegmentActivePckg;
                      
                     gsSet.add(bw.groupSegmentId);   
                     gspacklist.add(pack);
                    
                    }
                    //added
                    if(createTerminatePackage){
                   List<GA_Group_Segment__c> gslist=[select id,Name,ARV_Package__c from GA_Group_Segment__c  where Name=:bw.groupSegmentName limit 1];
                    string activePck=gslist[0].ARV_Package__c;
                          Package__c pckList=[select id,ARV_Vision_Plan__c,ARV_Dental_Plan__c,ARV_Medical_Plan__c,
                                              ARV_BCN_HRA_Products__c,ARV_CDH_Combination__c,ARV_Contract_Id__c,
                                              GS_number__c,ARV_CDH_Package_Combination__c from Package__c where id=:activePck limit 1 ];
                        Package__c packTar = new Package__c();
                        string VISIONPLANTYPE= [select id,Voluntary_Contributory__c from vlocity_ins__ContractLineItem__c where id=:pckList.ARV_Vision_Plan__c].Voluntary_Contributory__c;  
                        string MEDPLANTYPE= [select id,Carrier_Type__c from vlocity_ins__ContractLineItem__c where id=:pckList.ARV_Medical_Plan__c].Carrier_Type__c;
                        packTar.name='GS-Package' +'-'+ bw.groupSegmentName+'-'+'Terminated';
                        packTar.ARV_GWC_Benefit_Package_Type__c=TERMINATE;
                        packTar.ARV_Vision_Plan__c=pckList.ARV_Vision_Plan__c;
                        packTar.ARV_Dental_Plan__c=pckList.ARV_Dental_Plan__c;
                        packTar.ARV_Medical_Plan__c=pckList.ARV_Medical_Plan__c;
                        packTar.ARV_Contract_Id__c=contractId;
                        packTar.GS_number__c=bw.groupSegmentName;
                        packTar.ARV_Plan_Package_Combinations__c=PLANCOMB;
                        packTar.ARV_CDH_Package_Combination__c=pckList.ARV_CDH_Package_Combination__c;
                        packTar.ARV_Tech_GWC_Legacy_Id__c=bw.groupSegmentName;
                        packTar.RecordtypeId=RecTypeId;
                        if(MEDPLANTYPE == ARV_AP41_StringLiteralUtils.BCBSTYPE && VISIONPLANTYPE== ARV_AP41_StringLiteralUtils.VOLUNTARY ){
                            packTar.ARV_Pediatric_Vision_Plan__c=prdidmap.get(pedVisionPrdId);
                            }else{}
                         gspacklist.add(packTar);
                    }
                    
               }
              // }
                
            }
                    List<object> deletedGS= (List<object>)input.get(deletedGSArr);
                    Map<string,Object> strObjectMap;
                    set<id> GroupSegmentsdeleted=new Set<id>();
                    Set<String> gsdeleted=new Set<String>();
                    Map<Id,String> deletedgrpseg=new Map<Id,String>();
                    for(object gsdel: deletedGS){
                    strObjectMap = (map<String, Object>)gsdel;
                    GroupSegmentsdeleted.add(String.valueOf(strObjectMap.get(groupSegmentId)));
                    deletedgrpseg.put(String.valueOf(strObjectMap.get(groupSegmentId)),String.valueOf(strObjectMap.get(groupSegmentName)));
                    gsdeleted.add(String.valueOf(strObjectMap.get(groupSegmentName)));
                    }
                    List<GA_Group_Segment__c> gslistdel=[select id,Name,ARV_Pending_PackageId__c,status__c from GA_Group_Segment__c  where Name in:gsdeleted AND status__c='Active'];
                    system.debug('gslistdel::'+gslistdel);
                    system.debug('gslistdel size::'+gslistdel.size());
                    if(gslistdel.size()>0)
                    {
                     for(GA_Group_Segment__c gs:gslistdel){
                      Package__c packTerm = new Package__c();
                      packTerm.ARV_Vision_Plan__c=null;
                      packTerm.ARV_Dental_Plan__c=null;
                      packTerm.ARV_Medical_Plan__c=null;
                      packTerm.ARV_GWC_Benefit_Package_Type__c=TERMINATE;
                      packTerm.name='GS-Package' +ARV_AP41_StringLiteralUtils.SEPERATEDVAL+gs.Name+ARV_AP41_StringLiteralUtils.SEPERATEDVAL+'Terminated';
                      packTerm.ARV_Tech_GWC_Legacy_Id__c=gs.Name;
                      packTerm.RecordtypeId=RecTypeId;
                      packTerm.GS_number__c=gs.Name;
                      packTerm.ARV_Contract_Id__c=contractId;
                      gspacklist.add(packTerm);
                     }
                    }
            if(gspacklist.size()>0){
                database.insert(gspacklist);
                //system.debug('gspacklist size::'+gspacklist.size());
            }
            if(gspacklist.size()>0){
              /*List<Package__c> pckfinal= [select id,  ARV_GWC_Benefit_Package_Type__c, GS_number__c from  Package__c where ARV_GWC_Benefit_Package_Type__c='Terminated'];  
              Map<string,Id> mapVal=new Map<string,Id>();
              set<string> gsName=new set<string>();
              if(!pckfinal.isEmpty()){
                  for(Package__c pck:pckfinal){
                      gsName.add(pck.GS_number__c);
                    mapVal.put(pck.GS_number__c,pck.Id);
                 }
                       

                 List<GA_Group_Segment__c> gslist=[select id,Name,ARV_Pending_PackageId__c from GA_Group_Segment__c  where Name in:gsName];
                 List<GA_Group_Segment__c> gslistupddate=new list<GA_Group_Segment__c>();
                    GA_Group_Segment__c gsdec;
                    for(GA_Group_Segment__c ga:gslist){
                         gsdec=new GA_Group_Segment__c();
                         gsdec.Id=ga.Id;
                         gsdec.ARV_Pending_PackageId__c=mapVal.get(ga.Name);
                         gslistupddate.add(gsdec);
                    }
                 
                    if(gslistupddate.size()>0){
                    update gslistupddate;
                    }
                    
              }*/
                List<Contract> cntList=[Select Id,GWC_Request_Type__c  from contract where id=:contractId];
                    for(Contract cnt:cntList){
                    cnt.GWC_Request_Type__c=TERMINATE+ARV_AP41_StringLiteralUtils.SEPERATOR+BENEFITTPACKAGEDIFFCARRIER;
                    }
                    update cntList;
              
            }
            
            /*locationlist=jsonToListLocation(input.get(LOCATIONGS));
            if(locationlist!=null){  
            for(BenefitWrapperLocation bl : locationlist)
            {
            // RecTypeId= Schema.getGlobalDescribe().get('Package__c').getDescribe().getRecordTypeInfosByName().get('Group Segment Package').getRecordTypeId();
              // List<GA_Group_Segment__c> gslistlc=[select id,Name,ARV_Package__c from GA_Group_Segment__c  where Name=:bl.GroupSegmentName limit 1];
              // string activePcklc=gslistlc[0].ARV_Package__c;
              system.debug('inside loop');
                Package__c pckListlc=[select id,ARV_Vision_Plan__c,ARV_Dental_Plan__c,ARV_Medical_Plan__c,
                                              ARV_CDH_Combination__c,ARV_Contract_Id__c,
                                              GS_number__c,ARV_CDH_Package_Combination__c,ARV_GWC_Package_Change_Attributes__c,ARV_Tech_GWC_Legacy_Id__c,ARV_GWC_CDH_Transaction__c,ARV_GWC_Medical_Transaction__c,ARV_GWC_Dental_Transaction__c,ARV_GWC_Vision_Transaction__c,Original_Package_Id__c,ARV_Plan_Package_Combinations__c from Package__c where ARV_Tech_GWC_Legacy_Id__c=:bl.GroupSegmentName and ARV_Contract_Id__c=:contractId limit 1 ];
                 
                       blobmaplc.put(NEWLOC, bl.LocationName);
                        blobmaplc.put(ZIPCODE, bl.ZipCode);
                          if(bl.County.get(NAME)!='N/A')
                                    {
                                    GA_County_Code__c physicalcounty=[select id,name from GA_County_Code__c where name=:bl.County.get('name') limit 1];
                                     blobmaplc.put(COUNTY, physicalcounty.id);
                                    }
                   
                        blobmaplcdata=JSON.serialize(blobmaplc);
                      
                        packLc= pckListlc.clone(false, true, false, false);
                        packLc.name='GS-Package' +'-'+ bl.GroupSegmentName+'_Add Location'; 
                        packLc.ARV_GWC_Benefit_Package_Type__c='Add Location';
                        packlc.ARV_GWC_Package_Change_Attributes__c =blobmaplcdata+pckListlc.ARV_GWC_Package_Change_Attributes__c; 
                        
                          packlistlcloc.add(packLc);          
            }
        }
           
             if(packlistlcloc.size()>0){
                database.insert(packlistlcloc);
                
            } */    
              
            
           
            if(flag==ARV_AP41_StringLiteralUtils.FALSE_VALUE){
                flag=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                deletePackages(input,output,options);
            }
        }
        
    /*****************************************************************************************
    Method Name   : jsonToList
    Date Created : 29/09/2020
    Created By   : IDC Offshore
    Description  : This is the class for packages creation
    ******************************************************************************************/
        public static List<BenefitWrapper> jsonToList(Object lctnJson){
            try{
                string strJson = JSON.serialize(lctnJson);
                BenefitWrapper wrap= new BenefitWrapper();
               // system.debug('strJson ::'+strJson);
                return wrap.parse(strJson);
            }catch(Exception e){  
               system.debug('Error at Line no::'+e.getLineNumber());
                throw new AuraHandledException(+e.getMessage());
            }
        }
        
            /*****************************************************************************************
    Method Name   : jsonToList
    Date Created : 29/09/2020
    Created By   : IDC Offshore
    Description  : This is the class for packages creation
    ******************************************************************************************/
        public static List<BenefitWrapperLocation> jsonToListLocation(Object lctnJson){
            try{
                string strJson = JSON.serialize(lctnJson);
                BenefitWrapperLocation wrap= new BenefitWrapperLocation();
               // system.debug('strJson ::'+strJson);
                return wrap.parseLocation(strJson);
            }catch(Exception e){  
               system.debug('Error at Line no::'+e.getLineNumber());
                throw new AuraHandledException(+e.getMessage());
            }
        }
        /*****************************************************************************************
    Class Name   : BenefitWrapper
    Created By   : IDC Offshore
    Description  : This is the class for Wrapper
    ******************************************************************************************/
        public without sharing class BenefitWrapperLocation{
            public string LocationName;
            public string ZipCode;
            public string GroupSegmentName;
            public string GSName;
            public Map<string,string> County;

    /*****************************************************************************************
    Method Name   : parse
    Created By   : IDC Offshore
    Description  : This is the method for parsing
    ******************************************************************************************/     
            public List<BenefitWrapperLocation> parseLocation(String json) {
                try{
                    List<BenefitWrapperLocation> checklist=(List<BenefitWrapperLocation>) System.JSON.deserialize(json, List<BenefitWrapperLocation>.class);
                    return (List<BenefitWrapperLocation>) System.JSON.deserialize(json, List<BenefitWrapperLocation>.class);
                    
                    
                }catch(Exception e){
                    system.debug('Error at Line::'+e.getLineNumber());
                    throw new AuraHandledException('error::' +e.getMessage()+e.getlinenumber());
                }
                
            } 
        }
    /*****************************************************************************************
    Class Name   : BenefitWrapper
    Created By   : IDC Offshore
    Description  : This is the class for Wrapper
    ******************************************************************************************/
        public without sharing class BenefitWrapper{
            Public String visionPlan;
            Public  String  visVolType;
            Public String visVolContains;
            Public string visPrdId;
            Public String medicalType;
            Public String medicalPlan;
            Public string  medPrdId;
            Public String groupSegmentName;
            Public String groupSegmentActivePckg;
            Public string  groupSegmentId;
            Public String  dentalPlan;
            Public String  denVolType;
            Public  String  denVolContains;
            Public string denPrdId; 
            public string isCDHOptionSelected;
            Public Boolean isNewGS;
            public String ProductFamily;
            public String CdhPlan;
            public String selectedMedPlan;
            public String selectedDenPlan;
            public String selectedVisPlan;
            public String oldMedicalPlan;
            public String oldDentalPlan;
            public String oldVisionPlan;
            public String previousPlanMedicalType;
            public String oldDenVolType;
            public String oldvisVolType;
            public String PrevcdhPlanSelcted;
            public String previousPlanProductFamily;
            public String cdhPlanSelcted;
            public String benefitPkdAdd;
            public string groupSegmentBCNHSAOption;
            public string groupSegmentHBALevel;
            public string denPrdCode;
            public string medPrdCode;
            public string visPrdCode;
            public string olddenPrdCode;
            public string oldmedPrdCode;
            public string oldvisPrdCode;
            public string oldMedicalType;
            public boolean isAddSegLoc;
            public boolean isLocSelected;
            public string oldMedType;
            public string groupSegmentNameLoc;
            public string ZipCode;
            //public string County;
            public string medicalPlanId;
            public string oldMedicalId;
            public List<string> selectedGS;
            public Map<string,string> County;
            public string addsegprvmedtyp;
            
            // public List<String> GS-Selected;
    /*****************************************************************************************
    Method Name   : parse
    Created By   : IDC Offshore
    Description  : This is the method for parsing
    ******************************************************************************************/     
            public List<BenefitWrapper> parse(String json) {
                try{
                    List<BenefitWrapper> checklist=(List<BenefitWrapper>) System.JSON.deserialize(json, List<BenefitWrapper>.class);
                    return (List<BenefitWrapper>) System.JSON.deserialize(json, List<BenefitWrapper>.class);
                    
                    
                }catch(Exception e){
                    system.debug('Error at Line::'+e.getLineNumber());
                    throw new AuraHandledException('error::' +e.getMessage()+e.getlinenumber());
                }
                
            } 
        }
    /*****************************************************************************************
    Method Name   : deletePackages
    Created By   : IDC Offshore
    Description  : This is the method for deleting Packages
    ******************************************************************************************/
        public void deletePackages(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options){
           system.debug('entering::');
            string contId=String.valueof(input.get(conid));
            List<Package__c> pkglst=[select id from Package__c where ARV_Contract_Id__c=:contId];
            if(pkglst.size()>0){
                database.delete(pkglst);
            }
            
            createPackages(input,output,options);
        }
    
    }