echo -e "--- Get destructive changes script executions start ---\n\n\n"


echo -e "--- Step 1. Define destructive changes ---\n"

DIFF_BRANCH="origin/qa"
mapfile -t files_array < <( git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default )


COUNT=0
ARRAY_LEN=${#files_array[@]}
LOOP_LEN=$( expr $ARRAY_LEN - 1)
SF_COMMAND_META_STRING=""

while [ $COUNT -le $LOOP_LEN ]
do
    CURRENT_ARRAY_NODE=${files_array[$COUNT]}
    SF_COMMAND_META_STRING=${SF_COMMAND_META_STRING}"--source-dir "'"'${CURRENT_ARRAY_NODE}'" '
    COUNT=$(( $COUNT +1))

done

echo "ENV_DESTRUCTIVE_DIFF=$SF_COMMAND_META_STRING" >> "$GITHUB_ENV"


echo -e "\nStep 1 execution result"
echo "destructive changes list is: "
echo $SF_COMMAND_META_STRING
echo -e "\n--- Step 1 execution is finished ---"




echo "----------TEST---------------"

#sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default/objects/Account/fields/Business_Account__c.field-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default/objects/Account/fields/Business_Account__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Contact_Number__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Customer_Email__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Customer_Opt_In_Type__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/DELTA_Loyalty_Member__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Delta_Loyalty_Tier__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/E4A_Newsletter_Opt_In__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Group_Opt__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Is_Loyalty_Member_Exist__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Loyalty_Integration__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Loyalty_Opt_In__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/New_Opt_in_Date__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Old_Opt_in_Date__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Preferred_Language__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Role__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/SVOC_Integration__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/fields/Sensitive__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account/validationRules/Salutation_Validation.validationRule-meta.xml" --source-dir "force-app/main/default/objects/Account/webLinks/Create_New_Client.webLink-meta.xml" --source-dir "force-app/main/default/objects/Account_POS__c/fields/Account__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account_POS__c/fields/POS_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account_POS__c/fields/POS__c.field-meta.xml" --source-dir "force-app/main/default/objects/Account_POS__c/listViews/All.listView-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Action_Done_With__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Action__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Attendees_for_the_meeting__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Cancelled__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Contact_Number__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Number_of_Persons__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Preferred_Language__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Reference_Number__c.field-meta.xml" --source-dir "force-app/main/default/objects/Activity/fields/Target_Group__c.field-meta.xml" --source-dir "force-app/main/default/objects/Allocation_Booking__c/fields/Business_Account_Entity__c.field-meta.xml" --source-dir "force-app/main/default/objects/Allocation_Booking__c/fields/Business_Account__c.field-meta.xml" --source-dir "force-app/main/default/objects/Allocation_Booking__c/fields/Category__c.field-meta.xml" --source-dir "force-app/main/default/objects/Allocation_Booking__c/fields/Managed__c.field-meta.xml" --source-dir "force-app/main/default/objects/Allocation_Booking__c/fields/Record_Manager__c.field-meta.xml" --source-dir "force-app/main/default/objects/Allocation_Booking__c/webLinks/New_Booking.webLink-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Account_Number__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/BSP_Rev__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Completed__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Contract_Type__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Contract__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Credit_Check_Passed__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Current_Threshold__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Digital_Brand_Compliant__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/End_Date__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Invoiced_Rev__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/OwnerId.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Review_Status_Warning__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Review_Status__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Start_Date__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Started__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Total_Rev__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Trading_Account__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Trading_Name__c.field-meta.xml" --source-dir "force-app/main/default/objects/Annual_Review__c/fields/Year__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/API_Status__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Abandoned__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Account_Number__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Annual_Review__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Application_Abandonment_Date__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Application_Received__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Application_Sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Authorise_Tkg_Auth_and_add_IATA__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Budget__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Concessions_Approved_Y_N__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Concessions_Due_Date_Is_In_Future__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Concessions_Review_Due__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_Chase_Sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_DD_Received__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_DD_Sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_End_Date__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_Start__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_Status__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_Status_n__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_Type__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract_Type_n__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Contract__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Create_BAF_Rqst_mapping_update__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Credit_Check_Passed__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Direct_Debit_Received__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Direct_Debit_Sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Elgar_via_GDS_applicable__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Letter_of_Credit_Approved__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Letter_of_Credit_Renewal__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Letter_of_Credit_Sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Mapping_Request_sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/NDA_received__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/NDA_sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/NDA_specification_sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Notes_Comments__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Set_up_in_R12_Add_Oracle_Id_Above__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Sign_up_for_E4A_News_using_Notices_Email__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Trading_Account__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Trading_Name__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Type__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Unique_Contract_Applicable__c.field-meta.xml" --source-dir "force-app/main/default/objects/Application_Audit__c/fields/Voyager_Application_Sent__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2B_IATACode__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_Account__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_DeleteExtracted__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_Delete__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_EudoNetExternalId__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_FirstInsert__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_InsertExtracted__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_OfficeIdCode_Changed__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_OfficeIdCode__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_OfficeId__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/B2b_ParentAccount__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/Country__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/fields/OwnerId.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/listViews/All.listView-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/recordTypes/B2b_Deleted.recordType-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/recordTypes/B2b_Operational.recordType-meta.xml" --source-dir "force-app/main/default/objects/B2b_AccountPCC__c/validationRules/B2b_RTDeleted.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/Action_Type__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Account__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_ApprovalInProgress__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Approved__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_BeneLastExtractionDate__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Bene_Extract__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Code_type__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_EudoNetExternalId__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Extract_Date__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_GDS3LastExtractionDate__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_GDS3_Extract__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_GDS_Air_Comfort_Tariff_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_GDS_Air_Premium_Tariff_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_GDS_Air_Standard_Tariff_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_LastExtractionDate__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_NegotiatedRateDetailCode__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_ParentNrDetail__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageDiscountBp__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageDiscountComfort__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageDiscountFirst__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageDiscountPremium__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageDiscountSp__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageDiscountStandard__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageNl__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentagePossibleComfort__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentagePossibleFirst__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentagePossibleStandard__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_PercentageTGN__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Percentage_Discount_Comfort__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Percentage_Discount_Premium__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Percentage_Discount_Standard__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Resarail_Extract__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_RoadEndDate__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_RoadStartDate__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Road__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_RouteEndDate__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_RouteStartDate__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Route__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_S3_BeNe_Comfort_Tariff_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_S3_BeNe_Premium_Tariff_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_S3_BeNe_Standard_Tariff_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_Status__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_TicketsComfort__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_TicketsFirst__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_TicketsStandard__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_TurnoverComfort__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_TurnoverFirst__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/B2b_TurnoverStandard__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/ContractID__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/GDS_Air_Business_Premier_Tariff_Codes__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/GDS_Air_Extract__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/GDS_Air_Standard_Premier_Tariff_Codes__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/GDS_Used__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/OwnerId.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/PCC_Extract__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/S3_BeNe_Business_Premier_Tariff_Codes__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/S3_BeNe_Standard_Premier_Tariff_Codes__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/S3_Extract__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/fields/Skip_Validation__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/listViews/All.listView-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/listViews/Pricing_Team_B2b_NrDetails.listView-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/recordTypes/Negotiated_Rate_Continent.recordType-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/recordTypes/Negotiated_Rate_London.recordType-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2B_Exclude_values_Comfort.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2B_Exclude_values_Premium.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2B_Exclude_values_Standard.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_BlockNRDIfNRNotActive.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_BlockPercentageForClass.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_Block_NRD_New_Status.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_Block_NRD_Update_Status.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_Block_To_Be_Extracted.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_Block_To_Be_Extracted_V2.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_NRDStartDateRules.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_NegotiatedRateStatusRules.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_NeogtiatedRateStatusOrder.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_Only_Admin_Can_Change_Extracted.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_Prevent_Manual_Editing.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_NrDetails__c/validationRules/B2b_Prevent_Route_End_Date_Change.validationRule-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_AgenciesNetwork__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_Country__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_EudoNetExternalId__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_IATACode__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_Number__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_OfficeIdCode__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_Street__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/B2b_ZipCode__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/Office_Id_Code__c.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/fields/OwnerId.field-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/listViews/All.listView-meta.xml" --source-dir "force-app/main/default/objects/B2b_PCC__c/validationRules/B2b_BlockNameAndIATACode.validationRule-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"

