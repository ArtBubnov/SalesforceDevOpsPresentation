@isTest
private class Eins_UpdateCasePriorityBatch_Test {

    @isTest
    private static void testUpdateCasePriority() {
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            PNR__c = 'LFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today(),
            Origin = 'Web'
        );
        casesBefore.add(todayCase);
        Case weekCase = new Case(
            PNR__c = 'LFES43',
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Week',
            Departure_Date__c = Date.today().addDays(5),
            Origin = 'Web'
        );
        casesBefore.add(weekCase);
        Case futureCase = new Case(
            PNR__c = 'PFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Future',
            Departure_Date__c = Date.today().addDays(15),
            Origin = 'Web'
        );
        casesBefore.add(futureCase);
        insert casesBefore;

        List<Case> casesAfterInsert = [
            SELECT Id, Priority, Subject, Departure_Date__c
            FROM Case
        ];
        for (Case caseItem : casesAfterInsert) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
                caseItem.Departure_Date__c = Date.today().addDays(5);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
                caseItem.Departure_Date__c = Date.today().addDays(10);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Low', caseItem.Priority);
                caseItem.Departure_Date__c = Date.today();
            }
        }
        update casesAfterInsert;

        List<Case> casesAfterUpdate = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfterInsert) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Low', caseItem.Priority);
            }
        }

        Test.startTest();
            Eins_UpdateCasePriorityBatch updateCasePriorityBatch = new Eins_UpdateCasePriorityBatch();
            Database.executeBatch(updateCasePriorityBatch);
        Test.stopTest();

        List<Case> casesAfterBatch = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfterBatch) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Low', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('High', caseItem.Priority);
            }
        }
    }
}