# Aletheia

**Aletheia: Automated Detection of Data Integrity Violations in Microservices**  
*Mafalda Sofia Ferreira, João Ferreira Loff, João Garcia, and Rodrigo Rodrigues*  
*INESC-ID, Instituto Superior Técnico, Universidade de Lisboa*  
*In Proceedings of the 20th USENIX Symposium on Operating Systems Design and Implementation (**OSDI ’26**)*

---

Aletheia is a static analysis framework for automated detection of integrity violations in microservice codebases.

In microservice architectures, data is stored across heterogeneous systems, with data schemas partitioned and managed by separate services. Due to the complexity of microservices, it can be almost impossible for developers to have a comprehensive understanding of the entire system, making it challenging to reason about and maintain data integrity at the application level. 

Aletheia solves this problem through static analysis, identifying semantic violations in microservice ecosystems (i.e., service interactions and operations that break data integrity) for various types of integrity constraints, including entity integrity, referential integrity, and uniqueness.

Main repository:

- [Aletheia](https://github.com/aletheia-microservices/aletheia): implementation of Aletheia framework

Repositories related to OSDI '26:

- [Aletheia - OSDI'26 Artifact](https://github.com/aletheia-microservices/aletheia-artifact-osdi26): artifacts and instructions to reproduce the experiments from the paper "Aletheia: Automated Detection of Data Integrity Violations in Microservices", accepted in OSDI'26
- [Synthetic Microservice Applications Generator](https://github.com/aletheia-microservices/generator-synthetic-apps): generator of synthetic microservice applications based on call graph characteristics - used in the Aletheia OSDI'26 artifact

Additional repositories:
- [Fork of Blueprint's Repository](https://github.com/aletheia-microservices/blueprint): fork containing the Blueprint compiler and all applications analyzed by Aletheia
