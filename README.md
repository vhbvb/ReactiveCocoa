目录
===
[toc]

1.ReactiveCocoa简介
===

ReactiveCocoa（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的新框架:https://github.com/ReactiveCocoa/ReactiveCocoa

ReactiveCocoa是一个高度抽象的编程框架，它真的很抽象，初看你不知道它是要干嘛的，等你用上了之后，就发现，有了它你是想干嘛就干嘛，编码从未如此流畅。它就像中国的太极，太极生两仪，两仪生四象，四象生八卦，八卦生万物。(ps:这话不是我说的 😯)

2.MVVM 架构
===
（参考：http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/）

MVC
---

任何一个正经开发过一阵子软件的人都熟悉MVC，它意思是Model View Controller, 是一个在复杂应用设计中组织代码的公认模式. 它也被证实在 iOS 开发中有着第二种含义: Massive View Controller(重量级视图控制器)。它让许多程序员绞尽脑汁如何去使代码被解耦和组织地让人满意. 总的来说得出结论: 他们需要给视图控制器瘦身, 并进一步分离业务逻辑;

MVVM
---

于是MVVM流行起来, 它代表Model View View-Model, 它在这帮助我们创建更易处理, 更佳设计的代码.

### 定义：

1. **Model**： 在 MVVM 中没有真正的变化. 取决于你的偏好, 你的 model 可能会或可能不会封装一些额外的业务逻辑工作。

2. **View** ：包含实际 UI 本身(不论是 UIView 代码, storyboard 和 xib), 任何视图特定的逻辑, 和对用户输入的反馈. 在 iOS 中这不仅需要 UIView 代码和那些文件, 还包括很多需由 UIViewController 处理的工作。

3. **View-Model** ：这个术语本身会带来困惑, 因为它混搭了两个我们已知的术语, 但却是完全不同的东东.  它的职责之一就是作为一个表现视图显示自身所需数据的静态模型;但它也有收集, 解释和转换那些数据的责任. 这留给了 view (controller) 一个更加清晰明确的任务: 呈现由 view-model 提供的数据。（说白了就是数据的请求，到模型化再到解释到view）

也许你有注意到没有控制器：我们并没有真的去除视图控制器的概念或抛弃 “controller” 术语来匹配 MVVM。我们正要将重合的那块工作剥离到 view-model 中, 并让视图控制器的生活更加简单。

