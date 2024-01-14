GameObject subclass: Room [
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

    hasPath: direction [
        ^(directions includesKey: direction)
    ]

    getContainers [
        |containers|
        containers := OrderedCollection new.
        self getInteractables do: [:i | 
            (i isMemberOf: Container) ifTrue: [containers add: i].
       ]. 
       ^containers.
    ]

    getContainerItems [
        |containerItems|
        containerItems := OrderedCollection new.
        (self getContainers) do: [ :c | 
            containerItems addAll: (c getItems).
        ].
        ^containerItems.
    ]

    canGoInDirection: direction [
        |path|
        (self hasPath: direction) ifFalse: [^false].
        path := directions at: direction.
        ^path getIsLocked not
    ]

    listItems [
        |lines|
        lines := OrderedCollection new.
        lines add: 'Interactable items:'.
        self getItems do: [ :i | lines add: i getName].
        ^lines
    ]

    getAllInteractables [
        |all|
        all := OrderedCollection new.
        all addAll: self getItems.
        all addAll: self getInteractables.
        all addAll: self getContainerItems.
        ^all
    ]

    removeItem: item [
        self getItems identityRemove: item
    ]

    getItemByName: itemName [
        |foundItem|
        foundItem := nil.
        self getAllInteractables do: [ :i |
            (i getName = itemName) ifTrue: [foundItem := i].
        ].
        ^foundItem.
    ]
]

Object subclass: Rooms [
    |lockerRoom securityRoom corridorOne corridorTwo generatorRoom exitRoom experimentRoom computerRoom ventilationShaft|

    Rooms class >> new [
        |r|
        r := super new.
        ^r
    ]

    getLockerRoom [^lockerRoom]
    setLockerRoom: r [lockerRoom := r]
    getSecurityRoom [^securityRoom]
    setSecurityRoom: r [securityRoom := r]
    getCorridorOne [^corridorOne]
    setCorridorOne: r [corridorOne := r]
    getCorridorTwo [^corridorTwo]
    setCorridorTwo: r [corridorTwo := r]
    getGeneratorRoom [^generatorRoom]
    setGeneratorRoom: r [generatorRoom := r]
    getExitRoom [^exitRoom]
    setExitRoom: r [exitRoom := r]
    getExperimentRoom [^experimentRoom]
    setExperimentRoom: r [experimentRoom := r]
    getComputerRoom [^computerRoom]
    setComputerRoom: r [computerRoom := r]
    getVentilationShaft [^ventilationShaft]
    setVentilationShaft: r [ventilationShaft := r]

]

