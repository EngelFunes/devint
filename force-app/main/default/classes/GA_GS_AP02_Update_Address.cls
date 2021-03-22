/**
@Author : Dilip
@Name: GA_GS_AP02_Update_Address
@CreatedDate: 8 - June 2018 
@Description: GA_GS_AP02_Update_Address class is for updation of address fields in Group Segment object.
@version : 1.0  
*/ 
public with sharing class GA_GS_AP02_Update_Address {
    public static boolean isExecuting = false;
    public static boolean isExecutingFutr = false;
    public static boolean isInvoked = false;
    public static final string updteErrMsg = 'Unable to update Address :';
    public static final string ClsName  ='GA_GS_AP02_Update_Address';
    public static final string pTM  ='Physical to Mailing';
    public static final string mTP  ='Mailing to Physical';
    public static final string bTM  ='Billing to Mailing';
    public static final string bTP  ='Billing to Physical';
    public static final string mTB  ='Mailing to Billing';
    public static final string pTB  ='Physical to Billing';
    public static final string othr  ='OTHER';
    public static final string Nne  ='None';
    public static final string methodNme  ='updateAddress';
    public static final string methodName  ='updateCity';
    public static final string cityID = System.Label.GA_OtherCityID;
    public static  Map<Id,Id> GrpCityMap ;
    public static final string phyShwNotify ='Invalid selection in Physical City';
    public static final string phyErrMsg ='Please enter Other (Physical City).';
    public static final string invalidCity ='Please enter a valid city name.';
    public static final string selCity ='Please select “Other” for the City.';
    public static final string bilShwNotify ='Invalid selection in Billing City';
    public static final string bilErrMsg ='Please enter Other (Billing City).';
    public static final string mailShwNotify ='Invalid selection in Mailing City';
    public static final string mailErrMsg ='Please enter Other (Mailing City).';
    public static final string BLANK ='';
    public static final string TILDE ='~';
    public static final string selectQry ='Select id,name from GA_City_Code__c';
    public static final string whereClause = ' where name in ';
    public static final string limitClause =' Limit 5000';
    public static final string physicalCity ='GA_Physical_City__c';
    public static final string billingCity ='GA_Billing_City__c';
    public static final string mailingCity ='GA_Mailing_City__c';
    public static final string ID ='Id';
    public static final string miState ='MI';
    public static final string outofState ='OUT OF STATE';
    public static final string MultiCopyToMail  ='Please select either "Physical to Mailing" or "Billing to Mailing". You cannot select both.';
    public static final string MultiCopyToPhy  ='Please select either "Mailing to Physical" or "Billing to Physical". You cannot select both.'; 
    public static final string MultiCopyToBllng = 'Please select either "Mailing to Billing" or "Physical to Billing". You cannot select both.';
    public static final string BFldsMadtry  ='Please populate all the Billing Address fields.';
    public static final string PFldsMadtry  ='Please populate all the Physical Address fields.';
    public static final string MFldsMadtry  ='Please populate all the Mailing Address fields.';
    public static final string copyBillingErr  ='You do not have privilege to copy Mailing or Physical  to Billing';
    public static final string copyPMErr  ='You do not have privilege to copy Physical to Mailing or Mailing  to Physical';
    public static  Boolean user_has_permission = false;
    public static final string profIntUser='Integration User'; // Added by Steve
    /**
@Description: updateCity() method 
@Name : updateCity
@Param : list<GA_Group_Segment__c> gSList , Map<id,GA_Group_Segment__c> gSOldMap  
@Return : void
@throws Exception : N/A;
*/     
    public static void updateCity(list<GA_Group_Segment__c> gSList , Map<id,GA_Group_Segment__c> gSOldMap) {
        try
        {
            for(GA_Group_Segment__c gs : gSList){
                if(gs.GA_Physical_City_Name__c !=null)
                {
                    if(gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr) && String.IsEmpty(gs.GA_Physical_City_Other__c) ){
                        gs.addError(phyErrMsg);
                    }
                    if(gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr) && gs.GA_Physical_City_Other__c!= null && gs.GA_Physical_City_Other__c.equalsIgnoreCase(othr)){
                        gs.GA_Physical_City_Other__c.addError(invalidCity);
                    }   
                    if(gs.GA_Physical_City_Other__c!=null && !gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr)){
                        gs.GA_Physical_City__c.addError(selCity);
                    }
                }
                else if(gs.GA_Physical_City_Other__c!=null && gs.GA_Physical_City__c==null){
                    gs.GA_Physical_City__c.addError(selCity);
                }
                else
                {
                    gs.GA_Physical_City_Other__c=BLANK;   
                }
                
                if(gs.GA_Billing_City_Name__c !=null)
                {
                    if(gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr) && String.IsEmpty(gs.GA_Billing_City_Other__c) ){
                        gs.addError(bilErrMsg);
                    }
                    if(gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr) && gs.GA_Billing_City_Other__c != null && gs.GA_Billing_City_Other__c.equalsIgnoreCase(othr)){
                        gs.GA_Billing_City_Other__c.addError(invalidCity);
                    }
                    if(gs.GA_Billing_City_Other__c!=null && !gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr)){
                        gs.GA_Billing_City__c.addError(selCity);
                    }  
                }
                else if(gs.GA_Billing_City_Other__c!=null && gs.GA_Billing_City__c==null){
                    gs.GA_Billing_City__c.addError(selCity);
                }
                else
                {
                    gs.GA_Billing_City_Other__c=BLANK;   
                }
                if( gs.GA_Mailing_City_Name__c !=null)
                {
                    if(gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr) && String.IsEmpty(gs.GA_Mailing_City_Other__c) ){
                        gs.addError(mailErrMsg);
                    }  
                    if(gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr) && gs.GA_Mailing_City_Other__c!= null && gs.GA_Mailing_City_Other__c.equalsIgnoreCase(othr)){
                        gs.GA_Mailing_City_Other__c.addError(invalidCity);
                    }
                    if(gs.GA_Mailing_City_Other__c!=null && !gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr)){
                        gs.GA_Mailing_City__c.addError(selCity);
                    }
                }
                else if(gs.GA_Mailing_City_Other__c!=null && gs.GA_Mailing_City__c==null){
                    gs.GA_Mailing_City__c.addError(selCity);
                }
                else
                {
                    gs.GA_Mailing_City_Other__c=BLANK;   
                }
                
            } 
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
    } 
    /**
@Description: insertCity() method 
@Name : insertCity
@Param : list<GA_Group_Segment__c> gSList
@Return : void
@throws Exception : N/A;
*/    
    public static void insertCity(list<GA_Group_Segment__c> gSList ) {
        try
        { 
            
            for(GA_Group_Segment__c gs : gSList){
                if(gs.GA_Physical_City_Name__c !=null)
                {
                    
                    if(gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr) && String.IsEmpty(gs.GA_Physical_City_Other__c) ){
                        gs.addError(phyErrMsg);
                    }
                    if(gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr) && gs.GA_Physical_City_Other__c!= null && gs.GA_Physical_City_Other__c.equalsIgnoreCase(othr)){
                        gs.GA_Physical_City_Other__c.addError(invalidCity);
                    }
                    if(gs.GA_Physical_City_Other__c!=null && !gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr)){
                        gs.GA_Physical_City__c.addError(selCity);
                    }
                }
                else if(gs.GA_Physical_City_Other__c!=null && gs.GA_Physical_City__c==null){
                    gs.GA_Physical_City__c.addError(selCity);
                }
                else
                {
                    gs.GA_Physical_City_Other__c=BLANK;
                }
                if(gs.GA_Billing_City_Name__c !=null)
                {
                    
                    if(gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr) && String.IsEmpty(gs.GA_Billing_City_Other__c) ){
                        gs.addError(bilErrMsg);
                    }
                    if(gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr) && gs.GA_Billing_City_Other__c!=null && gs.GA_Billing_City_Other__c.equalsIgnoreCase(othr)){
                        gs.GA_Billing_City_Other__c.addError(invalidCity);
                    }
                    if(gs.GA_Billing_City_Other__c!=null && !gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr)){
                        gs.GA_Billing_City__c.addError(selCity);
                    }   
                }
                else if(gs.GA_Billing_City_Other__c!=null && gs.GA_Billing_City__c==null){
                    gs.GA_Billing_City__c.addError(selCity);
                }
                else
                {
                    gs.GA_Billing_City_Other__c=BLANK;
                }
                if( gs.GA_Mailing_City_Name__c !=null)
                {
                    
                    if(gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr) && String.IsEmpty(gs.GA_Mailing_City_Other__c) ){
                        gs.addError(mailErrMsg);
                    }  
                    if(gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr) && gs.GA_Mailing_City_Other__c!= null && gs.GA_Mailing_City_Other__c.equalsIgnoreCase(othr)){
                        gs.GA_Mailing_City_Other__c.addError(invalidCity);
                    }
                    if(gs.GA_Mailing_City_Other__c!=null && !gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr)){
                        gs.GA_Mailing_City__c.addError(selCity);
                    }
                }
                else if(gs.GA_Mailing_City_Other__c!=null && gs.GA_Mailing_City__c==null){
                    gs.GA_Mailing_City__c.addError(selCity);
                }
                else
                {
                    gs.GA_Mailing_City_Other__c=BLANK;
                }
            } 
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
    } 
    /**
@Description: updateCityForBatch() method 
@Name : updateCityForBatch
@Param : list<id> gsIds
@Return : void
@throws Exception : N/A;
*/ 
    public static void updateCityForBatch(list<id> gsIds)
    {
        list<GA_Group_Segment__c> grpSGmntConldLst=new list<GA_Group_Segment__c>();
        list<GA_Group_Segment__c> gSList=[select id,GA_Physical_City_Other__c,GA_Mailing_City_Other__c,
                                          GA_Billing_City_Other__c,GA_Physical_City__c,
                                          GA_Billing_City__c,GA_Mailing_City__c,
                                          GA_Physical_City__r.Name,GA_Billing_City__r.Name,GA_Mailing_City__r.Name,
                                          GA_Billing_Address_1__c,GA_Billing_State__c,GA_Billing_County_Id__c,
                                          GA_Billing_Zip__c,GA_Physical_Address_1__c,GA_Physical_State__c,
                                          GA_Physical_County_Id__c,GA_Physical_Zip__c,GA_Mailing_Address_1__c,
                                          GA_Mailing_State__c,GA_Mailing_County_Id__c,GA_Mailing_Zip__c ,GA_Copy_Address_From__c,
                                          GA_Billing_Address_2__c,GA_Billing_Address_3__c,GA_Physical_Address_2__c,
                                          GA_Physical_Address_3__c,GA_Mailing_Address_2__c,GA_Mailing_Address_3__c  
                                          from GA_Group_Segment__c where id in:gsIds Limit 50000 FOR UPDATE];
        
        Map<Id,String> grpSgmntOutOfStateMap =  New Map<Id,String>();
        Set<String> outOfStateLst =  New Set<String>();
        for(GA_Group_Segment__c gs : gSList){
            if((!String.IsEmpty(gs.GA_Physical_City_Other__c) || 
                !String.IsEmpty(gs.GA_Mailing_City_Other__c) ||
                !String.IsEmpty(gs.GA_Billing_City_Other__c))){
                    grpSgmntOutOfStateMap.put(gs.id,gs.GA_Physical_City_Other__c
                                              +TILDE+gs.GA_Billing_City_Other__c
                                              +TILDE+gs.GA_Mailing_City_Other__c);
                    if(!String.IsEmpty(gs.GA_Physical_City_Other__c) && gs.GA_Physical_City__c!=null && gs.GA_Physical_City__r.Name.equalsIgnoreCase(othr))
                        outOfStateLst.add(gs.GA_Physical_City_Other__c);
                    if(!String.IsEmpty(gs.GA_Mailing_City_Other__c) && gs.GA_Mailing_City__c!=null && gs.GA_Mailing_City__r.Name.equalsIgnoreCase(othr))  
                        outOfStateLst.add(gs.GA_Mailing_City_Other__c);
                    if(!String.IsEmpty(gs.GA_Billing_City_Other__c) && gs.GA_Billing_City__c!=null && gs.GA_Billing_City__r.Name.equalsIgnoreCase(othr))
                        outOfStateLst.add(gs.GA_Billing_City_Other__c);
                }
        }
        if(outOfStateLst.size() > 0) {
            Map<Id,GA_City_Code__c> cityMap = GA_Util15_CityDataAccessLayerHelper.fetchCityMap(selectQry,
                                                                                               whereClause+GA_Util08_FilterProcessHelper.strSet(outOfStateLst),BLANK,limitClause);
            
            
            map<string,id> cityNmIdMap=new map<string,Id>();
            map<string,list<string>> newcityNmIdMap=new map<string,list<string>>();
            list<string> NmIdLst=new list<string>();
            for(GA_City_Code__c cty : cityMap.values()) {
                cityNmIdMap.put(cty.Name.toUpperCase(),cty.Id);
            }
            list<GA_Group_Segment__c> grpSgmntLstUpdt=new list<GA_Group_Segment__c>();
            boolean cityOther=false;
            boolean OldcityOther=false;
            String city;
            for(GA_Group_Segment__c gs : gSList){
                cityOther=false;
                OldcityOther=false;
                
                if(!String.IsEmpty(gs.GA_Physical_City_Other__c) && gs.GA_Physical_City__c!=null && gs.GA_Physical_City__r.Name.equalsIgnoreCase(othr))
                {
                    cityOther=true;
                    city = gs.GA_Physical_City_Other__c.toUpperCase();
                    if(cityNmIdMap.get(city)!=null)
                    {
                        gs.GA_Physical_City__c=  cityNmIdMap.get(city);
                        OldcityOther=true;
                    }
                    else
                    {
                        if(newcityNmIdMap.get(gs.GA_Physical_City_Other__c.toUpperCase()) !=null)
                        {
                            NmIdLst=newcityNmIdMap.get(gs.GA_Physical_City_Other__c.toUpperCase());
                        }
                        else
                            NmIdLst=new list<string>(); 
                        NmIdLst.add(gs.id+TILDE+physicalCity);
                        newcityNmIdMap.put(gs.GA_Physical_City_Other__c.toUpperCase(),NmIdLst);
                    } 
                }          
                if(!String.IsEmpty(gs.GA_Billing_City_Other__c) && gs.GA_Billing_City__c!=null && gs.GA_Billing_City__r.Name.equalsIgnoreCase(othr)) 
                {
                    cityOther=true;
                    city = gs.GA_Billing_City_Other__c.toUpperCase();
                    if(cityNmIdMap.get(city)!=null)
                    {
                        gs.GA_Billing_City__c=  cityNmIdMap.get(city);
                        OldcityOther=true;
                    }
                    else
                    {
                        if(newcityNmIdMap.get(gs.GA_Billing_City_Other__c.toUpperCase()) !=null)
                        {
                            NmIdLst=newcityNmIdMap.get(gs.GA_Billing_City_Other__c.toUpperCase());
                        }
                        else
                            NmIdLst=new list<string>(); 
                        NmIdLst.add(gs.id+TILDE+billingCity);
                        newcityNmIdMap.put(gs.GA_Billing_City_Other__c.toUpperCase(),NmIdLst);
                    }  
                }
                if(!String.IsEmpty(gs.GA_Mailing_City_Other__c) && gs.GA_Mailing_City__c!=null && gs.GA_Mailing_City__r.Name.equalsIgnoreCase(othr))  
                {
                    cityOther=true;
                    city = gs.GA_Mailing_City_Other__c.toUpperCase();
                    if(cityNmIdMap.get(city)!=null)
                    {
                        gs.GA_Mailing_City__c=  cityNmIdMap.get(city);
                        OldcityOther=true;
                    }
                    else
                    {
                        if(newcityNmIdMap.get(gs.GA_Mailing_City_Other__c.toUpperCase()) !=null)
                        {
                            NmIdLst=newcityNmIdMap.get(gs.GA_Mailing_City_Other__c.toUpperCase());
                        }
                        else
                            NmIdLst=new list<string>(); 
                        NmIdLst.add(gs.id+TILDE+mailingCity);
                        newcityNmIdMap.put(gs.GA_Mailing_City_Other__c.toUpperCase(),NmIdLst);
                    }  
                }
                if(cityOther && OldcityOther)
                    grpSgmntLstUpdt.add(gs);
                
            }
            list<GA_City_Code__c> lstNewCities=new list<GA_City_Code__c>();
            GA_City_Code__c newCty=new GA_City_Code__c();
            for(string newCtyNm:newcityNmIdMap.keySet())
            {
                newCty=new GA_City_Code__c();
                newCty.Name=newCtyNm.toUpperCase();
                lstNewCities.add(newCty);
            }
            
            if(!lstNewCities.isEmpty())
            {
                GA_Util15_CityDataAccessLayerHelper.dmlOnCity(lstNewCities, GA_Util15_CityDataAccessLayerHelper.INSERT_OPERATION );
            }
            map<id,GA_Group_Segment__c> grpToUpdteNewCity=new map<id,GA_Group_Segment__c>();
            GA_Group_Segment__c grpSgmntNwCity=new GA_Group_Segment__c();
            string ctyName;
            for(GA_City_Code__c newCtyRec:lstNewCities)
            {
                list<string> grpInfoLst=newcityNmIdMap.get(newCtyRec.Name);
                if(!grpInfoLst.isEmpty()){
                    for(string grpInfo:grpInfoLst)
                    {
                        string grpId=grpInfo.split(TILDE)[0];
                        string fieldInfo=grpInfo.split(TILDE)[1];
                        if(grpToUpdteNewCity.get(grpId) !=null)
                        {
                            grpSgmntNwCity=grpToUpdteNewCity.get(grpId);
                        }
                        else
                            grpSgmntNwCity=new GA_Group_Segment__c();
                        
                        grpSgmntNwCity.put(ID ,grpId);
                        grpSgmntNwCity.put(fieldInfo,newCtyRec.Id);
                        grpToUpdteNewCity.put(grpId,grpSgmntNwCity);
                        
                    }
                }
            }
            grpSgmntLstUpdt.addAll(grpToUpdteNewCity.Values());
            map<id,list<GA_Group_Segment__c>> grpToUpdteNewCityFltr=new map<id,list<GA_Group_Segment__c>>();
            list<GA_Group_Segment__c> grpSgmntFltr=new list<GA_Group_Segment__c>();
            for(GA_Group_Segment__c grp:grpSgmntLstUpdt)
            {
                if(grpToUpdteNewCityFltr.get(grp.id) !=null)
                {
                    grpSgmntFltr=grpToUpdteNewCityFltr.get(grp.id);
                }
                else
                    grpSgmntFltr=new list<GA_Group_Segment__c>();
                grpSgmntFltr.add(grp);
                grpToUpdteNewCityFltr.put(grp.id,grpSgmntFltr);
                
            }
            GA_Group_Segment__c grpSGmntConld=new GA_Group_Segment__c();
            for(id grpId: grpToUpdteNewCityFltr.keySet())
            {
                grpSGmntConld=new GA_Group_Segment__c();
                for(GA_Group_Segment__c grpSmt:grpToUpdteNewCityFltr.get(grpId))
                {
                    grpSGmntConld.id=grpSmt.id;
                    if(grpSmt.GA_Physical_City__c !=null)
                    {
                        grpSGmntConld.GA_Physical_City__c=grpSmt.GA_Physical_City__c;
                    }
                    if(grpSmt.GA_Billing_City__c !=null)
                    {
                        grpSGmntConld.GA_Billing_City__c=grpSmt.GA_Billing_City__c;
                    }
                    if(grpSmt.GA_Mailing_City__c !=null)
                    {
                        grpSGmntConld.GA_Mailing_City__c=grpSmt.GA_Mailing_City__c;
                    }
                    grpSGmntConld.GA_Physical_City_Other__c=BLANK;
                    grpSGmntConld.GA_Mailing_City_Other__c=BLANK;
                    grpSGmntConld.GA_Billing_City_Other__c=BLANK;
                }
                grpSGmntConldLst.add(grpSGmntConld);
            }
        }
        
        Map<Id,GA_Group_Segment__c> grpSgmntCityMap = New Map<Id,GA_Group_Segment__c>();
        if(!grpSGmntConldLst.isEmpty()){
            for(GA_Group_Segment__c gs : grpSGmntConldLst){
                grpSgmntCityMap.put(gs.Id,gs);   
            } 
        }
        
        for(GA_Group_Segment__c gs : gSList){
            if( gs.GA_Copy_Address_From__c != null)  {
                if(!grpSgmntCityMap.isEmpty()){
                    if(grpSgmntCityMap.containsKey(gs.Id)){
                        GA_Group_Segment__c cityGs = grpSgmntCityMap.get(gs.Id);
                        
                        if(!String.isEmpty(cityGs.GA_Billing_City__c) && String.valueOf(cityGs.GA_Billing_City__c).substring(0,14) != cityID ){
                            
                            gs.GA_Billing_City__c = cityGs.GA_Billing_City__c;
                        }
                        if(!String.isEmpty(cityGs.GA_Physical_City__c) && String.valueOf(cityGs.GA_Physical_City__c).substring(0,14)!= cityID){
                            gs.GA_Physical_City__c = cityGs.GA_Physical_City__c;
                        }
                        if(!String.isEmpty(cityGs.GA_Mailing_City__c) && String.valueOf(cityGs.GA_Mailing_City__c).substring(0,14)!= cityID){
                            gs.GA_Mailing_City__c = cityGs.GA_Mailing_City__c;
                        }
                    }  
                }
                if(gs.GA_Copy_Address_From__c.contains(pTM)){
                    gs.GA_Mailing_Address_1__c=gs.GA_Physical_Address_1__c;
                    gs.GA_Mailing_Address_2__c=gs.GA_Physical_Address_2__c;
                    gs.GA_Mailing_Address_3__c=gs.GA_Physical_Address_3__c;
                    gs.GA_Mailing_City__c=gs.GA_Physical_City__c;
                    gs.GA_Mailing_State__c=gs.GA_Physical_State__c;
                    gs.GA_Mailing_County_Id__c=gs.GA_Physical_County_Id__c;
                    gs.GA_Mailing_Zip__c=gs.GA_Physical_Zip__c;
                }
                if(gs.GA_Copy_Address_From__c.contains(mTP)){
                    gs.GA_Physical_Address_1__c=gs.GA_Mailing_Address_1__c;
                    gs.GA_Physical_Address_2__c=gs.GA_Mailing_Address_2__c;
                    gs.GA_Physical_Address_3__c=gs.GA_Mailing_Address_3__c;
                    gs.GA_Physical_City__c=gs.GA_Mailing_City__c;
                    gs.GA_Physical_State__c=gs.GA_Mailing_State__c;
                    gs.GA_Physical_County_Id__c=gs.GA_Mailing_County_Id__c;
                    gs.GA_Physical_Zip__c=gs.GA_Mailing_Zip__c;
                }
                if(gs.GA_Copy_Address_From__c.contains(bTM)){
                    gs.GA_Mailing_Address_1__c=gs.GA_Billing_Address_1__c;
                    gs.GA_Mailing_Address_2__c=gs.GA_Billing_Address_2__c;
                    gs.GA_Mailing_Address_3__c=gs.GA_Billing_Address_3__c;
                    gs.GA_Mailing_City__c=gs.GA_Billing_City__c;
                    gs.GA_Mailing_State__c=gs.GA_Billing_State__c;
                    gs.GA_Mailing_County_Id__c=gs.GA_Billing_County_Id__c;
                    gs.GA_Mailing_Zip__c=gs.GA_Billing_Zip__c;
                }
                if (gs.GA_Copy_Address_From__c.contains(bTP)){
                    gs.GA_Physical_Address_1__c=gs.GA_Billing_Address_1__c;
                    gs.GA_Physical_Address_2__c=gs.GA_Billing_Address_2__c;
                    gs.GA_Physical_Address_3__c=gs.GA_Billing_Address_3__c;
                    gs.GA_Physical_City__c=gs.GA_Billing_City__c;
                    gs.GA_Physical_State__c=gs.GA_Billing_State__c;
                    gs.GA_Physical_County_Id__c=gs.GA_Billing_County_Id__c;
                    gs.GA_Physical_Zip__c=gs.GA_Billing_Zip__c;
                }
                
                if(gs.GA_Copy_Address_From__c.contains(mTB) && user_has_permission){
                    gs.GA_Billing_Address_1__c=gs.GA_Mailing_Address_1__c;
                    gs.GA_Billing_Address_2__c=gs.GA_Mailing_Address_2__c;
                    gs.GA_Billing_Address_3__c=gs.GA_Mailing_Address_3__c;
                    gs.GA_Billing_State__c=gs.GA_Mailing_State__c;
                    gs.GA_Billing_City__c=gs.GA_Mailing_City__c;
                    gs.GA_Billing_County_Id__c=gs.GA_Mailing_County_Id__c;
                    gs.GA_Billing_Zip__c=gs.GA_Mailing_Zip__c;
                }
                
                if (gs.GA_Copy_Address_From__c.contains(pTB) && user_has_permission){
                    gs.GA_Billing_Address_1__c=gs.GA_Physical_Address_1__c;
                    gs.GA_Billing_Address_2__c=gs.GA_Physical_Address_2__c;
                    gs.GA_Billing_Address_3__c=gs.GA_Physical_Address_3__c;
                    gs.GA_Billing_State__c=gs.GA_Physical_State__c;
                    gs.GA_Billing_City__c=gs.GA_Physical_City__c;
                    gs.GA_Billing_County_Id__c=gs.GA_Physical_County_Id__c;
                    gs.GA_Billing_Zip__c=gs.GA_Physical_Zip__c;
                }
                
                
                
                
                gs.GA_Physical_City_Other__c=BLANK;
                gs.GA_Mailing_City_Other__c=BLANK;
                gs.GA_Billing_City_Other__c=BLANK;
                gs.GA_Copy_Address_From__c=Nne;
                grpSgmntCityMap.put(gs.id,gs);
            }
        }
        isInvoked = true;
        System.debug('====grpSgmntCityMap==='+grpSgmntCityMap);
        database.update(grpSgmntCityMap.values()); 
    }
    /**
@Description: updateCityInfo() method 
@Name : updateCityInfo
@Param : list<id> gsIds
@Return : void
@throws Exception : N/A;
*/    
    @future
    public static void updateCityInfo(list<id> gsIds)
    {
        updateCityForBatch(gsIds);
    }
    /**
@Description: constructMap() method 
@Name : constructMap
@Param : list<GA_Group_Segment__c> gSList
@Return : List
@throws Exception : N/A;
*/      
    public static List<id> constructMap(list<GA_Group_Segment__c> gSList){
        list<id> grpIds=new list<id>();
        id gsmtId;
        for(GA_Group_Segment__c grpSgmnt:gSList)
        {
            gsmtId=grpSgmnt.Id;
            grpIds.add(gsmtId);
        }
        System.debug('===grpIds==='+grpIds);
        return grpIds;
    }
    /**
@Description: updateCounty() method 
@Name : updateCounty
@Param : list<GA_Group_Segment__c> gSList
@Return : void
@throws Exception : N/A;
*/    
    public static void updateCounty(list<GA_Group_Segment__c> gSList ) {
        
        GA_County_Code__c osCty = [select id, name from GA_County_Code__c Where Name =: outofState Limit 01];
        if(osCty!=null){
            for(GA_Group_Segment__c gs : gSList){
                if(gs.GA_Physical_State__c !=null && gs.GA_Physical_State__c!=miState && gs.GA_Physical_County_Id__c!=osCty.id)
                {
                    gs.GA_Physical_County_Id__c =osCty.id;
                }
                if(gs.GA_Billing_State__c !=null && gs.GA_Billing_State__c!=miState && gs.GA_Billing_County_Id__c!=osCty.id)
                {
                    gs.GA_Billing_County_Id__c =osCty.id;
                }
                if(gs.GA_Mailing_State__c !=null && gs.GA_Mailing_State__c!=miState && gs.GA_Mailing_County_Id__c!=osCty.id)
                {
                    gs.GA_Mailing_County_Id__c =osCty.id;
                }
            }
        }
    }
    
    /**
@Description: updateCityCopyAddressUI() method 
@Name : updateCityCopyAddressUI
@Param : list<GA_Group_Segment__c> gSList
@Return : void
@throws Exception : N/A;
*/  
    public static void updateCityCopyAddressUI(GA_Group_Segment__c gs)
    {   
        if( gs.GA_Copy_Address_From__c != null)  {
            
            if(gs.GA_Copy_Address_From__c.contains(pTM) && gs.GA_Copy_Address_From__c.contains(bTM)){
                gs.addError(MultiCopyToMail);
            }
            if(gs.GA_Copy_Address_From__c.contains(mTP) && gs.GA_Copy_Address_From__c.contains(bTP)){
                gs.addError(MultiCopyToPhy);
            }
            
            if(gs.GA_Copy_Address_From__c.contains(mTB) && gs.GA_Copy_Address_From__c.contains(pTB)){
                gs.addError(MultiCopyToBllng);
            }
            
            if(gs.GA_Copy_Address_From__c.contains(bTM) || gs.GA_Copy_Address_From__c.contains(bTP)){
                if(String.isEmpty(gs.GA_Billing_Address_1__c)||String.isEmpty(gs.GA_Billing_City__c)||String.isEmpty(gs.GA_Billing_State__c)||String.isEmpty(gs.GA_Billing_County_Id__c)||String.isEmpty(gs.GA_Billing_Zip__c))
                {
                    gs.addError(BFldsMadtry);
                }
            }
            if(gs.GA_Copy_Address_From__c.contains(mTP)||gs.GA_Copy_Address_From__c.contains(mTB)){
                if(String.isEmpty(gs.GA_Mailing_Address_1__c)||String.isEmpty(gs.GA_Mailing_City__c)||String.isEmpty(gs.GA_Mailing_State__c)||String.isEmpty(gs.GA_Mailing_County_Id__c)||String.isEmpty(gs.GA_Mailing_Zip__c))
                {
                    gs.addError(MFldsMadtry);
                }
                
            }
            
            if(gs.GA_Copy_Address_From__c.contains(pTM)||gs.GA_Copy_Address_From__c.contains(pTB)){
                if(String.isEmpty(gs.GA_Physical_Address_1__c)||String.isEmpty(gs.GA_Physical_City__c)||String.isEmpty(gs.GA_Physical_State__c)||String.isEmpty(gs.GA_Physical_County_Id__c)||String.isEmpty(gs.GA_Physical_Zip__c))
                {
                    gs.addError(PFldsMadtry);
                }
            }
            
            
            List<PermissionSetAssignment> lstcurrentUserPerSet =    [  SELECT Assignee.Id FROM PermissionSetAssignment
                                                                     WHERE Assignee.Id = :Userinfo.getUserId()  and
                                                                     PermissionSet.Name  = 'Allow_Group_Billing_to_update_GS_and_contact_fields' ];
            
            
            if(lstcurrentUserPerSet.size() > 0 && (gs.GA_Copy_Address_From__c.contains(mTB) || gs.GA_Copy_Address_From__c.contains(pTB))) {
                user_has_permission = true;
            }
            if(lstcurrentUserPerSet.size() > 0 && (gs.GA_Copy_Address_From__c.contains(pTM) || gs.GA_Copy_Address_From__c.contains(mTP))) {
                gs.addError(copyPMErr);
            }
            
            
            list<GA_Trigger_Functionality_By_Pass__c> copytoBilling = [select id,GA_Mailing_Physical_to_Billing__c,SetupOwner.Name 
                                                                       from GA_Trigger_Functionality_By_Pass__c 
                                                                       where SetupOwnerId=:userInfo.getProfileId() limit 1];
            
            
            if(copytoBilling.size()>0 && copytoBilling[0].GA_Mailing_Physical_to_Billing__c 
               && (gs.GA_Copy_Address_From__c.contains(mTB) || gs.GA_Copy_Address_From__c.contains(pTB)))
            {
                
                user_has_permission = true;
            }
            
            
            
            if(!user_has_permission  && (gs.GA_Copy_Address_From__c.contains(mTB) || gs.GA_Copy_Address_From__c.contains(pTB))){
                gs.addError(copyBillingErr);
            }
            
        }
        set<string> outOfStateLst=new set<string>();
        if((!String.IsEmpty(gs.GA_Physical_City_Other__c) || 
            !String.IsEmpty(gs.GA_Mailing_City_Other__c) ||
            !String.IsEmpty(gs.GA_Billing_City_Other__c))){
                
                if(!String.IsEmpty(gs.GA_Physical_City_Other__c) && gs.GA_Physical_City_Name__c!=null && gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr))
                    outOfStateLst.add(gs.GA_Physical_City_Other__c);
                if(!String.IsEmpty(gs.GA_Mailing_City_Other__c) && gs.GA_Mailing_City_Name__c!=null && gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr))  
                    outOfStateLst.add(gs.GA_Mailing_City_Other__c);
                if(!String.IsEmpty(gs.GA_Billing_City_Other__c) && gs.GA_Billing_City_Name__c!=null && gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr))
                    outOfStateLst.add(gs.GA_Billing_City_Other__c);
            }
        
        if(outOfStateLst.size() > 0) {
            Map<Id,GA_City_Code__c> cityMap = GA_Util15_CityDataAccessLayerHelper.fetchCityMap(selectQry,
                                                                                               whereClause+GA_Util08_FilterProcessHelper.strSet(outOfStateLst),BLANK,limitClause);
            
            
            map<string,id> cityNmIdMap=new map<string,Id>();
            map<string,list<string>> newcityNmIdMap=new map<string,list<string>>();
            list<string> NmIdLst=new list<string>();
            for(GA_City_Code__c cty : cityMap.values()) {
                cityNmIdMap.put(cty.Name.toUpperCase(),cty.Id);
            }
            
            boolean cityOther=false;
            boolean OldcityOther=false;
            String city;
            if(!String.IsEmpty(gs.GA_Physical_City_Other__c) && gs.GA_Physical_City_Name__c!=null && gs.GA_Physical_City_Name__c.equalsIgnoreCase(othr))
            {
                cityOther=true;
                city = gs.GA_Physical_City_Other__c.toUpperCase();
                if(cityNmIdMap.get(city)!=null)
                {
                    gs.GA_Physical_City__c=  cityNmIdMap.get(city);
                    OldcityOther=true;
                }
                else
                {
                    if(newcityNmIdMap.get(gs.GA_Physical_City_Other__c.toUpperCase()) !=null)
                    {
                        NmIdLst=newcityNmIdMap.get(gs.GA_Physical_City_Other__c.toUpperCase());
                    }
                    else
                        NmIdLst=new list<string>(); 
                    NmIdLst.add(gs.id+TILDE+physicalCity);
                    newcityNmIdMap.put(gs.GA_Physical_City_Other__c.toUpperCase(),NmIdLst);
                } 
            }          
            if(!String.IsEmpty(gs.GA_Billing_City_Other__c) && gs.GA_Billing_City_Name__c!=null && gs.GA_Billing_City_Name__c.equalsIgnoreCase(othr)) 
            {
                cityOther=true;
                city = gs.GA_Billing_City_Other__c.toUpperCase();
                if(cityNmIdMap.get(city)!=null)
                {
                    gs.GA_Billing_City__c=  cityNmIdMap.get(city);
                    OldcityOther=true;
                }
                else
                {
                    if(newcityNmIdMap.get(gs.GA_Billing_City_Other__c.toUpperCase()) !=null)
                    {
                        NmIdLst=newcityNmIdMap.get(gs.GA_Billing_City_Other__c.toUpperCase());
                    }
                    else
                        NmIdLst=new list<string>(); 
                    NmIdLst.add(gs.id+TILDE+billingCity);
                    newcityNmIdMap.put(gs.GA_Billing_City_Other__c.toUpperCase(),NmIdLst);
                }  
            }
            if(!String.IsEmpty(gs.GA_Mailing_City_Other__c) && gs.GA_Mailing_City_Name__c!=null && gs.GA_Mailing_City_Name__c.equalsIgnoreCase(othr))  
            {
                cityOther=true;
                city = gs.GA_Mailing_City_Other__c.toUpperCase();
                if(cityNmIdMap.get(city)!=null)
                {
                    gs.GA_Mailing_City__c=  cityNmIdMap.get(city);
                    OldcityOther=true;
                }
                else
                {
                    if(newcityNmIdMap.get(gs.GA_Mailing_City_Other__c.toUpperCase()) !=null)
                    {
                        NmIdLst=newcityNmIdMap.get(gs.GA_Mailing_City_Other__c.toUpperCase());
                    }
                    else
                        NmIdLst=new list<string>(); 
                    NmIdLst.add(gs.id+TILDE+mailingCity);
                    newcityNmIdMap.put(gs.GA_Mailing_City_Other__c.toUpperCase(),NmIdLst);
                }  
            }
            
            
            list<GA_City_Code__c> lstNewCities=new list<GA_City_Code__c>();
            GA_City_Code__c newCty=new GA_City_Code__c();
            for(string newCtyNm:newcityNmIdMap.keySet())
            {
                newCty=new GA_City_Code__c();
                newCty.Name=newCtyNm.toUpperCase();
                lstNewCities.add(newCty);
            }
            
            if(!lstNewCities.isEmpty())
            {
                GA_Util15_CityDataAccessLayerHelper.dmlOnCity(lstNewCities, GA_Util15_CityDataAccessLayerHelper.INSERT_OPERATION );
            }
            map<id,GA_Group_Segment__c> grpToUpdteNewCity=new map<id,GA_Group_Segment__c>();
            
            for(GA_City_Code__c newCtyRec:lstNewCities)
            {
                list<string> grpInfoLst=newcityNmIdMap.get(newCtyRec.Name);
                if(!grpInfoLst.isEmpty()){
                    for(string grpInfo:grpInfoLst)
                    {
                        string fieldInfo=grpInfo.split(TILDE)[1];
                        gs.put(fieldInfo,newCtyRec.Id); 
                    }
                }
            }
            
            gs.GA_Physical_City_Other__c=BLANK;
            gs.GA_Mailing_City_Other__c=BLANK;
            gs.GA_Billing_City_Other__c=BLANK;        
        }
        if( gs.GA_Copy_Address_From__c != null)  {
            
            if(gs.GA_Copy_Address_From__c.contains(pTM)){
                gs.GA_Mailing_Address_1__c=gs.GA_Physical_Address_1__c;
                gs.GA_Mailing_Address_2__c=gs.GA_Physical_Address_2__c;
                gs.GA_Mailing_Address_3__c=gs.GA_Physical_Address_3__c;
                gs.GA_Mailing_City__c=gs.GA_Physical_City__c;
                gs.GA_Mailing_State__c=gs.GA_Physical_State__c;
                gs.GA_Mailing_County_Id__c=gs.GA_Physical_County_Id__c;
                gs.GA_Mailing_Zip__c=gs.GA_Physical_Zip__c;
            }
            if(gs.GA_Copy_Address_From__c.contains(mTP)){
                gs.GA_Physical_Address_1__c=gs.GA_Mailing_Address_1__c;
                gs.GA_Physical_Address_2__c=gs.GA_Mailing_Address_2__c;
                gs.GA_Physical_Address_3__c=gs.GA_Mailing_Address_3__c;
                gs.GA_Physical_City__c=gs.GA_Mailing_City__c;
                gs.GA_Physical_State__c=gs.GA_Mailing_State__c;
                gs.GA_Physical_County_Id__c=gs.GA_Mailing_County_Id__c;
                gs.GA_Physical_Zip__c=gs.GA_Mailing_Zip__c;
            }
            if(gs.GA_Copy_Address_From__c.contains(bTM)){
                gs.GA_Mailing_Address_1__c=gs.GA_Billing_Address_1__c;
                gs.GA_Mailing_Address_2__c=gs.GA_Billing_Address_2__c;
                gs.GA_Mailing_Address_3__c=gs.GA_Billing_Address_3__c;
                gs.GA_Mailing_City__c=gs.GA_Billing_City__c;
                gs.GA_Mailing_State__c=gs.GA_Billing_State__c;
                gs.GA_Mailing_County_Id__c=gs.GA_Billing_County_Id__c;
                gs.GA_Mailing_Zip__c=gs.GA_Billing_Zip__c;
            }
            if(gs.GA_Copy_Address_From__c.contains(bTP)){
                gs.GA_Physical_Address_1__c=gs.GA_Billing_Address_1__c;
                gs.GA_Physical_Address_2__c=gs.GA_Billing_Address_2__c;
                gs.GA_Physical_Address_3__c=gs.GA_Billing_Address_3__c;
                gs.GA_Physical_City__c=gs.GA_Billing_City__c;
                gs.GA_Physical_State__c=gs.GA_Billing_State__c;
                gs.GA_Physical_County_Id__c=gs.GA_Billing_County_Id__c;
                gs.GA_Physical_Zip__c=gs.GA_Billing_Zip__c;
            }
            if(gs.GA_Copy_Address_From__c.contains(mTB) && user_has_permission){
                gs.GA_Billing_Address_1__c=gs.GA_Mailing_Address_1__c;
                gs.GA_Billing_Address_2__c=gs.GA_Mailing_Address_2__c;
                gs.GA_Billing_Address_3__c=gs.GA_Mailing_Address_3__c;
                gs.GA_Billing_State__c=gs.GA_Mailing_State__c;
                gs.GA_Billing_City__c=gs.GA_Mailing_City__c;
                gs.GA_Billing_County_Id__c=gs.GA_Mailing_County_Id__c;
                gs.GA_Billing_Zip__c=gs.GA_Mailing_Zip__c;
            }
            
            if (gs.GA_Copy_Address_From__c.contains(pTB) && user_has_permission){
                gs.GA_Billing_Address_1__c=gs.GA_Physical_Address_1__c;
                gs.GA_Billing_Address_2__c=gs.GA_Physical_Address_2__c;
                gs.GA_Billing_Address_3__c=gs.GA_Physical_Address_3__c;
                gs.GA_Billing_State__c=gs.GA_Physical_State__c;
                gs.GA_Billing_City__c=gs.GA_Physical_City__c;
                gs.GA_Billing_County_Id__c=gs.GA_Physical_County_Id__c;
                gs.GA_Billing_Zip__c=gs.GA_Physical_Zip__c;
            }
            
            gs.GA_Copy_Address_From__c=Nne;
        }
    }
    
