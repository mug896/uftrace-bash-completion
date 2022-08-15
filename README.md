## Iptables Bash Completion

Copy contents of `httpie-bash-completion.sh` file to `~/.bash_completion`.  
open new terminal and try auto completion !


```sh
bash$ hostnamectl
Operating System: Ubuntu 22.04.1 LTS
          Kernel: Linux 5.15.0-43-generic
    Architecture: x86-64

bash$ uftrace --version
uftrace v0.9.4 ( dwarf python tui perf sched dynamic )

bash$ uftrace --[tab]
--Event              --flame-graph        --no-comment         --signal
--argument           --flat               --no-event           --size-filter
--auto-args          --force              --no-libcall         --sort
--avg-self           --graphviz           --no-merge           --sort-column
--avg-total          --help               --no-pager           --srcline
--buffer             --host               --no-pltbind         --symbols
--caller-filter      --keep-pid           --no-randomize-addr  --task
. . .
```

