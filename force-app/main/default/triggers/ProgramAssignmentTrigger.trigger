trigger ProgramAssignmentTrigger on Program_Assignment__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    new ProgramAssignmentTriggerHandler().run();
}