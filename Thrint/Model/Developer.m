#import "Developer.h"

#import "Role.h"
#import "Team.h"

#import "NSManagedObject+BAAdditions.h"
#import "NSManagedObject+ViewAdditions.h"

@implementation Developer

+ (NSManagedObject *)insertObject {
    
    Developer *developer = (Developer *)[super insertObject];
    
    developer.name = @"New Developer";
    developer.joinDate = [NSDate date];
    
    return developer;
}

+ (Developer *)insertDeveloper {
    return (Developer *)[self insertObject];
}

- (NSString *)displayDescription {
    
    Role *role = [self.roles anyObject];
    NSString *roleString;
    
    if(role)
        roleString = [NSString stringWithFormat:@"%@ on %@", role.name, role.team.name];
    else
        roleString = @"unassigned";
        
    return [NSString stringWithFormat:@"%@ (%@)", self.name, roleString];
}

@end
