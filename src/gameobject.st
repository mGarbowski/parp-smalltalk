
"Base game object with a name, hint and description that rooms and item classes inherit from"
Object subclass: GameObject [
    | name description hint |

    GameObject class >> new [
        ^super new.
    ]

    GameObject class >> name: aName description: aDescription hint: aHint [
        |i|
        i := super new.
        i setName: aName.
        i setDescription: aDescription.
        i setHint: aHint.
        ^i
    ]

    getDescription [^ description]
    setDescription: value [description := value]

    getName [^ name]
    setName: value [name := value]

    getHint [^ hint]
    setHint: aHint [hint := aHint]
]