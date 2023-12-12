@IsTest
private class CaseServiceControllerTest {

    private static CaseServiceController.SubmitDetails createArgs() {
        cu_Utils.PnrDetails pnrItem = new cu_Utils.PnrDetails(
            'HFG230', false, S3PassengerAPIService.HOTEL_ONLY, false, false, false, false, false, '', '', false
        );
        CaseService.GuestDetails guestDetails = new CaseService.GuestDetails(
            'email@email.com', 'firstName', 'lastName', 'message', '+375 29 374-65-56', '2028-10-25',
            'iban', 'bicOrSwift', 'accountNumber', 'sortCode', 'paypal@mail.com', '', 'language',
            '', '', 'Praise', '', ''
        );
        Boolean isOnOurApp = false;
        Boolean checkOnExisting = false;
        CaseServiceController.SubmitDetails args = new CaseServiceController.SubmitDetails(
            pnrItem,
            guestDetails,
            CaseService.NEUTRAL_TONE,
            'station',
            'errorMessage',
            isOnOurApp,
            checkOnExisting,
            'topic',
            'topicApiName',
            'whatIsTheQuestion'
        );
        return args;
    }

    @IsTest
    static void updateCasesTest() {
        Test.startTest();
        CaseServiceController.SubmitDetails args = createArgs();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesB = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
        ];

