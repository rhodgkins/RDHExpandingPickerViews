//
//  EPVDatePicker.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVDatePicker.h"

// Fixed a bug in iOS 7, see http://stackoverflow.com/questions/20181980/uidatepicker-bug-uicontroleventvaluechanged-after-hitting-minimum-internal
#define RDH_IOS7_COUNT_DOWN_TIME_FIX 1

@implementation EPVDatePicker
#if RDH_IOS7_COUNT_DOWN_TIME_FIX
{
    BOOL firstChange;
}

// Only need to override this as a EPVDatePicker view is only ever initialized by 'new'
-(instancetype)init
{
    self = [super init];
    if (self) {
        firstChange = NO;
    }
    return self;
}

-(void)setCountDownDuration:(NSTimeInterval)countDownDuration
{
    super.countDownDuration = countDownDuration;
    
    if (!firstChange) {
        firstChange = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.countDownDuration = self.countDownDuration;
        });
    }
}
#endif

-(void)setMinuteInterval:(NSInteger)minuteInterval
{
    NSTimeInterval previousDuration = self.countDownDuration;
    super.minuteInterval = minuteInterval;
    
    if (previousDuration != self.countDownDuration) {
        // Make sure that we know the duration has changed
        self.countDownDuration = self.countDownDuration;
    }
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(date))];
    
    [super setDate:date animated:animated];
    
    [self didChangeValueForKey:NSStringFromSelector(@selector(date))];
}

-(void)setMinimumDate:(NSDate *)minimumDate
{
    NSDate *previousDate = self.date;
    super.minimumDate = minimumDate;
    
    if (![self.date isEqualToDate:previousDate]) {
        // Make sure that we know the date has changed
        self.date = self.date;
    }
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    NSDate *previousDate = self.date;
    super.maximumDate = maximumDate;
    
    if (![self.date isEqualToDate:previousDate]) {
        // Make sure that we know the date has changed
        self.date = self.date;
    }
}

@end
