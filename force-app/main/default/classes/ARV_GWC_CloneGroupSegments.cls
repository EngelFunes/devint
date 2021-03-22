/*****************************************************************************************
Class Name   : ARV_GWC_CloneGroupSegments
Date Created : 29/09/2020
Created By   : IDC Offshore
Description  : This is the class for Group Segment creation.......
******************************************************************************************/
public without sharing class ARV_GWC_CloneGroupSegments  
{
    public static final String SELECT_STRING ='SELECT ';
    public static final String ID='Id';
    public static final string BCBSMCLUSTERNULL ='00';
    public static final string CLUSTERFIRSTCHAR='F';
    private static final string CLASSNAME='ARV_GWC_CloneGroupSegments';
    private static final String ENROLLMENTCENSUSID ='enrollmentCensusId';
    private static final String CONTRACTID1='contractId';
    private static final String ENROLLMENTSYSCENSUS ='Enrollment_systemCensus';
    private static final String SYSTEMCENSUSID='systemCensusId';
    public static final String STATUSCHECK='Approved – Validate Data/Setup Group Segments';
    public static final String PCKGTYPTER='Terminate';
    public static final String PCKGTYPADDBP='Add Benefit Package';
    public static final String PCKGTYPADDL='Add Location';
    public static final string METHODNAME1='cloneGroupSegmentRecord';
    public static final String GSAORobjectAPIName = 'GA_AOR_Group_Segment__c';
    public static final string METHODNAME2='cloneAORRecords';
    public static final String GAobjectAPIName = 'GA_Group_Association__c';
    public static final string METHODNAME3='cloneASSOCRecords';
	public static final String GSobjectAPIName = 'GA_Group_Segment__c';
    public static final String STATUSCHECKCM='Group Segment Setup Complete';
    public static final String BCNHSAMO='BCN HSA Member Option:';
    public static final String PENDSTAT='Pending';
    public static final String NA='Not Applicable';
    public static final String PEDIATRIC='Pediatric';
    public static final String HBALEVEL='HBA Level:';
    public static final String ADDLOCDC='Add Location Different Carrier';
    public static final String CLUSTERCODE='D720';
    public static final String ACCTYPELOCAL='Local';
    public static final String NETWORKTYPE='MOS';
    public static final String ACCTYPEHMO='HMO';
    public static final String NEWLOC='New Location:';
    public static final String ZIPCODE='ZipCode:';
    public static final String COUNTY='County:';

/*****************************************************************************************
Method Name   : cloneGroupSegmentRecord
Created By   : IDC Offshore
Description  : This is the method for group segment creation
******************************************************************************************/
   @future
    public static void cloneGroupSegmentRecord(String conId)
    {
        try{
        system.debug('calling from 103:');
        //String conId= String.valueof(input.get('contractId'));
        List<Contract> conlist=[select id,status,ARV_Requested_Effective_Date__c,ARV_GWC_AdditionalSegmentRadio__c,ARV_GWC_DeleteGSFlag__c,ARV_GWC_AddCCSegment__c,ARV_RatingArea__c,ARV_Sponsored_Plan_Acronym__c,ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,AccountId from Contract where id=: conId];

        system.debug('Status in clone Method::'+conlist[0].status);
        if(conlist[0].status==STATUSCHECK){
            updateAccount(conlist[0],conlist[0].AccountId);
            system.debug('status::'+conlist[0].status);
            system.debug('size::'+conlist.size());
        List<Package__c> packglst=[select id,name,ARV_Tech_GWC_Legacy_Id__c,ARV_Plan_Package_Combinations__c,ARV_Tech_ReqEffDate__c,ARV_GWC_Benefit_Package_Type__c,ARV_Contains_BCN_HSA__c,ARV_Contains_HBA_Product__c,ARV_Tech_Dental_Voluntary_Contributory__c,ARV_Tech_Vision_Voluntary_Contributory__c,ARV_GWC_Package_Change_Attributes__c,Package_Carrier__c  from Package__c where ARV_Contract_Id__c=:conId and ARV_GWC_Benefit_Package_Type__c!='Terminate' ];
        List<string> legacyId=new List<string>();
        for(Package__c pckg:packglst){
            System.debug('legacy++' + pckg.ARV_Tech_GWC_Legacy_Id__c);
           legacyId.add(pckg.ARV_Tech_GWC_Legacy_Id__c);
        }
        List<GA_Group_Segment__c> gslist=[select id,name,GA_Account__c,ARV_GS_Dental_Type__c,GA_HBA__c from GA_Group_Segment__c where name IN:legacyId];
        System.debug('gs ++'+gslist);
        Map<string,string> gsMap=new Map<string,string>();
        for(GA_Group_Segment__c gs:gslist){
            gsMap.put(gs.name, gs.id);
        }
        system.debug('packglst::'+packglst.size());
        List<GA_Group_Segment__c> gsslst=new List<GA_Group_Segment__c>();
        for(Package__c pkg:packglst){
            system.debug('package legacy::'+pkg.ARV_Tech_GWC_Legacy_Id__c);
            system.debug('package Type::'+pkg.ARV_GWC_Benefit_Package_Type__c);
            Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(pkg.ARV_GWC_Package_Change_Attributes__c);   
            string newcarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.newCarrier);
            string oldcarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.oldCarrier);
            string oldDenatlPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDDENTALPLAN);
            string oldVisionPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDVISIONPLAN);
            string oldMedicalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDMEDICALPLAN);
            string newMedicalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWMEDICALPLAN);
            string newDentalType=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWDENTALTYPE);
            string newVisionType=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWVISIONTYPE);
            string oldVisionType=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDVISIONTYPE);
            string oldDentalType=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDDENTALTYPE);
            if(pkg.ARV_GWC_Benefit_Package_Type__c.contains(PCKGTYPADDBP) || pkg.ARV_GWC_Benefit_Package_Type__c.contains(PCKGTYPADDL)) 
              // || (pkg.ARV_GWC_Benefit_Package_Type__c=='Modify Benefit Package' && 
               // (oldDenatlPlan.contains('Pediatric') || oldVisionPlan.contains('Pediatric') || oldVisionType=='Non-Voluntary' || oldDentalType=='Non-Voluntary') && oldcarrier==newcarrier && (newDentalType=='Voluntary' || newVisionType=='Voluntary') 
              {
                system.debug('oldDenatlPlan:'+oldDenatlPlan);
                system.debug('oldVisionPlan:'+oldVisionPlan);
                system.debug('oldVisionPlan:'+newVisionType);
                system.debug('oldVisionPlan:'+newDentalType);
                    
               if(gsMap.containsKey(pkg.ARV_Tech_GWC_Legacy_Id__c)) {
               		GA_Group_Segment__c grpsgmnt = new GA_Group_Segment__c();
               		grpsgmnt.Id= gsMap.get(pkg.ARV_Tech_GWC_Legacy_Id__c);
                	cloneGSRecord(grpsgmnt.Id,conlist[0],pkg);
                	gsslst.add(grpsgmnt);
              }
            }
       }
        
        updateCensusMem(conId);
         
        system.debug('gsslst::'+gsslst.size());
            }  
     String gwcReqEffeDate=string.valueof(conlist[0].ARV_Requested_Effective_Date__c);
     String prvreqEffectiveDate=string.valueof(conlist[0].ARV_Requested_Effective_Date__c);
     

            //createSystemCensus
            ARV_AP104_GWC_Systemcheck2_new.gwcSystemCheck2(conId,gwcReqEffeDate,prvreqEffectiveDate,conlist[0].ARV_GWC_AddCCSegment__c,conlist[0].ARV_GWC_AdditionalSegmentRadio__c,conlist[0].ARV_GWC_DeleteGSFlag__c);
		 }
            catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME1); 
        }
    }
    
