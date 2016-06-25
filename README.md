#### 本Repo包含：

1. 样例（Pull及Push模式下）
2. 清除DSC进程的脚本
3. 官方示例版本的Resource，版本有些旧，建议自己去搜
4. Pull模式下触发立即执行配置的脚本
5. 搭建Pull服务器的脚本
6. Pull模式配置脚本 等

《The DSC Book》中文翻译版：https://yaowenjie.gitbooks.io/the-dsc-book/content/

### Demo运行步骤

1. 解压xWebAdministration和cWebAdministration，并解压后的目录拷贝到PowerShell模块目录，可以使用如下命令：
```
cp -Recurse -Force *WebAdministration ($env:PSModulePath.Split(";")|Select-Object -Last 1)
```
2. 在PowerShell命令行内输入__Get-ExecutionPolicy__，检查PowerShell的执行权限，如果是limited或其他受限的属性，需要将其改为非受限的属性，如：
```
Set-ExecutionPolicy RemoteSigned
```
3. 直接在命令行运行My-DSC-Sample.ps1文件:
```
.\My-DSC-Sample.ps1
```
