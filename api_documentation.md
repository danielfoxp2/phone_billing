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

### Request example

```bash
$ curl localhost:4000/api/taxes \
  -H "Content-Type: application/json" \
  -d taxes_params[call_charge]=0.05 
```
### Arguments

### Responses example

#### On Success

#### On Validation Errors



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


