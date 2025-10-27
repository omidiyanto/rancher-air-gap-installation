# RANCHER 2.12.3 
## Steps
1) create namespace cattle-system
    ```bash
    kubectl create ns cattle-system
    ```
2) create tls-ca secret menggunakan cacerts.pem
    ```bash
    kubectl -n cattle-system create secret generic tls-ca --from-file=cacerts.pem
    ```
3) create regcred secret di namespace cattle-system
    ```bash
    kubectl create secret docker-registry regcred -n cattle-system \
    --docker-server=registry.omidiyanto.local \
    --docker-username=developer \
    --docker-password='Passw0rd'
    ```
4) create certificate using cert-manager
    ```bash
    kubectl apply -f cert.yaml
    ```
--------------------------------------------------------------------

## LOCAL INSTALLATION
```bash
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.omidiyanto.local \
  --set ingress.tls.source=secret \
  --set privateCA=true \
  --set rancherImage=registry.omidiyanto.local/rancher/rancher \
  --set systemDefaultRegistry=registry.omidiyanto.local \
  --set useBundledSystemChart=true \
  --set imagePullSecrets[0].name=regcred \
  --set agentTLSMode=system-store \
  --set replicas=1 \
  --set bootstrapPassword='h4XbphnMAfvDU9nwVQ6'
```
----------------------------------------------------------------------
## ONLINE INSTALLATION
```bash
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.omidiyanto.local \
  --set ingress.tls.source=secret \
  --set privateCA=true \
  --set agentTLSMode=system-store \     
  --set replicas=1 \
  --kube-version 1.33.5
```

