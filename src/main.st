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

            (cmd startsWith: 'unlock ') ifTrue: [
                isUnknown := false.
                self handleUnlock: cmd
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
        |itemName validItem roomInspectables|
        validItem := false.
        itemName := cmd copyFrom: 9.
        roomInspectables := self getGame getCurrentRoom getAllInteractables.

        roomInspectables do: [ :i|
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


    handleInventory [
        self printLines: self getGame listInventory
    ]

    handleUnlock: cmd [
        |query room path key|
        room := self getGame getCurrentRoom.
        query := cmd copyFrom: 8 to: cmd size.

        (directions includes: query) ifTrue: [
            (room hasPath: query) ifFalse: [
                Transcript show: 'There is no path in this direction'; cr.
                ^nil
            ].

            path := room getDirections at: query.
            path getIsLocked ifFalse: [Transcript show: 'Path is already unlocked'; cr. ^nil].
            key := path getOpenedBy.
            self getGame getInventory do: [ :ie|
                (ie getItem getName = key getName) ifTrue: [
                    path setIsLocked: false.
                    Transcript show: 'Ok'; cr.
                    ^nil
                ]
            ].

            Transcript show: 'You cannot open this'; cr.
            ^nil
        ]
    ]
]

GameController new run.
