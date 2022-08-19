public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(Map<Id,Case> newRecords,Map<Id,Case> oldRecords) {
        // TODO: Complete the method to update workorders
        //get the recordset that are update to closed and type as Repair and Routine Maintenance Request
        Set<Id> closedMRIds = new Set<Id>();

        //Prepare the dataset to work
        for(Id cid:newRecords.keySet()){            
            if(newRecords.get(cid).Status == 'Closed' &&
            newRecords.get(cid).Status != oldRecords.get(cid).Status &&
            (newRecords.get(cid).Type == 'Repair' || newRecords.get(cid).Type == 'Routine Maintenance')){
                closedMRIds.add(cid);
            }
        }

        if(closedMRIds.size() > 0){
            //get the Equipment Maintenance request for the closedMR's
            List<Equipment_Maintenance_Item__c> listOfEMI = [SELECT Id, Name, Maintenance_Request__c, Equipment__c, Equipment__r.Maintenance_Cycle__c 
                                                    FROM Equipment_Maintenance_Item__c where Maintenance_Request__c IN :closedMRIds 
                                                    WITH SECURITY_ENFORCED
                                                    Order By Equipment__r.Maintenance_Cycle__c
                                                    ];
            //Map the Min.Cycle with maintenance request as key
            Map<Id,Integer> mapMRCycle = new Map<Id,Integer>(); 
            for(Equipment_Maintenance_Item__c eMI:listOfEMI){
                if(!mapMRCycle.containsKey(eMI.Maintenance_Request__c)){
                    mapMRCycle.put(eMI.Maintenance_Request__c, (Integer)eMI.Equipment__r.Maintenance_Cycle__c);
                }
            }

            //clone the MR's and set the status, Type,Subject and other fields
            List<case> newMRList = new List<case>();
            for(Id cid:closedMRIds){
                Case newMR = new Case();
                newMR = newRecords.get(cid).clone(false, true, false, false);
                newMR.Status = 'New';
                newMR.Type = 'Routine Maintenance';
                newMR.Subject = 'New Routine Maintenance created from:'+newRecords.get(cid).CaseNumber;
                newMR.Date_Reported__c = Date.today();
                if(mapMRCycle.containsKey(cid)){
                    newMR.Date_Due__c = Date.today().addDays(mapMRCycle.get(cid));
                }                   
                else {
                    newMR.Date_Due__c = Date.today();
                }
                newMR.Source_Maintenance_Request__c =  cid;               
                newMRList.add(newMR);
            }

            if(newMRList.size() > 0){
                insert newMRList;

                Map<Id,Id> mapNewOldrecords = new Map<Id,Id>();

                for(case c: newMRList){
                    mapNewOldrecords.put(c.Source_Maintenance_Request__c,c.Id);
                }

                List<Equipment_Maintenance_Item__c> clonedEMIList = new List<Equipment_Maintenance_Item__c>();
                for(Equipment_Maintenance_Item__c eMI:listOfEMI){
                    Equipment_Maintenance_Item__c newEMI = eMI.clone(false,true,false,false);
                    newEMI.Maintenance_Request__c = mapNewOldrecords.get(eMI.Maintenance_Request__c);
                    clonedEMIList.add(newEMI);
                }

                if(clonedEMIList.size()>0){
                    insert clonedEMIList;
                }   
            }

        }      


    }    
}