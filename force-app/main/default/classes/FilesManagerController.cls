public inherited sharing class FilesManagerController {
    
    @AuraEnabled
    public static ContentVersion saveFile(Id idParent, String strFileName, String base64Data) {
        
            List<contentVersion> contentVersionList = [SELECT Id FROM contentVersion where Title =: strFileName AND FirstPublishLocationId =: idParent];
            if(contentVersionList.isEmpty()){
                // Decoding base64Data
                base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
                // inserting file
                ContentVersion cv = new ContentVersion();
                cv.Title = strFileName;
                cv.PathOnClient = '/' + strFileName;
                cv.FirstPublishLocationId = idParent;
                cv.VersionData = EncodingUtil.base64Decode(base64Data);
                cv.IsMajorVersion = true;
                Insert cv;
                return cv;
            }
            else{
                return null;
            }
        
    }
    
    @AuraEnabled
    public static list<contentversion> releatedFiles(Id idParent){
        list<id> lstConDocs = new list<id>();
        for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:idParent]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }
        if(!lstConDocs.isEmpty()) {
            return [SELECT Id, Title, ContentSize, ContentDocumentId, ContentModifiedDate FROM ContentVersion WHERE ContentDocumentId IN :lstConDocs];
        }
        else {
            return null;
        }
        
    }
    
    @AuraEnabled
    public static String deleteDocuments(List<String> docIds){
        
        system.debug('entered here');
        
        delete [SELECT Id FROM ContentDocument WHERE Id=:docIds];
        
        return 'SUCCESS';
        
    }
    
}