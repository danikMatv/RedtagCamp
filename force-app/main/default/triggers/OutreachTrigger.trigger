trigger OutreachTrigger on Outreach__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    new OutreachTriggerHandler().run();
}