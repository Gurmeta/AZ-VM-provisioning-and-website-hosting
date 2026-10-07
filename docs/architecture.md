# Architecture

## Components

| Module | Resources | Purpose |
| --- | --- | --- |
| root | Resource group, locals (naming/tags) | Wires the modules together and owns shared inputs. |
| `modules/network` | VNet, 3 subnets (VM, AKS, App Gateway), VM public IP + NIC, VM NSG, AKS NSG | All connectivity and traffic filtering. |
| `modules/compute` | Linux VM, `provision.sh` via cloud-init | Web host with Azure CLI, kubectl and git. |
| `modules/aks` | AKS cluster, optional AGIC add-on | Kubernetes workload platform. |

Dependency flow: `network` → (`compute`, `aks`). Compute and AKS never reference each other; they only consume network outputs, so either can be removed without touching the other.

## Network layout

| Subnet | Default CIDR | Notes |
| --- | --- | --- |
| VM | `10.0.1.0/24` | NIC-level NSG: SSH from `allowed_ssh_cidrs`, HTTP/HTTPS from anywhere. |
| AKS | `10.0.2.0/24` | Subnet-level NSG: inbound TCP from `aks_allowed_inbound_ports`. Azure CNI gives each pod a VNet IP, so size this for `nodes × (max pods + 1)`. |
| Application Gateway | `10.0.3.0/24` | Dedicated; no NSG attached because App Gateway v2 requires specific management rules. Created only when `enable_agic = true`. |

Kubernetes service CIDR is `10.1.0.0/16` (DNS at `10.1.0.10`) and must not overlap the VNet.

## Traffic flow

- **Website on the VM:** Internet → Standard public IP → NIC NSG (80/443) → Apache2.
- **Administration:** Admin workstation (CIDR allow-list) → public IP → NIC NSG (22) → VM.
- **Workloads on AKS:** Internet → Application Gateway (AGIC) → pods in the AKS subnet.

## Design decisions

1. **Public subnet exposure is explicit.** SSH has no default allow-list; the variable is required and rejects `0.0.0.0/0`. Rationale: the most common cloud compromise path is an SSH port open to the world.
2. **SSH keys only.** Password authentication is disabled and the password variable was removed, so no credential can leak through state or tfvars. The key is read from a path at plan time and only the public half is used.
3. **Application Gateway in its own subnet, behind a flag.** App Gateway cannot share a subnet with AKS nodes and is the largest cost item; `enable_agic` lets a developer skip it.
4. **No `ssh` module.** It created an Azure SSH-key resource and a second resource group that nothing consumed. The VM receives the key directly.
5. **Standard SKU public IP.** The Basic SKU is being retired and Standard is secure-by-default (closed unless an NSG allows traffic) — which is why the NSG attachment is mandatory.
6. **Provisioning via signed apt repositories.** Packages are verified through apt's signed-by keyrings instead of downloading and executing remote scripts.
7. **Provider lock file committed.** Guarantees the same provider builds locally and in CI.
8. **State.** Local state by default for simplicity; `backend.tf.example` documents the Azure Storage backend for shared use.

## Known limitations and next steps

- Single VM, single region, no autoscaling or availability zones.
- The VM serves plain HTTP. Add TLS (Let's Encrypt on the VM, or a certificate on the App Gateway) before production use.
- AKS API server is publicly reachable; consider `api_server_access_profile` authorized IP ranges or a private cluster.
- Cluster autoscaler, Azure Monitor / Log Analytics and Azure Policy are not configured.
- AKS system-assigned identity may need *Network Contributor* on the AKS subnet for `LoadBalancer` services (see README).
- Not yet applied in a live subscription; run `terraform plan` and review it first.
