//
//  EPVDatePickerInputView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVBaseContainerInputView.h"

@interface EPVDatePickerInputView : EPVBaseContainerInputView

@property (nonatomic, weak, readonly) UIDatePicker *pickerView;

#pragma mark - Date selection

@property (nonatomic, copy) NSDate *selectedObject;

-(void)setSelectedObject:(NSDate *)selectedObject animated:(BOOL)animated;

@end
