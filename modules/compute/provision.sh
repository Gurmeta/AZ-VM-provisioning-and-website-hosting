#!/bin/bash

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Update packages and install dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Download the official GPG key securely
curl -fsSLo kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
gpg --no-default-keyring --keyring ./kubernetes-archive-keyring.gpg --fingerprint

# Verify the fingerprint manually (check against Kubernetes official docs)
# If it matches, move the keyring
sudo mv kubernetes-archive-keyring.gpg /usr/share/keyrings/

# Add the Kubernetes repo securely
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists and install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#install Git for GitCLI usage in the pipelines
sudo apt-get install -y git


# Install Apache2
sudo apt-get install -y apache2

# Replace the default Apache2 webpage with a custom HTML page
sudo bash -c 'cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Georgi Stefanov - DevOps Engineer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #1e1e2e;
            color: #ffffff;
            text-align: center;
        }
        header {
            background-color: #282a36;
            padding: 20px;
            font-size: 24px;
            font-weight: bold;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #2e2f3e;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
        }
        h1 {
            color: #50fa7b;
        }
        p {
            font-size: 18px;
        }
        .skills {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        .skill {
            background: #44475a;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
        }
        footer {
            margin-top: 50px;
            padding: 10px;
            background-color: #282a36;
        }
    </style>
</head>
<body>
    <header>Georgi Stefanov - DevOps Engineer</header>
    <div class="container">
        <h1>Welcome to My DevOps Portfolio</h1>
        <p>I am a passionate DevOps Engineer specializing in cloud infrastructure, automation, and CI/CD pipelines.</p>
        
        <h2>Skills</h2>
        <div class="skills">
            <div class="skill">Terraform</div>
            <div class="skill">Kubernetes</div>
            <div class="skill">Azure Cloud</div>
            <div class="skill">Docker</div>
            <div class="skill">CI/CD Pipelines</div>
            <div class="skill">Monitoring & Logging</div>
        </div>
    </div>
    <footer>
        &copy; 2025 Georgi Stefanov | DevOps Enthusiast
    </footer>
</body>
</html>

EOF'

# Restart Apache2 to apply changes
sudo systemctl restart apache2