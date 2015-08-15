//
//  WorkoutTypePickerView.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTypePickerView.h"

@interface WorkoutTypePickerView ()

@property (nonatomic, strong) NSMutableArray *workoutTypesInStore;

@end

@implementation WorkoutTypePickerView

@synthesize workoutTypesInStore = workoutTypesInStore;
@synthesize selectedWorkoutType = _selectedWorkoutType;
@synthesize managedObjectContext = _managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    self.workoutTypesInStore = [[NSMutableArray alloc] init];
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTypes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"workoutName"]];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTypeNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTypeNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    
    NSError *error;
    // Create and initialize the fetch results controller.
    NSArray *dictionariesForWorkoutNamesInStore = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (id dictionaryWorkoutName in dictionariesForWorkoutNamesInStore) {
        [self.workoutTypesInStore addObject:[dictionaryWorkoutName valueForKey:@"workoutName"]];
    }
}

- (id)initWithFrame:(CGRect)frame andContext:(NSManagedObjectContext *)context
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.showsSelectionIndicator = YES;
        self.managedObjectContext = context;
    }
    
    return self;
}

- (void)ifAvailableShowOption:(NSString *)possibleOption
{
    int numberOfRows = [self pickerView:self numberOfRowsInComponent:0];  //Assumed the picker view has just 1 component
    int i;
    
    for (i = 0; i < numberOfRows; i = i + 1) {
        if ([[self pickerView:self titleForRow:i forComponent:0] isEqualToString:possibleOption]) {
            [self selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
}

#pragma mark PickerView Datasource and Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.workoutTypesInStore.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.workoutTypesInStore objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.workoutTypesInStore.count > 0) {
        self.selectedWorkoutType = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    
}



@end
