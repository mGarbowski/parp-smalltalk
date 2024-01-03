Interactable subclass: Room [
    | name description hint items interactables directions |

    Room class >> new [
        |r|
        r := super new.
        r setItems: OrderedCollection new.
        r setInteractables: OrderedCollection new.
        r setDirections: Dictionary new.
        ^r
    ]

    Room class >> name: aName description: aDescription hint: aHint [
        |r|
        r := super new.
        r setName: aName.
        r setDescription: aDescription.
        r setHint: aHint.
        r setItems: OrderedCollection new.
        r setInteractables: OrderedCollection new.
        r setDirections: Dictionary new.
        ^r
    ]

    "Getters and setters"
    getItems [^ items]
    setItems: someItems [items := someItems]

    getInteractables [^ interactables]
    setInteractables: someInteractables [interactables := someInteractables]

    getDirections [^ directions]
    setDirections: someDirections [directions := someDirections]
]

"Factory for creating all room objects"
Object subclass: RoomFactory [

    "Factory methods for creating rooms populated with items and interactables"

    RoomFactory class >> lockerRoom [
        |r|
        r := Room
            name: 'locker room'
            description: 'locker room description'
            hint: 'locker room hint'.
        r getItems add: 'key'.
        ^r
    ]

    RoomFactory class >> corridorOne [
        |r|
        r := Room new.
        r setName: 'corridor one'.
        r setDescription: 'corridor description'.
        r setHint: 'corridor hint'.
        ^r
    ]

    "Return OrderedCollection of all rooms connected with each other"
    RoomFactory class >> rooms [
        |lockerRoom corridorOne path1 path2 all|
        lockerRoom := RoomFactory lockerRoom.
        corridorOne := RoomFactory corridorOne.

        path1 := Path new.
        path1 setToRoom: corridorOne.
        path1 setIsLocked: false.
        lockerRoom getDirections at: 'east' put: path1.

        path2 := Path new.
        path2 setToRoom: lockerRoom.
        path2 setIsLocked: false.
        corridorOne getDirections at: 'west' put: path2.

        all := OrderedCollection new.
        all add: lockerRoom.
        all add: corridorOne.

        ^all.
    ]
]