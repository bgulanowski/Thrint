#import "Feature.h"

#import "Product.h"
#import "Component.h"
#import "Developer.h"
#import "Team.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>


@implementation Feature

+ (NSManagedObject *)insertObject {
    
    Feature *feature = (Feature *)[super insertObject];
    
    feature.name = @"New Feature";
    feature.details = @"(Describe your new feature…)";
    
    return feature;
}

+ (Feature *)insertFeature {
    return  (Feature *)[self insertObject];
}

- (NSString *)listString {
    return [NSString stringWithFormat:@"%@ (%@)", self.name, self.owner.name];
}

- (NSString *)displayDescription {
    return self.details;
}

@end
