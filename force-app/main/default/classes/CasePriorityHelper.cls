public inherited sharing class DLT_CaseBatch implements Database.Batchable<SObject>, Schedulable {

    private String status = DLT_CaseConstants.STATUS_CLOSED;

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new DLT_CaseBatch(), 50);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Status'
            + ' FROM Case'
            + ' WHERE Status != :status'
            );
    }

    public void execute(Database.BatchableContext bc, List<Case> scope) {
        // only caluclations in DLT_CaseTriggerHander needed
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
    }
}