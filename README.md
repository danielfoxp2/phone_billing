# PhoneBilling

O projeto PhoneBilling é para criação de contas telefônicas. A fim de atingir este objetivo, o sistema apresenta 
um meio de persistir as ligações realizadas tornando possível o cálculo da conta telefônica em uma determinada referência.

A arquitetura do PhoneBilling é dividida em três aplicações, BillingGateway, BillingProcessor e BillingRepository.

The PhoneBilling project is intended for telephone bill creation. In order to do it so, the system provides a way to persist calls enabling the bill calculation for an specific period.

The PhoneBilling architecture is divided in three applications: BillingGateway, BillingProcessor and BillingRepository.

The apps separation is for maintenance flexibility and project improviment, making it easier to make changes, i.g., replacing Postgres to MongoDB, changing the API for something else or just change the validators inside BillingProcessor.

## BillingGateway

uma aplicação Phoenix destinada a processar as requisições feitas para a API Rest do PhoneBilling. 
É de sua responsabilidade coordenar o acesso ao banco de dados e a execução das regras de negócio.
Em resumo, o BillingGateway é responsável pela injeção de dependências na camada de domínio. O BillingGateway é
baseado na camada de aplicação do Domain Driven Design (DDD).

An Phoenix application for process requests to the PhoneBilling REST API. It its responsibility the coordination of database access and business rules execution.

The BillingGateway is based on the application layer of Domain Driven Design (DDD) and it is the dependency injector of the domain layer.

## BillingProcessor

uma aplicação Elixir que representa a camada de domínio do DDD. Foi pensada de modo a ser auto-suficiente,
completamente agnóstica, ou seja, não possui nenhuma dependência, e.g., acesso a banco de dados, IO de arquivos e network communication. 
Contêm as regras de negócio para processamento das ligações.

An Elixir application that represents the domain layer of DDD. It was thought to be self-contained, completely agnostic. In others words, it has no depencies, e.g., database, file IO or network communication.

It contains all the business rules to process calls and create bills.

## BillingRepository

uma aplicação destinada a persistir e recuperar os dados das ligações telefônicas. Tem a responsabilidade de prover
a infraestrutura necessária para acesso ao banco de dados.

A separação em aplicações foi feita para dar flexibilidade na manutenção e evolução do projeto, assim como facilitar uma eventual
mudanças de tecnologias. Ex. PostgreSql para MongoDB, etc.

An Elixir application with the purpose of persist to and recover from database the telephone calls data. It is the infrastructure layer of Domain Driven Design.

Fazer diagrama 

Colocar instruções de instalação e testes
Ambiente usado para executar projeto Computer/operating system, text editor/IDE, libraries, etc).
