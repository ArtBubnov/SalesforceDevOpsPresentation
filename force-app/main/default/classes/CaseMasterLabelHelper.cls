public with sharing class CaseMasterLabelHelper {
    public static Map<String, Map<String, String>>  getFiledsMap() {
        Map<String, Map<String, String>> result = new Map<String, Map<String, String>>();
        List<ei_EinsFields__mdt> fields = ei_EinsFields__mdt.getAll().values(); 
        for(ei_EinsFields__mdt item : fields) {
            Map <string, string> mdt = new Map <string, string>();
            if (string.isNotEmpty(item.FieldApiName__c) && (string.isNotEmpty(item.FieldValue__c))) {
                mdt.put( item.FieldApiName__c , item.FieldValue__c);
            }
            result.put(item.Label, mdt);
        }
        return result;
    }

    public static void updateMasterLabel(List<Case> caseList, String label) {
        for (Case caseItem : caseList) {
            System.debug('update case: '+ label);
            caseItem.Einstein_Master_Label__c = label.toLowerCase().capitalize();
            refillFields(caseItem);
        }
        System.debug('update case comit: '+ label);
        Database.update(caseList);
    }

    public static void updateMasterLabels(List<Case> caseList, Map<ID, String> labels) {
        for (Case caseItem : caseList) {
            //System.debug('update case: '+ caseItem.Einstein_Master_Label__c);
            if (labels.containsKey(caseItem.Id)) {
                caseItem.Einstein_Master_Label__c = labels.get(caseItem.Id);
                refillFields(caseItem);
            }
        }
        Database.update(caseList);
    }

    private static void refillFields(SObject item) {
        Map<string, Map<string, string>> fields = getFiledsMap();
        string label = (string)item.get('Einstein_Master_Label__c');
        if (fields.size() > 0 && fields.containsKey(label)) {
            Map<string, string> items = fields.get(label);
            for (string key: items.keySet()) {
                item.put(key, items.get(key));
            }
        }
        System.debug('refill');
    }
}