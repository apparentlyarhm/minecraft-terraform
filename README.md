# MINECRAFT BASIC INFRA WITH MINIMAL TRAFFIC CONTROL

ok so the idea is this terraform repository, given a gcp account, sets up
a basic minecraft server infra with a simple "authentication" app written in Spring and NextJS, so that it is (somewhat) secure.

> [!TIP]
>
> its undergoing major devlopment, so this will be updated. An in-depth guide will be made. for now, heres a time based log:

[30/3/25] - Its still barebones, but the server is configurable. just make sure to manually run the startup script for the VM. if u wnant to use modpacks, the `startup.sh` file must be edited accourdingly to automate it.

> Anyways the initialisation process will remain the same:

# Setting Up The Terraform Service Account for GCP

To deploy these Terraform resources on Google Cloud, you need to create a service account with the necessary permissions. Follow the steps below to set up the service account and generate the key.

## Prerequisites

- Ensure you have the **Google Cloud SDK** installed and authenticated.
- Set your desired **GCP project**:
  ```sh
  gcloud config set project YOUR_PROJECT_ID
  ```

## Step 1: Create the Service Account

Run the following command to create a Terraform-specific service account:

```sh
gcloud iam service-accounts create terraform-sa --display-name "Terraform Service Account"
```

Then, assign roles:

```sh
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:terraform-sa@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"

```

## Step 2: Generate and Download Service Account Key

Create a JSON key file to authenticate Terraform with GCP:

```sh
gcloud iam service-accounts keys create terraform-sa-key.json \
    --iam-account=terraform-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

For simplicity, just keep it in the same location as this repository, otherwise you will have to edit its reference everywhere its used

## Step 3: Set Up Terraform to Use the Service Account

Reference the key file in your Terraform provider configuration:

```hcl
provider "google" {
  credentials = file("./terraform-sa-key.json")
  project     = var.project_id
  region      = var.region
}
```

## Done!

Your Terraform service account is now ready. You can proceed with running `terraform init` and `terraform apply` to deploy your infrastructure!

I believe that there are better ways to do this, so I will update it if I incorporate those here, for now we will keep it like this.

# Post Terraform Configuration

[TO BE UPDATED] But this will most likely involve a script that can clone the supporting applications and deploy them to your GCP account/ github pages to finish the configuration


## See also

[Java Backend](https://github.com/apparentlyarhm/validator-gcp-java)