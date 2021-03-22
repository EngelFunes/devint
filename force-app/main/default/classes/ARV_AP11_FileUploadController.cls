/***********************************************************************
Class Name   : ARV_AP11_FileUploadController
Date Created : 05/10/2019 (mm/dd/yyyy)
Created By   : IDC Offshore - BCBSM Team
Description  : This is a class for ARV_CMP02_UploadLogo Lightning component.
**************************************************************************/
public without sharing class ARV_AP11_FileUploadController {
    private static Id contId;
    private static Id attaChmr;
    public static final STRING DESCRIPTION = 'Uploaded from BCBSM';
    public static final STRING EMPTY = '';
    public static final STRING UTF ='UTF-8';
    public static final STRING SLASH= '/';
    public static final STRING VIEW='servlet/servlet.FileDownload?file=';
    public static final STRING CLOSEBRACE=']';
    public static final STRING EQUALS='=';
    private static final string CONTACTQUERY='select id,agent_logo__c from contact';
    private static final string CONTACTWHERE=' where id =:paramId1';
    private static final STRING ORDERBYCLAUSE='';
    private static final STRING LIMITCLAUSE=' Limit 1';
    private static final string CLASSNAME  ='ARV_AP11_FileUploadController';
    private static final string METHODNAMESBCDOC  ='saveChunk';
    static final List<String> IMAGEFORMAT = new List<String> {'.png', '.jpg'};
    @AuraEnabled
    /************************************************************************************
    Method Name : saveChunk
    Parameters  : None
    Return type : void
    Description : 1. check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
    2.  which is save the check data and return the attachemnt Id after insert, 
    3.  next time (in else) we are call the appentTOFile() method
    4.for update the attachment with reamins chunks  
    *************************************************************************************/
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        try{
            system.debug('Inside class');
            if (EMPTY.equals(fileId)) {
                fileId = saveTheFile(parentId, fileName, base64Data, contentType);
                //updatecontact(contid);
            } else {
                appendToFile(fileId, base64Data);
            }
            return fileId!=null?Id.valueOf(fileId):null;
        }
        catch(exception e)        {
            //system.debug('eeeee'+e.getLineNumber());
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAMESBCDOC);
           // throw new AuraHandledException(e.getMessage());
           throw e;
        }  
    
    }
    
    /************************************************************************************
Method Name : saveTheFile
Parameters  : None
Return type : void
Description : Method to create attchment and save the file.  
*************************************************************************************/
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        Attachment oAttachment = new Attachment();
            //string base64Value = EncodingUtil.urlDecode(base64Data, UTF); 
            base64Data = EncodingUtil.urlDecode(base64Data, UTF);       
            Id userId = UserInfo.getUserId();
            user userlist = [select Id,contactId from user where id=:userId LIMIT 1];
            contId=userlist.contactId;      
            list<attachment> att = [select id,description from Attachment where parentId=:contId and description=:DESCRIPTION Limit 10];
            if(att.size() >= 1){
                Database.delete(att);               
            }
            oAttachment.parentId = contId;        
            oAttachment.Body = EncodingUtil.base64Decode(base64Data);
            oAttachment.Name = fileName;
            oAttachment.ContentType = contentType;
            oAttachment.description = DESCRIPTION;          
            Database.insert(oAttachment);
            attaChmr= oAttachment.Id;
            updatecontact(contId);      
        return oAttachment.Id!=null?oAttachment.Id:null;
    }
    
    /************************************************************************************
    Method Name : appendToFile
    Parameters  : None
    Return type : void
    Description : Method to append the file if file already exist.
    next time (in else) we are call the appentTOFile() method
    for update the attachment with reamins chunks  
    *************************************************************************************/
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, UTF);
        Attachment attc = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId LIMIT 1
        ];
        String existingBody = EncodingUtil.base64Encode(attc.Body);
        attc.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        Database.update(attc);
        //update attc;
    }
    
    /************************************************************************************
    Method Name : updatecontact
    Parameters  : None
    Return type : void
    Description : Method to update the Agent_logo__c field on contact object.
    *************************************************************************************/
    public static void updatecontact(Id contid1){
        ARV_AP07_QueryDataHelper.paramId1 = contid1;
        List<contact> cidlist= ARV_AP07_QueryDataHelper.getsObjects(CONTACTQUERY,CONTACTWHERE,ORDERBYCLAUSE,LIMITCLAUSE);
        List<contact> cidlistdfd=new List<contact>();
        for(contact c:cidlist){            
            string orgbaseurl=string.valueof(URL.getOrgDomainUrl());            
            string[] str=orgbaseurl.split(EQUALS);
            string finalstring=str[1];
            string totalstring=finalstring.removeEnd(CLOSEBRACE);
            c.Agent_Logo__c=totalstring +SLASH +VIEW+attaChmr;
            cidlistdfd.add(c);
        }
        Database.update(cidlistdfd); 
    }
}