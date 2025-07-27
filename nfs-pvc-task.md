Create a deployment that mounts a persistent volume using NFS for a sample application (`details_app`) inside your K8s cluster. Verify the following:

- You've defined and mounted an NFS-based PersistentVolume (PV) and PersistentVolumeClaim (PVC)
- The `details_app` pod can read/write to the mounted path
- Your deployment uses 2 replicas
- The application runs correctly and is accessible

Once you're done:
- Delete one of the pods and verify that the new pod automatically mounts the NFS volume and retains the data
