#import "Role.h"

#import "Team.h"
#import "Developer.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"


@implementation Role

- (void)awakeFromInsert {
    self.name = @"New Role";
}

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ (%@)", self.name, [[self.developers anyObject] name] ?: @"unassigned"];
}

- (NSString *)displayTitle {
    
    NSArray *names = [[self.developers valueForKeyPath:@"name"] allObjects];
    
    names = [names count] > 2 ? [names subarrayWithRange:NSMakeRange(0, 2)] : names;
    
    NSString *devNames = [names count] ? [names componentsJoinedByString:@", "] : @"unfilled";
    
    return [NSString stringWithFormat:@"%@ (%@)", self.name, devNames];
}

@end