/*****************************************************************************************
Method Name   : cloneAORRecords
Created By   : IDC Offshore
Description  : This is the method for AOR Records creation
******************************************************************************************/    
public static void cloneAORRecords(string aorgsId,string clonedGSId, string gsId){
        List<GA_AOR_Group_Segment__c> aorList=new List<GA_AOR_Group_Segment__c>();
        Boolean isChild = False;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        //String objectAPIName = 'GA_AOR_Group_Segment__c';
        Map<String, Schema.SObjectField> fields = schemaMap.get(GSAORobjectAPIName).getDescribe().fields.getMap();
           system.debug('fields::'+fields);
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING; 
           system.debug('Field values::'+fields.values());
           //system.debug('Field names::'+fields.getname());
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            //system.debug('fieldResult::'+fieldResult);
            //system.debug('Name::'+fieldResult.getname());
            //if(fieldResult.createable) {
               // system.debug('Is Executing');
                fieldMap.add(fieldResult.getname());
            //}
        }  
           //fieldMap.add(aorId);
           //system.debug('fieldMap:'+fieldMap);
           for (String s :fieldMap ){            
            soqlQuery +=  + s+ARV_AP41_StringLiteralUtils.COMMAVAL;          
             }
        
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +GSAORobjectAPIName +' WHERE GA_Group_Segment_Id__c = \'' + gsId + '\'' ;
        //system.debug('soqlQuery::'+soqlQuery);
        List<Sobject> records = Database.query(soqlQuery); 
         try{     
            for(Sobject srec :records){
                GA_AOR_Group_Segment__c aorRec = (GA_AOR_Group_Segment__c)srec;
                GA_AOR_Group_Segment__c gsAORclone = aorRec.clone(false, true);
                    gsAORclone.GA_Group_Segment_Id__c = clonedGSId; 
                   // System.debug(gsAORclone);
                    insert gsAORclone;
                    aorList.add(gsAORclone);
                    System.debug('clondedchildID:: '+aorList);
            }
         }
           
           catch(Exception e){
            System.debug('Error at '+e.getLineNumber());
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME2); 
           }
       }
                    
