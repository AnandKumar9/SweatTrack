//
//  SelectedMonthDetailsViewController.m
//  Kasrat
//
//  Created by Anand Kumar on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedMonthDetailsViewController.h"
#import "MonthPickerView.h"

@interface SelectedMonthDetailsViewController ()

@property (nonatomic, strong) NSString *monthRowText;
@property (nonatomic, strong) MonthPickerView *monthPickerView;

@property (nonatomic, strong) NSArray *fetchResults;

@property (nonatomic, strong) NSMutableArray *allDateValuesOfSelectedMonth;
@property (nonatomic, strong) NSMutableArray *variousUniqueFormattedDays;
@property (nonatomic, strong) NSMutableArray *variousUniqueFormattedDaysCount;

@end

@implementation SelectedMonthDetailsViewController

@synthesize monthRowText = _monthRowText;
@synthesize monthPickerView = _monthPickerView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchResults = _fetchResults;
@synthesize allDateValuesOfSelectedMonth = _allDateValuesOfSelectedMonth;
@synthesize variousUniqueFormattedDays = _variousUniqueFormattedDays;
@synthesize variousUniqueFormattedDaysCount = _variousUniqueFormattedDaysCount;

- (void)executeFetch
{
    if (self.monthRowText) {
        
        // Create and configure a fetch request with the WorkoutsDone entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutsDone" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setResultType:NSDictionaryResultType];
        [fetchRequest setReturnsDistinctResults:NO];
        [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"workoutDate"]];
        
        
        //Form date objects as per monthRowText, so that they can be used in the predicate
        NSString *monthInMonthRowText = [self.monthRowText substringToIndex:(self.monthRowText.length - 5)];
        NSString *yearInMonthRowText = [self.monthRowText substringFromIndex:(self.monthRowText.length - 4)];
        
        NSDateFormatter* formatterForGettingMonthNumber = [[NSDateFormatter alloc] init];
        [formatterForGettingMonthNumber setDateFormat:@"MMMM"];
        NSDate *dateForGettingMonthNumber = [formatterForGettingMonthNumber dateFromString:monthInMonthRowText];
        NSDateComponents *monthNumber = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:dateForGettingMonthNumber];
        
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents *date1Components = [[NSDateComponents alloc] init];
        [date1Components setDay:1];
        [date1Components setMonth:[monthNumber month]];
        [date1Components setYear:[yearInMonthRowText intValue]];
        [date1Components setHour:0];
        [date1Components setMinute:0];
        [date1Components setSecond:0];
        
        NSDate *date1 = [currentCalendar dateFromComponents:date1Components];
        
        NSDateComponents *nextMonthComponents = [[NSDateComponents alloc] init];
        nextMonthComponents.month = 1;
        NSDate *date2 = [currentCalendar dateByAddingComponents:nextMonthComponents toDate:date1 options:0];
        
        
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(workoutDate >= %@) AND (workoutDate < %@)", date1, date2];
        
        NSSortDescriptor *workoutDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutDateDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error;
        // Create and initialize the fetch results controller.
        self.allDateValuesOfSelectedMonth = (NSMutableArray *)[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
    }
}

- (void)setMonthRowText:(NSString *)monthRowText
{
    _monthRowText = monthRowText;
    
    [self executeFetch];
    self.variousUniqueFormattedDays = nil;
    self.variousUniqueFormattedDaysCount = nil;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.monthRowText) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MMMM"];
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit |           NSYearCalendarUnit fromDate:[NSDate date]];   
        
        NSDate *monthComponent = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d",[dateComponents month]]];
        int yearComponent = [dateComponents year];
        
        NSString *monthAndYear = [monthFormatter stringFromDate:monthComponent];
        monthAndYear = [monthAndYear stringByAppendingString:@" "];
        monthAndYear = [monthAndYear stringByAppendingFormat:@"%d", yearComponent];
        
        self.monthRowText = monthAndYear;
        
    }
    
    self.monthPickerView = [[MonthPickerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height*0.7, self.view.frame.size.width, self.view.frame.size.height*0.3) andContext:self.managedObjectContext];
    self.monthPickerView.dataSource = self.monthPickerView;
    self.monthPickerView.delegate = self.monthPickerView;
    self.monthPickerView.hidden = YES;
    
    [self.monthPickerView addObserver:self 
                           forKeyPath:@"selectedMonth" 
                              options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) 
                              context:NULL];
    
    [self.view addSubview:self.monthPickerView];
    
    
    [self executeFetch];
    [self.tableView reloadData];
    
    
    if ([self tableView:self.tableView numberOfRowsInSection:0] == 1 &&
        [self.monthPickerView pickerView:self.monthPickerView numberOfRowsInComponent:0] > 0){
        if (![self.monthRowText isEqualToString:[self.monthPickerView pickerView:self.monthPickerView titleForRow:0 forComponent:0]]) {            
            self.monthRowText = [self.monthPickerView pickerView:self.monthPickerView titleForRow:0 forComponent:0];
        }
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.monthPickerView.hidden = YES;
    self.monthPickerView = nil;
    self.variousUniqueFormattedDays = nil;
    self.variousUniqueFormattedDaysCount = nil;
}

