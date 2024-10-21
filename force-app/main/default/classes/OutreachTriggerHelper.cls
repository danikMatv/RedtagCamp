public with sharing class OutreachTriggerHelper {

    public static void updateLeadCountOutreachField(){

        Boolean leadFieldIsChanged = false;
        
        List<Lead> leadsList = SOQLQueryHelper.getAllLeadsAndFewParamFromOutreach();
        
        for(Lead lead : leadsList){

            Integer countOfChild = 0;
            Integer countOfAcceptedChild = 0;

            for(Outreach__c outreach : lead.Outreachs__r){
                countOfChild++;
                if(outreach.Outcome__c == 'Accepted'){
                    countOfAcceptedChild++;
                }
            }

            lead.Outreaches_count__c = countOfChild;
            lead.Successful_Outreaches__c = countOfAcceptedChild;
        }

        update leadsList;
    }


    public static void updateLeadCountOutreachFieldAfterChanges(Map<Id,Outreach__c> newOutreaches,Map<Id,Outreach__c> oldOutreaches){

        Boolean leadOrOutcomeFieldsAreChanged = false;

        for(Outreach__c newOutreach : newOutreaches.values()){
            if(newOutreach.Lead__c != oldOutreaches.get(newOutreach.Id).Lead__c){
                leadOrOutcomeFieldsAreChanged = true;
            }
            else if(newOutreach.Outcome__c != oldOutreaches.get(newOutreach.Id).Outcome__c){
                leadOrOutcomeFieldsAreChanged = true;
            }

        }
        if(leadOrOutcomeFieldsAreChanged){
            List<Lead> leadsList = SOQLQueryHelper.getAllLeadsAndFewParamFromOutreach();
            
            for(Lead lead : leadsList){

                Integer countOfChild = 0;
                Integer countOfAcceptedChild = 0;

                for(Outreach__c outreach : lead.Outreachs__r){
                    countOfChild++;
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
}