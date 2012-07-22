#import "Milestone.h"

#import "Component.h"

#import "NSManagedObject+ViewAdditions.h"
#import "NSManagedObject+BAAdditions.h"


@implementation Milestone

+ (NSManagedObject *)insertObject {
    
    Milestone *milestone = (Milestone *)[super insertObject];
    
    milestone.version = @"1.0.0a";
    milestone.dueDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*265];
    
    return milestone;
}

+ (Milestone *)insertMilestone {
    return (Milestone *)[self insertObject];
}

- (NSString *)displayDescription {
    
    static NSDateFormatter *df;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterLongStyle;
        df.timeStyle = NSDateFormatterNoStyle;
    });
    
    NSString *featuresString = [[[self valueForKeyPath:@"features.name"] allObjects] componentsJoinedByString:@", "];
    
    featuresString = [featuresString length] ? [@"Features: " stringByAppendingString:featuresString] : @"";
    
    NSDate *dueDate = self.dueDate;
    
    NSString *dueString = dueDate ? [@"Due: " stringByAppendingString:[df stringFromDate:self.dueDate]] : @"";
    
    NSSet *comps = [self valueForKeyPath:@"features.component.name"];
    NSString *compsString = [comps count] ? [[comps allObjects] componentsJoinedByString:@", "] : @"";
    
    return [NSString stringWithFormat:@"%@ %@: %@. %@", compsString, self.version, dueString, featuresString];
}

@end
