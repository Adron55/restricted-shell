if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
readonly PATH=$PATH:$HOME
export PATH

alias pwd="printf ''"

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
function ctrl_c() {
    echo You can do only this command: "ssh -q username@ip -p port"
}

PWD='YourPassword'
status=$(sshpass -p $PWD ssh -q -o ConnectTimeout=5 username@ip -p port echo ok 2>&1)

if [[ $status == ok ]] ; then
  ssh -q username@ip -p port
elif [[ $status == "Permission denied"* ]] ; then
  echo No Auth
else
  echo Error
fi