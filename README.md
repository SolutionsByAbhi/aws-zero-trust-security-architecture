 #  🔐  Zero‑Trust  Security Architecture  on  AWS
 
 This repository  implements  a  **Zero‑Trust  security blueprint**  on  AWS  using:
 
-  Private  VPC‑only  workloads
 - VPC  Lattice  for  service‑to‑service  access control
 -  AWS  PrivateLink  for private  consumer  access
 -  WAF +  ALB  as  a  Zero‑Trust ingress  layer
 -  IAM‑based  and JWT‑based  authentication
 -  GuardDuty  + Security  Hub  for  continuous  monitoring

 It’s  designed  as  a **reference  architecture**  and  a  **portfolio‑grade project**  for  cloud  security  and platform  engineers.
 
 ---
 
##  Core  Principles
 
 - **Never  trust,  always  verify**
 - **Identity‑centric  access**  (IAM,  JWT,  OIDC)
-  **No  direct  public  access to  workloads**
 -  **Centralized  ingress with  WAF**
 -  **Service‑to‑service  policies via  VPC  Lattice**
 -  **Continuous detection  &  visibility**
 
 ---

 ##  High‑Level  Architecture
 
-  A  **private  VPC**  hosts an  internal  API  service.
 - An  **ALB  +  WAF**  acts as  the  only  public  entry point.
 -  A  **Zero‑Trust  auth proxy  Lambda**  validates  JWTs  / identity  before  forwarding.
 -  **VPC Lattice**  enforces  service‑to‑service  policies.
 - **PrivateLink**  exposes  services  privately  to other  VPCs  /  accounts.
 - **GuardDuty**  and  **Security  Hub**  monitor threats  and  misconfigurations.
 
 ---

 ##  Getting  Started
 
```bash
 cd  infra/terraform
 terraform  init
terraform  apply  -var="region=us-east-1"  -var="project_prefix=zt-demo"
