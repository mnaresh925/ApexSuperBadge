public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(Map<Id,Case> newRecords,Map<Id,Case> oldRecords) {
        // TODO: Complete the method to update workorders
        //Check case Type and status
        List<Case> closedMRList = new List<Case>();
        closedMRList = [select Id,CaseNumber from case where Status='Closed' and Type IN ('Repair','Routine Maintenance') and Id IN :newRecords.keySet()
                                   WITH SECURITY_ENFORCED];       
        List<Equipment_Maintenance_Item__c> listOfEMI = [SELECT Id, Name, Maintenance_Request__c, Equipment__c, Equipment__r.Maintenance_Cycle__c 
                                                    FROM Equipment_Maintenance_Item__c where Maintenance_Request__c IN :newRecords.keySet() 
                                                    WITH SECURITY_ENFORCED
                                                    Order By Equipment__r.Maintenance_Cycle__c
                                                    ];
        Map<Id,Integer> mapMRCycle = new Map<Id,Integer>();        
        for(Equipment_Maintenance_Item__c eMI:listOfEMI){
            if(!mapMRCycle.containsKey(eMI.Maintenance_Request__c)){
                mapMRCycle.put(eMI.Maintenance_Request__c, (Integer)eMI.Equipment__r.Maintenance_Cycle__c);
            }
        }
        List<case> newMRList = new List<case>();
        Map<Id,Id> mapNewOldrecords =  new Map<Id,Id>();
        for(Case c:closedMRList){
            //if recordstatus is changed
            Case newMR = new Case();
            Case inMR = newRecords.get(c.Id);
            if(inMR.Status != oldRecords.get(c.Id).Status){
                newMR = inMR.clone(false, true, false, false);
                newMR.Status = 'New';
                newMR.Type = 'Routine Maintenance';
                newMR.Subject = 'New Routine Maintenance created from:'+c.CaseNumber;
                newMR.Date_Reported__c = Date.today();
                if(mapMRCycle.containsKey(c.Id)){
                    newMR.Date_Due__c = Date.today().addDays(mapMRCycle.get(c.Id));
                }                   
                else {
                    newMR.Date_Due__c = Date.today();
                }
                newMR.Source_Maintenance_Request__c =  c.Id;               
                newMRList.add(newMR);
            }
        }
        if(newMRList.size() > 0){
            insert newMRList;
        }
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