---
tags:
    - server
    - ldap
---

## Threads

Généralement fonction du nombre de cœur réel. Contre-intuitivement, un nombre de *threads* supérieur à 16 entraîne une baisse de performance des les opérations de lecture. En revanche les opérations intensives d'écriture sont plus rapides.
