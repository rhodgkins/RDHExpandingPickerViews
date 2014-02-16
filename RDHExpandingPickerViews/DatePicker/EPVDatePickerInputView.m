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
static void *EPVContextDatePickerMode = &EPVContextDatePickerMode;

@interface EPVDatePickerInputView ()

@end

@implementation EPVDatePickerInputView

-(void)dealloc
{
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(date)) context:EPVContextDate];
    [self.pickerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(datePickerMode)) context:EPVContextDatePickerMode];
}

-(void)commonInit
{
    [super commonInit];
    
    // Observer after so we don't get any calls when initially setting the selected object.
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(date)) options:NSKeyValueObservingOptionNew context:EPVContextDate];
    [self.pickerView addObserver:self forKeyPath:NSStringFromSelector(@selector(datePickerMode)) options:0 context:EPVContextDatePickerMode];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == EPVContextDate) {
        
        self.selectedObject = self.pickerView.date;
        
    } else if (context == EPVContextDatePickerMode) {
        
        [self updateValueDisplay];
    
    } else if ([super respondsToSelector:_cmd]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Required super class methods

-(UIView *)createPickerView
{
    UIDatePicker *datePicker = [EPVDatePicker new];
    [datePicker addTarget:self action:@selector(didChangeDate) forControlEvents:UIControlEventValueChanged];
    
    return datePicker;
}

-(NSString *)displayValueForSelectedObject
{
    NSString *value = nil;
    if (self.selectedObject) {
        // Pick date style based on picker mode
        NSDateFormatterStyle dateStyle = (self.pickerView.datePickerMode == UIDatePickerModeDate || self.pickerView.datePickerMode == UIDatePickerModeDateAndTime) ? NSDateFormatterLongStyle : NSDateFormatterNoStyle;
        
        // Pick time style based on picker mode
        NSDateFormatterStyle timeStyle = (self.pickerView.datePickerMode == UIDatePickerModeTime || self.pickerView.datePickerMode == UIDatePickerModeDateAndTime) ? NSDateFormatterShortStyle : NSDateFormatterNoStyle;
        
        // Use device localisation
        value = [NSDateFormatter localizedStringFromDate:self.selectedObject dateStyle:dateStyle timeStyle:timeStyle];
    }
    return value;
}

#pragma mark - Date selection

-(void)setSelectedObject:(NSDate *)selectedObject animated:(BOOL)animated
{
    [super setSelectedObject:selectedObject animated:animated];
    
    if (![self.selectedObject isEqualToDate:selectedObject]) {
        
        if (selectedObject) {
            [self.pickerView setDate:selectedObject animated:animated];
        } else {
            [self.pickerView setDate:[NSDate date] animated:animated];
        }
    }
}

-(id)initiallySelectedObject
{
    return self.pickerView.date;
}

#pragma mark - Date change target

-(void)didChangeDate
{
    self.selectedObject = self.pickerView.date;
}

@end
