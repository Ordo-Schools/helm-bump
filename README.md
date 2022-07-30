# Helm Bump

Very explicitly sets the provided **key/value** on the provided **helm release** in the configured **kubernetes cluster** for the provided **helm chart** via the provided **private github repo**. Mostly used to bump helm chart `image.tag` versions after building new docker images as part of CI/CD workflows.

## Usage

```
docker run -ti --rm ghcr.io/ordo-schools/helm-bump https://raw.githubusercontent.com/my-org/my-repo/path/to/my-chart my-release my-chart image.tag 0.1.0 $GITHUB_TOKEN $(cat path/to/kubeconfig.yaml | base64 -w 0)
```

The above will upgrade your release called `my-release` in the cluster configured by the provided kubeconfig, by calling `helm upgrade` against the `https://raw.githubusercontent.com/my-org/my-repo/path/to/my-chart` chart and setting `--set image.tag=0.1.0`.

This is how you can use it in a github action:

Convert your `KUBECONFIG` to base64 (i.e. `cat path/to/kubeconfig.yaml | base64`), and add it as a GitHub secret. Then add the below as a step in your workflow and modify it to meet your needs.

```
      - name: Deploy via helm-bump
        uses: ordo-schools/helm-bump@v1
        with:
          repository: https://raw.githubusercontent.com/my-org/my-repo/path/to/my-chart
          release: my-release
          package: my-chart
          key: image.tag
          value: 0.1.0
          kubeconfig: ${{ secrets.MY_BASE64_KUBECONFIG }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
```
