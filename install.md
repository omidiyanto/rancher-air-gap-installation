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
    --docker-username=admin \
    --docker-password='Omidiyanto!88' \
    ```
4) create certificate using cert-manager
    ```
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
    name:  tls-rancher-ingress
    namespace: cattle-system
    spec:
    secretName: tls-rancher-ingress
    duration: 2160h
    renewBefore: 360h
    privateKey:
        algorithm: RSA
        size: 4096
    commonName: rancher.omidiyanto.local
    dnsNames:
        - rancher.omidiyanto.local
    issuerRef:
        name: vault-cluster-issuer
        kind: ClusterIssuer
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
  --kube-version 1.33.5 
```
Image Used:
```
registry.omidiyanto.local/rancher/rancher:v2.12.3
registry.omidiyanto.local/rancher/shell:v0.5.0
registry.omidiyanto.local/rancher/shell:v0.5.0
registry.omidiyanto.local/rancher/fleet:v0.13.4
registry.omidiyanto.local/rancher/fleet-agent:v0.13.4
registry.omidiyanto.local/rancher/rancher-webhook:v0.8.3
registry.omidiyanto.local/rancher/system-upgrade-controller:v0.16.3
registry.omidiyanto.local/rancher/mirrored-cluster-api-controller:v1.10.2
registry.omidiyanto.local/rancher/kubectl:v1.33.1
registry.omidiyanto.local/rancher/rancher-agent:v2.12.3
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
Image Used:
```
rancher/rancher:v2.12.3
rancher/shell:v0.5.0
rancher/shell:v0.5.0
rancher/fleet:v0.13.4
rancher/fleet-agent:v0.13.4
rancher/rancher-webhook:v0.8.3
rancher/system-upgrade-controller:v0.16.3
rancher/mirrored-cluster-api-controller:v1.10.2
rancher/kubectl:v1.33.1
rancher/rancher-agent:v2.12.3

MONITORING:
rancher/kubelr-kubectl:v5.0.0
rancher/mirrored-ingress-nginx-kube-webhook-certgen:v1.5.1
rancher/pushprox-client:v0.1.5-rancher2-client
rancher/pushprox-proxy:v0.1.5-rancher2-proxy
rancher/appco-k8s-sidecar:1.30.7-11.3
rancher/mirrored-grafana-grafana:11.5.5
rancher/mirrored-library-nginx:1.27.2-alpine
rancher/mirrored-kube-state-metrics-kube-state-metrics:v2.15.0
rancher/mirrored-prometheus-operator-prometheus-operator:v0.80.1
rancher/mirrored-prometheus-adapter-prometheus-adapter:v0.12.0
rancher/mirrored-prometheus-node-exporter:v1.9.0
rancher/mirrored-prometheus-operator-prometheus-config-reloader:v0.80.1
rancher/mirrored-prometheus-alertmanager:v0.28.1
rancher/prom-prometheus:v3.2.1
rancher/mirrored-library-nginx:1.27.2-alpine



PROVISION RKE2:
rancher/hardened-addon-resizer:1.8.23-build20250909
rancher/hardened-calico:v3.30.3-build20250909
rancher/hardened-cluster-autoscaler:v1.10.2-build20250909
rancher/hardened-cni-plugins:v1.8.0-build20250909
rancher/hardened-coredns:v1.12.3-build20250909
rancher/hardened-dns-node-cache:1.26.0-build20250909
rancher/hardened-etcd:v3.5.21-k3s1-build20250910
rancher/hardened-flannel:v0.27.3-build20250901
rancher/hardened-k8s-metrics-server:v0.8.0-build20250909
rancher/hardened-kubernetes:v1.33.5-rke2r1-build20250910
rancher/hardened-multus-cni:v4.2.2-build20250909
rancher/hardened-multus-dynamic-networks-controller:v0.3.7-build20250711
rancher/hardened-multus-thick:v4.2.2-build20250909
rancher/hardened-whereabouts:v0.9.2-build20250909
rancher/harvester-cloud-provider:v0.2.4
rancher/harvester-csi-driver:v0.2.3
rancher/klipper-helm:v0.9.8-build20250709
rancher/klipper-lb:v0.4.13
rancher/mirrored-calico-apiserver:v3.30.3
rancher/mirrored-calico-cni:v3.30.3
rancher/mirrored-calico-csi:v3.30.3
rancher/mirrored-calico-ctl:v3.30.3
rancher/mirrored-calico-envoy-gateway:v3.30.3
rancher/mirrored-calico-goldmane:v3.30.3
rancher/mirrored-calico-kube-controllers:v3.30.3
rancher/mirrored-calico-node-driver-registrar:v3.30.3
rancher/mirrored-calico-node:v3.30.3
rancher/mirrored-calico-operator:v1.38.6
rancher/mirrored-calico-pod2daemon-flexvol:v3.30.3
rancher/mirrored-calico-typha:v3.30.3
rancher/mirrored-calico-whisker-backend:v3.30.3
rancher/mirrored-calico-whisker:v3.30.3
rancher/mirrored-cilium-certgen:v0.2.4
rancher/mirrored-cilium-cilium-envoy:v1.34.4-1754895458-68cffdfa568b6b226d70a7ef81fc65dda3b890bf
rancher/mirrored-cilium-cilium:v1.18.1
rancher/mirrored-cilium-clustermesh-apiserver:v1.18.1
rancher/mirrored-cilium-hubble-relay:v1.18.1
rancher/mirrored-cilium-hubble-ui-backend:v0.13.2
rancher/mirrored-cilium-hubble-ui:v0.13.2
rancher/mirrored-cilium-operator-aws:v1.18.1
rancher/mirrored-cilium-operator-azure:v1.18.1
rancher/mirrored-cilium-operator-generic:v1.18.1
rancher/mirrored-cloud-provider-vsphere-csi-release-driver:v3.5.0
rancher/mirrored-cloud-provider-vsphere-csi-release-syncer:v3.5.0
rancher/mirrored-cloud-provider-vsphere:v1.33.0
rancher/mirrored-ingress-nginx-kube-webhook-certgen:v1.6.2
rancher/mirrored-kube-vip-kube-vip-iptables:v0.8.7
rancher/mirrored-library-busybox:1.36.1
rancher/mirrored-library-traefik:3.3.6
rancher/mirrored-longhornio-csi-attacher:v3.2.1
rancher/mirrored-longhornio-csi-node-driver-registrar:v2.3.0
rancher/mirrored-longhornio-csi-provisioner:v2.1.2
rancher/mirrored-longhornio-csi-resizer:v1.2.0
rancher/mirrored-pause:3.6
rancher/mirrored-sig-storage-csi-attacher:v4.8.1
rancher/mirrored-sig-storage-csi-node-driver-registrar:v2.13.0
rancher/mirrored-sig-storage-csi-provisioner:v4.0.1
rancher/mirrored-sig-storage-csi-resizer:v1.12.0
rancher/mirrored-sig-storage-csi-snapshotter:v8.2.0
rancher/mirrored-sig-storage-livenessprobe:v2.15.0
rancher/mirrored-sig-storage-snapshot-controller:v8.2.0
rancher/nginx-ingress-controller:v1.12.6-hardened1
rancher/rke2-cloud-provider:v1.33.4-rc1.0.20250814212538-148243c49519-build20250908
rancher/rke2-runtime:v1.33.5-rke2r1
rancher/system-agent:v0.3.13-suc

```