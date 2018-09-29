Feature: Hold call details records
    As a telecommunication platform operator
    I want to hold call details records of a telephone number
    So that the monthly bill of the number can be calculated

    * It does not process if there's no postback url;
    * When there's postback url then a processing protocol is returned to the caller
    * Information about records processed will be sent to the postback url;

    Scenario: Processing request without postback url 
        Given that postback url not exists in the request parameters
        When I try to process call details records
        Then the processing is not executed
        And the message "Postback url is required" is immediately returned

    Scenario: Processing request with invalid postback url
        Given that postback url is invalid 
        When I try to process call details records
        Then the processing is not executed
        And the message "Postback url is invalid" is immediately returned


        