#import "Milestone.h"

#import "Component.h"

#import "NSManagedObject+ViewAdditions.h"
#import <BAFoundation/NSManagedObject+BAAdditions.h>


@implementation Milestone

NSDateFormatter *df;

+ (void)initialize {
    if(self == [Milestone class]) {
        df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterLongStyle;
        df.timeStyle = NSDateFormatterNoStyle;
    }
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.version = @"1.0.0a";
    self.dueDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*365];
}

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ due %@", self.version, [df stringFromDate:self.dueDate]];
}

- (NSString *)displayDescription {
    
    NSString *featuresString = [[[self valueForKeyPath:@"features.name"] allObjects] componentsJoinedByString:@", "];
    
    featuresString = [featuresString length] ? [@"Features: " stringByAppendingString:featuresString] : @"";
    
    NSDate *dueDate = self.dueDate;
    
    NSString *dueString = dueDate ? [@"Due: " stringByAppendingString:[df stringFromDate:self.dueDate]] : @"";
    
    NSSet *comps = [self valueForKeyPath:@"features.component.name"];
    NSString *compsString = [comps count] ? [[comps allObjects] componentsJoinedByString:@", "] : @"";
    
    return [NSString stringWithFormat:@"%@ %@: %@. %@", compsString, self.version, dueString, featuresString];
}

@end
