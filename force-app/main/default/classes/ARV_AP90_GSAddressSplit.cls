/*****************************************************************************************
Class Name   : ARV_AP90_GSAddressSplit. 
Date Created : 10-Mar-2020
Created By   : IDC Offshore
Description  : This is the class for Splitting Address in Group Segments...
******************************************************************************************/
public without sharing class ARV_AP90_GSAddressSplit {
       private static final integer MAX1 = 101;
       private static final integer MAX2 =  41;
       private static final integer MAX3 =  41;
       private static final string NULLVAL = 'null';
       private static final string EMPTY_STRING = '';
       private static final string SPACEVAL=' ';
      
    /*****************************************************************************************
    Method Name  : physicalAddressSplit. 
    Date Created : 10-Mar-2020
    Created By   : IDC Offshore
    Description  : This is the method for Physical,Admin,Billing address split.
    ******************************************************************************************/ 
     public static void physicalAddressSplit(List<GA_Group_Segment__C> insertGSList){
        try{
            List<GA_Group_Segment__c> updateGSLst =  new List<GA_Group_Segment__c> (); 
			
			for(GA_Group_Segment__c gs: insertGSList){
                if(gs.ARV_Location_Physical_Address__c != NULLVAL && gs.ARV_Location_Physical_Address__c != EMPTY_STRING ){
                    List<String> addSplit = splitAddress(gs.ARV_Location_Physical_Address__c);
                    gs.GA_Physical_Address_1__c = addSplit[0];
                    gs.GA_Physical_Address_2__c = addSplit[1];
                    gs.GA_Physical_Address_3__c = addSplit[2];  
                }
                if(gs.ARV_Admin_Address__c != NULLVAL && gs.ARV_Admin_Address__c != EMPTY_STRING ){	
                    List<String> addSplit = splitAddress(gs.ARV_Admin_Address__c);
                    gs.GA_Mailing_Address_1__c=addSplit[0];
                    gs.GA_Mailing_Address_2__c=addSplit[1];
                    gs.GA_Mailing_Address_3__c=addSplit[2];
    
                }
                if(gs.ARV_Billing_Address__c != NULLVAL && gs.ARV_Billing_Address__c != EMPTY_STRING ){	
                    List<String> addSplit = splitAddress(gs.ARV_Billing_Address__c);
                    gs.GA_Billing_Address_1__c=addSplit[0];
                    gs.GA_Billing_Address_2__c=addSplit[1];
                    gs.GA_Billing_Address_3__c=addSplit[2];
                    
            }
                gs.GA_Is_Mass_Updating__c = True;
                //system.debug('sljfsdf----:'+updateGSLst);
				updateGSLst.add(gs);
      }
            if(updateGSLst.size()>0){
              database.update(updateGSLst);
               
			}
    }
        catch(System.NullPointerException e){
            return;
        }
   }
    /*****************************************************************************************
    Method Name  : splitAddress. 
    Date Created : 10-Mar-2020
    Created By   : IDC Offshore
    Description  : This is the method called from physicalAddressSplit()
    ******************************************************************************************/
    public static List<String> splitAddress(String add){
        
        List<String> addList =new List<String>();
        String phyAdd=add;
        String physAdd1='';
        String physAdd2='';
        String physAdd3='';
        String[] address = phyAdd.split(SPACEVAL);
        integer length = 0;
        for (integer i = 0; i < address.size(); i++){
            length = length + address[i].length()+1;
            if(length <= MAX1) {
                physAdd1 = physAdd1 + address[i]+SPACEVAL;
            }
            else  if(length <= physAdd1.length()+MAX2){
                physAdd2 = physAdd2 +address[i]+SPACEVAL;
            }
            else  if(length <= physAdd1.length()+physAdd2.length()+MAX3){
                physAdd3 = physAdd3 + address[i]+SPACEVAL;
            }
            else{
                physAdd3 = physAdd3 ; 
                i =address.size() ;
            }             
        }
        addlist.add(physAdd1);
        addlist.add(physAdd2);
        addlist.add(physAdd3);
        return addlist;
    }   

}