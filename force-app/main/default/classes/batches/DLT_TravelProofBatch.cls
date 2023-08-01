public inherited sharing class DLT_TravelProofBatch implements Database.Batchable<SObject>, Schedulable {

    private String caseStatus = DLT_CaseConstants.STATUS_NEW;
    private String caseCategory = DLT_CaseConstants.CATEGORY_DOCUMENT_REQUEST;
    private String caseTopic = DLT_CaseConstants.TOPIC_TRAVEL_PROOF;
    private Set<String> whatIsTheQuestrions = new Set<String>{
        DLT_CaseConstants.WHAT_IS_THE_QUESTION_PROOF_OF_CANCELATION,
        DLT_CaseConstants.WHAT_IS_THE_QUESTION_PROOF_OF_DISRUPTION,
        DLT_CaseConstants.WHAT_IS_THE_QUESTION_PROOF_OF_TRAVEL
    };

    // Schedulable
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new DLT_TravelProofBatch(), 25);
    }

    // Batchable
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id,'
                + ' CaseNumber,'
                + ' SuppliedEmail,'
                + ' Proof_of_Travel_Sent__c,'
                + ' What_Is_The_Question__c,'
                + ' Account.Salutation,'
                + ' Account.LastName,'
                + ' Account.PersonEmail,'
                + ' Train__r.Cancelled__c'
            + ' FROM Case'
            + ' WHERE Status = :caseStatus'
                + ' AND Category__c = :caseCategory'
                + ' AND Topic__c = :caseTopic'
                + ' AND What_Is_The_Question__c IN :whatIsTheQuestrions'
                + ' AND Proof_of_Travel_Sent__c = NULL'
                + ' AND Train__c != NULL'
                + ' AND TCN__c != NULL'
        );
    }

    public void execute(Database.BatchableContext bc, List<Case> scope) {
        sendTravelProofDocumentAndCloseCase(scope);
    }

    public void finish(Database.BatchableContext bc) {
    }


    private static void sendTravelProofDocumentAndCloseCase(List<Case> scope) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<ContentDocumentLink> caseFiles = new List<ContentDocumentLink>();
        Map<Id, ContentVersion> caseIdToContentVersionMap = new Map<Id, ContentVersion>();
        Map<Id, Id> contentVersionIdToCaseId = new Map<Id, Id>();
        OrgWideEmailAddress owea = new OrgWideEmailAddress();

        if(!Test.isRunningTest()){
            owea = [
                SELECT Id
                FROM OrgWideEmailAddress
                WHERE Address = :DLT_Settings__c.getInstance().PDF_Travel_Proof_From_Email__c
                LIMIT 1
            ];
        }

        for (Case c : scope) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
            Boolean isProofOfTravel = c.What_Is_The_Question__c == DLT_CaseConstants.WHAT_IS_THE_QUESTION_PROOF_OF_TRAVEL
                && c.Train__r.Cancelled__c != true;

            message.setOrgWideEmailAddressId(owea.Id);
            message.optOutPolicy = 'FILTER';
            message.toAddresses = new List<String>{c.SuppliedEmail != null ? c.SuppliedEmail : c.Account.PersonEmail};

            if (message.toAddresses.isEmpty()) { continue; }

            message.subject = isProofOfTravel ? System.Label.PDF_Body_Email_Justificatory : System.Label.PDF_Subject_Email_Delay_Proof;
            message.htmlbody = System.Label.PDF_Justif_Label_Title + ' ' + c.Account.Salutation+ ' ' + c.Account.LastName
                + ',' + System.Label.PDF_Justif_label_Body + System.Label.PDF_Justif_Label_Footer;

            PageReference pageRef = Page.PDF_Generator_Travel_Proof;

            pageRef.getParameters().put(DLT_PDF_Constants.PARAM_CASE_NUMBER, c.CaseNumber);

            Blob pdfContent = !Test.isRunningTest() ? pageRef.getContent() : Blob.valueOf('Unit Test Attachment Body');

            String fileName = isProofOfTravel
                ? System.Label.PDF_Justif_Proof_of_Journey + DLT_PDF_Constants.FILE_EXT_PDF
                : System.Label.PDF_Justif_Proof_of_Delay + DLT_PDF_Constants.FILE_EXT_PDF;

            emailAttachment.setFileName(fileName);
            emailAttachment.setBody(pdfContent);

            message.setFileAttachments(new Messaging.EmailFileAttachment[]{emailAttachment});

            messages.add(message);

            ContentVersion conVer = new ContentVersion();
            conVer.VersionData = pdfContent;
            conVer.ContentLocation = 'S';
            conVer.PathOnClient = fileName;
            conVer.Title = fileName;

            caseIdToContentVersionMap.put(c.Id, conVer);

            c.Proof_of_Travel_Sent__c = Date.today();
            c.Status = DLT_CaseConstants.STATUS_CLOSED;
        }

        if (!Test.isRunningTest()) { Messaging.sendEmail(messages); }

        if (!caseIdToContentVersionMap.isEmpty()) {
            insert caseIdToContentVersionMap.values();

            for (Id caseId : caseIdToContentVersionMap.keySet()) {
                contentVersionIdToCaseId.put(caseIdToContentVersionMap.get(caseId).Id, caseId);
            }

            for (ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN :contentVersionIdToCaseId.keySet()]) {
                caseFiles.add(new ContentDocumentLink(
                    ContentDocumentId = cv.ContentDocumentId,
                    LinkedEntityId = contentVersionIdToCaseId.get(cv.Id)
                ));
            }

            insert caseFiles;
        }

        DLT_CaseTriggerHandler.isDisabled = true;

        update scope;
    }
}