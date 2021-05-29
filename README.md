# kube-ops-view

A deployment of the awesome [kube-ops-view](https://github.com/hjacobs/kube-ops-view.git).

I really like the nice and simple visualisation of what's going on with pods / nodes in a Kubernetes cluster. Note though that my experience of this is it does not handle large clusters too well - we run 100+ nodes at work at it just times out Might be something to look at if I knew a little more Node :)

---

## To Do

- [ ] Remove need for envsubst
- [ ] Smoke tests

---

## Configuration

The .yaml files are adjusted from [the originals here](https://github.com/hjacobs/kube-ops-view/tree/master/deploy) with `kustomize` to enable CI, and the following tweaks:

- Updated host & annotations in ingress
- Created certificate
- [Add annotations for basic auth](https://kubernetes.github.io/ingress-nginx/examples/auth/basic/)

Note that [OAuth login](https://github.com/hjacobs/kube-ops-view/blob/master/docs/access-control.rst) is supported.

---

## Installation

As a highly privileged account:

```sh
cd bootstrap/
kubectl apply -f namespace.yaml
kubectl apply -f ClusterRole.yaml
kubectl apply -f ClusterRoleBinding.yaml
```

Deployment then runs via CI, which executes the equivalent of:

```sh
export HOSTNAME=<your-url>
export USERNAME=<your-username>
export PASSWORD=<your-password>
./deploy.sh
```

It should then be available via `https://$HOSTNAME/`, or you can `kubectl proxy` to it of course.

## Usage

Adding `https://$HOSTNAME/#scale=2.0` makes it slightly easier to read.

The search bar at the top can be used to filter by name, namespace, and label.

## To Do

- [ ] Some smoke tests
- [ ] Look into OAuth
- [ ] Dashboard
