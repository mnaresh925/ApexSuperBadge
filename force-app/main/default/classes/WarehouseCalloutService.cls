public with sharing class WarehouseCalloutService implements Queueable{

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public static void execute(QueueableContext context){
        getWareHouseRecords();
    }
    @Future(CallOut=true)
    public static void getWareHouseRecords() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(WAREHOUSE_URL);
        HttpResponse response = http.send(request);       
        if(response.getStatusCode() == 200){
            List<Equipment> wareHouseRecords = (List<Equipment>)JSON.deserialize(response.getBody(), List<Equipment>.class);
            if(wareHouseRecords.size() > 0){
                updateEquipmentRecords(wareHouseRecords);
            }
        }
    }
    
    private static void updateEquipmentRecords(List<Equipment> wareHouseRecords) {
        List<Product2> updateEquipments = new List<Product2>();
        for(Equipment e: wareHouseRecords){
            updateEquipments.add(new Product2(
                Replacement_Part__c = true,
                Name=e.name,
                Cost__c=e.cost,
                Current_Inventory__c=e.quantity,
                Lifespan_Months__c=e.lifespan,
                Maintenance_Cycle__c=e.maintenanceperiod,
                Warehouse_SKU__c=e.sku));
        }
        if(updateEquipments.size() >0){
            upsert updateEquipments;
        }
    }

    public class Equipment{
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Decimal cost;
        String sku;
        Public Equipment(Boolean replacement,Integer quantity,String name,Integer maintenanceperiod,Integer lifespan,Decimal cost,String sku){
        this.replacement =replacement;
        this.quantity = quantity;
        this.name = name;
        this.maintenanceperiod = maintenanceperiod;
        this.lifespan =lifespan;
        this.cost =cost;
        this.sku =sku;
        }
    }
    
}