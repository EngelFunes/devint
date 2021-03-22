/*****************************************************************************************
Class Name   : ARV_AP48_PartBLookupsdataProcessing. 
Date Created : 24-DEC-2019
Created By   : IDC Offshore
Description  :This class is used to create lookups of city, county entered in partB.
******************************************************************************************/
global without sharing class ARV_AP48_PartBLookupsdataProcessing  implements vlocity_ins.VlocityOpenInterface2 {
    
    private static final string METHODNAME='fetchingLocationInfo';
	private static final string CONTXTID='ContextId';
	private static final string MNGNGAGNT='ManaginAgent';
	private static final string NBYA='N/A';
	private static final string HQSTR='HQ: ';
	private static final string TGG='TGG';
	private static final string ACTNBNFTS='Action Benefits';
	private static final string ACCAGNCY='Account - Agency';
	private static final string OOSTATE='OUT OF STATE';
    private static Id physicalCountyId=null;
	private static String physicalCntyName='';
	private static final string LOCPKGWHERECLAUSE = ' WHERE ARV_ContractId__c =:paramName ';
	private static final string CNRCTWHERECLAUSE = '  WHERE Id =:paramName ';
    private static final string GACITY_QRY='SELECT Id,Name FROM GA_City_Code__c ';
	private static final string GACITY_WHERECLAUSE=' WHERE  Name =:paramName ';
	private static final string GACITY_LIMITCLAUSE =' limit 1 ';
    private static final string GACOUNTY_QRY='SELECT Id,Name FROM GA_County_Code__c  ';
	private static final string GACOUNTY_WHERECLAUSE=' WHERE  Name =:paramName  ';
    private static final string TGGSOL='%TGG Solutions%';
    private static final string ACTNBNFTSSEARCH='%Action Benefits%';
    /*****************************************************************************************
	method Name   : invokeMethod. 	
	Description  :This class is used to create lookups of city, county entered in partB.
	******************************************************************************************/
    global static Boolean invokeMethod(String methodName, Map <String, Object> inputMap,
									   Map < String, Object > outMap, Map < String, Object > options) {
		try{
			if (methodName == METHODNAME) 
			{
				fetchingLocationInfo(inputMap,outMap,options);
			}
		}catch(Exception e){
			throw new AuraHandledException(e.getMessage()+e.getlinenumber());
			
		}
		return true;   
	}
	/*****************************************************************************************
	method Name   : fetchingLocationInfo. 	
	Description  :This class is used to create lookups of city, county entered in partB.
	******************************************************************************************/
    global static void fetchingLocationInfo(Map < String, Object > inputMap,
										  Map <String, Object > outMap, Map <String, Object > options){ 
    
		String contractId=String.valueof(inputmap.get(CONTXTID));
		String managinAgnt = String.valueof(options.get(MNGNGAGNT));
		String locationQry = System.label.ARV_CL47_LocationPackageQry;
		ARV_AP07_QueryDataHelper.paramName=contractId;
		list<LocationPackage__c> locpkgLst=ARV_AP07_QueryDataHelper.getsObjects(locationQry,LOCPKGWHERECLAUSE,null,null);
		//List<LocationPackage__c> locationList= new List<LocationPackage__c>();
		processCityAndCounties(locpkgLst);
        
		// Update COntract fields
		String contractQry = System.label.AR_CL45_CONTRACTQUERY;
		ARV_AP07_QueryDataHelper.paramName=contractId;
		List<contract> cntrctLst= ARV_AP07_QueryDataHelper.getsObjects(contractQry,CNRCTWHERECLAUSE,null,null);		
		String mvCnty =String.valueof(cntrctLst.get(0).ARV_Mutual_Voter_Mailing_County__c);
		if( mvCnty !=null) {
			cntrctLst.get(0).Mutual_Voter_Mailing_Address_County_Code__c=ARV_AP48_PartBLookupsdataProcessing.getCountyIdByName(mvCnty);
		}
		Id accountID = null;
		if( managinAgnt==TGG){
			accountID =[SELECT id,name,GA_Agency_Code__c,GA_Managing_Agency_Code__c FROM Account WHERE Name LIKE :TGGSOL AND 
                        IsPartner = true AND GA_RecordType__c =:ACCAGNCY AND GA_Agency_Code__c=null AND
                        GA_Managing_Agency_Code__c='01' limit 1].id;  
		}else if(managinAgnt ==ACTNBNFTS){
			accountID =[SELECT id,name,GA_Agency_Code__c,GA_Managing_Agency_Code__c FROM Account WHERE Name LIKE :ACTNBNFTSSEARCH AND
                        IsPartner = true AND GA_RecordType__c =:ACCAGNCY AND GA_Agency_Code__c=null AND
                        GA_Managing_Agency_Code__c='03' limit 1].id;                                            
		}                                       
		cntrctLst.get(0).ARV_Managing_Agent__c	=  accountID; 
		if(physicalCountyId !=null){
			cntrctLst.get(0).ARV_Location_Physical_County_Code__c=physicalCountyId;
			cntrctLst.get(0).ARV_Location_Physical_County__c = physicalCntyName;
		}  
		database.update(cntrctLst.get(0),false);
		// to update account
		if(locpkgLst.size()>0){
			Id accId=locpkgLst.get(0).ARV_AccountId__c;
			Account accnt = new Account(Id=accId);
			accnt.GA_Physical_County_Id__c=physicalCountyId;
			database.update(accnt,false);
		}
	}                                                                                  
    /*****************************************************************************************
	method Name  : getCountyIdByName. 	
	Description  : This method  is used to get countyId by passinf county name entered in partB.
	******************************************************************************************/
    public static Id getCountyIdByName(String name){
        Id countyId=null;
        List<GA_County_Code__c> gaCounty=new List<GA_County_Code__c>() ;
		try{  
			ARV_AP07_QueryDataHelper.paramName=name.trim();
			gaCounty=ARV_AP07_QueryDataHelper.getsObjects(GACOUNTY_QRY,GACOUNTY_WHERECLAUSE,null,
																					GACITY_LIMITCLAUSE); 
			if(gaCounty.size()>0){
				countyId=gaCounty.get(0).id;
			 
			}else{               
				ARV_AP07_QueryDataHelper.paramName=OOSTATE;
				gaCounty=ARV_AP07_QueryDataHelper.getsObjects(GACOUNTY_QRY,GACOUNTY_WHERECLAUSE,null,
																					GACITY_LIMITCLAUSE); 
			    countyId= gaCounty.get(0).id;
			}
			
		}catch(Exception e){
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
		}    
		return countyId;
    }
	/*****************************************************************************************
	method Name  : getCountyIdByName. 	
	Description  : This method  is used to get countyId by passing county name entered in partB.
	******************************************************************************************/
	private static void processCityAndCounties(list<LocationPackage__c> locpkgLst){
        List<LocationPackage__c> locationList= new List<LocationPackage__c>();
        String cityName ='';
		for(LocationPackage__c loc : locpkgLst){
			LocationPackage__c lpkg = new LocationPackage__c(id=loc.id);
			if(loc.ARV_Location_Physical_City__c !=null  ){
                cityName =ARV_AP48_PartBLookupsdataProcessing.getGACityName(loc.ARV_Location_Physical_City__c);  
				if(!String.isBlank(cityName)&& cityName != null){
					lpkg.ARV_Physical_City__c=cityName;
				}else{
					lpkg.ARV_Location_Physical_City_Other__c= loc.ARV_Location_Physical_City__c;
                    lpkg.ARV_Physical_City__c=null;
				}
			}	
			if(loc.ARV_Admin_City__c !=null){
				cityName =ARV_AP48_PartBLookupsdataProcessing.getGACityName(loc.ARV_Admin_City__c);
				if(! String.isBlank(cityName)&& cityName !=null ){
					lpkg.ARV_Admin_City_Code__c=cityName;
				}else{
					lpkg.ARV_Admin_City_Other__c= loc.ARV_Admin_City__c;
                    lpkg.ARV_Admin_City_Code__c=null;
				}
			}	
			if(loc.ARV_Billing_City__c !=null){
				cityName =ARV_AP48_PartBLookupsdataProcessing.getGACityName(loc.ARV_Billing_City__c);
				if( ! String.isBlank(cityName)&& cityName!=null){			
					lpkg.ARV_Billing_City_Code__c=cityName;
				}else{
					lpkg.ARV_Billing_City_Other__c= loc.ARV_Billing_City__c;
                    lpkg.ARV_Billing_City_Code__c=null;
				}
			}
			// To handle physical county
			String countyName =String.valueof(loc.ARV_Location_Physical_County__c); 
			String name ='';
			physicalCntyName =String.valueof(loc.ARV_Location_Physical_County__c);
			if(countyName !=null && countyName !=NBYA){
				physicalCntyName =countyName.contains(HQSTR)?countyName.substring(4,countyName.length()) :countyName;		  
				lpkg.ARV_Physical_County__c =ARV_AP48_PartBLookupsdataProcessing.getCountyIdByName(physicalCntyName);
				physicalCountyId=lpkg.ARV_Physical_County__c;
			}	  
			// to handle biling county	 ARV_Billing_County__c    ARV_Admin_County__c   
			String billCnty =String.valueof(loc.ARV_Billing_County__c);
			String bName ='';
			if(billCnty !=null){ 
				if(billCnty !=NBYA){
					bName =billCnty.contains(HQSTR)?billCnty.substring(4,billCnty.length()):billCnty;
					lpkg.ARV_Billing_County_Code__c=ARV_AP48_PartBLookupsdataProcessing.getCountyIdByName(bName);	
				}else{
					 bName =String.valueof(loc.ARV_Billing_County__c);
                     lpkg.ARV_Billing_County_Code__c=null;
				}
			}
			String admnCnty =String.valueof(loc.ARV_Admin_County__c);
			String aName ='';
			if(admnCnty !=null){
				if(admnCnty !=NBYA){
					aName =admnCnty.contains(HQSTR)?admnCnty.substring(4,admnCnty.length()):admnCnty;
				}else{
					aName =String.valueof(loc.ARV_Admin_County__c);
				}
			}
			lpkg.ARV_Admin_County_Code__c=ARV_AP48_PartBLookupsdataProcessing.getCountyIdByName(aName);         
			locationList.add(lpkg);
		}
		database.update(locationList,false);
	}
    /*****************************************************************************************
	method Name  : getGACityName. 	
	Description  : This method  is used to get GA City Name by passing city name entered in partB.
	******************************************************************************************/
    private static string getGACityName(String cityName){
        String name='';
        ARV_AP07_QueryDataHelper.paramName=cityName;				
        List<GA_City_Code__c> namefindlst =ARV_AP07_QueryDataHelper.getsObjects(GACITY_QRY,GACITY_WHERECLAUSE,null,
                                                                                GACITY_LIMITCLAUSE);  
        if(namefindlst.size()>=1){
			name=namefindlst.get(0).id;
		}
        return name;
    }
}