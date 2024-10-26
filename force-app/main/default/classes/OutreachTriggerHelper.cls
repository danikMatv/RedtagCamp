public with sharing class OutreachTriggerHelper {

    public static void updateLeadCountOutreachField(Set<Id> leadIds){
        
        List<Lead> leadsList = SOQLQueryHelper.getLeadsWithOutreachesById(leadIds);
        
        for(Lead lead : leadsList){

            Integer countOfChild = lead.Outreachs__r.size();
            Integer countOfAcceptedChild = 0;

            for(Outreach__c outreach : lead.Outreachs__r){
                if(outreach.Outcome__c == 'Accepted'){
                    countOfAcceptedChild++;
                }
            }

            lead.Outreaches_count__c = countOfChild;
            lead.Successful_Outreaches__c = countOfAcceptedChild;
        }

        update leadsList;
    }
}