/** 
@Description: updateCountyByZipCode() method 
@Name : updateCountyByZipCode
@Param : list<GA_Group_Segment__c> gSList
@Return : void
@throws Exception : N/A;
*/  
    public static void updateCountyByZipCode(list<GA_Group_Segment__c> gsList){
        GA_County_Code__c osCty = [select id, name from GA_County_Code__c Where Name =: outofState Limit 01];
        String userName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
        
        Map<String, ZipCode__c> zipMap = new Map<String, ZipCode__c>();
        List<String> gsZipList = new List<String>();
        // Custom Labels that Contains the Zip Codes with Multiple County
        String ZipcodeDuplicate = System.Label.Zipcode_Duplicate_1;
        String ZipcodeDuplicate2 = System.Label.Zipcode_Duplicate_2;
        String ZipcodeDuplicate3 = System.Label.Zipcode_Duplicate_3;
        
        for(GA_Group_Segment__c grp : gsList){
            if(grp.GA_Physical_Zip__c != null){
                if(grp.GA_Physical_Zip__c.length() < 5 && userName<>profIntUser)
                    grp.GA_Physical_Zip__c.addError('Invalid Zip Code/State Combination');
                else
                    gsZipList.add(grp.GA_Physical_Zip__c.substring(0,5));
            }
            
            if(grp.GA_Billing_Zip__c != null){
                if(grp.GA_Billing_Zip__c.length() < 5 && userName<>profIntUser)
                    grp.GA_Billing_Zip__c.addError('Invalid Zip Code/State Combination');
                else
                    gsZipList.add(grp.GA_Billing_Zip__c.substring(0,5));
            }
            
            if(grp.GA_Mailing_Zip__c != null){
                if(grp.GA_Mailing_Zip__c.length() < 5 && userName<>profIntUser)
                    grp.GA_Mailing_Zip__c.addError('Invalid Zip Code/State Combination');
                else
                    gsZipList.add(grp.GA_Mailing_Zip__c.substring(0,5));
            }
        }
        
        List<ZipCode__c> zipCodeList = [SELECT Id, CountyName__c, ZipCode__c FROM ZipCode__c WHERE ZipCode__c =: gsZipList];
        
        for(ZipCode__c zip : zipCodeList)
            zipMap.put(zip.Zipcode__c,zip);
        
        for(GA_Group_Segment__c grp : gsList){
            // Physical Zip
            if(grp.GA_Physical_Zip__c != null){
                ZipCode__c physicalZip = zipMap.get(grp.GA_Physical_Zip__c.substring(0,5));
                if(grp.GA_Physical_State__c == 'MI'){
                    // If Zip Code contains only one County Code or Wrong Zip Code when State is MI
                    if(!ZipcodeDuplicate.contains(grp.GA_Physical_Zip__c.substring(0,5)) && !ZipcodeDuplicate2.contains(grp.GA_Physical_Zip__c.substring(0,5)) && !ZipcodeDuplicate3.contains(grp.GA_Physical_Zip__c.substring(0,5))){
                        if(physicalZip != null || userName==profIntUser)
                            grp.GA_Physical_County_Id__c = physicalZip.CountyName__c;
                        else
                            grp.GA_Physical_Zip__c.addError('Invalid Zip Code/State Combination');
                    }
                    // If Zip Code contains Multiple County Code and County Code is not Populated
                    else if((ZipcodeDuplicate.contains(grp.GA_Physical_Zip__c.substring(0,5)) || ZipcodeDuplicate2.contains(grp.GA_Physical_Zip__c.substring(0,5)) || ZipcodeDuplicate3.contains(grp.GA_Physical_Zip__c.substring(0,5))) && grp.GA_Physical_County_Id__c == null && userName<>profIntUser){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name, ZipCode__c FROM ZipCode__c WHERE ZipCode__c =: grp.GA_Physical_Zip__c.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        county = county.removeEnd(', ');
                        grp.GA_Physical_Zip__c.addError('This Zip Code has multiple County: '+county);
                    }
                    // If Zip Code contains Multiple County Code and County Code is Populated but doesn't match with the Zip Code
                    else if(grp.GA_Physical_County_Id__c != null && userName<>profIntUser){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: grp.GA_Physical_Zip__c.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        String Countyname = [SELECT Name FROM GA_County_Code__c WHERE ID =:grp.GA_Physical_County_Id__c].Name;
                        county = county.removeEnd(', ');
                        if(!county.contains(Countyname)){
                            grp.GA_Physical_Zip__c.addError('County for the Zip Code should be the following: '+county);
                        }
                    }
                } else { // State Not != MI
                    // Invalid Combination if State != MI AND Zip Code is from MI
                    if(physicalZip != null && userName<>profIntUser){
                        grp.GA_Physical_Zip__c.addError('Invalid Zip Code and State Combination Selected');
                    } else{ // Populate the County Code to Out of State
                        grp.GA_Physical_County_Id__c = osCty.Id;
                    }
                }
            }
            // Billing Zip
            if(grp.GA_Billing_Zip__c != null){
                ZipCode__c billingZip = zipMap.get(grp.GA_Billing_Zip__c.substring(0,5)); 
                if(grp.GA_Billing_State__c == 'MI'){
                    if(!ZipcodeDuplicate.contains(grp.GA_Billing_Zip__c.substring(0,5)) && !ZipcodeDuplicate2.contains(grp.GA_Billing_Zip__c.substring(0,5)) && !ZipcodeDuplicate3.contains(grp.GA_Billing_Zip__c.substring(0,5))){
                        if(billingZip != null || userName==profIntUser)
                            grp.GA_Billing_County_Id__c = billingZip.CountyName__c;
                        else{
                            grp.GA_Billing_Zip__c.addError('Invalid Zip Code/State Combination');
                        }
                    }
                    else if((ZipcodeDuplicate.contains(grp.GA_Billing_Zip__c.substring(0,5)) || ZipcodeDuplicate2.contains(grp.GA_Billing_Zip__c.substring(0,5)) || ZipcodeDuplicate3.contains(grp.GA_Billing_Zip__c.substring(0,5))) && grp.GA_Billing_County_Id__c == null && userName<>profIntUser){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: grp.GA_Billing_Zip__c.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        county = county.removeEnd(', ');
                        grp.GA_Billing_Zip__c.addError('This Zip Code has multiple County: '+county);
                    }
                    else if(grp.GA_Billing_County_Id__c != null && userName<>profIntUser){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: grp.GA_Billing_Zip__c.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        String Countyname = [SELECT Name FROM GA_County_Code__c WHERE ID =:grp.GA_Billing_County_Id__c].Name;
                        county = county.removeEnd(', ');
                        if(!county.contains(Countyname)){
                            grp.GA_Billing_Zip__c.addError('County for the Zip Code should be the following: '+county);
                        }
                    }
                } else {
                    if(billingZip != null && userName<>profIntUser){
                        grp.GA_Billing_Zip__c.addError('Invalid Zip Code and State Combination Selected');
                    } else{
                        grp.GA_Billing_County_Id__c = osCty.Id;
                    }
                }
            }
            // Mailing Zip
            if(grp.GA_Mailing_Zip__c != null){
                ZipCode__c mailingZip = zipMap.get(grp.GA_Mailing_Zip__c.substring(0,5));
                if(grp.GA_Mailing_State__c == 'MI'){
                    if(!ZipcodeDuplicate.contains(grp.GA_Mailing_Zip__c.substring(0,5)) && !ZipcodeDuplicate2.contains(grp.GA_Mailing_Zip__c.substring(0,5)) && !ZipcodeDuplicate3.contains(grp.GA_Mailing_Zip__c.substring(0,5))){
                        if(mailingZip != null || userName==profIntUser)
                            grp.GA_Mailing_County_Id__c = mailingZip.CountyName__c;
                        else{
                            grp.GA_Mailing_Zip__c.addError('Invalid Zip Code/State Combination');
                        }
                    }
                    else if((ZipcodeDuplicate.contains(grp.GA_Mailing_Zip__c.substring(0,5)) || ZipcodeDuplicate2.contains(grp.GA_Mailing_Zip__c.substring(0,5)) || ZipcodeDuplicate3.contains(grp.GA_Mailing_Zip__c.substring(0,5))) && grp.GA_Mailing_County_Id__c == null && userName<>profIntUser){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: grp.GA_Mailing_Zip__c.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        county = county.removeEnd(', ');
                        grp.GA_Mailing_Zip__c.addError('This Zip Code has multiple County: '+county);
                    } 
                    else if(grp.GA_Mailing_County_Id__c != null && userName<>profIntUser){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: grp.GA_Mailing_Zip__c.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        String Countyname = [SELECT Name FROM GA_County_Code__c WHERE ID =:grp.GA_Mailing_County_Id__c].Name;
                        county = county.removeEnd(', ');
                        if(!county.contains(Countyname)){
                            grp.GA_Mailing_Zip__c.addError('County for the Zip Code should be the following: '+county);
                        }
                    }
                } else {
                    if(mailingZip != null && userName<>profIntUser){
                        grp.GA_Mailing_Zip__c.addError('Invalid Zip Code and State Combination Selected');
                    } else{
                        grp.GA_Mailing_County_Id__c = osCty.Id;
                    }
                }
            }
        } // End of For Loop Group Segment
    }
    
    /** 
@Description: updateAccCountyByZipCode() method 
@Name : updateAccCountyByZipCode
@Param : list<Account> accList
@Return : void
@throws Exception : N/A;
*/
    public static void updateAccCountyByZipCode(list<Account> accList){
        GA_County_Code__c osCty = [select id, name from GA_County_Code__c Where Name =: outofState /*Limit 01*/];
        String userName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
        // Added Start
        List<PermissionSetAssignment> permissionUserList = [SELECT Assignee.Name, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Pharmacy_Team_Member_Update'];
        List<String> idUserList = new List<String>();
        for(PermissionSetAssignment user : permissionUserList){
            idUserList.add(user.AssigneeId);
        }
        // End
        Map<String, ZipCode__c> zipMap = new Map<String, ZipCode__c>();
        List<String> accZipList = new List<String>();
        // Custom Labels that Contains the Zip Codes with Multiple County
        String ZipcodeDuplicate = System.Label.Zipcode_Duplicate_1;
        String ZipcodeDuplicate2 = System.Label.Zipcode_Duplicate_2;
        String ZipcodeDuplicate3 = System.Label.Zipcode_Duplicate_3;
        for(Account acc : accList){ 
            if(acc.ShippingPostalCode != null){
                if(acc.ShippingPostalCode.length() < 5 && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId()))
                    acc.ShippingPostalCode.addError('Invalid Zip Code/State Combination');
                else
                    accZipList.add(acc.ShippingPostalCode.substring(0,5));
            }
            
            if(acc.BillingPostalCode != null){
                if(acc.BillingPostalCode.length() < 5 && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId()))
                    acc.BillingPostalCode.addError('Invalid Zip Code/State Combination');
                else
                    accZipList.add(acc.BillingPostalCode.substring(0,5));
            }
        }
        
        List<ZipCode__c> zipCodeList = [SELECT Id, CountyName__c, ZipCode__c FROM ZipCode__c WHERE ZipCode__c =: accZipList];
        
        for(ZipCode__c zip : zipCodeList)
            zipMap.put(zip.Zipcode__c,zip);
        
        system.debug('TESTING ACCOUNT zipMap: '+zipMap);
        for(Account acc : accList){
            // ShippingPostalCode = Physical
            // Physical Zip
            if(acc.ShippingPostalCode != null){
                ZipCode__c physicalZip = zipMap.get(acc.ShippingPostalCode.substring(0,5));
                if(acc.ShippingStateCode == 'MI'){
                    if(!ZipcodeDuplicate.contains(acc.ShippingPostalCode.substring(0,5)) && !ZipcodeDuplicate2.contains(acc.ShippingPostalCode.substring(0,5)) && !ZipcodeDuplicate3.contains(acc.ShippingPostalCode.substring(0,5))){
                        if(physicalZip != null || userName==profIntUser)
                            acc.GA_Physical_County_Id__c = physicalZip.CountyName__c;
                        else
                            acc.ShippingPostalCode.addError('Invalid Zip Code/State Combination');
                    }
                    else if((ZipcodeDuplicate.contains(acc.ShippingPostalCode.substring(0,5)) || ZipcodeDuplicate2.contains(acc.ShippingPostalCode.substring(0,5)) || ZipcodeDuplicate3.contains(acc.ShippingPostalCode.substring(0,5))) && acc.GA_Physical_County_Id__c == null && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId()) && Limits.getQueries() < 100){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name, ZipCode__c FROM ZipCode__c WHERE ZipCode__c =: acc.ShippingPostalCode.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        county = county.removeEnd(', ');
                        acc.ShippingPostalCode.addError('This Zip Code has multiple County: '+county);
                    }
                    else if(acc.GA_Physical_County_Id__c != null && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId()) && Limits.getQueries() < 100){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: acc.ShippingPostalCode.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        String Countyname = [SELECT Name FROM GA_County_Code__c WHERE ID =:acc.GA_Physical_County_Id__c].Name;
                        county = county.removeEnd(', ');
                        if(!county.contains(Countyname)){
                            acc.ShippingPostalCode.addError('County for the Zip Code should be the following: '+county);
                        }
                    }
                } else {
                    if(physicalZip != null && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId())){
                        acc.ShippingPostalCode.addError('Invalid Zip Code and State Combination Selected');
                    } else{
                        acc.GA_Physical_County_Id__c = osCty.Id;
                    }
                }
            }
            //BillingPostalCode = Mailing
            // Mailing Zip
            system.debug('Test Billing State Code: '+acc.BillingStateCode);
            system.debug('Test Billing State: '+acc.BillingState);
            if(acc.BillingPostalCode != null){
                ZipCode__c mailingZip = zipMap.get(acc.BillingPostalCode.substring(0,5));
                if(acc.BillingStateCode == 'MI'){
                    if(!ZipcodeDuplicate.contains(acc.BillingPostalCode.substring(0,5)) && !ZipcodeDuplicate2.contains(acc.BillingPostalCode.substring(0,5)) && !ZipcodeDuplicate3.contains(acc.BillingPostalCode.substring(0,5))){
                        if(mailingZip != null || userName==profIntUser)
                            acc.GA_Mailing_County_Id__c = mailingZip.CountyName__c;
                        else{
                            acc.BillingPostalCode.addError('Invalid Zip Code/State Combination');
                        }
                    }
                    else if((ZipcodeDuplicate.contains(acc.BillingPostalCode.substring(0,5)) || ZipcodeDuplicate2.contains(acc.BillingPostalCode.substring(0,5)) || ZipcodeDuplicate3.contains(acc.BillingPostalCode.substring(0,5))) && acc.GA_Mailing_County_Id__c == null && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId()) && Limits.getQueries() < 100){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: acc.BillingPostalCode.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        county = county.removeEnd(', ');
                        acc.BillingPostalCode.addError('This Zip Code has multiple County: '+county);
                    } 
                    else if(acc.GA_Mailing_County_Id__c != null && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId()) && Limits.getQueries() < 100){
                        String county = '';
                        for (Zipcode__c zip : [SELECT Id, CountyName__r.Name FROM ZipCode__c WHERE ZipCode__c =: acc.BillingPostalCode.substring(0,5)]){
                            county += zip.CountyName__r.Name+', ';
                        }
                        String Countyname = [SELECT Name FROM GA_County_Code__c WHERE ID =:acc.GA_Mailing_County_Id__c].Name;
                        county = county.removeEnd(', ');
                        if(!county.contains(Countyname)){
                            acc.BillingPostalCode.addError('County for the Zip Code should be the following: '+county);
                        }
                    }
                } else {
                    if(mailingZip != null && userName<>profIntUser && !idUserList.contains(UserInfo.getUserId())){
                        acc.BillingPostalCode.addError('Invalid Zip Code and State Combination Selected');
                    } else{
                        acc.GA_Mailing_County_Id__c = osCty.Id;
                    }
                }
            }
        } // End of For Loop Account
    }
    
}