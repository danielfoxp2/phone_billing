# Phone Billing API Documentation

Explicacao basica da api
Falar sobre taxas, call records e bills

## Taxes

This resources allow the client of API to define taxes for a reference to charge calls.

### Request example

```bash
$ curl localhost:4000/api/taxes \
  -H "Content-Type: application/json" \
  -d '{"taxes_params": { "reference_period": "01/2019", "call_charge": "0.05", "standing_charge": "0.09" }}' 
```

### Arguments

Field | Description
----- | -----------
**taxes_params** | Object containing the data to be inserted.
**reference_period** | Reference to set taxes. Should have `MM/YYYY` format.
**call_charge** | Charged value of each minute of call. Should be a float. Integers are not considered floats by the application.
**standing_charge** | Default value charged one time in the call. Should be a float. Integers are not considered floats by the application.

### Responses example

#### On Success
If the taxes params are valid and can be inserted, then the caller will receive the response below.

```javascript
{
  "response_message": "Taxes inserted"
}
```
#### If taxes params are valid it will be inserted?
Not exactly. Even if all parameters are consistent the tariffs for the given reference can have its insertion denied by the business rules.
For a better explanation it will be used scenarios from ATDD below:

```guerkin
Scenario: When informed reference is lower than current reference and is not persisted yet
  Given that the current reference is "01/2019"
  And I informed "11/2018" as reference period to insert valid taxes
  And there is no "11/2018" reference persisted yet
  When I call the taxes API with these parameters
  Then it should have the taxes for "11/2018" reference persisted

Scenario: When informed reference is lower than current reference and it is persisted already
  Given that the current reference is "01/2019"
  And I informed "11/2018" as reference period to insert valid taxes
  But there is already a "11/2018" reference persisted 
  When I call the taxes API with these parameters
  Then it should not persist the new values I am inserting for "11/2018" reference
  And I should see the message "It is not allowed the update of taxes before the current reference"

Scenario: When informed reference is equal or greater than current reference and is not persisted yet
  Given that the current reference is "01/2019"
  And I informed "01/2019" as reference period to insert valid taxes
  And there is no "01/2019" reference persisted yet
  When I call the taxes API with these parameters
  Then it should have the taxes for "01/2019" reference persisted

Scenario: When informed reference is equal or greater than current reference and it is persisted already
  Given that the current reference is "01/2019"
  And I informed "05/2019" as reference period to insert valid taxes
  But there is already a "05/2019" reference persisted 
  When I call the taxes API with these parameters
  Then it should update taxes values for the existen reference
```

#### On Validation Errors

The application will return each inconsistence found in a list. The possible inconsistences can be found below.

#### when reference period don't exists or is in the wrong format

```javascript
{
  "taxes_error": [
    "The reference period should be informed with key 'reference_period' and formatted MM/AAAA"
  ]
}
```

#### when standing charge don't exists

```javascript
{
  "taxes_error": [
    "The standing charge should be informed with key 'standing_charge'"
  ]
}
```
#### when standing charge is not a number

```javascript
{
  "taxes_error": [
    "The standing charge should be a float number"
  ]
}
```
#### when call charge don't exists

```javascript
{
  "taxes_error": [
    "The call charge should be informed with key 'call_charge'"
  ]
}
```
#### when call charge is not a number

```javascript
{
  "taxes_error": [
    "The call charge should be a float number"
  ]
}
```

#### when the persisted reference is lower then current reference

```javascript
{
  "taxes_error": [
    "It is not allowed the update of taxes before the current reference"
  ]
}
```
## Call Records

The call records resource is intended to be called to save call records. It will process all call records and send the result to the postback URL.

### Request example
```javascript
// call_records_example.json
{
	"call_records_params":
	{
		"postback_url": "www.example.com/my-receiver-action",
		"call_records": 
		[
			{
			  "id": "40",
			  "type": "start",
			  "timestamp": "2018-11-15T13:15:44Z",
			  "call_id": "123",
			  "source": "62984680648",
			  "destination": "62111222333"
    	}, 
			{
        "id": "41",
        "type": "end",
        "timestamp": "2018-11-15T13:23:14Z",
        "call_id": "123"
			}
    ]
	}
}
```

```bash
$ curl localhost:4000/api/call_records \
  -H "Content-Type: application/json" \
  -d @call_records_example.json
```
### Arguments

Field | Description
----- | -----------
**call_records_params** | Object containing the data to be inserted.
**postback_url** | The URL that PhoneBilling will call to send the result of processing the call records informed.
**call_records** | A list of call records to be persisted.

### Response example

The call records insert processing is done asynchronously, because of it the response is split in two phases:

1ª - The caller will receive a protocol number as response of call record resource. The protocol number identify the call records chunk processed after the end of the second phase.

```javascript
{
  "protocol_number": 1
}
 ```

