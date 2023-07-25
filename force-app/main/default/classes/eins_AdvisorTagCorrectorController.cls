public with sharing class eins_AdvisorTagCorrectorController {
    

    private static Case selectCase(Id recordId)  {
        Case result = new Case();
        List<Case> caseList = [
                SELECT Id,  Einstein_Master_Label__c
                FROM Case
                WHERE Id =:recordId
                LIMIT 1
            ];
        if (!caseList.isEmpty()) {
            result = caseList[0];
        }
        return result;
    }
   

    @AuraEnabled(cacheable=true)
    public static TagWrapper getCurrentLabel(Id recordId) {
       TagWrapper tagWrapper = new TagWrapper();
        try {
                Case record = selectCase(recordId);

                tagWrapper.currentTag = string.isNotBlank(record.Einstein_Master_Label__c) ? record.Einstein_Master_Label__c.toLowerCase().capitalize()
                                                                                            : 'No intent' ;
                
                Map<string, Map<string, string>> fields = CaseMasterLabelHelper.getFiledsMap();
                for (string key : fields.keySet()) {
                    tagWrapper.tags.add(key.toLowerCase().capitalize());
                }
                system.debug('Wrapper: '+ tagWrapper);
            return tagWrapper;
        } catch (Exception e) {
            System.debug('Error:' + e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateMasterLabel(Id recordId, String label){
        try {
            System.debug('Update master label start' + label);
            List<Case> cases = new List<Case>();
            cases.add(selectCase(recordId));
            Map<ID, string> labels = new Map<Id, string> ();
            labels.put(recordId, label);
            System.debug('Update master label number records: '+ cases.size());
            CaseMasterLabelHelper.updateMasterLabels(cases, labels);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class TagWrapper {
        @AuraEnabled
        public String currentTag;
        @AuraEnabled
        public List<String> tags = new List<String>();

        public TagWrapper(){

        }

        public TagWrapper(String caseTag) {
            this.currentTag = caseTag;
            this.tags = new List<string>();
        }
    }
}
