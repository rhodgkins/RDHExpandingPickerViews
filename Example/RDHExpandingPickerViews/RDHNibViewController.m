//
//  RDHNibViewController.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 22/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "RDHNibViewController.h"

#import <RDHExpandingPickerViews/RDHExpandingPickerView.h>

@interface RDHNibViewController ()

@property (nonatomic, copy) NSArray *pickerItems;

@property (weak, nonatomic) IBOutlet RDHExpandingPickerView *expandingPickerView;

@end

@implementation RDHNibViewController

-(instancetype)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pickerItems = @[@"A", @"B", @"C", @"D", @"E"];
    
    self.expandingPickerView.displayValueBlock = ^NSString *(RDHExpandingPickerView *view, NSArray *selectedObject) {
        
        return [NSString stringWithFormat:@"%@ - %@", self.pickerItems[[selectedObject[0] unsignedIntegerValue]], selectedObject[1]];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(NSString *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView displayValueForSelectedObject:(NSArray *)selectedObject
{
    return [NSString stringWithFormat:@"%@%@", self.pickerItems[[selectedObject[0] unsignedIntegerValue]], selectedObject[1]];
}

-(NSString *)expandingPickerView:(RDHExpandingPickerView *)expandingPickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component
{
    if (component == 0) {
        return self.pickerItems[row];
    } else {
        return [NSString stringWithFormat:@"%lu", (unsigned long)row];
    }
}


@end
