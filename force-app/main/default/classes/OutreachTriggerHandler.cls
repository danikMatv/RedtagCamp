public with sharing class OutreachTriggerHandler extends TriggerHandler {

    public override void afterInsert(){
        OutreachTriggerHelper.updateLeadCountOutreachField();
    }

    public override void afterUpdate(){
        OutreachTriggerHelper.updateLeadCountOutreachFieldAfterChanges((Map<Id,Outreach__c>)Trigger.oldMap,(Map<Id,Outreach__c>)Trigger.newMap);
    }

    public override void afterDelete(){
        OutreachTriggerHelper.updateLeadCountOutreachField();
    }

    public override void afterUndelete(){
        OutreachTriggerHelper.updateLeadCountOutreachField();
    }
}