# Aletheia

Aletheia is a system for automated detection of integrity violations in microservice codebases.

In microservice architectures, data is stored across heterogeneous systems, with data schemas partitioned and managed by separate services. Due to the complexity of microservices, it can be almost impossible for developers to have a comprehensive understanding of the entire system, making it challenging to reason about and maintain data integrity at the application level. 

Aletheia solves this problem through static analysis, identifying semantic violations in microservice ecosystems (i.e., service interactions and operations that break data integrity) for various types of integrity constraints, including entity integrity, referential integrity, and uniqueness.

You can check our three main repositories:

- [Aletheia](https://github.com/aletheia-microservices/aletheia): core implementation of our analysis framework
- [Aletheia - Artifact OSDI'26](https://github.com/aletheia-microservices/aletheia-artifact-osdi26): artifacts and steps to reproduce experiments from our paper "Aletheia: Automated Detection of Data Integrity Violations in Microservices" accepted in OSDI'26
- [Blueprint](https://github.com/aletheia-microservices/blueprint): fork of Blueprint containing the applications analyzed and included in the paper
