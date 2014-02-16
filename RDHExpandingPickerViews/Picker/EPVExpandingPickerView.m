//
//  EPVExpandingPickerView.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVExpandingPickerView.h"
#import "EPVBaseContainerInputView_EPVInternal.h"

#import "NSValue+RDHSelector.h"

@interface EPVExpandingPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak, readonly) UIPickerView *pickerView;

@end

@implementation EPVExpandingPickerView

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (newWindow) {
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self reloadData];
    }
}

#pragma mark - Required super class methods

-(UIView *)createPickerView
{
    UIPickerView *pickerView = [UIPickerView new];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    return pickerView;
}

-(NSArray *)initiallySelectedObject
{
    NSUInteger count = [self numberOfComponents];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    NSNumber *zero = @(0);
    
    for (NSUInteger component = 0; component < count; component++) {
        [array addObject:zero];
    }
    
    return [array copy];
}

-(NSString *)displayValueForSelectedObject
{
    NSString *value = nil;
    if (self.selectedObject) {
        value = [self.delegate expandingPickerView:self displayValueForSelectedObject:self.selectedObject];
    }
    return value;
}

-(NSAttributedString *)attributedDisplayValueForSelectedObject
{
    NSAttributedString *value = [super attributedDisplayValueForSelectedObject];
    if ([self.delegate respondsToSelector:@selector(expandingPickerView:attributedDisplayValueForSelectedObject:)]) {
        if (self.selectedObject) {
            value = [self.delegate expandingPickerView:self attributedDisplayValueForSelectedObject:self.selectedObject];
        }
    }
    return value;
}

#pragma mark - Object selection

-(void)setSelectedObject:(NSArray *)selectedObject animated:(BOOL)animated
{
    [super setSelectedObject:selectedObject animated:animated];
    
    if (![self.selectedObject isEqualToArray:selectedObject]) {
        
        if (selectedObject) {
            NSAssert([selectedObject count] == [self numberOfComponents], @"The number of items in the selectedObjects array must equal the number of components in the expanding picker view");
            
            [selectedObject enumerateObjectsUsingBlock:^(NSNumber *row, NSUInteger component, BOOL *stop) {
                
                NSAssert([row isKindOfClass:[NSNumber class]], @"Item at index %lu of the selectedObjects must be a %@", (unsigned long)component, NSStringFromClass([NSNumber class]));
                
                [self.pickerView selectRow:[row integerValue] inComponent:component animated:animated];
            }];
        } else {
            for (NSUInteger component = 0; component < [self numberOfComponents]; component++) {
                [self.pickerView selectRow:0 inComponent:component animated:animated];
            }
        }
    }
}

#pragma mark - Class specific methods

-(void)reloadData
{
    [self.pickerView reloadAllComponents];
    
    [self updateEnabled];
}

-(NSUInteger)numberOfComponents
{
    return [self.dataSource numberOfComponentsInExpandingPickerView:self];
}

-(NSUInteger)numberOfRowsInComponent:(NSUInteger)component
{
    return [self.dataSource expandingPickerView:self numberOfRowsInComponent:component];
}

-(void)setDataSource:(id<EPVExpandingPickerViewDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        self.pickerView.dataSource = self;
        
        [self reloadData];
    }
}

-(void)setDelegate:(id<EPVExpandingPickerViewDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        self.pickerView.delegate = self;
        
        [self reloadData];
    }
}

-(void)updateEnabled
{
    BOOL enabled = NO;
    
    for (NSUInteger component = 0; component < [self.pickerView numberOfComponents]; component++) {
        
        if ([self.pickerView numberOfRowsInComponent:component] > 0) {
            // Found that we've got selectable data
            enabled = YES;
            break;
        }
    }
    self.enabled = enabled;
}

