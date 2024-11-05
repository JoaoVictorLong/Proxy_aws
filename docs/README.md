[![Static Badge](https://img.shields.io/badge/linkedin-blue?logo=linkedin)](https://www.linkedin.com/in/joaovictorlong/)
![GitHub last commit](https://img.shields.io/github/last-commit/JoaoVictorLong/Proxy_aws)
![GitHub forks](https://img.shields.io/github/forks/JoaoVictorLong/Proxy_aws)
![GitHub Repo stars](https://img.shields.io/github/stars/JoaoVictorLong/Proxy_aws)
![Static Badge](https://img.shields.io/badge/linux-black?logo=linux)
![Static Badge](https://img.shields.io/badge/terraform-black?logo=terraform)


# Quickly Create a Server Proxy with OpenSSH

## About

This script creates an EC2 instance on AWS with a key pair, enabling an SSH tunnel that can be used as a proxy.

## How to Use

1. Configure your AWS credentials:
    ```bash
    aws configure
    ```

2. Install Terraform on your machine:
    [Terraform Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

3. Run the following command to validate and apply the Terraform configuration:
    ```bash
    terraform validate && terraform apply
    ```

4. To establish the SSH tunnel, run `./bash_bin/ssh.sh` to initiate a connection. If successful, you can run the following command:
    ```bash
    ssh -D <Chosen_Port> -f -C -q -N -i <proxy-server-key.pem> "user@host"
    ```

5. When you're finished, use the following command to clean up the resources, including the SSH keys created in the process:
    ```bash
    terraform destroy
    ```

## How It Works

This code serves as a test of Terraform’s capabilities. In the future, I plan to make improvements for better usability. Feel free to contribute or suggest improvements if you have any ideas! 😜

Note: This code was tested on Linux. If you're using Windows or macOS, you might need to make some adjustments.

## Platforms
- Linux
