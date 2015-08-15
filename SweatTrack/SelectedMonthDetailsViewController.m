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

@property (nonatomic, strong) NSMutableArray *variousUniqueDays;
@property (nonatomic, strong) NSMutableArray *workoutsDoneOnVariousUniqueDays;

@end

@implementation SelectedMonthDetailsViewController

@synthesize monthRowText = _monthRowText;
@synthesize monthPickerView = _monthPickerView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchResults = _fetchResults;
@synthesize variousUniqueDays = _variousUniqueDays;
@synthesize workoutsDoneOnVariousUniqueDays = workoutsDoneOnVariousUniqueDays;

- (void)executeFetch
{
    if (self.monthRowText) {
        // Create and configure a fetch request with the Book entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutsDone" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Create the sort descriptors array.
        NSSortDescriptor *workoutNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutNameDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        //Form date objects as per monthRowText, so that they can be used in the predicate
        NSString *monthInMonthRowText = [self.monthRowText substringToIndex:(self.monthRowText.length - 5)];
        NSString *yearInMonthRowText = [self.monthRowText substringFromIndex:(self.monthRowText.length - 4)];
        
        NSDateFormatter* formatterForGettingMonthNumber = [[NSDateFormatter alloc] init];
        [formatterForGettingMonthNumber setDateFormat:@"MMMM"];
        NSDate *dateForGettingMonthNumber = [formatterForGettingMonthNumber dateFromString:monthInMonthRowText];
        NSDateComponents *monthNumber = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:dateForGettingMonthNumber];
        
//        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
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
        
        NSError *error = nil;
        self.fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
}

- (void)setMonthRowText:(NSString *)monthRowText
{
    _monthRowText = monthRowText;
    
    [self executeFetch];
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
        
        int lastRowIndexInPickerView = [self.monthPickerView pickerView:self.monthPickerView numberOfRowsInComponent:0] - 1;
        if (![self.monthRowText isEqualToString:[self.monthPickerView pickerView:self.monthPickerView titleForRow:lastRowIndexInPickerView forComponent:0]]) {            
            self.monthRowText = [self.monthPickerView pickerView:self.monthPickerView titleForRow:lastRowIndexInPickerView forComponent:0];
        }
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.monthPickerView.hidden = YES;
    self.monthPickerView = nil;
}

#pragma mark - TableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    self.variousUniqueDays = [[NSMutableArray alloc] init];
    self.workoutsDoneOnVariousUniqueDays = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.fetchResults.count; i = i + 1) {
        WorkoutsDone *workoutDone = [self.fetchResults objectAtIndex:i];
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:workoutDone.workoutDate];   
        
        NSString * dayComponent = [NSString stringWithFormat:@"%d",[dateComponents day]];
        
        if (![self.variousUniqueDays containsObject:dayComponent]) {
            [self.variousUniqueDays addObject:dayComponent];
        }
    }

    return self.variousUniqueDays.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Workouts Done on Date Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
        int dayForCell = [[self.variousUniqueDays objectAtIndex:(indexPath.row-1)] intValue];
        
        NSMutableArray *workoutsDoneOnDayForTheCell = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.fetchResults.count; i = i + 1) {
            WorkoutsDone *workoutDone = [self.fetchResults objectAtIndex:i];
            NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:workoutDone.workoutDate];   

            int dayComponent = [dateComponents day];
            if (dayForCell == dayComponent) {
                [workoutsDoneOnDayForTheCell addObject:workoutDone];
            }
        }
        
        [self.workoutsDoneOnVariousUniqueDays addObject:workoutsDoneOnDayForTheCell];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d work outs", workoutsDoneOnDayForTheCell.count];
        
        
        
        NSDate *dateForTheCell = [[workoutsDoneOnDayForTheCell objectAtIndex:0] valueForKey:@"workoutDate"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        cell.textLabel.text = [dateFormatter stringFromDate:dateForTheCell];
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
            NSDate *selectedDate = [[[self.workoutsDoneOnVariousUniqueDays objectAtIndex:(self.tableView.indexPathForSelectedRow.row-1)]
                                     objectAtIndex:0] valueForKey:@"workoutDate"]; 
            
            [segue.destinationViewController performSelector:@selector(setDate:) withObject:selectedDate];
        }
    }
}

@end