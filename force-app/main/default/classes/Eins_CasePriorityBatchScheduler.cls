global class Eins_CasePriorityBatchScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        Eins_UpdateCasePriorityBatch updateCasePriorityBatch = new Eins_UpdateCasePriorityBatch(); 
        Database.executeBatch(updateCasePriorityBatch);
    }
}