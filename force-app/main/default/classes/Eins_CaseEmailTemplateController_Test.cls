@isTest
public class Eins_CaseEmailTemplateController_Test {
    @testSetup
    static void makeData() {
        EmailTemplate testEmailTemplate = Eins_TestDataFactory.createEmailTemplate();
        insert testEmailTemplate;
    }

    @isTest
    private static void testGetEmailTemplates() {
        EmailTemplate testEmailTemplate = [
            SELECT Id, Body
            FROM EmailTemplate
            WHERE DeveloperName = 'unique_test_Email_Template'
        ];
        Case caseItem = Eins_TestDataFactory.createTestCaseWithTemplate(testEmailTemplate.Id);
        insert caseItem;

        Test.startTest();
        List<Eins_CaseEmailTemplateController.EmailTemplateWrapper> emailTemplates = Eins_CaseEmailTemplateController.getEmailTemplates(caseItem.Id);
        Test.stopTest();

        // System.assertEquals(testEmailTemplate.Id, emailTemplates[0].emailId);
        // System.assertEquals(testEmailTemplate.Body, emailTemplates[0].emailTemplate);
    }

    @isTest
    private static void testSendAndCloseCase() {
        EmailTemplate testEmailTemplate = [
            SELECT Id, Body
            FROM EmailTemplate
            WHERE DeveloperName = 'unique_test_Email_Template'
        ];
        Case caseItem = Eins_TestDataFactory.createTestCaseWithTemplate(testEmailTemplate.Id);
        insert caseItem;

        Test.startTest();
        Eins_CaseEmailTemplateController.sendAndCloseCase(caseItem.Id, testEmailTemplate.Id);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        Case closedCase = [
            SELECT Id, Status
            FROM Case
            WHERE Id = :caseItem.Id
        ];
        System.assertEquals('Closed', closedCase.Status);
        System.assertEquals(1, invocations);
    }

    @isTest
    private static void testQuickSend() {
        EmailTemplate testEmailTemplate = [
            SELECT Id, Body
            FROM EmailTemplate
            WHERE DeveloperName = 'unique_test_Email_Template'
        ];
        Case caseItem = Eins_TestDataFactory.createTestCaseWithTemplate(testEmailTemplate.Id);
        insert caseItem;

        Test.startTest();
        Eins_CaseEmailTemplateController.quickSend(caseItem.Id, testEmailTemplate.Id);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        Case caseAfterEmail = [
            SELECT Id, Status
            FROM Case
            WHERE Id = :caseItem.Id
        ];
        System.assertNotEquals('Closed', caseAfterEmail.Status);
        System.assertEquals(1, invocations);
    }

    @isTest
    private static void testUpdateTemplateOnCase() {
        EmailTemplate testEmailTemplate = [
            SELECT Id, Body
            FROM EmailTemplate
            WHERE DeveloperName = 'unique_test_Email_Template'
        ];
        Case caseItem = Eins_TestDataFactory.createTestCase();
        insert caseItem;

        Case caseBeforeUpdate = [
            SELECT Id, Einstein_Template_Id__c
            FROM Case
            WHERE Id = :caseItem.Id
        ];
        System.assert(String.isEmpty(caseBeforeUpdate.Einstein_Template_Id__c));

        Test.startTest();
        Eins_CaseEmailTemplateController.updateTemplateOnCase(caseItem.Id, testEmailTemplate.Id);
        Test.stopTest();

        Case caseAfterUpdate = [
            SELECT Id, Einstein_Template_Id__c
            FROM Case
            WHERE Id = :caseItem.Id
        ];
        System.assertEquals(testEmailTemplate.Id, caseAfterUpdate.Einstein_Template_Id__c);
    }
}
