## MINECRAFT BASIC INFRA WITH MINIMAL TRAFFIC CONTROL

ok so the idea is this terraform repository, given a gcp account, sets up
a basic minecraft server infra with a simple app written in django and nextjs, so that it is (somewhat) secure.

its undergoing major devlopment, so this will be updated.

also, to adapt it to any gcp project, create a service account specific to terraform, and get its credentials using google cloud cli. the `key.json` saved 
will serve as credentials. 