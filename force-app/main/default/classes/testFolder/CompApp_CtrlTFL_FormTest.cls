@isTest
private class CompApp_CtrlTFL_FormTest {

    static final String USER_IP = '0.0.0.0';
    static final String LANGUAGE_CODE = 'EN';
    static final String TICKET_NUMBER = '222222222';
    static final String USER_INPUT_PNR = 'ABCDEF';
    static final String USER_EMAIL = 'mail@gmail.com';
    static final String FIRST_NAME = 'first';
    static final String LAST_NAME = 'second';
    static final String MOBILE_PHONE = '80291113344';
    static final String STREET = 'Street test';
    static final String CITY = 'City test';
    static final String POSTCODE = '12345678';
    static final String STATE = 'Test state';
    static final String COUNTRY = 'United Kingdom';
    static final String STAFF_ID = '001345678943';
    static String PASSWORD = 'passWord123$';

    @isTest
    public static void testTFLUserCreation() {

        CompApp_Constructs.EligibilityResponse er = CompApp_CtrlTFL_Form.processTFLInput(
                USER_IP, null,null,null,null,null, LANGUAGE_CODE, FIRST_NAME, LAST_NAME, USER_EMAIL, MOBILE_PHONE,
                STREET, CITY, POSTCODE, STATE, COUNTRY, STAFF_ID
        );

        System.assertEquals('TFL001345678943', [SELECT Aria_Person_Id__c FROM Account LIMIT 1].Aria_Person_Id__c);

    }

    @isTest
    public static void testTFLErrorHandling() {

        CompApp_Constructs.EligibilityResponse result1 = CompApp_CtrlTFL_Form.processTFLInput(
                USER_IP, null,null,null,null,null, LANGUAGE_CODE, FIRST_NAME, LAST_NAME, USER_EMAIL, MOBILE_PHONE,
                STREET, CITY, POSTCODE, STATE, COUNTRY, STAFF_ID
        );

        System.assertEquals(1, [SELECT Id FROM Account].size());
        CompApp_Constructs.EligibilityResponse result2 = CompApp_CtrlTFL_Form.processTFLInput(
                USER_IP, null,null,null,null,null, LANGUAGE_CODE, FIRST_NAME, LAST_NAME, USER_EMAIL, MOBILE_PHONE,
                STREET, CITY, POSTCODE, STATE, COUNTRY, STAFF_ID
        );

        System.assertEquals(1, [SELECT Id FROM Account].size());
        System.assertEquals(result2.softErrorHeader, Label.CompApp_TFL_ErrorHeader);
    }

    @isTest
    public static void testUniqueMemberValidation() {
        System.assertEquals(0, CompApp_CtrlTFL_Form.isUniqueUserEmail(USER_IP, USER_EMAIL));

        CompApp_Constructs.EligibilityResponse er = CompApp_CtrlTFL_Form.processTFLInput(
                USER_IP, null,null,null,null,null, LANGUAGE_CODE, FIRST_NAME, LAST_NAME, USER_EMAIL, MOBILE_PHONE,
                STREET, CITY, POSTCODE, STATE, COUNTRY, STAFF_ID
        );

        System.assertEquals('TFL001345678943', [SELECT Aria_Person_Id__c FROM Account LIMIT 1].Aria_Person_Id__c);
        System.assertEquals(1, CompApp_CtrlTFL_Form.isUniqueUserEmail(USER_IP, USER_EMAIL));

        RecordType personAccountRecordType  =  [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account' Limit 1];
        Account acc = new Account ();
        acc.FirstName = 'test-FName';
        acc.LastName  = 'test-LName';
        acc.RecordTypeId = personAccountRecordType.Id;
        acc.Customer_Email__pc = 'test@gmail.com';
        insert acc;

        System.assertEquals(2, CompApp_CtrlTFL_Form.isUniqueUserEmail(USER_IP, acc.Customer_Email__pc));
    }

    @isTest
    public static void uniqueCardIdValidationTest() {
        System.assertEquals(true, CompApp_CtrlTFL_Form.isUniqueIdCard(USER_IP, STAFF_ID));

        CompApp_Constructs.EligibilityResponse er = CompApp_CtrlTFL_Form.processTFLInput(
                USER_IP, null,null,null,null,null, LANGUAGE_CODE, FIRST_NAME, LAST_NAME, USER_EMAIL, MOBILE_PHONE,
                STREET, CITY, POSTCODE, STATE, COUNTRY, STAFF_ID
        );

        System.assertEquals('TFL001345678943', [SELECT Aria_Person_Id__c FROM Account LIMIT 1].Aria_Person_Id__c);
        System.assertEquals(false, CompApp_CtrlTFL_Form.isUniqueIdCard(USER_IP, STAFF_ID));

    }
}