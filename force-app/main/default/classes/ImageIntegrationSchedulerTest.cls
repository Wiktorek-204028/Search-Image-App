@isTest
public without sharing class ImageIntegrationSchedulerTest {
   /**
    * Test checks if job has been scheduled 
    */
    @IsTest
    static void executeSchedulerTest(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ImagesMock());
        ImageIntegrationScheduler scheduler = new ImageIntegrationScheduler();
        String sch = '0 0 23 * * ?'; 
        String jobId = System.Schedule('Test Scheduler', sch, scheduler);  
        Test.stopTest(); 

        CronTrigger result = [SELECT Id, CronExpression, TimesTriggered, 
                                    NextFireTime
                          FROM CronTrigger 
                          WHERE id = :jobId];
        System.assertNotEquals(null, result);
    }
}