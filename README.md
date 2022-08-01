# Helm Runner

Makes it easy to run helm commands as part of your workflows.

## Usage

Convert your `KUBECONFIG` to base64 (i.e. `cat path/to/kubeconfig.yaml | base64`), and add it as a GitHub secret. Then add the below as a step in your workflow and modify it to meet your needs.

This is an example that builds an image, tags it as the branch and SHA, and deploys the SHA to an environment:

```
name: Build and release

on:
  push:
    branches: ['main']

env:
  REGISTRY: ghcr.io
  # The below is just to ensure lowercase image repos/names (i.e. if your org name is "My-Cool-Org" this should be "my-cool-org"). You can also use the `${{ github.* }}` variables if your repo is already lowerscase.
  IMAGE_NAME: your-org-or-user/your-repo

jobs:
  build-release:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Log in to the Container registry
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Get short SHA
        id: get_sha
        run: echo "::set-output name=sha::$(git rev-parse --short HEAD)"

      - name: Extract metadata (tags, labels) for Docker
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=sha

      - name: Build and push Docker image
        uses: docker/build-push-action@v3
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}

      - name: Deploy SHA to my-env environment
        uses: ordo-schools/helm-runner@v3
        env:
          BASE64_KUBECONFIG: "${{ secrets.MY_ENV_KUBECONFIG }}"
        with:
          # Assumes your current repo houses your helm chart, and that there are env-specific values available to apply alongside the `--set` flag.
          args: helm upgrade --install -f values/my-chart-env.yaml --set image.tag=sha-${{ steps.get_sha.outputs.sha }} my-release ./path/to/my-chart --wait
```
