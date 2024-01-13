Object subclass: Interactable [
    | name description hint |

    Interactable class >> new [
        ^super new.
    ]

    Interactable class >> name: aName description: aDescription hint: aHint [
        |i|
        i := super new.
        i setName: aName.
        i setDescription: aDescription.
        i setHint: aHint.
        ^i
    ]

    getDescription [^ description]
    setDescription: value [description := value]

    getName [^ name]
    setName: value [name := value]

    getHint [^ hint]
    setHint: aHint [hint := aHint]
]

Interactable subclass: Item [
    "Interactables that can be picked up by the player"
]

Interactable subclass: Container [
    "Interactables that can contain items"
    | itemsInside isLocked openedBy |
    Container class >> name: aName description: aDescription hint: aHint itemsInside: someItems locked: isLocked openedBy: aKey [
        |c itemCollection|
        c := super name: aName description: aDescription hint: aHint.
        "constructor uses arrays because they're simpler to initalize, we need a collection"
        itemCollection := OrderedCollection new.
        itemCollection addAll: someItems.
        
        c setItems: itemCollection.
        c setIsLocked: isLocked.
        c setOpenedBy: aKey.
        ^c
    ]

    "Getters and setters"
    getOpenedBy [^openedBy]
    setOpenedBy: anObject [
        openedBy := anObject
        ]
    getIsLocked [^isLocked]
    setIsLocked: aBool [
        isLocked := aBool
        ]
    getItems [
        isLocked ifTrue: [^OrderedCollection new].
        ^itemsInside
        ]
    setItems: someItems [itemsInside := someItems]
    
    "Content management"
    removeItem: i [itemsInside identityRemove: i]

    findItem: itemName [
        |i|
        i := nil.
        isLocked ifTrue: [^i]. "if locked, returns nil"

        itemsInside do: [:item |
        (item getName = itemName) ifTrue: [
            i := item.
            ].
        ].
        ^i.
    ]

    containsItem: itemName [
        ^(self findItem: itemName /= nil).
    ]
]
