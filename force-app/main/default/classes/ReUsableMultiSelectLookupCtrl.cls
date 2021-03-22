public class ReUsableMultiSelectLookupCtrl {
public static id recTypeIdofRegionTrrMapID =  Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region Territory Map').getRecordTypeId();
public static id recTypeIdofRegionASRMapID =  Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();
@AuraEnabled
public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList, String splQuery) {
	String searchKey = '%' + searchKeyWord + '%';
	List < sObject > returnList = new List < sObject > ();

	List<string> lstExcludeitems = new List<string>();
	for(sObject item : ExcludeitemsList ) {
		lstExcludeitems.add(item.id);
	}

	// Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records
	String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems '+ splQuery+' order by createdDate DESC limit 10';
	List < sObject > lstOfRecords = Database.query(sQuery);

	for (sObject obj: lstOfRecords) {
		returnList.add(obj);
	}
	return returnList;
}
@AuraEnabled
public static List<User> getUsers()
{
	return [SELECT Id, NAME FROM User order by id desc  ];
}
@AuraEnabled
public static List < String > getselectOptions() {
	List<String> allOpts = new List<String>();
	AggregateResult[] terrRgnList = [SELECT Territory_Region__c FROM Territory_ASR_Assignment_List__c where Active__c = true group by Territory_Region__c ];
	for (AggregateResult trASRec : terrRgnList) {
		String regionVal = (String) trASRec.get('Territory_Region__c');
		allOpts.add(regionVal);
	}
	system.debug('allOpts ---->' + allOpts);
	allOpts.sort();
	return allOpts;
}
@AuraEnabled
public static List<GA_Territory__c> getSelectedTerritories(String region)
{
	set<id> terrSet = new Set<id>();
	List<Territory_ASR_Assignment_List__c> terrtiesMapped = [Select id, Territory__c from Territory_ASR_Assignment_List__c where Territory_Region__c = :region and recordtypeid = :recTypeIdofRegionTrrMapID and Active__c = true ];
	for (Territory_ASR_Assignment_List__c trrRec : terrtiesMapped) {
		terrSet.add(trrRec.Territory__c);
	}
	return [SELECT Id, NAME FROM GA_Territory__c where id in : terrSet order by id desc ];
}

@AuraEnabled
public static List<User> getSelectedUsers(String region)
{
	set<id> aSRSet = new Set<id>();
	List<Territory_ASR_Assignment_List__c> terrtiesMapped = [Select id, ASR__c from Territory_ASR_Assignment_List__c where Territory_Region__c = :region and recordtypeid = :recTypeIdofRegionASRMapID and Active__c = true ];
	for (Territory_ASR_Assignment_List__c trrRec : terrtiesMapped) {
		aSRSet.add(trrRec.ASR__c);
	}
	return [SELECT Id, NAME FROM User where id in : aSRSet order by id desc  ];
}


@AuraEnabled
public static void  saveChanges(String varRegjion, List<GA_Territory__c> varTerritories, List<User> varUsers )
{
	System.debug('Param Regjion' + varRegjion);
	System.debug('Param varTerritories' + varTerritories);
	System.debug('Param varUsers' + varUsers);
	set<id> selectedTerrIDSet = new Set<Id>();

	map<id, Territory_ASR_Assignment_List__c> trIdTRAmap = new map<id, Territory_ASR_Assignment_List__c>();
	map<id, Territory_ASR_Assignment_List__c> usrIdTRAmap = new map<id, Territory_ASR_Assignment_List__c>();
	List<Territory_ASR_Assignment_List__c> upsertList = new List<Territory_ASR_Assignment_List__c>();
	List<Territory_ASR_Assignment_List__c> terrtiesASRMapped = [Select id, ASR__c, Territory__c,ASR__r.id, Territory__r.id, recordtypeid, Active__c from Territory_ASR_Assignment_List__c where
	                                                            Territory_Region__c = :varRegjion ];


	System.debug('Fetch terrtiesASRMapped' + terrtiesASRMapped);
	for (Territory_ASR_Assignment_List__c terrASSRec : terrtiesASRMapped) {
		if (terrASSRec.Recordtypeid == recTypeIdofRegionTrrMapID) {
			terrASSRec.Active__c = false;
			trIdTRAmap.put(terrASSRec.Territory__r.id, terrASSRec);
		}
		else if (terrASSRec.Recordtypeid == recTypeIdofRegionASRMapID) {
			terrASSRec.Active__c = false;
			usrIdTRAmap.put(terrASSRec.ASR__r.id, terrASSRec);
		}
	}

	for (GA_Territory__c terrRec : varTerritories) {
		if (trIdTRAmap.get(terrRec.id) != null ) {
			Territory_ASR_Assignment_List__c terrASRRec = trIdTRAmap.get(terrRec.id);
			terrASRRec.Active__c = true;
			trIdTRAmap.put(terrRec.id, terrASRRec);
		}
		else {
			Territory_ASR_Assignment_List__c terrASRRec = new  Territory_ASR_Assignment_List__c();
			terrASRRec.Name = varRegjion;
			terrASRRec.Territory__c = terrRec.id;
			terrASRRec.Active__c = true;
			terrASRRec.Territory_Region__c = varRegjion;
			terrASRRec.Recordtypeid = recTypeIdofRegionTrrMapID;
			trIdTRAmap.put(terrRec.id, terrASRRec);
		}
	}

	for (User userRec : varUsers) {
		if (usrIdTRAmap.get(userRec.id) != null ) {
			Territory_ASR_Assignment_List__c terrASRRec = usrIdTRAmap.get(userRec.id);
			terrASRRec.Active__c = true;
			usrIdTRAmap.put(userRec.id, terrASRRec);
		}
		else {
			Territory_ASR_Assignment_List__c terrASRRec = new  Territory_ASR_Assignment_List__c();
			terrASRRec.Name = varRegjion + 'ASR';
			terrASRRec.ASR__c = userRec.id;
			terrASRRec.Active__c = true;
			terrASRRec.Territory_Region__c = varRegjion;
			terrASRRec.Recordtypeid = recTypeIdofRegionASRMapID;
			usrIdTRAmap.put(userRec.id, terrASRRec);
		}
	}
	upsertList.addall(trIdTRAmap.values());
	upsertList.addall(usrIdTRAmap.values());
	upsert upsertList;
	System.debug('List upsertList' + upsertList);
}


