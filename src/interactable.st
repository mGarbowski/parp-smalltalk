
"The base type for items and containers, even though it does not extend the GameObject, it is 
conceptually a different entity."
GameObject subclass: Interactable []

"Interactables that can be picked up by the player"
Interactable subclass: Item []


"Interactables that can contain items and support unlocking using certain items/after meeting certain conditions"
Interactable subclass: Container [
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
    
    getDescription [
        isLocked ifTrue: [^#('It is locked, perhaps you need some key?')]
        ifFalse: [^description].
    ]
    
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
