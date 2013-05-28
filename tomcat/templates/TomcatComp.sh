#!/bin/sh
erb -P -x -T '-' TomcatEnviromentVars.erb | ruby -c