@AuraEnabled
public static List<Territory_ASR_Assignment_List__c>  checkValidTerr(String varRegjion, List<GA_Territory__c> varTerritories, List<User> varUsers ){
	List<Territory_ASR_Assignment_List__c> terrtieschkMapped = [select id, name, Territory__r.Name, Territory_Region__c  from Territory_ASR_Assignment_List__c 
	where Territory_Region__c !=:varRegjion and Active__c = true and recordtypeid =: recTypeIdofRegionTrrMapID and  Territory__c in : varTerritories];
	return terrtieschkMapped; 
}

@AuraEnabled
public static void  addRegionPicListValue(String varRegjion){
}

@AuraEnabled
public static void  deleteRegionAssigments(String varRegjion){
	List<Territory_ASR_Assignment_List__c> finallist = new List<Territory_ASR_Assignment_List__c>(); 
	List<Territory_ASR_Assignment_List__c> terrtiesMapped1 = [Select id, Territory__c, Active__c from Territory_ASR_Assignment_List__c where Territory_Region__c = :varRegjion and recordtypeid = :recTypeIdofRegionTrrMapID and Active__c = true ];

	List<Territory_ASR_Assignment_List__c> terrtiesMapped2 = [Select id, ASR__c, Active__c  from Territory_ASR_Assignment_List__c where Territory_Region__c = :varRegjion and recordtypeid = :recTypeIdofRegionASRMapID and Active__c = true ];

	for (Territory_ASR_Assignment_List__c terrRec : terrtiesMapped1) {
		terrRec.Active__c = false ; 
		finallist.add(terrRec); 
	}
	for (Territory_ASR_Assignment_List__c terrRec : terrtiesMapped2) {
		terrRec.Active__c = false ; 
		finallist.add(terrRec); 
	}
	 update finallist; 
}


@AuraEnabled
public static void  renameRegion(String varRegjion, String newRegionVal){
	List<Territory_ASR_Assignment_List__c> finallist = new List<Territory_ASR_Assignment_List__c>(); 
	List<Territory_ASR_Assignment_List__c> terrtiesMapped1 = [Select id, Territory__c, Active__c, Territory_Region__c from Territory_ASR_Assignment_List__c where Territory_Region__c = :varRegjion and recordtypeid = :recTypeIdofRegionTrrMapID ];

	List<Territory_ASR_Assignment_List__c> terrtiesMapped2 = [Select id, ASR__c, Active__c, Territory_Region__c  from Territory_ASR_Assignment_List__c where Territory_Region__c = :varRegjion and recordtypeid = :recTypeIdofRegionASRMapID  ];

	for (Territory_ASR_Assignment_List__c terrRec : terrtiesMapped1) {
		terrRec.Territory_Region__c = newRegionVal ; 
		finallist.add(terrRec); 
	}
	for (Territory_ASR_Assignment_List__c terrRec : terrtiesMapped2) {
		terrRec.Territory_Region__c = newRegionVal ; 
		finallist.add(terrRec); 
	}
	 update finallist; 
}
}