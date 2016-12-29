#!/bin/bash

### 设置指南：
### 将本文件放到一个固定的目录下，打开 Xcode，菜单选择 "Xcode"-"Behaviors"-"Edit Behaviors", 打开 `Behaviors` 编辑窗口
### ![](https://oadzxd0gg.bkt.clouddn.com/1483001315.png )
### 左下角添加自定义 Behaviors 并设置快捷键为 `⇧+⌘+S`, 右侧选择 Run Script，选择本文件所在路径。
### 后续在打开一个不符合编码风格的代码文件时，就可以直接使用 `⇧+⌘+S` 来格式化该文件

CDP=$(osascript -e '
tell application "Xcode"
    activate
    tell application "System Events" to keystroke "s" using {command down}
    --wait for Xcode to remove edited flag from filename
    delay 0.3
    set last_word_in_main_window to (word -1 of (get name of window 1))
    set current_document to document 1 whose name ends with last_word_in_main_window
    set current_document_path to path of current_document
    --CDP is assigned last set value: current_document_path
end tell ')

LOGPATH=$(dirname "$0")
LOGNAME=formatWithClangLog.txt
echo "Filepath: ${CDP}" > ${LOGPATH}/${LOGNAME}
sleep 1 ### during save Xcode stops listening for file changes
/usr/local/bin/clang-format -style=file -i -sort-includes ${CDP} >> ${LOGPATH}/${LOGNAME} 2>&1
