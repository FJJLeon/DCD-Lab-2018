## 自选实验-贪吃蛇VGA游戏
* 实现驱动VGA接口
* 实现目标的随机产生
* 实现蛇的长度变化、碰撞检测
* 实现分数显示

### 关键文件
* [`vga_play.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/greedy_snake/vga_play.v): 实现驱动VGA接口扫描显示
* [`apple_generate.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/greedy_snake/apple_generate.v): 实现目标产生， 蛇吃到的检测
* [`key.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/greedy_snake/key.v): 接受按键输入并消抖
* [`snake_ctrl.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/greedy_snake/snake_ctrl.v): 蛇运动方向控制、长度控制、碰撞检测、得分变化
* [`game_ctrl.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/greedy_snake/game_ctrl.v): 游戏进程控制
* [`snakeGame.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/greedy_snake/snakeGame.v): 顶层模块、得分显示

### Reference
* [基于FPGA的贪吃蛇游戏](https://blog.csdn.net/chengfengwenalan/article/details/79916122)
* [【接口时序】7、VGA接口原理与Verilog实现](https://www.cnblogs.com/liujinggang/p/9690504.html)
