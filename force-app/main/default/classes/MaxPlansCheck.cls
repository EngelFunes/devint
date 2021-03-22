global without sharing class  MaxPlansCheck implements vlocity_ins.VlocityOpenInterface  {
    
    private static final String ERRMSG ='Maxplans count validation error message';
	public String countcheck(Map<String,Object> input, Map<String,Object> output,
                                     Map<String,Object> options)
	{
		try{           
			Integer medplan=0;
			Integer denplan=0;
			Integer visplan=0; 
			Integer counter=0;
			Integer susccesstimes=0;
			map<Id,Product2> medmap= new map<Id,Product2>();
			map<Id,Product2> denmap = new map<Id,Product2>();
			map<Id,Product2>vismap=  new map<Id,Product2>();                                   
			String QuoteId = String.valueof(options.get('QuoteId'));
			system.debug('QUOTE ID::::'+QuoteId);
			//list<QuoteLineItem>  products= [select id,name,Product2.name,Product2.Family,vlocity_ins__GroupCensusId__c  from QuoteLineItem where quoteid=:QuoteId];
			Id censusId =[select id,name,vlocity_ins__GroupCensusId__c from quote where id=:QuoteId ].vlocity_ins__GroupCensusId__c;
			system.debug('CENSUS ID::::'+censusId);
			Integer censmem = [select count () from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c=:censusId];
			system.debug('CENSUSMEM::::'+censmem);
			List<Packagewrapper> pwdetails= new List<Packagewrapper>();
			pwdetails=jsonToList(input.get('finalGroupSegmentsPlans')); 
			system.debug('pwdetails::::::::::'+pwdetails);
			system.debug('pwdetails size::::::::::'+pwdetails.size());
			for(Packagewrapper pw: pwdetails) 
			{
				if(pw.medPrdId!=null && pw.denPrdId!=null &&pw.visPrdId!=null)
				{
					system.debug('eneteredv 3 cond if');
					if(!medmap.keySet().contains(pw.medPrdId))
					{
						medmap.put(pw.medPrdId,[select id,PCP_Focus__c,ARV_Is_Pediatric__c from product2 where id=:pw.denPrdId]);
						system.debug(' med put block:::'+medmap.get(pw.medPrdId));
							if(medmap.get(pw.medPrdId).PCP_Focus__c==false)
								medplan=medplan+1;      
								system.debug(' put block medplan::'+medplan);
					}
					else
					{
						if(medmap.get(pw.medPrdId).PCP_Focus__c==false)
						medplan=medplan;
						system.debug(' else block medplan::'+medplan);
					}
					if(medplan>=3){
					output.put('med is 3+',true);
					}
					else{
					output.put('med is less 3',true);
					}
					if(!denmap.keySet().contains(pw.denPrdId))
					{
					denmap.put(pw.denPrdId,[select id,PCP_Focus__c,ARV_Is_Pediatric__c from product2 where id=:pw.denPrdId]);
					system.debug(' den put block:::'+denmap.get(pw.denPrdId));
						if(denmap.get(pw.denPrdId).ARV_Is_Pediatric__c==false)
						denplan=denplan+1;
						system.debug(' put block denplan::'+denplan);
					}
					else{
						if(denmap.get(pw.denPrdId).ARV_Is_Pediatric__c==false)
						denplan=denplan;
						system.debug(' else block denplan::'+denplan);
						}
 // -------
					if(!vismap.keySet().contains(pw.visPrdId))
					{
					vismap.put(pw.visPrdId,[select id,PCP_Focus__c,ARV_Is_Pediatric__c from product2 where id=:pw.visPrdId]);
					system.debug(' vis put block:::'+vismap.get(pw.visPrdId));
						if(vismap.get(pw.visPrdId).ARV_Is_Pediatric__c==false)
						visplan=visplan+1;
						system.debug(' put block visplan::'+visplan);
					}
					else{
						 if(vismap.get(pw.visPrdId).ARV_Is_Pediatric__c==false)
						 visplan=visplan;
						 system.debug(' else block visplan::'+visplan);
						}
				}// 3 condition check if
			}
			system.debug('final medplan::'+medplan);
			system.debug('final denplan::'+denplan);
			system.debug('final visplan::'+visplan);
			if((censmem==1 && (medplan>1 || denplan>1 || visplan>1))||(censmem==2 && (medplan>2 || denplan>2 || visplan>2))||(censmem>=3 && (medplan>3 || denplan>3 || visplan>3)))
			{
				output.put('errormsg1234',ERRMSG); 
            }
			else
			{
				output.put('errormsg12345',ERRMSG);
			}
			return  ERRMSG;  
			}
			catch(Exception e)
			{
				GA_LogExceptionCls.LogExcp(e, 'MaxPlansCheck','countcheck');
				return  ERRMSG;
			}
	}   
    
global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options){           
        Boolean success = true;
        try{
            if (methodName == 'countcheck'){ 
                countcheck(input,output,options);
            }
        }catch(Exception e){
           // system.debug('line number@@ '+e.getLineNumber());
            //system.debug('getMessage @@ '+e.getMessage());
           GA_LogExceptionCls.LogExcp(e, 'MaxPlansCheck', 'invokeMethod');
            //throw new AuraHandledException(e.getMessage()+e.getlinenumber());
        }
        return success;
    }

 public List<Packagewrapper> jsonToList(Object lctnJson){
        try{
        string strJson = JSON.serialize(lctnJson);
            //string strJson = JSON.serialize(lctnJson);
            //strJson = strJson.startsWith(OPENBRACE) ? strJson : OPENBRACE + strJson;
            //strJson = strJson.endsWith(CLOSEBRACE) ? strJson : strJson + CLOSEBRACE;
            Packagewrapper wrap= new Packagewrapper();
            return wrap.parse(strJson);
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
    }
 public class Packagewrapper{
 Public String visionPlan;
Public  String  visVolType;
Public Boolean visVolContains;
Public Id visPrdId;
Public String medicalType;
Public String medicalPlan;
Public Id  medPrdId;
Public String groupSegmentName;
Public String  groupSegmentId;
Public String   dentalPlan;
Public String  denVolType;
Public  Boolean  denVolContains;
Public Id denPrdId; 
        public List<Packagewrapper> parse(String json) {
            try{
                system.debug('json::'+json);
                return (List<Packagewrapper>) System.JSON.deserialize(json, List<Packagewrapper>.class);
            }catch(Exception e){
                throw new AuraHandledException('error' +e.getMessage());
            }
        
        }

}


}