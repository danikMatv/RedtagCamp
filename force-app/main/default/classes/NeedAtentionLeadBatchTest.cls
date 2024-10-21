@isTest
public class NeedAtentionLeadBatchTest {

    @isTest
    static void testExecuteMethodInNeedAtentionLeadBatchClass() {


        Test.startTest();
        User user = new User();
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.Username = 'test839734@' + System.currentTimeMillis() + '.com';
        user.LastName = 'Test';
        user.Email = 'danik0matv@gmail.com';
        
        Lead testLead = TestDataFactory.generateLead();
        insert testLead;
        testLead.OwnerId = user.Id;

        Outreach__c testOutreach = TestDataFactory.generateOutreach(testLead);
        insert testOutreach;

        NeedAtentionLeadBatch batch = new NeedAtentionLeadBatch();
        String cron = '0 0 2 ? * MON-FRI';
        System.schedule('Test Need Attention Lead Batch', cron, batch);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
    
        //System.assertEquals(1, invocations, 'An email has not been sent');
    
        Lead updatedLead = [SELECT Id, Need_Attention__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, updatedLead.Need_Attention__c, 'The Need_Attention__c field should be updated to true');

    }
}
