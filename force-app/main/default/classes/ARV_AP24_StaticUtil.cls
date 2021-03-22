/*****************************************************************************************
    Class Name   : ARV_AP24_StaticUtil 
    Date Created : 12-june-2019
    Created By   : IDC Offshore.
    Description  :This class is  for ARV_AP24_StaticUtil. 
    ******************************************************************************************/
public without sharing class ARV_AP24_StaticUtil {
        public static final string CLSNAME  ='ARV_AP24_QuoteProposalServiceCall';
        public static final string METHODNAME  ='invokeMethod';
        public static final String EXCEPSEPRATR=': ';
        public static final String ERRORMSG='Unable to retrieve SBC Document';
        public static map<Id,QuoteLineItem> qliMap =new map<Id,QuoteLineItem>();
        public static final string QUOTELINEITEMQUERY=system.label.ARV_CL23_QUOTELINEQUERY;
        public static final string QUOTELINEWHERE=' where QuoteId=:paramId1 and '+
            '(product2.Corporate_Form_String__c!=null and product2.Certificate_Rider_Unique_String__c!=null)';
        public static final string QUOTELINEWHEREPRODUCT=' where Id in:products and '+
            '(product2.Corporate_Form_String__c!=null and product2.Certificate_Rider_Unique_String__c!=null)';
        public static final String LIMITCLAUSE=' LIMIT 50'; 
        public static final string PRODUCTQUERY=system.label.ARV_CL24_ProductQuery;
        public static final string PRODUCTWHERE=' where id =:products and  Corporate_Form_String__c!=null';
        public static final string ORDERBYCLAUSE=' order by createddate desc';    
        public static final string ORDERBYCLAUSE1=' order by Name Asc';    
        public static final string DOCUMENTWHERE=' where keywords in :docstrings';
        public static final string BOTHTYPE='Both';
        public static final string METHODNAME1='generateDocument';
        public static final string METHODNAME2='refreshDocument';
        public static final string METHODNAME3='sendingEmails';
        public static final string PARAMSBC='sbcParam';
        public static final string PARAMBAAG='baagParam';
        public static final string DOCBAAG='D_BAAG.pdf';
        public static final String DOCCNTTYPE=system.label.ARV_CL09_DocCntType;
        public static final String SELECTEDEMAILS='selectedEmails';
        public static final String MYFINALBAAGPRODUCTS='finalBAAGProducts';
        public static final String MYFINALSBCPRODUCTS='finalSBCProducts';
        public static final String  MYDOCIDLIST= 'docIdList';
        public static final String  MYJOBSID = 'jobsId';
        public static final string PRODUCTWHERE1 =' where Id=:products';
        public static final string ATTACHMENTQUERY =system.label.ARV_CL25_AttachmentQuery;
        public static final string ATTACHMENTWHERE =' where parentId=:paramId1';
        public static final string ATTACHMENTWHERE1 =' where parentId=:products';
        public static final string ATTACHMENTWHERE3 =' where Id=:products';
        public static final string ATTACHMENTWHERE2 =' where Id not in:products and parentId =:paramId1';
        public static final String LIMITCLAUSE2=' LIMIT 1';
        public static final string JOBLIST='jobList';
        public static final string VSTOPTIMER='vStopTimer';
        public static final string DOCBLOBMAP='docBlobMap';
        public static final string MYDOCIDS='docIds';
        public static final string BCNVAL='bcn-';
        public static final string MYEMAILIST='myEmailLst';
        public static final string COMPLETED='Completed';
        public static final string FAILED='Failed';
        public static final string ABORTED='Aborted';
        public static final string ASYNCJOBQUERY='select count() from AsyncApexJob '+
                                            'where Id in :products and Status not in :mystring';
        public static final string ASYNCJOBQUERY1='select count() from AsyncApexJob ';
        public static final string ASYNCJOBQUERYWHERE=' where Id in :products and Status not in :mystring';
        public static  List<string> attachDescSet=null;
        public static set<id> baagProducts=null;
        public static  set<id> sbcProducts=null;
        public static Map<Id,String> baagStaticProductsMap=null;
        public static  set<id> finalBaagProducts=null;
        public static map<id,string> prdsToGetDocBCNMap=null;
        public static map<id,string> prdsToGetDocSBCMap=null;
        public static set<id> prdsToGetDocSBC=null;
        public static set<id> prdsToGetDocBCBS=null;
        public static map<id,QuoteLineItem> qlimap1 =null;
        public static map<id,QuoteLineItem> qlimap2 =null;
        public static List<string> jobIdList=null;
        public static final string RATEGRIDTYPE ='RateGridType';
        public static final string COVERPAGETYPE='CoverPageType';
        public static set<Id> jobIdSet=null;
        public static set<string> jobStatus =null;
        public static set<id> productsforSBC=null;
        public static set<id> productsforBAAG=null;
        public static set<id> finalSBC=null;
        public static set<id> finalBAAG=null;
        public static list<string> myAttachmentList=null;
        public static final string SCLSBCPLANS='sclSBCPlans';
        public static final string SCLBAAGPLANS='sclBAAGPlans';
        public static final string ATTACHMENTIDS='attachmentIds';
        public static final string SELECTEDSBC='selectedSBC';
        public static final string SELECTEDBAAG='selectedBAAG';
        public static final  string FINALVAL1='D1';
        public static final string FINALVAL2='D2';
        public static final  string FINALVAL3='D3';
        public static final string BAAGTYPE1='_BAAG.pdf';
        public static final string CENSUSGRID='censusGrid';
        public static final string QUOTEQUERY=System.label.ARV_CL26_QUOTEQUERY;
        public static final string QUOTEQUERYWHERE=' where id=:paramId1';
        public static final string BCBSCOMP='BCBSCOMP';
        public static final string BCNCOMP='BCNCOMP';
        public static boolean checkSpecificBCN=false;
        public static boolean checkSpecificBCBS=false;
        public static boolean checkAllBCBS=false;
        public static QuoteLineItem dynamicComp=null;
        public static QuoteLineItem allDynamicComp=null;
        public static final string DOCUMENTQUERY=system.label.ARV_CL30_DOCUMENTQUERY;
        public static final string DOCUMENTWHERE1 = ' WHERE Name=:paramName';
        public static final string DOCUMENTNAME='BCN65COMP';
        public static string validCheck=null;
        public static final string ISVALIDSPECIFIC='isSpecific';
        public static final string QUOTELINEWHERE1=' where QuoteId=:paramId1 and '+
            '(product2.Corporate_Form_String__c!=null and product2.Certificate_Rider_Unique_String__c!=null)'
            +'  and Carrier_Type__c=:paramName';
        public static final string SELECTEDBCBSM='selectedBCBSM';
        public static final string SELECTEDBCN='selctedBCN';
        public static  string isBCBSMselected=null;
        public static  string isBCNselected=null;
        public static final string SELECTED='selected';
        public static final string NOTSPECIFIC='notSpecific';
        public static final string ISSELECTEDBCBS='isSelectedBCBS';
        public static final string ISSELECTEDBCN='isSelectedBCN';
        public static final string ISSELECTEDBCBS1='isSelectedBCBS1';
        public static final string ISSELECTEDBCN1='isSelectedBCN1';
        public static final string CHECKED='checked';
        public static  string onlyBAAG=null;
        public static final string  ISBAAG='isBAAG';
        public static final string ISBAAG1='isBaag';
        public static final string SELECTEDBCBSMALL='selectedBCBSMall';
        public static final string SELECTEDBCNALL='selctedBCNall';
        public static final string ISV='V';
        public static final string ALLUSERS='AllUsers';
        public static final string ISPDF='.pdf';
}