/*****************************************************************************************
Method Name   : cloneASSOCRecords
Created By   : IDC Offshore
Description  : This is the method for Group Association Records creation
******************************************************************************************/   
     public static void cloneASSOCRecords(string assocId,string clonedGSId, string gsId){
         system.debug('Calling::' + assocId + clonedGSId + gsId);
        List<GA_Group_Association__c> assocList=new List<GA_Group_Association__c>();
        Boolean isChild = False;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        //String objectAPIName = 'GA_Group_Association__c';
        Map<String, Schema.SObjectField> fields = schemaMap.get(GAobjectAPIName).getDescribe().fields.getMap();
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING;
         system.debug('field Values AoSC::'+fields.values());
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            //system.debug('fieldResult::'+fieldResult);
            if(fieldResult.createable) {
                fieldMap.add(fieldResult.getname());
            }
        }  
        for (String s :fieldMap ){            
            soqlQuery +=  + s+',';          
        }
         soqlQuery =  soqlQuery.removeEnd(',');
         system.debug('soqlQuery'+soqlQuery);
         soqlQuery += ' FROM ' +GAobjectAPIName +' Where Id = \'' + assocId +'\'' ;
          system.debug('soqlQuery1'+soqlQuery);
        List<Sobject> records = Database.query(soqlQuery); 
    try{ 
          for(Sobject srec :records){
                GA_Group_Association__c assocRec = (GA_Group_Association__c)srec;
                GA_Group_Association__c gsASSOCclone = assocRec.clone(false, true);
                gsASSOCclone.GA_External_ID__c=null;
                gsASSOCclone.GA_Group_Segment__c = clonedGSId; 
                insert gsASSOCclone;
                assocList.add(gsASSOCclone);
                
          }
            }
            catch(Exception e){
             GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME3);                         
             }      
        
  } 
 /*****************************************************************************************
Method Name   : cloneGSRecord
Created By   : IDC Offshore
Description  : This is the method for 
******************************************************************************************/      

    public static string cloneGSRecord(String gsId,Contract con,Package__c pkg){
        system.debug('hellohii::'+pkg);
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        //String objectAPIName = 'GA_Group_Segment__c';
        Map<String, Schema.SObjectField> fields = schemaMap.get(GSobjectAPIName).getDescribe().fields.getMap();
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING; 
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.createable) { //fieldResult.isUpdateable()
                fieldMap.add(fieldResult.getname());
            }
        }
        fieldMap.add(ID);    
        for (String s :fieldMap ){            
            soqlQuery +=  + s+ARV_AP41_StringLiteralUtils.COMMAVAL;          
        }
        system.debug('GS fieldMap::'+fieldMap);
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +GSobjectAPIName +' WHERE ID = \'' + gsId +'\'' ;
        system.debug('GS soqlQuery:'+soqlQuery);
        List<GA_Group_Segment__c> grpSgmntLst=new List<GA_Group_Segment__c>();
        System.debug(soqlQuery);
        GA_Group_Segment__c record = Database.query(soqlQuery);        
        GA_Group_Segment__c  clondedParentRecordID = record.clone(false, true);
        try{ 
        Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(pkg.ARV_GWC_Package_Change_Attributes__c);   
        string hbaLevel=(string)obj.get(HBALEVEL);
        string memberOption=(string)obj.get(BCNHSAMO);
        string newcarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.newCarrier);
        string oldcarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.oldCarrier);
            clondedParentRecordID.Status__c=PENDSTAT;
            clondedParentRecordID.GA_Group_Number__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            clondedParentRecordID.GA_Group_Suffix__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            clondedParentRecordID.GA_External_ID__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            clondedParentRecordID.GA_MTV_Group__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            clondedParentRecordID.GA_MTV_Group_Division__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            clondedParentRecordID.GA_Facets_Group_ID__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            clondedParentRecordID.GA_Facets_Sub_Group_Number__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            clondedParentRecordID.GA_Facets_Class_ID__c=ARV_AP41_StringLiteralUtils.NULLSTRING;
            ARV_AP59_CreateGroupSegmentRecords.contrctGrpSeg=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
       // if((pkg.ARV_GWC_Benefit_Package_Type__c=='Add Benefit Package' || pkg.ARV_GWC_Benefit_Package_Type__c=='Modify Benefit Package') && oldcarrier!=newcarrier){
            clondedParentRecordID.ARV_Pending_PackageId__c=pkg.Id;
            clondedParentRecordID.ARV_Pending_ContractId__c=con.Id;
            clondedParentRecordID.ARV_ContractID__c=con.Id;
            clondedParentRecordID.GA_Prevs_RecordID__c = gsId;
            clondedParentRecordID.ARV_BCN_HSA__c=pkg.ARV_Contains_BCN_HSA__c;
            clondedParentRecordID.GA_HBA__c=pkg.ARV_Contains_HBA_Product__c;
        if(pkg.ARV_Tech_Vision_Voluntary_Contributory__c==NA){
            clondedParentRecordID.ARV_GS_Dental_Type__c=PEDIATRIC;}
        else{
            clondedParentRecordID.ARV_GS_Dental_Type__c=pkg.ARV_Tech_Vision_Voluntary_Contributory__c;
        }
        if(pkg.ARV_Tech_Vision_Voluntary_Contributory__c==NA){
            clondedParentRecordID.ARV_GS_Vision_Type__c=PEDIATRIC;
        }
            else{
            clondedParentRecordID.ARV_GS_Vision_Type__c=pkg.ARV_Tech_Vision_Voluntary_Contributory__c;}
            clondedParentRecordID.ARV_BCN_HSA_Member_Option__c=memberOption;
            clondedParentRecordID.GA_HBA_Level__c=hbaLevel;
       clondedParentRecordID.GA_Group_Effective_Date__c= con.ARV_Requested_Effective_Date__c;
        clondedParentRecordID.GA_Benefit_Effective_Date__c=con.ARV_Requested_Effective_Date__c;
        if(newcarrier==ARV_AP41_StringLiteralUtils.BCBSTYPE){
                clondedParentRecordID.GA_Carrier__c=ARV_AP41_StringLiteralUtils.BCBSMVAL;}
        else{
            clondedParentRecordID.GA_Carrier__c=newcarrier;
        }
               if(pkg.ARV_GWC_Benefit_Package_Type__c==PCKGTYPADDL || pkg.ARV_GWC_Benefit_Package_Type__c==ADDLOCDC){
               if(pkg.Package_Carrier__c==ARV_AP41_StringLiteralUtils.BCBSTYPE){
                clondedParentRecordID.GA_Carrier__c=ARV_AP41_StringLiteralUtils.BCBSMVAL;
                }else{
                clondedParentRecordID.GA_Carrier__c=ARV_AP41_StringLiteralUtils.BCNTYPE;
                }
                }
  		if(clondedParentRecordID.GA_Carrier__c==ARV_AP41_StringLiteralUtils.BCBSMVAL){
              String associationCluster = con.ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c!=ARV_AP41_StringLiteralUtils.NULLSTRING?
               con.ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c : BCBSMCLUSTERNULL;
               String ratingAreacode = con.ARV_RatingArea__c!=ARV_AP41_StringLiteralUtils.NULLSTRING? con.ARV_RatingArea__c+associationCluster : associationCluster;
               String clusterCode = CLUSTERFIRSTCHAR+ratingAreacode;
               clondedParentRecordID.GA_Current_Cluster_Code__c=clusterCode;
               clondedParentRecordID.GA_Group_Factor_Cluster_Code__c=clusterCode;
               clondedParentRecordID.GA_Account_Type__c=ACCTYPELOCAL;
               clondedParentRecordID.Network__c=NETWORKTYPE;
              //clondedParentRecordID.GA_Rating_Type__c=ACCTYPELOCAL;
        }
        else if(clondedParentRecordID.GA_Carrier__c==ARV_AP41_StringLiteralUtils.BCNTYPE){
                clondedParentRecordID.Network__c=ARV_AP41_StringLiteralUtils.BCNTYPE;
                clondedParentRecordID.GA_Current_Cluster_Code__c=CLUSTERCODE;
                clondedParentRecordID.GA_Group_Factor_Cluster_Code__c=CLUSTERCODE;
                clondedParentRecordID.GA_Account_Type__c=ACCTYPEHMO;
            }
            clondedParentRecordID.ARV_PlanPackage_Combinations__c=pkg.ARV_Plan_Package_Combinations__c;
            Map<String, Object> pkgobj = (Map<String, Object>) JSON.deserializeUntyped(pkg.ARV_GWC_Package_Change_Attributes__c);   
            string pkgnewcarrier=(string)pkgobj.get(ARV_AP41_StringLiteralUtils.newCarrier);
            string pkgoldcarrier=(string)pkgobj.get(ARV_AP41_StringLiteralUtils.oldCarrier);
            string newLocation=(string)pkgobj.get(NEWLOC);
            string newZipcode=(string)pkgobj.get(ZIPCODE);
            string newCounty=(string)pkgobj.get(COUNTY);
            // GA_County_Code__c physicalcounty=[select id,name from GA_County_Code__c where name=:newCounty limit 1];
            /*if(pkg.ARV_GWC_Benefit_Package_Type__c=='Modify Benefit Package' && pkgnewcarrier!=pkgoldcarrier){
            clondedParentRecordID.ARV_Tech_GWC_Type__c='Add Benefit Package Different Carrier';
            }
            else{*/
                clondedParentRecordID.ARV_Tech_GWC_Type__c=pkg.ARV_GWC_Benefit_Package_Type__c;
            //}
            if(pkg.ARV_GWC_Benefit_Package_Type__c==PCKGTYPADDL || pkg.ARV_GWC_Benefit_Package_Type__c==ADDLOCDC){
                clondedParentRecordID.GA_Physical_Address_1__c=newLocation;
                clondedParentRecordID.GA_Physical_Zip__c=newZipcode;
                clondedParentRecordID.GA_Physical_County_Id__c=newCounty;
                clondedParentRecordID.GA_Billing_Address_1__c=newLocation;
                clondedParentRecordID.GA_Billing_Zip__c=newZipcode;
                clondedParentRecordID.GA_Billing_County_Id__c=newCounty;
                clondedParentRecordID.GA_Mailing_Address_1__c=newLocation;
                clondedParentRecordID.GA_Mailing_Zip__c=newZipcode;
                clondedParentRecordID.GA_Mailing_County_Id__c=newCounty;
			}
            insert clondedParentRecordID;
            grpSgmntLst.add(clondedParentRecordID);
        	system.debug('grpSgmntLst::'+grpSgmntLst.size());
            List< GA_AOR_Group_Segment__c > aorgsList =[select id from GA_AOR_Group_Segment__c where GA_Group_Segment_Id__c = :gsId ];
             /*if(aorgsList.size()>0){
               cloneAORRecords(aorgsList[0].id, clondedParentRecordID.id, gsId);          
               }*/
            List< GA_Group_Association__c > assoc =[select id from GA_Group_Association__c  where GA_Group_Segment__c = :gsId ];
            /*if(assoc.size()>0){
               cloneASSOCRecords(assoc[0].id, clondedParentRecordID.id, gsId);            
           }*/
         return clondedParentRecordID.id;
            }
        catch(Exception e){
            system.debug('Eror at::'+e.getLineNumber()+'---'+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME1); 
            return clondedParentRecordID.id;
       }
    }
