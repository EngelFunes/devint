/*****************************************************************************************
Class Name   : ARV_AP64_SegmentInfoService. 
Date Created : 16-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for Segment Locations in PARTB.
******************************************************************************************/
global with sharing class ARV_AP64_SegmentInfoService implements vlocity_ins.VlocityOpenInterface2 {
    private static final string METHODNAME='formatSegMentInfo';
    private static final string  SEGMENTINFORMATION= 'SegmentInformation';
    private static final string  DATATOTRANSFER = 'DataToTransfer';
    private static final string  SEGMENTLOCATIONINFORMATION = 'SegmentLocationInformation';
    private static final string   SEGMENTINFO= 'SegmentInfo';
    private static final string   SEGMENTLOCATIONINFO='SegmentLocationInfo';
    private static final string SEGMENTINFONODE  = 'SegmentInfoNode';
    private static final string  RENEWALDATE ='RenewalDate';
    private static final string  COUNTY='County';
    private static final string ZIPCODE='ZIPCodeNonMI';
    private static final string STARTINGARRAY='[';
    private static final string ENDINGARRAY=']';
/*************************************************************************************************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :this method is used to invoke the Segment Locations in PARTB method
******************************************************************************************************/
    global  Boolean invokeMethod(String methodName, Map <String, Object> inputMap,
                                       Map < String, Object > outMap, Map < String, Object > options) {
        try{
            if (methodName == METHODNAME) 
            {
            formatSegMentInfo(inputMap,outMap,options);
            }
        }catch(Exception e){
            system.debug('********'+e.getLineNumber()+'**********'+e.getMessage());
            throw new AuraHandledException(+e.getMessage());
        }
        return true;   
    }
/*************************************************************************************************************  
Method name : formatSegMentInfo
Params     : map
Return Type : null
Description :formatSegMentInfo() method to fetch segment data from dataJSON
***********************************************************************************************************/	
    global void formatSegMentInfo(Map < String, Object > inputMap,
                                          Map < String, Object > outMap, Map < String, Object > options) {         
        Map<String,Object> segmentInfoObj=(Map<String,Object>)inputMap.get(DATATOTRANSFER);
        string strJson = JSON.serialize(segmentInfoObj.get(SEGMENTINFORMATION));
        strJson=strJson.startsWith(STARTINGARRAY)? strJson :STARTINGARRAY+strJson;
        strJson=strJson.endsWith(ENDINGARRAY)? strJson :strJson+ENDINGARRAY;
        List<Object> segmentInfoArray = (List<Object>)JSON.deserializeUntyped(strJson);
     	Map<String,Object> segmentInfoMap=new Map<String,Object>();
        // List<Object> segmentInfoArrayOut=new List<Object>();
        for(Object obj:segmentInfoArray){
			List<Object> segValList=new List<Object>();
			Map<String,Object> segMap=new Map<String,Object>();
			Map<String,Object> each=(Map<String,Object>)obj;
            Map<String,Object> segmentLocationInformationEach=(Map<String,Object>)each.get(SEGMENTLOCATIONINFORMATION);
            String key=getKey(segmentLocationInformationEach);
            if(segmentInfoMap.containskey(key)){              
				for(string segStr:each.keySet()){	
					if(segStr != SEGMENTLOCATIONINFORMATION){
						segMap.put(segStr,each.get(segStr));
					}					
				}
                Map<String,Object> isSIMap=(Map<String,Object>)segmentInfoMap.get(key);
				object segObj = (Object)segMap;				
				((List<Object>)isSIMap.get(SEGMENTINFO)).add(segObj);
            }else{
                Map<String,Object> tempMap=new Map<String,Object>();				
				map<string,Object> locMap=new map<string,Object>();				
				locMap.putAll((Map<String,Object>)each.get(SEGMENTLOCATIONINFORMATION));
				tempMap.put(SEGMENTLOCATIONINFO,locMap);				
				for(string segStr:each.keySet()){	
					if(segStr != SEGMENTLOCATIONINFORMATION){
						segMap.put(segStr,each.get(segStr));
					}					
				}
				List<Object> listO=new List<Object>();                
                listO.add(segMap);
				tempMap.put(SEGMENTINFO,listO);
                segmentInfoMap.put(key,tempMap);                
            }
        }
        Map<String,Object> outM=new Map<String,Object>();
        outM.put(SEGMENTINFONODE,segmentInfoMap.values());
        outMap.put(RENEWALDATE,outM);
             
    }
   	/*************************************************************************************************************  
    Method name : getKey
    Params     : map
    Return Type : null
    Description :getKey() method to form county with zip
	***********************************************************************************************************/	 
    private static String getKey(Map<String,Object> m){
         return m.get(COUNTY)+ARV_AP41_StringLiteralUtils.HYPHENVAL+m.get(ZIPCODE);
    }
}