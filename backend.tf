// hardcoding for now...
terraform {
    cloud {
        organization = "minecraft-test"

        workspaces {
            name = "main"
        }
    }

}