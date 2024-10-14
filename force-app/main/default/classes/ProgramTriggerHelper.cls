public with sharing class ProgramTriggerHelper {
    
    public static void deleteProgramAssignmentRelatedToDeletedProgram(Map<Id, Program__c> deletedRecordsMap){
        Set<Id> programIds = deletedRecordsMap.keySet();
        List<Program_Assignment__c> programAssignments = SOQLQueryHelper.programAssignmentsWithoutProgram(programIds);
        if(programAssignments.size() == 0){
            System.debug(' programAssignments is empty');
        }
        delete programAssignments;
    }

    public static void deleteExeptionIfChildNotAvailableForDelete(Map<Id, Program__c> deletedRecordsMap) {
        Set<Id> programIds = new Set<Id>();
        List<Program_Assignment__c> programAssignments = SOQLQueryHelper.programAssignmentsWithStatusDeniedOrApplied();

        for(Program_Assignment__c pA : programAssignments){
            programIds.add(pA.Program__c);
        }

        for(Program__c pg : deletedRecordsMap.values()){
            if(programIds.contains(pg.Id)){ 
                pg.addError('Nope');
            }
        }
    }
}