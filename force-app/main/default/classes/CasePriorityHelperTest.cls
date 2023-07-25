@isTest
private class CasePriorityHelperTest {

    @TestSetup
    static void makeData() {
        List<Contact> contacts = new List<Contact>();
        contacts.add(Eins_TestDataFactory.createTestContactWithLoyaltyStatus('Carte Classique'));
        contacts.add(Eins_TestDataFactory.createTestContactWithLoyaltyStatus('Carte Blanche'));
        contacts.add(Eins_TestDataFactory.createTestContactWithLoyaltyStatus('Carte Blanche (VIP)'));
        contacts.add(Eins_TestDataFactory.createTestContactWithLoyaltyStatus('Carte Blanche (Elite)'));
        contacts.add(Eins_TestDataFactory.createTestContactWithLoyaltyStatus('Welcome'));
        insert contacts;
    }

    @isTest
    static void testPrioritiseEliteCasesByReturnDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Carte Blanche (Elite)'
            LIMIT 1
        ];
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            PNR__c = 'LFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today(),
            ContactId = contactItem.Id
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
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today().addDays(5),
            ContactId = contactItem.Id
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
            Return_Date__c = Date.today().addDays(15),
            ContactId = contactItem.Id
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('High', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseEliteCasesByDepartureDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Carte Blanche (Elite)'
            LIMIT 1
        ];
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
            ContactId = contactItem.Id
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
            ContactId = contactItem.Id
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
            ContactId = contactItem.Id
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('High', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseUnknownCasesByDepartureDate() {
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            PNR__c = 'LFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today()
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
            Departure_Date__c = Date.today().addDays(5)
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
            Departure_Date__c = Date.today().addDays(15)
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
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
    }

    @isTest
    static void testPrioritiseClassiqueCasesByReturnDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Carte Classique'
            LIMIT 1
        ];
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            PNR__c = 'LFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today(),
            ContactId = contactItem.Id
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
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today().addDays(5),
            ContactId = contactItem.Id
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
            Return_Date__c = Date.today().addDays(15),
            ContactId = contactItem.Id
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Medium', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseClassiqueCasesByDepartureDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Carte Classique'
            LIMIT 1
        ];
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
            ContactId = contactItem.Id
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
            ContactId = contactItem.Id
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
            ContactId = contactItem.Id
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Medium', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseNonMemberCasesByReturnDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Welcome'
            LIMIT 1
        ];
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            PNR__c = 'LFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today(),
            ContactId = contactItem.Id
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
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today().addDays(5),
            ContactId = contactItem.Id
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
            Return_Date__c = Date.today().addDays(15),
            ContactId = contactItem.Id
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
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
    }

    @isTest
    static void testPrioritiseNonMemberCasesNoDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Welcome'
            LIMIT 1
        ];
        List<Case> casesBefore = new List<Case>();
        Case longAgoCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Long ago',
            Departure_Date__c = Date.today().addDays(-15),
            ContactId = contactItem.Id
        );
        casesBefore.add(longAgoCase);
        Case wnoDateCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'No date',
            ContactId = contactItem.Id
        );
        casesBefore.add(wnoDateCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Long ago') {
                System.assertEquals('Low', caseItem.Priority);
            }
            if (caseItem.Subject == 'No date') {
                System.assertEquals('Low', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseClassiqueCasesNoDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Carte Classique'
            LIMIT 1
        ];
        List<Case> casesBefore = new List<Case>();
        Case longAgoCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Long ago',
            Departure_Date__c = Date.today().addDays(-15),
            ContactId = contactItem.Id
        );
        casesBefore.add(longAgoCase);
        Case wnoDateCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'No date',
            ContactId = contactItem.Id
        );
        casesBefore.add(wnoDateCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Long ago') {
                System.assertEquals('Low', caseItem.Priority);
            }
            if (caseItem.Subject == 'No date') {
                System.assertEquals('Low', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseBlancheCasesNoDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Carte Blanche'
            LIMIT 1
        ];
        List<Case> casesBefore = new List<Case>();
        Case longAgoCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Long ago',
            Departure_Date__c = Date.today().addDays(-15),
            ContactId = contactItem.Id
        );
        casesBefore.add(longAgoCase);
        Case wnoDateCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'No date',
            ContactId = contactItem.Id
        );
        casesBefore.add(wnoDateCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Long ago') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'No date') {
                System.assertEquals('Medium', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseEliteCasesNoDate() {
        Contact contactItem = [
            SELECT Id
            FROM Contact
            WHERE Loyalty_Status__c = 'Carte Blanche (VIP)'
            LIMIT 1
        ];
        List<Case> casesBefore = new List<Case>();
        Case longAgoCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Long ago',
            Departure_Date__c = Date.today().addDays(-15),
            ContactId = contactItem.Id
        );
        casesBefore.add(longAgoCase);
        Case wnoDateCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'No date',
            ContactId = contactItem.Id
        );
        casesBefore.add(wnoDateCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Long ago') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'No date') {
                System.assertEquals('High', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseUrgentCases() {
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            PNR__c = 'LFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today()
        );
        casesBefore.add(todayCase);
        Case weekCase = new Case(
            PNR__c = 'LFES43',
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Week',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today().addDays(5)
        );
        casesBefore.add(weekCase);
        Case futureCase = new Case(
            PNR__c = 'PFE343',
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Future',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today().addDays(15)
        );
        casesBefore.add(futureCase);
        Case longAgoCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Long ago',
            Departure_Date__c = Date.today().addDays(-15)
        );
        casesBefore.add(longAgoCase);
        Case wnoDateCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'No date'
        );
        casesBefore.add(wnoDateCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'No date') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Long ago') {
                System.assertEquals('Medium', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testUpdatePriorityUnknownCases() {
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today()
        );
        casesBefore.add(todayCase);
        Case weekCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Week',
            Departure_Date__c = Date.today().addDays(5)
        );
        casesBefore.add(weekCase);
        Case futureCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Future',
            Departure_Date__c = Date.today().addDays(15)
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        List<Case> casesAfterInsert = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfterInsert) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            caseItem.PNR__c = 'JHB943';
        }
        update casesAfterInsert;
        Test.stopTest();

        List<Case> casesAfterUpdate = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfterUpdate) {
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
    }
}