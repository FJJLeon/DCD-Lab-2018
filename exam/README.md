## 上机考试
* 上机考试要求在单周期CPU的基础上扩展一条指令 `even7` 或 `odd7`，以下以前者为例
* `even7 rd rs` 即判断一个7位二进制数`rs`中1的个数是否为偶数个，是则将`1`写入`rd`，否则写入`0`
* 结合I/O要求读入前7个拨动按钮作为输入，判断其中1的个数，若为偶数在第一个数码管显示`E`，否则显示`0`

### 关键文件
* [`sc_cu.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/exam/source/sc_cu.v): 添加了一条新的指令识别，并修改相应的控制信号
* [`alu.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/exam/source/alu.v): 使用新的`aluc`控制信号计算1的个数是否为偶数
* [`out_even.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/exam/source/out_even.v): 取巧的做法，直接修改了顶层模块第一个数码管译码逻辑，1显示E
* [`even_instmem.mif`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/exam/asm/even_instmem.mif): 编写汇编配合IO端口读取前7位拨动按钮计算后显示，需要手动计算并添加`even7`指令的机器码

### 注意
* 七段译码器与数码管对应关系
* 需要修改的控制信号
* 汇编代码手动修改机器码时的格式