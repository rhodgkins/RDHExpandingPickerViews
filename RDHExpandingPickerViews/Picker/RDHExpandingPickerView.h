//
//  RDHExpandingPickerView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "_RDHBaseExpandingPickerContainerView.h"

@protocol RDHExpandingPickerViewDataSource, RDHExpandingPickerViewDelegate;

/// Expanding picker view backed by a `UIPickerView`.
@interface RDHExpandingPickerView : _RDHBaseExpandingPickerContainerView

/// @name Data source

/// Data source
@property (nonatomic, weak) IBOutlet id<RDHExpandingPickerViewDataSource> dataSource;

/// @name Delegate

/// Delegate
@property (nonatomic, weak) IBOutlet id<RDHExpandingPickerViewDelegate> delegate;

/// @name Data methods

/// `YES` will disable the control when there are no values to pick from. Default is `YES`.
@property (nonatomic, assign, getter = isDisabledWhenEmpty) BOOL disabledWhenEmpty;

/// Reloads the picker view.
-(void)reloadData;

/// @returns The number of components in the picker.
-(NSUInteger)numberOfComponents;

/**
 * @param component the component.
 *
 * @returns The number of row for the provided component in the picker.
 */
-(NSUInteger)numberOfRowsInComponent:(NSUInteger)component;

#pragma mark - Item selection
/// @name Item selection

/// Each element in the array should be a `NSNumber` and is the row you want selected in the component for that index. The number of items should match the `-numberOfComponents`.
@property (nonatomic, copy) NSArray<NSNumber *> *selectedObject;

/// @see selectedObject
-(void)setSelectedObject:(NSArray<NSNumber *> *)selectedObject animated:(BOOL)animated;

#pragma mark - Display blocks
/// @name Display blocks

/// This will be ignored if `attributedDisplayValueBlock` is set or returns `nil`.
@property (nonatomic, copy) NSString*(^displayValueBlock)(RDHExpandingPickerView *expandingPickerView, NSArray<NSNumber *> *selectedObject);

/// This will be used over `displayValueBlock`.
@property (nonatomic, copy) NSAttributedString*(^attriburedDisplayValueBlock)(RDHExpandingPickerView *expandingPickerView, NSArray<NSNumber *> *selectedObject);

@end

/// Defines data values for the expanding picker view.
@protocol RDHExpandingPickerViewDataSource <NSObject>

@required

/**
 * @param expandingPickerView The expanding picker view requesting the number of components.
 *
 * @returns The number of components.
 */
-(NSUInteger)numberOfComponentsInExpandingPickerView:(RDHExpandingPickerView *)expandingPickerView;

/**
 * @param expandingPickerView The expanding picker view requesting the number of rows.
 * @param component The component requesting the number of rows it contains.
 *
 * @returns The number of row for the component.
 */
-(NSUInteger)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView numberOfRowsInComponent:(NSUInteger)component;

@end

/// Defines actions and views for the expanding picker view.
@protocol RDHExpandingPickerViewDelegate <NSObject>

@optional
#pragma mark - Sizing methods
/// @name Sizing methods

/**
 * @param expandingPickerView The expanding picker view requesting the component width.
 * @param component The component for the requested width.
 *
 * @return width of column the component.
 */
-(CGFloat)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView widthForComponent:(NSUInteger)component;

/**
 * @param expandingPickerView The expanding picker view requesting the row height.
 * @param component The component for the requested row height.
 *
 * @return height of row for each component.
 */
-(CGFloat)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView rowHeightForComponent:(NSUInteger)component;

@optional
#pragma mark - Content display methods
/// @name Content display methods

/**
 * If neither `-expandingPickerView:attributedTitleForRow:forComponent:` or `-expandingPickerView:viewForRow:forComponent:reusingView:` are implemented this method must be implemented.
 *
 * @param expandingPickerView The expanding picker view requesting the title.
 * @param row The row for the requested title.
 * @param component The component for the requested title.
 *
 * @return the title for the row in the component.
 */
-(NSString *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component;

/**
 * This method overrides `-expandingPickerView:titleForRow:forComponent:` but ignored if `-expandingPickerView:viewForRow:forComponent:reusingView:` is implemented.
 *
 * @param expandingPickerView The expanding picker view requesting the attributed title.
 * @param row The row for the requested attributed title.
 * @param component The component for the requested attributed title.
 *
 * @return the attributed title for the row in the component.
 */
-(NSAttributedString *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView attributedTitleForRow:(NSUInteger)row forComponent:(NSUInteger)component;

/**
 * This method overrides `-expandingPickerView:titleForRow:forComponent:` and `-expandingPickerView:attributedTitleForRow:forComponent:`if it is implemented.
 *
 * @param expandingPickerView The expanding picker view requesting the view.
 * @param row The row for the requested view.
 * @param component The component for the requested view.
 * @param view A view that can be reused that was previously returned from this method. This maybe `nil` if no reusable views are available.
 *
 * @return the view for the row in the component.
 */
-(UIView *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView viewForRow:(NSUInteger)row forComponent:(NSUInteger)component reusingView:(UIView *)view;

@optional
#pragma mark - Selection methods
/// @name Selection methods

/**
 * @param expandingPickerView The expanding picker view that was selected.
 * @param row The row that was selected.
 * @param component The component for the row.
 */
-(void)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView didSelectRow:(NSUInteger)row inComponent:(NSUInteger)component;

@end
