#import "Feature.h"

#import "Product.h"
#import "Component.h"
#import "Developer.h"
#import "Team.h"

#import "NSManagedObject+BAAdditions.h"


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

@end
