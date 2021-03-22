/** Class Name  : GA_GS_MassAddressUpdateController
* Project / CR  : BCBSM
* Description   : This controller class for Address Association Lighting Component.
* Created On    : 01/06/2020

* Modification Log:
* --------------------------------------------------------------------------------------------------------------------------------------
* Date             Developer           Description
* --------------------------------------------------------------------------------------------------------------------------------------
* 01/06/2020       Rahul      			Created
*
*/
public class GA_GS_MassAddressUpdateController 
{
	// Get all GS records for the account record
    @AuraEnabled
    public static List<GrpSegmntWrapper> getRelatedRecords(String recordId) 
    {
        List<GrpSegmntWrapper> gSWrperLst = new List<GrpSegmntWrapper>();
     
        for(GA_Group_Segment__c objGS : [SELECT Id, Name, GA_Group_Name__c, Network__c, GA_Is_Selected__c FROM GA_Group_Segment__c WHERE GA_Account__c =:recordId])
        {
            GrpSegmntWrapper obj = new GrpSegmntWrapper();
            obj.gsId = objGS.Id;
            obj.Name = objGS.Name;
            obj.GsName = objGS.GA_Group_Name__c;
            obj.isSelected = true;
            
            gSWrperLst.add(obj);
        }
        if(gSWrperLst.size() > 0)
            return gSWrperLst;
        
        return null;
    }
    
