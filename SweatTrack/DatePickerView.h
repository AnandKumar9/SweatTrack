//
//  DatePickerView.h
//  Kasrat
//
//  Created by Anand Kumar on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIDatePicker

@property (nonatomic, strong) NSString *selectedDate;

- (void)ifAvailableShowOption:(NSString *)possibleOption;

@end
