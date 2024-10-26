public with sharing class ScheduleLeadAttentionBatch implements Schedulable {
    public void execute(SchedulableContext ctx) {
        NeedAtentionLeadBatch batch = new NeedAtentionLeadBatch();
        Database.executeBatch(batch);
    }
}