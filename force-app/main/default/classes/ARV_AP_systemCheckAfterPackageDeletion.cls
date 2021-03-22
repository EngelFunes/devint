/********************************************************************************************
Class Name   : ARV_AP_systemCheckAfterPackageDeletion. 
Date Created : 06-Nov-2020
Created By   : IDC Offshore 
Description  : This is used for system check after package deletion 
*********************************************************************************/
global with sharing class ARV_AP_systemCheckAfterPackageDeletion implements vlocity_ins.VlocityOpenInterface {
private final static string GSNAME='groupSegmentName';
Private Static boolean CheckBCBSVolDen=false;
Private Static boolean CheckBCBSHBA=false;
Private Static boolean CheckBCNVolDen=false;
Private Static boolean CheckBCNVolVis=false;
Private Static boolean CheckBCNCDH=false;
Private Static string tempStatus='';
Private Static string COMMA=',';
Private Static String TERMVOLDEN=' Term Vol Dental';
Private Static String TERMHBA=' Term HBA';
Private Static String TERMBCNVOLVIS=' Term BCN Vol Vision';
Private Static String TERMBCNCDH='Term BCN CDH';
Private Static String GroupSegment='GroupSegments';
Private Static String FinalGroupSegment='finalGroupSegmentsPlans';
Private Static String GSID='GSId';
Private Static String groupSegmentId='groupSegmentId';
Private Static String GSCARRIER='GSCarrier';
Private Static String GSDENVOLTYPE='GSdenVolType';
Private Static String GSVISVOLTYPE ='GSvisVolType';
Private Static String GSPRODUCTFAMILY ='GSProductFamily';
Private Static String GSFCDHQ='GSf_CDHQuestion_GroupSegments';
private static final String SPACE='';
private static String ADMINSTRATIVE='Administrative';
private static  String TEMPSTAT='tempStatus';
private static  String delPck='delpckg';
private static  String CHECKBCNDEN='CheckBCNVolDen';
private static  String CHECKBCNVIS='CheckBCNVolVis';
private static  String CHECKCDH='CheckBCNCDH';
private static  String CHECKBCBSDEN= 'CheckBCBSVolDen';
private static  String CHECKHBA='CheckBCBSHBA';

/*****************************************************************************************
Method Name : invokeMethod. 
Date Created : 28-SEP-2020
Created By   : IDC Offshore
Description  :This is used for system check after package deletion
*******************************************************************************************/
global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options){           
                                    Boolean success = true;
                                    try{
                                        if (methodName   == 'systemCheckAfterPackageDeletion'){
                                        systemCheckAfterPackageDeletion(input,output,options);
                                        }
                                    }catch(Exception e){
                                        
                                        GA_LogExceptionCls.LogExcp(e, 'ARV_AP_systemCheckAfterPackageDeletion', 'METHODNAME');
                                        //throw new AuraHandledException(e.getMessage()+e.getlinenumber());
                                    }
                                    return success;
}
/*****************************************************************************************
Method Name : systemCheckAfterPackageDeletion 
Date Created : 06-NOV-2020
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting GWC Flow
*******************************************************************************************/
    
