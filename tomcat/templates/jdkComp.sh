#!/bin/sh
erb -P -x -T '-' JdkEnviromentVars.erb | ruby -c
