Object subclass: ItemFactory [
    ItemFactory class >> lockerRoomKey [
        ^Item
            name: 'heavy key'
            description: 'heavy metal key, what does it open?'
            hint: 'use it to open the locked door'
    ]

    ItemFactory class >> coat [
        ^Item
            name: 'coat'
            description: 'The lab coat stirs a sense of familiarity. The nametag reads: "Dr. J. Sysy.", it triggers a cascade of hazy memories. As you run your fingers over the fabric, flashes of experiments and research echo in your mind. Memories start coming back to you, it is your coat!'
            hint: 'Take a good look at it, maybe you will find something useful'
    ]

    ItemFactory class >> crowbar [
        ^Item
            name: 'crowbar'
            description: 'A heavy, metal crowbar painted red, the best tool for brute-force solutions'
            hint: 'Use it to pry open the ventilation shaft'
    ]

    ItemFactory class >> powerCell [
        ^Item
            name: 'power cell'
            description: 'The power cell pulses with energy, illuminating the room. It may come in handy.'
            hint: 'It is a portable source of power'
    ]

    ItemFactory class >> labShoes [
        ^Item
            name: 'lab shoes'
            description: 'A sturdy pair of shoes, essential for work in hazardous environments, around chemicals. You can put them on.'
            hint: 'Use `put on` to put on the shoes'
    ]

    ItemFactory class >> smallKey [
        ^Item
            name: 'small key'
            description: 'A small key, does not match the size of the keyholes in any of the doors you have seen so far. It must open something smaller like a...'
            hint: 'Use it to unlock the locker compartment'
    ]
    
    ItemFactory class >> locker [
        |lockerItems|
        lockerItems := {self coat}.
        ^ Container
            name: 'locker'
            description: 'A locker for storing personal items. The locker reveals two compartments, in the upper part, a lab coat hangs neatly on a hanger. Below there is another compartment.'
            hint: 'Look what is inside'
            itemsInside: lockerItems.
    ]

    ItemFactory class >> toolChest [
        |toolChestItems|
        toolChestItems := {self toolChest, self crowbar}.
        ^ Container
            name: 'tool chest'
            description: 'Inside there is a crowbar and a power cell'
            hint: 'Wearing the shoes, you can cross the toxic puddle and reach into the tool chest'
            itemsInside: toolChestItems.
    ]

    ItemFactory class >> compartment [
        |compartmentItems|
        compartmentItems := {self labShoes}.
        ^ Container
            name: 'compartment'
            description: 'In the smaller compartment is pair of sturdy, lab shoes. These could probably come in handy!'
            hint: 'Perhaps you can use the contents of the compartment later?'
            itemsInside: compartmentItems.
    ]

        ItemFactory class >> controlPanel [
        ^ Interactable
            name: 'control panel'
            description: 'The central console stands prominently, adorned with an array of power control',
                'switches. Their sleek design and illuminated indicators add a touch of modernity',
                'to the room. Labels beside each switch hint at their specific functions. The',
                'control panel exudes an air of authority, silently overseeing the lab''s intricate',
                'systems from its place in the security room.',
                'One switch catches your eye - it''s the elevator power supply',
                'This is what you have been looking for!'
            hint: 'You can use it to `power on` something'
    ]

    ItemFactory class >> ventEntrance [
        ^ Interactable
            name: 'vent'
            description: 'A big, rectangular ventilation shaft large enough for a human to crawl inside'
            hint: 'You can `enter` the vent'
    ]

    ItemFactory class >> computer [
        ^ Interactable
            name: 'computer'
            description: 'On the desk, a computer sits dormant. Its screen is powered off, casting a',
                'dark reflection in the quiet room. The keyboard awaits your interaction,',
                'could its hard drives have some answers for you?'
            hint: 'You can use it as a decorative piece or `power on computer`. to make better use of it.'
    ]

    ItemFactory class >> generator [
        ^ Interactable
            name: 'generator'
            description: 'The emergency power generator looms with a single glowing cell within, flanked by two conspicuous empty slots,',
                'rendering the machine silent and incomplete, waiting for its missing components.',
                'In order to restore electricity in the lab, the two remaining cells have to be found.'
            hint: 'Use `power on generator` to power it on'
    ]

    ItemFactory class >> brokenDoor [
        ^ Interactable
            name: 'broken door'
            description: 'A massive door, ripped out of its hinges is laying on the floor next to the entrance it used to guard.'
            hint: 'Maybe taking a closer look at it will reveal something?'
    ]

    ItemFactory class >> elevator [
        ^ Interactable
            name: 'elevator'
            description: 'Approaching the elevator, you find it disabled, a security override in effect.',
                'A prominent display blinks with a warning, indicating that access is restricted',
                'and the elevator is currently non-operational. The usual hum of its machinery',
                'is replaced by an eerie silence. Looks like the security staff can turn it on/off during emergencies.'
            hint: 'To go inside use `enter elevator`'
    ]

    ItemFactory class >> desk [
        ^ Interactable
            name: 'desk'
            description: 'The desk in the room is simple yet functional. It holds a powered-off computer',
                'at its center. The smooth surface suggests a place for work or study, while',
                'the surrounding space remains uncluttered, you bend to see what''s underneath it',
                'There is a sticky note! It says "pass: rot13(XvetvfJnygre)"',
                'What''s rot13? The computer nerds from the lab wouldn''t just leave a password in plain text for everyone to see'
            hint: 'just google it'
    ]

    ItemFactory class >> keypad [
        ^ Interactable
            name: 'keypad'
            description: 'A modern keypad, mounted beside the security room door, stands as the gateway to the lab.',
                'It features a digital touchscreen with a numeric grid and softly backlit keys.',
                'To enter, you must input the correct 6-digit code.'
            hint: 'Use `enter keypad <code>` to enter a code',
                'Only 6 digits? That''s only like 999 999 options, you can just brute force it...',
                '...or look around for the code, it must be *somewhere*'
    ]

]