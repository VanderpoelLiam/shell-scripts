# bash-scripts
A collection of bash scripts.

## Issues
### Sourcing a bash script inside of a zsh shell
Sourcing a script equates to typing the commands in your current shell. Any changes to the environment will take effect and stay in your current shell. Executing a script equates to opening a new shell, typing the commands in the new shell, copying the output back to your current shell, then closing the new shell.

This is sourcing a script:
```
. my_script.sh
```
or
```
source my_script.sh
```

This is executing a script:
```
./my_script.sh
```

If your current shell is not bash, for example if it is [zsh](https://ohmyz.sh/), then it is necessary to source a bash script by running
```
bash -c '. my_script.sh'
```
