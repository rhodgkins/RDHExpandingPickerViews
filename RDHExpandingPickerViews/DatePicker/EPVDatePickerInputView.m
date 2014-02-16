//
//  EPVDatePickerInputView.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVDatePickerInputView.h"
#import "EPVBaseContainerInputView_EPVInternal.h"

#import "EPVDatePicker.h"

static void *EPVContextDate = &EPVContextDate;
static void *EPVContextCountDownInterval = &EPVContextCountDownInterval;
static void *EPVContextDatePickerMode = &EPVContextDatePickerMode;

@interface EPVDatePickerInputView ()

@end

@implementation EPVDatePickerInputView

-(void)dealloc
{
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(date)) context:EPVContextDate];
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(countDownDuration)) context:EPVContextCountDownInterval];
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(datePickerMode)) context:EPVContextDatePickerMode];
}

-(void)commonInit
{
    [self subclassCalled];
    
    [super commonInit];
    
    // Observer after so we don't get any calls when initially setting the selected object.
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(date)) options:NSKeyValueObservingOptionNew context:EPVContextDate];
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(countDownDuration)) options:NSKeyValueObservingOptionNew context:EPVContextCountDownInterval];
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(datePickerMode)) options:0 context:EPVContextDatePickerMode];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == EPVContextDate) {
        
        self.selectedDate = self.pickerView.date;
    
    } else if (context == EPVContextCountDownInterval) {
        
        self.selectedTimeInterval = self.pickerView.countDownDuration;
    
    } else if (context == EPVContextDatePickerMode) {

        if (self.selectedObject) {
            self.selectedObject = self.initiallySelectedObject;
        }
        [self updateValueDisplay];
        
    } else if ([super respondsToSelector:_cmd]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Required super class methods

-(UIView *)createPickerView
{
    UIDatePicker *datePicker = [EPVDatePicker new];
    [datePicker addTarget:self action:@selector(didChangeValue) forControlEvents:UIControlEventValueChanged];
    
    return datePicker;
}

-(NSString *)displayValueForSelectedObject
{
    NSString *value = nil;
    if (self.selectedObject) {
        
        if ([self isCountDownTimer]) {
            
            // Use the time since reference date to display as this will be formatted correctly and the maximum countdown time is 23:59
            value = [[[self class] countDownDateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:self.selectedTimeInterval]];
        } else {
            // Pick date style based on picker mode
            NSDateFormatterStyle dateStyle = (self.pickerView.datePickerMode == UIDatePickerModeDate || self.pickerView.datePickerMode == UIDatePickerModeDateAndTime) ? NSDateFormatterLongStyle : NSDateFormatterNoStyle;
            
            // Pick time style based on picker mode
            NSDateFormatterStyle timeStyle = (self.pickerView.datePickerMode == UIDatePickerModeTime || self.pickerView.datePickerMode == UIDatePickerModeDateAndTime) ? NSDateFormatterShortStyle : NSDateFormatterNoStyle;
            
            // Use device localisation
            value = [NSDateFormatter localizedStringFromDate:self.selectedDate dateStyle:dateStyle timeStyle:timeStyle];
        }
    }
    return value;
}

-(id)initiallySelectedObject
{
    if ([self isCountDownTimer]) {
        return @(self.pickerView.countDownDuration);
    } else {
        return self.pickerView.date;
    }
}

-(BOOL)isCountDownTimer
{
    return self.pickerView.datePickerMode == UIDatePickerModeCountDownTimer;
}

-(void)setSelectedObject:(id)selectedObject animated:(BOOL)animated
{
    if (!selectedObject) {
        if ([self isCountDownTimer]) {
            [self setSelectedTimeInterval:0 animated:animated];
        } else {
            [self setSelectedDate:nil animated:animated];
        }
    } else if ([selectedObject isKindOfClass:[NSDate class]]) {
        [self setSelectedDate:selectedObject animated:animated];
    } else if ([selectedObject isKindOfClass:[NSNumber class]]) {
        [self setSelectedTimeInterval:[selectedObject doubleValue] animated:YES];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Invalid selected object class (%@), only %@ (as a NSTimeInterval) and %@ are valid.", NSStringFromClass([selectedObject class]), NSStringFromClass([NSNumber class]), NSStringFromClass([NSDate class])];
    }
}

#pragma mark - Date selection

-(NSDate *)selectedDate
{
    if ([self isCountDownTimer]) {
        NSLog(@"You are trying to get a date on a count down timer UIDatePicker, change the mode first.");
        return nil;
    } else {
        return self.selectedObject;
    }
}

-(void)setSelectedDate:(NSDate *)selectedDate
{
    [self setSelectedDate:selectedDate animated:NO];
}

-(void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated
{
    if ([self isCountDownTimer]) {
        NSLog(@"You are trying to set a date on a count down timer UIDatePicker, change the mode first. Nothing has been done.");
    } else {
        NSDate *previousSelectedObject = self.selectedObject;
        
        [super setSelectedObject:selectedDate animated:animated];
        
        if (![previousSelectedObject isEqualToDate:selectedDate]) {
            
            if (selectedDate) {
                [self.pickerView setDate:selectedDate animated:animated];
            } else {
                [self.pickerView setDate:[NSDate date] animated:animated];
            }
        }
    }
}

#pragma mark - Countdown time selection

-(NSTimeInterval)selectedTimeInterval
{
    if ([self isCountDownTimer]) {
        return [self.selectedObject doubleValue];
    } else {
        NSLog(@"You are trying to get a time interval on a date UIDatePicker, change the mode first.");
        return 0;
    }
}

-(void)setSelectedTimeInterval:(NSTimeInterval)selectedTimeInterval
{
    [self setSelectedTimeInterval:selectedTimeInterval animated:NO];
}

-(void)setSelectedTimeInterval:(NSTimeInterval)selectedTimeInterval animated:(BOOL)animated
{
    if ([self isCountDownTimer]) {
        NSNumber *previousSelectedObject = self.selectedObject;
        
        [super setSelectedObject:@(selectedTimeInterval) animated:animated];
        
        if (![previousSelectedObject isEqualToNumber:@(selectedTimeInterval)]) {
            self.pickerView.countDownDuration = selectedTimeInterval;
        }
    } else {
        NSLog(@"You are trying to set a time interval on a UIDatePicker, change the mode first. Nothing has been done.");
    }
}

#pragma mark - Date change target

-(void)didChangeValue
{
    if ([self isCountDownTimer]) {
        self.selectedTimeInterval = self.pickerView.countDownDuration;
    } else {
        self.selectedDate = self.pickerView.date;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Count down date formatting

+(NSDateFormatter *)countDownDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCurrentLocaleDidChangeNotification:) name:NSCurrentLocaleDidChangeNotification object:nil];
        
        [self updateCurrentLocaleForCountDownDateFormatter:dateFormatter];
    });
    return dateFormatter;
}

+(void)updateCurrentLocaleForCountDownDateFormatter:(NSDateFormatter *)dateFormatter
{
    [dateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"H:m" options:0 locale:[dateFormatter locale]];
    [dateFormatter setDateFormat:dateFormat];
}

+(void)didReceiveCurrentLocaleDidChangeNotification:(NSNotification *)aNotification
{
    [self updateCurrentLocaleForCountDownDateFormatter:[self countDownDateFormatter]];
}

@end
