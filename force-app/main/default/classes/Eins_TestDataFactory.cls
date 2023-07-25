@isTest
public class Eins_TestDataFactory {
    public static Case createTestCaseWithTemplate(String templateId) {
        Case caseItem = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Status = 'In Progress',
            SuppliedEmail = 'test@test.com',
            Einstein_Template_Id__c = templateId
        );

        return caseItem;
    }

    public static Case createTestCase() {
        Case caseItem = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Status = 'In Progress',
            SuppliedEmail = 'test@test.com'
        );

        return caseItem;
    }

    public static Case createIntentTestCase( string description) {
        Case caseItem = createTestCase();
        caseItem.Description = description;
        
        return caseItem;
    }

    public static Contact createTestContactWithLoyaltyStatus(String loyaltyStatus) {
        Contact contactItem = new Contact(
            FirstName = 'Name',
            LastName = 'Surname',
            Email = 'test@email.com',
            Loyalty_Status__c = loyaltyStatus
        );

        return contactItem;
    }

    public static EmailTemplate createEmailTemplate() {
        EmailTemplate testEmailTemplate = new EmailTemplate();
        testEmailTemplate.isActive = true;
        testEmailTemplate.Name = 'Test Email Template';
        testEmailTemplate.DeveloperName = 'unique_test_Email_Template';
        testEmailTemplate.TemplateType = 'text';
        testEmailTemplate.FolderId = UserInfo.getUserId();
        testEmailTemplate.Subject = 'Test Subject';

        return testEmailTemplate;
    }
}
