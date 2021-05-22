//
//  CancelPreviousPerformVC.m
//  CommonTest
//
//  Created by zzyong on 2021/3/17.
//

#import "CancelPreviousPerformVC.h"

@interface CancelPreviousPerformVC ()

@end

@implementation CancelPreviousPerformVC

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    // Do any additional setup after loading the view.
    
    /**
       frame #0: 0x000000010e4f9d27 CommonTest`-[CancelPreviousPerformVC printLog](self=0x00007f902cf04880, _cmd="printLog") at CancelPreviousPerformVC.m:30:5
       frame #1: 0x00007fff208308a9 Foundation`__NSFireDelayedPerform + 415
       frame #2: 0x00007fff2038fc57 CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__ + 20
       frame #3: 0x00007fff2038f72a CoreFoundation`__CFRunLoopDoTimer + 926
       frame #4: 0x00007fff2038ecdd CoreFoundation`__CFRunLoopDoTimers + 265
       frame #5: 0x00007fff2038935e CoreFoundation`__CFRunLoopRun + 1949
       frame #6: 0x00007fff203886d6 CoreFoundation`CFRunLoopRunSpecific + 567
       frame #7: 0x00007fff2bededb3 GraphicsServices`GSEventRunModal + 139
       frame #8: 0x00007fff24690e0b UIKitCore`-[UIApplication _run] + 912
       frame #9: 0x00007fff24695cbc UIKitCore`UIApplicationMain + 101
       frame #10: 0x000000010e4fa052 CommonTest`main(argc=1, argv=0x00007ffee1705d18) at main.m:17:12
       frame #11: 0x00007fff202593e9 libdyld.dylib`start + 1
       frame #12: 0x00007fff202593e9 libdyld.dylib`start + 1
     */
    
    [self performSelector:@selector(printLog) withObject:nil afterDelay:5];
    [self performSelector:@selector(printLog) withObject:nil afterDelay:5];
}

- (void)printLog {
    NSLog(@"CancelPreviousPerformVC");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
