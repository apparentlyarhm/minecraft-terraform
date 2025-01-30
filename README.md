## MINECRAFT BASIC INFRA WITH MINIMAL TRAFFIC CONTROL

ok so the idea is this terraform repository, given a gcp account, sets up
a basic minecraft server infra with a simple app written in django and nextjs, so that it is (somewhat) secure.

> [!TIP]
>
> its undergoing major devlopment, so this will be updated. An in-depth guide will be made


>[!IMPORTANT]
>
>a service account with necessary permissions is required beforehand, specifically its credentials in the form of a json file.


One can use `github cli` create a service account to save a key.json to the repo location, and run `terraform apply`. This should, at least in theory, deploy everything automatically, that we will see as the codebase evolves