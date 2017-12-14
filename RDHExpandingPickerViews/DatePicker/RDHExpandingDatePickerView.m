//
//  RDHExpandingDatePickerView.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "RDHExpandingDatePickerView.h"
#import "_RDHBaseExpandingPickerContainerView_RDHInternal.h"

#import "RDHDatePicker.h"

static void *RDHContextDate = &RDHContextDate;
static void *RDHContextCountDownInterval = &RDHContextCountDownInterval;
static void *RDHContextDatePickerMode = &RDHContextDatePickerMode;

@interface RDHExpandingDatePickerView ()

@property (nonatomic, readonly, getter=isCountDownTimer) BOOL countDownTimer;

@end

@implementation RDHExpandingDatePickerView

@dynamic pickerView;

-(void)dealloc
{
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(date)) context:RDHContextDate];
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(countDownDuration)) context:RDHContextCountDownInterval];
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(datePickerMode)) context:RDHContextDatePickerMode];
}

-(void)commonInit
{
    [self subclassCalled];
    
    [super commonInit];
    
    // Observer after so we don't get any calls when initially setting the selected object.
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(date)) options:NSKeyValueObservingOptionNew context:RDHContextDate];
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(countDownDuration)) options:NSKeyValueObservingOptionNew context:RDHContextCountDownInterval];
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(datePickerMode)) options:0 context:RDHContextDatePickerMode];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == RDHContextDate) {
        
        self.selectedDate = self.pickerView.date;
        
    } else if (context == RDHContextCountDownInterval) {
        
        self.selectedTimeInterval = self.pickerView.countDownDuration;
        
    } else if (context == RDHContextDatePickerMode) {
        
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
    UIDatePicker *datePicker = [RDHDatePicker new];
    [datePicker addTarget:self action:@selector(didChangeValue) forControlEvents:UIControlEventValueChanged];
    
    return datePicker;
}

#pragma mark - Optional subclass methods

-(id)initiallySelectedObject
{
    if (self.countDownTimer) {
        return @(self.pickerView.countDownDuration);
    } else {
        return self.pickerView.date;
    }
}

-(NSString *)defaultDisplayValueForSelectedObject
{
    NSString *value = nil;
    
    if (self.countDownTimer) {
        
        if (self.timeIntervalFormatter) {
            value = [self.timeIntervalFormatter stringForObjectValue:@(self.selectedTimeInterval)];
        } else {
            // Use the time since reference date to display as this will be formatted correctly and the maximum countdown time is 23:59
            value = [[[self class] countDownDateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:self.selectedTimeInterval]];
        }
    } else {
        
        if (self.dateFormatter) {
            value = [self.dateFormatter stringFromDate:self.selectedDate];
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

#pragma mark - Class specific methods

-(BOOL)isCountDownTimer
{
    return self.pickerView.datePickerMode == UIDatePickerModeCountDownTimer;
}

-(void)setSelectedObject:(id)selectedObject animated:(BOOL)animated
{
    if (!selectedObject) {
        if (self.countDownTimer) {
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
    if (self.countDownTimer) {
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
    if (self.countDownTimer) {
        NSLog(@"You are trying to set a date on a count down timer UIDatePicker, change the mode first. Nothing has been done.");
    } else {
        NSDate *previousSelectedObject = self.selectedObject;
        
        [super setSelectedObject:selectedDate animated:animated];
        
        if (selectedDate) {
            if (![previousSelectedObject isEqualToDate:selectedDate]) {
                [self.pickerView setDate:selectedDate animated:animated];
            }
        } else {
            if (previousSelectedObject) {
                [self.pickerView setDate:[NSDate date] animated:animated];
            }
        }
    }
}

#pragma mark - Countdown time selection

-(NSTimeInterval)selectedTimeInterval
{
    if (self.countDownTimer) {
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
    if (self.countDownTimer) {
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
    if (self.countDownTimer) {
        self.selectedTimeInterval = self.pickerView.countDownDuration;
    } else {
        self.selectedDate = self.pickerView.date;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Display blocks

-(void)setDateDisplayValueBlock:(NSString* _Nullable (^)(RDHExpandingDatePickerView * _Nonnull, NSDate * _Nonnull))block
{
    NSAssert(!self.countDownTimer, @"Calling %@ on count down timer", NSStringFromSelector(_cmd));
    
    if (block) {
        self.displayValueBlock = ^NSString* _Nullable (_RDHBaseExpandingPickerContainerView* pv, NSDate* date) { return block((RDHExpandingDatePickerView*)pv, date); };
    } else {
        self.displayValueBlock = nil;
    }
}

-(void)setAttributedDateDisplayValueBlock:(NSAttributedString * _Nullable (^)(RDHExpandingDatePickerView * _Nonnull, NSDate * _Nonnull))block
{
    NSAssert(!self.countDownTimer, @"Calling %@ on count down timer", NSStringFromSelector(_cmd));
    
    if (block) {
        self.attributedDisplayValueBlock = ^NSAttributedString* _Nullable (_RDHBaseExpandingPickerContainerView* pv, NSDate* date) { return block((RDHExpandingDatePickerView*)pv, date); };
    } else {
        self.displayValueBlock = nil;
    }
}

-(void)setTimeIntervalDisplayValueBlock:(NSString* _Nullable (^)(RDHExpandingDatePickerView * _Nonnull, NSTimeInterval))block
{
    NSAssert(self.countDownTimer, @"Calling %@ on non-count down timer", NSStringFromSelector(_cmd));
    
    if (block) {
        self.displayValueBlock = ^NSString *(_RDHBaseExpandingPickerContainerView* pv, NSNumber *tI) { return block((RDHExpandingDatePickerView*)pv, tI.doubleValue); };
    } else {
        self.displayValueBlock = nil;
    }
}

-(void)setAttributedTimeIntervalDisplayValueBlock:(NSAttributedString * _Nullable (^)(RDHExpandingDatePickerView * _Nonnull, NSTimeInterval))block
{
    NSAssert(self.countDownTimer, @"Calling %@ on non-count down timer", NSStringFromSelector(_cmd));
    
    if (block) {
        self.attributedDisplayValueBlock = ^NSAttributedString* _Nullable (_RDHBaseExpandingPickerContainerView* pv, NSNumber* tI) { return block((RDHExpandingDatePickerView*)pv, tI.doubleValue); };
    } else {
        self.displayValueBlock = nil;
    }
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
