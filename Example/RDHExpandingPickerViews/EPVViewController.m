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

#import "UIImage+RDHColor.h"

@interface EPVViewController ()<EPVExpandingPickerViewDataSource, EPVExpandingPickerViewDelegate>

@property (nonatomic, weak) EPVDatePickerInputView *countDownPickerInputView;

@property (nonatomic, weak) EPVDatePickerInputView *datePickerInputView;

@property (nonatomic, weak) EPVExpandingPickerView *expandingPickerView;

@property (nonatomic, copy) NSArray *pickerItems;

@property (nonatomic, strong) UIScrollView *view;

@end

@implementation EPVViewController

-(void)loadView
{
    self.view = [UIScrollView new];
        
    EPVDatePickerInputView *datePickerInputView = [EPVDatePickerInputView autoLayoutView];
    datePickerInputView.titleLabel.tintColor = [UIColor greenColor];
//    datePickerInputView.titleLabel.text = @"Title";
    //    [datePickerInputView setTitle:@"Title" forState:~(0L)];
    [datePickerInputView setTitle:@"TitleN" forState:UIControlStateNormal];
    [datePickerInputView setTitle:@"TitleS" forState:UIControlStateSelected];
    [datePickerInputView setTitle:@"TitleNH" forState:UIControlStateNormal|UIControlStateHighlighted];
    [datePickerInputView setTitle:@"TitleSH" forState:UIControlStateSelected|UIControlStateHighlighted];
    [datePickerInputView setTitle:@"TitleAHS" forState:RDHControlStateActivated|UIControlStateHighlighted|UIControlStateSelected];
    [datePickerInputView setTitle:@"TitleAHN" forState:RDHControlStateActivated|UIControlStateHighlighted|UIControlStateNormal];
    [datePickerInputView setTitle:@"TitleA" forState:RDHControlStateActivated];
    [datePickerInputView setTitle:@"TitleAS" forState:RDHControlStateActivated|UIControlStateSelected];
    
    [datePickerInputView setTitle:@"TitleDN" forState:UIControlStateNormal | UIControlStateDisabled];
    [datePickerInputView setTitle:@"TitleDS" forState:UIControlStateSelected | UIControlStateDisabled];
    [datePickerInputView setTitle:@"TitleDNH" forState:UIControlStateNormal|UIControlStateHighlighted | UIControlStateDisabled];
    [datePickerInputView setTitle:@"TitleDSH" forState:UIControlStateSelected|UIControlStateHighlighted | UIControlStateDisabled];
    [datePickerInputView setTitle:@"TitleDAHS" forState:RDHControlStateActivated|UIControlStateHighlighted|UIControlStateSelected | UIControlStateDisabled];
    [datePickerInputView setTitle:@"TitleDAHN" forState:RDHControlStateActivated|UIControlStateHighlighted|UIControlStateNormal | UIControlStateDisabled];
    [datePickerInputView setTitle:@"TitleDA" forState:RDHControlStateActivated | UIControlStateDisabled];
    [datePickerInputView setTitle:@"TitleDAS" forState:RDHControlStateActivated|UIControlStateSelected | UIControlStateDisabled];
    datePickerInputView.labelEdgeInsets = UIEdgeInsetsMake(2, 10, 5, 20);
    datePickerInputView.placeholderValue = @"Date";
//    datePickerInputView.pickerViewBackgroundColor = [UIColor cyanColor];
//    datePickerInputView.expandedValueTextColor = [UIColor purpleColor];
//    datePickerInputView.displayBackgroundColor = [UIColor whiteColor];
//    datePickerInputView.displayHighlightedBackgroundColor = [UIColor lightGrayColor];
//    datePickerInputView.displayExpandedBackgroundColor = [UIColor redColor];
//    datePickerInputView.displayExpandedHighlightedBackgroundColor = [UIColor lightGrayColor];
    [datePickerInputView addTarget:self action:@selector(editingDidBeingForExpandingPickerView:) forControlEvents:UIControlEventEditingDidBegin];
    [datePickerInputView addTarget:self action:@selector(editingDidEndForExpandingPickerView:) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:datePickerInputView];
    self.datePickerInputView = datePickerInputView;
    
    [datePickerInputView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeTop ofItem:self.topLayoutGuide inset:CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame)];
    [datePickerInputView pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0];
 
    
    EPVDatePickerInputView *countDownPickerInputView = [EPVDatePickerInputView autoLayoutView];
    countDownPickerInputView.titleLabel.text = @"Title";
    countDownPickerInputView.pickerView.datePickerMode = UIDatePickerModeCountDownTimer;
