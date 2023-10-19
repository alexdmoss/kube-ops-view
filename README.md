# kube-ops-view

A deployment of the awesome [kube-ops-view](https://github.com/hjacobs/kube-ops-view.git).

I really like the nice and simple visualisation of what's going on with pods / nodes in a Kubernetes cluster. Note though that my experience of this is it does not handle large clusters too well - we run 100+ nodes at work at it just times out (have not investigated further)

---

## To Do

- [ ] Convert to using IAP with Gateway
- [ ] Clean up yaml / bootstrap
- [ ] Remove need for envsubst

---

## Configuration

The .yaml files are adjusted from [the originals here](https://github.com/hjacobs/kube-ops-view/tree/master/deploy) with `kustomize` to enable CI.

### Authentication

Basic Auth has been replaced with Google's Identity Aware Proxy across my shared `Gateway`. If looking for that config, look at commits before October 2023.

Set up has been done manually for now - may revisit this later. General gist is:

- Enable IAP via the Console
- find the Backend Service for this workload in the IAP panel and toggle IAP to On. _This should create a credential in [API Credentials](https://console.cloud.google.com/apis/credentials) automatically_
- Within the credential that's automatically created:
  - Copy the client ID from the credential that's created into `ingress.yaml` - `GCPBackendPolicy`
  - Create a secret from the client secret, and make sure the name matches up - `kubectl create secret generic iap-client --from-file=iap-secret.txt`
- Apply the `GCPBackendPolicy`

---

## Usage

Adding `https://$HOSTNAME/#scale=2.0` makes it slightly easier to read.

The search bar at the top can be used to filter by name, namespace, and label.
