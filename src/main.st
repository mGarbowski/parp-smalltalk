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
        'A long time ago, in a galaxy far, far away...'
        ''
        'It is a period of civil war. Rebel'
        'spaceships, striking from a hidden'
        'base, have won their first victory'
        'against the evil Galactic Empire.'
        ''
        'During the battle, Rebel spies managed'
        'to steal secret plans to the Empire''s'
        'ultimate weapon, the Death Star, an'
        'armored space station with enough'
        'power to destroy an entire planet.'
        ''
        'Pursued by the Empire''s sinister agents,'
        'Princess Leia races home aboard her'
        'starship, custodian of the stolen plans'
        'that can save her people and restore'
        'freedom to the galaxy....'
        ''
    ).

    instructionsText := #(
        'Available commands are:'
        ''
        'instructions  -- to see these instructions.'
        'quit          -- to end the game and quit.'
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

            (cmd startsWith: 'hint ') ifTrue: [
                isUnknown := false.
                cmd = 'hint here'
                    ifTrue: [self handleHintHere]
                    ifFalse: [self handleHint: cmd]
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

    test [
        |rooms tmp|
        rooms := RoomFactory rooms.

        rooms do: [ :room |
            Transcript show: room getName; cr.
            room getDirections at: 'east' ifPresent: [ :path |
                Transcript show: 'is connected to the east with '.
                Transcript show: path getToRoom getName; cr; cr.
            ]
        ]

    ]

    handleLook [
        Transcript show: self getGame getCurrentRoom getDescription; cr
    ]

    handleHintHere [
        |room|
        room := self getGame getCurrentRoom.
        Transcript show: room getHint; cr.
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
]

GameController new run.
