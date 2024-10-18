public with sharing class ProgramAssignmentTriggerHandler extends TriggerHandler {
    
    public override void beforeInsert() {
        List<Program_Assignment__c> programAssignmentList = Trigger.New;
        Set<Id> contactIds = new Set<Id>();
        Set<Id> protgramsIds = new Set<Id>();

        for (Program_Assignment__c pA : programAssignmentList) {
            if(pA.Autoname__c){
                contactIds.add(pA.Contact__c);
                protgramsIds.add(pA.Program__c);
            }
        }

        Map<Id,Contact> contacts = new Map<Id,Contact>(SOQLQueryHelper.getContactsByIdsSet(contactIds));
        Map<Id,Program__c> programs = new Map<Id,Program__c> (SOQLQueryHelper.getProgramsByIdSet(protgramsIds));

        for(Program_Assignment__c pA : programAssignmentList){
            ProgramAssignmentHalper.generateNameAndAddToObject(
                pA,contacts.get(pA.Contact__c),programs.get(pA.Program__c));
        }
    }

    public override void beforeUpdate() { 
        List<Program_Assignment__c> programAssignmentList = Trigger.New;
        Map<Id,Program_Assignment__c> programAssignmentOldMap = (Map<Id,Program_Assignment__c>) Trigger.oldMap;
        Set<Id> contactIds = new Set<Id>();
        Set<Id> protgramsIds = new Set<Id>();
        
        Boolean autoNameIsElected = false;
        for (Program_Assignment__c pA : programAssignmentList) {
                if(pA.Autoname__c && pA.Autoname__c != programAssignmentOldMap.get(pA.Id).Autoname__c){
                        autoNameIsElected = true;
                        contactIds.add(pA.Contact__c);
                    }
                if(pA.Autoname__c && pA.Contact__c != programAssignmentOldMap.get(pA.Id).Contact__c){
                    autoNameIsElected = true;
                    contactIds.add(pA.Contact__c);
                    protgramsIds.add(pA.Program__c);
                }
                if(pA.Autoname__c && pA.Program__c != programAssignmentOldMap.get(pA.Id).Program__c){
                    autoNameIsElected = true;
                    contactIds.add(pA.Contact__c);
                    protgramsIds.add(pA.Program__c);
                }
                if(pA.Autoname__c && pA.Start_Date__c != programAssignmentOldMap.get(pA.Id).Start_Date__c){
                    autoNameIsElected = true;
                    contactIds.add(pA.Contact__c);
                    protgramsIds.add(pA.Program__c);
                }
                if(pA.Autoname__c && pA.Name != programAssignmentOldMap.get(pA.Id).Name){
                    autoNameIsElected = true;
                    contactIds.add(pA.Contact__c);
                    protgramsIds.add(pA.Program__c);
                }
            }
            
        if(autoNameIsElected){
            Map<Id,Contact> contacts = new Map<Id,Contact>(SOQLQueryHelper.getContactsByIdsSet(contactIds));
            Map<Id,Program__c> programs = new Map<Id,Program__c> (SOQLQueryHelper.getProgramsByIdSet(protgramsIds));

            for(Program_Assignment__c pA : programAssignmentList){
                ProgramAssignmentHalper.generateNameAndAddToObject(
                pA,contacts.get(pA.Contact__c),programs.get(pA.Program__c));
            }
        }
    }
}