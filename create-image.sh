#!/bin/bash

# TODO: name from arg

hcloud server create-image image-base --type snapshot --description "Oracle Linux 7.9"
