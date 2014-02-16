//
//  EPVViewController.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVViewController.h"

#import <UIView-Autolayout/UIView+AutoLayout.h>

#import <RDHExpandingPickerViews/EPVDatePickerInputView.h>
#import <RDHExpandingPickerViews/EPVExpandingPickerView.h>

@interface EPVViewController ()<EPVExpandingPickerViewDataSource, EPVExpandingPickerViewDelegate>

@property (nonatomic, weak) EPVDatePickerInputView *datePickerInputView;

@property (nonatomic, weak) EPVExpandingPickerView *expandingPickerView;

@property (nonatomic, copy) NSArray *pickerItems;

@end

@implementation EPVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    EPVDatePickerInputView *datePickerInputView = [EPVDatePickerInputView autoLayoutView];
    datePickerInputView.titleLabel.text = @"Title";
//    datePickerInputView.selectedObject = [NSDate date];
    datePickerInputView.labelEdgeInsets = UIEdgeInsetsMake(2, 10, 5, 20);
    datePickerInputView.placeholderValue = @"Date";
    datePickerInputView.displayBackgroundColor = [UIColor redColor];
//    datePickerInputView.expandedValueTextColor = [UIColor purpleColor];
    datePickerInputView.displayHighlightedBackgroundColor = [UIColor orangeColor];
    [self.view addSubview:datePickerInputView];
    self.datePickerInputView = datePickerInputView;
    
    [datePickerInputView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeTop ofItem:self.topLayoutGuide inset:CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame)];
    [datePickerInputView pinEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge toSameEdgesOfView:self.view];
    
    
    EPVExpandingPickerView *expandingPickerView = [EPVExpandingPickerView autoLayoutView];
    expandingPickerView.titleLabel.text = @"Title";
    expandingPickerView.placeholderValue = @"Picker";
    expandingPickerView.displayBackgroundColor = [UIColor yellowColor];
    expandingPickerView.displayHighlightedBackgroundColor = [UIColor orangeColor];
    expandingPickerView.dataSource = self;
    expandingPickerView.delegate = self;
    [self.view addSubview:expandingPickerView];
    self.expandingPickerView = expandingPickerView;
    
    [expandingPickerView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeBottom ofItem:datePickerInputView inset:50];
    [expandingPickerView pinEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge toSameEdgesOfView:self.view];
    
    double delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.datePickerInputView.pickerView setDate:[NSDate dateWithTimeIntervalSince1970:12414] animated:YES];
//        self.datePickerInputView.pickerView.maximumDate = [NSDate date];
//        self.datePickerInputView.pickerView.date = [NSDate dateWithTimeIntervalSince1970:2343242];
    });
    
    self.pickerItems = @[@"A", @"B", @"C", @"D", @"E"];
}

#pragma mark - Expanding picker view data source

-(NSUInteger)numberOfComponentsInExpandingPickerView:(EPVExpandingPickerView *)expandingPickerView
{
    return 2;
}

-(NSUInteger)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView numberOfRowsInComponent:(NSUInteger)component
{
    if (component == 0) {
        // Letters
        return [self.pickerItems count];
    } else {
        return 10;
    }
}

#pragma mark - Expanding picker view delegate

-(NSString *)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView displayValueForSelectedObject:(NSArray *)selectedObject
{
    return [NSString stringWithFormat:@"%@%@", self.pickerItems[[selectedObject[0] unsignedIntegerValue]], selectedObject[1]];
}

-(NSString *)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component
{
    if (component == 0) {
        return self.pickerItems[row];
    } else {
        return [NSString stringWithFormat:@"%lu", (unsigned long)row];
    }
}

@end
