//
//  DatePickerView.m
//  Kasrat
//
//  Created by Anand Kumar on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

@synthesize selectedDate = _selectedDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.datePickerMode = UIDatePickerModeDate;
        self.maximumDate = [NSDate date];
    }
    
    return self;
}

- (void)ifAvailableShowOption:(NSDate *)possibleOption
{
    
}

@end
