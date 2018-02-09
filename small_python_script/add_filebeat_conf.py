#!/usr/bin/env python
#-*- encoding:utf-8 -*-
#write by weiye in 2018.02.08


import os
import sys
import yaml
import commands
import subprocess
from io import StringIO


# -----------------------
# 
# 请根据项目情况设置.
#
# -----------------------

project_name = "caimi-quark-api"

monitor_log_dir = "/data/quark-api/bin/logs"

monitor_log_paths = '["%s/restController.log","%s/qaurkapi.log","%s/qaurkapi.error.log"]'%(monitor_log_dir,monitor_log_dir,monitor_log_dir)


# ELK offline redis
#redis_hosts = '["10.19.64.69:6379", "10.19.64.70:6379", "10.19.64.71:6379"]'

# ELK online redis
redis_hosts = '["10.19.64.108:6379", "10.19.64.109:6379", "10.19.64.110:6379"]'

redis_key = "filebeat-java"


# ----------------------
#
# Filebeat 配置, 如Filebeat是按标准安装，
# 一般不做更改
#
# ----------------------

filebeat_install_home = "/opt/platform/filebeat"

filebeat_conf_path = filebeat_install_home + "/conf"

filebeat_startup_script = filebeat_install_home + "/start.sh"


# -----------------------
# 
# Filebeat配置文件模板，一般不做更改!
#
# -----------------------


yaml_template = u'''
filebeat.prospectors:
- input_type: log
  paths: %s
  encoding: plain
  document_type: %s
  multiline.pattern: ^[0-9]
  multiline.negate: true
  multiline.match: after

filebeat.registry_file: ${path.data}/registry-%s

output.redis:
  hosts: %s
  key: %s
  datatype: list
  loadbalance: true
'''


# -----------------------
#
# Functions
#
# -----------------------

def xprint(message,color):

    print("<font color='%s'>%s</font>"%(color,message))

# -----------------------
# 
# Main
#
# -----------------------


# Verify filebeat is installed as standard

if not os.path.exists(filebeat_conf_path) or not os.path.exists(filebeat_startup_script):
    xprint("filebeat is not installed according to standard methods!!!","red")
    sys.exit(1)


# Create filebeat config file for this project

project_conf_file = "%s/%s.yml"%(filebeat_conf_path,project_name) 

if os.path.exists(project_conf_file):
    xprint("%s is already exists,quit!"%project_conf_file,"red")
    sys.exit(1)
else:
    instance_yaml = yaml_template%(monitor_log_paths,project_name,project_name,redis_hosts,redis_key)
    f = StringIO(instance_yaml)
    middle_data = yaml.load(f)
    o = open(project_conf_file,"w")
    yaml.dump(middle_data,o)


# Write startup item to filebeat start script

if commands.getstatusoutput("grep -rl %s %s"%(project_name,filebeat_startup_script))[0] == 0:
    xprint("already exists startup item for %s in %s"%(project_name,filebeat_startup_script),"red")
    sys.exit(1)
else:

    if commands.getstatusoutput("echo '%s/filebeat -c %s &' >> %s"%(filebeat_install_home,project_conf_file,filebeat_startup_script))[0] == 1:
        xprint("Write startup item to filebeat start script fail!!!","red")
        sys.exit(1)


xprint("add filebeat config for %s success!!!!!!"%(project_name),"green")

# Startup filebeat item for this project

subprocess.Popen("%s/filebeat -c %s &"%(filebeat_install_home,project_conf_file),shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)