/*****************************************************************************************
Method Name   : updateAccount
Created By   : IDC Offshore
Description  : This is the method for updating Account based on contract
******************************************************************************************/  

    public static void updateAccount(Contract con,string accId){
        List<Account> acclist=new List<Account>();
        Account acc=new Account(id=accId);
        acc.ShippingCity=con.ShippingCity;
        acc.ShippingCountry=con.ShippingCountry;
        acc.ShippingCountryCode=con.ShippingCountryCode;
        acc.ShippingState=con.ShippingState;
        acc.ShippingPostalCode=con.ShippingPostalCode;
        acc.ShippingStreet=con.ShippingStreet;
        acc.ShippingStateCode=con.ShippingStateCode;
        acclist.add(acc);
        if(acclist.size()>0){
            database.update(acclist);
        }
        
    }
 /*****************************************************************************************
Method Name   : updateCensusMem
Created By   : IDC Offshore
Description  : This is the method for 
******************************************************************************************/  

public static void updateCensusMem(string conId){
 system.debug('Ex:');
 Map<Id,Id> censusGS = new Map<Id,Id>();
 Map<Id,Id> GS = new Map<Id,Id>();
 list<vlocity_ins__GroupCensusMember__c> updatecensusmem= new list<vlocity_ins__GroupCensusMember__c>();

 Contract con = [select id,vlocity_ins__EnrollmentCensusId__c from Contract where id=: conId limit 1];
 List<GA_Group_Segment__c> gslist=[select id,ARV_Pending_PackageId__c from GA_Group_Segment__c 
                                              where  ARV_Pending_ContractId__c =: conId limit 500];
 for(GA_Group_Segment__c gsgmnt :gslist ){
                GS.put(gsgmnt.ARV_Pending_PackageId__c,gsgmnt.id);                              
                 }

 for(vlocity_ins__GroupCensusMember__c mem: [select id,ARV_Package__c,
                                                        ARV_Group_Segment__c
                                                        from vlocity_ins__GroupCensusMember__c where 
                                                        vlocity_ins__CensusId__c =: con.vlocity_ins__EnrollmentCensusId__c limit 500]){
            censusGS.put(mem.id,mem.ARV_Package__c);                                            
                                                        
		}
 vlocity_ins__GroupCensusMember__c updatecensus = null;                                                        
 for(vlocity_ins__GroupCensusMember__c mem1: [select id,ARV_Package__c,
                                                        ARV_Group_Segment__c
                                                        from vlocity_ins__GroupCensusMember__c where 
                                                        vlocity_ins__CensusId__c =: con.vlocity_ins__EnrollmentCensusId__c limit 500])    
  {
 	updatecensus = new vlocity_ins__GroupCensusMember__c();
 	updatecensus.id=mem1.id;
 	updatecensus.ARV_Group_Segment__c=GS.get(censusGS.get(mem1.id));
 	updatecensusmem.add(updatecensus);
  }    
	if(updatecensusmem.size()>0) {
		update updatecensusmem;
	}
 	createSystemCensus(conId,gslist);
}

