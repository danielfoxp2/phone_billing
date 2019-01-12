alias BillingRepository.Calls.CallRecord

first_start_call_record = %CallRecord{id: "1", call_id: 1, destination: 6234568967, source: 6234567967, timestamp: ~N[2019-11-23T13:34:56Z], type: "start"}
first_end_call_record = %CallRecord{id: "2", call_id: 1, timestamp: ~N[2019-11-23T13:45:56Z], type: "end"}

second_start_call_record = %CallRecord{id: "3", call_id: 2, destination: 6234888967, source: 6234555967, timestamp: ~N[2019-11-23T13:45:56Z], type: "start"}
second_end_call_record = %CallRecord{id: "4", call_id: 2, timestamp: ~N[2019-11-23T13:55:56Z], type: "end"}

third_start_call_record = %CallRecord{id: "5", call_id: 3, destination: 6234448967, source: 6234558968, timestamp: ~N[2019-11-23T13:45:56Z], type: "start"}
third_end_call_record = %CallRecord{id: "6", call_id: 3, timestamp: ~N[2019-11-23T13:55:56Z], type: "end"}

fourth_start_call_record = %CallRecord{id: "7", call_id: 4, destination: 6298457834, source: 62984680648, timestamp: ~N[2018-11-23T21:57:13Z], type: "start"}
fourth_end_call_record = %CallRecord{id: "8", call_id: 4, timestamp: ~N[2018-11-23T22:17:53Z], type: "end"}

fifth_start_call_record = %CallRecord{id: "9", call_id: 5, destination: 6298457877, source: 62984680648, timestamp: ~N[2018-11-25T15:45:23Z], type: "start"}
fifth_end_call_record = %CallRecord{id: "10", call_id: 5, timestamp: ~N[2018-11-25T16:08:05Z], type: "end"}

sixth_start_call_record = %CallRecord{id: "11", call_id: 6, destination: 6298457877, source: 62984680648, timestamp: ~N[2018-10-31T23:50:00Z], type: "start"}
sixth_end_call_record = %CallRecord{id: "12", call_id: 6, timestamp: ~N[2018-11-01T00:08:05Z], type: "end"}

BillingRepository.Repo.insert!(first_start_call_record)
BillingRepository.Repo.insert!(first_end_call_record)

BillingRepository.Repo.insert!(second_start_call_record)
BillingRepository.Repo.insert!(second_end_call_record)

BillingRepository.Repo.insert!(third_start_call_record)
BillingRepository.Repo.insert!(third_end_call_record)

BillingRepository.Repo.insert!(fourth_start_call_record)
BillingRepository.Repo.insert!(fourth_end_call_record)

BillingRepository.Repo.insert!(fifth_start_call_record)
BillingRepository.Repo.insert!(fifth_end_call_record)

BillingRepository.Repo.insert!(sixth_start_call_record)
BillingRepository.Repo.insert!(sixth_end_call_record)

BillingRepository.Repo.query!("insert into tariffs (reference, standing_charge, call_charge) values(201811, 0.36, 0.09)")
