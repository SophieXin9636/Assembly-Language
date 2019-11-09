# Assembly Language

## HW1
* 在命令列輸入執行指令及字串，須印出反向字串
* 例如
```
./a.out "hello world"
```
則輸出
```
reversed result: dlrow olleh
```

### 想法
先將暫存器的index指向'\0'的前一個 <br>
在遞減印出即可