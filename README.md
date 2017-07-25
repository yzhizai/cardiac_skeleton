cardiac_skeleton
================

This is the program to produce cardiac skeleton....
My name is Shaofeng Duan.

### workflow
1. 准备被试静息和负荷的心肌短轴图像：
	一般为`<subject's name>1 =====>静息态`
              `<subject's name>2 =====>负荷态`
2. 用spm中的normalized的batch将图像从[6.7 6.7 6.7] --->[2 2 2]的像素尺寸，具体操作：
	1. 打开`batch`
	2. 选择`normalise(estimate&write)`
	3. 将`source,write,reference`都选择想要插值的图像
	4. 运行
3. 上面的图像变成：
	      `w<subject's name>1 =====>静息态`
              `w<subject's name>2 =====>负荷态`
将这两幅图像放置到新建的子文件夹chazhi下;
4. `./cardiac_skeleton`获取初步的skeleton图像：<basename>_skeleton_1,以及<basename>_tfce_*的所有文件
	1. 静息的图像用`cardiac_skeleton -i <basename> 1`
	2. 负荷的图像用`cardiac_skeleton -i <basename> 2`
	3. 前面的步骤会生成`<basename>_tfce_thr`的图像，然后利用该图像并用`tfce_tiqu.m`函数去生成tfce版的原图像提取图
	4. 然后用spm中的coregistrate进行配准，得到负荷的rm开头的负荷文件
（小结：之前的版本因为没有采用插值的方法，会出现骨架不完整的现象，但是经过插值处理，骨架不完整的情况减少，故骨架插值步骤取消）
5. 获取骨架的mask,一般采用
	`fslmaths <basename>_skeleton_1 -bin <basename>_skeleton_mask`
但是因为文件在spm和fsl之间由于数据类型的不同导致mask的结果不好，可采用img_binary.m函数在matlab中实现骨架的二值化。
6. 下面需要往骨架上去投影，投影之前需要的文件包括：
  ```
	<basename>_tfce_mask 
	<basename>_skeleton_mask									
	<basename>_tfce
  ```
上面都是静息态下的图像, 负荷态只需要提供<basename>图像即可。  
    
7. 采用下面的命令进行骨架的投影。
```
cardiac_project -i <basename> -r <refname>   
```
8. 验证操作：将投影的骨架反投影会原来的图像，获取原始空间的体素位置。
```
cardiac_deproject <skeletonisedname> <refname> <spacename>
<skeletonisedname>  ======> 已投影的骨架化image
<refname>     =======> 等同于cardiac_project程序中的<refname>
<spacename> ======> 等同于cardiac_project程序中的<basename>
```
