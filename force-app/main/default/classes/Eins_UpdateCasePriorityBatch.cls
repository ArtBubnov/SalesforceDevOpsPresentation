public without sharing class Eins_UpdateCasePriorityBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String caseQuery = 'SELECT Id, PNR__c, ContactId, Departure_Date__c, Return_Date__c, Priority, Status, Topic__c' +
        ' FROM Case WHERE RecordType.Name IN (\'New Standard Case\', \'Standard Case\')' + 
        ' AND (Origin = \'Web\' OR Origin = \'Email\') AND Status != \'Closed\'';
        return Database.getQueryLocator(caseQuery);
    }

    public void execute(Database.BatchableContext bc, List<Case> cases) {
        List<Case> casesWithNewPriorities = CasePriorityHelper.prioritiseCases(cases);
        try {
            update casesWithNewPriorities;
        } catch(Exception e) {
            System.debug(e);
        }
    }

    public void finish(Database.BatchableContext bc){
        AsyncApexJob apexJob = [
            SELECT Id, Status, JobType, NumberOfErrors, JobItemsProcessed, TotalJobItems,
                CompletedDate, ExtendedStatus
            FROM AsyncApexJob
            WHERE Id =: bc.getJobId()
        ];

        List<String> toAddresses = new List<String>();
        Map<String, Case_Priority_Batch_Emails__c> emails = Case_Priority_Batch_Emails__c.getAll();
        for (Case_Priority_Batch_Emails__c emailItem : emails.values()) {
            toAddresses.add(emailItem.Email__c);
        }
        // toAddresses.add('salesforce.support@eurostar.com');
        // toAddresses.add('rebecca.fajon@eurostar.com');
        // toAddresses.add('matthew.elvy@eurostar.com');
        // toAddresses.add('eleanor.brown@eurostar.com');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject('Updating Case Priority Batch - ' + apexJob.Status);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(
            'The batch Apex job completed on  ' + apexJob.CompletedDate + ',\n\n' +
            'Job Status : ' + apexJob.Status + '\n'+
            'Total Job Items processed : ' + apexJob.TotalJobItems + '\n'+
            'Number of Job Items processed : ' + apexJob.JobItemsProcessed + '\n' +
            'Number of Failures : '+ apexJob.NumberOfErrors
        );

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
