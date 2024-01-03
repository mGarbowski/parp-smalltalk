Object subclass: Interactable [
    | name description hint |

    Interactable class >> new [
        ^super new.
    ]

    getDescription [^ description]
    setDescription: value [description := value]

    getName [^ name]
    setName: value [name := value]

    getHint [^ hint]
    setHint: aHint [hint := aHint]
]