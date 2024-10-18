public with sharing class ProgramTriggerHandler extends TriggerHandler{
    
    public override virtual void afterUpdate() {
        Map<Id,Program__c> newPrograms = (Map<Id,Program__c>) Trigger.newMap;
        Map<Id,Program__c> oldPrograms = (Map<Id,Program__c>) Trigger.oldMap;

        Set<Id> programsIds = new Set<Id> ();

        for(Id programId : newPrograms.keySet()){
            Program__c newProgram = newPrograms.get(programId);
            Program__c oldProgram = oldPrograms.get(programId);

            if(newProgram.Name != oldProgram.Name){
                programsIds.add(programId);
            }
        }

        List<Program_Assignment__c> programAssignments = SOQLQueryHelper.programAssignmentsWithAutonameTrue(programsIds);

        for(Program_Assignment__c pA : programAssignments){
            pA.Name = 'Changed'; // This will call beforeUpdate trigger in ProgramAssignmentTriggerHandler and change related ProgramAssigns.  
        }

        update programAssignments;
    }

    public override virtual void beforeDelete(){
        ProgramTriggerHelper.deleteExeptionIfChildNotAvailableForDelete((Map<Id,Program__c>) Trigger.oldMap);
        ProgramTriggerHelper.deleteProgramAssignmentRelatedToDeletedProgram((Map<Id,Program__c>) Trigger.oldMap);
    }
}