# Objective-C 编码规范

# 目录
1. [代码格式](#代码格式)
    - [空行](#空行)
    - [ViewController.m 文件结构](#viewcontroller.m-文件结构)
2. [命名原则](#命名原则)
    - [基本原则](#基本原则)
    - [使用前缀](#使用前缀)
    - [命名类和协议(Class&Protocol)](#命名类和协议(class&protocol))
    - [命名头文件(Headers)](#命名头文件(headers))
    - [命名方法(Methods)](#命名方法(methods))
    - [存取方法(Accessor Methods)](#存取方法(accessor-methods))
    - [命名委托(Delegate)](#命名委托(delegate))
    - [集合操作类方法(Collection Methods)](#集合操作类方法(collection-methods))
    - [命名函数(Functions)](#命名函数(functions))
    - [命名属性和实例变量(Properties & Instance Variables)](#命名属性和实例变量(properties-&-instance-variables))
    - [命名常量(Constants)](#命名常量(constants))
    - [命名通知(Notifications)](#命名通知(notifications))
3. [注释](#注释)
    - [文件注释](#文件注释)
    - [方法注释](#方法注释)
    - [代码注释](#代码注释)
4. [编码风格](#编码风格)
    - [不要使用new方法](#不要使用new方法)
    - [Public API 要尽量简洁](#public-api-要尽量简洁)
    - [头文件引用](#头文件引用)
    - [BOOL的使用](#bool的使用)
    - [nil检查](#nil检查)
    - [点分语法的使用](#点分语法的使用)
    - [delegate要使用弱引用](#delegate要使用弱引用)
    - [使用 Literals](#使用-literals)
    - [Switch Case](#switch-case)
    - [?: 操作符](#?:-操作符)
    - [CGRect 方法](#cgrect-方法)
    - [Golden Path](#golden-path)
    - [处理 NSError](#处理-nserror)
    - [storyboard 使用](#storyboard-使用)


# 1. Objective-C 编码规范及原则

## 代码格式
项目内使用 `Clang Format` 来约束 C/C++/Objective-C 编码风格

Clang Format 配置步骤(Xcode)：  

1. Xcode 安装 `ClangFormat-Xcode` 插件(https://github.com/travisjeffery/ClangFormat-Xcode)
2. 配置快捷键，`Xcode -> Edit -> Format Code`，勾选使用`File`使用根目录下的`.clang-format`作为约束文件，勾选`Enable Format on Save`
3. 将本文档同目录下的`.clang-format`文件放入新建工程的根目录下，命名为`.clang-format`
4. 后续在 Xcode 保存该工程的代码文件时，会自动根据`.clang-format`来规范代码格式

**排序**   
包括`头文件引用`，`工程 group 排序`，无特殊说明时，按字母顺序排序。每次工程中添加新 group 时，需重新按字母排序。

#### 需要额外注意的事项
clang-format 在部分格式上不支持强制在 `//` 后保留一个空格，需要在写代码时额外注意。
```
// Preferred:
// 这里是注释

// Not Preferred:
//这里是注释
```

在使用 block 时，应尽量通过拆分和换行，减少 block 内代码块的整体缩进，尽量控制在小宽度屏幕也能比较方便的阅读代码
```objective-c
// Preferred:
MSTClientCompletionHandler handler = ^(NSInteger code, NSString *msg, id data) {
    // do something.
};
[[MSTClient sharedInstance]
    fetchPhoneCertCodeWithPhone:telephone
              completionHandler:^(NSInteger code, NSString *msg, id data) {
                  handler(code, msg, data);
              }];

// Preferred:
[[MSTClient sharedInstance]
    fetchPhoneCertCodeWithPhone:telephone
              completionHandler:^(NSInteger code, NSString *msg, id data) {
                  // do something.
              }];

// Not Preferred:
[[MSTClient sharedInstance] fetchPhoneCertCodeWithPhone:self.telephone
                                      completionHandler:^(NSInteger code, NSString *msg, id data) {
                                          // do something.
                                      }];
```

**例外**    
在宏定义文件(eg. MSTMacro.h)中，需要的代码格式不同于其他文件，使用`clang-format off`来关闭 clang-format
```
// clang-format off

// 非标准代码风格的代码

// clang-format on
```

## 空行
- #import 块前后保留一个空行
- @interface 与 @protocol 间保留一个空行
- 多个 @property 时，如果涉及不同区块、不同职能属性，可使用空行分隔成多组
- .m 文件中 @interface 与 @implementation 使用两个空行隔开
- 方法间使用一个空行分隔
- @end 之后保留一个空行

```objective-c
// Preferred:
#import <UIKit/UIKit.h>

@class MSTHotelSearchParams;
@class MSTHotelList;
@interface MSTHotelSearchResultChildViewController : UITableViewController

@property (strong, nonatomic) MSTHotelList *hotels;

- (id)initWithSearchParams:(MSTHotelSearchParams )params;
- (void)configureWithSearchParams:(MSTHotelSearchParams *)params;

@end


// Not Preferred:
#import <UIKit/UIKit.h>
@class MSTHotelSearchParams;
@class MSTHotelList;
@interface MSTHotelSearchResultChildViewController : UITableViewController
@property (strong, nonatomic) MSTHotelList *hotels;
- (id)initWithSearchParams:(MSTHotelSearchParams *)params;
- (void)configureWithSearchParams:(MSTHotelSearchParams *)params;
@end

```


## ViewController.m 文件结构
使用 #pragma mark 区分不同代码块，可引用[Code Snippets For Xcode in cncn.com & cncn.net](https://github.com/EuanChan/CodeSnippets_MST)，code snippet 来快速生成结构，一个典型的 ViewController.m 结构如下：
```objective-c
///--------------------------------------
#pragma mark - life cycle
///--------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];

}

///--------------------------------------
#pragma mark - setup & configuration
///--------------------------------------



///--------------------------------------
#pragma mark - custom delegate
///--------------------------------------



///--------------------------------------
#pragma mark - event response
///--------------------------------------



///--------------------------------------
#pragma mark - update views
///--------------------------------------



///--------------------------------------
#pragma mark - helper/private methods
///--------------------------------------



///--------------------------------------
#pragma mark - getters and setters
///--------------------------------------

```


## 命名原则
## 基本原则
- 清晰

命名应该尽可能的清晰和简洁，但在Objective-C中，清晰比简洁更重要。由于Xcode强大的自动补全功能，我们不必担心名称过长的问题。

```objective-c
// Preferred:
insertObject:atIndex:

// Not Preferred: insert的对象类型和at的位置属性没有说明
insert:at:

// Preferred:
removeObjectAtIndex:

// Not Preferred:，remove的对象类型没有说明，参数的作用没有说明
remove:

```

除官方推荐的缩写外，尽量不使用单词缩写，拼写出完整的单词：
```objective-c
// Preferred:
destinationSelection
setBackgroundColor:

// Not Preferred: 不要使用简写
destSel
setBkgdColor:
```

有部分单词简写在Objective-C编码过程中是非常常用的，以至于成为了一种规范，这些简写可以在代码中直接使用，下面列举了部分：
```
alloc   == Allocate                 max    == Maximum
alt     == Alternate                min    == Minimum
app     == Application              msg    == Message
calc    == Calculate                nib    == Interface Builder archive
dealloc == Deallocate               pboard == Pasteboard
func    == Function                 rect   == Rectangle
horiz   == Horizontal               Rep    == Representation (used in class name such as NSBitmapImageRep).
info    == Information              temp   == Temporary
init    == Initialize               vert   == Vertical
int     == Integer
```

命名方法或者函数时要避免歧义
```
// Not Preferred: 有歧义，是返回sendPort还是send一个Port？
sendPort

// Not Preferred: 有歧义，是返回一个名字属性的值还是display一个name的动作？
displayName
```

- 一致性

## 使用前缀

如果代码需要打包成Framework给别的工程使用，或者工程项目非常庞大，需要拆分成不同的模块，使用命名前缀是非常有用的。

- 前缀由大写的字母缩写组成，比如Cocoa中NS前缀代表Founation框架中的类，IB则代表Interface Builder框架。
- 可以在为类、协议、函数、常量以及typedef宏命名的时候使用前缀，但注意不要为成员变量或者方法使用前缀，因为他们本身就包含在类的命名空间内。
- 命名前缀的时候不要和苹果SDK框架冲突。

项目的工程命名尽量不直接使用业务名称的拼音或者对应的英文名(业务在后续中可能会变化发展)，例如旅游顾问项目的项目代号为 Mansinthe, 前缀为 MST。

现有的基础类库从旅游顾问项目中拆分，仍以 `MST` 为前缀。

## 命名类和协议(Class&Protocol)

类名以大写字母开头，应该包含一个*名词*来表示它代表的对象类型，同时可以加上必要的前缀，比如`NSString`, `NSDate`, `NSScanner`, `NSApplication`等等。

而协议名称应该清晰地表示它所执行的行为，而且要和类名区别开来，所以通常使用`ing`词尾来命名一个协议，比如`NSCopying`,`NSLocking`。

有些协议本身包含了很多不相关的功能，主要用来为某一特定类服务，这时候可以直接用类名来命名这个协议，比如`NSObject`协议，它包含了id对象在生存周期内的一系列方法。

## 命名头文件(Headers)

源码的头文件名应该清晰地暗示它的功能和包含的内容：

- 如果头文件内只定义了单个类或者协议，直接用类名或者协议名来命名头文件，比如`NSLocale.h`定义了`NSLocale`类。

- 如果头文件内定义了一系列的类、协议、类别，使用其中最主要的类名来命名头文件，比如`NSString.h`定义了`NSString`和`NSMutableString`。

- 每一个Framework都应该有一个和框架同名的头文件，包含了框架中所有公共类头文件的引用，比如`Foundation.h`

- Framework中有时候会实现在别的框架中类的类别扩展，这样的文件通常使用`被扩展的框架名`+`Additions`的方式来命名，比如`NSBundleAdditions.h`。

## 命名方法(Methods)

Objective-C的方法名通常都比较长，这是为了让程序有更好地可读性，按苹果的说法*“好的方法名应当可以以一个句子的形式朗读出来”*。

方法一般以小写字母打头，每一个后续的单词首字母大写，方法名中不应该有标点符号(*包括下划线*)，有两个例外：

- 可以用一些通用的大写字母缩写打头方法，比如`PDF`,`TIFF`等。
- 可以用带下划线的前缀来命名私有方法或者 Category 中的方法。

如果方法表示让对象执行一个动作，使用动词打头来命名，注意不要使用`do`，`does`这种多余的关键字，动词本身的暗示就足够了：

```objective-c
// 动词打头的方法表示让对象执行一个动作
- (void)invokeWithTarget:(id)target;
- (void)selectTabViewItem:(NSTabViewItem *)tabViewItem;
```

如果方法是为了获取对象的一个属性值，直接用属性名称来命名这个方法，注意不要添加`get`或者其他的动词前缀：

```objective-c
// Preferred: 使用属性名来命名方法
- (NSSize)cellSize;

// Not Preferred: 添加了多余的动词前缀
- (NSSize)calcCellSize;
- (NSSize)getCellSize;
```

对于有多个参数的方法，务必在每一个参数前都添加关键词，关键词应当清晰说明参数的作用：

```objective-c
// Preferred: 保证每个参数都有关键词修饰
- (void)sendAction:(SEL)aSelector toObject:(id)anObject forAllCells:(BOOL)flag;

// Not Preferred: 遗漏关键词
- (void)sendAction:(SEL)aSelector :(id)anObject :(BOOL)flag;

// Preferred:
- (id)viewWithTag:(NSInteger)aTag;

// Not Preferred: 关键词的作用不清晰
- (id)taggedView:(int)aTag;
```

不要用`and`来连接两个参数，通常`and`用来表示方法执行了两个相对独立的操作(*从设计上来说，这时候应该拆分成两个独立的方法*)：

```objective-c
// Not Preferred: 不要使用"and"来连接参数
- (int)runModalForDirectory:(NSString *)path andFile:(NSString *)name andTypes:(NSArray *)fileTypes;

// Preferred: 使用"and"来表示两个相对独立的操作
- (BOOL)openFile:(NSString *)fullPath withApplication:(NSString *)appName andDeactivate:(BOOL)flag;
```

方法的参数命名也有一些需要注意的地方:
- 和方法名类似，参数的第一个字母小写，后面的每一个单词首字母大写
- 不要再方法名中使用类似`pointer`,`ptr`这样的字眼去表示指针，参数本身的类型足以说明
- 不要使用只有一两个字母的参数名
- 不要使用简写，拼出完整的单词

下面列举了一些常用参数名：

```objective-c
...action:(SEL)aSelector
...alignment:(int)mode
...atIndex:(int)index
...content:(NSRect)aRect
...doubleValue:(double)aDouble
...floatValue:(float)aFloat
...font:(NSFont *)fontObj
...frame:(NSRect)frameRect
...intValue:(int)anInt
...keyEquivalent:(NSString *)charCode
...length:(int)numBytes
...point:(NSPoint)aPoint
...stringValue:(NSString *)aString
...tag:(int)anInt
...target:(id)anObject
...title:(NSString *)aString
```

## 存取方法(Accessor Methods)

存取方法是指用来获取和设置类属性值的方法，属性的不同类型，对应着不同的存取方法规范：

```objective-c
// 属性是一个名词时的存取方法范式
- (type)noun;
- (void)setNoun:(type)aNoun;
// 栗子
- (NSString *)title;
- (void)setTitle:(NSString *)aTitle;

// 属性是一个形容词时存取方法的范式
- (BOOL)isAdjective;
- (void)setAdjective:(BOOL)flag;
// 栗子
- (BOOL)isEditable;
- (void)setEditable:(BOOL)flag;

// 属性是一个动词时存取方法的范式
- (BOOL)verbObject;
- (void)setVerbObject:(BOOL)flag;
// 栗子
- (BOOL)showsAlpha;
- (void)setShowsAlpha:(BOOL)flag;
```

命名存取方法时不要将动词转化为被动形式来使用：
```objective-c
// Preferred:
- (void)setAcceptsGlyphInfo:(BOOL)flag;
- (BOOL)acceptsGlyphInfo;

// Not Preferred: 不要使用动词的被动形式
- (void)setGlyphInfoAccepted:(BOOL)flag;
- (BOOL)glyphInfoAccepted;
```

可以使用`can`,`should`,`will`等词来协助表达存取方法的意思，但不要使用`do`,和`does`：
```objective-c
// Preferred:
- (void)setCanHide:(BOOL)flag;
- (BOOL)canHide;
- (void)setShouldCloseDocument:(BOOL)flag;
- (BOOL)shouldCloseDocument;

// Not Preferred: 不要使用"do"或者"does"
- (void)setDoesAcceptGlyphInfo:(BOOL)flag;
- (BOOL)doesAcceptGlyphInfo;
```

为什么Objective-C中不适用`get`前缀来表示属性获取方法？因为`get`在Objective-C中通常只用来表示从函数指针返回值的函数：
```objective-c
// 三个参数都是作为函数的返回值来使用的，这样的函数名可以使用"get"前缀
- (void)getLineDash:(float *)pattern count:(int *)count phase:(float *)phase;
```

## 命名委托(Delegate)

当特定的事件发生时，对象会触发它注册的委托方法。委托是Objective-C中常用的传递消息的方式。委托有它固定的命名范式。

一个委托方法的第一个参数是触发它的对象，第一个关键词是触发对象的类名，除非委托方法只有一个名为`sender`的参数：
```objective-c
// 第一个关键词为触发委托的类名
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row;
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename;

// 当只有一个"sender"参数时可以省略类名
- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender;
```

根据委托方法触发的时机和目的，使用`should`,`will`,`did`等关键词
```objective-c
- (void)browserDidScroll:(NSBrowser *)sender;

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window;、

- (BOOL)windowShouldClose:(id)sender;
```

## 集合操作类方法(Collection Methods)

有些对象管理着一系列其它对象或者元素的集合，需要使用类似“增删查改”的方法来对集合进行操作，这些方法的命名范式一般为：

```objective-c
// 集合操作范式
- (void)addElement:(elementType)anObj;
- (void)removeElement:(elementType)anObj;
- (NSArray *)elements;

// 栗子
- (void)addLayoutManager:(NSLayoutManager *)obj;
- (void)removeLayoutManager:(NSLayoutManager *)obj;
- (NSArray *)layoutManagers;
```

注意，如果返回的集合是无序的，使用`NSSet`来代替`NSArray`。如果需要将元素插入到特定的位置，使用类似于这样的命名：

```objective-c
- (void)insertLayoutManager:(NSLayoutManager *)obj atIndex:(int)index;
- (void)removeLayoutManagerAtIndex:(int)index;
```

如果管理的集合元素中有指向管理对象的指针，要设置成`weak`类型以防止引用循环。

下面是SDK中`NSWindow`类的集合操作方法：

```objective-c
- (void)addChildWindow:(NSWindow *)childWin ordered:(NSWindowOrderingMode)place;
- (void)removeChildWindow:(NSWindow *)childWin;
- (NSArray *)childWindows;
- (NSWindow *)parentWindow;
- (void)setParentWindow:(NSWindow *)window;
```

## 命名函数(Functions)

在很多场合仍然需要用到函数，比如说如果一个对象是一个单例，那么应该使用函数来代替类方法执行相关操作。

函数的命名和方法有一些不同，主要是：

- 函数名称一般带有缩写前缀，表示方法所在的框架。
- 前缀后的单词以“驼峰”表示法显示，第一个单词首字母大写。

函数名的第一个单词通常是一个动词，表示方法执行的操作：

```objective-c
NSHighlightRect
NSDeallocateObject
```

如果函数返回其参数的某个属性，省略动词：

```objective-c
unsigned int NSEventMaskFromType(NSEventType type)
float NSHeight(NSRect aRect)
```

如果函数通过指针参数来返回值，需要在函数名中使用`Get`：

```objective-c
const char *NSGetSizeAndAlignment(const char *typePtr, unsigned int *sizep, unsigned int *alignp)
```

函数的返回类型是BOOL时的命名：

```objective-c
BOOL NSDecimalIsNotANumber(const NSDecimal *decimal)
```

## 命名属性和实例变量(Properties & Instance Variables)

属性和对象的存取方法相关联，属性的第一个字母小写，后续单词首字母大写，不必添加前缀。属性按功能命名成名词或者动词：

```objective-c
// 名词属性
@property (strong) NSString *title;

// 动词属性
@property (assign) BOOL showsAlpha;
```

属性也可以命名成形容词，这时候通常会指定一个带有`is`前缀的get方法来提高可读性：

```objective-c
@property (assign, getter=isEditable) BOOL editable;
```

命名实例变量，在变量名前加上`_`前缀(*有些有历史的代码会将`_`放在后面*)，其它和命名属性一样：

```objective-c
@implementation MyClass {
    BOOL _showsTitle;
}
```

一般来说，类需要对使用者隐藏数据存储的细节，所以不要将实例方法定义成公共可访问的接口，可以使用`@private`，`@protected`前缀。

## 命名常量(Constants)

如果要定义一组相关的常量，尽量使用枚举类型(enumerations)，枚举类型的命名规则和函数的命名规则相同。
建议使用 `NS_ENUM` 和 `NS_OPTIONS` 宏来定义枚举类型，参见官方的 [Adopting Modern Objective-C](https://developer.apple.com/library/ios/releasenotes/ObjectiveC/ModernizationObjC/AdoptingModernObjective-C/AdoptingModernObjective-C.html) 一文：

```objective-c
// 定义一个枚举
typedef NS_ENUM(NSInteger, NSMatrixMode) {
    NSRadioModeMatrix,
    NSHighlightModeMatrix,
    NSListModeMatrix,
    NSTrackModeMatrix
};
```

定义bit map：

```objective-c
typedef NS_OPTIONS(NSUInteger, NSWindowMask) {
    NSBorderlessWindowMask      = 0,
    NSTitledWindowMask          = 1 << 0,
    NSClosableWindowMask        = 1 << 1,
    NSMiniaturizableWindowMask  = 1 << 2,
    NSResizableWindowMask       = 1 << 3
};
```

使用`const`定义浮点型或者单个的整数型常量，如果要定义一组相关的整数常量，应该优先使用枚举。常量的命名规范和函数相同：

```objective-c
const float NSLightGray;
```

不要使用`#define`宏来定义常量，如果是整型常量，尽量使用枚举，浮点型常量，使用`const`定义。`#define`通常用来给编译器决定是否编译某块代码，比如常用的：

```objective-c
#ifdef DEBUG
```

注意到一般由编译器定义的宏会在前后都有一个`__`，比如*`__MACH__`*。

## 命名通知(Notifications)

通知常用于在模块间传递消息，所以通知要尽可能地表示出发生的事件，通知的命名范式是：

    [触发通知的类名] + [Did | Will] + [动作] + Notification

栗子：

```objective-c
NSApplicationDidBecomeActiveNotification
NSWindowDidMiniaturizeNotification
NSTextViewDidChangeSelectionNotification
NSColorPanelColorDidChangeNotification
```

## 注释

好的代码应该是“自解释”(self-documenting)的，SDK 或公用的方法中，应使用注释来说明参数的意义、返回值、功能及副作用。其中参数的意义，如果能通过类型名称、 enum type 来说明的，尽量不通过注释额外说明。

## 文件注释
暂无要求，有注释时需保持格式统一，主要用于描述文件包含的内容、作用。

## 方法注释
，但仍然需要详细的注释来说明参数的意义、返回值、功能以及可能的副作用。

方法、函数、类、协议、类别的定义都需要注释，推荐采用Apple的标准注释风格，好处是可以在引用的地方`alt+点击`自动弹出注释，非常方便。

有很多可以自动生成注释格式的插件，推荐使用[VVDocumenter](https://github.com/onevcat/VVDocumenter-Xcode)：

![Screenshot](https://raw.github.com/onevcat/VVDocumenter-Xcode/master/ScreenShot.gif)

一些良好的SDK注释：

```objective-c
/**
 *  Create a new preconnector to replace the old one with given mac address.
 *  NOTICE: We DO NOT stop the old preconnector, so handle it by yourself.
 *
 *  @param type       Connect type the preconnector use.
 *  @param macAddress Preconnector's mac address.
 */
- (void)refreshConnectorWithConnectType:(IPCConnectType)type  Mac:(NSString *)macAddress;

/**
 *  Stop current preconnecting when application is going to background.
 */
-(void)stopRunning;

/**
 *  Get the COPY of cloud device with a given mac address.
 *
 *  @param macAddress Mac address of the device.
 *
 *  @return Instance of IPCCloudDevice.
 */
-(IPCCloudDevice *)getCloudDeviceWithMac:(NSString *)macAddress;

// A delegate for NSApplication to handle notifications about app
// launch and shutdown. Owned by the main app controller.
@interface MyAppDelegate : NSObject {
  ...
}
@end
```

协议、委托的注释要明确说明其被触发的条件：

```objective-c
/** Delegate - Sent when failed to init connection, like p2p failed. */
-(void)initConnectionDidFailed:(IPCConnectHandler *)handler;
```

如果在注释中要引用参数名或者方法函数名，使用`||`将参数或者方法括起来以避免歧义：

```objective-c
// Sometimes we need |count| to be less than zero.

// Remember to call |StringWithoutSpaces("foo bar baz")|
```

**尽量通过命名来减弱注释的作用**，在一些非公用代码中，可适当减弱注释。

**一旦添加了注释，更改代码时需同步更新注释**。

## 代码注释

**代码注释大多数情况下应用于解释为什么这么做，而不是解释做了什么。在需要解释做了什么的时候，考虑是否是变量命名不够合理，方法职责划分不够明确。**



## 编码风格

## 不要使用new方法

尽管很多时候能用`new`代替`alloc init`方法，但这可能会导致调试内存时出现不可预料的问题。Cocoa的规范就是使用`alloc init`方法，使用`new`会让一些读者困惑。

## Public API 要尽量简洁

共有接口要设计的简洁，满足核心的功能需求就可以了。不要设计很少会被用到，但是参数极其复杂的API。如果要定义复杂的方法，使用类别或者类扩展。

## 头文件引用

`#import`是Cocoa中常用的引用头文件的方式，它能自动防止重复引用文件，什么时候使用`#import`，什么时候使用`#include`呢？

- 当引用的是一个Objective-C或者Objective-C++的头文件时，使用`#import`
- 当引用的是一个C或者C++的头文件时，使用`#include`，这时必须要保证被引用的文件提供了保护域(#define guard)。

头文件中尽量通过 `@class`, `@protocol` 预定义来减少头文件的引用，.m 文件中，头文件引用分成两组按字母排序，`<>`在前，`""`在后，如：

```objective-c
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVPullToRefresh.h>
#import <TSMessage.h>
#import "MSTClient+Hotel.h"
#import "MSTEmptyDataSetHelper.h"
#import "MSTHotel.h"
#import "MSTHotelDetailViewController.h"
#import "MSTHotelSearchParams.h"
#import "MSTHotelSearchResultBottomFilterSortViewController.h"
#import "MSTHotelSearchResultChildViewController.h"
#import "MSTHotelSearchResultKeywordEditViewController.h"
#import "MSTHotelSearchResultViewCell.h"
#import "MSTZone.h"
```

## BOOL的使用

BOOL在Objective-C中被定义为`signed char`类型，这意味着一个BOOL类型的变量不仅仅可以表示`YES`(1)和`NO`(0)两个值，所以永远**不要**将BOOL类型变量直接和`YES`比较：

```objective-c
// 错误，无法确定|great|的值是否是YES(1)，不要将BOOL值直接与YES比较
BOOL great = [foo isGreat];
if (great == YES)
  // ...be great!

// 正确
BOOL great = [foo isGreat];
if (great)
  // ...be great!
```

同样的，也不要将其它类型的值作为BOOL来返回，这种情况下，BOOL变量只会取值的最后一个字节来赋值，这样很可能会取到0(NO)。但是，一些逻辑操作符比如`&&`,`||`,`!`的返回是可以直接赋给BOOL的：

```objective-c
// 错误，不要将其它类型转化为BOOL返回
- (BOOL)isBold {
  return [self fontTraits] & NSFontBoldTrait;
}
- (BOOL)isValid {
  return [self stringValue];
}

// 正确
- (BOOL)isBold {
  return ([self fontTraits] & NSFontBoldTrait) ? YES : NO;
}

// 正确，逻辑操作符可以直接转化为BOOL
- (BOOL)isValid {
  return [self stringValue] != nil;
}
- (BOOL)isEnabled {
  return [self isValid] && [self isBold];
}
```

另外BOOL类型可以和`_Bool`,`bool`相互转化，但是**不能**和`Boolean`转化。

## nil检查

因为在Objective-C中向nil对象发送命令是不会抛出异常或者导致崩溃的，只是完全的“什么都不干”，所以，只在程序中使用nil来做逻辑上的检查。

另外，不要使用诸如`nil == Object`或者`Object == nil`的形式来判断。

```objective-c
// 正确，直接判断
if (!objc) {
    ...
}

// 错误，不要使用nil == Object的形式
if (nil == objc) {
    ...
}
```
## 点分语法的使用

不要用点分语法来调用方法，只用来访问属性。这样是为了防止代码可读性问题。

```objective-c
// 正确，使用点分语法访问属性
NSString *oldName = myObject.name;
myObject.name = @"Alice";

// 错误，不要用点分语法调用方法
NSArray *array = [NSArray arrayWithObject:@"hello"];
NSUInteger numberOfItems = array.count;
array.release;
```

## delegate要使用弱引用

一个类的Delegate对象通常还引用着类本身，这样很容易造成引用循环的问题，所以类的Delegate属性要设置为弱引用。

```objective-c
/** delegate */
@property (nonatomic, weak) id <IPCConnectHandlerDelegate> delegate;
```

## 使用 Literals
```objective-c
// Preferred:
NSArray *names = @[@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul"];
NSDictionary *productManagers = @{@"iPhone": @"Kate", @"iPad": @"Kamal", @"Mobile Web": @"Bill"};
NSNumber *shouldUseLiterals = @YES;
NSNumber *buildingStreetNumber = @10018;

// Not Preferred:
NSArray *names = [NSArray arrayWithObjects:@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul", nil];
NSDictionary *productManagers = [NSDictionary dictionaryWithObjectsAndKeys: @"Kate", @"iPhone", @"Kamal", @"iPad", @"Bill", @"Mobile Web", nil];
NSNumber *shouldUseLiterals = [NSNumber numberWithBool:YES];
NSNumber *buildingStreetNumber = [NSNumber numberWithInteger:10018];
```

## Switch Case

当一个 case 包含多行时，添加{}。 如果使用枚举类型，无需添加 default:  

```objective-c
switch (condition) {
    case 1:
        // ...
        break;
    case 2: {
        // ...
        // Multi-line example using braces
        break;
    }
    case 3:
        // ...
        break;
    case 4:
        // ** fall-through! **          # 需明确注释指明
    case 5:
        // code executed for values 4 and 5
        break;
    default:
        // ...
        break;
}
```

## ?: 操作符
```objective-c
// Preferred:

NSInteger value = 5;
result = (value != 0) ? x : y;

BOOL isHorizontal = YES;
result = isHorizontal ? x : y;

// Not Preferred:
result = a > b ? x = c > d ? c : d : y;
```

## CGRect 方法
访问一个 CGRect 的 `x`, `y`, `width`, `height` 时，尽量使用[CGGeometry functions](http://developer.apple.com/library/ios/#documentation/graphicsimaging/reference/CGGeometry/Reference/reference.html)而不是直接访问。
```objective-c
// Preferred:

CGRect frame = self.view.frame;

CGFloat x = CGRectGetMinX(frame);
CGFloat y = CGRectGetMinY(frame);
CGFloat width = CGRectGetWidth(frame);
CGFloat height = CGRectGetHeight(frame);
CGRect frame = CGRectMake(0.0, 0.0, width, height);

// Not Preferred:
CGRect frame = self.view.frame;

CGFloat x = frame.origin.x;
CGFloat y = frame.origin.y;
CGFloat width = frame.size.width;
CGFloat height = frame.size.height;
CGRect frame = (CGRect){ .origin = CGPointZero, .size = frame.size };
```

## Golden Path
When coding with conditionals, the left hand margin of the code should be the "golden" or "happy" path. That is, don't nest if statements. Multiple return statements are OK.

```objective-c
// Preferred:
- (void)someMethod
{
    if (![someOther boolValue]) {
        return;
    }

    // Do something important
}

// Not Preferred:
- (void)someMethod
{
    if ([someOther boolValue]) {
        // Do something important
    }
}
```

## 处理 NSError
```objective-c
// Preferred:
NSError *error;
if (![self trySomethingWithError:&error]) {
    // Handle Error
}

// Not Preferred:
NSError *error;
[self trySomethingWithError:&error];
if (error) {
    // Handle Error
}
```

## storyboard 使用

项目中尽量使用 storyboard，减少使用 xib，尽量不用代码创建视图。使用 storyboard 时，根据模块的复杂度，如果一个模块的视图较少，可以全部放到单一的 storyboard 中，如果较多，继续拆分。

一个 ViewController A，对于外部使用者而言，不应该暴露 A 是使用了怎样的创建视图方式，使用 storyboard 时，规约为重载 init 方法，外部调用时直接调用 init，或 initWithParamsXXX
```objective-c
- (instancetype)init
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HotelDetail" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"hotelDetail"];
    if (self) {
    }
    return self;
}

- (instancetype)initWithXXXXXXXX
{
    if ([self init]) {
        // do something.
    }
    return self;
}
```
