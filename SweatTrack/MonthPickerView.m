//
//  MonthPickerView.m
//  Kasrat
//
//  Created by Anand Kumar on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MonthPickerView.h"

@interface MonthPickerView ()

@property (nonatomic, strong) NSMutableArray *uniqueMonthsInStore;

@end

@implementation MonthPickerView

@synthesize uniqueMonthsInStore = _uniqueMonthsInStore;
@synthesize selectedMonth = _selectedMonth;
@synthesize managedObjectContext = _managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    self.uniqueMonthsInStore = [[NSMutableArray alloc] init];
    
    // Create and configure a fetch request with the WorkoutsDone entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutsDone" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"workoutDate"]];
    
    NSError *error;
    // Create and initialize the fetch results controller.
    NSArray *allDateValuesInStore = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMMM"];
    
   for (id workoutDateDictionary in allDateValuesInStore)
   {
       NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit |           NSYearCalendarUnit fromDate:[workoutDateDictionary valueForKey:@"workoutDate"]];   
       
       NSDate *monthComponent = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d",[dateComponents month]]];
       int yearComponent = [dateComponents year];
 
       NSString *monthAndYear = [monthFormatter stringFromDate:monthComponent];
       monthAndYear = [monthAndYear stringByAppendingString:@" "];
       monthAndYear = [monthAndYear stringByAppendingString:[NSString stringWithFormat:@"%d",yearComponent]];
       if (![self.uniqueMonthsInStore containsObject:monthAndYear]) {
           [self.uniqueMonthsInStore addObject:monthAndYear];
       }
   }
    
    self.uniqueMonthsInStore = (NSMutableArray *)[[self.uniqueMonthsInStore reverseObjectEnumerator] allObjects];
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
    return self.uniqueMonthsInStore.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.uniqueMonthsInStore objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedMonth = [self pickerView:pickerView titleForRow:row forComponent:component];
}

@end
