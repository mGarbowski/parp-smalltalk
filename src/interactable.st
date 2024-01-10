Object subclass: Interactable [
    | name description hint |

    Interactable class >> new [
        ^super new.
    ]

    Interactable class >> name: aName description: aDescription hint: aHint [
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