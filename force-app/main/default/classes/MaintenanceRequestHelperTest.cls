@isTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
   @isTest
   private static void singleMRPositiveRecordTest() {
       CreateTestData.makeData(1,'Routine Maintenance');
       Case c= [select Id,Status from Case];
       Test.startTest();
       c.Status = 'Closed';
       Upsert c;
       Test.stopTest();
       Case newCase = [select Id,Status,Type,Subject,Date_Due__c from Case where Source_Maintenance_Request__c = :c.Id];
       System.assertEquals(newCase.Type, 'Routine Maintenance');
       System.assertEquals(newCase.Date_Due__c, Date.today().addDays(15));  
   }
   @isTest
   private static void bulkTest() {
    CreateTestData.makeData(300,'Routine Maintenance');
    List<case> cases = [select id,Status from case];
    for(case c: cases){
        c.Status = 'Closed';
    }
    Test.startTest();
    upsert cases;
    Test.stopTest();
    System.assertEquals(300, [select count() from case where Status != 'Closed']);    
   }

   @isTest
   private static void negitiveTest() {
    CreateTestData.makeData(1,'Other');
       Case c= [select Id,Status from Case];
       Test.startTest();
       c.Status = 'Closed';
       upsert c;
       Test.stopTest();
       System.assertEquals(0, [select count() from case where Status != 'Closed']);
    
   }

}