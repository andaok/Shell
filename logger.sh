#!/bin/bash

USERNAME=logger
PASSWORD="aaaaaa"

cd /bin/
#ln -s bash rbash
useradd -s /bin/bash $USERNAME
echo "$PASSWORD" | passwd --stdin $USERNAME

mkdir /home/$USERNAME/bin/
cd /home/$USERNAME/bin/
ln -s /bin/ls ls
ln -s /bin/cat cat
ln -s /bin/more more
ln -s /bin/grep grep
ln -s /bin/awk awk
ln -s /usr/bin/sudo sudo
ln -s /usr/bin/passwd passwd
ln -s /usr/bin/less less
ln -s /usr/bin/tail tail
ln -s /usr/bin/head head
ln -s /usr/bin/tac tac

cd /home/$USERNAME
sed -i -r 's/PATH=.*/PATH=\$HOME\/bin/' .bash_profile
chown root:root .bashrc .bash_profile


# visudo
cat > /etc/sudoers.d/01_logger <<EOF
User_Alias LOGGER = $USERNAME
Cmnd_Alias LOGGER = /bin/cat /var/log/message*, /bin/more /var/log/message*, /usr/bin/less /var/log/message*, /usr/bin/tail /var/log/message*, /usr/bin/head /var/log/message*, /usr/bin/tac /var/log/message*
LOGGER  ALL=(root)  NOPASSWD: LOGGER

EOF

