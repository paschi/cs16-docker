[![Docker](https://github.com/paschi/cs16-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/paschi/cs16-docker/actions/workflows/docker-publish.yml)
[![GitHub](https://img.shields.io/github/license/paschi/cs16-docker)](https://github.com/paschi/cs16-docker/blob/main/LICENSE)

# Counter-Strike 1.6 Docker Server
> Powered by Docker, Terraform and Microsoft Azure.

A Docker image for Counter-Strike 1.6 dedicated servers. Bundled with custom maps, Metamod and AMX Mod X.
Supports deployment to Microsoft Azure via Terraform.

## Getting Started

### Run Locally

To start the Docker container locally, open a command shell and execute:

```fish
docker run -d --rm -p 27015:27015/tcp -p 27015:27015/udp -p 27020:27020/udp -p 26900:26900/udp --name cs16 paschi/cs16
```

This will open the required ports and start the server. You can then start your CS 1.6 client and should see the server 
listed under "Find Servers > LAN". If you're running the container on WSL2 and the server is not displayed or you can't
connect to it, you may need to connect directly to the IP that is listed when running `ifconfig`:

```fish
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.29.23.5  netmask 255.255.240.0  broadcast 172.29.79.255
```

Open the console in your CS 1.6 client and enter `connect 172.29.23.5` to connect to the server.

To stop and remove the Docker container, run:

```fish
docker stop cs16
```

### Cloud Deployment

The Terraform configurations in the `terraform` directory allow deploying the Docker image to Microsoft Azure.
To start the deployment, run this code after [authenticating using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli):

```fish
cd terraform

# initialize the working directory for use with Terraform
terraform init

# create an execution plan for the deployment
terraform plan

# execute the plan and create the required resources in Azure
terraform apply
# input: yes
```

If the deployment was successful, `terraform apply` will output the IP address of the server:

```fish
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
Outputs:
ip_address = "20.113.8.157"
```

To clean up the deployment and remove all created resources:

```fish
terraform destroy
# input: yes
```

## Development

### Building

In order to build the Docker image, run this code:

```fish
docker build -t paschi/cs16 .
```

### Publishing

To publish the Docker image to a repository, perform these steps:

```fish
docker image tag paschi/cs16 registry-host:5000/myuser/cs16:latest
docker image push registry-host:5000/myuser/cs16:latest
```

This will tag the the previously built image as `myuser/cs16:latest` and push it to the registry at [registry-host:5000](#).

## Configuration

The Docker image can be configured via environment variables:

```fish
docker run -d --rm -p 27015:27015/tcp -p 27015:27015/udp -p 27020:27020/udp -p 26900:26900/udp --name cs16 \
    -e SERVER_NAME="My CS 1.6 Server" -e MAP=de_aztec -e MAXPLAYERS=16 -e ADMIN_STEAM=0:1:12345 paschi/cs16
```

| Environment Variable | Default Value | Description                                         |
| -------------------- | ------------- | --------------------------------------------------- |
| SERVER_NAME          | CS 1.6 Server | Name of the server.                                 |
| MAP                  | de_dust2      | Start map.                                          |
| MAXPLAYERS           | 24            | Maximum number of players.                          |
| ADMIN_STEAM          | -             | Steam ID of the server admin (format: `0:1:12345`). |
| SV_PASSWORD          | -             | Server password.                                    |
| RCON_PASSWORD        | -             | RCON password.                                      |

For a full list of supported variables and their default values, see [docker-entrypoint.sh](https://github.com/paschi/cs16-docker/blob/main/docker-entrypoint.sh).