//    countDownPickerInputView.selectedTimeInterval = 2213;
//    countDownPickerInputView.pickerView.minuteInterval = 5;
    countDownPickerInputView.pickerViewBackgroundColor = [UIColor cyanColor];
    countDownPickerInputView.labelEdgeInsets = UIEdgeInsetsMake(2, 10, 5, 20);
    countDownPickerInputView.placeholderValue = @"Count Down";
//    countDownPickerInputView.expandedValueTextColor = [UIColor purpleColor];
//    countDownPickerInputView.displayBackgroundColor = [UIColor redColor];
//    countDownPickerInputView.displayHighlightedBackgroundColor = [UIColor orangeColor];
//    countDownPickerInputView.displayExpandedBackgroundColor = [UIColor grayColor];
//    countDownPickerInputView.displayExpandedHighlightedBackgroundColor = [UIColor magentaColor];
    [countDownPickerInputView addTarget:self action:@selector(editingDidBeingForExpandingPickerView:) forControlEvents:UIControlEventEditingDidBegin];
    [countDownPickerInputView addTarget:self action:@selector(editingDidEndForExpandingPickerView:) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:countDownPickerInputView];
    self.countDownPickerInputView = countDownPickerInputView;
    
    [countDownPickerInputView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeBottom ofItem:datePickerInputView inset:20];
    [countDownPickerInputView pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0];
    
    
    EPVExpandingPickerView *expandingPickerView = [EPVExpandingPickerView autoLayoutView];
    expandingPickerView.titleLabel.text = @"Title";
    expandingPickerView.placeholderValue = @"Picker";
//    expandingPickerView.displayBackgroundColor = [UIColor yellowColor];
//    expandingPickerView.displayHighlightedBackgroundColor = [UIColor orangeColor];
//    expandingPickerView.dataSource = self;
    expandingPickerView.delegate = self;
    expandingPickerView.selectedObject = nil;
    [expandingPickerView addTarget:self action:@selector(editingDidBeingForExpandingPickerView:) forControlEvents:UIControlEventEditingDidBegin];
    [expandingPickerView addTarget:self action:@selector(editingDidEndForExpandingPickerView:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.view addSubview:expandingPickerView];
    self.expandingPickerView = expandingPickerView;
    
    [expandingPickerView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeBottom ofItem:countDownPickerInputView inset:20];
    [expandingPickerView pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0];
    [expandingPickerView pinEdge:NSLayoutAttributeBottom toEdge:NSLayoutAttributeBottom ofItem:self.bottomLayoutGuide];
    
    double delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.datePickerInputView.pickerView setDate:[NSDate dateWithTimeIntervalSince1970:12414] animated:YES];
//        self.datePickerInputView.pickerView.maximumDate = [NSDate date];
//        self.datePickerInputView.pickerView.date = [NSDate dateWithTimeIntervalSince1970:2343242];
//        self.datePickerInputView.displayHeight = 100;
    });
    
    self.pickerItems = @[@"A", @"B", @"C", @"D", @"E"];
    
//    UIButton *b = [UIButton autoLayoutView];
//    [b setTitle:@"TITLE" forState:UIControlStateNormal];
//    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [b setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [b addTarget:self action:@selector(numberOfComponentsInExpandingPickerView:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:b];
//    [b pinToSuperviewEdges:JRTViewPinAllEdges inset:10];
}

-(void)editingDidBeingForExpandingPickerView:(EPVBaseContainerInputView *)expandingPickerView
{
    CGRect rect = [self.view convertRect:expandingPickerView.bounds fromView:expandingPickerView];
    [self.view scrollRectToVisible:rect animated:YES];
}

-(void)editingDidEndForExpandingPickerView:(EPVBaseContainerInputView *)expandingPickerView
{
//    CGRect rect = [self.view convertRect:expandingPickerView.bounds fromView:expandingPickerView];
//    [self.view scrollRectToVisible:rect animated:YES];
    
//    expandingPickerView.enabled = NO;
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
