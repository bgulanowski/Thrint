#import "Feature.h"

#import "Product.h"
#import "Component.h"
#import "Developer.h"
#import "Team.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>


@implementation Feature

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.name = @"New Feature";
    self.details = @"(Describe your new feature…)";
}

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ (%@)", self.name, self.owner.name];
}

- (NSString *)displayDescription {
    return self.details;
}

@end
