//
//  WorkoutTemplatePickerView.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTemplatePickerView.h"

@interface WorkoutTemplatePickerView ()

@property (nonatomic, strong) NSMutableArray *workoutTemplatesInStore;

@end

@implementation WorkoutTemplatePickerView

@synthesize workoutTemplatesInStore = _workoutTemplatesInStore;
@synthesize selectedWorkoutTemplate = _selectedWorkoutTemplate;
@synthesize managedObjectContext = _managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    self.workoutTemplatesInStore = [[NSMutableArray alloc] init];
    
    // Create and configure a fetch request with the Workout Template entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"workoutTemplateName"]];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTemplateNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTemplateNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    // Create and initialize the fetch results controller.
    NSArray *dictionariesForWorkoutTemplateNamesInStore = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (id dictionaryWorkoutTemplateName in dictionariesForWorkoutTemplateNamesInStore) {
        [self.workoutTemplatesInStore addObject:[dictionaryWorkoutTemplateName valueForKey:@"workoutTemplateName"]];
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
    return self.workoutTemplatesInStore.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.workoutTemplatesInStore objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.workoutTemplatesInStore.count > 0) {
            self.selectedWorkoutTemplate = [self pickerView:pickerView titleForRow:row forComponent:component];
    }

}


@end
