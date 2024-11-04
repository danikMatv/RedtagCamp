public with sharing class LeadTriggerHelper {

    // public static void checkIfJobNeedsToBeCancelled() {
    //     ControleAsyncProcesse__mdt settings = [SELECT Box__c FROM ControleAsyncProcesse__mdt WHERE Label = 'NeedAtentionLeadBatch?' LIMIT 1];
        
    //     List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Need Attention Lead Batch Job'];
        
    //     if (settings == null || !settings.Box__c) {
    //         // Kill if exist or off
    //         for (CronTrigger job : jobs) {
    //             System.abortJob(job.Id);
    //         }
    //     } else {
    //         if (jobs.isEmpty()) {
    //             System.debug('In LeadTriggerHelper');
    //             NeedAtentionLeadBatch needAtentionLeadBatch = new NeedAtentionLeadBatch();
    //             String cron = '0 0 2 ? * MON-FRI';//MON-FRI
    //             System.schedule('Need Attention Lead Batch Job', cron, needAtentionLeadBatch);
    //         }
    //     }
    // }

    public static void NotificateUserAboutNewLeadStatus() {
        System.debug('In the email sender');
        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
        emailToSend.setToAddresses(new String[] { UserInfo.getUserEmail() });
        emailToSend.setSubject('Lead Status Updated');
        emailToSend.setPlainTextBody('Dear ' + UserInfo.getFirstName() + ', lead status has been updated.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailToSend });
    }
}