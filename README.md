# Helm Runner

Makes it easy to run helm commands as part of your workflows.

## Usage

Convert your `KUBECONFIG` to base64 (i.e. `cat path/to/kubeconfig.yaml | base64`), and add it as a GitHub secret. Then add the below as a step in your workflow and modify it to meet your needs.

```
jobs:
  ...
    steps:
      ...
      - name: Deploy via helm-runner
        uses: ordo-schools/helm-runner@main
        run: helm upgrade --install my-release my-repo/my-chart
        env:
          BASE64_KUBECONFIG: ${{ secrets.MY_BASE64_KUBECONFIG }}
```
