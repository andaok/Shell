#!/usr/bin/bash
# write by weiye in 20180208

# -------------------
#
# Standardized installation of filebeat
#
# -------------------

filebeat_root_dir="/opt/platform"
filebeat_install_home="${filebeat_root_dir}/filebeat"
filebeat_conf_path="${filebeat_install_home}/conf"
filebeat_startup_script="${filebeat_install_home}/start.sh"
filebeat_stop_script="${filebeat_install_home}/stop.sh"


if [ -d ${filebeat_install_home} ]; then
   echo "${filebeat_install_home} already exists,install quit!"
   exit 1
fi


mkdir -p  ${filebeat_root_dir} && cd ${filebeat_root_dir}
wget -q http://job.quark.com/download/elk/filebeat-5.5.1-linux-x86_64.tar.gz
tar zxf filebeat-5.5.1-linux-x86_64.tar.gz
mv filebeat-5.5.1-linux-x86_64 filebeat && mkdir filebeat/conf

touch ${filebeat_startup_script} && echo "#!/bin/bash" >> ${filebeat_startup_script}  && chmod +x  ${filebeat_startup_script}

touch ${filebeat_stop_script} && echo -e '#!/bin/bash \npkill -f "filebeat -c"' >> ${filebeat_stop_script} && chmod +x ${filebeat_stop_script}

exit 0