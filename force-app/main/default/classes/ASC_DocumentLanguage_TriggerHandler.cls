/******************************************************************************************************************************************
@Author : Dinesh
@Name: ASC_DocumentLanguage_TriggerHandler
@CreatedDate: 27 - July - 2020 
@Description: This handler class is used to call the respective helper methods in the ASC_DocumentLanguage_TriggerHelper class.
@version : 1.0  
*****************************************************************************************************************************************/
public class ASC_DocumentLanguage_TriggerHandler {
        
    private static final string CLSNAME  ='ASC_DocumentLanguage_TriggerHandler';
    private static final string METHODNMEBEFOREINSERT  ='beforeinsert';
    private static final string METHODNMEBEFOREUPDATE='beforeUpdate';
    private static boolean isExecuting = false;
    /*********************************************************************************************************************************************
    @Description: beforeinsert() method 
    @Name : beforeinsert
    @Param : list<ASC_Document_Language__c> doclList
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void beforeinsert(list<ASC_Document_Language__c> doclList)
    {
        try{    
          /*US-3309 -Added By Dinesh -  before insert - duplicate check - To restrict the user to create more than 1 active/draft record.*/
          ASC_DocumentLanguage_TriggerHelper.checkForDuplicateDocLanguage(doclList,null);
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREINSERT);}
    }         
    /*********************************************************************************************************************************************
    @Description: beforeUpdate() method 
    @Name : beforeUpdate
    @Param : list<ASC_Document_Language__c> doclList
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************************/ 
    public static void beforeUpdate(list<ASC_Document_Language__c> doclList,map<id,ASC_Document_Language__c> doclOldMap)
    {
        try{  
          /*US-3309 -Added By Dinesh -  before insert - duplicate check - To restrict the user to create more than 1 active/draft record.*/
          ASC_DocumentLanguage_TriggerHelper.checkForDuplicateDocLanguage(doclList,doclOldMap);
          //ASC_Doclangupdate.DocLanguageTextUpdation(doclList,doclOldMap);
          ASC_AutoGenerateFiles.checkForDocLanguageTextUpdation(doclList,doclOldMap);      
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREUPDATE);}
    }
    
    public static void afterupdate(list<ASC_Document_Language__c> doclList,map<id,ASC_Document_Language__c> doclOldMap)
    {
        try{                                               
            if(!ASC_Doclangupdate.isExecuting){
            ASC_Doclangupdate.isExecuting = true;  
            ASC_Doclangupdate.docLanguageTextUpdation(doclList,doclOldMap);       
            }                        
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, 'afterupdate');}
    }

   }