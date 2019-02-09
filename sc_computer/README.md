## 单周期CPU
* 实现基本的具有20条指令的单周期CPU
* 实现统一编址I/O端口扩展
* 编写汇编代码产生对应机器码后测试

### 关键文件
老师提供了几乎全部代码，关键在于填写真值表，理清每个指令所使用的控制信号及其作用，并实现统一编址I/O端口扩展，编写测试汇编代码
* [`sc_cu.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/sc_computer/source/sc_cu.v): 按照从指令内存读取的机器码识别指令，确定控制信号
* [`alu.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/sc_computer/source/alu.v): 按照由指令确定的aluc控制信号完成相应算术逻辑运算
* [`sc_datamem.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/sc_computer/source/sc_datamem.v): 内存空间控制，使用MUX选择内存读取或IO
* [`io_output.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/sc_computer/source/io_output.v)/[`io_input.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/sc_computer/source/io_input.v): 实现统一编址I/O端口扩展
* [`sc_instmem.mif`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/sc_computer/source/source/sc_instmem.mif): 使用MIPS汇编实现减法器，将10个拨动按钮分为左右两组作为2进制数，将相减的等式显示在数码管上

### 注意
* 顶层模块使用了BDF图
* 使用汇编器生产的mif内存初始化文件路径需要在 `lpm_rom_irom` 和 `lpm_ram_dq_dram` IP模块指定，推荐使用绝对路径
* 仿真测试时编写TestBench时尤其注意命名问题，变量未定义可以被使用，不会直接报错
* 若在Quartus直接打开ModelSim注意意设置的Top_level_module与 TestBench 中定义的相同，否则仿真会报错 
* 引脚分配推荐使用文件导入的方式, 注意端口与引脚的对应

### 注意
* 减法器使用绝对值解决溢出问题，保证结果不会出现负数
* 使用的汇编器可能与 RAM 存在不匹配的问题，生成的 datamem.mif 文件 DEPTH 需要改为 32，BEGIN 后接 [0..1F]，否则会有错误

### Reference
* [Wesley-Jzy/SJTU-DCD-LAB-2017](https://github.com/Wesley-Jzy/SJTU-DCD-LAB-2017)