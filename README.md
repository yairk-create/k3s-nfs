
# Voltask

A K3s example project to demonstrate using an NFS-backed PersistentVolume with a multi-replica deployment.

Author: **Yair Kochavi**  
Date: **27/07/2025**

---

## 📁 Project Structure

```
voltask/
├── deployment.yaml         # K3s Deployment (nginx using NFS mount)
├── install.sh              # Script to deploy manifests to K3s cluster
├── nfs-pvc-task.md         # Task description for using NFS in K3s
├── pvc.yaml                # PersistentVolumeClaim definition
├── pv.yaml                 # PersistentVolume definition (NFS)
├── setup-nfs.sh            # Bash script to set up NFS server
├── README.md               # This file
```

---

## 🧾 Project Goal

Deploy an NGINX-based app (`details_app`) using an NFS-based PersistentVolume with:

- Two replicas
- Shared mount at `/usr/share/nginx/html`
- Persistent data backed by an external NFS server
- Recovery validation by deleting one pod

---

## ⚠️ Prerequisites

Before applying the manifests:

- You must have a working K3s cluster (`kubectl` configured).
- NFS server must be reachable by all nodes in the cluster.
- Update the NFS server IP in `pv.yaml`:

```yaml
spec:
  nfs:
    server: 192.168.1.100  # ← replace with your NFS server IP
    path: /srv/nfs/shared
```

To find and replace all hardcoded IPs:

```bash
grep -rn "192.168" .
```

---

## 🚀 K3s Deployment

### Step 1: Apply Resources

```bash
chmod +x install.sh
./install.sh
```

This will:

- Create a `voltask` namespace
- Apply the PersistentVolume and PersistentVolumeClaim
- Deploy an NGINX app with 2 replicas using the shared NFS volume

### Step 2: Validate

Check resources:

```bash
kubectl get pods -n voltask
kubectl get pvc -n voltask
kubectl describe pod <pod-name> -n voltask
```

Delete one pod to validate volume persistence:

```bash
kubectl delete pod <pod-name> -n voltask
```

Then reload the new pod and verify data remains intact.

---

## 🧱 NFS Server Setup

Use the provided script to install and configure NFS on a host or VM:

### Step 1: Run setup script

```bash
chmod +x setup-nfs.sh
sudo ./setup-nfs.sh
```

This script will:

- Install `nfs-kernel-server` if missing
- Create `/srv/nfs/shared`
- Write a test `index.html` file
- Add export rules to `/etc/exports`
- Restart the NFS service

Make sure your cluster nodes can reach this server (check firewall/NAT if needed).

---

## 🔒 Notes

- The setup uses `ReadWriteMany` which is supported by NFS.
- Pods can write to the same volume concurrently.
- You must configure the correct IP and path in your PersistentVolume definition.

---

## ✅ You Now Have

- A working multi-replica K3s deployment using shared storage
- Verified pod rescheduling and data persistence
- A reusable script for NFS server provisioning

