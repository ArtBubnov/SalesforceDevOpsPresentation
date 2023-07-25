public with sharing class Eins_CaseEmailTemplateController {

    public static List<OrgWideEmailAddress> fromAddress = new List<OrgWideEmailAddress>();

    private static List<string> getTemplateNamesFromSettings(string label, string language) {
        language = string.isNotBlank(language)? language : 'en-gb';
        System.debug('Template Mapping : ' + language);
        System.debug('Template Mapping for: ' + label);
        List<string> names = new List<string> (); 
        if (string.isNotBlank(label)) {
            List<eins_MasterLabelTemplate__mdt> masterLabel_settings = [SELECT id, label, TemplageTitle__c,Template_Language__c 
                                                                            FROM eins_MasterLabelTemplate__mdt 
                                                                        where label = :label 
                                                                        and Template_Language__c = :language];
            for (eins_MasterLabelTemplate__mdt masterLabel : masterLabel_settings){
                names.add(masterLabel.TemplageTitle__c);
            }
        }
        return names;

    }

    private static Case get_caseItem(Id recordId) {
        Case caseItem = [
            SELECT Id, ContactId, ContactEmail, Einstein_Template_Id__c, Einstein_Master_Label__c, Language_Code__c
            FROM Case
            WHERE Id = :recordId
            LIMIT 1
        ];
        return caseItem;
    }


    @AuraEnabled(cacheable=true)
    public static List<EmailTemplateWrapper> getEmailTemplates(Id recordId) {


        List<EmailTemplateWrapper> emailTemplates = new List<EmailTemplateWrapper>();
        try {
            Case caseItem = get_caseItem(recordId);

            

            if (caseItem != null ) {
                List<string> names = getTemplateNamesFromSettings(caseItem.Einstein_Master_Label__c, caseItem.Language_Code__c);
                System.debug('names: '+ names);
                if ( names.size() > 0) {
                    List<EmailTemplate> testEmailTemplates = [
                        SELECT Id, HtmlValue, Body
                        FROM EmailTemplate
                        WHERE  name in :names

                    ];
                    for (EmailTemplate testEmailTemplate : testEmailTemplates) {

                        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(testEmailTemplate.id, null, recordId);
                        emailTemplates.add(
                            new EmailTemplateWrapper(mail.HtmlBody, testEmailTemplate.Id, mail.PlainTextBody)
                        );
                    }
                        
                }
            }
            System.debug('emailTemplates: ' +emailTemplates);
            return emailTemplates;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void sendAndCloseCase(Id recordId, Id templateId) {
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        if (String.isNotBlank(templateId)) {
            Messaging.SingleEmailMessage mailMessage = createEmail(recordId, templateId);
            emailMessages.add(mailMessage);
        }
        try {
            if (!emailMessages.isEmpty()) {
                EmailServiceController.sendEmails(emailMessages);
            }
            Case caseItem = new Case(
                Id = recordId,
                Status = 'Closed'
            );
            update caseItem;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void quickSend(Id recordId, Id templateId) {
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        try {
            if (String.isNotBlank(templateId)) {
                Messaging.SingleEmailMessage mailMessage = createEmail(recordId, templateId);
                emailMessages.add(mailMessage);
            }

            if (!emailMessages.isEmpty()) {
                EmailServiceController.sendEmails(emailMessages);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateTemplateOnCase(Id recordId, Id templateId) {
        try {
            if (String.isNotBlank(templateId)) {
                Case caseItem = new Case(
                    Id = recordId,
                    Einstein_Template_Id__c = templateId
                );
                update caseItem;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Messaging.SingleEmailMessage createEmail(Id recordId, Id templateId) {
        Case caseItem = get_caseItem(recordId);
        if (fromAddress.isEmpty()) {
            fromAddress = [
                SELECT Id, Address, DisplayName
                FROM OrgWideEmailAddress
                WHERE DisplayName = 'Eurostar Customer Care'
                LIMIT 1
            ];
        }
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setTargetObjectId(caseItem.ContactId);
        emailMessage.setTemplateId(templateId);
        if (Test.isRunningTest()) {
            fromAddress = new List<OrgWideEmailAddress>();
        }
        if (!fromAddress.isEmpty()) {
            emailMessage.setOrgWideEmailAddressId(fromAddress[0].Id);
        }

        emailMessage.setToAddresses(new String[] { caseItem.ContactEmail.trim() });

        return emailMessage;
    }

    public class EmailTemplateWrapper {
        @AuraEnabled
        public String emailTemplate;
        @AuraEnabled
        public String emailId;
        @AuraEnabled
        public String emailTemplatePlain;

        public EmailTemplateWrapper(String emailTemplate, String emailId, String emailTemplatePlain) {
            this.emailTemplate = emailTemplate;
            this.emailId = emailId;
            this.emailTemplatePlain = emailTemplatePlain;
        }
    }
}