        CaseServiceController.updateCases(feedbackCasesB, 'Comment', 'Complaint');
        Test.stopTest();
        List<Case> feedbackCasesA = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
            WHERE Status = 'Case Comment Received'
        ];

        System.assertEquals(1, feedbackCasesA.size());
    }

    @IsTest
    static void updateCasesPNRTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));
        List<Case> feedbackCasesBefore = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
            WHERE PNR__c = :args.pnrItem.pnr
        ];
        System.assertEquals(1, feedbackCasesBefore.size());

        Test.startTest();
        CaseServiceController.updateCasesByPNR(args.pnrItem.pnr, 'Comment', 'Praise');
        Test.stopTest();
        List<Case> feedbackCasesAfter = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = 'Praise'
        ];

        System.assertEquals(1, feedbackCasesAfter.size());
    }

    @IsTest
    static void createFeedbackCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesN = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.NEUTRAL_TONE
        ];

        args.buttonLabel = CaseService.PRAISE_TONE;

        Test.startTest();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesP = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.PRAISE_TONE
        ];
    }

    @IsTest
    static void createFeedbackCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesN = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.NEUTRAL_TONE
        ];

        args.buttonLabel = CaseService.COMPLAINT_TONE;

        Test.startTest();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));
        Test.stopTest();


        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.COMPLAINT_TONE
        ];
    }

    @IsTest
    static void createAddSomethingCaseHotelTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.REQUEST_ELSE;

        Test.startTest();
        CaseServiceController.submitCase('createAddSomethingCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesS = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Subject LIKE 'Standalone hotel add on request%'
        ];
        System.assertEquals(1, feedbackCasesS.size());
    }
    
    @IsTest
    static void createAddSomethingCasePackageTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        args.buttonLabel = CaseService.REQUEST_MEALS;

        Test.startTest();
        CaseServiceController.submitCase('createAddSomethingCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesM = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Subject LIKE 'Package add on request%'
        ];
        System.assertEquals(1, feedbackCasesM.size());
    }
    
    @IsTest
    static void createAddSomethingCaseTrainTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.buttonLabel = CaseService.REQUEST_ELSE;

        Test.startTest();
        CaseServiceController.submitCase('createAddSomethingCase', JSON.serialize(args));
        Test.stopTest();


        List<Case> feedbackCasesI = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Initial_Reason_For_Contact__c = 'Buy or Book'
        ];

        System.assertEquals(1, feedbackCasesI.size());
    }

    @IsTest
    static void createReportAProblemFeedbackCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        CaseServiceController.submitCase('createReportAProblemFeedbackCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesN = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Topic__c = 'General feedback'
        ];
        System.assertEquals(1, feedbackCasesN.size());
    }

    @IsTest
    static void createReportAnErrorCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_MAKING_A_BOOKING;

        Test.startTest();
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createReportAnErrorCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_MAKING_PAYMENT;

        Test.startTest();
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createReportAnErrorCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_EXCHANGING_BOOKING;

        Test.startTest();
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createReportAnErrorCaseTest4() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_CANCELLING_A_BOOKING;

        Test.startTest();
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }


    @IsTest
    static void createReportAnErrorCaseTest5() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_MAKING_A_BOOKING;

       Test.startTest();
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createReportAnErrorCaseTest6() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_ACCESSING_BOOKING;

       Test.startTest();
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }


    @IsTest
    static void createSpecialAssistanceCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.SPECIAL_ASSISTANCE_DOGS;

        Test.startTest();
        CaseServiceController.submitCase('createSpecialAssistanceCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createClubEurostarCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_ACCOUNT_QUERY;

        Test.startTest();
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createClubEurostarCaseTes2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_JOURNEY_OR_MISSING_POINTS;

        Test.startTest();
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createClubEurostarCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_CHANGES_PERSONAL_INFO;

        Test.startTest();
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createClubEurostarCaseTest4() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_TROUBLE_ACCESSING_ACC;

        Test.startTest();
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    
    @IsTest
    static void createMakeBookingCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = 'Kent';

        Test.startTest();
        CaseServiceController.submitCase('createMakeBookingCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createMakeBookingCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = 'Lyon';

        Test.startTest();
        CaseServiceController.submitCase('createMakeBookingCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createMakeBookingCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = 'Somewhere else';


        Test.startTest();
        CaseServiceController.submitCase('createMakeBookingCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }


    @IsTest
    static void createTravelQuestionCaseTestTimetable() {
        CaseServiceController.SubmitDetails args = createArgs();
        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_TIMETABLE;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createTravelQuestionCaseTestDestinations() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_DESTINATIONS;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createTravelQuestionCaseTestArrivals() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_LIVE_DEPARTURES_ARRIVALS;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createTravelQuestionCaseTestConnecting() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_CONNECTING_TRAVEL;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        // System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createTravelQuestionCaseTestTickets() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_GETTING_TICKETS;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createTicketConditionQuestionCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_TS_AND_CS;

        Test.startTest();
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createTicketConditionQuestionCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_EXCHANGES;

        Test.startTest();
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createTicketConditionQuestionCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_CANCELLATIONS_REFUNDS;

        Test.startTest();
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createTicketConditionQuestionCaseTest4() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_TRANSFER;

        Test.startTest();
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createStationsQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = cu_Utils.GENERIC;
        args.topic = cu_Utils.STATION_INFORMATION;
        args.whatIsTheQuestion = cu_Utils.AACHEN;

        Test.startTest();
        CaseServiceController.submitCase('createStationsQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
         System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createOnboardQuestionCaseTestSeating() {
        CaseServiceController.SubmitDetails args = createArgs();
        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_SEATING;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createOnboardQuestionCaseTestCatering() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_CATERING;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createOnboardQuestionCaseTestTravel() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_TRAVEL_CLASSES;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createOnboardQuestionCaseTestWifi() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_WIFI;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    
    @IsTest
    static void createOnboardQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_ELSE;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createLugageQuestionCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_PROHIBITTED_LUGGAGE;

        Test.startTest();
        CaseServiceController.submitCase('createLugageQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createLugageQuestionCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_LUGGAGE_ALLOWANCE;

        Test.startTest();
        CaseServiceController.submitCase('createLugageQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createLugageQuestionCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_LUGGAGE_INFO;

        Test.startTest();
        CaseServiceController.submitCase('createLugageQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createrRedLuggageQuestionCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = System.Label.cu_Luggage_Information;

        Test.startTest();
        CaseServiceController.submitCase('createRedLugageQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Topic__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
        System.assertEquals(CaseService.CASE_TOPIC_LUGGAGE, feedbackCasesC[0].Topic__c);
    }

    @IsTest
    static void createrRedLuggageQuestionCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = System.Label.cu_TravelingWithBikes;

        Test.startTest();
        CaseServiceController.submitCase('createRedLugageQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Topic__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
        System.assertEquals(CaseService.CASE_TOPIC_BIKE, feedbackCasesC[0].Topic__c);
    }

    @IsTest
    static void createrRedLuggageQuestionCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = System.Label.cu_LostProperty;

        Test.startTest();
        CaseServiceController.submitCase('createRedLugageQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Topic__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
        System.assertEquals(CaseService.CASE_TOPIC_LUGGAGE, feedbackCasesC[0].Topic__c);
    }

    @IsTest
    static void createDisruptionQuestionCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_EXPENSES;
        args.station = 'Disney';

        Test.startTest();
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDisruptionQuestionCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.buttonLabel = CaseService.QUESTION_DELAY_COMPENSATION;
        args.station = 'Amsterdam';

        Test.startTest();
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDisruptionQuestionCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.buttonLabel = CaseService.QUESTION_CANCELLATION_COMPENSATION;
        args.station = 'Ski';

        Test.startTest();
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDisruptionQuestionCaseTest4() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.buttonLabel = CaseService.QUESTION_CORONAVIRUS;
        args.station = 'London';

        Test.startTest();
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createWebsiteQuestionCaseTestFinding() {
        CaseServiceController.SubmitDetails args = createArgs();
        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_HELP_FINDING;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createWebsiteQuestionCaseTestDoing() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_HELP_DOING;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createWebsiteQuestionCaseTestOnline() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_ONLINE_HELP;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createWebsiteQuestionCaseTestProblem() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_REPORT_PROBLEM;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createWebsiteQuestionCaseTestPassword() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_RESET_PASSWORD;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocsQuestionCaseTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_NAMES_AND_OTHER_DETAILS;

        Test.startTest();
        CaseServiceController.submitCase('createDocsQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocsQuestionCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_WHAT_DO_I_NEED_TO_TRAVEL;

        Test.startTest();
        CaseServiceController.submitCase('createDocsQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocsQuestionCaseTest3() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_ELSE;

        Test.startTest();
        CaseServiceController.submitCase('createDocsQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createVoucherQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel =  System.Label.cu_IWouldLikeToPurchaseGiftVouchers;

        Test.startTest();
        CaseServiceController.submitCase('createVoucherQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createElseQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        CaseServiceController.submitCase('createElseQuestionCase', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createCaseTrainExchangeQueueTest1() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createCaseTrainExchangeQueueTest2() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isChangeableOnline = true;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createCaseTrainDisruptionExchangeQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createCaseTrainCancelRefundQueueTest1() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;

        Test.startTest();
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createCaseTrainCancelRefundQueueTest2() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;

        Test.startTest();
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createCaseTrainDisruptionRefundQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = S3PassengerAPIService.NO_REFUND;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = S3PassengerAPIService.REFUND_TO_VOUCHER;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = S3PassengerAPIService.FULL_REFUND;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createCaseTrainDisruptionRefundQueue', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingExchangeQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingDisruptionExchangeQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.isFree = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingCancelRefundQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingDisruptionRefundQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createDocRequestCaseInvoiceCreditTest1() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_Invoices';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseInvoiceCreditTest2() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_CreditNotes';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseProFormaTest() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_ProForma';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseHistoryTest2() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_History';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseProofTest1() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_ProofOfTravel';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseProofTest2() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_ProofOfDisruption';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseProofTest3() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_ProofOfCancellation';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseAdditionalTest1() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_BookingReceipt';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseAdditionalTest2() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_AdditionalCharges';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocRequestCaseAdditionalTest3() {
        CaseServiceController.SubmitDetails args = createArgs();

        args.topicAPIName = 'cu_ConfirmationOfBooking';

        Test.startTest();
        CaseServiceController.submitCase('createDocRequestCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createB2BBookingCaseTest() {

        String argumentString = getArgumentsString();

        Test.startTest();
        CaseServiceController.submitCase('createB2BBookingCase', argumentString);
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id
            FROM Case
        ];

        System.assertEquals(1, feedbackCasesC.size());
    }

    private static String getArgumentsString(){
        return '{"pnrItem":{"pnr":"","isDisrupted":false,"bookingType":"","isFree":false,"isRefundable":false,'+
        '"isExchangable":false,"isChangeableOnline":false,"addInfo":false,"cancelOption":"","error":""},'+
        '"guestDetails":{"email":"email@email.comcom","firstName":"first name","lastName":"last name","message":"comment","phone":"12345678",'+
        '"dateOfTravel":"2020-05-24","destination":"Aime-La-Plagne","selectedCountry":"France","checkOnExisting":true,"language":""},'+
        '"buttonLabel":"France","origin":"St Pancras International","destination":"Aime-La-Plagne","isOnOurApp":false,'+
        '"checkOnExisting":true,"topic":"","classService":"Business Premier","companyName":"company name","dateOfTravel":"2020-05-24",'+
        '"dateOfReturn":"2020-05-25","timeOfTravel":"09:00 - 11:00","timeOfReturn":"11:00 - 13:00","assistanceCatering":false,'+
        '"assistanceLuggage":false,"assistanceBranding":true,"assistanceExperience":true,"assistanceCarriage":false,"assistanceHalfcharter":false,'+
        '"assistanceCharter":false,"adultPassengers":"2","childrenPassengers":"3","infantsPassengers":"4"}';
    }

}