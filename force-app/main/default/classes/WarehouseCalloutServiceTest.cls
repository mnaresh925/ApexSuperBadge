@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
@IsTest
private static void TestQueable() {
    
    WarehouseCalloutService wcs = new WarehouseCalloutService();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
    System.enqueueJob(wcs);
    WarehouseCalloutService.getWareHouseRecords();
    WarehouseCalloutService.Equipment e = new WarehouseCalloutService.Equipment(true,1,'String ',2,1,1,'11');
    Test.stopTest();
    Product2 p = [select name,Replacement_Part__c,Cost__c,Current_Inventory__c,Lifespan_Months__c,Maintenance_Cycle__c from Product2 where Warehouse_SKU__c = '100003'][0];
    System.assertEquals(p.Replacement_Part__c, true);
    System.assertEquals(p.Maintenance_Cycle__c, 365);
}
}