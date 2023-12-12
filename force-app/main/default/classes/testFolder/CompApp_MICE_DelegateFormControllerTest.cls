@IsTest
private class CompApp_MICE_DelegateFormControllerTest {

    @TestSetup
    static void prepareData() {
        Lead newLead = new Lead();
        newLead.Company = 'Acme inc';
        newLead.Conference_or_Event_Name__c = 'Event';
        newLead.Conference_or_Event_Date__c = Date.today().addDays(10);
        newLead.Conference_or_Event_End_Date__c = Date.today().addDays(20);
        newLead.Type__c = 'Conference';
        newLead.Salutation = 'MR.';
        newLead.FirstName = 'firstName';
        newLead.Email = 'fakeemail@nosuchdomain.err';
        newLead.LastName = 'lastName';
        newLead.Industry = 'Chemicals';
        newLead.Number_of_Delegates__c = 3;
        newLead.LeadSource = 'MICE Special Rate Form';
        newLead.Status = 'Open';
        newLead.Description = 'Using chemicals';
        newLead.Special_Rate_Code__c = 'abcdef123456';
        insert newLead;
    }

    @IsTest
    static void testSubmitOk() {
        CompApp_MICE_DelegateRegFormController instance = new CompApp_MICE_DelegateRegFormController();
        CompApp_MICE_DelegateRegFormController.DataResult result = CompApp_MICE_DelegateRegFormController.processDelegateRegForm (
                '255.255.255.255', 'MR.', 'firstName1', 'lastName1', 'fakeemail1@nosuchdomain.err', 'street', 'city',
                'postcode', 'Gonduras', '37529711111', 'abcdef123456'
        );
        System.assert(!result.hasError);
    }

    @IsTest
    static void testSubmitWrongRateCode() {
        CompApp_MICE_DelegateRegFormController.DataResult result = CompApp_MICE_DelegateRegFormController.processDelegateRegForm (
                '255.255.255.255', 'MR.', 'firstName1', 'lastName1', 'fakeemail1@nosuchdomain.err', 'street', 'city',
                'postcode', 'Gonduras', '37529711111', 'abcdef12345'
        );
        System.assert(result.hasError);
        System.assert(result.specRateCodeDoNotExist);
    }

    @IsTest
    static void testSubmitAlreadyHasActiveRateCode() {
        Id MICEId = [SELECT Id FROM RecordType WHERE DeveloperName = 'MICE_Person_Account' and SObjectType = 'Account' Limit 1].Id;
        Account customer = new Account(FirstName = 'John', LastName = 'Doe', RecordTypeId = MICEId,
                Current_Special_Rate_Code__pc = 'abcdef123456', Customer_Email__pc = 'fakeemail1@nosuchdomain.err',
                Aria_Email__pc = 'fakeemail1@nosuchdomain.err'
        );
        insert customer;

        CompApp_MICE_DelegateRegFormController.DataResult result = CompApp_MICE_DelegateRegFormController.processDelegateRegForm (
                '255.255.255.255', 'MR.', 'firstName1', 'lastName1', 'fakeemail1@nosuchdomain.err', 'street', 'city',
                'postcode', 'Gonduras', '37529711111', 'abcdef123456'
        );
        System.assert(result.hasError);
        System.assert(result.isAlreadyHasActiveCode);
    }

    @IsTest
    static void testSubmitPreviousRateCodeDuplicate() {
        Id MICEId = [SELECT Id FROM RecordType WHERE DeveloperName = 'MICE_Person_Account' and SObjectType = 'Account' Limit 1].Id;
        Account customer = new Account(FirstName = 'John', LastName = 'Doe', RecordTypeId = MICEId,
                Current_Special_Rate_Code__pc = '', Customer_Email__pc = 'fakeemail1@nosuchdomain.err',
                Aria_Email__pc = 'fakeemail1@nosuchdomain.err', Previous_Special_Rate_Codes__pc = 'abcdef123456'
        );
        insert customer;

        CompApp_MICE_DelegateRegFormController.DataResult result = CompApp_MICE_DelegateRegFormController.processDelegateRegForm (
                '255.255.255.255', 'MR.', 'firstName1', 'lastName1', 'fakeemail1@nosuchdomain.err', 'street', 'city',
                'postcode', 'Gonduras', '37529711111', 'abcdef123456'
        );
        System.assert(result.hasError);
        System.assert(result.isPreviousCodeDuplicate);
    }
}