    //This method is to validate logged in user access
    @AuraEnabled
    public static String validateLoginUser(String recordId) 
    {
        System.debug('===login user id==='+UserInfo.getUserId() );
        String profileName = [Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        System.debug('===profileName==='+profileName);
        
        GA_Mass_Address_Update_Access__c mssAddressUpdtAccess = GA_Mass_Address_Update_Access__c.getInstance();
        if(mssAddressUpdtAccess.Access__c)
        {
            return 'Eligible';
        }
        else
        {
        	return 'Not Eligible';    
        }
    }
    
    // List<String> lstGrpSegments, String destinationSelected
    @AuraEnabled
    public static String massUpdateGrpSegments(String recordId, List<String> lstGrpSegments, String sourceSelected, String destinationSelected)  
    {
        Set<String> setDestinations = new Set<String>();
        if(destinationSelected.contains(','))
        {
        	setDestinations.addAll(destinationSelected.split(','));    
        }
        else
        {
        	setDestinations.add(destinationSelected);    
        }
        List<GA_Group_Segment__c> lstGSForUpdate = new List<GA_Group_Segment__c>();
        
        Account objAcc = [SELECT Id, Name,ShippingCity, ShippingState, ShippingCountry, ShippingStreet, ShippingPostalCode, GA_Physical_County_Id__c, BillingCity, BillingState, BillingCountry, BillingStreet, BillingPostalCode, GA_Mailing_County_id__c FROM Account WHERE Id=:recordId];
        Map<String, Id> mapCityCodes = new Map<String, Id>();
        Map<String, String> mapCountyCodes = new Map<String, String>();
        
        for(GA_City_Code__c objCity : [SELECT Id, Name FROM GA_City_Code__c])
        {
        	mapCityCodes.put(objCity.Name, objCity.Id);	    
        }
        
        for(GA_County_Code__c objCnty : [SELECT Id, Name FROM GA_County_Code__c])
        {
        	mapCountyCodes.put(objCnty.Id, objCnty.Name);	    
        }
        
        for(GA_Group_Segment__c objGS : [SELECT Id,Name, GA_Billing_Address_1__c, GA_Billing_Zip__c, GA_Billing_State__c, GA_Billing_County_Id__c, 
                                         		GA_Billing_City__c, GA_Physical_City__c, GA_Physical_County_Id__c, GA_Physical_Address_1__c, GA_Physical_Zip__c,
                                         		GA_Physical_State__c,GA_Mailing_City__c, GA_Mailing_County_Id__c, GA_Mailing_Address_1__c, GA_Mailing_Zip__c, GA_Mailing_State__c 
                                         		FROM GA_Group_Segment__c 
                                         		WHERE Id IN : lstGrpSegments])
        {
            GA_Group_Segment__c objGrpSegment = new GA_Group_Segment__c(Id=objGS.Id);
            //Mapping account fields to GS fields
            if(sourceSelected == 'mailing')
            {
                if(setDestinations.contains('billing'))
                {
                    objGrpSegment.GA_Billing_Address_1__c = objAcc.BillingStreet;
                    objGrpSegment.GA_Billing_Zip__c = objAcc.BillingPostalCode ;
                    objGrpSegment.GA_Billing_State__c = objAcc.BillingState ;
                    objGrpSegment.GA_Billing_County_Id__c = objAcc.GA_Mailing_County_id__c;
                    if(mapCityCodes.containsKey(objAcc.BillingCity))
                        objGrpSegment.GA_Billing_City__c = mapCityCodes.get(objAcc.BillingCity);
                }
                if(setDestinations.contains('mailing'))
                {
                    objGrpSegment.GA_Mailing_Address_1__c = objAcc.BillingStreet;
                    objGrpSegment.GA_Mailing_Zip__c = objAcc.BillingPostalCode ;
                    objGrpSegment.GA_Mailing_State__c = objAcc.BillingState ;
                    objGrpSegment.GA_Mailing_County_Id__c = objAcc.GA_Mailing_County_id__c;  
                    if(mapCityCodes.containsKey(objAcc.BillingCity))
                        objGrpSegment.GA_Mailing_City__c = mapCityCodes.get(objAcc.BillingCity);
                 }
                
                if(setDestinations.contains('physical'))
                {
                    objGrpSegment.GA_Physical_Address_1__c = objAcc.BillingStreet;
                    objGrpSegment.GA_Physical_Zip__c = objAcc.BillingPostalCode ;
                    objGrpSegment.GA_Physical_State__c = objAcc.BillingState ;
                    objGrpSegment.GA_Physical_County_Id__c = objAcc.GA_Mailing_County_id__c;    
                    if(mapCityCodes.containsKey(objAcc.BillingCity))
                        objGrpSegment.GA_Physical_City__c = mapCityCodes.get(objAcc.BillingCity);
                }
            }
			else if(sourceSelected == 'physical') 
            {
            	if(setDestinations.contains('billing'))
                {
                    objGrpSegment.GA_Billing_Address_1__c = objAcc.ShippingStreet;
                    objGrpSegment.GA_Billing_Zip__c = objAcc.ShippingPostalCode ;
                    objGrpSegment.GA_Billing_State__c = objAcc.ShippingState ;
                    objGrpSegment.GA_Billing_County_Id__c = objAcc.GA_Physical_County_Id__c;
                    if(mapCityCodes.containsKey(objAcc.ShippingCity))
                        objGrpSegment.GA_Billing_City__c = mapCityCodes.get(objAcc.ShippingCity);
                }
                
                if(setDestinations.contains('mailing'))
                {
                    objGrpSegment.GA_Mailing_Address_1__c = objAcc.ShippingStreet;
                    objGrpSegment.GA_Mailing_Zip__c = objAcc.ShippingPostalCode ;
                    objGrpSegment.GA_Mailing_State__c = objAcc.ShippingState ;
                    objGrpSegment.GA_Mailing_County_Id__c = objAcc.GA_Physical_County_Id__c;
                    if(mapCityCodes.containsKey(objAcc.ShippingCity))
                        objGrpSegment.GA_Mailing_City__c = mapCityCodes.get(objAcc.ShippingCity);
                 }
                
                if(setDestinations.contains('physical'))
                {
                    objGrpSegment.GA_Physical_Address_1__c = objAcc.ShippingStreet;
                    objGrpSegment.GA_Physical_Zip__c = objAcc.ShippingPostalCode ;
                    objGrpSegment.GA_Physical_State__c = objAcc.ShippingState ;
                    objGrpSegment.GA_Physical_County_Id__c = objAcc.GA_Physical_County_Id__c;
                    if(mapCityCodes.containsKey(objAcc.ShippingCity))
                        objGrpSegment.GA_Physical_City__c = mapCityCodes.get(objAcc.ShippingCity);
                }	    
            }
            if(objGrpSegment.GA_Physical_State__c == 'Michigan')
				objGrpSegment.GA_Physical_State__c = 'MI';
            if(objGrpSegment.GA_Mailing_State__c == 'Michigan')
				objGrpSegment.GA_Mailing_State__c = 'MI';
            if(objGrpSegment.GA_Billing_State__c == 'Michigan')
				objGrpSegment.GA_Billing_State__c = 'MI';
                
            lstGSForUpdate.add(objGrpSegment);
        }
        if(lstGSForUpdate.size() > 0)
        {
            //Update lstGSForUpdate;
            Database.SaveResult[] saveResultList = Database.update(lstGSForUpdate, false);
			
            List<String> lstFailedRecords = new List<String>();
            // Iterate through saveResultList based on isSuccess capture the failed records
            for (Database.SaveResult sr : saveResultList) 
            {
                if (sr.isSuccess()) 
                {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('=====Successfully updated GS record: ' + sr.getId());
                }
                else 
                {
                    // Operation failed, so get all errors   
                    if(sr.getId() != null && sr.getId() != '')
                    {
                        GA_Group_Segment__c objGSegment = [SELECT Id,Name FROM GA_Group_Segment__c  WHERE Id=:sr.getId() ];
                        lstFailedRecords.add(objGSegment.Name);
                    }
                    else
                    {
                    	for(Database.Error err : sr.getErrors()) 
                        {
                            return 'ERROR :'+err.getMessage();
                        }     
                    }
                    
                }
            }
            if(lstFailedRecords.size() > 0 )
            {
                return 'ERROR record names :'+lstFailedRecords; 
            }
        }   
        return 'Success';
    }

    
     /**
    @Description: GrpSegmntWrapper wrapper 
    @Name : GrpSegmntWrapper
    @Param : N/A
    @Return : N/A
    @throws Exception : N/A;
    */     
    public without sharing class GrpSegmntWrapper{
        @AuraEnabled
        public String gsId {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String GsName {get;set;}
        public boolean isSelected {get;set;}
    }
    
}