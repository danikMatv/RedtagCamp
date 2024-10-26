@isTest
public with sharing class OutreachTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        Lead lead = TestDataFactory.generateLead();
        insert lead;
        List<Outreach__c> outreaches = TestDataFactory.generateOutreaches(lead,3);
        insert outreaches;
    }
    
    @isTest
    private static void afterInserOutreachtSuccessfulTest(){
        Lead oldLead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        List<Outreach__c> outreaches = TestDataFactory.generateOutreaches(oldLead,3);

        Test.startTest();
            insert outreaches;
        Test.stopTest();

        Lead lead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        System.Assert.areEqual(6,lead.Outreaches_count__c, 'The number of outreaches should be 3');
    }

    @isTest
    private static void afterUpdateOutreachSuccessfulTest(){
        Lead oldLead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        List<Outreach__c> outreaches = [SELECT Id,Name,Lead__c,Outcome__c FROM Outreach__c WHERE Lead__c =:oldLead.Id];

        for(Outreach__c outreach : outreaches){
            outreach.Outcome__c = 'Accepted';
        }
        Test.startTest();
            update outreaches;
        Test.stopTest();

        Lead lead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        System.Assert.areEqual(3,lead.Successful_Outreaches__c, 'The number of successful outreaches should be 3');
    }

    @isTest
    private static void afterDeleteOutreachSuccessfulTest(){
        Lead oldLead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        List<Outreach__c> outreaches = [SELECT Id,Name,Lead__c,Outcome__c FROM Outreach__c WHERE Lead__c =:oldLead.Id];

        Test.startTest();
            delete outreaches;
        Test.stopTest();

        Lead lead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        System.Assert.areEqual(0,lead.Outreaches_count__c, 'The number of outreaches should be 0');
    }

    @isTest
    private static void afterUndeleteOutreachSuccessfulTest(){
        Lead oldLead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        List<Outreach__c> outreaches = [SELECT Id,Name,Lead__c,Outcome__c FROM Outreach__c WHERE Lead__c =:oldLead.Id];

        for(Outreach__c outreach : outreaches){
            outreach.Outcome__c = 'Accepted';
        }
        
        delete outreaches;

        Test.startTest();
            undelete outreaches;
        Test.stopTest();

        Lead lead = [SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c FROM Lead WHERE Name  = 'Test Lead' LIMIT 1];
        System.Assert.areEqual(3,lead.Outreaches_count__c, 'The number of successful outreaches should be 3');
    }
}