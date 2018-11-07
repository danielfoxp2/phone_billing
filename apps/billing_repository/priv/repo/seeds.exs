alias BillingRepository.Calls.CallRecord

first_start_call_record = %CallRecord{id: "1", call_id: 1, destination: "6234568967", source: "6234567967", timestamp: "2019-11-23T13:34:56Z", type: "start"}
first_end_call_record = %CallRecord{id: "2", call_id: 1, timestamp: "2019-11-23T13:45:56Z", type: "end"}

second_start_call_record = %CallRecord{id: "3", call_id: 2, destination: "6234888967", source: "6234555967", timestamp: "2019-11-23T13:45:56Z", type: "start"}
second_end_call_record = %CallRecord{id: "4", call_id: 2, timestamp: "2019-11-23T13:55:56Z", type: "end"}

third_start_call_record = %CallRecord{id: "5", call_id: 3, destination: "6234448967", source: "6234558968", timestamp: "2019-11-23T13:45:56Z", type: "start"}
third_end_call_record = %CallRecord{id: "6", call_id: 3, timestamp: "2019-11-23T13:55:56Z", type: "end"}

BillingRepository.Repo.insert!(first_start_call_record)
BillingRepository.Repo.insert!(first_end_call_record)

BillingRepository.Repo.insert!(second_start_call_record)
BillingRepository.Repo.insert!(second_end_call_record)

BillingRepository.Repo.insert!(third_start_call_record)
BillingRepository.Repo.insert!(third_end_call_record)

