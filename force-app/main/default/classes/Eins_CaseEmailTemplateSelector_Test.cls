@isTest
public class Eins_CaseEmailTemplateSelector_Test {
    @testSetup
    static void makeData() {
        EmailTemplate testEmailTemplate = Eins_TestDataFactory.createEmailTemplate();
        insert testEmailTemplate;
    }

    @isTest
    private static void testCaseEmailTemplateSelector() {
        EmailTemplate testEmailTemplate = [
            SELECT Id
            FROM EmailTemplate
            WHERE DeveloperName = 'unique_test_Email_Template'
        ];
        Case caseItem = Eins_TestDataFactory.createTestCaseWithTemplate(testEmailTemplate.Id);
        insert caseItem;

        List<QuickAction.QuickActionDefaults> defaultsList = new List<QuickAction.QuickActionDefaults>();
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = Test.newsendEmailQuickActionDefaults(caseItem.Id, null);
        defaultsList.add(sendEmailDefaults);

        Test.startTest();
        Eins_CaseEmailTemplateSelector cntl = new Eins_CaseEmailTemplateSelector();
        cntl.onInitDefaults(defaultsList);
        Test.stopTest();

        EmailMessage emailMessage = (EmailMessage) sendEmailDefaults.getTargetSObject();
        System.assertNotEquals(null, emailMessage);
    }
}