2ª - As the caller can send a big load of call records, in order to avoid blocking the application while these call records is being processed this processing is done asynchronously and the result is sent to the `postback_url` informed.

```javascript
{
  "received_records_quantity":"2",
  "consistent_records_quantity":"2",
  "inconsistent_records_quantity":"0",
  "database_inconsistent_records_quantity":"0",
  "failed_records_on_validation": [],
  "failed_records_on_insert": []
}
```

#### Response fields

Field | Description
----- | -----------
**received_records_quantity** | Represents the total quantity of call records received to be processed.
**consistent_records_quantity** | Represents the total quantity of call records received that comply with the consistence call records rules.
**inconsistent_records_quantity** | Represents the total quantity of call records received that not comply with the consistence call records rules.
**database_inconsistent_records_quantity** | Represents the total quantity of call records that has ids or call ids duplicated with call records from database.
**failed_records_on_validation** | Represents the list of call records that has some inconsistence.
**failed_records_on_insert** | Represents the list of call records that returned `{:error, reason}` on database insertion moment.



### Validations
Before insert the call records, the application executes a set of validations to garantee that call records with inconsistences do not get inserted in database. 

These validations also serves to inform the PhoneBilling caller why each refused call record is invalid.

The set o validation consists in:

* Content;
* Duplication;
* Call structure;

#### Validations of Content
The content validation takes care of information domain and required fields.

Below are described error messages for each content validation of call records.

#### when it does not contains the id field or the id is null or empty

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record don't have id"
  ]
}
```

#### when it does not contains the type field

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record don't have type"
  ]
}
```

#### when the type field is different of 'start' or 'end'

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "Call record has a wrong type: '<wrong_type_description_here>'. Only 'start' and 'end' types are allowed."
  ]
}
```

#### when it does not contains the timestamp field or the timestamp is null or empty

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record don't have timestamp"
  ]
}
```

#### when timestamp has not 'YYYY-MM-DDThh:mm:ssZ' utc format

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "Call record has a wrong timestamp: '<wrong_timestamp_here>'. The timestamp must have this format: YYYY-MM-DDThh:mm:ssZ"
  ]
}
```

#### when it does not contains the call id field or call id is null

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record don't have call_id"
  ]
}
```

#### when call id is not a integer

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "Call record has a wrong call_id: '<wrong_call_id_here>'. The call id must be integer."
  ]
}
```

#### when it does not contains the source field or the source is null in a start record

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record don't have source"
  ]
}
```

#### when source has not AAXXXXXXXX or AAXXXXXXXXX format

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    `
      Call record has a wrong source: '<wrong_source_here>'. 
      The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
      The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
    `
  ]
}
```

#### when it does not contains the destination field or the destination is null in start record

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record don't have destination"
  ]
}
```

#### when destination has not AAXXXXXXXX or AAXXXXXXXXX format

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    `
      Call record has a wrong destination: ''<wrong_destination_here>'. 
      The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
      The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
    `
  ]
}
```

#### Validation of Duplicity

The duplicity validation consists of two types: duplication on itens being inserted and duplication 
with the itens already inserted. The target fields of these validations are: `id` and `call_id`.

The Id must be uniq for each call record.

The call_id need to be a pair of call records consisting in a call record of type `start` with a call_id number 
and a call record of type `end` with the same call_id.

Below are described error messages for each duplicity validation of call records.

####  when there are duplicated call record id within call records to be persisted

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record with id: <duplicated_id_here> is duplicated in call records being inserted"
  ]
}
```

#### when already exists the same call record id persisted

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record with id: <duplicated_id_here> already exists in database"
  ]
}
```

#### when there are more than two call ids with the same value within call records to be persisted

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record with call_id: <duplicated_call_id_here> is duplicated in call records being inserted"
  ]
}
```

#### when already exists the same call record call_id persisted

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "call record with call_id: <duplicated_call_id_here> already exists in database"
  ]
}
```

#### Validation of call structure

The call is a pair of a call record of type `start` and one of type `end` with the same call_id in both of them. 

Below are described error messages for call structure validation.

#### when a call has a call records pair with the same type

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "Inconsistent call for call_id <call_id_number_here>. A call is a composition of two record types, 'start' and 'end', with the same call id."
  ]
}
```

#### when a call has a call record without type value

```javascript
{
  //[other fields of the invalid call record...]
  "errors": [
    "Inconsistent call for call_id <call_id_number_here>. A call is a composition of two record types, 'start' and 'end', with the same call id."
  ]
}
```

## Bills

### Request example

```bash
$ curl localhost:4000/api/taxes \
  -d taxes_params[reference_period]=01/2019 \
  -d taxes_params[call_charge]=0.05 \
  -d taxes_params[standing_charge]=0.09 
```
### Arguments

### Responses example

#### On Success

#### On Validation Errors


