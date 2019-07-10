# md_img_dl
一个下载 markdown 文件中图片的 bash 脚本

## usage  

```
./md_img_dl.sh [-s | -self] [-f $file| --file $file]
```
* 默认是在工作目录新建backup文件夹保存图片，[-s | -self] 选项表示在markdown文件同级目录新建一个文件夹保存图片
* 默认递归遍历工作目录下.md文件，可以使用[-f $file| --file $file]指定文件夹或者.md文件