"Factory for creating all room objects
todo populate rooms with items and interactables
"
Object subclass: RoomFactory [

    "Factory methods for creating rooms populated with items and interactables"

    RoomFactory class >> lockerRoom [
        |r|
        r := Room
            name: 'locker room'
            description: #(
                 'The locker room is dimly lit, with a faint hum of machinery in the air. Rows'
                 'of lockers fill the space, closed and orderly. However, one locker catches'
                 'your eye - slightly open, a hint of something inside. It seems like the owner'
                 'forgot to lock it properly'
                 'To the north, a heavy metal door labeled "Security" and a modern keypad next to it present themselves to you'
                 'To the east, you see another door with no labels as to where it leads'
            )
            hint: #('You can interact with the locker, go north or go east, inspect the keypad next to security doors to find out more.').

        r getItems add: InteractableFactory lockerRoomKey.
        r getInteractables add: InteractableFactory locker.
        r getInteractables add: InteractableFactory coat.
        r getInteractables add: InteractableFactory compartment.
        ^r
    ]

    RoomFactory class >> securityRoom [
        |r|
        r := Room
            name: 'security room'
            description: #(
                'The security room is dimly lit, the soft glow of monitors casting a blue hue on'
                'the walls. The air is cool, and the hum of electronic equipment fills the room.'
                'Rows of monitors display surveillance footage, capturing glimpses of different'
                'sections of the lab. The power control switches on the central console beckon,'
                'suggesting a pivotal role in the functionality of the facility.'
            )
            hint: #('You can interact with the control panel or go south').
        r getInteractables add: InteractableFactory keypad.
        ^r
    ]

    RoomFactory class >> corridorOne [
        |r|
        r := Room new.
        r setName: 'corridor one'.
        r setDescription: #(
            'You find yourself in a dimly lit corridor, the ambient light casting faint shadows.'
            'Directly ahead to the north, a door labeled "Generator Room" stands prominently.'
            'Looking to the south, the corridor stretches away, its destination obscured by the dim lighting,'
            'The western door leads to the locker room.'
        ).
        r setHint: #('You can go west, north, south').
        ^r
    ]

    RoomFactory class >> corridorTwo [
        |r|
        r := Room
            name: 'corridor two'
            description: #(
                'You are further down the corridor, to the west - entrance to the experiment chamber.'
                'The air is heavy with the weight of past scientific endeavors ...or are those toxic fumes?'
                'To the east - a locked door guards more secrets.'
            )
            hint: #('You can go north, east, west').
        ^r
    ]

    RoomFactory class >> generatorRoom [
        |r|
        r := Room
            name: 'generator room'
            description: #(
                'As you explore the generator room, the dormant generator at the center stands in'
                'stark contrast to the adjacent ventilation shaft. The idle turbines offer a'
                'glimpse into the halted functionality of the lab''s power source.'
                'The ventilation shaft on the eastern wall,'
                'though vibrating with a faint breeze, seems large enough for someone to fit through.'
            )
            hint: #('You can interact with generator, vent or go south').
        r getInteractables add: InteractableFactory generator.
        r getInteractables add: InteractableFactory ventEntrance.
        ^r
    ]

    RoomFactory class >> exitRoom [
        |r|
        r := Room
            name: 'exit room'
            description: #(
                'As you''re crawling out of the ventilation shaft, you notice an elevator.'
                'Finally, a way out of this maze! You notice something shiny on the floor - it''s a power cell!'
            )
            hint: #('You can interact with vent and elevator').
        r getInteractables add: InteractableFactory elevator.
        r getItems add: InteractableFactory powerCell.
        ^r
    ]

    RoomFactory class >> experimentRoom [
        |r|
        r := Room
            name: 'experiment room'
            description: #(
                'You are in the experiment room. The floor is covered in a sticky, toxic sludge.'
                'On the other side of the room, you see a small metal tool chest.'
                'If you were only able to go through the sludge,'
                'you could see what''s inside. The door was blown open by the failure of the experiment, it seems.'
                'The broken door is laying next to where you stand.'
            )
            hint: #('You need to acquire some protective gear to walk through the toxic sludge.').
        r getInteractables add: InteractableFactory toolChest.
        r getInteractables add: InteractableFactory brokenDoor.
        ^r
    ]

    RoomFactory class >> computerRoom [
        |r|
        r := Room
            name: 'computer room'
            description: #(
                'As you step into the room bathed in soft light, you notice a solitary desk at'
                'its center. On the desk rests a computer, its screen silent and'
                'dark. The absence of the usual hum of electronic activity adds an eerie calm'
                'to the room, leaving the space seemingly dormant.'
                'To the west there is a door locked from this side.'
            )
            hint: #('You can interact with: computer, desk, vent or try the door to the west').
        r getInteractables add: InteractableFactory computer.
        r getInteractables add: InteractableFactory ventEntrance.
        r getInteractables add: InteractableFactory desk.
        ^r
    ]

    RoomFactory class >> ventilationShaft [
        |r|
        r := Room
            name: 'ventilation shaft'
            description: #('You are in the vent shaft. You can proceed east, south or north')
            hint: #('You can proceed east, south or north').
        ^r
    ]


    "Return Rooms object populated with all rooms and with all paths added"
    RoomFactory class >> getRooms [
        |rooms p t k|
        rooms := Rooms new.
        rooms setLockerRoom: RoomFactory lockerRoom.
        rooms setSecurityRoom: RoomFactory securityRoom.
        rooms setCorridorOne: RoomFactory corridorOne.
        rooms setCorridorTwo: RoomFactory corridorTwo.
        rooms setGeneratorRoom: RoomFactory generatorRoom.
        rooms setExitRoom: RoomFactory exitRoom.
        rooms setExperimentRoom: RoomFactory experimentRoom.
        rooms setComputerRoom: RoomFactory computerRoom.
        rooms setVentilationShaft: RoomFactory ventilationShaft.

        "add paths"

        "locker room"
        p := Path new.
        p setToRoom: rooms getCorridorOne.
        p setIsLocked: true.
        p setOpenedBy: InteractableFactory lockerRoomKey.
        rooms getLockerRoom getDirections at: 'east' put: p.

        p := Path new.
        p setToRoom: rooms getSecurityRoom.
        p setIsLocked: true.
        rooms getLockerRoom getDirections at: 'north' put: p.

        "security room"
        p := Path new.
        p setToRoom: rooms getLockerRoom.
        p setIsLocked: false.
        rooms getSecurityRoom getDirections at: 'south' put: p.

        "corridor one"
        p := Path new.
        p setToRoom: rooms getLockerRoom.
        p setIsLocked: false.
        rooms getCorridorOne getDirections at: 'west' put: p.

        p := Path new.
        p setToRoom: rooms getGeneratorRoom.
        p setIsLocked: false.
        rooms getCorridorOne getDirections at: 'north' put: p.

        p := Path new.
        p setToRoom: rooms getCorridorTwo.
        p setIsLocked: false.
        rooms getCorridorOne getDirections at: 'south' put: p.

        "corridor two"
        p := Path new.
        p setToRoom: rooms getCorridorOne.
        p setIsLocked: false.
        rooms getCorridorTwo getDirections at: 'north' put: p.

        p := Path new.
        p setToRoom: rooms getExperimentRoom.
        p setIsLocked: false.
        rooms getCorridorTwo getDirections at: 'west' put: p.

        p := Path new.
        p setToRoom: rooms getComputerRoom.
        p setIsLocked: true.
        rooms getCorridorTwo getDirections at: 'east' put: p.

        "generator room"
        p := Path new.
        p setToRoom: rooms getCorridorOne.
        p setIsLocked: false.
        rooms getGeneratorRoom getDirections at: 'south' put: p.

        p := Path new.
        p setToRoom: rooms getVentilationShaft.
        p setIsLocked: true.
        p setOpenedBy: InteractableFactory crowbar.
        rooms getGeneratorRoom getDirections at: 'east' put: p.

        "experiment room"
        p := Path new.
        p setToRoom: rooms getCorridorTwo.
        p setIsLocked: false.
        rooms getExperimentRoom getDirections at: 'east' put: p.

        "computer room"
        p := Path new.
        p setToRoom: rooms getCorridorTwo.
        p setIsLocked: true.
        rooms getComputerRoom getDirections at: 'west' put: p.

        "ventilation shaft"
        p := Path new.
        p setToRoom: rooms getExitRoom.
        p setIsLocked: false.
        rooms getVentilationShaft getDirections at: 'east' put: p.

        p := Path new.
        p setToRoom: rooms getGeneratorRoom.
        p setIsLocked: false.
        rooms getVentilationShaft getDirections at: 'west' put: p.

        p := Path new.
        p setToRoom: rooms getComputerRoom.
        p setIsLocked: false.
        rooms getVentilationShaft getDirections at: 'south' put: p.

        ^rooms
    ]
]
