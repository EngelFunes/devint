/*@Author : Sundeep & Harsha
@Name: ASC_DocuSignParticipantHelper
@CreatedDate:  
@Description: ASC_DocuSignParticipantHelper class 
@version : 1.0  
@US# :US-3960 && 3962 && 3964
*/
public class ASC_DocuSignParticipantHelper {
    private static final String STATUS = 'Status';
    private static final String RECEIVECOPY='Receives a Copy';
    private static final String NAME='VP Admin';
    private static final string GROUPPRIMARY  ='Group Primary';
    private static final string SIGNER  ='Signer';
    private static final string AGENT  ='Agent';
    private static final string SEGMENTOWNER  ='Segment Owner';
    private static final string APPROVER  ='Approver';
    
    
    
    public static final Id ASC_SIGNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Group Signer').getRecordTypeId();
    public static final Id AGENT_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
    public static final Id SEGOWNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Segment Owner').getRecordTypeId();
    public static final Id VPADMIN_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('VP Admin').getRecordTypeId();
    
    
    
    /*US-3960 , US-3962 , US-3964 - create DocuSign Participants */
    public static void createDocuSignParticipants(List<Quote> listOfrecords,Map<id,sobject> oldMapOfrecords){ 
        
        try{                   
            
            Set<Id> accIdSet = new Set<Id>();
            Set<Id> terrIdSet = new Set<Id>();
            List<DocuSign_Participant__c> listOfParticipantsToInsert = new List<DocuSign_Participant__c>();
            Map<String,String> contractIdMap = new Map<String,String>();
            Map<Id,Id> oldNewContractMap;//new added
            Set<Id> quotIdSet = new Set<Id>();
            List<Id> contrIdSet = new List<Id>();
            //List<Id> AORIdset =new List<id>();//new added01
            if(!listOfrecords.isEmpty()){            
                for(Quote eachRec : [Select Id,Status,AccountId,Account.GA_Territory__c from Quote where Id IN:listOfrecords]){ 
                    sObject oldMapInContext = Schema.getGlobalDescribe().get('Quote').newSObject();                 
                    if(oldMapOfrecords !=null){
                        oldMapInContext = oldMapOfrecords.get(eachRec.Id);
                    } 
                    
                    if(oldMapInContext !=null 
                       && 'Accepted'.equals(eachRec.get(STATUS))
                       && String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS))){
                           accIdSet.add(String.ValueOf(eachRec.get('AccountId')));                                                                                                                               
                           terrIdSet.add(eachRec.Account.GA_Territory__c);   
                           quotIdSet.add(eachRec.Id);                        
                       }                                               
                }
                oldNewContractMap = new Map<Id,Id>();
                for(Contract contr:[Select Id,vlocity_ins__QuoteId__c,vlocity_ins__QuoteId__r.ParentContractId__c,vlocity_ins__QuoteId__r.Status
                                    from Contract where vlocity_ins__QuoteId__c IN:quotIdSet ORDER By LastModifiedDate DESC limit 1]){
                                        contractIdMap.put(contr.vlocity_ins__QuoteId__c,contr.Id);
                                        contrIdSet.add(contr.Id);
                                        //new added for clone
                                        //System.debug('Quote Status '+contr.vlocity_ins__QuoteId__r.Status);
                                        if(contr.vlocity_ins__QuoteId__r.Status =='Accepted' && contr.vlocity_ins__QuoteId__r.ParentContractId__c != NULL ){
                                            oldNewContractMap.put(contr.vlocity_ins__QuoteId__r.ParentContractId__c,contr.id);
                                        }//end added  clone
                                    }
                //To pass value for docsign cloning
                Map<id,String> aorId = new Map<id,String>();
                //Agent
                for(GA_AOR__c aor:[Select Id,GA_Contact_Id__c,GA_Contact_Id__r.name,GA_Contact_Id__r.FirstName,
                                   GA_Contact_Id__r.LastName 
                                   from GA_AOR__c where GA_Account_Id__c IN:accIdSet 
                                   AND GA_Agent_Active__c = true
                                   AND (GA_Commissioning_Agent__c = true OR GA_Servicing_Agent__c = true)
                                   LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                       
                                       
                                       aorId.put(aor.GA_Contact_Id__c, aor.GA_Contact_Id__r.name);
                                       DocuSign_Participant__c newdpRec = new DocuSign_Participant__c();
                                       newdpRec.Name = aor.GA_Contact_Id__r.FirstName+' '+aor.GA_Contact_Id__r.LastName;
                                       newdpRec.Agent__c = aor.GA_Contact_Id__c;
                                       newdpRec.Contract__c = !contrIdSet.isEmpty()?contrIdSet[0]:null;
                                       newdpRec.DocuSign_Action__c = APPROVER;
                                       newdpRec.RecordTypeId = AGENT_RECTYPEID;
                                       listOfParticipantsToInsert.add(newdpRec);
                                   }
                
                
                Map<String,String> regionMap = new Map<String,String>();
                Map<String,String> terrIdMap = new Map<String,String>();
                for(GA_Territory__c ter:[Select Id,GA_Sales_Office__c,GA_Sales_Office__r.GA_Region__c
                                         from GA_Territory__c where Id IN:terrIdSet 
                                         LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                             regionMap.put(ter.GA_Sales_Office__r.GA_Region__c,ter.Id);     
                                             terrIdMap.put(ter.Id,ter.GA_Sales_Office__r.GA_Region__c);                                        
                                         }
                
                Map<String,GA_Region__c> segOwnerIdMap = new Map<String,GA_Region__c>();
                List<GA_Region__c> regList = [Select Id,ASC_Sales_Segment_Owner__c,ASC_Sales_Segment_Owner__r.DelegatedApproverId,
                                              ASC_Sales_Segment_Owner__r.FirstName,ASC_Sales_Segment_Owner__r.LastName
                                              from GA_Region__c 
                                              where Id IN:regionMap.KeySet()
                                              LIMIT :UTIL_SLB.retrieveQueryLimitValue()];
                
                if(!regList.isEmpty()){
                    for(GA_Region__c reg:regList){
                        segOwnerIdMap.put(reg.Id,reg);
                    }
                }
                
                
                //Group Signer
                for(Quote eachRec : [Select Id,Status,AccountId,Account.GA_Territory__c,
                                     Account.GA_CEO__r.FirstName,
                                     Account.GA_CEO__r.LastName,
                                     Account.GA_Decision_Maker__r.FirstName,
                                     Account.GA_Decision_Maker__r.LastName,
                                     Account.GA_CEO__c,
                                     Account.GA_Decision_Maker__c,
                                     Account.GA_CEO__r.Email,
                                     Account.GA_Decision_Maker__r.Email
                                     from Quote where Id IN:listOfrecords]){ 
                                         sObject oldMapInContext = Schema.getGlobalDescribe().get('Quote').newSObject();                 
                                         if(oldMapOfrecords !=null){
                                             oldMapInContext = oldMapOfrecords.get(eachRec.Id);
                                         } 
                                         
                                         if(oldMapInContext !=null 
                                            && 'Accepted'.equals(eachRec.get(STATUS))
                                            && (String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS)))
                                            //&& String.isNotBlank(eachRec.ContractId)
                                            && String.isNotBlank(eachRec.Account.GA_CEO__c)
                                           )
                                         {
                                             DocuSign_Participant__c docsign = new DocuSign_Participant__c();
                                             docsign.Name = eachRec.Account.GA_CEO__r.FirstName +' '+ eachRec.Account.GA_CEO__r.LastName;
                                             docsign.Contact__c = eachRec.Account.GA_CEO__c;
                                             docsign.Contract__c = contractIdMap.ContainsKey(eachRec.Id)?contractIdMap.get(eachRec.Id):null;//eachRec.ContractId;
                                             docsign.Email__c = eachRec.Account.GA_CEO__r.Email;  
                                             docsign.First_Name__c = eachRec.Account.GA_CEO__r.FirstName;
                                             docsign.Last_Name__c = eachRec.Account.GA_CEO__r.LastName;
                                             if((String.ValueOf(eachRec.Account.GA_CEO__c) == String.ValueOf(eachRec.Account.GA_Decision_Maker__c))){
                                                 docsign.DocuSign_Action__c= GROUPPRIMARY;
                                             }
                                             else{
                                                 docsign.DocuSign_Action__c= SIGNER;
                                             }
                                             docsign.RecordTypeId = ASC_SIGNER_RECTYPEID;                                                 
                                             listOfParticipantsToInsert.add(docsign);                                                                                           
                                         } 
                                         if(oldMapInContext !=null 
                                            && 'Accepted'.equals(eachRec.get(STATUS))
                                            && (String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS)))
                                            && (String.ValueOf(eachRec.Account.GA_CEO__c) != String.ValueOf(eachRec.Account.GA_Decision_Maker__c))
                                            && String.isNotBlank(eachRec.Account.GA_Decision_Maker__c)
                                           )
                                         {
                                             DocuSign_Participant__c docsign1 = new DocuSign_Participant__c();
                                             docsign1.Name = eachRec.Account.GA_Decision_Maker__r.FirstName +' '+ eachRec.Account.GA_Decision_Maker__r.LastName;
                                             docsign1.Contact__c = eachRec.Account.GA_Decision_Maker__c;
                                             docsign1.Contract__c = contractIdMap.ContainsKey(eachRec.Id)?contractIdMap.get(eachRec.Id):null;//eachRec.ContractId;
                                             docsign1.Email__c = eachRec.Account.GA_Decision_Maker__r.Email;  
                                             docsign1.First_Name__c = eachRec.Account.GA_Decision_Maker__r.FirstName;
                                             docsign1.Last_Name__c = eachRec.Account.GA_Decision_Maker__r.LastName;
                                             docsign1.DocuSign_Action__c= GROUPPRIMARY;
                                             docsign1.RecordTypeId = ASC_SIGNER_RECTYPEID;                                                 
                                             listOfParticipantsToInsert.add(docsign1);  
                                         }
                                         
