<img width="1163" height="490" alt="image" src="https://github.com/user-attachments/assets/3a726527-4e5b-4ef5-a334-d9f7327c2277" />### Componentes Principais:
1. **Amazon Route 53:** Camada de DNS responsável por resolver o nome de domínio e direcionar o tráfego de entrada para o balanceador de carga.
2. **Elastic Load Balancing (ALB):** Um Application Load Balancer que atua como porta de entrada pública para o tráfego HTTP (porta 80), distribuindo as requisições de forma equilibrada entre as instâncias EC2 ativas nas sub-redes públicas.
3. **Zonas de Disponibilidade (Zone A e Zone B):** Uso das zonas `us-east-1a` e `us-east-1b` para garantir alta disponibilidade. Caso uma zona sofra uma interrupção, a outra continuará operando normalmente.
4. **Auto Scaling Group (ASG):** Componente responsável pela elasticidade do sistema. Ele monitora a saúde das instâncias e gerencia automaticamente a quantidade de servidores baseando-se em políticas de demanda (mínimo, máximo e capacidade desejada).
5. **Instâncias EC2 & Provisionamento Inicial (User Data):** Servidores virtuais executando Ubuntu Server. O provisionamento inicial foi automatizado via script bash embarcado no argumento `user_data`, realizando a atualização do sistema, instalação e inicialização do servidor web Apache de forma transparente no primeiro boot.

---

## Fluxo Operacional da Solução

1. **Entrada do Tráfego:** O cliente final faz uma requisição web digitando o endereço da aplicação. O **Amazon Route 53** resolve a consulta DNS e aponta para o endereço DNS do **Elastic Load Balancer**.
2. **Distribuição de Carga:** O **Elastic Load Balancer** recebe a requisição na porta pública 80, avalia a saúde (Health Check) das instâncias EC2 nas duas zonas de disponibilidade e encaminha o tráfego de forma alternada.
3. **Processamento da Aplicação:** A instância EC2 alvo (localizada na Subnet A ou Subnet B) processa a requisição através do serviço Apache instalado nativamente e retorna o conteúdo HTML configurado no provisionamento inicial.
4. **Elasticidade Automática:** O **Auto Scaling** garante de forma autônoma que existam sempre pelo menos 2 instâncias operacionais (uma em cada AZ). Caso o tráfego atinja picos elevados, novas instâncias são criadas horizontalmente; caso a demanda caia, instâncias excedentes são finalizadas para otimização de custos.

---

## Estrutura do Projeto

O código foi inteiramente construído utilizando **Módulos do Terraform** para separar responsabilidades de rede e computação.

```text
trabalho-iac-aws/
├── .gitignore               # Arquivos ignorados pelo Git (Credentials, tfstate, etc.)
├── providers.tf             # Configuração do Provedor AWS e versões requeridas
├── main.tf                  # Chamada principal e orquestração dos módulos
├── variables.tf             # Variáveis de entrada globais da raiz
└── modules/
    ├── network/             # Módulo responsável pela Infraestrutura de Rede
    │   ├── main.tf          # Criação de VPC, Subnets, IGW e Route Tables
    │   ├── variables.tf     # Parâmetros customizáveis de rede
    │   └── outputs.tf       # Exportação de IDs da VPC e Subnets
    └── compute/             # Módulo responsável pela Computação e Escalabilidade
        ├── main.tf          # Security Groups, Launch Template, ASG e User Data
        ├── variables.tf     # Entradas dependentes do módulo network
        └── outputs.tf       # Exportação de atributos de computação (SG IDs, ASG Name)



