# logseq-rdf-export-docker

A docker image to export logseq graphs into rdf

## Description

This repository uses the code provided by https://github.com/logseq/rdf-export to export a
configurable portion of a Logseq graph to [RDF](https://www.w3.org/RDF/).

## Usage

A docker image is available on [Dockerhub](https://hub.docker.com/r/mathiasvda/logseq-rdf-export)

Example usage:

```sh
$ docker run -it -v <path-to-logseq-graph-directory>:/data /mathiasvda/logseq-rdf-export logseq-rdf-export docs.ttl
```

### Gitlab

[GitLab](https://gitlab.com/) also allows to automate actions, similar to GitHub. Below is an example [.gitlab-ci.yml](https://docs.gitlab.com/ee/ci/) file that uses the Docker image of logseq-export-rdf. The example also includes a step on how to publish the logseq documentation to GitLab pages using the [logseq-publish-spa](https://github.com/logseq/publish-spa) library.

```yml
stages:
  - rdf
  - pages

rdf:
  image:
    name: mathiasvda/logseq-rdf-export
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  stage: rdf
  script:
    - logseq-rdf-export notes.ttl
  artifacts:
    paths:
      - notes.ttl

pages:
  image:
    name: ghcr.io/l-trump/logseq-publish-spa:alpine
    entrypoint: ["/bin/sh", "-c"]
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  stage: pages
  environment: live
  script:
    - mkdir -p public
    - node /opt/logseq-publish-spa/publish_spa.mjs $CI_PROJECT_DIR/public --static-directory /opt/logseq-static --directory $CI_PROJECT_DIR --theme-mode $THEME --accent-color $ACCENT_COLOR
  artifacts:
    paths:
      - public
```

## Configuration

To configure how and what is exported to RDF, create a `.rdf-export/config.edn`
file in your graph's directory. It's recommended to configure the `:base-url`
key so that urls point to your Logseq graph. To configure what is exported,
knowledge of [advanced
queries](https://docs.logseq.com/#/page/advanced%20queries) is required. See
[the config
file](https://github.com/logseq/rdf-export/blob/main/src/logseq/rdf_export/config.cljs)
for the full list of configuration keys.

## LICENSE

See LICENSE.md
