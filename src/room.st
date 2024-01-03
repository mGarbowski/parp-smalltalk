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

    "Getters and setters"
    getItems [^ items]
    setItems: someItems [items := someItems]

    getInteractables [^ interactables]
    setInteractables: someInteractables [interactables := someInteractables]

    getDirections [^ directions]
    setDirections: someDirections [directions := someDirections]
]