                                         //Segment Owner                                                
                                         if(oldMapInContext !=null 
                                            && 'Accepted'.equals(eachRec.get(STATUS))
                                            && String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS))
                                           ){
                                               
                                               DocuSign_Participant__c docsign= new DocuSign_Participant__c();                            
                                               if(segOwnerIdMap.ContainsKey(terrIdMap.get(eachRec.Account.GA_Territory__c))){
                                                   docsign.Name = segOwnerIdMap.get(terrIdMap.get(eachRec.Account.GA_Territory__c)).ASC_Sales_Segment_Owner__r.FirstName +' '+
                                                       segOwnerIdMap.get(terrIdMap.get(eachRec.Account.GA_Territory__c)).ASC_Sales_Segment_Owner__r.LastName;
                                               }                                           
                                               docsign.Segment_Owner__c = segOwnerIdMap.get(terrIdMap.get(eachRec.Account.GA_Territory__c)).ASC_Sales_Segment_Owner__c;
                                               docsign.DocuSign_Action__c= SIGNER;
                                               docsign.RecordTypeId = SEGOWNER_RECTYPEID;
                                               docsign.Contract__c = contractIdMap.ContainsKey(eachRec.Id)?contractIdMap.get(eachRec.Id):null;//eachRec.ContractId;
                                               
                                               listOfParticipantsToInsert.add(docsign);
                                               
                                           }               	                                  
                                     }  
                
                if(!listOfParticipantsToInsert.isEmpty()){
                    Insert listOfParticipantsToInsert; 
                    system.debug('listOfParticipantsToInsert are::::'+listOfParticipantsToInsert);
                    System.debug('oldNewContractMap'+oldNewContractMap);
                    if(!oldNewContractMap.isEmpty()){//added for clone
                        System.debug('Participant Clone IN');
                        cloneDocusignParticipents(oldNewContractMap,contrIdSet,aorId);
                    }// end added clone
                }
            }
        }
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e, 'ASC_DocuSignParticipantHelper', 'createDocuSignParticipants');
        }
    }  
    /*****************************************************************
@Description: cloneDocusignParticipents() method 
@Name : cloneDocusignParticipents method
@Param : 
@Return :void
******************************************************************/
    
    public static void cloneDocusignParticipents(Map<id,id> oldnewContractId,List<Id> newContractId, Map<id,String> aorId){
        List<DocuSign_Participant__c> DPList = new List<DocuSign_Participant__c>();
        Map<String, Id> newDPList = new Map<String, Id>();
        try{
            for(DocuSign_Participant__c dp:[select id,name,DocuSign_Action__c,RecordType.name,Contract__c,RecordTypeId,Routing_Order__c,Email__c,Contact__c,
                                            Contract__r.vlocity_ins__QuoteId__r.ParentContractId__c,TPA__c,Agent__c,Segment_Owner__c from DocuSign_Participant__c where 
                                            DocuSign_Participant__c.Contract__c IN :oldnewContractId.keySet() or DocuSign_Participant__c.Contract__c IN :oldnewContractId.values()]){
                                                if(dp.Contract__c == oldnewContractId.get(dp.Contract__r.vlocity_ins__QuoteId__r.ParentContractId__c)){
                                                    newDPList.put(dp.name,dp.RecordTypeId);  
                                                    System.debug('newDP '+dp);
                                                }
                                                else  { 
                                                    System.debug('old '+dp);
                                                    System.debug('aorId '+aorId);
                                                    System.debug('Record Typ Name Doc'+dp.recordtype.name);
                                                    if(dp.recordtype.name ==AGENT && aorId.containskey(dp.Agent__c)){
                                                        DPList.add(dp);
                                                        System.debug('appexist');
                                                    }
                                                    else if(dp.recordtype.name !=AGENT && dp.RecordType.name != SEGMENTOWNER){
                                                        System.debug('appnot '+dp);
                                                        DPList.add(dp); 
                                                    }
                                                    
                                                }
                                            }
            System.debug('newDP '+newDPList);
            List<DocuSign_Participant__c> DPinsertList = new List<DocuSign_Participant__c>();
            if(DPList.size()>0){
                System.debug('DPList Size '+DPList.size());
                for(DocuSign_Participant__c docSign : DPList){
                    System.debug(docSign.name+' Doc Name '+newDPList.containsKey(docSign.name)+' Doc rec '+newDPList.get(docSign.name));
                    if(!newDPList.containsKey(docSign.name) && docSign.RecordTypeId != newDPList.get(docSign.name)){
                        DocuSign_Participant__c dpIns= docSign.clone(false, false, false, false);
                        dpIns.Contract__c = oldnewContractId.get(dpIns.Contract__c);
                        //DPinsertList.add(docSign);
                        DPinsertList.add(dpIns);
                    }
                }
            }
            
            System.debug('DP '+DPinsertList);
            insert DPinsertList;
            system.debug('DPinsertList are++++>'+DPinsertList);
        }catch(Exception e){
            System.debug('DML Exception '+e);
        }
    } 
    /*****************************************************************
@Description: update DocuSign Participants method 
@Name : updateDocuSignParticipants method
@Param : 
@Return :void
******************************************************************/
    public static void updateDocuSignParticipants(List<DocuSign_Participant__c> listOfrecords,map<id,DocuSign_Participant__c> oldMapOfrecords){
        try{
            map<string,string> agentnamemap=new map<string,string>();
            map<string,string> contactnamemap=new map<string,string>();
            map<string,string> usernamemap=new map<string,string>();
            map<string,string> vpadminnamemap=new map<string,string>();
            set<id>userids=new set<id>();
            set<id>contactids=new set<id>();
            set<id> agentids=new set<id>();
            set<id> vpadminids=new set<id>();
            for(DocuSign_Participant__c cd:listOfrecords){
                agentids.add(cd.Agent__c);
                contactids.add(cd.contact__c);
                userids.add(cd.Segment_Owner__c);
                vpadminids.add(cd.VP_Admin__c);
                
                
                if(!agentids.isempty()){
                    for(Contact con: [select id,name from contact where id in:agentids ]){
                        agentnamemap.put(con.id,con.name);
                    }
                }
                
                if(!contactids.isempty()){
                    for(Contact con: [select id,name from contact where id in:contactids ]){
                        contactnamemap.put(con.id,con.name);
                    }
                }
                if(!userids.isempty()){
                    for(User use:[select id,name from user where id in:userids]){
                        usernamemap.put(use.id,use.name);
                    }
                }
                if(!vpadminids.isempty()){
                    for(User use:[select id,name from user where id in:vpadminids]){
                        vpadminnamemap.put(use.id,use.name);
                    }
                }
                
                if(oldMapOfrecords != null){
                    DocuSign_Participant__c cd1 = oldMapOfrecords.get(cd.Id);
                    //Agent
                    if(cd.RecordTypeId == AGENT_RECTYPEID){
                        if(cd1.Agent__c!=cd.Agent__c){
                            cd.Name=agentnamemap.get(cd.Agent__c);
                            
                        }
                    }
                    //Group signer
                    if(cd.RecordTypeId == ASC_SIGNER_RECTYPEID){
                        if(cd1.Contact__c!=cd.Contact__c){
                            cd.Name=contactnamemap.get(cd.Contact__c);
                            
                        }
                    }
                    //Segment owner
                    if(cd.RecordTypeId == SEGOWNER_RECTYPEID){
                        if(cd1.Segment_Owner__c!=cd.Segment_Owner__c){
                            cd.Name=usernamemap.get(cd.Segment_Owner__c);
                            
                        }
                    }
                    //VP Admin
                    if(cd.RecordTypeId == VPADMIN_RECTYPEID){
                        if(cd1.VP_Admin__c!=cd.VP_Admin__c){
                            cd.Name=vpadminnamemap.get(cd.VP_Admin__c);
                            
                        }
                    }
                }else{ //Agent
                    if(cd.RecordTypeId == AGENT_RECTYPEID){
                        cd.Name=agentnamemap.get(cd.Agent__c);                       
                        
                    }
                    //Group signer
                    if(cd.RecordTypeId == ASC_SIGNER_RECTYPEID){
                        cd.Name=contactnamemap.get(cd.Contact__c);
                    }
                    //Segment owner
                    if(cd.RecordTypeId == SEGOWNER_RECTYPEID){
                        cd.Name=usernamemap.get(cd.Segment_Owner__c);
                    }
                    //VP Admin
                    if(cd.RecordTypeId == VPADMIN_RECTYPEID){
                        cd.Name=vpadminnamemap.get(cd.VP_Admin__c);
                    }
                }
            }
            
        }
        
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e, 'ASC_DocuSignParticipantHelper', 'updateDocuSignParticipants');
        }
    }
    /*****************************************************************
@Description: 
@Name : ValidateAORondocusign() method 
@Param : 
@Return :void
******************************************************************/ 
    public static void ValidateAORondocusign(List<DocuSign_Participant__c> listOfrecords){
        try{
            Set<Id> accIdSet = new Set<Id>();
            List<DocuSign_Participant__c> listOfParticipantsToInsert = new List<DocuSign_Participant__c>();
            set<id> AccId = new set<id>(); 
            set<id> cntrIdSet = new set<id>();        
            
            for(DocuSign_Participant__c cd :listOfrecords){
                AccId.add(cd.Contract__c);
            }
            list<Contract> accntid=[select id,AccountId from contract where id in:AccId ];
            if(!accntid.isEmpty()){
                cntrIdSet.add(accntid[0].AccountId);
            }
            if(!listOfrecords.isEmpty()){   
                set<id> agentids=new set<id>();
                for(DocuSign_Participant__c cd:listOfrecords){
                    agentids.add(cd.Agent__c);
                    if(cd.RecordTypeId == AGENT_RECTYPEID){
                        list<GA_AOR__c> aor =[Select Id,GA_Contact_Id__c,GA_Account_Id__c,GA_Contact_Id__r.FirstName,
                                              GA_Contact_Id__r.LastName
                                              from GA_AOR__c where  GA_Account_Id__c IN:cntrIdSet 
                                              AND GA_Agent_Active__c = true AND (GA_Commissioning_Agent__c = true OR GA_Servicing_Agent__c = true) AND GA_Contact_Id__c=:cd.Agent__c 
                                              LIMIT :UTIL_SLB.retrieveQueryLimitValue()];
                        
                        if(aor.size()==0){
                            cd.adderror('The selected Agent does not exist in AOR Related List for this Group.');
                            
                        }
                        
                    }
                }
                
            }   
        }
        
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e, 'ASC_DocuSignParticipantHelper', 'ValidateAORondocusign');
        }
    }
    /*****************************************************************
@Name : VPAdminCreation() method 
@Description: To create VPAdmin record in DocuSign Particioants
@Param : 
@Return :void
******************************************************************/ 
    public static void VPAdminCreation(List<DocuSign_Participant__c> listOfrecords,map<id,DocuSign_Participant__c> oldMapOfrecords){
        try{
            map<string,string> usernamemap=new map<string,string>();
            set<id>userids=new set<id>();
            List<DocuSign_Participant__c> VAdminParticipantsToInsert = new List<DocuSign_Participant__c>();
            for(DocuSign_Participant__c cd :listOfrecords){
                userids.add(cd.Segment_Owner__c);
                
                if(cd.RecordTypeId == SEGOWNER_RECTYPEID && cd.Segment_Owner__c!=null && oldMapOfrecords == null){
                    User us=[select id,name,DelegatedApproverId from user where id=:cd.Segment_Owner__c and DelegatedApproverId!=null];
                    if(us!=null){                       
                        System.debug('Segment owner'+cd.Segment_Owner__r.DelegatedApproverId);
                        DocuSign_Participant__c docsign= new DocuSign_Participant__c();                            
                        docsign.Name =NAME;
                        docsign.VP_Admin__c=us.DelegatedApproverId;
                        docsign.DocuSign_Action__c= RECEIVECOPY;
                        docsign.RecordTypeId = VPADMIN_RECTYPEID;
                        docsign.Contract__c = cd.contract__c;
                        VAdminParticipantsToInsert.add(docsign);
                    }   
                }
                
                if(oldMapOfrecords != null){
                    DocuSign_Participant__c cd1 = oldMapOfrecords.get(cd.Id);
                    User us=[select id,name,DelegatedApproverId from user where id=:cd.Segment_Owner__c and DelegatedApproverId!=null];
                    
                    if(cd.RecordTypeId == SEGOWNER_RECTYPEID && cd1.Segment_Owner__c!=cd.Segment_Owner__c &&us!=null){
                        DocuSign_Participant__c docsign= new DocuSign_Participant__c();                            
                        docsign.Name =NAME;
                        docsign.VP_Admin__c=us.DelegatedApproverId;
                        docsign.DocuSign_Action__c= RECEIVECOPY;
                        docsign.RecordTypeId = VPADMIN_RECTYPEID;
                        docsign.Contract__c = cd.contract__c;
                        VAdminParticipantsToInsert.add(docsign);
                        
                    }
                    
                    
                }
                
            }
            
            System.debug('VP admin details'+VAdminParticipantsToInsert);
            if(!VAdminParticipantsToInsert.isEmpty()){
                Insert VAdminParticipantsToInsert; 
            }                                    
        }
        
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e, 'ASC_DocuSignParticipantHelper', 'VPAdminCreation');
        }
    }
    
    
}