public without sharing class CasePriorityHelper {
    private static Map<String, String> casesWithLoyaltyStatus = new Map<String, String>();

    public static List<Case> prioritiseCases(List<Case> cases) {
        getLoyaltyStatuses(cases);
        for (Case caseItem : cases) {
            if (caseItem.Status != 'Closed') {
                if (caseItem.Departure_Date__c != null) {
                    if (String.isNotBlank(caseItem.PNR__c)) {
                        setCaseDatePriority(caseItem);
                    }
                    if (0 < Date.today().daysBetween(caseItem.Departure_Date__c)) {
                        setCasePastDatePriority(caseItem);
                    }
                } else {
                    setCaseNoDatePriority(caseItem);
                }
                highPriority(caseItem);
            }
        }
        return cases;
    }

    private static void getLoyaltyStatuses(List<Case> cases) {
        Map<String, String> contactsWithLoyaltyStatus = new Map<String, String>();
        Set<Id> contactIds = new Set<Id>();
        for (Case caseItem : cases) {
            contactIds.add(caseItem.ContactId);
        }
        for (Contact contactItem : [SELECT Id, Loyalty_Status__c FROM Contact WHERE Id IN :contactIds]) {
            contactsWithLoyaltyStatus.put(contactItem.Id, contactItem.Loyalty_Status__c);
        }
        for (Case caseItem : cases) {
            if (contactsWithLoyaltyStatus.containsKey(caseItem.ContactId)) {
                if (String.isNotBlank(contactsWithLoyaltyStatus.get(caseItem.ContactId))) {
                    casesWithLoyaltyStatus.put(caseItem.Id, contactsWithLoyaltyStatus.get(caseItem.ContactId));
                }
            }
        }
    }

    private static void setCaseDatePriority(Case caseItem) {
        if ((0 <= Date.today().daysBetween(caseItem.Departure_Date__c)) && (Date.today().daysBetween(caseItem.Departure_Date__c) < 3)) {
            caseItem.Priority = 'High';
        } else if ((2 < Date.today().daysBetween(caseItem.Departure_Date__c)) && (Date.today().daysBetween(caseItem.Departure_Date__c) <= 7)) {
            travelMore3Less7(caseItem);
        } else {
            travelMore7(caseItem);
        }
    }

    private static void travelMore3Less7(Case caseItem) {
        caseItem.Priority = 'High';
        if (casesWithLoyaltyStatus.containsKey(caseItem.Id)) {
            if (casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Classique') ||
                casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Avantage') ||
                !casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Carte')) {
                    caseItem.Priority = 'Medium';
            }
        } else {
            caseItem.Priority = 'Medium';
        }
        if (caseItem.Return_Date__c != null) {
            if ((0 <= Date.today().daysBetween(caseItem.Return_Date__c)) && (Date.today().daysBetween(caseItem.Return_Date__c) < 3)) {
                caseItem.Priority = 'High';
            }
        }
    }

    private static void travelMore7(Case caseItem) {
        caseItem.Priority = 'High';
        if (casesWithLoyaltyStatus.containsKey(caseItem.Id)) {
            if (casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Classique') ||
                casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Avantage') ||
                casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Blanche')) {
                    caseItem.Priority = 'Medium';
            }
            if (!casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Carte')) {
                caseItem.Priority = 'Low';
            }
        } else {
            caseItem.Priority = 'Low';
        }

        if (caseItem.Return_Date__c != null) {
            if ((0 <= Date.today().daysBetween(caseItem.Return_Date__c)) && (Date.today().daysBetween(caseItem.Return_Date__c) < 3)) {
                caseItem.Priority = 'High';
            }
            if ((2 < Date.today().daysBetween(caseItem.Return_Date__c)) && (Date.today().daysBetween(caseItem.Return_Date__c) <= 7)) {
                travelMore3Less7(caseItem);
            }
        }
    }

    private static void setCaseNoDatePriority(Case caseItem) {
        caseItem.Priority = 'Medium';
        if (casesWithLoyaltyStatus.containsKey(caseItem.Id)) {
            if (casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Classique') ||
                casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Avantage') ||
                !casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Carte')) {
                    caseItem.Priority = 'Low';
            }
        } else {
            caseItem.Priority = 'Low';
        }
    }

    private static void setCasePastDatePriority(Case caseItem) {
        caseItem.Priority = 'Medium';
        if (casesWithLoyaltyStatus.containsKey(caseItem.Id)) {
            if (casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Classique') ||
                casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Avantage') ||
                !casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Carte')) {
                    caseItem.Priority = 'Low';
            }
        } else {
            caseItem.Priority = 'Low';
        }
    }

    private static void highPriority(Case caseItem) {
        if (casesWithLoyaltyStatus.containsKey(caseItem.Id)) {
            if (casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('Elite') ||
                casesWithLoyaltyStatus.get(caseItem.Id).containsIgnoreCase('VIP')) {
                    caseItem.Priority = 'High';
            }
        }

        if (String.isNotBlank(caseItem.Topic__c) && caseItem.Topic__c.containsIgnoreCase('Urgent')) {
            caseItem.Priority = 'High';
            if (caseItem.Departure_Date__c != null) {
                if (0 < Date.today().daysBetween(caseItem.Departure_Date__c)) {
                    if (caseItem.Return_Date__c != null) {
                        if (0 < Date.today().daysBetween(caseItem.Return_Date__c)) {
                            caseItem.Priority = 'Medium';
                        }
                    } else {
                        caseItem.Priority = 'Medium';
                    }
                }
            }
        }
    }
}