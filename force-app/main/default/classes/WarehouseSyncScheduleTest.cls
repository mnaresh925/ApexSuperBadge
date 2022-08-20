@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    public static String CRON_EXP = '0 0 0 15 9 ? 2022';
    @isTest
    private static void Schduletest() {
        
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new WarehouseSyncSchedule());
        Test.stopTest();
        System.assertEquals(1, [select count() from Product2]);
    }
}