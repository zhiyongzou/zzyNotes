//
//  DeviceUtils.m
//  DebugTools
//
//  Created by zzyong on 2021/10/14.
//

#ifdef DEBUG

#import "DeviceUtils.h"
#import <mach/mach.h>
#import <sys/sysctl.h>

@implementation DeviceUtils

+ (float)cpuUsage {
    kern_return_t kr;
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    float tot_cpu = 0;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return tot_cpu;
    }
    
    long tot_sec = 0;
    long tot_usec = 0;
    for(int i = 0; i < thread_count; i++) {
        thread_info_data_t tinfo = {0};
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO, tinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return tot_cpu;
        }
        thread_basic_info_t basic_info_th = (thread_basic_info_t)tinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec += basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec += basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0f;
        }
    }
    vm_deallocate(mach_task_self_, (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    return tot_cpu;
}

+ (double)memoryFootprint {
    if (@available(iOS 9.0, *)) {
        task_vm_info_data_t vmInfo;
        mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
        kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo, &count);
        if (result != KERN_SUCCESS) {
            return 0;
        }
        return vmInfo.phys_footprint / 1024.0 / 1024.0;
    }
    return 0;
}

@end


#endif
