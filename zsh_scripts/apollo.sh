SSH_ENV="$HOME/.ssh/environment"
source /apollo/env/AmazonAwsCli/bin/aws_zsh_completer.sh
   
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }  
else
    start_agent;
fi


if command -v klist > /dev/null
then
    if [ -d ~/.envimprovement ] && ! [ -e ~/.envimprovement/kinit ]
    then
        echo "this file's timestamp is used during kerberos expiration testing" > ~/.envimprovement/kinit
        touch -d "-2 hours" ~/.envimprovement/kinit
    fi
    __check_kinit() {
        if touch ~/.envimprovement/kinit-now 2>/dev/null \
            && [ ~/.envimprovement/kinit-now -nt ~/.envimprovement/kinit ]
        then
            touch -d "+1 hour" ~/.envimprovement/kinit
            if ! klist -s
            then
                echo "Your kerberos ticket has expired - please run kinit -f"
            fi
        fi
    }
fi


if command -v __check_kinit >/dev/null
then
    precmd_functions+='__check_kinit'
fi
