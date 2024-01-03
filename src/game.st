"Game class storing the game's state"
Object subclass: Game [
    |currentRoom allRooms inventory|

    Game class >> new [
        |g|
        g := super new.
        g setAllRooms: RoomFactory rooms.
        g setCurrentRoom: g getAllRooms first.
        g setInventory: OrderedCollection new.
        ^g
    ]

    getCurrentRoom [^currentRoom]
    setCurrentRoom: room [currentRoom := room]

    getAllRooms [^allRooms]
    setAllRooms: rooms [allRooms := rooms]

    getInventory [^inventory]
    setInventory: inv [inventory := inv]
]