#import "ProductNote.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"


@implementation ProductNote

+ (NSManagedObject *)insertObject {
    
    ProductNote *note = (ProductNote *)[super insertObject];
    
    note.title = @"New Note";
    note.details = @"(Add a description…)";
    
    return note;
}

+ (ProductNote *)insertProductNote {
    return (ProductNote *)[self insertObject];
}

-(NSString *)listString {
    return [NSString stringWithFormat:@"%@", self.title];
}

- (NSString *)displaySubtitle {
    NSString *content = self.details;
    
    if([content length] > 100)
        return [NSString stringWithFormat:@"%@…", [content substringToIndex:100]];
    return content;
}

@end