/*****************************************************************************************
Method Name   : updateFutureConStatus 
Date Created : Oct 2020
Created By   : IDC Offshore
Description  :This method updates census members
******************************************************************************************/   
 public static void createSystemCensus(string conId,List<GA_Group_Segment__c> gslist) {
     system.debug('Entering this method:');
        String contractId =conId;
        Contract cont=[select id,vlocity_ins__EnrollmentCensusId__c,vlocity_ins__FinalRatingGroupCensusId__c,AccountId,status from Contract where Id =:contractId];
        try{
            if(gslist.size()>0){
            cont.status=STATUSCHECKCM;
            }
        system.debug('status in census::'+cont.status);
        Map<String, Object> ipInputJson = new Map<String, Object>();        
        Map<String, Object> ipOptions = new Map <String, Object> ();
        Map<String, Object> ipOutput = new Map <String, Object> ();                                              
        ipInputJson.put(ENROLLMENTCENSUSID,cont.vlocity_ins__EnrollmentCensusId__c);
        ipInputJson.put(CONTRACTID1,cont.Id);
        ipOutput = (Map<String,Object>)vlocity_ins.IntegrationProcedureService.runIntegrationService(ENROLLMENTSYSCENSUS,
                                                                                                     ipInputJson, ipOptions);
        String finalCensusId = (String)ipOutput.get(SYSTEMCENSUSID);
        cont.vlocity_ins__FinalRatingGroupCensusId__c = (String)ipOutput.get(SYSTEMCENSUSID);
        database.update(cont); 
        deleteCensusMembers(finalCensusId, contractId);
        system.debug('status::'+cont.status);
        }catch(Exception e){
        } 
        /*List<GA_Group_Segment__c> gslist=[select id,ARV_ContractID__c,ARV_GWC_Type__c,ARV_BCN_HRA__c,ARV_BCN_HSA__c,GA_Benefit_Effective_Date__c from GA_Group_Segment__c where ARV_Pending_ContractId__c=:cont.id];
        system.debug('gslist::'+gslist);
        ARV_AP_GWC_WorkFlowsCreation.manualWorkFlow(gslist,cont,cont.AccountId);  */                                  
    }
    
    /*****************************************************************************************
    Method Name   : deleteCensusMembers 
    Date Created : Feb 2021
    Created By   : IDC Offshore
    Description  :This method deletes Census Members from system census of contract where CM_End date is less than ContractStartDate
    ******************************************************************************************/   
    public static void deleteCensusMembers(String systemCensusId, String contractId){
       //List<vlocity_ins__GroupCensusMember__c> deleteCensusMemList=new List<vlocity_ins__GroupCensusMember__c>();
       List<Contract> contractList = [Select StartDate,Base_Rate_Effective_Date__c from contract where Id =:contractId limit 1];
       Date contractStartDate = contractList[0].StartDate;
       Date contractBaseEffDate = contractList[0].Base_Rate_Effective_Date__c;
       List<vlocity_ins__GroupCensusMember__c> censusMemList=[Select id,CM_End_Date__c from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c =:systemCensusId AND CM_End_Date__c!=null AND (CM_End_Date__c < :contractStartDate AND CM_End_Date__c < :contractBaseEffDate) limit 500];
     
       if(censusMemList.size()>0){
           database.delete(censusMemList);
       }
    }
}