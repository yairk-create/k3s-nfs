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

Create a deployment (`details_app`) that uses an NFS-based PersistentVolume with the following:

- Uses an `nginx` container
- Mounted to `/usr/share/nginx/html`
- Shared volume created via NFS
- Two replicas in deployment
- Test persistence by deleting one pod and confirming recovery with data intact

---

## 🚀 K3s Deployment

### 1. Apply K3s Resources

```bash
chmod +x install.sh
./install.sh
```

This script will:

- Create a namespace called `voltask`
- Apply the NFS-based PV and PVC
- Deploy the nginx app with 2 replicas

### 2. Validate

```bash
kubectl get pods -n voltask
kubectl get pvc -n voltask
kubectl describe pod <pod-name> -n voltask
```

Delete a pod and verify data persists:

```bash
kubectl delete pod <one-pod-name> -n voltask
```

---

## 🧱 NFS Server Setup (K3s Compatible)

Use the provided script to configure an NFS server on your K3s host or a reachable node:

### 1. Run NFS setup

```bash
chmod +x setup-nfs.sh
sudo ./setup-nfs.sh
```

This will:

- Install `nfs-kernel-server` (if needed)
- Create the directory `/srv/nfs/shared`
- Add an `index.html` to test access
- Export the share to all clients
- Restart the NFS service

Make sure your K3s nodes can access the NFS server via the same network.

---

## 🔒 Notes

- You may need to modify `pv.yaml` with your actual NFS server IP and export path.
- This example uses `ReadWriteMany`, which requires an NFS or similar shared backend.
- K3s supports NFS natively when using appropriate mount options.

---

## ✅ Done!

You now have:

- A working K3s Deployment using NFS
- Pod recovery with persistent shared storage
- Scripts to install both NFS and workload resources

Want to extend this with monitoring or turn it into a Helm chart? Just ask.
