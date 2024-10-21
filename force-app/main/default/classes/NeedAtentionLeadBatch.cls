public with sharing class NeedAtentionLeadBatch implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        List<Lead> leads = [
            SELECT Id, Name, Need_Attention__c,Owner.Email, (SELECT Name, Outcome__c FROM Outreachs__r) 
            FROM Lead
            WHERE Need_Attention__c = false
        ];

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
        NotificateUserAboutNewLeadStatus(leadsToUpdate);
    }

    private void NotificateUserAboutNewLeadStatus(List<Lead> leadsList){
        System.debug('In the email sender');
        for(Lead lead : leadsList){
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(new String[] { lead.Owner.Email });
            emailToSend.setSubject('Lead Status Updated');
            emailToSend.setPlainTextBody('Dear ' + lead.Owner.Name + ',  lead status - updated ');            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailToSend });
        }
    
    }
}
