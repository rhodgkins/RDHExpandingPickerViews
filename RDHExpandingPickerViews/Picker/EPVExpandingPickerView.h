//
//  EPVExpandingPickerView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVBaseContainerInputView.h"

@protocol EPVExpandingPickerViewDataSource, EPVExpandingPickerViewDelegate;

@interface EPVExpandingPickerView : EPVBaseContainerInputView

@property (nonatomic, weak) id<EPVExpandingPickerViewDataSource> dataSource;
@property (nonatomic, weak) id<EPVExpandingPickerViewDelegate> delegate;

-(void)reloadData;

-(NSUInteger)numberOfComponents;

-(NSUInteger)numberOfRowsInComponent:(NSUInteger)component;

#pragma mark - Item selection

/// Each element in the array should be a `NSNumber` and is the row you want selected in the component for that index. The number of items should match the `-[numberOfComponents]`.
@property (nonatomic, copy) NSArray *selectedObject;

-(void)setSelectedObject:(NSArray *)selectedObject animated:(BOOL)animated;

@end

@protocol EPVExpandingPickerViewDataSource <NSObject>

@required

-(NSUInteger)numberOfComponentsInExpandingPickerView:(EPVExpandingPickerView *)expandingPickerView;

-(NSUInteger)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView numberOfRowsInComponent:(NSUInteger)component;

@end

@protocol EPVExpandingPickerViewDelegate <NSObject>

/// @name Value display methods

@required

-(NSString *)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView displayValueForSelectedObject:(NSArray *)selectedObject;

@optional

-(NSAttributedString *)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView attributedDisplayValueForSelectedObject:(NSArray *)selectedObject;

@optional

/// @name Sizing methods

/// @return width of column the component.
-(CGFloat)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView widthForComponent:(NSUInteger)component;

/// @return height of row for each component.
-(CGFloat)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView rowHeightForComponent:(NSUInteger)component;

/// @name Content display methods

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
/**
 * If neither `-[expandingPickerView:attributedTitleForRow:forComponent:]` or `-[expandingPickerView:viewForRow:forComponent:reusingView:]` are implemented this method must be implemented.
 *
 * @return the title for the row in the component.
 */
-(NSString *)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component;
-(NSAttributedString *)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView attributedTitleForRow:(NSUInteger)row forComponent:(NSUInteger)component; // attributed title is favored if both methods are implemented
-(UIView *)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView viewForRow:(NSUInteger)row forComponent:(NSUInteger)component reusingView:(UIView *)view;

/// @name Selection methods

-(void)expandingPickerView:(EPVExpandingPickerView *)expandingPickerView didSelectRow:(NSUInteger)row inComponent:(NSUInteger)component;

@end