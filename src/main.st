"The germ of a text adventure game
Marcin Szlenk 2022"

"Game class

Responsibilities:
* print/read outputs/inputs
* handle game loop
* handle 'instructions' and 'halt' commands

Collaborators:
* ..."

Object subclass: GameController [
    | isGameOver game |
    directions := #('north' 'south' 'east' 'west').

    introductionText := #(
    ''
    'As you slowly open your eyes, a throbbing ache reverberates through your head'
    'and the acrid scent of chemicals fills the air. Disoriented, you find yourself lying'
    'on a cold metal floor in what appears to be a dimly lit locker room. The flickering'
    'light above casts unsettling shadows on the lockers that surround you.'
    ''
    'A soft hum of emergency alarms pulsates through the room, and the distant echoes'
    'of chaotic commotion resonate in the air. Struggling to your feet, you notice a faint'
    'glow emanating from a small screen hanged on the wall near the entrance.'
    'The screen flickers to life, displaying a message in stark white letters: '
    ''
    '"Dr S., the experiment has failed. Containment breach detected. Evacuation'
    'protocol initiated. Escape the facility before critical systems fail. Beware of'
    'anomalies. Your survival is paramount. Time is of the essence.'
    ''
    'With a sense of urgency, you realize that your fate is entwined with the impending'
    'collapse of the lab. The clock is ticking, and the path to freedom is uncertain.'
    ).

    instructionsText := #(
        'Available commands are:'
        ''
        'instructions  -- to see these instructions'
        'go DIR        -- to go in DIR direction'
        'unlock DIR    -- to unlock doors in direction DIR'
        'look          -- to look around the room you are in'
        'take X        -- to pick up X and store it in your inventory'
        'inventory     -- to see your inventory'
        'hint here     -- to see a hint about the room you are in'
        'hint X        -- to see a hint about X'
        'quit          -- to end the game and quit'
        ''
    ).
 
    GameController class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        game := Game new.
    ]

    getGame [^game]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printIntroduction [
       self printLines: introductionText.
    ]

    printInstructions [
        self printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    "Run the game."
    run [
        | cmd isUnknown |

        self printIntroduction.
        self printInstructions.
        self handleLook.

        "Game loop."
        [isGameOver] whileFalse: [

            isUnknown := true.
            cmd := self readCommand.

            cmd = 'instructions' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            (cmd startsWith: 'go') ifTrue: [
                isUnknown := false.
                self handleGo: cmd
            ].

            (cmd startsWith: 'look') ifTrue: [
                self handleLook.
                isUnknown := false
            ].
            
            (cmd startsWith: 'inspect ') ifTrue: [
                isUnknown := false.
                self handleInspect: cmd
            ].

            (cmd startsWith: 'hint ') ifTrue: [
                isUnknown := false.
                cmd = 'hint here'
                    ifTrue: [self handleHintHere]
                    ifFalse: [self handleHint: cmd]
            ].

            (cmd startsWith: 'take ') ifTrue: [
                isUnknown := false.
                self handleTake: cmd
            ].

            cmd = 'inventory' ifTrue: [
                isUnknown := false.
                self handleInventory
            ].

            (cmd startsWith: 'enter pin ') ifTrue: [
                isUnknown := false.
                self handleEnterPin: cmd
            ].

            (cmd startsWith: 'unlock ') ifTrue: [
                isUnknown := false.
                self handleUnlock: cmd
            ].

            (cmd startsWith: 'power on') ifTrue: [
                isUnknown := false.
                self handlePowerOn: cmd.
            ].

            cmd = 'quit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].
                
            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ]
        ]
    ]


    handleLook [
        self printLines: self getGame getCurrentRoom getDescription
    ]

    handleHintHere [
        |room|
        room := self getGame getCurrentRoom.
        self printLines: room getHint.
        self printLines: room listItems
    ]

    "todo also handle items in the inventory"
    handleHint: cmd [
        |iName interactables found obj|

        iName := cmd copyFrom: 6 to: cmd size.
        interactables := self getGame getCurrentRoom getAllInteractables.
        found := false.

        interactables do: [ :i |
            i getName = iName ifTrue: [
                found := true.
                obj := i.
            ]
        ].

        found
            ifTrue: [Transcript show: obj getHint; cr]
            ifFalse: [Transcript show: 'I dont see that here...'; cr]
    ]

    handleGo: cmd [
        |direction path currRoom nextRoom|
        (cmd size < 4) ifTrue: [
            self printLines: #('Specify direction where you want to go').
            ^nil
        ].

        direction := cmd copyFrom: 4 to: cmd size.
        (directions includes: direction) ifFalse: [
            self printLines: #(
                'Invalid direction'
                'You can go north, south, east or west'
            ).
            ^nil
        ].

        currRoom := self getGame getCurrentRoom.
        (currRoom hasPath: direction) ifFalse: [
            self printLines: #('You cannot go in this direction from here').
            ^nil
        ].

        (currRoom canGoInDirection: direction) ifFalse: [
            self printLines: #('This path is locked').
            ^nil
        ].

        path := currRoom getDirections at: direction.
        nextRoom := path getToRoom.
        self getGame setCurrentRoom: nextRoom.
        self handleLook
    ]

    handleTake: cmd [
        |itemName roomItems taken containerItem|
        itemName := cmd copyFrom: 6 to: cmd size.
        roomItems := self getGame getCurrentRoom getItems.
        taken := false.
        containerItem := nil.

        roomItems do: [:item |
            item getName = itemName ifTrue: [
                taken := true.
                self getGame addItem: item.
                self getGame getCurrentRoom removeItem: item.
                ]
        ].

        "iterate through containers and remove if found"
        self getGame getCurrentRoom getContainers do: [:c|
            containerItem := c findItem: itemName.
            (containerItem = nil) ifFalse: [
                taken := true.
                self getGame addItem: containerItem.
                c removeItem: containerItem.
                ].
            ].

        taken ifTrue: [Transcript show: 'Ok'; cr] ifFalse: [Transcript show: 'I don''t see that here'; cr]
    ]

    handleInspect: cmd [
        |itemName validItem roomInspectables allInspectables|
        validItem := false.
        itemName := cmd copyFrom: 9.
        allInspectables := self getGame getCurrentRoom getAllInteractables.
        allInspectables addAll: self getGame getInventoryItems.


        (self trySpecialInspect: itemName) ifTrue: [^nil.].

        allInspectables do: [ :i|
            (itemName = i getName) ifTrue: [
                self printLines: i getDescription.
                validItem := true.
                ].
        ].

        validItem ifFalse: [
            Transcript show: 'I don''t see that here.'; nl.
        ].
        ^nil.
    ]


    trySpecialInspect: itemName [
        "Inspecting the coat and broken door yields an item,
        but just once. These need to be handled separately."
        "coat case"
        | currentRoomName g specialItem inspected holdingCoat |
        g := self getGame.
        inspected := false.
        currentRoomName := g getCurrentRoom getName.

        (itemName = InteractableFactory coat getName & currentRoomName = RoomFactory lockerRoom getName) ifTrue: [
            g getCoatKeyTaken ifFalse: [
                inspected := true.
                "Modify the inventory and gamestate"
                g addItem: InteractableFactory lockerRoomKey.
                g setCoatKeyTaken: true.
                "Print and set new description"
                specialItem := g getCurrentRoom getItemByName: InteractableFactory coat getName.
                self printLines: specialItem getDescription.
                specialItem setDescription: DescriptionFactory coatKeyTaken.
            ] .
        ].

        "broken door case"
        (itemName = InteractableFactory brokenDoor getName & currentRoomName = RoomFactory experimentRoom getName) ifTrue: [
            g getBrokenDoorKeyTaken ifFalse: [
                inspected := true.
                "Modify the inventory and gamestate"
                g addItem: InteractableFactory smallKey.
                g setBrokenDoorKeyTaken: true.
                "Printe and set new description"
                specialItem := g getCurrentRoom getItemByName: InteractableFactory brokenDoor getName.
                self printLines: specialItem getDescription.
                specialItem setDescription: DescriptionFactory brokenDoorKeyTaken.
            ].
        ].
        ^inspected.
    ]

    handlePutOn: cmd [
        | query toolChest |
        query := cmd copyFrom: 8.
        (query = InteractableFactory labShoes getName) ifTrue: [
            (self getGame getLabShoesOn) ifTrue: [
                Transcript show: 'You''ve already put them on'; cr.
                ^nil.
                ].
            (self getGame inventoryContains: InteractableFactory labShoes getName) ifTrue: [
                "unlock the tool chest and change its description"
                toolChest := self getGame getAllRooms getExperimentRoom getItemByName: InteractableFactory toolChest getName.
                self getGame setLabShoesOn: true.
                toolChest setIsLocked: false.
                toolChest setDescription: DescriptionFactory toolChestWearingShoes.
                Transcript show: 'You put the shoes on. They feel solid and heavy.'.
            ]
            ifFalse:[Transcript show: 'You need to acquire them first.'; cr].
        ]
        ifFalse: [Transcript show: 'Can''t put this on.'; cr].
    ]


    handleInventory [
        self printLines: self getGame listInventory
    ]

    handlePowerOn: cmd [
        | query |
        query := cmd copyFrom: 10.

        "Check if the player is trying to power on the generator"
        (query = (InteractableFactory generator getName)) ifTrue: [
            self tryPowerOnGenerator.
            ^nil.
        ].

        "Check if the player is trying to power on the elevator"
        (query = (InteractableFactory elevator getName)) ifTrue: [
            self tryPowerOnElevator.
            ^nil.
        ].

        Transcript show: 'Can''t power this on.'; cr.
        ^nil.
    ]

    tryPowerOnGenerator [
        |generator cellCount|
        generator := self getGame getAllRooms getGeneratorRoom getItemByName: InteractableFactory generator getName.

        "already on"
        (self getGame getGeneratorOn) ifTrue: [
            Transcript show: 'The air vibrates with renewed energy, and the machinery''s gentle rumble echoes through the entire lab.'; cr.
            ^nil.
        ].

        "no power cells in equipment"
        (self getGame inventoryContains: InteractableFactory powerCell getName) ifFalse: [
            Transcript show: 'Power remains elusive without the necessary cells. Find and install them to awaken this dormant machine.'; cr.
            ^nil.
        ].

        "there is a power cell entry, check how many cells"
        cellCount := (self getGame getEntryOrNil: InteractableFactory powerCell getName) getCount.

        "enough cells"
        cellCount = 2 ifTrue: [
            self printLines: #('With a satisfying click, you slot the power cells into place.'
                    'The generator springs to life with a reassuring hum. Lights flicker on, flooding the room with a steady glow.'
                    'The air vibrates with renewed energy, and the machinery''s gentle rumble signals success, powering up the entire lab.').
            self getGame setGeneratorOn: true.
            generator setDescription: DescriptionFactory generatorOn.
        ]

        "not enough cells"
        ifFalse: [
            Transcript show: 'Power remains elusive without the necessary cells. Find and install them to awaken this dormant machine.'; cr.
        ]
    ]

    tryPowerOnElevator [
        | elevator securityRoomMsg |

        elevator := self getGame getAllRooms getExitRoom getItemByName: InteractableFactory elevator getName.
        securityRoomMsg := 'You hear an unpleasant <buzz>, looks like the backup power supply system is not enough to power the elevator. It needs more juice!'.

        "Check if the player is in the Security Room"
        (self getGame getCurrentRoom getName) = (RoomFactory securityRoom getName) ifTrue: [
            
            "Check if the elevator is already powered"
            (self getGame getElevatorOn) ifTrue: [
                Transcript show: 'It is already powered, it really won''t work any better if you spam this button...'; cr.
                ^nil.
            ].

            "Check if the generator is off"
            (self getGame getGeneratorOn) ifFalse: [
                Transcript show: securityRoomMsg; cr.
                ^nil.
            ].

            "Power on the elevator"
            Transcript show: 'You hear a satisfying <click>. The elevator powers on, ready to take you to new heights!'; cr.
            self getGame setElevatorOn: true.
            elevator setDescription: DescriptionFactory elevatorOn.

        ] ifFalse: [
            Transcript show: 'How?'; cr.
        ].
    ]

    handleEnterPin: cmd [
        |pin path|
        
        "wrong room"
        (self getGame getCurrentRoom getName = RoomFactory lockerRoom getName) ifFalse: [
            Transcript show: 'Where?'; cr.
            ^nil.
            ].

        "right room"
        pin := cmd copyFrom: 11.
        (pin = '852611') ifTrue: [
            Transcript show: 'The light on the lock blinks green, it buzzes and unlocks. Correct!'; cr.
            path := self getGame getAllRooms getLockerRoom getDirections at: 'north'.
            path setIsLocked: false.
        ] ifFalse: [
            Transcript show: 'The light on the lock blinks red. The provided code was incorrect.'; cr.
                ].
    ]


    handleUnlock: cmd [
        |query room path key validQuery compartment g|  
        room := self getGame getCurrentRoom.
        query := cmd copyFrom: 8 to: cmd size.
        validQuery := false.
        g := self getGame.

        "unlock the doors"
        (directions includes: query) ifTrue: [
            validQuery := true.
            (room hasPath: query) ifFalse: [
                Transcript show: 'There is no path in this direction'; cr.
                ^nil
            ].

            path := room getDirections at: query.
            path getIsLocked ifFalse: [Transcript show: 'Path is already unlocked'; cr. ^nil].
            key := path getOpenedBy.
            g getInventory do: [ :ie|
                (ie getItem getName = key getName) ifTrue: [
                    path setIsLocked: false.
                    "Only show the message if not unlocking the vent since it has a custom one"
                    (room getName = RoomFactory generatorRoom getName & query = 'east') ifFalse: [
                        Transcript show: 'Ok, unlocked.'; cr.
                        ].
                    ^nil
                ]
            ].

            Transcript show: 'You cannot unlock this. Perhaps you need some key?'; cr.
            ^nil.
        ].

        "unlock the compartment"
        (query = InteractableFactory compartment getName & g getCurrentRoom getName = RoomFactory lockerRoom getName) ifTrue: [
            validQuery := true.
            compartment := g getCurrentRoom getItemByName: InteractableFactory compartment getName.
            (g inventoryContains: compartment getOpenedBy getName) ifTrue: [
                compartment setIsLocked: false.
                Transcript show: 'Ok, unlocked.'; cr.
            ]
            ifFalse: [
                Transcript show: 'You cannot unlock this. Perhaps you need some key?'; cr.
            ].
        ].

        "Unlock the vent"
        (query = 'vent') ifTrue: [
            g getVentBlocked ifFalse: [
                Transcript show: 'It''s already unlocked.'; cr.
                ^nil.
            ] ifTrue: [
                validQuery := true.
                (g getCurrentRoom getName = RoomFactory generatorRoom getName & g inventoryContains: InteractableFactory crowbar getName) ifTrue: [
                    validQuery := true.
                    self printLines: #('You slide the crowbar between the vent door and its door frame'
                                'and push with a lot of force. The vent swings open!').
                    g setVentBlocked: false.
                    self handleUnlock: 'unlock east'.
                ] ifFalse: [
                    self printLines: #('The vent is closed shut and the door doesn''t seem to budge.'
                        'Maybe using some tool would help?').
                ].
            ].
        ].


        validQuery ifFalse: [Transcript show: 'I don''t see that here'; cr].
    ]
]

GameController new run.
