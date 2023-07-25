public without sharing class Eins_UpdatePNRCasePriorityController {

    public static void updateCasePriority(List<Case> beforeCases, Map<Id,Case> afterCases) {
        List<Case> casesWithUpdatedPNR = new List<Case>();
        for (Case caseItem: beforeCases) {
            Case oldCaseItem = afterCases.get(caseItem.Id);
            if (caseItem.PNR__c != oldCaseItem.PNR__c) {
                casesWithUpdatedPNR.add(caseItem);
            }
        }
        CasePriorityHelper.prioritiseCases(casesWithUpdatedPNR);
    }
}