#pragma mark - TableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    
    self.variousUniqueFormattedDays = [[NSMutableArray alloc] init];
    self.variousUniqueFormattedDaysCount = [[NSMutableArray alloc] init];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMMM"];
    
    for (id workoutDateDictionary in self.allDateValuesOfSelectedMonth) {
        NSDate *dateWorkoutDone = [workoutDateDictionary valueForKey:@"workoutDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *formattedDate = [dateFormatter stringFromDate:dateWorkoutDone];
        
        if (![self.variousUniqueFormattedDays containsObject:formattedDate]) {
            [self.variousUniqueFormattedDays addObject:formattedDate];
            [self.variousUniqueFormattedDaysCount addObject:[NSNumber numberWithInt:1]];
        }
        else {
            NSUInteger index = [self.variousUniqueFormattedDays indexOfObject:formattedDate];
            int currentCount = [[self.variousUniqueFormattedDaysCount objectAtIndex:index] intValue];
            [self.variousUniqueFormattedDaysCount removeObjectAtIndex:index];
            [self.variousUniqueFormattedDaysCount insertObject:[NSNumber numberWithInt:(currentCount + 1)] atIndex:index];
        }
    }
    
    return self.variousUniqueFormattedDays.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *CellIdentifier = @"Workouts Done on Date Cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    
    // Configure the cell...
    
    if (indexPath.row == 0) {
        UILabel *monthNameRow = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        monthNameRow.text = self.monthRowText; 
        monthNameRow.enabled = NO;
        monthNameRow.adjustsFontSizeToFitWidth = YES;
        monthNameRow.font = [UIFont systemFontOfSize:25.0];
        monthNameRow.textAlignment = UITextAlignmentCenter;
        monthNameRow.tag = 1;
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:monthNameRow];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    else {
        cell.textLabel.text = [self.variousUniqueFormattedDays objectAtIndex:(indexPath.row-1)];
        
        int workoutsCountForCell = [[self.variousUniqueFormattedDaysCount objectAtIndex:(indexPath.row-1)] intValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d workouts", workoutsCountForCell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.monthPickerView.hidden) {
            self.monthPickerView.hidden = NO;
            [self.monthPickerView ifAvailableShowOption:self.monthRowText];
        }
        else {
            self.monthPickerView.hidden = YES;
        }
    }
    else {
        [self performSegueWithIdentifier:@"Show Selected Day Details" sender:self];
    }
}

#pragma mark - KVO methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedMonth"] && [object isKindOfClass:[MonthPickerView class]]) {
        self.monthRowText = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

#pragma mark - prepareForSegue:
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   
    if ([segue.identifier isEqualToString:@"Show Selected Day Details"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setContext:)]) {
            [segue.destinationViewController performSelector:@selector(setContext:) withObject:self.managedObjectContext];
            
            for (id workoutDateDictionary in self.allDateValuesOfSelectedMonth) {
                NSDate *dateWorkoutDone = [workoutDateDictionary valueForKey:@"workoutDate"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                NSString *formattedDate = [dateFormatter stringFromDate:dateWorkoutDone];
                
                int selectedRow = self.tableView.indexPathForSelectedRow.row;
                if ([formattedDate isEqualToString:[self.variousUniqueFormattedDays objectAtIndex:(selectedRow-1)]]) {
                    [segue.destinationViewController performSelector:@selector(setDate:) withObject:dateWorkoutDone];
                    break;
                }
            }
        }
    }
}

@end