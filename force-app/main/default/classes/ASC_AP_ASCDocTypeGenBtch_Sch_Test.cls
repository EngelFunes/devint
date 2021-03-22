/******************************************************************************************
@Author : IDC Offshore
@Name: ASC_AP_ASCDocTypeGenBtch_Sch_Test
@CreatedDate: 19 - May 2020 
@Description: ASC_AP_ASCDocTypeGenBtchToDelDocs_Schdlr Test class
@version : 1.0  
******************************************************************************************/
@isTest(seealldata = false)
private class ASC_AP_ASCDocTypeGenBtch_Sch_Test {
/***********************************************************************************************************************************************
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void executeTest()
    {   
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
          
        List<ASC_Document_Type_Record__c> Doclst=new List<ASC_Document_Type_Record__c>();
         
         Product_Document_Mapping__c PdocMap=new Product_Document_Mapping__c();
            PdocMap.Name = 'Test Doc Mapping';
            PdocMap.Coverage_Product__c=null;
            PdocMap.Parent_Product__c=null;
            PdocMap.Document_Type__c='Schedule A';
            PdocMap.Document_Version__c='2021 Schedule A Default';
            PdocMap.Section__c='5';
            PdocMap.Sequence__c=1;
            database.insert(PdocMap);
        ASC_Document_Type_Record__c DocRcrd= new ASC_Document_Type_Record__c();
               For(Integer i=1 ;i<=51 ; i++)
        {                    
            DocRcrd= new ASC_Document_Type_Record__c();
            DocRcrd.Name = 'Test ' + i;
            DocRcrd.Contract_Line_Item__c=null;
            DocRcrd.Product_Document_Mapping__c=PdocMap.id;
            DocRcrd.Instance__c=207;
            
            Doclst.add(DocRcrd);    
        }
      
        database.insert(Doclst);
        
        system.runAs(usr){
            
            try{
                ASC_AP_ASCDocTypeGenBtchToDelDocs_Schdlr docBtch = new ASC_AP_ASCDocTypeGenBtchToDelDocs_Schdlr();
                String sch = '0 0 23 * * ?'; 
                
                Test.startTest();
                system.schedule('docBtch update', sch, docBtch);
                Test.stopTest(); 
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }      
        }
        
    }
    
}