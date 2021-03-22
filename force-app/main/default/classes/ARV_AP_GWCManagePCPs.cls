/*****************************************************************************************
Class Name   : ARV_AP_GWCManagePCPs. 
Date Created : 7-Sept-2020
Created By   : IDC Offshore
Description  :This is the class for Group segment validation in GWC flow.
******************************************************************************************/
global class ARV_AP_GWCManagePCPs implements vlocity_ins.VlocityOpenInterface2 
{
    /*******************************************************************************************  
    Method name : invokeMethod
    Params     : map
    Return Type : null
    Description :this method is used to invoke the enrollMedicalValidation method
    *******************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                        Map<String,Object> output, Map<String,Object> options) 
    {           
       try
       {
            physExistanceRules(input,output,options);
       }
       catch(Exception e)
       {
            system.debug('error occured********'+e.getlinenumber()+'::::'+e.getmessage());  

       } 
       return true;
    }
    /*******************************************************************************************  
    Method name : physExistanceRules
    Params     : map
    Return Type : null
    Description :this method is used to invoke the enrollMedicalValidation method
    *******************************************************************************************/
    global void physExistanceRules(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
    {
        Set<String> countylist=new set<String>();
        String dntChangeMedPlan=null;
        Id cntrctId = id.valueOf(String.valueOf(input.get('contractId')));
        Id acntId = id.valueOf(String.valueOf(input.get('AccountId')));
        Set<String> nonPCPCountySet= new set<string>();
        List<String> nonPCPCountyList= new List<string>();
        List<vlocity_ins__ContractLineItem__c> cLineItemList = new List<vlocity_ins__ContractLineItem__c>();
        List<String> pcpAcntCountyList= new List<string>();
        List<Object> pcpCountyList = (List<Object>)input.get('countyList');
        List<Object> fnl2GSDetails = new List<Object>();
        map<string,Object> strObjectMap;
        Boolean isPCP;
        Integer nonpcpBCN = 0;
        set<id> medPrdSetIds = new Set<id>();
        map<id,id> pcpPrdMapIds = new map<id,id>();
        map<id,String> pcpPrdMapNames = new map<id,String>();
        try
        {
            list<object> fnl1GSDetails = (list<object>)input.get('finalGroupSegmentsPlans');
            for(Object gsRecord: fnl1GSDetails)
            {
                strObjectMap = (map<String, Object>)gsRecord;
                if(String.valueOf(strObjectMap.get('SisterParentID'))=='' || String.valueOf(strObjectMap.get('SisterParentID')) == null)
                {
                    if(String.valueOf(strObjectMap.get('pcpFocus'))=='true'){
                        isPCP=true;
                    }
                    if(String.valueOf(strObjectMap.get('pcpFocus'))=='false' && String.valueOf(strObjectMap.get('medicalType'))=='BCN'){
                        nonpcpBCN = nonpcpBCN +1;
                    }
                    if(!pcpCountyList.contains(String.valueOf(strObjectMap.get('physicalCounty')))){
                        nonPCPCountySet.add(String.valueOf(strObjectMap.get('physicalCounty')));
                        nonPCPCountyList.add(String.valueOf(strObjectMap.get('physicalCounty')));
                        medPrdSetIds.add(id.valueOf(String.valueOf(strObjectMap.get('medPrdId'))));
                    }
                    else if(pcpCountyList.contains(String.valueOf(strObjectMap.get('physicalCounty')))){
                        pcpAcntCountyList.add(String.valueOf(strObjectMap.get('physicalCounty')));
                    }
            	}
            }
            //map of nonPCP county products' sister procut Ids
            for(Id medPrdRecord: medPrdSetIds){
                pcpPrdMapIds.put(medPrdRecord,[Select id, ARV_PCPFocus_SisterPlan__c FROM Product2 WHERE id=:medPrdRecord].ARV_PCPFocus_SisterPlan__c);
                pcpPrdMapNames.put(medPrdRecord,[Select id, ARV_PCPFocus_SisterPlan__c, ARV_PCPFocus_SisterPlan__r.Name FROM Product2 WHERE id=:medPrdRecord].ARV_PCPFocus_SisterPlan__r.Name);
            }
            
            if(pcpPrdMapNames.keySet().size()>0){
                for(Id prd:pcpPrdMapNames.keySet()){
                    vlocity_ins__ContractLineItem__c cLineItem = new vlocity_ins__ContractLineItem__c();
                    cLineItem.Name = pcpPrdMapNames.get(prd);
                    cLineItem.vlocity_ins__Product2Id__c=pcpPrdMapIds.get(prd);
                    cLineItem.vlocity_ins__ContractId__c=cntrctId;
                    cLineItemList.add(cLineItem);
                }
            }
            database.insert(cLineItemList);
            
            System.debug('isPCP Kishore '+isPCP);
            System.debug('nonpcpBCN Kishore '+nonpcpBCN);
            System.debug('nonPCPCountySet Kishore '+nonPCPCountySet);
            System.debug('nonPCPCountySet.size() Kishore '+nonPCPCountySet.size());
            System.debug('nonPCPCountyList Kishore '+nonPCPCountyList);
            System.debug('nonPCPCountyList.size() Kishore '+nonPCPCountyList.size());
            System.debug('medPrdSetIds Kishore '+medPrdSetIds);
            System.debug('medPrdSetIds.size() Kishore '+medPrdSetIds.size());
            System.debug('pcpAcntCountyList.size() Kishore '+pcpAcntCountyList.size());
            System.debug('fnl1GSDetails.size() Kishore '+fnl1GSDetails.size());
            System.debug('pcpPrdMapIds Kishore '+pcpPrdMapIds);
            System.debug('pcpPrdMapNames Kishore '+pcpPrdMapNames);

            //Conditions to apply in OmniScript to display errors
            if(isPCP==true && nonpcpBCN>0){
                output.put('pcpBCNCoexistence','pcpBCNCoexistence');
            }
            if(nonPCPCountySet.size()==1 && isPCP==true && pcpAcntCountyList.size()==0){
                output.put('sngleLcnOutErr','sngleLcnOutErr');
                dntChangeMedPlan = 'dntChangeMedPlan';
            }
            else if(nonPCPCountySet.size()>0 && isPCP==true && (nonPCPCountyList.size()==fnl1GSDetails.size())){
                dntChangeMedPlan = 'dntChangeMedPlan';
                output.put('mltplLcnOutErr','mltplLcnOutErr');
                System.debug('dntChangeMedPlan '+dntChangeMedPlan);
            }
            if(dntChangeMedPlan!='dntChangeMedPlan')
            {
                    for(Object fob: fnl1GSDetails)
                    {
                        strObjectMap = (map<String, Object>)fob;
                        //if(String.valueOf(strObjectMap.get('SisterParentID'))=='' || String.valueOf(strObjectMap.get('SisterParentID')) == null)
                		//{
                            if(!pcpCountyList.contains(strObjectMap.get('physicalCounty')) &&
                               String.valueOf(strObjectMap.get('pcpFocus'))=='true')
                            {
                                   strObjectMap.put('medicalPlan',pcpPrdMapNames.get(Id.valueOf(String.valueOf(strObjectMap.get('medPrdId')))));
                                   strObjectMap.put('medPrdId',pcpPrdMapIds.get(Id.valueOf(String.valueOf(strObjectMap.get('medPrdId')))));
                                   fnl2GSDetails.add(strObjectMap);
                            }
                            else
                            {
                                        strObjectMap.put('medPrdId',strObjectMap.get('medPrdId'));
                                        strObjectMap.put('medicalPlan',strObjectMap.get('medicalPlan'));
                                        fnl2GSDetails.add(strObjectMap);
                            }
                    	//}
                    }
                    //Update JSON back to OS from Apex Class
                    output.put('finalGroupSegmentsPlans',fnl2GSDetails);
            }
        }
        catch(Exception e)
        {
            system.debug('line number@@ '+e.getLineNumber()); 
            system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP_GWCManagePCPs', 'physExistanceRules');
        }
    }
}