public with sharing class OutreachTriggerHandler extends TriggerHandler {

    public override void afterInsert(){
        List<Outreach__c> outreachesList = (List<Outreach__c>) Trigger.new;
        Set<Id> leadIds = new Set<Id>();
        for(Outreach__c outreach : outreachesList){
            leadIds.add(outreach.Lead__c);
        }
        OutreachTriggerHelper.updateLeadCountOutreachField(leadIds);
    }

    public override void afterUpdate(){

        Map<Id, Outreach__c> newOutreaches = (Map<Id, Outreach__c>) Trigger.newMap;
        Map<Id, Outreach__c> oldOutreaches = (Map<Id, Outreach__c>) Trigger.oldMap;
        Set<Id> leadIds = new Set<Id>();

        Boolean leadOrOutcomeFieldsAreChanged = false;

        for(Outreach__c newOutreach : newOutreaches.values()){
            if(newOutreach.Lead__c != oldOutreaches.get(newOutreach.Id).Lead__c){
                leadIds.add(newOutreach.Lead__c);
                leadIds.add(oldOutreaches.get(newOutreach.Id).Lead__c);
            }
            else if((newOutreach.Outcome__c != oldOutreaches.get(newOutreach.Id).Outcome__c) && 
                    (newOutreach.Outcome__c == 'Accepted' && oldOutreaches.get(newOutreach.Id).Outcome__c != 'Accepted')){
                
                leadIds.add(newOutreach.Lead__c);
                leadIds.add(oldOutreaches.get(newOutreach.Id).Lead__c);
            }
            else if((newOutreach.Outcome__c != oldOutreaches.get(newOutreach.Id).Outcome__c) && 
                    (newOutreach.Outcome__c != 'Accepted' && oldOutreaches.get(newOutreach.Id).Outcome__c == 'Accepted')){
                
                leadIds.add(newOutreach.Lead__c);
                leadIds.add(oldOutreaches.get(newOutreach.Id).Lead__c);
            }
        }
        OutreachTriggerHelper.updateLeadCountOutreachField(leadIds);
    }

    public override void afterDelete(){
        List<Outreach__c> outreachesList = (List<Outreach__c>) Trigger.old;
        Set<Id> leadIds = new Set<Id>();
        for(Outreach__c outreach : outreachesList){
            leadIds.add(outreach.Lead__c);
        }
        OutreachTriggerHelper.updateLeadCountOutreachField(leadIds);
    }

    public override void afterUndelete(){
        List<Outreach__c> outreachesList = (List<Outreach__c>) Trigger.new;
        Set<Id> leadIds = new Set<Id>();
        for(Outreach__c outreach : outreachesList){
            leadIds.add(outreach.Lead__c);
        }
        OutreachTriggerHelper.updateLeadCountOutreachField(leadIds);
    }
}