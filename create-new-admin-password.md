```bash
kubectl -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- reset-password
```
```
W1027 06:54:10.442748     203 client_config.go:667] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
0 users were found with authz.management.cattle.io/bootstrapping=admin-user label. They are []. Can only reset the default admin password when there is exactly one user with this label
command terminated with exit code 1
```

```bash
kubectl -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- ensure-default-admin
```
```
W1027 06:54:34.570667     218 client_config.go:667] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
New default admin user (user-4qssp):
New password for default admin user (user-4qssp):
aIjCwAPMS6UiB15zM7Qg
```

Reference: https://medium.com/nerd-for-tech/ensure-having-a-rancher-admin-4ee62cd066e1 