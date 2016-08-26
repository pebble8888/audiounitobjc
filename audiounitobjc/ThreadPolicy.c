//
//  ThreadPolicy.c
//  audiounitswift
//
//  Created by pebble8888 on 2016/08/26.
//  Copyright © 2016年 pebble8888. All rights reserved.
//
// https://developer.apple.com/library/mac/documentation/Darwin/Conceptual/KernelProgramming/scheduler/scheduler.html
//

#include "ThreadPolicy.h"

#include <mach/mach_init.h>
#include <mach/thread_policy.h>
#include <mach/thread_act.h>
#include <pthread.h>
#include <assert.h>
#include <stdio.h>

void getThreadPolicy(void)
{
    thread_port_t threadport = pthread_mach_thread_np(pthread_self());
    
    kern_return_t kr;
    mach_msg_type_number_t policy_count;
    boolean_t get_default;
    {
        thread_standard_policy_data_t policy;
        policy_count = THREAD_STANDARD_POLICY_COUNT;
        get_default = FALSE;
        kr = thread_policy_get(threadport,
                               THREAD_STANDARD_POLICY,
                               (thread_policy_t)&policy,
                               &policy_count,
                               &get_default);
        assert(kr == KERN_SUCCESS);
        printf("standard policy_count %d get_default %d\n", policy_count, get_default);
    }
    {
        thread_precedence_policy_data_t policy;
        policy_count = THREAD_PRECEDENCE_POLICY_COUNT;
        get_default = FALSE;
        kr = thread_policy_get(threadport,
                               THREAD_PRECEDENCE_POLICY,
                               (thread_policy_t)&policy,
                               &policy_count,
                               &get_default);
        assert(kr == KERN_SUCCESS);
        
        printf("importance %d count %d get_default %d\n", policy.importance, policy_count, get_default);
    }
    {
        thread_extended_policy_data_t policy;
        policy_count = THREAD_EXTENDED_POLICY_COUNT;
        get_default = FALSE;
        kr = thread_policy_get(threadport,
                               THREAD_EXTENDED_POLICY,
                               (thread_policy_t)&policy,
                               &policy_count,
                               &get_default);
        assert(kr == KERN_SUCCESS);
        printf("timeshare %d policy_count %d get_default %d\n", policy.timeshare, policy_count, get_default);
    }
    {
        thread_time_constraint_policy_data_t policy;
        policy_count = THREAD_TIME_CONSTRAINT_POLICY_COUNT;
        get_default = FALSE;
        kr = thread_policy_get(threadport,
                               THREAD_TIME_CONSTRAINT_POLICY,
                               (thread_policy_t)&policy,
                               &policy_count,
                               &get_default);
        assert(kr == KERN_SUCCESS);
        printf("period %d computation %d constraint %d preemptible %d policy_count %d get_default %d\n",
               policy.period, policy.computation, policy.constraint, policy.preemptible, policy_count, get_default);
    }
}