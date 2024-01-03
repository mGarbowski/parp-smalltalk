Object subclass: Path [
    | toRoom isLocked openedBy |

    Path class >> new [
        ^super new.
    ]

    getToRoom [^toRoom]
    setToRoom: aRoom [toRoom := aRoom]

    getIsLocked [^isLocked]
    setIsLocked: locked [isLocked := locked]

    getOpenedBy [^openedBy]
    setOpenedBy: item [openedBy := item]
]