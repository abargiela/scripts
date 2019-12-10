# Dependency: You need install https://github.com/tfutils/tfenv

# Usage: Copy this function into your .basrc or if you use zsh, into your .zshrc
# After added open a new session or execute: source ~/.zshrc for zsh or source ~/.bashrc for bash.
# Go into the project repository and execute: 
# tfenv_switch 

function tfenv_switch(){
    TF_FILE_TEST=$(
        grep required_version ${PWD}/*.tf | \
        grep -v \# | \
        awk  '{print $5}' | \
        awk -F \" '{print $1}' | \
        tail -n1
    )
    
    if [[ "${TF_FILE_TEST}" == "0.12" ]];then  
        TF_FILE_TEST="0.12.0"
    fi

    tfenv install ${TF_FILE_TEST} && \
    tfenv use ${TF_FILE_TEST}
}
