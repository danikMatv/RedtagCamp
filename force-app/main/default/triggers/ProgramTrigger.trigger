trigger ProgramTrigger on Program__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    new ProgramTriggerHandler().run();
}