public with sharing class ProgramAssignmentTriggerHandler extends TriggerHandler {
    
    public override void beforeInsert() {
        List<Program_Assignment__c> programAssignmentList = Trigger.New;
        Set<Id> contactIds = new Set<Id>();
        Set<Id> protgramsIds = new Set<Id>();
        Set<Program_Assignment__c> programAssignmentSet = new Set<Program_Assignment__c>();

        for (Program_Assignment__c pA : programAssignmentList) {
            if(pA.Autoname__c){
                contactIds.add(pA.Contact__c);
                protgramsIds.add(pA.Program__c);
            }
        }

        Map<Id,Contact> contacts = new Map<Id,Contact>(SOQLQueryHelper.getContactsByIdsSet(contactIds));
        Map<Id,Program__c> programs = new Map<Id,Program__c> (SOQLQueryHelper.getProgramsByIdSet(protgramsIds));

        for(Program_Assignment__c pA : programAssignmentList){
            programAssignmentSet.add(ProgramAssignmentHalper.generateNameAndAddToObject(
                pA,contacts.get(pA.Contact__c),programs.get(pA.Program__c)));
        }
    }

    public override void beforeUpdate() { 
        List<Program_Assignment__c> programAssignmentList = Trigger.New;
        Set<Id> contactIds = new Set<Id>();
        Set<Id> protgramsIds = new Set<Id>();
        Set<Program_Assignment__c> programAssignmentSet = new Set<Program_Assignment__c>();

        Integer key = 0;
        for (Program_Assignment__c pA : programAssignmentList) {
            if(pA.Autoname__c){
                key = 1;
                contactIds.add(pA.Contact__c);
                protgramsIds.add(pA.Program__c);
            }
        }
        if(key == 1){
            Map<Id,Contact> contacts = new Map<Id,Contact>(SOQLQueryHelper.getContactsByIdsSet(contactIds));
            Map<Id,Program__c> programs = new Map<Id,Program__c> (SOQLQueryHelper.getProgramsByIdSet(protgramsIds));

            for(Program_Assignment__c pA : programAssignmentList){
                programAssignmentSet.add(ProgramAssignmentHalper.generateNameAndAddToObject(
                pA,contacts.get(pA.Contact__c),programs.get(pA.Program__c)));
            }
        }
    }
}