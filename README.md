# How to restrict user commands for spesific user on linux
**Our goal:** Restrict user to use other commands except ssh because we want to redirect this user to another computer immediately. Of course you will can edit these restrictions how you want.
1. Create user and restricted environment
1. Restrict specific commands
1. Ssh to another machine
1. Check connection and trigger when ctrl-c pressed

## 1. Create user and restricted environment
First, create the restricted shell
```
cp /bin/bash /bin/rbash
```
Add user and modify the target user for the shell as restricted shell
```
adduser username
usermod -s /bin/rbash username
```
For now username can access all commands which allowed to execute. We will edit it and it will restrict user
```
nano /home/username/.bash_profile
```
add these lines to .bash_profile and save it.

```
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
readonly PATH=$HOME
export PATH
```

Now after logging with that username profile, user can't run a simple command too. 

## 2. Restrict specific commands
and if some commands are accessible and you want to restrict them you can use like that
```
alias apt-get="printf ''"
```
and it will restricted but you have to add line to end of this file.
```
alias alias="printf ''"
```
## 3. Ssh to another machine
We can make user login to another machine automatically via this command
```
ssh -q username@ip -p port
```
> for example ssh -q root@10.110.10.1 -p 2655
>
## 4. Check connection and trigger when ctrl-c pressed
Trigger when ctrl-c pressed or interrupted and echo that you can only use ssh command
```
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
function ctrl_c() {
    echo You can do only this command: "ssh -q username@ip -p port"
}
PWD='YourPassword'
status=$(sshpass -p $PWD ssh -q -o ConnectTimeout=5 username@ip -p port echo ok 2>&1)
#echo $status
if [[ $status == ok ]] ; then
  #ssh -q username@ip -p port
  sshpass -p $PWD ssh -q username@ip -p port #automatic connection with password no need to write password again
elif [[ $status == "Permission denied"* ]] ; then
  echo No Auth
else
  echo Error
fi
```
