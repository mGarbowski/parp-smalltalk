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
    | itemsInside |
    Container class >> name: aName description: aDescription hint: aHint itemsInside: someItems [
        |c itemCollection|
        c := super name: aName description: aDescription hint: aHint.
        "constructor uses arrays because they're simpler to initalize, we need a collection"
        itemCollection := OrderedCollection new.
        itemCollection addAll: someItems.
        c setItems: itemCollection.
        ^c
    ]

    getItems [^ itemsInside]
    setItems: someItems [itemsInside := someItems]
    
    removeItem: i [itemsInside identityRemove: i]

    findItem: itemName [
        |i|
        i := nil.
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
