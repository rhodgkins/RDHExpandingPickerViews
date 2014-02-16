//
//  EPVDatePicker.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVDatePicker.h"

@implementation EPVDatePicker

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
