@isTest
public with sharing class CreateTestData {
    public static void makeData(Integer numberOfRecords,String type){
        List<Vehicle__c> vehicles = createVehicles();
        List<Product2> equipment = createEquipment();
        List<Case> maintenanceRequest = createMaintenanceRequest(vehicles,numberOfRecords,type);
        List<Equipment_Maintenance_Item__c> joinRecords = createJoinRecords(equipment, maintenanceRequest,numberOfRecords);
    }
    public static List<Vehicle__c> createVehicles(){
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        vehicles.add(new Vehicle__c(Name = 'Toy Hauler RV', Air_Conditioner__c = true, Bathrooms__c = 1, Bedrooms__c = 1, Model__c = 'Toy Hauler RV'));
        vehicles.add(new Vehicle__c(Name = 'Travel Trailer RV', Air_Conditioner__c = true, Bathrooms__c = 2, Bedrooms__c = 2, Model__c = 'Travel Trailer RV'));
        vehicles.add(new Vehicle__c(Name = 'Teardrop Camper', Air_Conditioner__c = true, Bathrooms__c = 1, Bedrooms__c = 1, Model__c = 'Teardrop Camper'));
        vehicles.add(new Vehicle__c(Name = 'Pop-Up Camper', Air_Conditioner__c = true, Bathrooms__c = 1, Bedrooms__c = 1, Model__c = 'Pop-Up Camper'));
        insert vehicles;
        return vehicles;
    }
    public static List<Product2> createEquipment(){
        List<Product2> equipments = new List<Product2>();
        equipments.add(new Product2(name = 'Fuse 20B',Replacement_Part__c = true,Cost__c = 1000, Maintenance_Cycle__c = 30  ));
        equipments.add(new Product2(name = 'Breaker 13C',Replacement_Part__c = true,Cost__c = 100  , Maintenance_Cycle__c = 15));
        equipments.add(new Product2(name = 'UPS 20 VA',Replacement_Part__c = true,Cost__c = 200  , Maintenance_Cycle__c = 60));
        insert equipments;
        return equipments;
        
    }
    public static List<Case> createMaintenanceRequest(List<Vehicle__c> vehicles,Integer numberOfRecords,String type){
        List<Case> maintenanceRequests = new List<Case>();
        for(Integer i=0;i<numberOfRecords;i++){
            maintenanceRequests.add(new Case(Vehicle__c = vehicles.get(1).Id, Type = type, Date_Reported__c = Date.today()));
        }       
        insert maintenanceRequests;
        return maintenanceRequests;
    }
    public static List<Equipment_Maintenance_Item__c> createJoinRecords(List<Product2> equipment, List<Case> maintenanceRequest,Integer numberOfRecords){ 
        List<Equipment_Maintenance_Item__c> joinRecords = new List<Equipment_Maintenance_Item__c>();
        if(numberOfRecords == 1){
            joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = equipment.get(0).Id, Maintenance_Request__c = maintenanceRequest.get(0).Id));
            joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = equipment.get(1).Id, Maintenance_Request__c = maintenanceRequest.get(0).Id));
            joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = equipment.get(2).Id, Maintenance_Request__c = maintenanceRequest.get(0).Id));  
        }else{
           for(Integer i=0;i<numberOfRecords-1;i++){
            joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = equipment.get(0).Id, Maintenance_Request__c = maintenanceRequest.get(i).Id));
            joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = equipment.get(1).Id, Maintenance_Request__c = maintenanceRequest.get(i).Id));
            joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = equipment.get(2).Id, Maintenance_Request__c = maintenanceRequest.get(i).Id));  
        }   
        }
                 
        insert joinRecords;
        return joinRecords;
    }
}
