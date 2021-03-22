/*****************************************************************************************
    Class Name   : ARV_AP46_ContactsCreationForSigning. 
    Date Created : 24-DEC-2019
    Created By   : IDC Offshore
    Description  :This class is used to create contacts given through Part-B to use in E-sign/Wet-Sign......
    ******************************************************************************************/
    global without sharing class ARV_AP46_ContactsCreationForSigning implements vlocity_ins.VlocityOpenInterface2{
        private static final string METHODNAME='uniqueContactsIdentification';
        private static final string ACCOUNTID='AccountId';
        private static final String WHERECLAUSE=' WHERE Id =: paramId1' ;
        private static final String LOCATIONWHERECLAUSE= '  WHERE ARV_ContractId__c=:paramId1 ';
        private static final string CONTRACTID='ContractId';
        private static final string ISBCBSM='IsBcbsmCarrier';
        private static final String LOCATIONQRY=System.label.ARV_CL47_LocationPackageQry;         
        private static final String CONTRACTQRY = System.label.ARV_CL46_CONTRACTQUERY;
        private static final Map<String,string> FINALMAP= new Map<String,string>();
        private static final Map<String,string> FINALCONTRACTMAP= new Map<String,string>();
        private static final Map<String,string> FINALSEGMENTMAP= new Map<String,string>();
        private static final Map<String,string> FINALSEGMENTCONTMAP= new Map<String,string>();
        private static final string FNAME='fname:';
        private static final string LNAME=';lname:';
        private static final string EMAIL=';email:';
        private static final string PHONE=';phone:';
        private static final string ADDRS=';address:';
        private static final string CITY=';city:';
        private static final string STATE=';state:';
        private static final string ZIP=';zip:';
        private static final string COUNTY=';county:';
        private static final string TITLE=';title:';    
        private static final String CEO='CEO';
        private static final String PADMN='PADMN';
        private static final String MVTR='MVTR';
        private static final String ROLEID='roleId:';
        private static final String EOA='Executive Sponsor;Other;Administrative';
        private static final String EXS='Executive Sponsor';
        private static final String ADMN='Administrative'; 
        private static final String BILLING='Billing'; 
        private static final String OTHR='Other';
        private static final String EXOTHR='Executive Sponsor;Other';
        private static final String ADMNOTHR='Administrative;Other';
        private static final String ADMNBILLNG='Administrative;Billing';
        private static final String EXADMN='Executive Sponsor;Administrative'; 
        private static final String LCTNPKG='LocationPackage__c'; 
        private static final String CNTRCTOBJ='Contract';
        private static final string FNAME1='fname';
        private static final string LNAME1='lname';
        private static final string EMAIL1='email';
        private static final string PHONE1='phone';
        private static final string PHONE2='phone:';
        private static final string ADDRS1='address';
        private static final string CITY1='city';
        private static final string STATE1='state';
        private static final string ZIP1='zip';
        private static final string COUNTY1='county';
        private static final string TITLE1='title'; 
        private static final string NBYA='N/A'; 
        private static final string SEMICOLON=';'; 
        private static final string COLON=':';
        private static final string COMMA=',';
        private static Set<Id> contactsSet = new Set<Id>();
        private static final string CONTACTQRY=System.label.ARV_CL45_ContactQuery;
        private static final string CONTACTWHERCLAUSE=' where id=:paramId1 ';
        private static final string LIMITCLAUSE=' limit 1 ';
        private static Id CEOCONTACTID=NULL;
        private static Id MVTRCONTACTID=NULL;
        private static Id PADMNCONTACTID=NULL;


        /*****************************************************************************************
        Mehtod Name   :  invokeMethod   
        Description  :This class is used to invoke remote methods.
        ******************************************************************************************/ 
        global static Boolean invokeMethod(String methodName, Map <String, Object> inputMap,
                                       Map < String, Object > outMap, Map < String, Object > options) {
        try{
            if (methodName == METHODNAME) 
            {
                uniqueContactsIdentification(inputMap,outMap,options);
            }
        }catch(Exception e){
            system.debug('Exception:::'+e.getLineNumber()+':::::'+e.getMessage());
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
            
        }
        return true;   
        }
        /*****************************************************************************************
        Mehtod Name   :  uniqueContactsIdentification   
        Description  :This class is used to identify unique contacts.
        ******************************************************************************************/ 
        global static void uniqueContactsIdentification(Map < String, Object > inputMap,
                                          Map <String, Object > outMap, Map <String, Object > options){    
            Id contractId = String.valueof(inputMap.get(CONTRACTID));                                           
            Id accountId  = String.valueof(inputMap.get(ACCOUNTID));  
            Boolean isBcbsmCarrier =Boolean.valueof(inputMap.get(ISBCBSM)) ;  
            //system.debug(' bcbsm carrier from os &&&&'+    isBcbsmCarrier );   
            //Map<String,string> finalSegmentMap1 = new Map<String,string>();         
            //finalSegmentMap1.putall(FINALSEGMENTMAP);
            Map<String,string> finalSegmentMap2 = new Map<String,string>();       
            // Contracts fetching 
            getContractsInfo(contractId,isBcbsmCarrier);
            //SegmentInfo Fetching
            getSegmentInfo(contractId);                                     
            for(String cntrct:FINALCONTRACTMAP.keyset()){
                String sgmt1='';
                //system.debug('*********cntrct'+cntrct);
                for(String sgmt:FINALSEGMENTMAP.keyset()){
                    //system.debug('*********sgmt'+sgmt);

                    if(FINALCONTRACTMAP.get(cntrct) !=null && FINALCONTRACTMAP.get(cntrct).contains(OTHR)){
                        system.debug('***********other cntrct'+cntrct);
                        String mvtrcnt=cntrct;
                        String name2=sgmt.substringbefore(PHONE2);
                        string name4=sgmt.substringAfter(PHONE2);
                        string name5=name4.right(name4.length()-11)+name4.left(1);                      
                        sgmt1=name2+name5; 
                        //system.debug('***********other sgmt1'+sgmt1);

                    }
                    if(sgmt1.contains(cntrct)){
                        if(FINALCONTRACTMAP.get(cntrct) !=null && FINALSEGMENTMAP.get(sgmt) !=null){
                            FINALMAP.put(sgmt,FINALSEGMENTMAP.get(sgmt)+COMMA+FINALCONTRACTMAP.get(cntrct));
                        }
                        FINALCONTRACTMAP.remove(cntrct);
                    }else{
                     //system.debug('Final contract map:::::::::::'+FINALCONTRACTMAP);
                    }   
                }
            }
            finalSegmentMap2.putall(FINALCONTRACTMAP);
            finalSegmentMap2.putall(FINALSEGMENTMAP);
            finalSegmentMap2.putall(FINALMAP);
            //system.debug('finalSegmentMap2**************'+finalSegmentMap2);
            contactsCreation(finalSegmentMap2,accountId,contractId);
        } 
        /*****************************************************************************************
        Mehtod Name   :  getContractsInfo   
        Description  :This method is used to get  contracts info.
        ******************************************************************************************/     
        private static Map<String,String> getContractsInfo(Id contractId,boolean isBcbsmCarrier){
            // Contracts fetching
            Set<String> contractSet =new Set<String>(); 
            Map<String,String> contractmap= new Map<String,String>();
            Boolean ceoPadmnCheck = false;
            ARV_AP07_QueryDataHelper.paramId1=contractId;                                  
            List<Contract> contractlst =ARV_AP07_QueryDataHelper.getsObjects(contractQry,WHERECLAUSE,null,null);          
            for(Contract cont:contractlst){
                // reading CEO Info         
                String ceoInfo =FNAME+cont.ARV_CEO_First_Name__c+LNAME+cont.ARV_CEO_Last_Name__c+EMAIL+
                    cont.ARV_CEO_Email__c+PHONE+String.valueof(cont.ARV_CEO_Phone__c);
                String ceoInfoWOPhone =FNAME+cont.ARV_CEO_First_Name__c+LNAME+cont.ARV_CEO_Last_Name__c+EMAIL+
                    cont.ARV_CEO_Email__c;  
                contractmap.put(CEO,ceoInfo);
                contractSet.add(ceoInfo);
                //system.debug('ceoInfo&&&'+ceoInfo);
                // Reading Principal Admin fields                       
                String paInfo =FNAME+cont.ARV_Principal_Admin_First_Name__c+LNAME+cont.ARV_Principal_Admin_Last_Name__c+EMAIL+
                               cont.ARV_Principal_Admin_Email__c; 

                //system.debug('paInfo&&&'+paInfo);                               
                contractSet.add(paInfo);
                contractmap.put(PADMN,paInfo);
                String contRoleId=ROLEID+cont.id;       
                if(ceoInfo.contains(paInfo)){
                    ceoPadmnCheck=true;
                }
                //reading Mutaul Voter Info         
                if(isBcbsmCarrier){ 
                    String  mvContact='';
                    String mvEmail=cont.ARV_Mutual_Voter_Email__c!=null ? cont.ARV_Mutual_Voter_Email__c:'';
                    //system.debug('********mvEmail'+mvEmail);
                    if(!String.isBlank(mvEmail)){
                        //system.debug('********mvEmail if'+mvEmail);
                        mvContact=FNAME+cont.ARV_Mutual_Voter_First_Name__c+LNAME+cont.ARV_Mutual_Voter_Last_Name__c
                        +EMAIL+cont.ARV_Mutual_Voter_Email__c+ADDRS+cont.ARV_Mutual_Voter_Mailing_Address__c+
                        CITY+cont.ARV_Mutual_Voter_Mailing_City__c
                        +STATE+cont.ARV_Mutual_Voter_Mailing_State__c+ZIP+cont.ARV_Mutual_Voter_Mailing_Zip__c+COUNTY+
                        cont.ARV_Mutual_Voter_Mailing_County__c ;
                    }else{
                        //system.debug('********mvEmail else'+mvEmail);

                        mvContact=FNAME+cont.ARV_Mutual_Voter_First_Name__c+LNAME+cont.ARV_Mutual_Voter_Last_Name__c
                        +ADDRS+cont.ARV_Mutual_Voter_Mailing_Address__c+
                        CITY+cont.ARV_Mutual_Voter_Mailing_City__c
                        +STATE+cont.ARV_Mutual_Voter_Mailing_State__c+ZIP+cont.ARV_Mutual_Voter_Mailing_Zip__c+COUNTY+
                        cont.ARV_Mutual_Voter_Mailing_County__c ;
                        
                    } 
                    
                    if((mvContact.contains(ceoInfoWOPhone)) && cont.ARV_CEO_Phone__c!=null){
                    mvContact=mvContact+PHONE+String.valueof(cont.ARV_CEO_Phone__c);
                      
                }
                  
                    
                    contractSet.add(mvContact);
                    contractmap.put(MVTR,mvContact);
                    //system.debug('mvcontact&&&'+ mvContact);
                    if(ceoPadmnCheck){
                        //system.debug(' ceoPadmnCheck condition&&&'+ceoPadmnCheck);
                        if(mvContact.contains(paInfo) ){
                            finalContractMap.put(mvContact,EOA+contRoleId);
                        }else{
                            finalContractMap.put(ceoInfo,EXADMN+contRoleId);
                            //finalContractMap.put(paInfo,ADMN+contRoleId);   
                            finalContractMap.put(mvContact,OTHR+contRoleId);
                        }                          
                    }else if(mvContact.contains(ceoInfoWOPhone)){
                        //system.debug('*******MVContact CEO'+mvContact);
                        finalContractMap.put(mvContact,EXOTHR+contRoleId);
                        if(mvContact.contains(paInfo)){
                            //system.debug('*******MVContact PAINFO'+mvContact);
                            finalContractMap.put(mvContact,ADMNOTHR+contRoleId);
                        }else{
                            finalContractMap.put(paInfo,ADMN+contRoleId);   
                        }   
                    }else{
                        //system.debug('line 178 after creating CEO contact');
                        finalContractMap.put(ceoInfo,EXS+contRoleId);                
                        if(mvContact.contains(paInfo)){
                            finalContractMap.put(mvContact,ADMNOTHR+contRoleId);
                        }else{ 
                        //system.debug(' line 182 none matched');
                            finalContractMap.put(paInfo,ADMN+contRoleId);   
                            finalContractMap.put(mvContact,OTHR+contRoleId);   
                        } 
                    }
                }else {
                    if(ceoPadmnCheck){
                        finalContractMap.put(ceoInfo,EXADMN+contRoleId);
                    }else{
                        finalContractMap.put(ceoInfo,EXS+contRoleId);
                        finalContractMap.put(paInfo,ADMN+contRoleId);             
                    } 
                }
            } 
            
            //system.debug('finalContractMap'+finalContractMap);
            //system.debug(map keys'+finalContractMap.KeySet());
            //system.debug(map values'+finalContractMap.values());
            return finalContractMap;
       
            
        }
        /*****************************************************************************************
        Mehtod Name   :  getContractsInfo   
        Description  :This method is used to get  contracts info.
        ******************************************************************************************/ 
        private static Map<String,String> getSegmentInfo(Id contractId){
            //SegmentInfo Fetching
            Set<String> segmentSet =new Set<String>();
            ARV_AP07_QueryDataHelper.paramId1=contractId;    
            List<LocationPackage__c> sgmntlist= ARV_AP07_QueryDataHelper.getsObjects(locationQry,locationWhereClause,null,null);          
            /* To handle SegmentInfo
            */
            for(LocationPackage__c sgmt : sgmntlist  ){
                
            // logic to insert Billing and Admin contacts.  
                String admnEml = sgmt.ARV_Admin_Email__c !=null?sgmt.ARV_Admin_Email__c :'';
                String admnValue='';
                if(!String.isBlank(admnEml)){
                    admnValue=FNAME+sgmt.ARV_Admin_First_Name__c+LNAME+sgmt.ARV_Admin_Last_Name__c+EMAIL+admnEml+PHONE
                              +sgmt.ARV_Admin_Phone__c+TITLE+sgmt.ARV_Admin_Job_Title__c;
                              
                              /*+ADDRS+sgmt.ARV_Admin_Address__c+CITY+sgmt.ARV_Admin_City__c+STATE
                              +sgmt.ARV_Admin_State__c+ZIP+sgmt.ARV_Admin_Zip_Code__c+COUNTY+sgmt.ARV_Admin_County__c+
                              TITLE+sgmt.ARV_Admin_Job_Title__c;*/
                }else{
                    admnValue=FNAME+sgmt.ARV_Admin_First_Name__c+LNAME+sgmt.ARV_Admin_Last_Name__c+PHONE
                              +sgmt.ARV_Admin_Phone__c+TITLE+sgmt.ARV_Admin_Job_Title__c;
                              
                              /*ADDRS+sgmt.ARV_Admin_Address__c+CITY+sgmt.ARV_Admin_City__c+STATE
                              +sgmt.ARV_Admin_State__c+ZIP+sgmt.ARV_Admin_Zip_Code__c+COUNTY+sgmt.ARV_Admin_County__c+
                              TITLE+sgmt.ARV_Admin_Job_Title__c;*/
                }                   
                String billEml = sgmt.ARV_Billing_Email__c !=null?sgmt.ARV_Billing_Email__c :'';
                String billingValue=''; 
                if(!String.isBlank(billEml)){
                    billingValue=FNAME+sgmt.ARV_Billing_First_Name__c+LNAME+sgmt.ARV_Billing_Last_Name__c+EMAIL+billEml+
                               PHONE+sgmt.ARV_Billing_Phone__c+TITLE+sgmt.ARV_Billing_Job_Title__c;
                               
                               /*+ADDRS+sgmt.ARV_Billing_Address__c+CITY+sgmt.ARV_Billing_City__c+
                               STATE+sgmt.ARV_Billing_State__c+ZIP+sgmt.ARV_Billing_Zip_Code__c+COUNTY+sgmt.ARV_Billing_County__c+
                               TITLE+sgmt.ARV_Billing_Job_Title__c;*/
                }else{
                    billingValue=FNAME+sgmt.ARV_Billing_First_Name__c+LNAME+sgmt.ARV_Billing_Last_Name__c+
                               PHONE+sgmt.ARV_Billing_Phone__c+TITLE+sgmt.ARV_Billing_Job_Title__c;
                               
                               
                               /*ADDRS+sgmt.ARV_Billing_Address__c+CITY+sgmt.ARV_Billing_City__c+
                               STATE+sgmt.ARV_Billing_State__c+ZIP+sgmt.ARV_Billing_Zip_Code__c+COUNTY+sgmt.ARV_Billing_County__c+
                               TITLE+sgmt.ARV_Billing_Job_Title__c;*/
                
                }                   
                               
                String sgmntId = ROLEID+sgmt.Id;    
                if(admnValue.equals(billingValue)){
                    finalSegmentMap.put(admnValue,ADMNBILLNG+sgmntId);
                }else{
                    finalSegmentMap.put(admnValue,ADMN+sgmntId); 
                    finalSegmentMap.put(billingValue,BILLING+sgmntId); 
                }     
                segmentSet.add(admnValue);
                segmentSet.add(billingValue);
            }
            return finalSegmentMap;  
        }   
        /*****************************************************************************************
        Mehtod Name   :  getContractsInfo   
        Description  :This method is used to get  contracts info.
        ******************************************************************************************/ 
        public static void contactsCreation(Map<String,String> contacts,Id accountId, Id contractId){
            String roles='';
            list<contact> contList = new List<contact>();
            for(String cntct : contacts.keyset()){          
                list<String> contbrdn = cntct.split(SEMICOLON); 
                Contact contactobj= new contact();
                roles = contacts.get(cntct);
                // to handle multi roles and Ids
                String finalRoleS='';
                String finaldS='';
                if(roles.contains(COMMA)){
                    String[] multiRoles=roles.split(COMMA);
                    for(string role: multiRoles ){
                        String[] mrole= role.split(ROLEID);
                    if(! finalRoleS.contains(mrole[0])){
                        finalRoleS=finalRoleS+mrole[0]+SEMICOLON;
                    }
                    if(mrole !=null)
                        finaldS=finaldS+mrole[1]+SEMICOLON;
                    }
                }else{
                    // single role handling
                    String[] singlRl=roles.split(ROLEID);
                    if(! finalRoleS.contains(singlRl[0])){
                    finalRoleS=finalRoleS+singlRl[0]+SEMICOLON;
                    }
                    finaldS=finaldS+singlRl[1]+SEMICOLON;
                }
                String[] rolesplt =roles.split(ROLEID);           
                for(String wrd: contbrdn){
                    String[] wrds=wrd.split(COLON);
                    //system.debug('********wrds'+wrds);
                    if(wrds[1] !=null){
                        if(wrds[0]==FNAME1){
                            contactObj.firstname=wrds[1];   
                        }                   
                        if(wrds[0]==LNAME1){
                            contactObj.lastname=wrds[1];
                        }
                        try{
                            if(wrds[0]==EMAIL1 && wrds[1] !=null){
                                contactObj.email=wrds[1];
                            }
                            if(wrds[0]==PHONE1){
                                contactObj.phone=wrds[1];
                            }
                            if(wrds[0]==ADDRS1){
                                contactObj.MailingStreet=wrds[1];
                            }
                            if(wrds[0]==CITY1){
                                contactObj.MailingCity=wrds[1];
                            }
                              
                            if(wrds[0]==STATE1  && wrds[1] !=null ){
                                String statename= ARV_AP49_GetStateNameByStateCode.getStateName(wrds[1]);              
                                contactObj.MailingState=statename; 
                            }
                            
                            if(wrds[0]==COUNTY1  && wrds[1] !=null && wrds[1] !=NBYA){
                                Id countyId=ARV_AP48_PartBLookupsdataProcessing.getCountyIdByName(wrds[1]); 
                                if(countyId !=null ){
                                    contactObj.GA_Mailing_County_ID__c=countyId;
                                }   
                           }
                        }catch(Exception e){
                            //system.debug('*********exception occured at '+e.getlinenumber()+':::msg:::'+e.getMessage());
                            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
                        }   
                        if(wrds[0]==ZIP1){
                            contactObj.MailingPostalCode=wrds[1];
                        }
                        if(wrds[0]==TITLE1){
                            contactObj.title=wrds[1]; 
                        }                   
                    }
                }
                Set<String> uniqRoles= new Set<String>();
                uniqRoles.addAll(finalRoleS.split(';'));  
                //system.debug('*********uniqRoles'+uniqRoles);               
                contactObj.GA_Contact_Role__c=String.join(new List<String>(uniqRoles), ';');
                contactObj.Accountid=accountId;  
                contactObj.ARV_Tech_ContractId__c=String.valueof(contractId);
                contactObj.ARV_Tech_Lctn_Cntrct_ids__C=finaldS.removeend(SEMICOLON);            
                contList.add(contactObj);
            }
            //insert contacts
            //system.debug('Contacts list::::::::::::::::'+contList);

            database.saveresult[] idsLst =database.insert(contList,false);      
            insertRelatedContacts(idsLst,contractId);
        }
        /*****************************************************************************************
        Mehtod Name   :  getContractsInfo   
        Description  :This method is used to get  contracts info.
        ******************************************************************************************/ 
        private static void insertRelatedContacts(database.saveresult[] idsLst,Id contractId){
            list<LocationPackage__c> list1 = new List<LocationPackage__c>();        
            list<contract> contractLst = new List<contract>();
            Map<Id,contract> contractMap = new Map<id,contract>();
            Map<Id,LocationPackage__c> locpkgMap = new Map<Id,LocationPackage__c>();
            Map<String,contract> conMap = new Map<String,contract>();
            for(integer i=0;i<idsLst.size();i++){
                if(idsLst.get(i).id !=null ){
                    ARV_AP07_QueryDataHelper.paramId1=idsLst.get(i).id;
                    list<Contact> cont =ARV_AP07_QueryDataHelper.getsObjects(CONTACTQRY,CONTACTWHERCLAUSE,NULL,LIMITCLAUSE);            
                    String ids = cont.get(0).ARV_Tech_Lctn_Cntrct_ids__C;               
                    String[] objs =ids.split(SEMICOLON);                
                    for(String str : objs){
                        Id myId = Id.valueof(str);
                        ContactsSet.add(idsLst.get(i).id);
                        String sObjName = myId.getSObjectType().getDescribe().getName();  
                        if(LCTNPKG.equals(sObjName)){
                            LocationPackage__c locpkg = new LocationPackage__c (id=myId);
                            if(cont.get(0).GA_Contact_Role__c.contains(ADMN)){
                               //ARV_Admin_Contact__c         
                                locpkg.ARV_Admin_Contact__c=idsLst.get(i).id;
                            }if(cont.get(0).GA_Contact_Role__c.contains(BILLING)){
                                //ARV_Billing_Contact__c 
                                locpkg.ARV_Billing_Contact__c=idsLst.get(i).id;
                            }
                            if(locpkgMap.containsKey(locpkg.id)){
                               //system.debug('Key already there');
                                list1.add(locpkg);
                            }else{

                               locpkgMap.put(locpkg.id, locpkg); 
                            }
                            
                            //database.update(locpkg,false);                        
                        }else if(CNTRCTOBJ.equals(sObjName)){
                            if(cont.get(0).GA_Contact_Role__c.contains(EXS)){
                                CEOCONTACTID =idsLst.get(i).id ;
                            }if(cont.get(0).GA_Contact_Role__c.contains(ADMN)){
                                PADMNCONTACTID=idsLst.get(i).id;
                            }if(cont.get(0).GA_Contact_Role__c.contains(OTHR)){
                                MVTRCONTACTID=idsLst.get(i).id;
                            }
                        }
                    }
                }
            }
            // to handle dml over here.
            database.update(locpkgMap.values(),false);
            if(list1.size()>0){
                database.update(list1,false);
            }
            Contract contractObj = new Contract(id=contractId);
            contractObj.ARV_CEO_Contact__c=CEOCONTACTID;
            contractObj.ARV_Principal_Admin_Contact__c=PADMNCONTACTID;
            contractObj.ARV_Mutual_Voter_Contact__c=MVTRCONTACTID;
            database.update(contractObj,false);

        }
    }