#pragma mark - UIPickerView data source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSUInteger result = [self numberOfComponents];
    
    NSAssert(result <= NSIntegerMax, @"The data source method %@ must return a value less than NSIntegerMax", NSStringFromSelector(@selector(numberOfComponentsInExpandingPickerView:)));
    
    return result;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger result = [self numberOfRowsInComponent:component];
    
    NSAssert(result <= NSIntegerMax, @"The data source method %@ must return a value less than NSIntegerMax", NSStringFromSelector(@selector(expandingPickerView:numberOfRowsInComponent:)));
    
    return result;
}

#pragma mark - UIPickerView delegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self.delegate expandingPickerView:self widthForComponent:component];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [self.delegate expandingPickerView:self rowHeightForComponent:component];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.delegate expandingPickerView:self titleForRow:row forComponent:component];
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.delegate expandingPickerView:self attributedTitleForRow:row forComponent:component];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    return [self.delegate expandingPickerView:self viewForRow:row forComponent:component reusingView:view];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableArray *selectedObjects = [self.selectedObject mutableCopy];
    if (!selectedObjects) {
        selectedObjects = self.initiallySelectedObject;
    }
    selectedObjects[component] = @(row);
    self.selectedObject = selectedObjects;
    
    if ([self.delegate respondsToSelector:@selector(expandingPickerView:didSelectRow:inComponent:)]) {
        [self.delegate expandingPickerView:self didSelectRow:row inComponent:component];
    }
}

#pragma mark - Delegate selector checking

-(BOOL)respondsToSelector:(SEL)aSelector
{
    NSValue *mappedSelector = [[self class] mappedUIPickerViewDelegateSelectors][[NSValue valueWithSelector:aSelector]];
    if (mappedSelector) {
        return [self.delegate respondsToSelector:[mappedSelector selector]];
    }
    
    mappedSelector = [[self class] mappedUIPickerViewDataSourceSelectors][[NSValue valueWithSelector:aSelector]];
    if (mappedSelector) {
        return [self.dataSource respondsToSelector:[mappedSelector selector]];
    }
    
    return [super respondsToSelector:aSelector];
}

#define RDH_SEL_VALUE(S) ([NSValue valueWithSelector:@selector(S)])

/// @return A dictionary mapping `UIPickerViewDelegate` selectors to `EPVExpandingPickerViewDelegate` selectors.
+(NSDictionary *)mappedUIPickerViewDelegateSelectors
{
    static NSDictionary *mappedSelectors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappedSelectors = @{RDH_SEL_VALUE(pickerView:widthForComponent:) : RDH_SEL_VALUE(expandingPickerView:widthForComponent:),
                            RDH_SEL_VALUE(pickerView:rowHeightForComponent:) : RDH_SEL_VALUE(expandingPickerView:rowHeightForComponent:),
                            RDH_SEL_VALUE(pickerView:titleForRow:forComponent:) : RDH_SEL_VALUE(expandingPickerView:titleForRow:forComponent:),
                            RDH_SEL_VALUE(pickerView:attributedTitleForRow:forComponent:) : RDH_SEL_VALUE(expandingPickerView:attributedTitleForRow:forComponent:),
                            RDH_SEL_VALUE(pickerView:widthForComponent:) : RDH_SEL_VALUE(expandingPickerView:widthForComponent:),
                            RDH_SEL_VALUE(pickerView:viewForRow:forComponent:reusingView:) : RDH_SEL_VALUE(expandingPickerView:viewForRow:forComponent:reusingView:)
                            
                            };
    });
    return mappedSelectors;
}

/// @return A dictionary mapping `UIPickerViewDataSource` selectors to `EPVExpandingPickerViewDataSource` selectors.
+(NSDictionary *)mappedUIPickerViewDataSourceSelectors
{
    static NSDictionary *mappedSelectors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappedSelectors = @{RDH_SEL_VALUE(numberOfComponentsInPickerView:) : RDH_SEL_VALUE(numberOfComponentsInExpandingPickerView:),
                            RDH_SEL_VALUE(pickerView:numberOfRowsInComponent:) : RDH_SEL_VALUE(expandingPickerView:numberOfRowsInComponent:)
                            
                            };
    });
    return mappedSelectors;
}

@end
