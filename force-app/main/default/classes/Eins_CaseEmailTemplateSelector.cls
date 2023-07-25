global without sharing class Eins_CaseEmailTemplateSelector implements QuickAction.QuickActionDefaultsHandler {
    global Eins_CaseEmailTemplateSelector() { }

    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaultsList) {
        for (Integer j = 0; j < defaultsList.size(); j++) {
            QuickAction.QuickActionDefaults defaults = defaultsList.get(j);
            if (
                defaults instanceof QuickAction.SendEmailQuickActionDefaults &&
                defaults.getTargetSObject().getSObjectType() == EmailMessage.sObjectType &&
                defaults.getActionType().equals('SendEmail')
            ) {
                String actionName = defaults.getActionName();
                Id contextId = defaults.getContextId();

                // check if the related object is a Case
                // and process it in the same way no matter if it's 
                // a `SendEmail`, `Reply`, or `Reply All` action
                if (
                    (actionName.equals('Case.Send_Email') ||
                     actionName.equals('EmailMessage._Reply') ||
                     actionName.equals('EmailMessage._ReplyAll')
                    ) &&
                    String.isNotEmpty(contextId) &&
                    contextId.getSobjectType() == Case.sObjectType
                ) {
                    applySendEmailDefaultsForCase((QuickAction.SendEmailQuickActionDefaults) defaults);
                    break;
                }
            }
        }
    }

    private void applySendEmailDefaultsForCase(QuickAction.SendEmailQuickActionDefaults sendEmailDefaults) {
        Case caseItem = [
            SELECT Id, Einstein_Template_Id__c
            FROM Case
            WHERE Id = :sendEmailDefaults.getContextId()
        ];

        // implement some logic to obtain the correct `emailTemplateId` && `validatedFromAddress`,
        // based on the Case record fields (preferably using a Custom Metadata Type)

        sendEmailDefaults.setTemplateId(caseItem.Einstein_Template_Id__c);
        sendEmailDefaults.setInsertTemplateBody(true);
        sendEmailDefaults.setIgnoreTemplateSubject(false);

        EmailMessage emailMessage = (EmailMessage) sendEmailDefaults.getTargetSObject();
        // emailMessage.ValidatedFromAddress = validatedFromAddress;
        // emailMessage.ValidatedFromAddress = 'contactus@eurostar.com';
    }
}