/*****************************************************************************************
Class Name   : ARV_AP49_GetStateNameByStateCode. 
Date Created : 13-Jan-2020
Created By   : IDC Offshore
Description  :This class is used to fetch statename by passing state code.
******************************************************************************************/
public without sharing class ARV_AP49_GetStateNameByStateCode {

    
/***
**Method Name   : ARV_AP49_GetStateNameByStateCode.
**Description  :This method is used to fetch statename by passing state code.
****/   
    public static string getStateName(String stateCode){
		 
		string stateName='';
	    if(stateCode=='AK')
	        stateName='Alaska';
		else if(stateCode=='AL')
	        stateName='Alabama';
		else if(stateCode=='AR')
	        stateName='Arkansas';
		else if(stateCode=='AZ')
	        stateName='Arizona';
		else if(stateCode=='CA')
	        stateName='California';
		else if(stateCode=='CO')
	        stateName='Colorado';
		else if(stateCode=='CT')
	        stateName='Connecticut';
		else if(stateCode=='DE')
	        stateName='Delaware';
		else if(stateCode=='FL')
	        stateName='Florida';
		else if(stateCode=='GA')
	        stateName='Georgia';
		else if(stateCode=='HI')
	        stateName='Hawaii';
		else if(stateCode=='IA')
	        stateName='Iowa';
		else if(stateCode=='ID')
	        stateName='Idaho';
		else if(stateCode=='IL')
	        stateName='Illinois';
		else if(stateCode=='IN')
	        stateName='Indiana';
		else if(stateCode=='KS')
	        stateName='Kansas';
		else if(stateCode=='KY')
	        stateName='Kentucky';
		else if(stateCode=='LA')
	        stateName='Louisiana';
		else if(stateCode=='MA')
	        stateName='Massachusetts';
		else if(stateCode=='MD')
	        stateName='Maryland';
		else if(stateCode=='ME')
	        stateName='Maine';
		else if(stateCode=='MI')
	        stateName='Michigan';
		else if(stateCode=='MN')
	        stateName='Minnesota';
		else if(stateCode=='MO')
	        stateName='Missouri';
		else if(stateCode=='MS')
	        stateName='Mississippi';
		else if(stateCode=='MT')
	        stateName='Montana';
		else if(stateCode=='NC')
	        stateName='North Carolina';
		else if(stateCode=='ND')
	        stateName='North Dakota';
		else if(stateCode=='NE')
	        stateName='Nebraska';
		else if(stateCode=='NH')
	        stateName='New Hampshire';
		else if(stateCode=='NJ')
	        stateName='New Jersey';
		else if(stateCode=='NM')
	        stateName='New Mexico';
		else if(stateCode=='NV')
	        stateName='Nevada';
		else if(stateCode=='NY')
	        stateName='New York';
		else if(stateCode=='OH')
	        stateName='Ohio';
		else if(stateCode=='OK')
	        stateName='Oklahoma';
		else if(stateCode=='OR')
	        stateName='Oregon';
		else if(stateCode=='PA')
	        stateName='Pennsylvania';
		else if(stateCode=='RI')
	        stateName='Rhode Island';
		else if(stateCode=='SC')
	        stateName='South Carolina';
		else if(stateCode=='SD')
	        stateName='South Dakota';
		else if(stateCode=='TN')
	        stateName='Tennessee';
		else if(stateCode=='TX')
	        stateName='Texas';
		else if(stateCode=='UT')
	        stateName='Utah';
		else if(stateCode=='VA')
	        stateName='Virginia';
		else if(stateCode=='VT')
	        stateName='Vermont';
		else if(stateCode=='WA')
	        stateName='Washington';
		else if(stateCode=='WI')
	        stateName='Wisconsin';
		else if(stateCode=='WV')
	        stateName='West Virginia';
		else if(stateCode=='WY')
	        stateName='Wyoming';
     return stateName;		
	 } 
}