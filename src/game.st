Object subclass: InventoryEntry [
    |item count|

    getItem [^item]
    setItem: anItem [item := anItem]
    getCount [^count]
    setCount: aCount [count := aCount]

    InventoryEntry class >> new [
        ^super new
    ]

    InventoryEntry class >> ofItem: anItem [
        |ie|
        ie := InventoryEntry new.
        ie setItem: anItem.
        ie setCount: 1.
        ^ie
    ]
]

"Game class storing the game's state"
Object subclass: Game [
    |currentRoom allRooms inventory generatorOn elevatorOn ventBlocked|

    Game class >> new [
        |g|
        g := super new.
        g setAllRooms: RoomFactory getRooms.
        g setCurrentRoom: g getAllRooms getLockerRoom.
        g setInventory: OrderedCollection new.
        g setGeneratorOn: false.
        g setElevatorOn: false.
        g setVentBlocked: true.
        ^g
    ]

    getCurrentRoom [^currentRoom]
    setCurrentRoom: room [currentRoom := room]

    getAllRooms [^allRooms]
    setAllRooms: rooms [allRooms := rooms]

    getInventory [^inventory]
    setInventory: inv [inventory := inv]

    getGeneratorOn [^generatorOn]
    setGeneratorOn: bool [generatorOn := bool]
    
    getElevatorOn [^elevatorOn]
    setElevatorOn: bool [elevatorOn := bool]

    getVentBlocked [^ventBlocked]
    setVentBlocked: bool [ventBlocked := bool]

    addItem: item [
        |invEntry count|
        invEntry := nil.
        self getInventory do: [:ie |
            (ie getItem getName = item getName) ifTrue: [invEntry := ie]
        ].

        invEntry = nil
            ifTrue: [
                invEntry := InventoryEntry ofItem: item.
                self getInventory add: invEntry
            ]
            ifFalse: [
                count := invEntry getCount.
                count := count + 1.
                invEntry setCount: count
            ]
    ]

    listInventory [
        |lines line|
        lines := OrderedCollection new.
        lines add: 'Inventory:'.

        self getInventory do: [:ie |
            lines add: '- ', ie getItem getName, ' x', ie getCount printString
        ].

        ^lines
    ]
]

