@isTest
public without sharing class CompApp_COVIDCaseCloserTest {

    @testSetup
    public static void initialiseEnvironment() {
        COVID19_TriggerUtilsTest.initialiseEnvironment();
    }

    @isTest
    public static void testExecution(){

        COVID19_TriggerUtilsTest.TicketCreationParams outbound = new  COVID19_TriggerUtilsTest.TicketCreationParams();
        outbound.outbound = true;
        outbound.departureDate = COVID19_TriggerUtils.POLICY_THRESHOLD_DATE.addDays(-30);

        COVID19_TriggerUtilsTest.TicketCreationParams inbound = new  COVID19_TriggerUtilsTest.TicketCreationParams();
        inbound.outbound = false;
        inbound.departureDate = COVID19_TriggerUtils.POLICY_THRESHOLD_DATE.addDays(30);

        COVID19_TriggerUtilsTest.populateData(outbound, inbound, false, false);


        Id testAccountId = [SELECT Id FROM Account limit 1][0].Id;
        Case customerCase = new Case(
                //Reason_Code__c = [SELECT Id FROM Reason_Code__c WHERE en_Label__c = 'Coronavirus (COVID-19)' LIMIT 1].Id,
                Email__c = 'test@test.com',
                Description = 'Inbound Outbound',
                First_Name__c = 'FirstName',
                Last_Name__c = 'LastName',
                Converted_From_Site__c = true,
                Origin = 'Web',
                Website_Language__c = 'en',
                Subject = 'Coronavirus eVoucher Request',
                SuppliedEmail = 'test@test.com',
                PNR__c = 'ABC123',
                SuppliedName = 'LastName FirstName',
                CreatedById = COVID19_TriggerUtils.EMERGENCY_GUEST_USER_ID,
                Claim_Date_COVID__c = DateTime.newInstance(COVID_Logic_Rules__c.getOrgDefaults().Policy_Threshold_Date__c.addDays(-8), Time.newInstance(3, 0, 0, 0))
        );

/*
        Test.startTest();


        List<User> usr = [SELECT Name FROM USER WHERE ID = : COVID19_TriggerUtils.EMERGENCY_GUEST_USER_ID];
        System.runAs(usr[0]) {
            insert customerCase;
        }

        Utility__c ut = new Utility__c();
        ut.PNR__c = 'ABC123';
        ut.Case__c = customerCase.Id;
        insert ut;

        List<Compensation__c> compensations = [SELECT Id, Integration_Status__c, PNR__c FROM   Compensation__c];

        List<Utility__c> utilities = [SELECT Id, Name, Case__c, PNR__c FROM Utility__c];

        List<CronTrigger> crons = [SELECT Id,CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'COVID Case Closer'];

        Database.executeBatch(new CompApp_COVIDCaseCloser(), 200);
        Test.stopTest();

        List<Case> cases = [SELECT Id, Incomplete_Voucher_Set__c FROM Case WHERE Status = 'Closed'];
*/
    }
}