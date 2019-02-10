# PhoneBilling

The PhoneBilling project is intended for telephone bill creation. In order to do it so, the system provides a way to persist calls, which enables the bill calculation for an specific period.

The PhoneBilling architecture is divided in three applications: BillingGateway, BillingProcessor and BillingRepository.

The apps separation is for maintenance flexibility and project improviment, making it easier to make changes, i.g., replacing Postgres to MongoDB, changing the API for something else or just change the validators inside BillingProcessor.

## BillingGateway

A Phoenix application for process requests to the PhoneBilling REST API. It its responsibility the coordination of database access and business rules execution.

The BillingGateway is based on the application layer of Domain Driven Design (DDD) and it is the dependency injector of the domain layer.

## BillingProcessor

An Elixir application that represents the domain layer of DDD. It was thought to be self-contained, completely agnostic. In others words, it has no depencies, e.g., database, file IO or network communication.

It contains all the business rules to process calls and create bills.

## BillingRepository

An Elixir application with the purpose of persist to and recover from database the telephone calls data. It is the infrastructure layer of Domain Driven Design.


Fazer diagrama 
Colocar instruções de instalação e testes
Ambiente usado para executar projeto Computer/operating system, text editor/IDE, libraries, etc).
