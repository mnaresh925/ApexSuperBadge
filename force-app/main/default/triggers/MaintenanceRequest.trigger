trigger MaintenanceRequest on Case (before update, after update,after insert,before insert) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    switch on Trigger.operationType {
        when AFTER_INSERT {
            MaintenanceRequestHelper.updateWorkOrders(Trigger.newMap, Trigger.oldMap);
        }
        When AFTER_UPDATE{
            MaintenanceRequestHelper.updateWorkOrders(Trigger.newMap, Trigger.oldMap);
        }
        when else {
            
        }
    }
}