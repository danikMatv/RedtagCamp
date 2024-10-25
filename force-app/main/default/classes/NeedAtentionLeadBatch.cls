public with sharing class NeedAtentionLeadBatch implements Database.Batchable<Lead> {
    
    private static String query = 'SELECT Id, Name, Need_Attention__c, Owner.Email, (SELECT Name, Outcome__c FROM Outreachs__r) FROM Lead WHERE Need_Attention__c = false';

    public Iterable<Lead> start(Database.BatchableContext bc) {
        return [
            SELECT Id, Name, Need_Attention__c, Owner.Email,
                 (SELECT Name, Outcome__c FROM Outreachs__r) 
            FROM Lead
             WHERE Need_Attention__c = false
        ];
    }

    public void execute(Database.BatchableContext bc, List<Lead> leads) {
        List<Outreachs_outcome__mdt> outreachsOutcome = [SELECT Label FROM Outreachs_outcome__mdt];
        Set<String> successfulOutcomes = new Set<String>();

        for (Outreachs_outcome__mdt outcome : outreachsOutcome) {
            successfulOutcomes.add(outcome.Label);
        }

        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : leads) {
            Boolean needsAttention = true;

            for (Outreach__c outreach : lead.Outreachs__r) {
                if (successfulOutcomes.contains(outreach.Outcome__c)) {
                    needsAttention = false;
                    break;
                }
            }

            if (needsAttention) {
                lead.Need_Attention__c = true;
                leadsToUpdate.add(lead);
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        LeadTriggerHelper.NotificateUserAboutNewLeadStatus();
        System.debug('Batch process finished.');
    }
}