global void systemCheckAfterPackageDeletion(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
{
map<string,Object> strObjectMap;
map<string,Object> strObjectgsMap;
    try{
    String contractId= String.valueof(input.get('contractId'));
    Contract con = new Contract();
    con=[select id,ARV_GWC_System_Check_1_Status__c,ARV_TypeofCheck__c from Contract where id=:contractId];
        //System.debug('contractId:::'+contractId);
        List<object> grpseg= (List<object>)input.get(GroupSegment);
        system.debug('**groupsegments**'+grpseg);
        list<object> fnl1GSDetails = (list<object>)input.get(FinalGroupSegment);
        system.debug('**finalgs**'+fnl1GSDetails);
        Set<Id> grpsegs= new Set<Id>();
        Set<Id> fgps= new Set<Id>();
        Set<Id> dgs= new Set<Id>();
        for(object gpkg: grpseg){
            strObjectgsMap=(map<String,object>)gpkg;
            grpsegs.add(String.valueOf(strObjectgsMap.get(GSID)));
        }
        for(object fpkg: fnl1GSDetails){
            strObjectgsMap=(map<String,object>)fpkg;
            fgps.add(String.valueOf(strObjectgsMap.get(groupSegmentId)));
        }
        System.debug('grpsegs'+grpsegs);
        System.debug('fgps'+fgps);
        for(Id gsreds: grpsegs){
            if(!fgps.contains(gsreds)){
               dgs.add(gsreds); 
            } 
        }
        System.debug('dgs'+dgs);
        System.debug('Size'+grpseg.size());
        System.debug('Size'+fnl1GSDetails.size());
        for(object pkg: grpseg){
            strObjectgsMap=(map<String,object>)pkg;
            String grpsid=String.valueOf(strObjectgsMap.get(GSID));
            for(Id delGs: dgs){
                if(delGs==grpsid){
                    String carrier=String.valueOf(strObjectgsMap.get(GSCARRIER));
                  	System.debug('carrier::'+carrier);
                    String volden=String.valueOf(strObjectgsMap.get(GSDENVOLTYPE));
               		System.debug('volden::'+volden);
                    String volvis=String.valueOf(strObjectgsMap.get(GSVISVOLTYPE));
                    System.debug('volvis::'+volvis);
                    String family=String.valueOf(strObjectgsMap.get(GSPRODUCTFAMILY)); 
                    System.debug('family::'+family);
                    String cdh=String.valueOf(strObjectgsMap.get(GSFCDHQ));
                     if(carrier==ARV_AP41_StringLiteralUtils.BCBSMVAL && volden==ARV_AP41_StringLiteralUtils.VOLUNTARY){
                            System.debug('CheckBCBSVolDen'+CheckBCBSVolDen);
                            CheckBCBSVolDen=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
                       }
                     if(carrier==ARV_AP41_StringLiteralUtils.BCBSMVAL && family==ARV_AP41_StringLiteralUtils.HBACH){
                            System.debug('CheckBCBSHBA'+CheckBCBSHBA);    
                            CheckBCBSHBA=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
                     }
                     if(carrier==ARV_AP41_StringLiteralUtils.BCNTYPE && volden==ARV_AP41_StringLiteralUtils.VOLUNTARY){
                            CheckBCNVolDen=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
                     }
                     if(carrier==ARV_AP41_StringLiteralUtils.BCNTYPE && volvis==ARV_AP41_StringLiteralUtils.VOLUNTARY){
                            CheckBCNVolVis=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
                     }
                     if(carrier==ARV_AP41_StringLiteralUtils.BCNTYPE && family==ARV_AP41_StringLiteralUtils.HSA && cdh==ARV_AP41_StringLiteralUtils.YESVAL)
                            {
                            CheckBCNCDH=true;
                     }
                }
        }
                            
        } 
        
				tempStatus+= CheckBCBSVolDen?TERMVOLDEN+COMMA:SPACE;
				tempStatus+= CheckBCBSHBA?TERMHBA+COMMA:SPACE;      
				tempStatus+= CheckBCNVolDen?TERMVOLDEN+COMMA:SPACE;
				tempStatus+= CheckBCNVolVis?TERMBCNVOLVIS+COMMA:SPACE;
				tempStatus+= CheckBCNCDH?TERMBCNCDH+COMMA:SPACE;
				tempStatus = tempStatus.removeEnd(COMMA);
				System.debug('tempStatus'+tempStatus);
				if(CheckBCBSVolDen || CheckBCBSHBA || CheckBCNVolDen || CheckBCNVolVis || CheckBCNCDH)
				{
				con.ARV_TypeofCheck__c= ADMINSTRATIVE;
				con.ARV_GWC_System_Check_1_Status__c=tempStatus; 
				}
				update con;
	}
   catch(Exception e)
        {
            system.debug('line number@@ '+e.getLineNumber()); 
            system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP_systemCheckAfterPackageDeletion', 'systemCheckAfterPackageDeletion');
        }
}
}