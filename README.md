# kube-ops-view

A deployment of the awesome https://github.com/hjacobs/kube-ops-view.git.

I really like the nice and simple visualisation of what's going on with pods / nodes in a Kubernetes cluster.

---

## Configuration

The .yaml files are adjusted from the originals here: https://github.com/hjacobs/kube-ops-view/tree/master/deploy as follows:

- Namespace created, and ` namespace:` added to all relevant resources
- Updated host & annotations in ingress
- Created certificate
- Add annotations for basic auth (https://kubernetes.github.io/ingress-nginx/examples/auth/basic/)

Note that OAuth login is supported: https://github.com/hjacobs/kube-ops-view/blob/master/docs/access-control.rst.

---

## Installation

With an appropriate context configured ...

```sh
export APP_HOSTNAME=[your-external-hostname]
export NAMESPACE=[your-namespace]
./deploy.sh
```

It should then be available via https://$APP_HOSTNAME/, or you can `kubectl proxy`.

## Usage

https://$APP_HOSTNAME/#scale=2.0 makes it slightly easier to read.

The search bar at the top can be used to filter by name, namespace, and label.
