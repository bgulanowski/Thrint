#import "Role.h"

#import "Team.h"
#import "Developer.h"

#import "NSManagedObject+BAAdditions.h"
#import "NSManagedObject+ViewAdditions.h"


@implementation Role

+ (NSManagedObject *)insertObject {
    
    Role *role = (Role *)[super insertObject];
    
    role.name = @"New Role";
    
    return role;
}

+ (Role *)insertRole {
    return (Role *)[self insertObject];
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
