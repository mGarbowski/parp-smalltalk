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
    |currentRoom allRooms inventory generatorOn elevatorOn ventBlocked coatKeyTaken brokenDoorKeyTaken labShoesOn|

    Game class >> new [
        |g|
        g := super new.
        g setAllRooms: RoomFactory getRooms.
        g setCurrentRoom: g getAllRooms getLockerRoom.
        g setInventory: OrderedCollection new.
        g setGeneratorOn: false.
        g setElevatorOn: false.
        g setVentBlocked: true.
        g setCoatKeyTaken: false.
        g setBrokenDoorKeyTaken: false.
        g setLabShoesOn: false.
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

    getCoatKeyTaken [^coatKeyTaken]
    setCoatKeyTaken: bool [coatKeyTaken := bool]

    getBrokenDoorKeyTaken [^brokenDoorKeyTaken]
    setBrokenDoorKeyTaken: bool [brokenDoorKeyTaken := bool]

    getLabShoesOn [^labShoesOn]
    setLabShoesOn: bool [labShoesOn := bool]

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

    removeItem: itemName [
        |entry|
        entry := self getEntryOrNil: itemName.
        inventory identityRemove: entry.
    ]

    listInventory [
        |lines line|
        lines := OrderedCollection new.
        lines add: 'Inventory:'.

        self getInventory do: [:ie |
            lines add: '- ', ie getItem getName, ' x', ie getCount printString
        ].

        (lines size = 1) ifFalse: [^lines] ifTrue: [^#('Your inventory is empty')].
    ]

    inventoryContains: itemName [
        ^(self getEntryOrNil: itemName) notNil.
    ]

    getEntryOrNil: itemName [
        |entry|
        entry := nil.
        self getInventory do: [:ie |
            (ie getItem getName = itemName) ifTrue: [entry := ie].
        ].
        ^entry.
    ]

    getInventoryItems [
        |items|
        items := OrderedCollection new.
        self getInventory do: [:ie |
            items add: ie getItem.
        ].
        ^items.
    ]
]

