# Run Loops
> [原文链接：Run Loops](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html#//apple_ref/doc/uid/10000057i-CH16-SW1)

运行循环是基础架构的其中一部分，它与线程是一一对应。运行循环是一种事件处理循环，可用于安排工作和协调收到的事件。运行循环目的是让线程在有工作的时候忙碌，而在没有工作的时候睡眠。

运行循环管理不是完全自动的。你必须设计线程代码以在适当的时间启动运行循环并响应传入的事件。Cocoa和Core Foundation都提供了运行循环对象，以帮助您配置和管理线程的运行循环。你的应用程序不需要显式创建这些对象。每个线程（包括应用程序的主线程）都有一个关联的运行循环对象。只有子线程才需要显式地运行其运行循环。在应用程序启动过程中，应用程序框架会自动在主线程上设置并运行运行循环。

接下来的章节将会提供有关运行循环以及如何为应用程序配置循环的更多信息。有关运行循环对象的其他信息，请参考[NSRunLoop类参考](https://developer.apple.com/documentation/foundation/nsrunloop)和[CFRunLoop参考](https://developer.apple.com/documentation/corefoundation/cfrunloop)。

## 剖析 Run Loop
A run loop is very much like its name sounds. It is a loop your thread enters and uses to run event handlers in response to incoming events. Your code provides the control statements used to implement the actual loop portion of the run loop—in other words, your code provides the while or for loop that drives the run loop. Within your loop, you use a run loop object to "run” the event-processing code that receives events and calls the installed handlers.

A run loop receives events from two different types of sources. Input sources deliver asynchronous events, usually messages from another thread or from a different application. Timer sources deliver synchronous events, occurring at a scheduled time or repeating interval. Both types of source use an application-specific handler routine to process the event when it arrives.

Figure 3-1 shows the conceptual structure of a run loop and a variety of sources. The input sources deliver asynchronous events to the corresponding handlers and cause the runUntilDate: method (called on the thread’s associated NSRunLoop object) to exit. Timer sources deliver events to their handler routines but do not cause the run loop to exit.

运行循环非常像其名称听起来。这是您的线程进入的一个循环，用于响应传入事件而运行事件处理程序。您的代码提供了用于实现运行循环的实际循环部分的控制语句-换句话说，您的代码提供了驱动运行循环的whileor for循环。在循环内，您可以使用运行循环对象来“运行”事件处理代码，以接收事件并调用已安装的处理程序。

运行循环从两种不同类型的源接收事件。输入源传递异步事件，通常是来自另一个线程或其他应用程序的消息。计时器源传递同步事件，这些事件在计划的时间或重复的间隔发生。两种类型的源都使用特定于应用程序的处理程序例程来处理事件到达时的事件。

图3-1显示了运行循环和各种来源的概念结构。输入源将异步事件传递给相应的处理程序，并导致runUntilDate:方法（在线程的关联NSRunLoop对象上调用）退出。计时器源将事件传递到其处理程序例程，但不会导致运行循环退出。

**Figure 3-1**  Structure of a run loop and its sources

![](/imgs/runloop.jpg)

In addition to handling sources of input, run loops also generate notifications about the run loop’s behavior. Registered run-loop observers can receive these notifications and use them to do additional processing on the thread. You use Core Foundation to install run-loop observers on your threads.

The following sections provide more information about the components of a run loop and the modes in which they operate. They also describe the notifications that are generated at different times during the handling of events.

除了处理输入源之外，运行循环还生成有关运行循环行为的通知。注册的运行循环观察者可以接收这些通知，并使用它们在线程上进行其他处理。您可以使用Core Foundation在线程上安装运行循环观察器。

以下各节提供有关运行循环的组件及其运行方式的更多信息。它们还描述了事件处理期间在不同时间生成的通知。

### Run Loop Modes
A run loop mode is a collection of input sources and timers to be monitored and a collection of run loop observers to be notified. Each time you run your run loop, you specify (either explicitly or implicitly) a particular “mode” in which to run. During that pass of the run loop, only sources associated with that mode are monitored and allowed to deliver their events. (Similarly, only observers associated with that mode are notified of the run loop’s progress.) Sources associated with other modes hold on to any new events until subsequent passes through the loop in the appropriate mode.

In your code, you identify modes by name. Both Cocoa and Core Foundation define a default mode and several commonly used modes, along with strings for specifying those modes in your code. You can define custom modes by simply specifying a custom string for the mode name. Although the names you assign to custom modes are arbitrary, the contents of those modes are not. You must be sure to add one or more input sources, timers, or run-loop observers to any modes you create for them to be useful.

You use modes to filter out events from unwanted sources during a particular pass through your run loop. Most of the time, you will want to run your run loop in the system-defined “default” mode. A modal panel, however, might run in the “modal” mode. While in this mode, only sources relevant to the modal panel would deliver events to the thread. For secondary threads, you might use custom modes to prevent low-priority sources from delivering events during time-critical operations.

一个运行的循环模式是输入源和定时器的集合进行监测和运行循环观察员集合通知。每次运行运行循环时，都可以（显式或隐式）指定运行的特定“模式”。在运行循环的整个过程中，仅监视与该模式关联的源，并允许其传递事件。（类似地，仅将与该模式关联的观察者通知运行循环的进度。）与其他模式关联的源将保留任何新事件，直到随后以适当的模式通过循环。

在代码中，您可以通过名称识别模式。Cocoa和Core Foundation都定义了默认模式和几种常用模式，以及用于在代码中指定这些模式的字符串。您可以通过简单地为模式名称指定自定义字符串来定义自定义模式。尽管您分配给自​​定义模式的名称是任意的，但是这些模式的内容不是任意的。您必须确保将一个或多个输入源，计时器或运行循环观察器添加到您创建的任何模式中，以使其有用。

您可以使用模式从运行循环的特定遍历中过滤掉有害来源的事件。大多数情况下，您将需要在系统定义的“默认”模式下运行运行循环。但是，模式面板可以在“模式”模式下运行。在这种模式下，只有与模式面板相关的源才将事件传递给线程。对于辅助线程，您可以使用自定义模式来防止低优先级源在时间紧迫的操作期间传递事件。

> Note: Modes discriminate based on the source of the event, not the type of the event. For example, you would not use modes to match only mouse-down events or only keyboard events. You could use modes to listen to a different set of ports, suspend timers temporarily, or otherwise change the sources and run loop observers currently being monitored.
> 
> 注意：  模式是根据事件的来源而不是事件的类型来区分的。例如，您不会使用仅匹配鼠标按下事件或仅匹配键盘事件的模式。您可以使用模式来侦听另一组端口，暂时暂停计时器，或者以其他方式更改源并运行当前正在监视的循环观察器

Table 3-1 lists the standard modes defined by Cocoa and Core Foundation along with a description of when you use that mode. The name column lists the actual constants you use to specify the mode in your code.

表3-1列出了Cocoa和Core Foundation定义的标准模式，以及何时使用该模式的说明。名称列列出了用于在代码中指定模式的实际常量。

Table 3-1  Predefined run loop modes

| Mode | Name | Description |
| :-----| :-----| :----- |
| Default | NSDefaultRunLoopMode (Cocoa) kCFRunLoopDefaultMode (Core Foundation) | The default mode is the one used for most operations. Most of the time, you should use this mode to start your run loop and configure your input sources。默认模式是用于大多数操作的模式。大多数时候，您应该使用此模式来启动运行循环并配置输入源。|
| Connection |  NSConnectionReplyMode (Cocoa) | Cocoa uses this mode in conjunction with NSConnection objects to monitor replies. You should rarely need to use this mode yourself。可可将此模式与 NSConnection 对象结合使用以监视答复。您很少需要自己使用此模式。|
| Modal | NSModalPanelRunLoopMode (Cocoa) | Cocoa uses this mode to identify events intended for modal panels. 可可使用此模式来识别用于模式面板的事件。|
| Event tracking | NSEventTrackingRunLoopMode (Cocoa) | Cocoa uses this mode to restrict incoming events during mouse-dragging loops and other sorts of user interface tracking loops. 可可使用此模式来限制鼠标拖动循环和其他类型的用户界面跟踪循环期间的传入事件。|
| Common modes | NSRunLoopCommonModes (Cocoa) kCFRunLoopCommonModes (Core Foundation) | This is a configurable group of commonly used modes. Associating an input source with this mode also associates it with each of the modes in the group. For Cocoa applications, this set includes the default, modal, and event tracking modes by default. Core Foundation includes just the default mode initially. You can add custom modes to the set using the CFRunLoopAddCommonMode function.  这是一组可配置的常用模式。将输入源与此模式相关联还将其与组中的每个模式相关联。对于Cocoa应用程序，此集合默认包括默认，模式和事件跟踪模式。最初，Core Foundation仅包括默认模式。您可以使用该CFRunLoopAddCommonMode功能将自定义模式添加到集合中。 |


### Input Sources
Input sources deliver events asynchronously to your threads. The source of the event depends on the type of the input source, which is generally one of two categories. Port-based input sources monitor your application’s Mach ports. Custom input sources monitor custom sources of events. As far as your run loop is concerned, it should not matter whether an input source is port-based or custom. The system typically implements input sources of both types that you can use as is. The only difference between the two sources is how they are signaled. Port-based sources are signaled automatically by the kernel, and custom sources must be signaled manually from another thread.

When you create an input source, you assign it to one or more modes of your run loop. Modes affect which input sources are monitored at any given moment. Most of the time, you run the run loop in the default mode, but you can specify custom modes too. If an input source is not in the currently monitored mode, any events it generates are held until the run loop runs in the correct mode.

The following sections describe some of the input sources.

输入源将事件异步传递到您的线程。事件的来源取决于输入来源的类型，通常是两个类别之一。基于端口的输入源监视您的应用程序的Mach端口。定制输入源监视事件的定制源。就您的运行循环而言，输入源是基于端口的还是定制的都无关紧要。系统通常实现两种类型的输入源，您可以按原样使用。两种信号源之间的唯一区别是信号的发送方式。基于端口的源由内核自动发出信号，而自定义源必须从另一个线程手动发出信号。

创建输入源时，可以将其分配给运行循环的一种或多种模式。模式会影响在任何给定时刻监视哪些输入源。大多数情况下，您会在默认模式下运行运行循环，但也可以指定自定义模式。如果输入源不在当前监视的模式下，则它生成的任何事件都将保留，直到运行循环以正确的模式运行。

以下各节描述了一些输入源。

### Port-Based Sources

Cocoa and Core Foundation provide built-in support for creating port-based input sources using port-related objects and functions. For example, in Cocoa, you never have to create an input source directly at all. You simply create a port object and use the methods of NSPort to add that port to the run loop. The port object handles the creation and configuration of the needed input source for you.

In Core Foundation, you must manually create both the port and its run loop source. In both cases, you use the functions associated with the port opaque type (CFMachPortRef, CFMessagePortRef, or CFSocketRef) to create the appropriate objects.

For examples of how to set up and configure custom port-based sources, see Configuring a Port-Based Input Source.

Cocoa和Core Foundation提供了内置支持，用于使用与端口相关的对象和功能创建基于端口的输入源。例如，在可可中，您根本不必直接创建输入源。您只需创建一个端口对象，然后使用的方法NSPort将该端口添加到运行循环中。端口对象为您处理所需输入源的创建和配置。

在Core Foundation中，您必须手动创建端口及其运行循环源。在这两种情况下，您使用的端口类型不透明（相关的功能CFMachPortRef，CFMessagePortRef或CFSocketRef）创建合适的对象。

有关如何设置和配置基于端口的自定义源的示例，请参阅“ 配置基于端口的输入源”。

### Custom Input Sources
To create a custom input source, you must use the functions associated with the CFRunLoopSourceRef opaque type in Core Foundation. You configure a custom input source using several callback functions. Core Foundation calls these functions at different points to configure the source, handle any incoming events, and tear down the source when it is removed from the run loop.

In addition to defining the behavior of the custom source when an event arrives, you must also define the event delivery mechanism. This part of the source runs on a separate thread and is responsible for providing the input source with its data and for signaling it when that data is ready for processing. The event delivery mechanism is up to you but need not be overly complex.

For an example of how to create a custom input source, see Defining a Custom Input Source. For reference information for custom input sources, see also CFRunLoopSource Reference.

要创建自定义输入源，必须使用与CFRunLoopSourceRefCore Foundation中的不透明类型关联的功能。您可以使用多个回调函数配置自定义输入源。当从运行循环中删除源时，Core Foundation会在不同位置调用这些函数以配置源，处理所有传入事件并拆除源。

除了定义事件到达时自定义源的行为外，还必须定义事件传递机制。源代码的这一部分在单独的线程上运行，负责为输入源提供其数据，并在准备好处理数据时向其发出信号。事件传递机制取决于您，但不必过于复杂。

有关如何创建自定义输入源的示例，请参见定义自定义输入源。有关自定义输入源的参考信息，另请参见CFRunLoopSource参考。

### Cocoa Perform Selector Sources
In addition to port-based sources, Cocoa defines a custom input source that allows you to perform a selector on any thread. Like a port-based source, perform selector requests are serialized on the target thread, alleviating many of the synchronization problems that might occur with multiple methods being run on one thread. Unlike a port-based source, a perform selector source removes itself from the run loop after it performs its selector.

除了基于端口的源代码外，Cocoa还定义了一个自定义输入源，使您可以在任何线程上执行选择器。像基于端口的源一样，执行选择器请求在目标线程上被序列化，从而减轻了在一个线程上运行多个方法时可能发生的许多同步问题。与基于端口的源不同，执行选择器源在执行选择器后将其自身从运行循环中删除。

> Note: Prior to OS X v10.5, perform selector sources were used mostly to send messages to the main thread, but in OS X v10.5 and later and in iOS, you can use them to send messages to any thread.
> 
> 注意：  在OS X v10.5之前，执行选择器源主要用于将消息发送到主线程，但是在OS X v10.5和更高版本以及iOS中，可以使用它们将消息发送到任何线程。


When performing a selector on another thread, the target thread must have an active run loop. For threads you create, this means waiting until your code explicitly starts the run loop. Because the main thread starts its own run loop, however, you can begin issuing calls on that thread as soon as the application calls the applicationDidFinishLaunching: method of the application delegate. The run loop processes all queued perform selector calls each time through the loop, rather than processing one during each loop iteration.

Table 3-2 lists the methods defined on NSObject that can be used to perform selectors on other threads. Because these methods are declared on NSObject, you can use them from any threads where you have access to Objective-C objects, including POSIX threads. These methods do not actually create a new thread to perform the selector.

在另一个线程上执行选择器时，目标线程必须具有活动的运行循环。对于您创建的线程，这意味着等到您的代码显式启动运行循环。但是，由于主线程启动了自己的运行循环，因此您可以在应用程序调用applicationDidFinishLaunching:应用程序委托的方法后立即开始在该线程上发出调用 。每次循环时，运行循环都会处理所有排队的执行选择器调用，而不是在每次循环迭代时都处理一个。

表3-2列出了NSObject可在其他线程上执行选择器的方法。由于这些方法是在上声明的NSObject，因此可以在可以访问Objective-C对象的任何线程（包括POSIX线程）中使用它们。这些方法实际上不会创建新线程来执行选择器。

**Table 3-2**  Performing selectors on other threads

| Methods | Description|
|:-----   |:-----      |
|performSelectorOnMainThread:withObject:waitUntilDone: performSelectorOnMainThread:withObject:waitUntilDone:modes: |Performs the specified selector on the application’s main thread during that thread’s next run loop cycle. These methods give you the option of blocking the current thread until the selector is performed.在该线程的下一个运行循环周期内，在该应用程序的主线程上执行指定的选择器。这些方法使您可以选择阻塞当前线程，直到执行选择器为止。|
|performSelector:onThread:withObject:waitUntilDone: performSelector:onThread:withObject:waitUntilDone:modes:|Performs the specified selector on any thread for which you have an NSThread object. These methods give you the option of blocking the current thread until the selector is performed. 在具有NSThread对象的任何线程上执行指定的选择器。这些方法使您可以选择阻塞当前线程，直到执行选择器为止。|
|performSelector:withObject:afterDelay: performSelector:withObject:afterDelay:inModes:|Performs the specified selector on the current thread during the next run loop cycle and after an optional delay period. Because it waits until the next run loop cycle to perform the selector, these methods provide an automatic mini delay from the currently executing code. Multiple queued selectors are performed one after another in the order they were queued.在下一个运行循环周期和一个可选的延迟时间之后，在当前线程上执行指定的选择器。因为它一直等到下一个运行循环周期执行选择器，所以这些方法提供了当前执行代码的最小自动延迟。多个排队的选择器按照排队的顺序依次执行。|
|cancelPreviousPerformRequestsWithTarget: cancelPreviousPerformRequestsWithTarget:selector:object:|Lets you cancel a message sent to the current thread using the performSelector:withObject:afterDelay: or performSelector:withObject:afterDelay:inModes: method 使您可以使用performSelector:withObject:afterDelay:or performSelector:withObject:afterDelay:inModes:方法取消发送到当前线程的消息。|

For detailed information about each of these methods, see NSObject Class Reference.

有关每种方法的详细信息，请参见《NSObject类参考》。

### Timer Sources
Timer sources deliver events synchronously to your threads at a preset time in the future. Timers are a way for a thread to notify itself to do something. For example, a search field could use a timer to initiate an automatic search once a certain amount of time has passed between successive key strokes from the user. The use of this delay time gives the user a chance to type as much of the desired search string as possible before beginning the search.

Although it generates time-based notifications, a timer is not a real-time mechanism. Like input sources, timers are associated with specific modes of your run loop. If a timer is not in the mode currently being monitored by the run loop, it does not fire until you run the run loop in one of the timer’s supported modes. Similarly, if a timer fires when the run loop is in the middle of executing a handler routine, the timer waits until the next time through the run loop to invoke its handler routine. If the run loop is not running at all, the timer never fires.

You can configure timers to generate events only once or repeatedly. A repeating timer reschedules itself automatically based on the scheduled firing time, not the actual firing time. For example, if a timer is scheduled to fire at a particular time and every 5 seconds after that, the scheduled firing time will always fall on the original 5 second time intervals, even if the actual firing time gets delayed. If the firing time is delayed so much that it misses one or more of the scheduled firing times, the timer is fired only once for the missed time period. After firing for the missed period, the timer is rescheduled for the next scheduled firing time.

For more information on configuring timer sources, see Configuring Timer Sources. For reference information, see NSTimer Class Reference or CFRunLoopTimer Reference.

计时器源在将来的预设时间将事件同步传递到您的线程。计时器是线程通知自己执行某事的一种方式。例如，一旦在来自用户的连续击键之间经过了一定的时间量，则搜索字段可以使用计时器来启动自动搜索。使用此延迟时间使用户有机会在开始搜索之前键入尽可能多的所需搜索字符串。

尽管计时器生成基于时间的通知，但它不是实时机制。像输入源一样，计时器与运行循环的特定模式相关联。如果计时器不在运行循环当前正在监视的模式下，则在您以计时器支持的一种模式运行运行循环之前，它不会触发。同样，如果运行循环在执行处理程序例程的中间触发计时器，则计时器将等到下一次通过运行循环调用其处理例程。如果运行循环根本没有运行，则计时器永远不会触发。

您可以将计时器配置为仅一次或重复生成事件。重复计时器会根据计划的触发时间（而不是实际的触发时间）自动重新计划自身。例如，如果计划将计时器在特定时间触发，然后每5秒触发一次，则即使实际触发时间被延迟，计划的触发时间也将始终落在原始的5秒时间间隔上。如果触发时间延迟得太多，以致错过了一个或多个计划的触发时间，则计时器将在错过的时间段内仅触发一次。在错过了一段时间后触发后，计时器将重新安排为下一个计划的触发时间。

有关配置计时器源的更多信息，请参见“ 配置计时器源”。有关参考信息，请参见《NSTimer类参考》或《CFRunLoopTimer参考》。

### Run Loop Observers
In contrast to sources, which fire when an appropriate asynchronous or synchronous event occurs, run loop observers fire at special locations during the execution of the run loop itself. You might use run loop observers to prepare your thread to process a given event or to prepare the thread before it goes to sleep. You can associate run loop observers with the following events in your run loop:

- The entrance to the run loop.
- When the run loop is about to process a timer.
- When the run loop is about to process an input source.
- When the run loop is about to go to sleep.
- When the run loop has woken up, but before it has processed the event that woke it up.
- The exit from the run loop.

You can add run loop observers to apps using Core Foundation. To create a run loop observer, you create a new instance of the CFRunLoopObserverRef opaque type. This type keeps track of your custom callback function and the activities in which it is interested.

Similar to timers, run-loop observers can be used once or repeatedly. A one-shot observer removes itself from the run loop after it fires, while a repeating observer remains attached. You specify whether an observer runs once or repeatedly when you create it.

For an example of how to create a run-loop observer, see Configuring the Run Loop. For reference information, see CFRunLoopObserver Reference.

与在适当的异步或同步事件发生时触发的源相反，运行循环观察者在运行循环本身执行期间的特定位置触发。您可以使用运行循环观察器来准备线程以处理给定事件，或者在线程进入睡眠之前准备线程。您可以将运行循环观察者与运行循环中的以下事件相关联：

- 运行循环的入口。
- 当运行循环将要处理计时器时。
- 当运行循环将要处理输入源时。
- 当运行循环即将进入睡眠状态时。
- 当运行循环醒来但在处理事件之前将其唤醒。
- 运行循环的退出。

您可以使用Core Foundation将运行循环观察器添加到应用程序。要创建运行循环观察器，请创建CFRunLoopObserverRef不透明类型的新实例。此类型跟踪您的自定义回调函数及其感兴趣的活动。

与计时器类似，运行循环观察器可以使用一次或重复使用。一次触发的观察者在触发后将自己从运行循环中删除，而重复的观察者仍然处于连接状态。您可以指定创建观察者时是运行一次还是重复运行。

有关如何创建运行循环观察器的示例，请参见“ 配置运行循环”。有关参考信息，请参见CFRunLoopObserver参考。


### The Run Loop Sequence of Events
Each time you run it, your thread’s run loop processes pending events and generates notifications for any attached observers. The order in which it does this is very specific and is as follows:

1. Notify observers that the run loop has been entered.
2. Notify observers that any ready timers are about to fire.
3. Notify observers that any input sources that are not port based are about to fire.
4. Fire any non-port-based input sources that are ready to fire.
5. If a port-based input source is ready and waiting to fire, process the event immediately. Go to step 9.
6. Notify observers that the thread is about to sleep.
7. Put the thread to sleep until one of the following events occurs:
	- An event arrives for a port-based input source.
	- A timer fires.
	- The timeout value set for the run loop expires.
	- The run loop is explicitly woken up.
8. Notify observers that the thread just woke up.
9. Process the pending event.
	- If a user-defined timer fired, process the timer event and restart the loop. Go to step 2.
	- If an input source fired, deliver the event.
	- If the run loop was explicitly woken up but has not yet timed out, restart the loop. Go to step 2.
10. Notify observers that the run loop has exited.

Because observer notifications for timer and input sources are delivered before those events actually occur, there may be a gap between the time of the notifications and the time of the actual events. If the timing between these events is critical, you can use the sleep and awake-from-sleep notifications to help you correlate the timing between the actual events.

Because timers and other periodic events are delivered when you run the run loop, circumventing that loop disrupts the delivery of those events. The typical example of this behavior occurs whenever you implement a mouse-tracking routine by entering a loop and repeatedly requesting events from the application. Because your code is grabbing events directly, rather than letting the application dispatch those events normally, active timers would be unable to fire until after your mouse-tracking routine exited and returned control to the application.

A run loop can be explicitly woken up using the run loop object. Other events may also cause the run loop to be woken up. For example, adding another non-port-based input source wakes up the run loop so that the input source can be processed immediately, rather than waiting until some other event occurs.


每次运行它时，线程的运行循环都会处理未决事件并为任何附加的观察者生成通知。它执行此操作的顺序非常具体，如下所示：

1. 通知观察者已进入运行循环。
2. 通知观察者任何准备就绪的计时器即将触发。
3. 通知观察者任何不基于端口的输入源都将被触发。
4. 触发所有准备触发的非基于端口的输入源。
5. 如果基于端口的输入源已准备好并等待启动，请立即处理事件。转到步骤9。
6. 通知观察者线程即将进入睡眠状态。
7. 使线程进入睡眠状态，直到发生以下事件之一：
	- 事件到达基于端口的输入源。
	- 计时器触发。
	- 为运行循环设置的超时值到期。
	- 运行循环被明确唤醒。
8. 通知观察者线程刚刚醒来。
9. 处理未决事件。
	- 如果触发了用户定义的计时器，请处理计时器事件并重新启动循环。转到步骤2。
	- 如果触发了输入源，则传递事件。
	- 如果运行循环已显式唤醒，但尚未超时，请重新启动循环。转到步骤2。
10. 通知观察者运行循环已退出。

由于计时器和输入源的观察者通知是在这些事件实际发生之前传递的，因此通知时间和实际事件时间之间可能会有差距。如果这些事件之间的时间很关键，则可以使用睡眠和从睡眠中唤醒通知来帮助您关联实际事件之间的时间。

由于在运行运行循环时会传递计时器和其他定期事件，因此规避该循环会破坏这些事件的传递。每当您通过进入循环并重复从应用程序请求事件来实现鼠标跟踪例程时，就会出现此行为的典型示例。因为您的代码直接捕获事件，而不是让应用程序正常分配事件，所以活动的计时器将无法触发，直到您的鼠标跟踪例程退出并将控制权返回给应用程序之后。

可以使用运行循环对象显式唤醒运行循环。其他事件也可能导致运行循环被唤醒。例如，添加另一个非基于端口的输入源将唤醒运行循环，以便可以立即处理输入源，而不是等到发生其他事件为止。

## When Would You Use a Run Loop?
The only time you need to run a run loop explicitly is when you create secondary threads for your application. The run loop for your application’s main thread is a crucial piece of infrastructure. As a result, the app frameworks provide the code for running the main application loop and start that loop automatically. The run method of UIApplication in iOS (or NSApplication in OS X) starts an application’s main loop as part of the normal startup sequence. If you use the Xcode template projects to create your application, you should never have to call these routines explicitly.

For secondary threads, you need to decide whether a run loop is necessary, and if it is, configure and start it yourself. You do not need to start a thread’s run loop in all cases. For example, if you use a thread to perform some long-running and predetermined task, you can probably avoid starting the run loop. Run loops are intended for situations where you want more interactivity with the thread. For example, you need to start a run loop if you plan to do any of the following:

- Use ports or custom input sources to communicate with other threads.
- Use timers on the thread.
- Use any of the performSelector… methods in a Cocoa application.
- Keep the thread around to perform periodic tasks.

If you do choose to use a run loop, the configuration and setup is straightforward. As with all threaded programming though, you should have a plan for exiting your secondary threads in appropriate situations. It is always better to end a thread cleanly by letting it exit than to force it to terminate. Information on how to configure and exit a run loop is described in Using Run Loop Objects.

唯一需要明确运行运行循环的时间是在为应用程序创建辅助线程时。应用程序主线程的运行循环是基础架构的关键部分。结果，应用程序框架提供了用于运行主应用程序循环并自动启动该循环的代码。在iOS（或OS X）run中UIApplication，的方法NSApplication作为正常启动顺序的一部分启动应用程序的主循环。如果使用Xcode模板项目创建应用程序，则永远不必显式调用这些例程。

对于辅助线程，您需要确定是否需要运行循环，如果需要，请自行配置并启动它。您无需在所有情况下都启动线程的运行循环。例如，如果使用线程执行一些长时间运行的预定任务，则可以避免启动运行循环。运行循环用于需要与线程更多交互的情况。例如，如果您打算执行以下任一操作，则需要启动运行循环：

- 使用端口或自定义输入源与其他线程进行通信。
- 在线程上使用计时器。
- performSelector在Cocoa应用程序中使用任何...方法。
- 保持线程执行定期任务。

如果确实选择使用运行循环，则配置和设置非常简单。与所有线程编程一样，您应该有一个计划，在适当的情况下退出辅助线程。最好通过让线程退出干净地结束线程，而不是强制终止线程。使用运行循环对象中介绍了有关如何配置和退出运行循环的信息。

## Using Run Loop Objects
A run loop object provides the main interface for adding input sources, timers, and run-loop observers to your run loop and then running it. Every thread has a single run loop object associated with it. In Cocoa, this object is an instance of the NSRunLoop class. In a low-level application, it is a pointer to a CFRunLoopRef opaque type.

运行循环对象提供了用于将输入源，计时器和运行循环观察器添加到您的运行循环然后运行它的主界面。每个线程都有一个与之关联的运行循环对象。在可可中，此对象是NSRunLoop类的实例。在低级应用程序中，它是指向CFRunLoopRef不透明类型的指针。

### Getting a Run Loop Object
To get the run loop for the current thread, you use one of the following:

- In a Cocoa application, use the currentRunLoop class method of NSRunLoop to retrieve an NSRunLoop object.
- Use the CFRunLoopGetCurrent function.

Although they are not toll-free bridged types, you can get a CFRunLoopRef opaque type from an NSRunLoop object when needed. The NSRunLoop class defines a getCFRunLoop method that returns a CFRunLoopRef type that you can pass to Core Foundation routines. Because both objects refer to the same run loop, you can intermix calls to the NSRunLoop object and CFRunLoopRef opaque type as needed.

要获取当前线程的运行循环，请使用以下方法之一：

- 在Cocoa应用程序中，使用的currentRunLoop类方法NSRunLoop检索NSRunLoop对象。
- 使用CFRunLoopGetCurrent功能。

尽管它们不是免费的桥接类型，但是您可以在需要时CFRunLoopRef从NSRunLoop对象获取不透明类型。本NSRunLoop类定义了一个getCFRunLoop返回的方法CFRunLoopRef类型，你可以传递给Core Foundation的例程。由于两个对象都引用相同的运行循环，因此您可以根据需要混合对NSRunLoop对象和CFRunLoopRef不透明类型的调用。

### Configuring the Run Loop
Before you run a run loop on a secondary thread, you must add at least one input source or timer to it. If a run loop does not have any sources to monitor, it exits immediately when you try to run it. For examples of how to add sources to a run loop, see Configuring Run Loop Sources.

In addition to installing sources, you can also install run loop observers and use them to detect different execution stages of the run loop. To install a run loop observer, you create a CFRunLoopObserverRef opaque type and use the CFRunLoopAddObserver function to add it to your run loop. Run loop observers must be created using Core Foundation, even for Cocoa applications.

Listing 3-1 shows the main routine for a thread that attaches a run loop observer to its run loop. The purpose of the example is to show you how to create a run loop observer, so the code simply sets up a run loop observer to monitor all run loop activities. The basic handler routine (not shown) simply logs the run loop activity as it processes the timer requests.

在辅助线程上运行运行循环之前，必须向其添加至少一个输入源或计时器。如果运行循环没有任何要监视的源，则当您尝试运行它时，它将立即退出。有关如何将源添加到运行循环的示例，请参见《配置运行循环源》。

除了安装源代码，您还可以安装运行循环观察器，并使用它们来检测运行循环的不同执行阶段。要安装运行循环观察器，请创建一个CFRunLoopObserverRef不透明类型，然后使用该CFRunLoopAddObserver函数将其添加到您的运行循环中。即使使用Cocoa应用程序，也必须使用Core Foundation创建运行循环观察器。

清单3-1显示了将运行循环观察器附加到其运行循环的线程的主例程。该示例的目的是向您展示如何创建运行循环观察器，因此代码仅设置了一个运行循环观察器以监视所有运行循环活动。基本处理程序例程（未显示）在处理计时器请求时仅记录运行循环活动。

**Listing 3-1**  Creating a run loop observer

```objc
- (void)threadMain
{
    // The application uses garbage collection, so no autorelease pool is needed.
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
 
    // Create a run loop observer and attach it to the run loop.
    CFRunLoopObserverContext  context = {0, self, NULL, NULL, NULL};
    CFRunLoopObserverRef    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
            kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
 
    if (observer)
    {
        CFRunLoopRef    cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
 
    // Create and schedule the timer.
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
 
    NSInteger    loopCount = 10;
    do
    {
        // Run the run loop 10 times to let the timer fire.
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
    }
    while (loopCount);
}
```

When configuring the run loop for a long-lived thread, it is better to add at least one input source to receive messages. Although you can enter the run loop with only a timer attached, once the timer fires, it is typically invalidated, which would then cause the run loop to exit. Attaching a repeating timer could keep the run loop running over a longer period of time, but would involve firing the timer periodically to wake your thread, which is effectively another form of polling. By contrast, an input source waits for an event to happen, keeping your thread asleep until it does.

为长寿命线程配置运行循环时，最好添加至少一个输入源以接收消息。尽管您可以仅连接一个计时器即可进入运行循环，但是一旦计时器触发，它通常就会失效，这将导致运行循环退出。附加重复的计时器可以使运行循环保持较长时间运行，但是会涉及定期触发计时器以唤醒线程，这实际上是轮询的另一种形式。相比之下，输入源会等待事件发生，使线程保持睡眠状态直到事件发生。

### Starting the Run Loop
Starting the run loop is necessary only for the secondary threads in your application. A run loop must have at least one input source or timer to monitor. If one is not attached, the run loop exits immediately.

There are several ways to start the run loop, including the following:

- Unconditionally
- With a set time limit
- In a particular mode

Entering your run loop unconditionally is the simplest option, but it is also the least desirable. Running your run loop unconditionally puts the thread into a permanent loop, which gives you very little control over the run loop itself. You can add and remove input sources and timers, but the only way to stop the run loop is to kill it. There is also no way to run the run loop in a custom mode.

Instead of running a run loop unconditionally, it is better to run the run loop with a timeout value. When you use a timeout value, the run loop runs until an event arrives or the allotted time expires. If an event arrives, that event is dispatched to a handler for processing and then the run loop exits. Your code can then restart the run loop to handle the next event. If the allotted time expires instead, you can simply restart the run loop or use the time to do any needed housekeeping.

In addition to a timeout value, you can also run your run loop using a specific mode. Modes and timeout values are not mutually exclusive and can both be used when starting a run loop. Modes limit the types of sources that deliver events to the run loop and are described in more detail in Run Loop Modes.

Listing 3-2 shows a skeleton version of a thread’s main entry routine. The key portion of this example shows the basic structure of a run loop. In essence, you add your input sources and timers to the run loop and then repeatedly call one of the routines to start the run loop. Each time the run loop routine returns, you check to see if any conditions have arisen that might warrant exiting the thread. The example uses the Core Foundation run loop routines so that it can check the return result and determine why the run loop exited. You could also use the methods of the NSRunLoop class to run the run loop in a similar manner if you are using Cocoa and do not need to check the return value. (For an example of a run loop that calls methods of the NSRunLoop class, see Listing 3-14.)

仅对于应用程序中的辅助线程，才需要启动运行循环。一个运行循环必须至少有一个输入源或计时器要监视。如果未连接，运行循环将立即退出。

有几种启动运行循环的方法，包括以下几种：

- 无条件
- 设定时间限制
- 在特定模式下

无条件进入运行循环是最简单的选择，但也是最不希望的。无条件运行运行循环会将线程置于永久循环，这使您几乎无法控制运行循环本身。您可以添加和删除输入源和计时器，但是停止运行循环的唯一方法是终止运行循环。也没有办法在自定义模式下运行运行循环。

与其无条件地运行运行循环，不如使用超时值运行运行循环。当您使用超时值时，运行循环将运行直到事件到达或指定的时间到期为止。如果事件到达，则将该事件调度到处理程序进行处理，然后退出运行循环。然后，您的代码可以重新启动运行循环以处理下一个事件。如果分配的时间到期了，您可以简单地重新启动运行循环或使用该时间进行任何必要的内务处理。

除了超时值之外，您还可以使用特定模式运行运行循环。模式和超时值不是互斥的，并且在启动运行循环时都可以使用。模式限制了将事件传递到运行循环的源的类型，运行循环模式中对此进行了详细描述。

清单3-2显示了线程的主进入例程的框架版本。此示例的关键部分显示了运行循环的基本结构。本质上，您将输入源和计时器添加到运行循环中，然后重复调用例程之一以启动运行循环。每次运行循环例程返回时，您都要检查是否出现了可能保证退出线程的条件。该示例使用Core Foundation运行循环例程，以便它可以检查返回结果并确定为什么退出运行循环。NSRunLoop如果您使用的是Cocoa，并且不需要检查返回值，则也可以使用类的方法以类似的方式运行运行循环。（有关调用NSRunLoop类的方法的运行循环的示例，请参见清单3-14。）

**Listing 3-2**  Running a run loop

```objc
- (void)skeletonThreadMain
{
    // Set up an autorelease pool here if not using garbage collection.
    BOOL done = NO;
 
    // Add your sources or timers to the run loop and do any other setup.
 
    do
    {
        // Start the run loop but return after each source is handled.
        SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
 
        // If a source explicitly stopped the run loop, or if there are no
        // sources or timers, go ahead and exit.
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
            done = YES;
 
        // Check for any other exit conditions here and set the
        // done variable as needed.
    }
    while (!done);
 
    // Clean up code here. Be sure to release any allocated autorelease pools.
}
```

It is possible to run a run loop recursively. In other words, you can call CFRunLoopRun, CFRunLoopRunInMode, or any of the NSRunLoop methods for starting the run loop from within the handler routine of an input source or timer. When doing so, you can use any mode you want to run the nested run loop, including the mode in use by the outer run loop.

可以递归运行运行循环。换句话说，您可以在输入源或计时器的处理程序例程中调用CFRunLoopRun，CFRunLoopRunInMode或任何NSRunLoop用于启动运行循环的方法。这样做时，可以使用任何要运行嵌套运行循环的模式，包括外部运行循环使用的模式。

### Exiting the Run Loop
There are two ways to make a run loop exit before it has processed an event:

- Configure the run loop to run with a timeout value.
- Tell the run loop to stop.

Using a timeout value is certainly preferred, if you can manage it. Specifying a timeout value lets the run loop finish all of its normal processing, including delivering notifications to run loop observers, before exiting.

Stopping the run loop explicitly with the CFRunLoopStop function produces a result similar to a timeout. The run loop sends out any remaining run-loop notifications and then exits. The difference is that you can use this technique on run loops you started unconditionally.

Although removing a run loop’s input sources and timers may also cause the run loop to exit, this is not a reliable way to stop a run loop. Some system routines add input sources to a run loop to handle needed events. Because your code might not be aware of these input sources, it would be unable to remove them, which would prevent the run loop from exiting.

在处理事件之前，有两种方法可以使运行循环退出：

- 配置运行循环以使用超时值运行。
- 告诉运行循环停止。

如果可以管理，使用超时值无疑是首选。指定超时值可使运行循环在退出之前完成其所有正常处理，包括将通知传递给运行循环观察器。

使用该CFRunLoopStop函数显式停止运行循环会产生类似于超时的结果。运行循环将发出所有剩余的运行循环通知，然后退出。区别在于您可以在无条件启动的运行循环中使用此技术。

尽管删除运行循环的输入源和计时器也可能导致运行循环退出，但这不是停止运行循环的可靠方法。一些系统例程将输入源添加到运行循环中以处理所需的事件。因为您的代码可能不知道这些输入源，所以它将无法删除它们，这将阻止运行循环退出。

### Thread Safety and Run Loop Objects
Thread safety varies depending on which API you are using to manipulate your run loop. The functions in Core Foundation are generally thread-safe and can be called from any thread. If you are performing operations that alter the configuration of the run loop, however, it is still good practice to do so from the thread that owns the run loop whenever possible.

The Cocoa NSRunLoop class is not as inherently thread safe as its Core Foundation counterpart. If you are using the NSRunLoop class to modify your run loop, you should do so only from the same thread that owns that run loop. Adding an input source or timer to a run loop belonging to a different thread could cause your code to crash or behave in an unexpected way.

线程安全性取决于您用来操纵运行循环的API。Core Foundation中的函数通常是线程安全的，可以从任何线程中调用。但是，如果您执行的操作会更改运行循环的配置，则最好还是从拥有运行循环的线程中进行更改。

可可NSRunLoop类在本质上不如其Core Foundation同类线程安全。如果要使用NSRunLoop该类来修改运行循环，则只能从拥有该运行循环的同一线程进行。将输入源或计时器添加到属于不同线程的运行循环中可能会导致代码崩溃或行为异常。

## Configuring Run Loop Sources
The following sections show examples of how to set up different types of input sources in both Cocoa and Core Foundation.

以下各节显示了如何在Cocoa和Core Foundation中设置不同类型的输入源的示例。

### Defining a Custom Input Source
Creating a custom input source involves defining the following:

- The information you want your input source to process.
- A scheduler routine to let interested clients know how to contact your input source.
- A handler routine to perform requests sent by any clients.
- A cancellation routine to invalidate your input source.

Because you create a custom input source to process custom information, the actual configuration is designed to be flexible. The scheduler, handler, and cancellation routines are the key routines you almost always need for your custom input source. Most of the rest of the input source behavior, however, happens outside of those handler routines. For example, it is up to you to define the mechanism for passing data to your input source and for communicating the presence of your input source to other threads.

Figure 3-2 shows a sample configuration of a custom input source. In this example, the application’s main thread maintains references to the input source, the custom command buffer for that input source, and the run loop on which the input source is installed. When the main thread has a task it wants to hand off to the worker thread, it posts a command to the command buffer along with any information needed by the worker thread to start the task. (Because both the main thread and the input source of the worker thread have access to the command buffer, that access must be synchronized.) Once the command is posted, the main thread signals the input source and wakes up the worker thread’s run loop. Upon receiving the wake up command, the run loop calls the handler for the input source, which processes the commands found in the command buffer.

创建自定义输入源涉及定义以下内容：

- 您希望输入源处理的信息。
- 调度程序，让感兴趣的客户知道如何联系您的输入源。
- 处理程序例程，用于执行任何客户端发送的请求。
- 取消例程使您的输入源无效。

因为您创建了一个定制输入源来处理定制信息，所以实际配置被设计为灵活的。调度程序，处理程序和取消例程是自定义输入源几乎始终需要的关键例程。但是，其余大多数输入源行为都发生在那些处理程序例程之外。例如，您可以定义一种机制，用于将数据传递到输入源以及将输入源的存在传达给其他线程。

图3-2显示了定制输入源的样本配置。在此示例中，应用程序的主线程维护对输入源，该输入源的定制命令缓冲区以及安装该输入源的运行循环的引用。当主线程有一个要移交给工作线程的任务时，它将一个命令以及工作线程启动该任务所需的所有信息发布到命令缓冲区。（因为主线程和工作线程的输入源都可以访问命令缓冲区，所以访问必须同步。）一旦发布命令，主线程将向输入源发出信号并唤醒工作线程的运行循环。收到唤醒命令后，运行循环将调用输入源的处理程序，该处理程序将处理在命令缓冲区中找到的命令。

**Figure 3-2**  Operating a custom input source

![](/imgs/custominputsource.jpg)

The following sections explain the implementation of the custom input source from the preceding figure and show the key code you would need to implement.

以下各节说明了上图中自定义输入源的实现，并显示了您需要实现的关键代码。

### Defining the Input Source
Defining a custom input source requires the use of Core Foundation routines to configure your run loop source and attach it to a run loop. Although the basic handlers are C-based functions, that does not preclude you from writing wrappers for those functions and using Objective-C or C++ to implement the body of your code.

The input source introduced in Figure 3-2 uses an Objective-C object to manage a command buffer and coordinate with the run loop. Listing 3-3 shows the definition of this object. The RunLoopSource object manages a command buffer and uses that buffer to receive messages from other threads. This listing also shows the definition of the RunLoopContext object, which is really just a container object used to pass a RunLoopSource object and a run loop reference to the application’s main thread.

定义自定义输入源需要使用Core Foundation例程来配置运行循环源并将其附加到运行循环。尽管基本处理程序是基于C的函数，但这并不妨碍您编写这些函数的包装程序并使用Objective-C或C ++实现代码主体。

图3-2中引入的输入源使用一个Objective-C对象来管理命令缓冲区并与运行循环协调。清单3-3显示了此对象的定义。该RunLoopSource对象管理命令缓冲区，并使用该缓冲区从其他线程接收消息。此清单还显示了RunLoopContext对象的定义，它实际上只是一个容器对象，用于传递RunLoopSource对象和对应用程序主线程的运行循环引用。

**Listing 3-3**  The custom input source object definition

```objc
@interface RunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray* commands;
}
 
- (id)init;
- (void)addToCurrentRunLoop;
- (void)invalidate;
 
// Handler method
- (void)sourceFired;
 
// Client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
 
@end
 
// These are the CFRunLoopSourceRef callback functions.
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
 
// RunLoopContext is a container object used during registration of the input source.
@interface RunLoopContext : NSObject
{
    CFRunLoopRef        runLoop;
    RunLoopSource*        source;
}
@property (readonly) CFRunLoopRef runLoop;
@property (readonly) RunLoopSource* source;
 
- (id)initWithSource:(RunLoopSource*)src andLoop:(CFRunLoopRef)loop;
@end
```

Although the Objective-C code manages the custom data of the input source, attaching the input source to a run loop requires C-based callback functions. The first of these functions is called when you actually attach the run loop source to your run loop, and is shown in Listing 3-4. Because this input source has only one client (the main thread), it uses the scheduler function to send a message to register itself with the application delegate on that thread. When the delegate wants to communicate with the input source, it uses the information in RunLoopContext object to do so.

尽管Objective-C代码管理输入源的自定义数据，但是将输入源附加到运行循环需要基于C的回调函数。当您将运行循环源实际附加到运行循环时，将调用其中的第一个函数，如清单3-4所示。因为此输入源只有一个客户端（主线程），所以它使用调度程序功能发送消息以在该线程上的应用程序委托中注册自己。当委托人想要与输入源进行通信时，它将使用RunLoopContextobject中的信息进行通信。

**Listing 3-4**  Scheduling a run loop source

```objc
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RunLoopSource* obj = (RunLoopSource*)info;
    AppDelegate*   del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
 
    [del performSelectorOnMainThread:@selector(registerSource:)
                                withObject:theContext waitUntilDone:NO];
}
```

One of the most important callback routines is the one used to process custom data when your input source is signaled. Listing 3-5 shows the perform callback routine associated with the RunLoopSource object. This function simply forwards the request to do the work to the sourceFired method, which then processes any commands present in the command buffer.

最重要的回调例程之一是当输入源被信号通知时用于处理自定义数据的例程。清单3-5显示了与RunLoopSource对象关联的perform回调例程。该函数只是将完成工作的请求转发给sourceFired方法，该方法然后处理命令缓冲区中存在的所有命令

**Listing 3-5**  Performing work in the input source

```objc
void RunLoopSourcePerformRoutine (void *info)
{
    RunLoopSource*  obj = (RunLoopSource*)info;
    [obj sourceFired];
}
```

If you ever remove your input source from its run loop using the CFRunLoopSourceInvalidate function, the system calls your input source’s cancellation routine. You can use this routine to notify clients that your input source is no longer valid and that they should remove any references to it. Listing 3-6 shows the cancellation callback routine registered with the RunLoopSource object. This function sends another RunLoopContext object to the application delegate, but this time asks the delegate to remove references to the run loop source.

如果使用该CFRunLoopSourceInvalidate功能从运行循环中删除输入源，系统将调用输入源的取消例程。您可以使用此例程来通知客户端您的输入源不再有效，并且他们应删除对其的任何引用。 清单3-6显示了向该RunLoopSource对象注册的取消回调例程。此函数将另一个RunLoopContext对象发送给应用程序委托，但这一次要求委托删除对运行循环源的引用。

**Listing 3-6**  Invalidating an input source

```objc
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RunLoopSource* obj = (RunLoopSource*)info;
    AppDelegate* del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
 
    [del performSelectorOnMainThread:@selector(removeSource:)
                                withObject:theContext waitUntilDone:YES];
}
```

> Note: The code for the application delegate’s registerSource: and removeSource: methods is shown in Coordinating with Clients of the Input Source.
> 
> 注意：与输入源的客户端协调中显示 了应用程序委托registerSource:和removeSource:方法的代码。


### Installing the Input Source on the Run Loop
Listing 3-7 shows the init and addToCurrentRunLoop methods of the RunLoopSource class. The init method creates the CFRunLoopSourceRef opaque type that must actually be attached to the run loop. It passes the RunLoopSource object itself as the contextual information so that the callback routines have a pointer to the object. Installation of the input source does not occur until the worker thread invokes the addToCurrentRunLoop method, at which point the RunLoopSourceScheduleRoutine callback function is called. Once the input source is added to the run loop, the thread can run its run loop to wait on it.

清单3-7显示了该类的init和addToCurrentRunLoop方法RunLoopSource。该init方法创建CFRunLoopSourceRef实际上必须附加到运行循环的不透明类型。它将RunLoopSource对象本身作为上下文信息传递，以便回调例程具有指向该对象的指针。在工作线程调用该addToCurrentRunLoop方法之前，不会安装输入源，此时将RunLoopSourceScheduleRoutine调用回调函数。将输入源添加到运行循环后，线程可以运行其运行循环以等待它。


**Listing 3-7**  Installing the run loop source

```objc
- (id)init
{
    CFRunLoopSourceContext    context = {0, self, NULL, NULL, NULL, NULL, NULL,
                                        &RunLoopSourceScheduleRoutine,
                                        RunLoopSourceCancelRoutine,
                                        RunLoopSourcePerformRoutine};
 
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init];
 
    return self;
}
 
- (void)addToCurrentRunLoop
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

```


### Coordinating with Clients of the Input Source
For your input source to be useful, you need to manipulate it and signal it from another thread. The whole point of an input source is to put its associated thread to sleep until there is something to do. That fact necessitates having other threads in your application know about the input source and have a way to communicate with it.

One way to notify clients about your input source is to send out registration requests when your input source is first installed on its run loop. You can register your input source with as many clients as you want, or you can simply register it with some central agency that then vends your input source to interested clients. Listing 3-8 shows the registration method defined by the application delegate and invoked when the RunLoopSource object’s scheduler function is called. This method receives the RunLoopContext object provided by the RunLoopSource object and adds it to its list of sources. This listing also shows the routine used to unregister the input source when it is removed from its run loop.

为了使您的输入源有用，您需要对其进行操作并从另一个线程发出信号。输入源的全部目的是使其关联线程处于休眠状态，直到有事要做。这个事实使得您的应用程序中的其他线程必须了解输入源并有一种与之通信的方法。

通知客户端有关您的输入源的一种方法是在您的输入源首次安装在其运行循环中时发出注册请求。您可以根据需要在任意数量的客户中注册输入源，也可以直接在某个中央机构中注册，然后将您的输入源出售给感兴趣的客户。清单3-8显示了由应用程序委托定义的注册方法，该方法在调用RunLoopSource对象的调度程序函数时调用。此方法接收该RunLoopContext对象提供的RunLoopSource对象，并将其添加到其源列表中。此清单还显示了从运行循环中删除输入源时用来注销输入源的例程。



**Listing 3-8**  Registering and removing an input source with the application delegate

```objc
- (void)registerSource:(RunLoopContext*)sourceInfo;
{
    [sourcesToPing addObject:sourceInfo];
}
 
- (void)removeSource:(RunLoopContext*)sourceInfo
{
    id    objToRemove = nil;
 
    for (RunLoopContext* context in sourcesToPing)
    {
        if ([context isEqual:sourceInfo])
        {
            objToRemove = context;
            break;
        }
    }
 
    if (objToRemove)
        [sourcesToPing removeObject:objToRemove];
}
```

> Note: The callback functions that call the methods in the preceding listing are shown in Listing 3-4 and Listing 3-6.
> 
> 注意：清单3-4和清单3-6  中显示了调用前面清单中的方法的回调函数。

### Signaling the Input Source
After it hands off its data to the input source, a client must signal the source and wake up its run loop. Signaling the source lets the run loop know that the source is ready to be processed. And because the thread might be asleep when the signal occurs, you should always wake up the run loop explicitly. Failing to do so might result in a delay in processing the input source.

Listing 3-9 shows the fireCommandsOnRunLoop method of the RunLoopSource object. Clients invoke this method when they are ready for the source to process the commands they added to the buffer.

客户端将其数据交给输入源后，客户端必须向该源发出信号并唤醒其运行循环。向源发出信号使运行循环知道源已准备好进行处理。并且因为当信号出现时线程可能处于睡眠状态，所以您应该始终明确地唤醒运行循环。否则，可能会导致输入源处理延迟。

清单3-9显示了fireCommandsOnRunLoop该RunLoopSource对象的方法。客户端准备好让源处理它们添加到缓冲区的命令时，客户端将调用此方法。



**Listing 3-9**  Waking up the run loop

```objc
- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}
```

> Note: You should never try to handle a SIGHUP or other type of process-level signal by messaging a custom input source. The Core Foundation functions for waking up the run loop are not signal safe and should not be used inside your application’s signal handler routines. For more information about signal handler routines, see the sigaction man page.
> 
> 注意：  切勿尝试SIGHUP通过传递自定义输入源来处理一个或其他类型的过程级信号。唤醒运行循环的Core Foundation函数不是信号安全的，不应在应用程序的信号处理程序例程中使用。有关信号处理程序例程的更多信息，请参见sigaction手册页


## Configuring Timer Sources
To create a timer source, all you have to do is create a timer object and schedule it on your run loop. In Cocoa, you use the NSTimer class to create new timer objects, and in Core Foundation you use the CFRunLoopTimerRef opaque type. Internally, the NSTimer class is simply an extension of Core Foundation that provides some convenience features, like the ability to create and schedule a timer using the same method.

In Cocoa, you can create and schedule a timer all at once using either of these class methods:

- scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:
- scheduledTimerWithTimeInterval:invocation:repeats:

These methods create the timer and add it to the current thread’s run loop in the default mode (NSDefaultRunLoopMode). You can also schedule a timer manually if you want by creating your NSTimer object and then adding it to the run loop using the addTimer:forMode: method of NSRunLoop. Both techniques do basically the same thing but give you different levels of control over the timer’s configuration. For example, if you create the timer and add it to the run loop manually, you can do so using a mode other than the default mode. Listing 3-10 shows how to create timers using both techniques. The first timer has an initial delay of 1 second but then fires regularly every 0.1 seconds after that. The second timer begins firing after an initial 0.2 second delay and then fires every 0.2 seconds after that.

要创建计时器源，您要做的就是创建一个计时器对象并将其安排在运行循环中。在Cocoa中，您可以使用NSTimer该类来创建新的计时器对象，而在Core Foundation中，您可以使用CFRunLoopTimerRef不透明类型。在内部，NSTimer该类只是Core Foundation的扩展，提供了一些便利功能，例如使用相同方法创建和安排计时器的功能。

在Cocoa中，您可以使用以下两种方法之一同时创建和安排计时器：

- scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:
- scheduledTimerWithTimeInterval:invocation:repeats:

这些方法创建计时器并将其以默认模式（NSDefaultRunLoopMode）添加到当前线程的运行循环中。如果需要，还可以通过创建NSTimer对象然后使用的addTimer:forMode:方法将其添加到运行循环中来手动安排计时器NSRunLoop。两种技术基本上都做同样的事情，但是给您对计时器配置的不同级别的控制。例如，如果您创建计时器并将其手动添加到运行循环中，则可以使用默认模式以外的其他模式来执行此操作。清单3-10显示了如何使用这两种技术创建计时器。第一个计时器的初始延迟为1秒，但此后每隔0.1秒定期触发一次。第二个计时器在最初的0.2秒延迟后开始触发，然后在此之后每0.2秒触发一次。


**Listing 3-10**  Creating and scheduling timers using NSTimer

```objc
NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
 
// Create and schedule the first timer.
NSDate* futureDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
NSTimer* myTimer = [[NSTimer alloc] initWithFireDate:futureDate
                        interval:0.1
                        target:self
                        selector:@selector(myDoFireTimer1:)
                        userInfo:nil
                        repeats:YES];
[myRunLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
 
// Create and schedule the second timer.
[NSTimer scheduledTimerWithTimeInterval:0.2
                        target:self
                        selector:@selector(myDoFireTimer2:)
                        userInfo:nil
                        repeats:YES];
```

Listing 3-11 shows the code needed to configure a timer using Core Foundation functions. Although this example does not pass any user-defined information in the context structure, you could use this structure to pass around any custom data you needed for your timer. For more information about the contents of this structure, see its description in CFRunLoopTimer Reference.

清单3-11显示了使用Core Foundation函数配置计时器所需的代码。尽管此示例未在上下文结构中传递任何用户定义的信息，但是您可以使用此结构传递计时器所需的任何自定义数据。有关此结构的内容的更多信息，请参见CFRunLoopTimer参考中的描述。

**Listing 3-11**  Creating and scheduling a timer using Core Foundation

```objc
CFRunLoopRef runLoop = CFRunLoopGetCurrent();
CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0,
                                        &myCFTimerCallback, &context);
 
CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);

```

## Configuring a Port-Based Input Source
Both Cocoa and Core Foundation provide port-based objects for communicating between threads or between processes. The following sections show you how to set up port communication using several different types of ports.

Cocoa和Core Foundation都提供了基于端口的对象，用于在线程之间或进程之间进行通信。以下各节说明如何使用几种不同类型的端口来设置端口通信。


### Configuring an NSMachPort Object
To establish a local connection with an NSMachPort object, you create the port object and add it to your primary thread's run loop. When launching your secondary thread, you pass the same object to your thread's entry-point function. The secondary thread can use the same object to send messages back to your primary thread.

要与NSMachPort对象建立本地连接，请创建端口对象并将其添加到主线程的运行循环中。启动辅助线程时，将同一对象传递给线程的入口点函数。辅助线程可以使用同一对象将消息发送回您的主线程。



### Implementing the Main Thread Code
Listing 3-12 shows the primary thread code for launching a secondary worker thread. Because the Cocoa framework performs many of the intervening steps for configuring the port and run loop, the launchThread method is noticeably shorter than its Core Foundation equivalent (Listing 3-17); however, the behavior of the two is nearly identical. One difference is that instead of sending the name of the local port to the worker thread, this method sends the NSPort object directly.

清单3-12显示了用于启动辅助工作线程的主要线程代码。因为Cocoa框架执行了许多配置端口和运行循环的干预步骤，所以该launchThread方法明显短于其Core Foundation等效方法（清单3-17）。但是，两者的行为几乎相同。一个区别是，此方法不是将本地端口的名称发送到工作线程，而是NSPort直接发送对象。



**Listing 3-12**  Main thread launch method

```objc
- (void)launchThread
{
    NSPort* myPort = [NSMachPort port];
    if (myPort)
    {
        // This class handles incoming port messages.
        [myPort setDelegate:self];
 
        // Install the port as an input source on the current run loop.
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
 
        // Detach the thread. Let the worker release the port.
        [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:)
               toTarget:[MyWorkerClass class] withObject:myPort];
    }
}
```

In order to set up a two-way communications channel between your threads, you might want to have the worker thread send its own local port to your main thread in a check-in message. Receiving the check-in message lets your main thread know that all went well in launching the second thread and also gives you a way to send further messages to that thread.

Listing 3-13 shows the handlePortMessage: method for the primary thread. This method is called when data arrives on the thread's own local port. When a check-in message arrives, the method retrieves the port for the secondary thread directly from the port message and saves it for later use.

为了在线程之间建立双向通信通道，您可能希望工作线程在签入消息中将其自己的本地端口发送到主线程。接收到签入消息可以使您的主线程知道在启动第二个线程时一切进展顺利，还为您提供了一种向该线程发送更多消息的方法。

清单3-13显示handlePortMessage:了主线程的方法。当数据到达线程自己的本地端口时，将调用此方法。当签入消息到达时，该方法直接从端口消息中检索辅助线程的端口，并将其保存以供以后使用。



**Listing 3-13**  Handling Mach port messages

```objc
#define kCheckinMessage 100
 
// Handle responses from the worker thread.
- (void)handlePortMessage:(NSPortMessage *)portMessage
{
    unsigned int message = [portMessage msgid];
    NSPort* distantPort = nil;
 
    if (message == kCheckinMessage)
    {
        // Get the worker thread’s communications port.
        distantPort = [portMessage sendPort];
 
        // Retain and save the worker port for later use.
        [self storeDistantPort:distantPort];
    }
    else
    {
        // Handle other messages.
    }
}
```

### Implementing the Secondary Thread Code
For the secondary worker thread, you must configure the thread and use the specified port to communicate information back to the primary thread.

Listing 3-14 shows the code for setting up the worker thread. After creating an autorelease pool for the thread, the method creates a worker object to drive the thread execution. The worker object’s sendCheckinMessage: method (shown in Listing 3-15) creates a local port for the worker thread and sends a check-in message back to the main thread.

对于辅助工作线程，您必须配置线程并使用指定的端口将信息传递回主线程。

清单3-14显示了设置工作线程的代码。在为线程创建自动释放池之后，该方法将创建一个工作器对象以驱动线程执行。worker对象的sendCheckinMessage:方法（如清单3-15所示）为worker线程创建一个本地端口，并将签入消息发送回主线程。


**Listing 3-14**  Launching the worker thread using Mach ports

```objc
+(void)LaunchThreadWithPort:(id)inData
{
    NSAutoreleasePool*  pool = [[NSAutoreleasePool alloc] init];
 
    // Set up the connection between this thread and the main thread.
    NSPort* distantPort = (NSPort*)inData;
 
    MyWorkerClass*  workerObj = [[self alloc] init];
    [workerObj sendCheckinMessage:distantPort];
    [distantPort release];
 
    // Let the run loop process things.
    do
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                            beforeDate:[NSDate distantFuture]];
    }
    while (![workerObj shouldExit]);
 
    [workerObj release];
    [pool release];
}
```

When using NSMachPort, local and remote threads can use the same port object for one-way communication between the threads. In other words, the local port object created by one thread becomes the remote port object for the other thread.

Listing 3-15 shows the check-in routine of the secondary thread. This method sets up its own local port for future communication and then sends a check-in message back to the main thread. The method uses the port object received in the LaunchThreadWithPort: method as the target of the message.

使用时NSMachPort，本地线程和远程线程可以将相同的端口对象用于线程之间的单向通信。换句话说，一个线程创建的本地端口对象成为另一线程的远程端口对象。

清单3-15显示了辅助线程的签入例程。此方法设置自己的本地端口以用于将来的通信，然后将签入消息发送回主线程。该方法将方法中接收到的端口对象LaunchThreadWithPort:用作消息的目标。


**Listing 3-15**  Sending the check-in message using Mach ports

```objc
// Worker thread check-in method
- (void)sendCheckinMessage:(NSPort*)outPort
{
    // Retain and save the remote port for future use.
    [self setRemotePort:outPort];
 
    // Create and configure the worker thread port.
    NSPort* myPort = [NSMachPort port];
    [myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
 
    // Create the check-in message.
    NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:outPort
                                         receivePort:myPort components:nil];
 
    if (messageObj)
    {
        // Finish configuring the message and send it immediately.
        [messageObj setMsgId:setMsgid:kCheckinMessage];
        [messageObj sendBeforeDate:[NSDate date]];
    }
}

```

### Configuring an NSMessagePort Object
To establish a local connection with an NSMessagePort object, you cannot simply pass port objects between threads. Remote message ports must be acquired by name. Making this possible in Cocoa requires registering your local port with a specific name and then passing that name to the remote thread so that it can obtain an appropriate port object for communication. Listing 3-16 shows the port creation and registration process in cases where you want to use message ports.

要与NSMessagePort对象建立本地连接，不能简单地在线程之间传递端口对象。远程消息端口必须按名称获取。要在Cocoa中实现此功能，需要使用特定名称注册您的本地端口，然后将该名称传递给远程线程，以便它可以获得用于通信的适当端口对象。清单3-16显示了要使用消息端口的情况下的端口创建和注册过程。


**Listing 3-16** Registering a message port

```objc
NSPort* localPort = [[NSMessagePort alloc] init];
 
// Configure the object and add it to the current run loop.
[localPort setDelegate:self];
[[NSRunLoop currentRunLoop] addPort:localPort forMode:NSDefaultRunLoopMode];
 
// Register the port using a specific name. The name must be unique.
NSString* localPortName = [NSString stringWithFormat:@"MyPortName"];
[[NSMessagePortNameServer sharedInstance] registerPort:localPort
                     name:localPortName];

```

### Configuring a Port-Based Input Source in Core Foundation
This section shows how to set up a two-way communications channel between your application’s main thread and a worker thread using Core Foundation.

Listing 3-17 shows the code called by the application’s main thread to launch the worker thread. The first thing the code does is set up a CFMessagePortRef opaque type to listen for messages from worker threads. The worker thread needs the name of the port to make the connection, so that string value is delivered to the entry point function of the worker thread. Port names should generally be unique within the current user context; otherwise, you might run into conflicts.

本节说明如何使用Core Foundation在应用程序的主线程和辅助线程之间建立双向通信通道。

清单3-17显示了由应用程序的主线程调用以启动工作线程的代码。代码要做的第一件事是建立一个CFMessagePortRef不透明类型，以侦听来自工作线程的消息。工作线程需要使用端口名称进行连接，以便将字符串值传递到工作线程的入口点函数。在当前用户上下文中，端口名称通常应该是唯一的；否则，您可能会遇到冲突。

**Listing 3-17**  Attaching a Core Foundation message port to a new thread

```objc
#define kThreadStackSize        (8 *4096)
 
OSStatus MySpawnThread()
{
    // Create a local port for receiving responses.
    CFStringRef myPortName;
    CFMessagePortRef myPort;
    CFRunLoopSourceRef rlSource;
    CFMessagePortContext context = {0, NULL, NULL, NULL, NULL};
    Boolean shouldFreeInfo;
 
    // Create a string with the port name.
    myPortName = CFStringCreateWithFormat(NULL, NULL, CFSTR("com.myapp.MainThread"));
 
    // Create the port.
    myPort = CFMessagePortCreateLocal(NULL,
                myPortName,
                &MainThreadResponseHandler,
                &context,
                &shouldFreeInfo);
 
    if (myPort != NULL)
    {
        // The port was successfully created.
        // Now create a run loop source for it.
        rlSource = CFMessagePortCreateRunLoopSource(NULL, myPort, 0);
 
        if (rlSource)
        {
            // Add the source to the current run loop.
            CFRunLoopAddSource(CFRunLoopGetCurrent(), rlSource, kCFRunLoopDefaultMode);
 
            // Once installed, these can be freed.
            CFRelease(myPort);
            CFRelease(rlSource);
        }
    }
 
    // Create the thread and continue processing.
    MPTaskID        taskID;
    return(MPCreateTask(&ServerThreadEntryPoint,
                    (void*)myPortName,
                    kThreadStackSize,
                    NULL,
                    NULL,
                    NULL,
                    0,
                    &taskID));
}
```

With the port installed and the thread launched, the main thread can continue its regular execution while it waits for the thread to check in. When the check-in message arrives, it is dispatched to the main thread’s MainThreadResponseHandler function, shown in Listing 3-18. This function extracts the port name for the worker thread and creates a conduit for future communication.

安装端口并启动线程后，主线程可以在等待线程检入的同时继续其常规执行。当检入消息到达时，它将分派给主线程的MainThreadResponseHandler函数，如清单3-18所示。。此函数提取工作线程的端口名，并创建用于将来通信的管道。


**Listing 3-18**  Receiving the checkin message

```objc
#define kCheckinMessage 100
 
// Main thread port message handler
CFDataRef MainThreadResponseHandler(CFMessagePortRef local,
                    SInt32 msgid,
                    CFDataRef data,
                    void* info)
{
    if (msgid == kCheckinMessage)
    {
        CFMessagePortRef messagePort;
        CFStringRef threadPortName;
        CFIndex bufferLength = CFDataGetLength(data);
        UInt8* buffer = CFAllocatorAllocate(NULL, bufferLength, 0);
 
        CFDataGetBytes(data, CFRangeMake(0, bufferLength), buffer);
        threadPortName = CFStringCreateWithBytes (NULL, buffer, bufferLength, kCFStringEncodingASCII, FALSE);
 
        // You must obtain a remote message port by name.
        messagePort = CFMessagePortCreateRemote(NULL, (CFStringRef)threadPortName);
 
        if (messagePort)
        {
            // Retain and save the thread’s comm port for future reference.
            AddPortToListOfActiveThreads(messagePort);
 
            // Since the port is retained by the previous function, release
            // it here.
            CFRelease(messagePort);
        }
 
        // Clean up.
        CFRelease(threadPortName);
        CFAllocatorDeallocate(NULL, buffer);
    }
    else
    {
        // Process other messages.
    }
 
    return NULL;
}
```

With the main thread configured, the only thing remaining is for the newly created worker thread to create its own port and check in. Listing 3-19 shows the entry point function for the worker thread. The function extracts the main thread’s port name and uses it to create a remote connection back to the main thread. The function then creates a local port for itself, installs the port on the thread’s run loop, and sends a check-in message to the main thread that includes the local port name.

配置了主线程后，剩下的唯一事情就是新创建的工作线程创建自己的端口并签入。清单3-19显示了工作线程的入口点函数。该函数提取主线程的端口名，并使用它来创建返回到主线程的远程连接。然后，该函数为其自身创建一个本地端口，将该端口安装在线程的运行循环上，并向主线程发送包含本地端口名称的签入消息。

**Listing 3-19**  Setting up the thread structures

```objc
OSStatus ServerThreadEntryPoint(void* param)
{
    // Create the remote port to the main thread.
    CFMessagePortRef mainThreadPort;
    CFStringRef portName = (CFStringRef)param;
 
    mainThreadPort = CFMessagePortCreateRemote(NULL, portName);
 
    // Free the string that was passed in param.
    CFRelease(portName);
 
    // Create a port for the worker thread.
    CFStringRef myPortName = CFStringCreateWithFormat(NULL, NULL, CFSTR("com.MyApp.Thread-%d"), MPCurrentTaskID());
 
    // Store the port in this thread’s context info for later reference.
    CFMessagePortContext context = {0, mainThreadPort, NULL, NULL, NULL};
    Boolean shouldFreeInfo;
    Boolean shouldAbort = TRUE;
 
    CFMessagePortRef myPort = CFMessagePortCreateLocal(NULL,
                myPortName,
                &ProcessClientRequest,
                &context,
                &shouldFreeInfo);
 
    if (shouldFreeInfo)
    {
        // Couldn't create a local port, so kill the thread.
        MPExit(0);
    }
 
    CFRunLoopSourceRef rlSource = CFMessagePortCreateRunLoopSource(NULL, myPort, 0);
    if (!rlSource)
    {
        // Couldn't create a local port, so kill the thread.
        MPExit(0);
    }
 
    // Add the source to the current run loop.
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rlSource, kCFRunLoopDefaultMode);
 
    // Once installed, these can be freed.
    CFRelease(myPort);
    CFRelease(rlSource);
 
    // Package up the port name and send the check-in message.
    CFDataRef returnData = nil;
    CFDataRef outData;
    CFIndex stringLength = CFStringGetLength(myPortName);
    UInt8* buffer = CFAllocatorAllocate(NULL, stringLength, 0);
 
    CFStringGetBytes(myPortName,
                CFRangeMake(0,stringLength),
                kCFStringEncodingASCII,
                0,
                FALSE,
                buffer,
                stringLength,
                NULL);
 
    outData = CFDataCreate(NULL, buffer, stringLength);
 
    CFMessagePortSendRequest(mainThreadPort, kCheckinMessage, outData, 0.1, 0.0, NULL, NULL);
 
    // Clean up thread data structures.
    CFRelease(outData);
    CFAllocatorDeallocate(NULL, buffer);
 
    // Enter the run loop.
    CFRunLoopRun();
}
```

Once it enters its run loop, all future events sent to the thread’s port are handled by the ProcessClientRequest function. The implementation of that function depends on the type of work the thread does and is not shown here.

一旦进入运行循环，该ProcessClientRequest函数将处理所有将来发送到线程端口的事件。该函数的实现取决于线程执行的工作类型，此处未显示。
