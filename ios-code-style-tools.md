iOS 代码风格规范工具设置指南
---

**设置完成之后，在开始文件的改动前，请使用方法1来规范文件的代码风格并做一次单独提交。然后再开始改动该文件**

首先安装 *clang-format*
```
brew install clang-format
```

### 1. 借助 clang-format 主动规范当前文件的代码风格
**设置指南:**   
- 将 [.clang-format](./.clang-format) 文件放到 iOS 工程根目录下;  
- 将 [clang-format-for-xcode-behaviors.sh](./clang-format-for-xcode-behaviors.sh) 文件放到一个固定的目录下，注意开启执行权限  

打开 Xcode，菜单选择 "Xcode"-"Behaviors"-"Edit Behaviors", 打开 `Behaviors` 编辑窗口
![](http://oadzxd0gg.bkt.clouddn.com/1483001315.png)

左下角添加自定义 Behaviors 并设置快捷键为 `⇧+⌘+S`, 右侧选择 Run Script，选择`clang-format-for-xcode-behaviors.sh`所在路径。
后续在打开一个不符合编码风格的代码文件时，就可以直接使用 `⇧+⌘+S` 来格式化该文件

### 2. 借助 git precommit 在 git commit 时强制检查代码风格
**设置指南:**
- 将 [pre-commit](./pre-commit) 文件放到 iOS 项目下的 `.git/hooks` 目录，注意确认是否有执行权限  

每次 `git commit` 的时候，会触发根据 `.clang-format` 的约束检查代码风格，如果风格不符合，会 commit 失败。  

![](http://oadzxd0gg.bkt.clouddn.com/1483002377.png)

如果 commit 失败，不要直接应用生成的 patch，而应该使用 `git stash` 来暂存当前的代码改动，然后回到文件的原始状态，应用`方法1`先规范代码风格，并做一次 `[style] 规范代码风格` 的提交，再从 git stash 中把改动的代码取出来做合并，最后完成提交。
