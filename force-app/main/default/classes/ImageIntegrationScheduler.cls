public without sharing class ImageIntegrationScheduler implements Schedulable{
    /**
     * Method allows to schedule ImageIntegration queueable class in Salesforce
     * @param  SchedulableContext sc
     */ 
    public void execute(SchedulableContext sc)
    {  
        System.enqueueJob(new ImageIntegration());
    }
}