![image](http://cc.cocimg.com/api/uploads/20150525/1432542301497557.gif)

### View-Model 实例


#### 我们的 view-model 头文件应该长这样:

```
//MYTwitterLookupViewModel.h
@interface MYTwitterLookupViewModel: NSObject
  
@property (nonatomic, assign, readonly, getter=isUsernameValid) BOOL usernameValid;
@property (nonatomic, strong, readonly) NSString *userFullName;
@property (nonatomic, strong, readonly) UIImage *userAvatarImage;
@property (nonatomic, strong, readonly) NSArray *tweets;
@property (nonatomic, assign, readonly) BOOL allTweetsLoaded;
  
@property (nonatomic, strong, readwrite) NSString *username;
  
- (void) getTweetsForCurrentUsername;
- (void) loadMoreTweets;

```
相当直截了当的填充. 注意到这些壮丽的 readonly 属性了么?这个 view-model 暴漏了视图控制器所必需的最小量信息, 视图控制器实际上并不在乎 view-model 是如何获得这些信息的. 现在我们两者都不在乎. 仅仅假定你习惯于标准的网络服务请求, 校验, 数据操作和存储.

#### view-model 不做的事儿

对视图控制器以任何形式直接起作用或直接通告其变化
View Controller(视图控制器)

#### 视图控制器从 view-model 获取的数据将用来:

1. 当 usernameValid 的值发生变化时触发 “Go” 按钮的 enabled 属性
2. 当 usernameValid 等于 NO 时调整按钮的 alpha 值为0. 5(等于 YES 时设为1. 0)
3. 更新 UILable 的 text 属性为字符串 userFullName 的值
4. 更新 UIImageView 的 image 属性为 userAvatarImage 的值
5. 用 tweets 数组中的对象设置表格视图中的 cell (后面会提到)
6. 当滑到表格视图底部时如果 allTweetsLoaded 为 NO, 提供一个 显示 “loading” 的 cell

#### 视图控制器将对 view-model 起如下作用:

1. 每当 UITextField 中的文本发生变化, 更新 view-model 上仅有的 readwrite 属性 username
2. 当 “Go” 按钮被按下时调用 view-model 上的 getTweetsForCurrentUsername 方法
3. 当到达表格中的 “loading” cell 时调用 view-model 上的 loadMoreTweets 方法
 
#### 视图控制器不做的事儿:

1. 发起网络服务调用
2. 管理 tweets 数组
3. 判定 username 内容是否有效
4. 将用户的姓和名格式化为全名
5. 下载用户头像并转成 UIImage(如果你习惯在 UIImageView 上使用类别从网络加载图片, 你可以暴漏 URL 而不是图片. 这样没有让 view-model 和 UIKit 更完全摆脱, 但我视 UIImage 为数据而非数据的确切显示. 这些东西不是固定死的. )

==注意==: 视图控制器总的责任是处理 view-model 中的变化.

介绍 ReactiveCocoa
===

1 .RACSignal 
---
### 定义：
信号类,一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。

### 说明:
1. 信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。

2. 默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。

3. 如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。


### 代码


```
//
//  RACSignalViewController.m
//  RACSignal
//
//  Created by youzu_Max on 2017/3/29.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACSignalViewController.h"


@interface RACSignalViewController ()

@property(nonatomic,strong) id subscriber ;

@end

@implementation RACSignalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"block excute");
        [subscriber sendNext:@"haha"];
        _subscriber = subscriber ;//如果不保存的话就会自动[subscriber sendCompleted];

        RACDisposable * disponse = [RACDisposable disposableWithBlock:^{
            NSLog(@"当信号发送完成或者发送错误，就会自动执行这个block,执行完Block后，当前信号就不在被订阅了。");
        }];
        
        return disponse ;
    }];
    
    // 订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"receive:%@",x]);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"receive:%@",x]);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_subscriber sendNext:@"lol"];
    [_subscriber sendCompleted];
    [_subscriber sendNext:@"lalala"]; // 不会执行
}
```
### 注意事项 
1. subscriber 需要保存，不保存则自动发送结束

2. 每订阅一次，创建信号方法传入的block就会被执行一次。（不想这样参考RACMulticastConnection）；

3. 每次订阅，都会创建一个subscriber,一次订阅对应一个subscriber ; 

4. RACSubscriber:表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。

5. RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。不想监听某个信号时，可以通过它主动取消订阅信号。

### 初始化方法


```

- (void)doNext
{
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        _subscriber = subscriber ;
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@"1"];之前会调用这个Block
        NSLog(@"%@",[x stringByAppendingString:@"doNext"]);
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

// 设置延时
- (void)timeout
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {\
        
        //发送一个延时请求。
        return nil;
    }] timeout:10 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        // 10秒后会自动调用
        NSLog(@"%@",error);
    }];
}

//定时器
- (void)timer
{
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        
        NSLog(@"timer : %@",x);
    }];
}

//延时
- (void)delay
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        _delaySubscriber = subscriber ;
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

// 只要失败，就会重新执行创建信号中的block,直到成功
- (void)retry
{
    __block int i = 10;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i--) {
            NSLog(@"报一个错误");
            [subscriber sendError:nil];
        }
        else
        {
           [subscriber sendNext:@"重要不报错了"];
        }
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        
    }];
}

- (void)replay
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
        
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者%@",x);
        
    }];
}

// 节流
- (void)throttle
{
    RACSubject *signal = [RACSubject subject];
    // 节流，在一定时间（10秒）内，不接收任何信号内容，过了这个时间（10秒）获取最后发送的信号内容发出。
    [[signal throttle:10] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

```


2 .RACSubject
---

### 定义

就是一个RACSignal,集成了<RACSubscriber> 协议 。

### 说明

可以用来做代理使用

### 代码

```Objc

RACSubject * subject = [RACSubject subject];

[subject subscribeNext:^(id  _Nullable x) {
    NSLog(@"%@",[NSString stringWithFormat:@"张三先关注一波:%@",x]);
}];
    

[subject subscribeNext:^(id  _Nullable x) {
    NSLog(@"%@",[NSString stringWithFormat:@"李四也关注一波:%@",x]);
}];
    
[subject sendNext:@"大红包"];
    
```

### 代替代理的场景 

在第二个控制器内部通过segVC改变第一个控制里的label.

#### OneViewController 中代码：
```
#import "OneViewController.h"
#import "TwoViewController.h"

@interface OneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)jump:(id)sender
{
    TwoViewController * vc = [TwoViewController new];
    
    vc.subject = [RACSubject subject];
    
    [vc.subject subscribeNext:^(id  _Nullable x) {
        
        NSNumber * index = x ;
        _name.text = @[@"小明",@"小华",@"小芳"][index.intValue];
        
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end

```

#### TwoViewController 中的代码


```
@interface TwoViewController ()

@property(nonatomic ,strong) RACSubject * subject ;

@end


@implementation TwoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)change:(UISegmentedControl *)sender
{
    if (_subject)
    {
        [_subject sendNext:@(sender.selectedSegmentIndex)];
    }
}
```

### 注意 

代理拿不到回调。只能正向传值 。

3 . RACReplaySubject 
---

#### 定义：

重复提供信号类，RACSubject的子类。

RACReplaySubject与RACSubject区别:
RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。

#### 说明 ：

使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。

使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。

#### 代码

```
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //大家好，我是土豪
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //张三关注了土豪
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"张三收到红包：%@",x]);
    }];
    
    //土豪发红包了
    [replaySubject sendNext:@"1个亿"];
    
    //李四看张三发财了也关注了土豪，并表示红包没抢到，要求重发
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"李四收到红包：%@",x]);
    }];
    
    //土豪表示，钱不是问题，不但重发，还把之前你没抢到的也发给你。
    [replaySubject sendNext:@"1毛钱"];
    
}
```

**log:**

```
2017-03-30 12:26:54.890 ReactiveCocoa[39418:1278518] 张三收到红包：1个亿
2017-03-30 12:26:54.890 ReactiveCocoa[39418:1278518] 李四收到红包：1个亿
2017-03-30 12:26:54.890 ReactiveCocoa[39418:1278518] 张三收到红包：1毛钱
2017-03-30 12:26:54.891 ReactiveCocoa[39418:1278518] 李四收到红包：1毛钱
```

4 . RACMulticastConnection
---
### 定义

用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。

### 说明

创建： RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.

### 代码

 NSLog(@"--->%@ ,times:%zd",subscriber,++times); 只会打印一次。

```
//
//  RACMulticastConnectionViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/30.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACMulticastConnectionViewController.h"

@interface RACMulticastConnectionViewController ()
{
    RACSignal *_signal ;
    id<RACSubscriber>  _Nonnull _subscriber ;
}

@end

@implementation RACMulticastConnectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block NSInteger times ;
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"--->%@ ,times:%zd",subscriber,++times);
        _subscriber = subscriber ;
        
        return nil ;
    }];
    
    
//    [signal subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"1 --> %@",x);
//    }];
//    
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"2 --> %@",x);
//    }];
    
//    _signal = signal ;
    
    static RACMulticastConnection *connect = nil ;
    
    if (!connect)
    {
        connect = [signal publish] ;
    }
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection  -->   %@",x);
    }];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection  -->   %@",x);
    }];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection  -->   %@",x);
    }];
    
    [connect connect];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_subscriber sendNext:@"sendedData"];
}

@end

```

### 注意 

subsciber 会给所有的订阅者发送消息。（类似与RACSubject），虽然subScriber只被保存了一次。

点击屏幕后
**log:**

```
2017-03-30 12:39:11.736 ReactiveCocoa[39608:1284448] ---><RACPassthroughSubscriber: 0x600000228b60> ,times:1
2017-03-30 12:39:15.766 ReactiveCocoa[39608:1284448] RACMulticastConnection  -->   sendedData
2017-03-30 12:39:15.767 ReactiveCocoa[39608:1284448] RACMulticastConnection  -->   sendedData
2017-03-30 12:39:15.768 ReactiveCocoa[39608:1284448] RACMulticastConnection  -->   sendedData
```

5 .RACCommand
---

### 定义 ：
RAC中用于处理事件的类。可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。比如：网络请求，点击事件等。

### 说明
RACCommand的实例能够决定是否可以被执行，这个特性能反应在UI上，而且它能确保在其不可用时不会被执行。通常，当一个命令可以执行时，会将它的属性allowsConcurrentExecution设置为它的默认值：NO，从而确保在这个命令已经正在执行的时候，不会同时再执行新的操作。命令执行的返回值是一个RACSignal，因此我们能对该返回值进行next:，completed或error:

### 代码

```
//
//  RACCommandViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/30.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACCommandViewController.h"

@interface RACCommandViewController ()
{
    RACCommand * _command ;
}

@end

@implementation RACCommandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input){

        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"%@",input);
            MOBAWxArticleRequest * req = [MOBAWxArticleRequest wxArticleCategoryRequest];
            
            [MobAPI sendRequest:req onResult:^(MOBAResponse *response) {
                [subscriber sendNext:response.responder];
                [subscriber sendCompleted];
            }];
            
            return nil ;
        }] ;
        
        return signal ;
        
    }];


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    //先订阅
//    [_command.executionSignals subscribeNext:^(id  _Nullable x) {
//        
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"normal -> %@",x);
//        }];
//    }];
    
    //也可以这样写
    [_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"vip --> %@",x);
    }];


    //监听command的状态
    [[_command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue)
        {
            NSLog(@"excuting...");
        }
        else
        {
            NSLog(@"not excuted");
        }
    }];
    
    //在执行
    [_command execute:@"参数"];
    
}

@end

```
### 注意
1. RACommand本身也是信号类, 属性executionSignals是一个信号中的信号
所以command执行，我得到的数据x时一个RACSignal包装的数据。需要再次订阅这个signal才能拿到数据。

2. 以下初始化方法可以创建一个信号觉得command的状态是执行还是不可执行的。

```
- (instancetype)initWithEnabled:(nullable RACSignal<NSNumber *> *)enabledSignal signalBlock:(RACSignal<ValueType> * (^)(InputType _Nullable input))signalBlock;
```

6 . others
--

#### 1. RACTuple:元组类

类似NSArray,用来包装值.

#### 2. RACSequence:集合类

用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。

#### 3. RACScheduler

针对RAC中的队列，GCD的封装。

#### 4. RACEvent

把数据包装成信号事件(signalevent)。它主要通过RACSignal的-materialize来使用，然并卵

#### 4. RACUnit

表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.

#### 实例代码

```
 // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    [numbers.rac_sequence.signal subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];
```

```
// 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"1":@"a",@"2":@"b"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {

        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;

        // 相当于以下写法
//        NSString *key = x[0];
//        NSString *value = x[1];

        NSLog(@"%@ %@",key,value);

    }];

```

7 . RAC 常用方法
---

#### 1. rac_signalForSelector

NSObject的分类，hook的方式 ，返回参数x是原方法传入参数的tuple 


```
 [[self rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
```


#### 2. rac_valuesAndChangesForKeyPath

KVO的RAC写法


```
    [[self rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {

        NSLog(@"%@",x);

    }];
```


#### 3. rac_signalForControlEvents
把事件封装成singnal

```
[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        NSLog(@"%@"，x);
    }];
```


#### 4. rac_addObserverForName 
RAC 的通知写法

```
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
```

#### 5. rac_textSignal
监听文本框文字改变
只要文本框发出改变就会发出这个信号。

```
  [_textField.rac_textSignal subscribeNext:^(id x) {

       NSLog(@"文字改变了%@",x);
   }];
```


#### 6. rac_liftSelector:withSignalsFromArray:Signals:
当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。


```
    RACSignal *req1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        // 发送请求
        [subscriber sendNext:@"1"];
        return nil;
    }];
    
        RACSignal *req2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        [subscriber sendNext:@"2"];
        return nil;
    }];

    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWith1:2:) withSignalsFromArray:@[request1,request2]];


}
// 更新UI
- (void)updateUIWith1:(id)x1 2:(id)x2
{
    NSLog(@"%@  %@",x1,x2);
}
```

#### 7. map 和 flattenMap （映射）

通过此方法可以在拿到信号发送的数据前 执行一些操作 在把我们操作操作过的值发送出去。


```
    RACSignal *signal = [self.textFiled.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [value stringByAppendingString:@"+修改一下"];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
```


```

```




注意 ：信号数组的长度等于@selector的方法参数数量，响应方法的时候会被一一填充。

8 . RACSignal常见操作方法
---
### 1. concat :

按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。

#### 代码：
```
//按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
- (IBAction)concat:(id)sender
{
    NSLog(@"****************** concat ******************");
    
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    RACSignal *concatSignal = [signalA concat:signalB] ;
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat:%@",x);
    }];
    
    [subscriberA sendNext:@"A"];
    [subscriberA sendCompleted];//一定要调complete
    
    [subscriberB sendNext:@"B"];

}
```
#### 说明：
如果subscriberB 先发送则不会有任何打印消息。

### 2. then :
用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
#### 代码
```
    NSLog(@"****************** then ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberThen ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalThen = [signalA then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            subscriberThen = subscriber ;
            return nil ;
        }];
    }];
    
    //  A的订阅会被忽略掉。
    [signalA subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalThen subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subscriberA sendNext:@"A"];
    [subscriberA sendCompleted];//一定要调complete
    
    [subscriberThen sendNext:@"B"];
    [subscriberThen sendCompleted];
```

#### 说明
A发送完成后一定要调sendCompleted ；
A的订阅会被忽略。只有then信号的订阅收到信号。


### 3. merge ：
把多个信号合并为一个信号，任何一个信号有新值的时候就会调用.
#### 代码

```
 NSLog(@"****************** merge ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberB sendNext:@"B sended"];

```
### 4. zipWith:

#### 把2个信号合并成一个信号，2个信号都发送时，zip信号才会发送消息。


```
    NSLog(@"****************** zipWith ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberB sendNext:@"B sended"];
    [subscriberA sendNext:@"A sended2"];
    [subscriberB sendNext:@"B sended2"];
```

### 5. combineLatest:
将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
#### 代码

```
NSLog(@"****************** combineLatest ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    id<RACSubscriber>  __block subscriberC ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberC = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
//    RACSignal *combineSignal = [[signalA combineLatestWith:signalB] combineLatestWith:signalC];
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[signalA,signalB,signalC]];

    [combineSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberA sendNext:@"A sended 2"];
    
    [subscriberB sendNext:@"B sended"];
    
    [subscriberC sendNext:@"C sended"];
    [subscriberC sendNext:@"C sended 2"];

```
#### 说明
对比与zipWith,它会不停的更新为最新的值。

### 6. reduce:
就是combine 发送的信号 在reduce block里面处理后发送出去。


```
- (IBAction)reduce:(id)sender
{
    
    NSLog(@"****************** combineLatest ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    id<RACSubscriber>  __block subscriberC ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberC = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    //    RACSignal *combineSignal = [[signalA combineLatestWith:signalB] combineLatestWith:signalC];
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[signalA,signalB,signalC] reduce:^id(NSString *a,NSString *b,NSString *c){
        
        return [@[a,b,c] componentsJoinedByString:@" + "];
    }];
    
    [combineSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberA sendNext:@"A sended 2"];
    
    [subscriberB sendNext:@"B sended"];
    
    [subscriberC sendNext:@"C sended"];
    [subscriberC sendNext:@"C sended 2"];
}

```

### 7. filter ：
过滤信号，使用它可以获取满足条件的信号 

#### 代码
```
    /* 过滤信号，使用它可以获取满足条件的信号 */
    [[_textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3 ;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter -> %@",x);
    }];
```

### 8. ignore ：
忽略完某些值的信号

#### 代码


```
[[_textField.rac_textSignal ignore:@"MOB"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"ignore ->%@",x);
    }];
```
### 9. distinctUntilChanged
当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉
#### 代码

```

    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"distinctUntilChanged -> %@",x);
    }];
```

### 10. take/takeLast

取前几次 / 取最后几次  发送的信号

#### 代码


```
   [[_textField.rac_textSignal take:2] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"take -> %@",x);
    }];
    
   [[_textField.rac_textSignal takeLast :3] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"takeLast -> %@",x);
    }];
```
#### 说明
takeLast 一定要调用sendComplete。不然不知道什么是结束。也就没有最后的概念。返回的是tuple

### 11. skip
跳过几次信号发送

#### 代码

```
[[_textField.rac_textSignal skip:2] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"skip -> %@",x);
    }];
```


9 .RAC 常用的宏 
---

### 1. RAC(TARGET, ...)

```
// content属性值随着输入框值得变化而变化。
    @property (nonatomic ,copy) NSString *content ;
    
    RAC(self,content) = _textField.rac_textSignal ;
```

### 2.RACObserve(<#TARGET#>, <#KEYPATH#>)

```
    [RACObserve(self, content) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
```

### 3. @weakify(self)和@strongify(self) 

一定要配套使用，实现原理：


```
    @weakify(self);
    [[self rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@" test ----> %@",x);
    }];
    
    __weak typeof(self) weakSelf = self ;
    [[self rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id  _Nullable x) {
        id self = weakSelf ;
        
        NSLog(@" test ----> %@",x);
    }];

```

### 4. RACTuplePack(...) /  RACTupleUnpack(...)

把数据包装成元组类/解析元组


```
    RACTuple *tuple = RACTuplePack(@"1314",@20);
    
    RACTupleUnpack(NSString *a,NSNumber *b) = tuple;

    NSLog(@"%@,%@",a,b);
```

Reactive 5.0 更新
===

参考自：http://www.cocoachina.com/ios/20161116/18104.html

RAC 5.0 相比于 4.0 有了巨大的变化，不仅是受 swift 3.0 大升级的影响，RAC 对自身项目结构的也进行了大幅度的调整。这个调整就是将 RAC 拆分为四个库：ReactiveCocoa、ReactiveSwift、ReactiveObjC、ReactiveObjCBridge。

###  ReactiveCocoa

现在的 RAC 注意力主要集中在 Swift 和 UI 层上，将原来一个基于 RAC 面向 UI 层的扩展库 Rex 合并进了 RAC 。

RAC 3 和 4 的主要精力在围绕 Swift 重新打造一个响应式编程库。因为这部分的核心 API 已经很成熟，所以现在将重心放在为 AppKit 和 UIKit 提供一些更好用的扩展上。

### ReactiveSwift

原来 RAC 中只和 Swift 平台相关的核心代码被单独抽取成了一个新框架：ReactiveSwift 。

Swift 正在快速成长并且成长为一个跨平台的语言。把只和 Swift 相关的代码抽取出来后，ReactiveSwift 就可以在其他平台上被使用，而不只是局限在 CocoaTouch 和 Cocoa 中。

### ReactiveObjC

在 RAC 3 和 4 中，RAC 也包含了 RAC 2 中的 OC 代码。现在这部分代码被移到了 ReactiveObjC 。

这样做的原因是因为两个库虽然有着一样的核心编程范式，实际上却是完全独立的两套 API 。实际的使用中，RAC 4 和 RAC 2 是完全不同的两组用户群，并且维护的团队其实也是两组。之前混在一个库里也增加了管理的复杂度。拆分出去后也可以更加自由的维护 ReactiveObjC 。

### ReactiveObjCBridge

在把 Swift 和 OC 的库拆分之后问题来了，并不是所有的库都是纯 OC 和 Swift 的。有相当大一部分项目处于 OC 迁移到 Swift 过程中，其中可能使用 Swift 调用了 RAC 2 中基于 OC 写的 API。为了解决这部分用户的问题，所以有了 ReactiveObjCBridge 。

### 大量的Api的改变和重命名。

比如API 都放在了 reactive 后。不再是原先的 rac_xx 。
增加了生命周期 lifetime 的属性等等 。


### 最后 ？

![image](http://cc.cocimg.com/api/uploads/20161116/1479260442604874.jpg)