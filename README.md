# kube-ops-view

A deployment of the awesome https://github.com/hjacobs/kube-ops-view.git.

I really like the nice and simple visualisation of what's going on with pods / nodes in a Kubernetes cluster.

---

## Configuration

The .yaml files are adjusted from the originals here: https://github.com/hjacobs/kube-ops-view/tree/master/deploy through `kustomize` to enable CI, with the following tweaks:

- Updated host & annotations in ingress
- Created certificate
- Add annotations for basic auth (https://kubernetes.github.io/ingress-nginx/examples/auth/basic/)

Note that OAuth login is supported: https://github.com/hjacobs/kube-ops-view/blob/master/docs/access-control.rst.

---

## Installation

Apply the yaml in `bootstrap/` (once), then, with an appropriate context configured ...

```sh
export HOSTNAME=<your-url>
export USERNAME=<your-username>
export PASSWORD=<your-password>
./deploy.sh
```

It should then be available via https://$HOSTNAME/, or you can `kubectl proxy`.

## Usage

https://$HOSTNAME/#scale=2.0 makes it slightly easier to read.

The search bar at the top can be used to filter by name, namespace, and label.

## To Do

- [ ] Some smoke tests
