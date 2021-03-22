/*********************************************************************************************
Class Name   : ARV_AP_GWCCOEXISTANCERules. 
Date Created : 7-Sept-2020
Created By   : IDC Offshore
Description  :This is the class for Group segment validation in GWC flow.
******************************************************************************************/
global class  GWCCOEXISTANCERulesDemo implements vlocity_ins.VlocityOpenInterface2 {
    
    private static final string SIMPLYBLUE='Simply Blue';
    private static final string CBH='Community Blue HRA';
    private static final string SIMPLYBLUEPPO='Simply Blue PPO';
    private static final string SIMPLYBLUEHRA='Simply Blue HRA';
    private static final string SIMPLYBLUEHSA='Simply Blue HSA';
    private static final string BLUEROUTINECARE='Simply Blue Routine Care';
    private static final string PHYSCHOICE='Physician Choice Plan';
    private static final string HEALTHYACHIEVE='Healthy Blue Achieve';
    private static final string COMMUNITYBLUE='Community Blue';
    private static final string BCNHMO='BCN HMO';
    private static final string BLUEELECTPLUS='Blue Elect Plus'; 
    private static final string HEALTHYLIVING='Healthy Blue Living';
    private static final string ROUTINECARE='Routine Care';
    private static final string BCNHRA='BCN HRA';  
    private static final string BCNHSA='BCN HSA';
    private static final string OPENBRACE  = '[';
    private static final string CLOSEBRACE  = ']';
    private static final string SELECTQUERY = System.Label.ARV_CL24_ProductQuery;
    private static final string WHERECLAUSE  = ' where id IN : products and vlocity_ins__Type__c=: paramName ' ;
    private static final string ERRORMSG='Coexistence rules have been violated within  ';
    private static final string ERRORMSGPHY=' The PCP/Physicians Choice plan you selected is not compatible with at least 1 other plan.';
    private static final string ERROROK='OK';
    private static final string VALERROR='error';
    private static final string PED='Pediatric';
    public static boolean checkphy = false;
    public boolean hasAdultD=false;
    public boolean hasAdultV=false;
    /*******************************************************************************************  
    Method name : invokeMethod
    Params     : map
    Return Type : null
    Description :this method is used to invoke the enrollMedicalValidation method
    *******************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                        Map<String,Object> output, Map<String,Object> options) 
    {           
       try{
            gwcCoExistanceRules(input,output,options);
       }catch(Exception e){
        system.debug('error occured********'+e.getlinenumber()+'::::'+e.getmessage());  
       } 
        return true;
    }
    /*****************************************************************  
    Method name : gwcBCNCoexistance
    Params     : map
    Return Type : null
    Description :this method is used to invoke the enrollMedicalValidation method    **********************************************************************/
    global String gwcCoExistanceRules(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
    {    
        String msg=null;
        String lobMsg=null;
        Map<Id,String> lobsLst = new Map<Id,String>();
        String medMsg='';
        //Boolean hasAdultD = false;
        //Boolean hasAdultV = false;
        List<groupSgmntsDtails> gsDetails = new List<groupSgmntsDtails>();
        Set<String> lobLst = new Set<String>();
        Set<String> orthoset = new Set<String>();
        Set<String> dntlVLset = new Set<String>();
        Set<String> vsnVLset = new Set<String>();
        Set<Id> prdSet=new Set<Id>();
        Map<Id,String> prdNmLst = new Map<Id,String>();
        Set<groupSgmntsDtails> GSset = new Set<groupSgmntsDtails>();
        try{
            gsDetails = jsonToList(input.get('finalGroupSegmentsPlans'));
            String emsg =null;
            String gsName='';
            for(groupSgmntsDtails gsd:gsDetails){
                system.debug('Febgsd.dentalPlan.contains(PED)'+gsd.dentalPlan.contains(PED));
                if(gsd.dentalPlan!= null && gsd.dentalPlan != '' &&  !gsd.dentalPlan.contains(PED) ){
                    hasAdultD = true;
                    break;
                }
            }
            for(groupSgmntsDtails gsd:gsDetails){
                system.debug('Febgsd.visionPlan.contains(PED)'+gsd.visionPlan.contains(PED));
              if(gsd.visionPlan != null && gsd.visionPlan != '' && !gsd.visionPlan.contains(PED)){
                    hasAdultV = true;
                    break;
                }
            }
            for(groupSgmntsDtails gsd:gsDetails){
                //if(!gsd.dentalPlan.contains(PED) && !gsd.visionPlan.contains(PED)){
                if(hasAdultD && hasAdultV && !gsd.dentalPlan.contains(PED) && !gsd.visionPlan.contains(PED)){
                	GSset.add(gsd);
                   system.debug('if'); 
                    system.debug('if  hasAdultD'+hasAdultD);
                     system.debug('if  hasAdultV'+hasAdultV);
                    system.debug('if 1 contains dental ped'+gsd.dentalPlan.contains(PED));
                    system.debug('if 1 contains vision ped'+gsd.visionPlan.contains(PED));    
            	}
				else if(hasAdultD && !hasAdultV && !gsd.dentalPlan.contains(PED)){
                   
					GSset.add(gsd);
                    
                    system.debug('else if 2');
                     system.debug('else if 2 hasAdultD'+hasAdultD);
                    system.debug('else if 2 contains dental ped'+gsd.dentalPlan.contains(PED));
                        
                
				}else if(!hasAdultD && hasAdultV && !gsd.visionPlan.contains(PED)){
					GSset.add(gsd);
                    
                    system.debug('else if 3');
                     system.debug('else if 3 hasAdultD'+hasAdultD);
                    system.debug('else if 3 contains dental ped'+gsd.dentalPlan.contains(PED));
                        
                
				}
                
				else if(!hasAdultD && !hasAdultV && gsd.visionPlan.contains(PED) && gsd.dentalPlan.contains(PED)){
                   
                        GSset.add(gsd);
                         system.debug('else if 4');
                         system.debug('else if 4 hasAdultV'+hasAdultV);
                    	system.debug('else if 4 contains dental ped'+gsd.dentalPlan.contains(PED));
                        system.debug('else if 4 visionPlan'+gsd.visionPlan.contains(PED));
                    
				}
                    
			}
           // }
            system.debug('FebGSset'+GSset);
            system.debug('febhasAdultD'+hasAdultD);
            system.debug('febhasAdultV'+hasAdultV);
            List<groupSgmntsDtails> lgs=new List<groupSgmntsDtails>();
			lgs.addAll(GSset);
            gsDetails = lgs;
            for(groupSgmntsDtails gsd:gsDetails){
                system.debug('febBefIFhasAdultD'+hasAdultD);
                system.debug('febBefIFgsd.dentalPlan.contains(PED)'+gsd.dentalPlan.contains(PED));
               if((gsd.SisterParentID =='' || gsd.SisterParentID == null)
                 // (((hasAdultD && !gsd.dentalPlan.contains(PED)) || (!hasAdultD && gsd.dentalPlan.contains(PED))) 
			  // && (((hasAdultV && !gsd.visionPlan.contains(PED)) || (!hasAdultV && gsd.visionPlan.contains(PED)))))
                //  || (gsd.dentalPlan.contains(PED) && gsd.visionPlan.contains(PED))
                 ){
                   system.debug('febAftIFhasAdultD'+hasAdultD);
                system.debug('febAftIFgsd.dentalPlan.contains(PED)'+gsd.dentalPlan.contains(PED));
                emsg='';      
                emsg+=gsd.medPrdId!=''?'M':'';
                emsg+=gsd.denPrdId!=''?'D':'';
                emsg+=gsd.visPrdId!=''?'V':'';
                lobLst.add(emsg);
                system.debug('FebsecondFor');
                gsName+=gsd.groupSegmentName+', ';
                    
                if(gsd.medPrdId !=''){
                    prdSet.add(gsd.medPrdId);
                    prdNmLst.put(gsd.medPrdId,gsd.groupSegmentName);
                }
                if(gsd.dentalOrtho!=''){
                    orthoset.add(gsd.dentalOrtho);
                    
                }
                if(gsd.isDenVolStr!=''){
                    dntlVLset.add(gsd.isDenVolStr);
                    
                }   
                if(gsd.isVisVolStr!=''){
                    vsnVLset.add(gsd.isVisVolStr);
                    
                }
                if(lobLst.size()>1 || orthoset.size()>1 || dntlVLset.size()>1 || vsnVLset.size()>1){
                    lobMsg =ERRORMSG+gsName.removeEnd(', ') ;
                    break;
                }
                  System.debug('febForlobMsg'+lobMsg); 
            }
            }
            system.debug('FeblobLst'+lobLst.size());
            system.debug('Feborthoset'+orthoset.size());
            system.debug('FebdntlVLset'+ dntlVLset.size());
            system.debug('FebvsnVLset'+vsnVLset.size());
            
            if(lobMsg == null && emsg !='' && !emsg.equals('M')){
                lobMsg=sameLobExstCheck(gsDetails);
                System.debug('feblobMsg'+lobMsg);
            }   
            if(lobMsg!= null && lobMsg!= ERROROK){
                output.put('LobCoExistanceMsg',lobMsg+medMsg.removeEnd(','));
                system.debug('Febemsg:msg:::::::'+emsg+'::'+lobMsg);
            }else{
                if((lobMsg == 'OK' || lobMsg == null) && prdSet.size()>0){
                    msg=validatePackage(prdSet,prdNmLst);
                    String[] finalMsg=null; 
                    if(msg !=null){             
                        if(msg.contains('BCN:')){
                            finalMsg=msg.split('BCN:');
                        }
                        else{
                            finalMsg=msg.split(':');
                        }                        
                        output.put('BCBSMCoExistanceMsg',finalMsg[0].removeEnd(':'));
                         system.debug('FebBCBSMCoExistfinalMsg::'+finalMsg[0].removeEnd(':'));
                        output.put('checkPhysion',checkphy);
                        if(finalMsg[1] !=null){
                            output.put('BCNCoExistanceMsg',finalMsg[1]);
                        }
                    }
                }
            }
            /*if(1==1){
             MaxPlansCheck mp =new MaxPlansCheck();
             mp.countcheck(input,output,options);  //US3479 (Max plans count)
             ARV_AP_GWCManagePCPs gw= new ARV_AP_GWCManagePCPs(); //US3649 (Physician county check)
             gw.physExistanceRules(input,output,options);
            }*/
        }catch(Exception e){
            system.debug('error occured********'+e.getlinenumber()+'::::'+e.getmessage());
            system.debug('line number@@ '+e.getLineNumber()); 
            system.debug('getMessage @@ '+e.getMessage());   
        } 
        String finalVoilation=lobMsg!=null?lobMsg:msg;
        return finalVoilation;
    }
    public string sameLobExstCheck(List<groupSgmntsDtails> gsDetails){
        String lmsgcheck=null;
        Map<Id,String> prdNmLst = new Map<Id,String>();
        Map<String,String> dntlOrthoMap= new Map<String,String>();
        Map<String,String> dntlVlntryMap= new Map<String,String>();
        Map<String,String> vsnVlntryMap= new Map<String,String>();
        Map<Id,String> lobsLst = new Map<Id,String>();
        String medMsg='';
        for(groupSgmntsDtails gsd:gsDetails){
       // if( ((hasAdultD && !gsd.dentalPlan.contains(PED)) || (!hasAdultD && gsd.dentalPlan.contains(PED))) || 
         //          (((hasAdultV && !gsd.visionPlan.contains(PED)) || (!hasAdultV && gsd.visionPlan.contains(PED))))){
            if(gsd.medPrdId !=''){
                prdNmLst.put(gsd.medPrdId,gsd.groupSegmentName);
            }
            if(gsd.dentalOrtho!=''){
                dntlOrthoMap.put(gsd.dentalOrtho,gsd.groupSegmentName);
            }
            if(gsd.isDenVolStr!=''){
                dntlVlntryMap.put(gsd.isDenVolStr,gsd.groupSegmentName);
            }
            if(gsd.isVisVolStr!=''){
                vsnVlntryMap.put(gsd.isVisVolStr,gsd.groupSegmentName);
            }
            medMsg+=prdNmLst.get(gsd.medPrdId)+', ';
            String dID=gsd.denPrdId!=''?gsd.denPrdId:':';
            String vID=gsd.visPrdId!=''?gsd.visPrdId:':';
            if(lobsLst.size()<1){
              lobsLst.put(gsd.medPrdId,dID+':'+vID);
            }
            else{                

                if(!lobsLst.containsKey(gsd.medPrdId)){
                    lobsLst.put(gsd.medPrdId,dID+':'+vID);
                }               
                else if(lobsLst.get(gsd.medPrdId).equals(dID+':'+vID)){
                    lmsgcheck =ERROROK ;
                }else{
                    lmsgcheck =ERRORMSG+medMsg.removeEnd(', ')  ;
                    break;
                }
            }
        
        }       
        return lmsgcheck;
    }
    /*************************************************************************  
    Method name : validatePackage
    Params     : List
    Return Type : String
    Description :validatePackage() logic to validate products selected for a package in enrollment process
    *************************************************************************/ 
    public String validatePackage(Set<Id> prodList,Map<Id,String> prdNamMap){
        String finalMsg=null;
        List<String> bcbsmMap = new List<String>();
        List<String> bcnMap = new List<String>();
        List<String> pcpList = new List<String>();
        String bcmGSName='';
        String bcnGSName='';
        Integer bcnProducts =0;
        String bcBsmMsg=null;
        String bcnMsg=null;        
        ARV_AP07_QueryDataHelper.products = prodList;
        ARV_AP07_QueryDataHelper.paramName = ARV_AP41_StringLiteralUtils.MEDICALTYPE;  
        try{
            for(Product2 prod: (List<Product2>)ARV_AP07_QueryDataHelper.getsObjects(SELECTQUERY,WHERECLAUSE,null,null)){            
                if(prod.Carrier_Type__c == ARV_AP41_StringLiteralUtils.BCBSTYPE){
                    bcbsmMap.add(prod.Family);
                    bcmGSName+=prdNamMap.get(prod.Id)+', ';                 
                }else if(prod.Carrier_Type__c == ARV_AP41_StringLiteralUtils.BCNTYPE && !prod.PCP_Focus__c){
                    bcnMap.add(prod.Family); 
                    bcnGSName+=prdNamMap.get(prod.Id)+', ';
                }else if(prod.PCP_Focus__c){
                    pcpList.add(prod.Family); 
                    bcnGSName+=prdNamMap.get(prod.Id)+', ';
                }
                else{}
            } 
            bcnProducts = bcnMap.size()+pcpList.size();  
            if(bcbsmMap.size()>1){          
                bcBsmMsg = bcBsmPrdValidation(bcbsmMap);   
                system.debug('bcbsm message 188'+bcBsmMsg);
            }   
            if(bcnProducts >1){
                bcnMsg   = bcnPrdValidation(bcnMap,pcpList,bcnProducts);
            }           
            if(bcBsmMsg !='OK' && bcBsmMsg!=null){
                //bcBsmMsg=bcBsmMsg.remove(ERRORMSGPHY);
                bcBsmMsg=bcBsmMsg+bcmGSName.removeEnd(', ');
               //String  bcBsmMsgphy= bcBsmMsg+ERRORMSGPHY;
                
                system.debug('196mcmsm message'+bcBsmMsg);
                finalMsg=bcBsmMsg;
                system.debug('final message##'+finalMsg);
            }
           system.debug('bcnMsg:::'+bcnMsg);
            if(bcnMsg !='OK' && bcnMsg!=null){
                bcnMsg=bcnMsg+bcnGSName.removeEnd(', ');
                finalMsg=finalMsg+':BCN:'+bcnMsg;
            }           
        }
        catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
            
        }
        return finalMsg;
    }
/***********************************************************************************************************  
Method name : productValidation
Params     : List
Return Type : String
Description :productValidation() logic to validate products selected for a package in enrollment process
*****************************************************************************************************************/    
public String bcBsmPrdValidation(List<String> bcbsmMap){
    try{
        String message='';
               
        if(!bcbsmMap.isEmpty() && (bcbsmMap.contains(SIMPLYBLUE) || bcbsmMap.contains(SIMPLYBLUEHRA) 
                                   || bcbsmMap.contains(BLUEROUTINECARE))
           && (bcbsmMap.contains(HEALTHYACHIEVE) || bcbsmMap.contains(COMMUNITYBLUE))){                                
               message = ERRORMSG;
        }else if(!bcbsmMap.isEmpty() && bcbsmMap.size() > 1 && (bcbsmMap.contains(SIMPLYBLUEHSA) || bcbsmMap.contains(COMMUNITYBLUE))
                    && bcbsmMap.contains(HEALTHYACHIEVE)){
                        message=ERRORMSG; 
        }
        else if(!bcbsmMap.isEmpty()&&bcbsmMap.contains(PHYSCHOICE)&&
        (bcbsmMap.contains(COMMUNITYBLUE)||bcbsmMap.contains(CBH)||bcbsmMap.contains(SIMPLYBLUE)||
        bcbsmMap.contains(SIMPLYBLUEHRA)||bcbsmMap.contains(BLUEROUTINECARE)||bcbsmMap.contains(HEALTHYACHIEVE)))
        {
         checkphy = true;   
           
            message=ERRORMSG;
           
        }
        else{
            message=ERROROK;
        }
        return message;
    }
    catch(Exception e){            
        throw new AuraHandledException(+e.getMessage());
    }
}
/***********************************************************************************************************  
Method name : productValidation
Params     : List
Return Type : String
Description :productValidation() logic to validate products selected for a package in enrollment process
*****************************************************************************************************************/    
public String bcnPrdValidation(List<String> bcnMap,List<String> pcpList,Integer bcnProducts){
    try{
        String message='';
        if(!bcnMap.isEmpty() && (bcnMap.contains(BCNHMO) || bcnMap.contains(BLUEELECTPLUS) || 
        bcnMap.contains(ROUTINECARE) || bcnMap.contains(BCNHRA) || bcnMap.contains(BCNHSA)) 
            && (bcnMap.contains(HEALTHYLIVING) || !pcpList.isEmpty())){
                    message=ERRORMSG;
            }
        //for HBL+HBL coexistance
        //else if( (pcpList.contains(HEALTHYLIVING) || pcpList.contains(BCNHMO) ) && bcnProducts >1  ){
        else if( pcpList.size()>=1  && bcnMap.size() >=1  ){
            message=ERRORMSG ;
        }
        else{
            message=ERROROK;
        }
        return message;
    }
    catch(Exception e){            
        throw new AuraHandledException(+e.getMessage());
    }
}
   /**********************************************************************************************  
    Method name : jsonToList
    Params     : map
    Return Type : null
    Description :jsonToList() method to convert object to List.
    ***********************************************************************************************/     
    public List<GroupSgmntsDtails> jsonToList(Object lctnJson){
        try{
            string strJson = JSON.serialize(lctnJson);
            strJson = strJson.startsWith(OPENBRACE) ? strJson : OPENBRACE + strJson;
            strJson = strJson.endsWith(CLOSEBRACE) ? strJson : strJson + CLOSEBRACE;
            GroupSgmntsDtails wrap = new GroupSgmntsDtails();
            return wrap.parse(strJson);
        }catch(Exception e){   
            throw new AuraHandledException(+e.getMessage());
        }
    }
    /**********************************************************************************************  
    class name : GroupSgmntsDtails
    Description: The wrapper class to 
    ***********************************************************************************************/   
    public class GroupSgmntsDtails{
        private String medicalType;
        private String medPrdId;
        private String denPrdId;
        private String visPrdId;
        private String ProductFamily;
        private String groupSegmentName;
        private String medicalPlan;
        private String dentalPlan;
        private String visionPlan;
        private String dentalOrtho;
        private String denVolType;
        private String visVolType;
        private String isVisVolStr;
        private String isDenVolStr;
        private String SisterParentID;
        private Boolean hasPedDentalPlan;
		private Boolean hasPedVisionPlan;
        public List<GroupSgmntsDtails> parse(String json) {
            try{
                return (List<GroupSgmntsDtails>) System.JSON.deserialize(json, List<GroupSgmntsDtails>.class);
            }catch(Exception e){                     
                throw new AuraHandledException('errormsg' +e.getMessage());
            }
        
        }

    }       
}