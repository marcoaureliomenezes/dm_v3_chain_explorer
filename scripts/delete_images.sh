#!/bin/bash


# Delete all images

docker rmi $(docker images -q)