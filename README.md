# PhoneBilling

O projeto PhoneBilling é para criação de contas telefônicas. A fim de atingir este objetivo, o sistema apresenta 
um meio de persistir as ligações realizadas tornando possível o cálculo da conta telefônica em uma determinada referência.

A arquitetura do PhoneBilling é dividida em três aplicações, BillingGateway, BillingProcessor e BillingRepository.

## BillingGateway

uma aplicação Phoenix destinada a processar as requisições feitas para a API Rest do PhoneBilling. 
É de sua responsabilidade coordenar o acesso ao banco de dados e a execução das regras de negócio.
Em resumo, o BillingGateway é responsável pela injeção de dependências na camada de domínio. O BillingGateway é
baseado na camada de aplicação do Domain Driven Design (DDD).

## BillingProcessor

uma aplicação Elixir que representa a camada de domínio do DDD. Foi pensada de modo a ser auto-suficiente,
completamente agnóstica, ou seja, não possui nenhuma dependência, e.g., acesso a banco de dados, IO de arquivos e network communication. 
Contêm as regras de negócio para processamento das ligações.

## BillingRepository

uma aplicação destinada a persistir e recuperar os dados das ligações telefônicas. Tem a responsabilidade de prover
a infraestrutura necessária para acesso ao banco de dados.

A separação em aplicações foi feita para dar flexibilidade na manutenção e evolução do projeto, assim como facilitar uma eventual
mudanças de tecnologias. Ex. PostgreSql para MongoDB, etc.

Fazer diagrama 

Colocar instruções de instalação e testes
Ambiente usado para executar projeto Computer/operating system, text editor/IDE, libraries, etc).
