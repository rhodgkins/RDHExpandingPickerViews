//
//  RDHViewController.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "RDHViewController.h"

#import <RDHExpandingPickerViews/RDHExpandingDatePickerView.h>
#import <RDHExpandingPickerViews/RDHExpandingPickerView.h>

#import "UIImage+RDHColor.h"

@interface RDHViewController ()<RDHExpandingPickerViewDataSource, RDHExpandingPickerViewDelegate>

@property (nonatomic, weak) RDHExpandingDatePickerView *countDownPickerInputView;

@property (nonatomic, weak) RDHExpandingDatePickerView *datePickerInputView;

@property (nonatomic, weak) RDHExpandingPickerView *expandingPickerView;

@property (nonatomic, copy) NSArray *pickerItems;

@property (nonatomic, strong) UIScrollView *view;

@end

@implementation RDHViewController

@dynamic view;

-(void)loadView
{
    NSMutableArray<UIView *> *views = [NSMutableArray array];
    
    RDHExpandingDatePickerView *datePickerInputView = [RDHExpandingDatePickerView new];
    datePickerInputView.titleLabel.tintColor = [UIColor greenColor];
//    [self setup:datePickerInputView];
//    datePickerInputView.titleLabel.text = @"Title";
    //    [datePickerInputView setTitle:@"Title" forState:~(0L)];
    datePickerInputView.labelEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    datePickerInputView.placeholderValue = @"Date";
//    datePickerInputView.dateFormatter = [NSDateFormatter new];
//    [datePickerInputView.dateFormatter setDateFormat:@"HH:mm yyyy"];
//    datePickerInputView.pickerViewBackgroundColor = [UIColor cyanColor];
//    datePickerInputView.expandedValueTextColor = [UIColor purpleColor];
//    datePickerInputView.displayBackgroundColor = [UIColor whiteColor];
//    datePickerInputView.displayHighlightedBackgroundColor = [UIColor lightGrayColor];
//    datePickerInputView.displayExpandedBackgroundColor = [UIColor redColor];
//    datePickerInputView.displayExpandedHighlightedBackgroundColor = [UIColor lightGrayColor];
    [datePickerInputView addTarget:self action:@selector(editingDidBeingForExpandingPickerView:) forControlEvents:UIControlEventEditingDidBegin];
    [datePickerInputView addTarget:self action:@selector(editingDidEndForExpandingPickerView:) forControlEvents:UIControlEventEditingDidEnd];
    [views addObject:datePickerInputView];
    self.datePickerInputView = datePickerInputView;
    
    RDHExpandingDatePickerView *countDownPickerInputView = [RDHExpandingDatePickerView new];
//    [self setup:countDownPickerInputView];
    countDownPickerInputView.pickerView.datePickerMode = UIDatePickerModeCountDownTimer;
//    countDownPickerInputView.selectedTimeInterval = 2213;
//    countDownPickerInputView.pickerView.minuteInterval = 5;
//    countDownPickerInputView.pickerViewBackgroundColor = [UIColor cyanColor];
    countDownPickerInputView.labelEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    countDownPickerInputView.placeholderValue = @"Count Down";
//    countDownPickerInputView.expandedValueTextColor = [UIColor purpleColor];
//    countDownPickerInputView.displayBackgroundColor = [UIColor redColor];
//    countDownPickerInputView.displayHighlightedBackgroundColor = [UIColor orangeColor];
//    countDownPickerInputView.displayExpandedBackgroundColor = [UIColor grayColor];
//    countDownPickerInputView.displayExpandedHighlightedBackgroundColor = [UIColor magentaColor];
    [countDownPickerInputView addTarget:self action:@selector(editingDidBeingForExpandingPickerView:) forControlEvents:UIControlEventEditingDidBegin];
    [countDownPickerInputView addTarget:self action:@selector(editingDidEndForExpandingPickerView:) forControlEvents:UIControlEventEditingDidEnd];
    [views addObject:countDownPickerInputView];
    self.countDownPickerInputView = countDownPickerInputView;
    
    RDHExpandingPickerView *expandingPickerView = [RDHExpandingPickerView new];
    expandingPickerView.placeholderValue = @"Picker";
//    [self setup:expandingPickerView];
//    expandingPickerView.displayBackgroundColor = [UIColor yellowColor];
//    expandingPickerView.displayHighlightedBackgroundColor = [UIColor orangeColor];
    expandingPickerView.dataSource = self;
    expandingPickerView.delegate = self;
    expandingPickerView.selectedObject = nil;
//    expandingPickerView.displayValueBlock = ^NSString *(RDHExpandingPickerView *view, NSArray *selectedObject) {
//        
//        return [NSString stringWithFormat:@"%@ - %@", self.pickerItems[[selectedObject[0] unsignedIntegerValue]], selectedObject[1]];
//    };
    [expandingPickerView addTarget:self action:@selector(editingDidBeingForExpandingPickerView:) forControlEvents:UIControlEventEditingDidBegin];
    [expandingPickerView addTarget:self action:@selector(editingDidEndForExpandingPickerView:) forControlEvents:UIControlEventEditingDidEnd];
//    expandingPickerView.placeholderValueColor = [UIColor blueColor];
    
    [views addObject:expandingPickerView];
    self.expandingPickerView = expandingPickerView;
    
    double delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.datePickerInputView.pickerView setDate:[NSDate dateWithTimeIntervalSince1970:12414] animated:YES];
