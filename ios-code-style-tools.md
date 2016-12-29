iOS 开发代码规范辅助工具
---

**1、2的工具设置完成之后，在开始任意文件的改动前，请使用方法1或其他方式规范该文件的代码风格并做一次单独提交。然后再开始改动当前文件**

### 1. 借助 clang-format 主动规范当前文件的代码风格
**设置指南:**  
将 `clang-format-for-xcode-behaviors.sh` 放到一个固定的目录下，打开 Xcode，菜单选择 "Xcode"-"Behaviors"-"Edit Behaviors", 打开 `Behaviors` 编辑窗口
![](https://oadzxd0gg.bkt.clouddn.com/1483001315.png )
左下角添加自定义 Behaviors 并设置快捷键为 `⇧+⌘+S`, 右侧选择 Run Script，选择`clang-format-for-xcode-behaviors.sh`所在路径。
后续在打开一个不符合编码风格的代码文件时，就可以直接使用 `⇧+⌘+S` 来格式化该文件

### 2. 借助 git precommit 约束提交文件的代码风格
**设置指南:**
在团队内部开发的 iOS 项目仓库中，将`pre-commit`文件放到 git 仓库下的 `.git/hooks` 目录，即完成操作。  
每次 `git commit` 的时候，会触发根据 `.clang-format` 的约束检查代码风格，如果风格不符合，会 commit 失败。  
![](https://oadzxd0gg.bkt.clouddn.com/1483002377.png )

**注意尽量在开始编辑文件前，用方法1来规范代码风格，做一个 [style] 提交后，再做后续的编码，不要将规范代码风格的变动与实际功能修改的代码变动混在同一个 commit 内提交**
如果已经检查失败，建议 `git stash` 当前的代码改动，然后回到文件的原始状态，应用`方法1`先规范代码，做一次 [style] 规范代码风格 的提交，再从 git stash 中把改动的代码取出来做合并，提交。
