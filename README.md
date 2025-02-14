# 🚀 Azure VM Provisioning Toolkit

**Automate Azure Virtual Machine Deployments with Terraform & Bash**\
*Infrastructure as Code meets Web Elegance*





---

## 🔍 Overview

This repository provides an automated and scalable approach to provisioning Azure Virtual Machines using Terraform. Whether you're setting up a development environment, testing configurations, or managing production workloads, this toolkit has you covered.

### **Key Features**

- 🚀 **Terraform-based Infrastructure as Code (IaC)** – Define and deploy your Azure VM stack efficiently.
- 🛠️ **Bash Automation** – Automate post-deployment configurations.
- 🌍 **Web Dashboard** – Monitor and manage deployments via a sleek HTML/CSS/JS interface.
- 🔄 **Modular & Scalable** – Easily adapt and extend for various use cases.

---

## 🌟 Why Choose This Toolkit?

### **Your Azure VM Deployment Command Center**

✅ **Terraform-Powered** – Manage Azure resources declaratively in `main.tf`.
✅ **Automated Configuration** – Utilize Bash scripts for provisioning and tuning.
✅ **Web Monitoring** – Optional dashboard for real-time status tracking.
✅ **End-to-End Deployment** – From VM creation to post-deployment automation.

---

## 🛠️ Tech Stack

| Component          | Tools Used                          |
| ------------------ | ----------------------------------- |
| **Infrastructure** | Terraform, Azure CLI, HCL           |
| **Automation**     | Bash Scripting                      |
| **Web Interface**  | HTML5, CSS3, JavaScript             |
| **DevOps**         | Git, Modular Design, Best Practices |

---

## ⚡ Quick Start Guide

### **Prerequisites**

Ensure you have the following installed and configured:

- An active **Azure account**
- **Terraform ≥ 1.0** installed
- **Azure CLI** installed and authenticated

### **Deployment in 3 Easy Steps**

1. Clone the repository:
   ```bash
   git clone https://github.com/Gurmeta/AZ-VM-Provisioning.git
   cd AZ-VM-Provisioning
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Deploy your Azure VM:
   ```bash
   terraform apply -var-file="variables.json" -auto-approve
   ```

---

## 📂 Project Structure

```
AZ-VM-Provisioning/
├── modules/               # Reusable Terraform modules
├── scripts/               # Automation scripts (Bash)
├── web-dashboard/         # Web-based monitoring UI
├── main.tf                # Terraform configuration
├── variables.tf           # Input variables
├── providers.tf           # Provider configurations
└── outputs.tf             # Output values
```

---

## 🚀 Next Steps

🔹 Customize `variables.tf` to fit your environment.\
🔹 Extend automation scripts for additional setup tasks.\
🔹 Enable monitoring using the included web dashboard.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

---

## 📜 License

This project is licensed under the MIT License. See `LICENSE` for details.

---

**Happy Coding!** 🎉

