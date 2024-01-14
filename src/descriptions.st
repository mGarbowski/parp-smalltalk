
"Class providing descriptions which change during gameplay"
Object subclass: DescriptionFactory [
    DescriptionFactory class >> elevatorOn [
        ^#(
         'The elevator is operational and stands ready, a beacon of potential escape.'
         'Its doors slightly ajar, inviting you to step inside and make your way to freedom.'
        )
    ]
        DescriptionFactory class >> generatorFull [
        ^#('With the power cells in place, the generator hums to life, its core glowing vibrantly.'
            'It''s ready to go—just a switch away from unleashing its energy.')
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
]


"Same thing, but with hints"
Object subclass: HintFactory [
    HintFactory class >> ventUnlocked [
        ^#('You can `enter` the vent')
    ]
]