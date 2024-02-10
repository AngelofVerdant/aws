## VPC Provisioning YAML Configuration
This repository contains a YAML configuration file for provisioning a Virtual Private Cloud (VPC) and its associated components using infrastructure-as-code (IaC) principles.

Overview
The YAML file provided here automates the setup of a VPC within a cloud environment. It defines various components such as subnets, route tables, internet gateways, security groups, and Access Control Lists (ACLs) necessary for creating a secure and isolated network environment.

File Structure
vpc_provisioning.yaml: This is the main YAML configuration file responsible for defining the VPC and its components.
Components
VPC (Virtual Private Cloud)
The VPC serves as the foundational networking construct within the cloud environment. It allows users to create a logically isolated section of the cloud where resources can be launched in a virtual network that you define.

Subnets
Subnets are subdivisions of the VPC's IP address range in which you can place groups of isolated resources. They can be public or private, depending on whether they have internet connectivity.

Route Tables
Route tables define the rules for routing network traffic between subnets and the internet, allowing for effective communication within the VPC and with external networks.

Internet Gateway
An internet gateway allows resources within the VPC to access the internet, enabling communication with external services and resources hosted outside the VPC.

Security Groups
Security groups act as virtual firewalls for your instances to control inbound and outbound traffic. They regulate the flow of traffic to and from various resources within the VPC based on defined rules.

Access Control Lists (ACLs)
ACLs provide an additional layer of security by controlling traffic entering and exiting subnets. They can be used to allow or deny specific types of traffic based on rules defined for each subnet.
