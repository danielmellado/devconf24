#!/usr/bin/env bash

#################################
# include the -=magic=-
# you can pass command line args
#
# example:
# to disable simulated typing
# . ../demo-magic.sh -d
#
# pass -h to see all options
#################################
. ./demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
#DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
DEMO_PROMPT="${GREEN}➜ ${CYAN}\h ${COLOR_RESET}"

# text color
# DEMO_CMD_COLOR=$BLACK

# hide the evidence
clear

p "make run-on-kind"
cat kind_ebpf.txt

p "cat examples/config/base/go-xdp-counter/bytecode.yaml"
cat "bytecode.yaml"

p "kubectl apply -f examples/config/base/go-xdp-counter/bytecode.yaml"
echo "xdpprogram.bpfman.io/go-xdp-counter-example created"

p "kubectl get xdpprograms"
cat <<EOF
NAME                     BPFFUNCTIONNAME   NODESELECTOR   STATUS
go-xdp-counter-example   xdp_stats         {}             ReconcileSuccess
EOF

p "kubectl get xdpprograms go-xdp-counter-example -o yaml"
cat <<EOF
apiVersion: bpfman.io/v1alpha1
kind: XdpProgram
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"bpfman.io/v1alpha1","kind":"XdpProgram","metadata":{"annotations":{},"labels":{"app.kubernetes.io/name":"xdpprogram"},"name":"go-xdp-counter-example"},"spec":{"bpffunctionname":"xdp_stats","bytecode":{"image":{"url":"quay.io/bpfman-bytecode/go-xdp-counter:latest"}},"interfaceselector":{"primarynodeinterface":true},"nodeselector":{},"priority":55}}
  creationTimestamp: "2024-06-12T22:43:48Z"
  finalizers:
  - bpfman.io.operator/finalizer
  generation: 2
  labels:
    app.kubernetes.io/name: xdpprogram
  name: go-xdp-counter-example
  resourceVersion: "3267"
  uid: cbe0afc3-e1d0-4fc6-907d-723a75c28db8
spec:
  bpffunctionname: xdp_stats
  bytecode:
    image:
      imagepullpolicy: IfNotPresent
      url: quay.io/bpfman-bytecode/go-xdp-counter:latest
  interfaceselector:
    primarynodeinterface: true
  mapownerselector: {}
  nodeselector: {}
  priority: 55
  proceedon:
  - pass
  - dispatcher_return
status:
  conditions:
  - lastTransitionTime: "2024-06-12T22:44:08Z"
    message: bpfProgramReconciliation Succeeded on all nodes
    reason: ReconcileSuccess
    status: "True"
    type: ReconcileSuccess
EOF

p "kubectl get bpfprograms"
cat <<EOF
NAME                                                          TYPE   STATUS         AGE
go-xdp-counter-example-bpfman-deployment-control-plane-eth0   xdp    bpfmanLoaded   50s
EOF

p "kubectl get all -n bpfman"
cat <<EOF
NAME                                   READY   STATUS    RESTARTS   AGE
pod/bpfman-daemon-5fffk                3/3     Running   0          46m
pod/bpfman-operator-7f67bc7c57-vqn5l   2/2     Running   0          46m

NAME                                                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/bpfman-controller-manager-metrics-service   ClusterIP   10.96.118.56   <none>        8443/TCP   46m

NAME                           DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/bpfman-daemon   1         1         1       1            1           <none>          46m

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/bpfman-operator   1/1     1            1           46m

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/bpfman-operator-7f67bc7c57   1         1         1       46m
EOF

p "kubectl get crd"
cat <<EOF
NAME                           CREATED AT
bpfprograms.bpfman.io          2024-06-12T22:42:41Z
fentryprograms.bpfman.io       2024-06-12T22:42:41Z
fexitprograms.bpfman.io        2024-06-12T22:42:41Z
kprobeprograms.bpfman.io       2024-06-12T22:42:41Z
tcprograms.bpfman.io           2024-06-12T22:42:41Z
tracepointprograms.bpfman.io   2024-06-12T22:42:41Z
uprobeprograms.bpfman.io       2024-06-12T22:42:41Z
xdpprograms.bpfman.io          2024-06-12T22:42:41Z
EOF

p ""