//        self.datePickerInputView.pickerView.maximumDate = [NSDate date];
//        self.datePickerInputView.pickerView.date = [NSDate dateWithTimeIntervalSince1970:2343242];
//        self.datePickerInputView.displayHeight = 100;
    });
    
    self.pickerItems = @[@"One", @"Two", @"Three", @"Four", @""];
    
    NSMutableArray *pickerItems = [NSMutableArray arrayWithCapacity:20];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    for (NSUInteger i=0; i<20; i++) {
        [pickerItems addObject:[formatter stringFromNumber:@(i)]];
    }
    self.pickerItems = pickerItems;
    
    [datePickerInputView setTitle:@"Date Picker" forState:UIControlStateNormal];
    [countDownPickerInputView setTitle:@"Count Down Picker" forState:UIControlStateNormal];
    [expandingPickerView setTitle:@"Picker" forState:UIControlStateNormal];
    
    datePickerInputView.placeholderValue = @"Date";
    countDownPickerInputView.placeholderValue = @"Timer";
    expandingPickerView.placeholderValue = @"Item";
    
    
    self.view = [UIScrollView new];
    
    UIStackView *sv = [[UIStackView alloc] initWithArrangedSubviews:views];
    sv.spacing = 20;
    sv.axis = UILayoutConstraintAxisVertical;
    sv.distribution = UIStackViewDistributionFill;
    sv.alignment = UIStackViewAlignmentFill;
    
    sv.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray<NSLayoutConstraint *>* constraits;
    if (@available(iOS 11.0, *)) {
        constraits = @[
           [sv.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0],
           [sv.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0],
           [sv.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0],
           [sv.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0],
        ];
    } else {
        constraits = @[
           [sv.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:0],
           [sv.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0],
           [sv.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:0],
           [sv.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0],
       ];
    }
    
    [self.view addSubview:sv];
    [NSLayoutConstraint activateConstraints:constraits];
}

-(void)setup:(_RDHBaseExpandingPickerContainerView *)datePickerInputView
{
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
}

-(void)editingDidBeingForExpandingPickerView:(_RDHBaseExpandingPickerContainerView *)expandingPickerView
{
    CGRect rect = [self.view convertRect:expandingPickerView.bounds fromView:expandingPickerView];
    [self.view scrollRectToVisible:rect animated:YES];
}

-(void)editingDidEndForExpandingPickerView:(_RDHBaseExpandingPickerContainerView *)expandingPickerView
{
//    CGRect rect = [self.view convertRect:expandingPickerView.bounds fromView:expandingPickerView];
//    [self.view scrollRectToVisible:rect animated:YES];
    
//    expandingPickerView.enabled = NO;
}

#pragma mark - Expanding picker view data source

-(NSUInteger)numberOfComponentsInExpandingPickerView:(RDHExpandingPickerView *)expandingPickerView
{
    return 2;
}

-(NSUInteger)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView numberOfRowsInComponent:(NSUInteger)component
{
    if (component == 0) {
        // Letters
        return [self.pickerItems count];
    } else {
        return 10;
    }
}

#pragma mark - Expanding picker view delegate

-(NSString *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component
{
    if (component == 0) {
        return self.pickerItems[row];
    } else {
        return [NSString stringWithFormat:@"%lu", (unsigned long)row];
    }
}

@end
