/*************************************************************
Class Name   : ARV_AP01_ThreeChildCapRule
Description  : This class takes the input census and produces first three children older children along with employee (+spouse).
*****************************************************************/
global with sharing class ARV_AP01_RatingValidation implements vlocity_ins.VlocityOpenInterface2 {

    // static values assignment 
    static final String HIOS_PLAN_ID = 'HIOSPlanID';
    static final String PRODUCT_NAME = 'ProductName';
    static final String PRODUCT_KEY = 'productKey';
    static final String CALCULATE_METHOD = 'calculate';
    static final BOOLEAN TRUE_VAL = true;
    static final BOOLEAN FALSE_VAL = false;
    static final String OPEN_BRACE_ARRAY = '[';
    static final String CLOSE_BRACE_ARRAY = ']';

    static final String RELATIONSHIP_OTHR = 'Other Dependent';
    private static final string CLSNAME = 'ARV_AP01_RatingValidation';
    private static final String ERRORMSG = 'Error ocured while processing the premiums....';
    private static final string METHODNAME = 'calculate';
    private static final string COMP = 'Comp';

    /**************  
    Method name : invokeMethod
    Param 1     : inputMap, outputMap and Options
    Return Type : Boolean
    Description : This method to implement calculate method.
    *************/
    public Object invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object >
        outMap, Map < String, Object > options) {
        Boolean success = TRUE_VAL;

        try {

            if (methodName.equals(CALCULATE_METHOD)) {
                calculate(inputMap, outMap, options);
            }
        } catch (Exception e) {

            success = FALSE_VAL;
        }
        return success;
    }

    /**************  
    Method name : calculate
    Param 1     : inputMap, outputMap and Options
    Return Type : void
    Description : This method to run the age and count logic on the recieved census members.
    *************/
    public static Boolean calculate(Map < String, Object > inputMap, Map < String, Object > outMap,
									Map < String, Object > options) {
        system.debug('>>>>inside calculate>>>' + inputMap);
        set < string > strSet = inputMap.keyset();
        map < string, string > hiosMap = new map < string, string > ();
        map < string, string > prodIdMap = new map < string, string > ();
        map < string, string > productNameMap = new map < string, string > ();
        List < Object > mycensus = new list < Object > ();
        list < Object > objList = new List < object > ();
        //map < string, Object > inMap = new map < string, Object > ();
        map < string, Object > inMap = null;        


        for (string str: strSet) {
            objList = (List < Object > ) inputMap.get(str);
            for (object obj: objList) {
               inMap= new map < string, Object > ();
                
                inMap = (map < string, Object > ) obj;
                hiosMap.put(str, (string) inMap.get(HIOS_PLAN_ID));        
                productNameMap.put(str, (string) inMap.get(PRODUCT_NAME));        
                prodIdMap.put(str, (string) inMap.get(PRODUCT_KEY));
        
                break;
            }
        }
      
        mycensus = inputMap.values();

        string strJsonMy = JSON.serialize(mycensus);
        Integer intAgeForValidation = Integer.valueof(System.Label.AgeForValidation);
        Integer intNoOfChild = Integer.valueof(System.Label.NoOfChild);

        Map < String, Integer > mapSubscriberToDependantChildCount = new Map < String, Integer > ();
        Map < String, List < ARV_AP02_RatingValidationJsonParser.CensusDetails >> mapParentToFamily = new Map < String,
            List < ARV_AP02_RatingValidationJsonParser.CensusDetails >> ();
        Map < String, List < ARV_AP02_RatingValidationJsonParser.CensusDetails >> mapParentToChildren = new Map < String,
            List < ARV_AP02_RatingValidationJsonParser.CensusDetails >> ();
        Map < String, List < ARV_AP02_RatingValidationJsonParser.CensusDetails >> mapParentToOtherDependent = new Map < String,
            List < ARV_AP02_RatingValidationJsonParser.CensusDetails >> ();
        List < ARV_AP02_RatingValidationJsonParser.CensusDetails > lstCensus = new List <
            ARV_AP02_RatingValidationJsonParser.CensusDetails > ();


        try {
            /*************************** START: Validation  logic*****************************************************************/
            if (!String.isBlank(strJsonMy)) {
                strJsonMy = strJsonMy.removeStart(OPEN_BRACE_ARRAY);
                strJsonMy = strJsonMy.removeEnd(CLOSE_BRACE_ARRAY);

                List < ARV_AP02_RatingValidationJsonParser.CensusDetails > lstAllCensus=ARV_AP02_RatingValidationJsonParser.parse(strJsonMy);
                List < ARV_AP02_RatingValidationJsonParser.CensusDetails > lstAllCensusdesc = new
                List < ARV_AP02_RatingValidationJsonParser.CensusDetails > ();
                Id parentCMId = null;
                Id parentCMId5 = null;

                //Sort censusdetails by age
                lstAllCensus.sort();
                //system.debug('>>>sort>>>'+lstAllCensus );
                for (Integer icon = lstAllCensus.size() - 1; icon >= 0; icon--) {
                    lstAllCensusdesc.add(lstAllCensus[icon]);
                }
               
                for (ARV_AP02_RatingValidationJsonParser.CensusDetails objCensus: lstAllCensusdesc) {
                    parentCMId = objCensus.RF_SG_CM_ParentId != null ? objCensus.RF_SG_CM_ParentId : objCensus.RF_SG_CM_Id;
                   // parentCMId5 = objCensus.RF_SG_CM_Id != null ? objCensus.RF_SG_CM_Id : objCensus.RF_SG_CM_ParentId;
                    //below 'if' is checking for Parent and Spouse census member
                    if ((objCensus.RF_SG_CM_ParentId == null || objCensus.IsSpouse == true || objCensus.Relationship == RELATIONSHIP_OTHR) &&
                        objCensus.RF_SG_CM_MemberType != COMP) {

                        //parentCMId = objCensus.RF_SG_CM_ParentId!=null?objCensus.RF_SG_CM_ParentId:objCensus.RF_SG_CM_Id;

                        
                        if (!mapParentToFamily.containsKey(parentCMId) && objCensus.Relationship != RELATIONSHIP_OTHR) {
                            
                            mapParentToFamily.put(parentCMId, new List < ARV_AP02_RatingValidationJsonParser.CensusDetails > {
                                objCensus
                            });
                        } else if (objCensus.Relationship != RELATIONSHIP_OTHR) {
                            
                            mapParentToFamily.get(parentCMId).add(objCensus);
                        } else {
                            if (!mapParentToOtherDependent.containsKey(objCensus.RF_SG_CM_ParentId)) {
                               

                                mapParentToOtherDependent.put(parentCMId, new List < ARV_AP02_RatingValidationJsonParser.CensusDetails > {
                                    objCensus
                                });
                            } else {
                            
                                mapParentToOtherDependent.get(parentCMId).add(objCensus);
                            }
                        }
                    }
                    //below 'else if' is checking for child census members
                    else if (objCensus.RF_SG_CM_Id != objCensus.RF_SG_CM_ParentId && objCensus.IsSpouse == false
					         && objCensus.RF_SG_CM_ParentId != null) {
                        system.debug('>>>>here 1.1.1 else if...>>>>');

                        if (!mapSubscriberToDependantChildCount.containsKey(objCensus.RF_SG_CM_ParentId) && 
						     !mapParentToChildren.containsKey(objCensus.RF_SG_CM_ParentId)) {
                           

                            if (objCensus.Age < intAgeForValidation) {
                              

                                mapSubscriberToDependantChildCount.put(objCensus.RF_SG_CM_ParentId, 1);
                            }
                            mapParentToChildren.put(objCensus.RF_SG_CM_ParentId, new List < ARV_AP02_RatingValidationJsonParser.CensusDetails > {
                                objCensus
                            });


                        } else if (mapParentToChildren.containsKey(objCensus.RF_SG_CM_ParentId)) {
                            

                            if (mapSubscriberToDependantChildCount.get(objCensus.RF_SG_CM_ParentId) == null && 
							    objCensus.Age < intAgeForValidation) {
                                mapSubscriberToDependantChildCount.put(objCensus.RF_SG_CM_ParentId, 1);
                                mapParentToChildren.get(objCensus.RF_SG_CM_ParentId).add(objCensus);
                            } else if (mapSubscriberToDependantChildCount.get(objCensus.RF_SG_CM_ParentId) < intNoOfChild 
                                       && objCensus.Age < intAgeForValidation) {

                                Integer intCount = mapSubscriberToDependantChildCount.get(objCensus.RF_SG_CM_ParentId) + 1;
                                mapSubscriberToDependantChildCount.put(objCensus.RF_SG_CM_ParentId, intCount);
                                mapParentToChildren.get(objCensus.RF_SG_CM_ParentId).add(objCensus);
                            } else if (objCensus.Age >= intAgeForValidation) {

                                mapParentToChildren.get(objCensus.RF_SG_CM_ParentId).add(objCensus);
                            }else{
								// flag to differentiate members who are not included in the calculation
								mapParentToChildren.get(objCensus.RF_SG_CM_ParentId).add(objCensus);
								objCensus.Calculate = 'false';								
							}
                        }
                    } else {
                        
                        if (objCensus.RF_SG_CM_Id != objCensus.RF_SG_CM_ParentId && objCensus.IsSpouse == true &&
 						     objCensus.RF_SG_CM_ParentId != null) {
                            

                           // Id parentCMId2 = objCensus.RF_SG_CM_Id != null ? objCensus.RF_SG_CM_Id : objCensus.RF_SG_CM_ParentId;
                            Id parentCMId2 = objCensus.RF_SG_CM_ParentId != null ? objCensus.RF_SG_CM_ParentId : objCensus.RF_SG_CM_Id;
                            mapParentToFamily.put(parentCMId2, new List < ARV_AP02_RatingValidationJsonParser.CensusDetails > {
                                objCensus
                            });

                        } else if (objCensus.RF_SG_CM_ParentId == null) {
                           
                           // Adding the Details to Parent Comp
                           // Id parentCMId3 = objCensus.RF_SG_CM_ParentId != null ? objCensus.RF_SG_CM_ParentId : objCensus.RF_SG_CM_Id;
                            Id parentCMId3 = objCensus.RF_SG_CM_Id != null ? objCensus.RF_SG_CM_Id : objCensus.RF_SG_CM_ParentId;
                            if(mapParentToFamily.get(parentCMId3) != null ){
                                mapParentToFamily.get(parentCMId3).add(objCensus);
                            }else{
                            mapParentToFamily.put(parentCMId3, new List < ARV_AP02_RatingValidationJsonParser.CensusDetails > {
                                objCensus
                            });
                            }
                            
                            
                        } else {
                            system.debug('>>>>here 1.1.5>>>>'+objCensus+ objCensus.Relationship+ 'objCensus.age\t'+objCensus.Age);

                            mapParentToOtherDependent.put(parentCMId, new List < ARV_AP02_RatingValidationJsonParser.CensusDetails > {
                                objCensus
                            });

                        }
                    }
                }
               
                for (String parentId: mapParentToChildren.keySet()) {
                    if (mapParentToFamily.containsKey(parentId)) {
                        mapParentToFamily.get(parentId).addAll(mapParentToChildren.get(parentId));
                    } else {
                        mapParentToFamily.put(parentId, mapParentToChildren.get(parentId));
                    }
                }
                for (String parentId: mapParentToOtherDependent.keySet()) {

                    if (mapParentToFamily.containsKey(parentId)) {
                        mapParentToFamily.get(parentId).addAll(mapParentToOtherDependent.get(parentId));
                    } else {

                        mapParentToFamily.put(parentId, mapParentToOtherDependent.get(parentId));
                    }
                }
                //preparing valid census members for JSON
                for (String parentId: mapParentToFamily.keySet()) {
                    if (mapParentToFamily.containsKey(parentId)) {
                        lstCensus.addAll(mapParentToFamily.get(parentId));
                    }
                }
                //This loop is to add the refined census members to each productId to send output back.
                map < string, Object > output = new map < string, Object > ();
                for (string str: strSet) {
                     
                    for (ARV_AP02_RatingValidationJsonParser.CensusDetails wrap: lstCensus) {
                        wrap.ProductName = productNameMap.get(str);
                        wrap.HIOSPlanID = hiosMap.get(str);
                        wrap.productKey = prodIdMap.get(str);
                        wrap.parentProdKey = prodIdMap.get(str);
                    }
                    output.put(str, (List < Object > ) JSON.deserializeUntyped(JSON.serialize(lstCensus)));
                }                
                //Vlocity tried out: clear inputMap, then clone
                inputMap.clear();
                inputMap.putAll(output);
                outMap.putAll(output); //temp 08.12.2019
                system.debug('>>>>outMap>>>' + outMap);

            }

            /*************************** END: Validation  logic**************************************************/

        } catch (Exception e) {
            //GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME  );
            throw new AuraHandledException(ERRORMSG + e.getMessage());
        }
        return true;
    }
}