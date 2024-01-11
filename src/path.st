Object subclass: Path [
    | toRoom isLocked openedBy |

    Path class >> new [
        ^super new.
    ]

    Path class >> to: aRoom locked: isLocked key: aKey [
        |p|
        p := self new.
        p setToRoom: aRoom.
        p setIsLocked: isLocked.
        p setOpenedBy: aKey.
        ^p
    ]

    getToRoom [^toRoom]
    setToRoom: aRoom [toRoom := aRoom]

    getIsLocked [^isLocked]
    setIsLocked: locked [isLocked := locked]

    getOpenedBy [^openedBy]
    setOpenedBy: item [openedBy := item]
]