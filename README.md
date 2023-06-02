## When container crashes

To enter a crashed container set the following command:

```
command: [ "/bin/bash", "-c", "--" ]
args: [ "while true; do sleep 30; done;" ]
```
