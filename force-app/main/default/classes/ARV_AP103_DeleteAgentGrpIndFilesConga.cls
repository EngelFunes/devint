/****
*Class Name   : ARV_AP103_DeleteAgentGrpIndFiles_Test
*Date Created : 11-August-2020
*Created By   : IDC Offshore
*Description  : This class is used for testing ARV_AP103_DeleteAgentGrpIndFilesConga.
****/
global without sharing class ARV_AP103_DeleteAgentGrpIndFilesConga {
    private static string YESVAL='yes';
    @InvocableMethod(label='Delete Renewal Packages' description='To delete individual pdfs')
    
    /**
    *Method Name : deleteRenwlPkgFiles
    *Description : This class is used for deleting individual files generated through ARV_AP100_GenerateRenwlPkgs.
    **/
    public static void deleteRenwlPkgFiles(RenewalPackages[] rnwPkgs){
        List<contentdocumentlink> cdIds1  = new List<contentdocumentlink>();
        List<contentdocumentlink> agntids = new List<contentdocumentlink>();
        List<contentdocumentlink> grpids  = new  List<contentdocumentlink>();
        for(RenewalPackages pkg:rnwPkgs){
            if(YESVAL.equals(pkg.congaAgent)) {
                agntids =[select id,contentdocument.title from contentdocumentlink where linkedentityid=:pkg.contractId and contentdocument.title like '%CongaAgent%'];
            }if(YESVAL.equals(pkg.CongaGroup)) {
                grpids =[select id,contentdocument.title from contentdocumentlink where linkedentityid=:pkg.contractId and contentdocument.title like '%CongaGroup%'];
            }
            if(agntids.size()>0){
                cdIds1.addAll(agntids);
            }
            if(grpids.size()>0){
                cdIds1.addAll(grpids);
            }
        }
        database.delete(cdIds1,false);
    }
    /**
    *Class Name   : RenewalPackages
    *Date Created : 11-August-2020
    *Created By   : IDC Offshore
    *Description  : This is the wrapper class used to delete individual Conga Agent & Group Renewal files.
    **/
    global class RenewalPackages {
        @InvocableVariable()
        global Id contractId;
        @InvocableVariable()
        global String congaAgent;
         @InvocableVariable()
        global String congaGroup;
    }
}