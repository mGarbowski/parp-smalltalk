Object subclass: ItemFactory [
    ItemFactory class >> lockerRoomKey [
        ^Interactable
            name: 'locker room key'
            description: 'heavy metal key, what does it open?'
            hint: 'use it to open the locked door'
    ]

    ItemFactory class >> coat [
        ^Interactable
            name: 'coat'
            description: 'The lab coat stirs a sense of familiarity. The nametag reads: "Dr. J. Sysy.", it triggers a cascade of hazy memories. As you run your fingers over the fabric, flashes of experiments and research echo in your mind. Memories start coming back to you, it is your coat!'
            hint: 'Take a good look at it, maybe you will find something useful'
    ]

    ItemFactory class >> crowbar [
        ^Interactable
            name: 'crowbar'
            description: 'A heavy, metal crowbar painted red, the best tool for brute-force solutions'
            hint: 'Use it to pry open the ventilation shaft'
    ]

    ItemFactory class >> powerCell [
        ^Interactable
            name: 'power cell'
            description: 'The power cell pulses with energy, illuminating the room. It may come in handy.'
            hint: 'It is a portable source of power'
    ]

    ItemFactory class >> labShoes [
        ^Interactable
            name: 'lab shoes'
            description: 'A sturdy pair of shoes, essential for work in hazardous environments, around chemicals. You can put them on.'
            hint: 'Use `put on` to put on the shoes'
    ]

    ItemFactory class >> smallKey [
        ^Interactable
            name: 'small key'
            description: 'A small key, does not match the size of the keyholes in any of the doors you have seen so far. It must open something smaller like a...'
            hint: 'Use it to unlock the locker compartment'
    ]
]