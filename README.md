[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![Tests](https://github.com/julienloizelet/ddev-portainer/actions/workflows/tests.yml/badge.svg)](https://github.com/julienloizelet/ddev-portainer/actions/workflows/tests.yml)
[![last commit](https://img.shields.io/github/last-commit/julienloizelet/ddev-portainer)](https://github.com/julienloizelet/ddev-portainer/commits)
[![release](https://img.shields.io/github/v/release/julienloizelet/ddev-portainer)](https://github.com/julienloizelet/ddev-portainer/releases/latest)

# ddev-portainer

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Introduction](#introduction)
- [Installation](#installation)
- [Basic usage](#basic-usage)
- [Contribute](#contribute)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

[Portainer](https://www.portainer.io/) is a toolset that allows you to easy manage containers in Docker.

This DDEV add-on allows you to use [Portainer Community Edition (CE)](https://docs.portainer.io/#about-portainer) in a separate `portainer` service.


## Installation


```sh
ddev add-on get julienloizelet/ddev-portainer && ddev restart
```

## Basic usage

Once ddev has been restarted, you can access the Portainer GUI by running `ddev portainer`.
 
If this is your first access, create your user:

![create user](images/create-user.jpg)



Click the `Getting started` link and start using the Portainer GUI.

For more information, please read the [official documentation](https://docs.portainer.io/user/home).

## Contribute

Anyone is welcome to submit a PR to this repo.


**Contributed and maintained by [julienloizelet](https://github.com/julienloizelet)**

**Originally Contributed by [@davidjguru](https://github.com/davidjguru) in [ddev-contrib](https://github.com/ddev/ddev-contrib/tree/master/docker-compose-services/portainer)**

