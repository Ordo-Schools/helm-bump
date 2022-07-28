# Helm Bump

Very explicitly sets the provided **key/value** on the provided **helm release** in the configured **kubernetes cluster** for the provided **package** via the provided **private github repo** with `helm upgrade --install --set KEY=VALUE RELEASE REPO/PACKAGE`. Mostly used to bump helm chart `image.tag` versions after building new docker images as part of CI/CD workflows.

## Usage

```
docker run -ti --rm ghcr.io/ordo-schools/helm-bump my-release my-github-org/my-package image.tag v0.1.0 $GITHUB_TOKEN $(cat path/to/kubeconfig.yaml | base64 -w 0)
```

The above will install or upgrade your release called `my-release` in the cluster by calling `helm upgrade` against the `my-github-org/my-package` chart and setting `my.image.tag=v0.1.0`.

This is how you can use it in a github action:

Convert your `KUBECONFIG` to base64 (i.e. `cat path/to/kubeconfig.yaml | base64`), and add it as a GitHub secret. Then add the below as a step in your workflow and modify it to meet your needs.

```
      - name: Deploy testing
        uses: ordo-schools/helm-bump@v1
        with:
          release: my-release
          package: my-github-org/my-package
          key: image.tag
          value: my-version-tag
          token: ${{ secrets.GITHUB_TOKEN }}
          kubeconfig: ${{ secrets.MY_BASE64_KUBECONFIG }}
```
