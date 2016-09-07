#!/bin/bash

set -e

# Tweak bashrc
echo "export PS1='\[\e[1;32m\]\u@\w$>>\[\e[0m\] '"    >> /root/.bashrc
echo "export TERM=screen"                             >> /root/.bashrc
echo "alias ls='ls --color=auto'"                     >> /root/.bashrc

# Update environment
echo "TZ=\"Australia/Sydney\""                        >> /etc/environment 
echo "TERM=screen"                                    >> /etc/environment 
echo "export TZ=\"Australia/Sydney\""                 >> /etc/profile
echo "export TERM=screen"                             >> /etc/profile
echo "export TZ=\"Australia/Sydney\""                 >> /root/.bashrc
echo "export TERM=screen"                             >> /root/.bashrc

