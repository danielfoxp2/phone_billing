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

prod_start_call_record_example_one = %CallRecord{id: "13", call_id: 70, destination: 9933468278, source: 99988526423, timestamp: ~N[2016-02-29T12:00:00Z], type: "start"}
prod_end_call_record_example_one = %CallRecord{id: "14", call_id: 70, timestamp: ~N[2016-02-29T14:00:00Z], type: "end"}

prod_start_call_record_example_two = %CallRecord{id: "15", call_id: 71, destination: 9933468278, source: 99988526423, timestamp: ~N[2017-12-11T15:07:13Z], type: "start"}
prod_end_call_record_example_two = %CallRecord{id: "16", call_id: 71, timestamp: ~N[2017-12-11T15:14:56Z], type: "end"}

prod_start_call_record_example_three = %CallRecord{id: "17", call_id: 72, destination: 9933468278, source: 99988526423, timestamp: ~N[2017-12-12T22:47:56Z], type: "start"}
prod_end_call_record_example_three = %CallRecord{id: "18", call_id: 72, timestamp: ~N[2017-12-12T22:50:56Z], type: "end"}

prod_start_call_record_example_four = %CallRecord{id: "19", call_id: 73, destination: 9933468278, source: 99988526423, timestamp: ~N[2017-12-12T21:57:13Z], type: "start"}
prod_end_call_record_example_four = %CallRecord{id: "20", call_id: 73, timestamp: ~N[2017-12-12T22:10:56Z], type: "end"}

prod_start_call_record_example_five = %CallRecord{id: "21", call_id: 74, destination: 9933468278, source: 99988526423, timestamp: ~N[2017-12-12T04:57:13Z], type: "start"}
prod_end_call_record_example_five = %CallRecord{id: "22", call_id: 74, timestamp: ~N[2017-12-12T06:10:56Z], type: "end"}

prod_start_call_record_example_six = %CallRecord{id: "23", call_id: 75, destination: 9933468278, source: 99988526423, timestamp: ~N[2017-12-13T21:57:13Z], type: "start"}
prod_end_call_record_example_six = %CallRecord{id: "24", call_id: 75, timestamp: ~N[2017-12-14T22:10:56Z], type: "end"}

prod_start_call_record_example_seven = %CallRecord{id: "25", call_id: 76, destination: 9933468278, source: 99988526423, timestamp: ~N[2017-12-12T15:07:58Z], type: "start"}
prod_end_call_record_example_seven = %CallRecord{id: "26", call_id: 76, timestamp: ~N[2017-12-12T15:12:56Z], type: "end"}

prod_start_call_record_example_eight = %CallRecord{id: "27", call_id: 77, destination: 9933468278, source: 99988526423, timestamp: ~N[2018-02-28T21:57:13Z], type: "start"}
prod_end_call_record_example_eight = %CallRecord{id: "28", call_id: 77, timestamp: ~N[2018-03-01T22:10:56Z], type: "end"}

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

BillingRepository.Repo.insert!(prod_start_call_record_example_one)
BillingRepository.Repo.insert!(prod_end_call_record_example_one)

BillingRepository.Repo.insert!(prod_start_call_record_example_two)
BillingRepository.Repo.insert!(prod_end_call_record_example_two)

BillingRepository.Repo.insert!(prod_start_call_record_example_three)
BillingRepository.Repo.insert!(prod_end_call_record_example_three)

BillingRepository.Repo.insert!(prod_start_call_record_example_four)
BillingRepository.Repo.insert!(prod_end_call_record_example_four)

BillingRepository.Repo.insert!(prod_start_call_record_example_five)
BillingRepository.Repo.insert!(prod_end_call_record_example_five)

BillingRepository.Repo.insert!(prod_start_call_record_example_six)
BillingRepository.Repo.insert!(prod_end_call_record_example_six)

BillingRepository.Repo.insert!(prod_start_call_record_example_seven)
BillingRepository.Repo.insert!(prod_end_call_record_example_seven)

BillingRepository.Repo.insert!(prod_start_call_record_example_eight)
BillingRepository.Repo.insert!(prod_end_call_record_example_eight)

BillingRepository.Repo.query!("insert into tariffs (reference, standing_charge, call_charge) values(201602, 0.36, 0.09)")

BillingRepository.Repo.query!("insert into tariffs (reference, standing_charge, call_charge) values(201712, 0.36, 0.09)")

BillingRepository.Repo.query!("insert into tariffs (reference, standing_charge, call_charge) values(201802, 0.36, 0.09)")

BillingRepository.Repo.query!("insert into tariffs (reference, standing_charge, call_charge) values(201811, 0.36, 0.09)")
