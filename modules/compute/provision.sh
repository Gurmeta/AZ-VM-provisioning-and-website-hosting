#!/bin/bash
# First-boot provisioning for the Ubuntu 24.04 VM (executed as root by cloud-init).
# Installs: Azure CLI, kubectl, git and Apache2 serving a static landing page.
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
KUBECTL_MINOR="v1.31" # Kubernetes apt repo channel; bump deliberately.

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release git apache2

install -m 0755 -d /etc/apt/keyrings

# --- Azure CLI (Microsoft apt repository, signed-by keyring) -----------------
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
chmod 0644 /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
  > /etc/apt/sources.list.d/azure-cli.list

# --- kubectl (official pkgs.k8s.io repository, signed-by keyring) ------------
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR}/deb/Release.key" \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 0644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR}/deb/ /" \
  > /etc/apt/sources.list.d/kubernetes.list

apt-get update -y
apt-get install -y azure-cli kubectl

# --- Landing page -------------------------------------------------------------
# Quoted 'EOF' prevents the shell from expanding anything inside the page.
cat > /var/www/html/index.html <<'EOF'
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
    <main class="container">
        <h1>Welcome to My DevOps Portfolio</h1>
        <p>I am a passionate DevOps Engineer specializing in cloud infrastructure, automation, and CI/CD pipelines.</p>

        <h2>Skills</h2>
        <div class="skills">
            <div class="skill">Terraform</div>
            <div class="skill">Kubernetes</div>
            <div class="skill">Azure Cloud</div>
            <div class="skill">Docker</div>
            <div class="skill">CI/CD Pipelines</div>
            <div class="skill">Monitoring &amp; Logging</div>
        </div>
    </main>
    <footer>
        &copy; 2025 Georgi Stefanov | DevOps Enthusiast
    </footer>
</body>
</html>
EOF

systemctl enable apache2
systemctl restart apache2
