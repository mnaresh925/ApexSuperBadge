global with sharing class WarehouseSyncSchedule implements Schedulable{
    // implement scheduled code here
    global void execute(SchedulableContext context){
        System.enqueueJob(new WarehouseCalloutService());
    }
}