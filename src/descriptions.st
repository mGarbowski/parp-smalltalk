
"Class providing descriptions which change during gameplay"
Object subclass: DescriptionFactory [
    DescriptionFactory class >> elevatorOn [
        ^#(
         'The elevator is operational and stands ready, a beacon of potential escape.'
         'Its doors slightly ajar, inviting you to step inside and make your way to freedom.'
        )
    ]
        DescriptionFactory class >> generatorOn [
        ^#('The generator is fully functional, providing power for the entire laboratory.'
            'Perhaps powering it on has provided you with some new possibilities?')
    ]
        DescriptionFactory class >> coatKeyTaken [
        ^#('The lab coat stirs a sense of familiarity. The nametag reads: "Dr. J. Sysy". It is your coat!')
    ]
        DescriptionFactory class >> brokenDoorKeyTaken [
        ^#('A massive door, ripped out of its hinges is laying on the floor next to the entrance it used to guard.')
    ]
        DescriptionFactory class >> toolChestWearingShoes [
        ^#('Inside there is a crowbar and a power cell. These could come in handy!')
    ]
        DescriptionFactory class >> exitRoomNoPowerCell [
        ^#('As you''re crawling out of the ventilation shaft, you notice an elevator.'
            'Finally, a way out of this maze!')
    ]
        DescriptionFactory class >> compartmentUnlocked [
        ^#('In the smaller compartment is pair of sturdy, lab shoes. These could probably come in handy!')
    ]
]


"Same thing, but with hints"
Object subclass: HintFactory [
    HintFactory class >> ventUnlocked [
        ^#('You can now enter the ventilation shaft by going in its direction')
    ]

    HintFactory class >> experimentRoomShoesOn [
        ^#('With the shoes you''re wearing, you can interact with the chest. You can go east.')
    ]
]